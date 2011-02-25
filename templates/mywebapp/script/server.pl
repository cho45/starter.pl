#!/usr/bin/env perl

use strict;
use warnings;

use lib glob 'modules/*/lib';
use lib 'lib';
use Plack::Runner;

my $runner = Plack::Runner->new;
$runner->parse_options(
	'--server', 'HTTP::Server::Simple',
	'--port', 3000,
	'--Reload', join(',', glob('modules/*/lib'), 'lib'),
	'--loader', 'Shotgun',
	'--app', 'script/app.psgi',
	@ARGV,
);
$runner->run;

