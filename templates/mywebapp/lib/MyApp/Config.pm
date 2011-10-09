package MyApp::Config;

use utf8;
use strict;
use warnings;
use Config::ENV 'PLACK_ENV', export => 'config';
use Path::Class;
use constant root => dir(".")->absolute;

common +{
	appname => 'myapp',
};

config development => {
};

config staging => {
};

config production => {
};

1;
__END__
