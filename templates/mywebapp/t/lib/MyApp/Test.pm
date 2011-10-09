package MyApp::Test;

use utf8;
use strict;
use warnings;

use Exporter::Lite;
use Plack::Util;
use Test::More;
use Test::WWW::Mechanize::PSGI;

use MyApp;

our @EXPORT = qw(
	mechanize
);

no warnings 'redefine';
sub import {
	my $class = caller(0);
	no warnings 'redefine';
	no strict 'refs';

	*{"$class\::subtest"} = sub {
		my ($name, $subtests) = @_;
		note "\nsubtest $name\n\n";
		goto &$subtests;
	};

	goto &Exporter::Lite::import;
};

sub mechanize {
	my $app  = Plack::Util::load_psgi(config->root->file("script/app.psgi"));
	my $mech = Test::WWW::Mechanize::PSGI->new(app => $app);
	$mech;
};

1;
__END__
