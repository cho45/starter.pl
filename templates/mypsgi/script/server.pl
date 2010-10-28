#!/usr/bin/env perl
use strict;
use warnings;

use FindBin;
use Path::Class;
use lib glob 'modules/*/lib';
use lib 'lib';

use Getopt::Long;
use Pod::Usage;
use Plack::Runner;
use UNIVERSAL::require;

my $help    = 0;
my $port    = 5000;
my $fast    = 0;
my $verbose = 0;
my $env;
my $reboot;
my $reboot_port;
my $kyt_prof = 1;

GetOptions(
    'help|?'    => \$help,
    'port|p=s'  => \$port,
    'env|e=s'   => \$env,
    'enable-kyt-prof' => \$kyt_prof,
);

pod2usage(1) if $help;

if ($kyt_prof) {
    if (Devel::KYTProf->require) {
        Devel::KYTProf->namespace_regex('<?= $_->{module} ?>');
        Devel::KYTProf->ignore_class_regex(qr{
            <?= $_->{module} ?>::Memcached
        }x);
    }
}

my $runner = Plack::Runner->new;
$runner->parse_options(
    '--server', 'HTTP::Server::Simple',
    '--port', $port || 5000,
    '--Reload', join(',', glob('modules/*/lib'), 'lib'),
    '--app', 'script/app.psgi',
);
$runner->run;

1;
