package <?= $_->{module} ?>::Web::Views;
# mix-in module

use strict;
use warnings;

use Text::Xslate;
use Encode;
use URI::Escape;
use JSON::XS;
use parent qw(Exporter);

use <?= $_->{module} ?>;

our @EXPORT = qw(
    redirect
    html
    json
    error
);

my $base;

my $XSLATE = Text::Xslate->new(
    syntax => 'TTerse',
    module => [
        'Text::Xslate::Bridge::TT2Like'
    ],
    path   => [
        config->root->subdir('templates')
    ],
    cache_dir => '/tmp/<?= $_->{myname} ?>',
    cache     => 1,
    function  => {
        uri_for => sub {
            my ( $path, $args ) = @_;
            my $uri = $base->clone;
            $path =~ s|^/||;
            $uri->path( $uri->path . $path );
            $uri->query_form(@$args) if $args;
            $uri;
        },

        format_datetime => sub {
            my ($datetime, $format) = @_;
            $datetime->strftime($format);
        }
    },
);

sub redirect {
    my ($self, $location, $status) = @_;
    $self->res->redirect($location, $status);
    $self->res->finalize;
}

sub html {
    my ($self, $name, $vars) = @_;
    $vars ||= {};
    $vars->{r} = $self;

    $base = $self->req->base;
    my $content = $XSLATE->render($name, $vars);

    $self->res->content_type('text/html; charset=utf8');
    $self->res->content(encode_utf8 $content);
    $self->res->finalize;
}

sub json {
    my ($self, $vars) = @_;
    my $body = JSON::XS->new->ascii(1)->encode($vars);
    $self->res->content_type('application/json; charset=utf8');
    $self->res->content($body);
    $self->res->finalize;
}

sub error {
    my ($self, $code, $message) = @_;
    $self->res->code($code);
    $self->res->content_type('text/plain');
    $self->res->content($message || $code);
    $self->res->finalize;
}

1;
__END__



