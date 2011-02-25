package <?= $_->{module} ?>::Web::Request;

use strict;
use warnings;
use parent qw(Plack::Request);
use Hash::MultiValue;
use Encode;

sub params {
    $_[0]->parameters
}

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

    $self->{_path_parameters};
}

sub string_param {
    my ($self, $key) = @_;
    decode_utf8($self->param($key));
}

sub number_param {
    my ($self, $key) = @_;
    my $val = $self->param($key) || "";
    if ($val =~ /^[\d.]+$/) {
        $val + 0;
    } else {
        undef;
    }
}

1;
__END__



