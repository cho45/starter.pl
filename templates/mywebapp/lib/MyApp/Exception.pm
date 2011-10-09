package MyApp::Exception;

use utf8;
use strict;
use warnings;

sub throw {
    my ($class, %opts) = @_;
    die $class->new(%opts);
}

sub new {
    my ($class, %opts) = @_;
    bless \%opts, $class;
}


1;
