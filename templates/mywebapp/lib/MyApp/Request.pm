package MyApp::Request;

use utf8;
use strict;
use warnings;
use parent qw(Plack::Request);
use Hash::MultiValue;
use JSON;
use Encode;

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

sub number_param {
	my ($self, $key, $limit) = @_;
	$limit ||= 'inf';

	my $val = $self->param($key) // "";
	if ($val =~ /^\d+(.\d+)?$/) {
		my $ret = $val + 0;
		if ($ret <= $limit) {
			$ret;
		} else {
			$limit;
		}
	} else {
		undef;
	}
}

sub string_param {
	my ($self, $key, $limit) = @_;
	$limit ||= 'inf';

	my $val = decode_utf8 $self->param($key) // "";
	length $val > $limit ? substr($val, 0, $limit) : $val;
}

sub json_param {
	my ($self, $key) = @_;
	my $val = eval { decode_json $self->param($key) } || undef;
}

sub if_none_match {
	my ($self, $etag) = @_;
	my $match = $self->header('If-None-Match') || '';
	$match ne $etag;
}

1;
