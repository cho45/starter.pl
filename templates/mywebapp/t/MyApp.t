use strict;
use warnings;
use Test::More;
use Test::Name::FromLine;

use HTTP::Request::Common;
use HTTP::Message::PSGI;
use Router::Simple;

BEGIN { use_ok( 'MyApp' ); }

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

done_testing;
