package <?= $_->{module} ?>::Config;

use strict;
use warnings;

use Path::Class;
use Config::Tiny;

my $root   = dir('.')->absolute;
my $file   = $root->file("app.conf");
my $config = do "$file";
unless ($config) {
	die "Couldn't parse $file: $@" if $@;
	die "Couldn't do $file: $!" unless defined $config;
	die "Couldn't run $file: $!" unless $config;
}

my $instance;

sub instance {
	my ($class) = @_;
	bless $config, $class;
}

sub root {
	$root;
}



1;
__END__



