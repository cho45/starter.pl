package <?= $_->{module} ?>::Web::Context;

use strict;
use warnings;
use Plack::Session;
use <?= $_->{module} ?>;
use <?= $_->{module} ?>::Web::Request;
use <?= $_->{module} ?>::Web::Response;
use <?= $_->{module} ?>::Web::Views; # define some methods
use <?= $_->{module} ?>::Browser;

sub new {
    my ($class, $env) = @_;

    my $req = <?= $_->{module} ?>::Web::Request->new($env);
    my $res = <?= $_->{module} ?>::Web::Response->new(200);
    $res->content_type("text/html");

    bless {
        req => $req,
        res => $res,
    }, $class;
}

sub req { $_[0]->{req} }
sub res { $_[0]->{res} }
sub session {
    my ($self) = @_;
    $self->{_session} ||= Plack::Session->new($self->req->env);
}

sub browser {
    my ($self) = @_;
    $self->{_browser} ||= <?= $_->{module} ?>::Browser->new($self->req->user_agent);
}

sub in_post {
    my ($self, %opts) = @_;
    if ($self->req->method eq 'POST') {
        if ($self->require_tokens) {
            return 1;
        }
        if (defined $opts{require_tokens} && !$opts{require_tokens}) {
            return 1;
        }
    }
    return 0;
}

sub require_tokens {
    my ($self) = @_;
    $self->user or return;
    ($self->user->rkm eq $self->req->param('rkm')) or return;
    ($self->user->rkc eq $self->req->param('rkc')) or return;
    1;
}

sub log {
    my ($self, $format, @args) = @_;
    my $text = sprintf($format, @args);
    $text =~ /\n$/ or $text = "$text\n";
    $self->req->env->{'psgi.errors'}->print($text);
}

sub version {
    my $hash = config->root->file('.git/refs/heads/master')->slurp;
    chomp $hash;
    substr($hash, 0, 32);
}

1;
__END__



