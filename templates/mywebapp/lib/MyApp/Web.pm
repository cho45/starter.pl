package <?= $_->{module} ?>::Web;

use strict;
use warnings;

use Router::Simple;
use <?= $_->{module} ?>;
use <?= $_->{module} ?>::Web::Context;

use constant SERVER_TIMEOUT => 30;

sub route ($$);
route '/' => {
	action => sub {
		my ($r) = @_;
		$r->html("index.html");
	}
};

BEGIN {
	my $router = Router::Simple->new;
	sub route ($$) { $router->connect(@_) };

	sub run {
		my ($env) = @_;
		if ( my $handler = $router->match($env) ) {
			my $c = <?= $_->{module} ?>::Web::Context->new($env);
			$c->req->path_parameters(%$handler);
			$handler->{action}->($c);
		} else {
			[ 404, [ 'Content-Type' => 'text/html' ], ['Not Found'] ];
		}
	}

};


1;
__END__



