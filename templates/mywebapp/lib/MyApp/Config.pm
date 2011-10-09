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

config development => do {
	my $file   = root->file("app.conf-sample");
	my $config = do "$file";
	unless ($config) {
		die "Couldn't parse $file: $@" if $@;
		die "Couldn't do $file: $!" unless defined $config;
		die "Couldn't run $file: $!" unless $config;
	}
	$config;
};


config staging => {
	parent('development'),
};

config production => {
	parent('development'),
};

1;
__END__
