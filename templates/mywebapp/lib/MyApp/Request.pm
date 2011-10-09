package MyApp::Request;

use utf8;
use strict;
use warnings;
use parent qw(Plack::Request);
use Hash::MultiValue;

sub parameters {
    my $self = shift;

    $self->env->{'plack.request.merged'} ||= do {
        my $query = $self->query_parameters;
        my $body  = $self->body_parameters;
        my $path  = $self->path_parameters;
        Hash::MultiValue->new($path->flatten, $query->flatten, $body->flatten);
    };
}

sub path_parameters {
    my $self = shift;

    if (@_ > 1) {
        $self->{_path_parameters} = Hash::MultiValue->new(@_);
    }

    $self->{_path_parameters} ||= Hash::MultiValue->new;
}


1;
