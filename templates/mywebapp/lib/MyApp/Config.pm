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
};

config staging => {
	parent('development'),
};

config production => {
	parent('development'),
};

1;
__END__
