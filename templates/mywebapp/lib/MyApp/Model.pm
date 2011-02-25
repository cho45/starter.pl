package MyApp::Model;

use strict;
use warnings;
use parent qw(Teng);

sub find {
    my $self = shift;
    $self->select(@_)->[0];
}

sub select {
    my ($self, $sql, $hash, $name) = @_;
    unless ($name) {
        ($name) = ($sql =~ /FROM\s+([^\s]+)/i)
    }
    [ $self->search_named($sql, $hash || {}, $name) ];
}

1;
__END__



