package <?= $_->{module} ?>;

use strict;
use warnings;
use utf8;

use Path::Class;
use URI;

use <?= $_->{module} ?>::Router;
use <?= $_->{module} ?>::Request;
use <?= $_->{module} ?>::View;

use <?= $_->{module} ?>::Model;
use <?= $_->{module} ?>::Config;
use <?= $_->{module} ?>::Model::Row::Entry;
use <?= $_->{module} ?>::Empty;


route '/', action => sub {
	my ($r) = @_;
	$r->html('index.html');
};

route '/:id', id => qr/\d+/, action => sub {
	my ($r) = @_;
};

route '/', method => GET,  action => sub { };
route '/', method => POST, action => sub { };

sub uri_for {
	my ($r, $path, $args) = @_;
	$path ||= "";
	my $uri = $r->req->base;
	$uri->path(($r->config->{_}->{root} || '') . $path);
	$uri->query_form(@$args) if $args;
	$uri;
}

sub abs_uri {
	my ($r, $path, $args) = @_;
	$path ||= "";
	my $uri = URI->new($r->config->{_}->{base});
	$uri->path(($r->config->{_}->{root} || '') . $path);
	$uri->query_form(@$args) if $args;
	$uri;
}



sub run {
	my ($env) = @_;
	my $req = <?= $_->{module} ?>::Request->new($env);
	my $res = $req->new_response;
	my $niro = <?= $_->{module} ?>->new(
		req => $req,
		res => $res,
	);
	$niro->_run;
}

sub new {
	my ($class, %opts) = @_;
	bless {
		%opts
	}, $class;
}

sub config {
	<?= $_->{module} ?>::Config->instance;
}

sub _run {
	my ($self) = @_;
	<?= $_->{module} ?>::Router->dispatch($self);
	$self->res->finalize;
}

sub req { $_[0]->{req} }
sub res { $_[0]->{res} }
sub log {
	my ($class, $format, @rest) = @_;
	print STDERR sprintf($format, @rest) . "\n";
}

sub stash {
	my ($self, %params) = @_;
	if (%params) {
		$self->{stash} = {
			%{ $self->{stash} || {} },
			%params
		};
	}
	$self->{stash};
}

sub error {
	my ($self, %opts) = @_;
	$self->res->status($opts{code} || 500);
	$self->res->body($opts{message} || $opts{code} || 500);
}

1;
__END__



