# vim:ft=perl:
use strict;
use warnings;
use lib 'lib';
use lib glob 'modules/*/lib';

use UNIVERSAL::require;
use Path::Class;
use File::Spec;
use Data::MessagePack;

use Plack::Builder;
use Plack::Session::State::Cookie;
use Plack::Session::Store::File;

my $MessagePack = Data::MessagePack->new;
$MessagePack->canonical;

use MyApp;

builder {
	enable "Plack::Middleware::Static",
		path => qr{^/(images|js|css)/},
		root => config->root->subdir('static');

	enable "Plack::Middleware::ReverseProxy";
	enable "Plack::Middleware::Session",
		state => Plack::Session::State::Cookie->new(
			session_key => 's',
			expires => undef,
		),
		store => Plack::Session::Store::File->new(
			dir          => config->root->subdir('session'),
			serializer   => sub {
				my ($session, $file) = @_;
				my $fh = file($file)->openw;
				print $fh $MessagePack->pack($session);
				close $fh;
			},
			deserializer => sub {
				my ($file) = @_;
				eval {
					$MessagePack->unpack(scalar file($file)->slurp)
				} || +{}
			},
		);

	sub {
		MyApp->new(shift)->run->res->finalize;
	};
};


