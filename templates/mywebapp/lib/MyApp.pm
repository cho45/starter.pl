package MyApp;

use strict;
use warnings;

use MyApp::Base;
use parent qw(MyApp::Base);

our @EXPORT = qw(config);

route "/" => sub {
	$_->res->content('Hello, World!');
};

1;
