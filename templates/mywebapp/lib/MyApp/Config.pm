package MyApp::Config;

use utf8;
use strict;
use warnings;
use Config::ENV 'PLACK_ENV', export => 'config';
use Path::Class;
use constant root => dir(".")->absolute;

common +{
	appname => 'myapp',
	load("app.conf-sample"),
};

config development => {
	db => root->file('db/development.db'),
};

config production => {
	db => root->file('db/deployment.db'),
};

1;
__END__
