package MyApp::Views;

use utf8;
use strict;
use warnings;

use Exporter::Lite;
our @EXPORT = qw(html json redirect render email);

use Text::Xslate qw(mark_raw);
use JSON;
use Encode;
use HTML::Trim;

use MyApp::Config;

my $XSLATE = Text::Xslate->new(
	syntax   => 'TTerse',
	path     => [ config->root->subdir('templates') ],
	module   => [ 'Text::Xslate::Bridge::TT2Like' ],
	cache    => 1,
	function => {
		trim => sub {
			my ($len) = @_;

			sub {
				HTML::Trim::vtrim(shift || '', $len, '…');
			}
		},
	},
);

sub render {
	my ($r, $name, $vars) = @_;
	$vars = {
		%{ $r->stash },
		%{ $vars || {} },
		r => $r,
	};

	my $content = $XSLATE->render($name, $vars);
}

sub html {
	my ($r, $name, $vars) = @_;
	$r->res->content_type('text/html; charset=utf-8');
	$r->res->content(encode_utf8 $r->render($name, $vars));
}

sub json {
	my ($r, $vars, %opts) = @_;
	my $body = JSON::XS->new->ascii(1)->encode($vars);
	$r->res->content_type('application/json; charset=utf-8');
	$r->res->content($body);
}

1;
