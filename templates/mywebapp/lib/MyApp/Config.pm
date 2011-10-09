package MyApp::Config;

use utf8;
use strict;
use warnings;
use Config::ENV 'PLACK_ENV', export => 'config';

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
