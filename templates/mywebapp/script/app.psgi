# vim:ft=perl:
use strict;
use warnings;
use lib 'lib';
use lib glob 'modules/*/lib';

use UNIVERSAL::require;
use Path::Class;
use Plack::Builder;
use File::Spec;

use MyApp;

builder {
	enable "Plack::Middleware::Static",
		path => qr{^/(images|js|css)/},
		root => config->root->subdir('static');

	enable "Plack::Middleware::ReverseProxy";
	enable "Plack::Middleware::Session";

	sub {
		MyApp->new(shift)->run->res->finalize;
	};
};


