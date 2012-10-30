use utf8;
use strict;
use warnings;
use lib 't/lib';
use Test::More;
use Test::Name::FromLine;

use HTTP::Request::Common;
use HTTP::Message::PSGI;
use Router::Simple;
use URI::Escape;

BEGIN { use_ok( 'MyApp' ); }

use MyApp::Test;
use MyApp::Request;

subtest base => sub {
	my $app = MyApp->new(GET('/')->to_psgi);
	isa_ok $app->req, "Plack::Request";
	isa_ok $app->res, "Plack::Response";
};

subtest path_parameters => sub {
	local $MyApp::Base::router = Router::Simple->new;
	MyApp::route('/:foo/:bar' => sub {
		my ($r) = @_;
		is $r->req->path_parameters->{foo}, 'hoge';
		is $r->req->path_parameters->{bar}, 'fuga';
		is $r->req->param('foo'), 'qqq';
		is $r->req->param('bar'), 'fuga';
	});
	my $r = MyApp->new(GET('/hoge/fuga?foo=qqq')->to_psgi)->run;
};

subtest xframeoptions => sub {
	local $MyApp::Base::router = Router::Simple->new;

	MyApp::route('/' => sub {
		my ($r) = @_;
		$r->res->content('foobar');
	});

	MyApp::route('/sameorigin' => sub {
		my ($r) = @_;
		$r->res->header('X-Frame-Options' => 'SAMEORIGIN');
	});

	MyApp::route('/no' => sub {
		my ($r) = @_;
		$r->res->headers->remove_header('X-Frame-Options');
	});

	{
		my $r = MyApp->new(GET('/')->to_psgi)->run;
		is $r->res->header('X-Frame-Options'), 'DENY';
	};

	{
		my $r = MyApp->new(GET('/sameorigin')->to_psgi)->run;
		is $r->res->header('X-Frame-Options'), 'SAMEORIGIN';
	};

	{
		my $r = MyApp->new(GET('/no')->to_psgi)->run;
		is $r->res->header('X-Frame-Options'), undef;
	};
};

subtest default => sub {
	my $mech = mechanize();
	$mech->get_ok("/");
};

subtest number_param => sub {
	is +MyApp::Request->new(GET('/?a=1')->to_psgi)->number_param('a'), 1;
	is +MyApp::Request->new(GET('/?a=1&a=2')->to_psgi)->number_param('a'), 2;
	is +MyApp::Request->new(GET('/?a=1.5')->to_psgi)->number_param('a'), 1.5;
	is +MyApp::Request->new(GET('/?a=1.5.5')->to_psgi)->number_param('a'), undef;
	is +MyApp::Request->new(GET('/?a=one')->to_psgi)->number_param('a'), undef;

	is +MyApp::Request->new(GET('/?a=3')->to_psgi)->number_param('a', 2), 2;
	is +MyApp::Request->new(GET('/?a=3')->to_psgi)->number_param('a', 3), 3;
	is +MyApp::Request->new(GET('/?a=3')->to_psgi)->number_param('a', 4), 3;
};

subtest string_param => sub {
	is +MyApp::Request->new(GET('/?a=1')->to_psgi)->string_param('a'), '1';
	is +MyApp::Request->new(GET('/?a=1&a=2')->to_psgi)->string_param('a'), '2';
	is +MyApp::Request->new(GET('/?a=1.5')->to_psgi)->string_param('a'), '1.5';
	is +MyApp::Request->new(GET('/?a=one')->to_psgi)->string_param('a'), 'one';
	is +MyApp::Request->new(GET('/?a=あ')->to_psgi)->string_param('a'), 'あ';
	ok utf8::is_utf8 +MyApp::Request->new(GET('/?a=あ')->to_psgi)->string_param('a');

	is +MyApp::Request->new(GET('/?a=1234567890')->to_psgi)->string_param('a', 5), '12345';
	is +MyApp::Request->new(GET('/?a=あいうえお')->to_psgi)->string_param('a', 3), 'あいう';
};

subtest json_param => sub {
	is +MyApp::Request->new(GET('/?a=xxx')->to_psgi)->json_param('a'), undef;
	is_deeply +MyApp::Request->new(GET('/?a=[1]')->to_psgi)->json_param('a'), [1];
	is_deeply +MyApp::Request->new(GET('/?a={"foo":1}')->to_psgi)->json_param('a'), { foo => 1 };
};

subtest if_none_match => sub {
	ok +MyApp::Request->new(GET('/', 'If-None-Match' => 'aaa')->to_psgi)->if_none_match('');
	ok !+MyApp::Request->new(GET('/', 'If-None-Match' => 'aaa')->to_psgi)->if_none_match('aaa');
	ok +MyApp::Request->new(GET('/')->to_psgi)->if_none_match('aaa');
};

done_testing;
