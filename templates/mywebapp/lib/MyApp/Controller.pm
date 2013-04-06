package MyApp::Controller;

use utf8;
use strict;
use warnings;

use Attribute::Handlers;

my $attributes = {};
sub attributes {
	my ($class, $sub) = @_;
	$attributes->{$sub};
}

sub csrf_check : ATTR(CODE, BEGIN) {
	my ($package, $symbol, $referent, $attr, $data, $phase) = @_;
	$attributes->{$referent}->{$attr} = $data;
}



1;
__END__
