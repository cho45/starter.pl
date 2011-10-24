package MyApp;

use strict;
use warnings;

use MyApp::Base;
use parent qw(MyApp::Base);

our @EXPORT = qw(config throw);

route "/" => sub {
	$_->res->content('Hello, World!');
};

1;
