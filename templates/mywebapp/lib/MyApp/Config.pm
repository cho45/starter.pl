package <?= $_->{module} ?>::Config;
# PRIMITIVE CONFIG CLASS
# YOU MUST NOT USE ANY MORE MODULES
# Seealso: Init.pm
use strict;
use warnings;
use Path::Class;
use URI;
use parent 'Exporter::Lite';
our @EXPORT = qw(config);

my $config = +{
    default => {
    },

    staging => {
    },

    production => {
    },

    test => {
        test => 1,
    },
};

my $root = file(__FILE__)->parent->parent->parent->parent;
sub root () { $root }

my $instance;
sub config {
    $instance ||= do {
        my $env = $ENV{RIDGE_ENV} || 'default';
        my $ret = +{
            %{ $config->{default} || {} },
            %{ $config->{$env} || {}    },
        };

        bless +{ env => $env, hash => $ret }, __PACKAGE__; # DO NOT EXTEND THIS CLASS;
    }
}

sub env {
    my ($self) = @_;
    $self->{env};
}

sub param {
    my ($self, $name) = @_;
    $self->{hash}->{$name};
}


1;
__END__



