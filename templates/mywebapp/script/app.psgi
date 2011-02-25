# vim:ft=perl:
use strict;
use warnings;
use lib '/home/httpd/apps/lib/lib/perl5';
use lib glob 'modules/*/lib';
use lib 'lib';

use UNIVERSAL::require;
use Path::Class;
use Plack::Builder;
use <?= $_->{module} ?>::Web;
use Plack::Session::Store::MongoDB;
use File::Spec;
use Cache::LRU;
use JavaScript::Squish;

my $root = file(__FILE__)->parent->parent;

builder {
    enable_if { $_[0]->{PATH_INFO} =~ m{^/admin} }  "Auth::Basic", authenticator => sub {
        my ($user, $pass) = @_;
        return $user eq 'admin' && $pass eq 'pass';
    };

    enable "StaticShared",
        cache => Cache::LRU->new(size => 10),
        base  => './static/',
        binds => [
            {
                prefix       => '/.shared.js',
                content_type => 'text/javascript; charset=utf8',
                filter => sub {
                    my $c = JavaScript::Squish->new;
                    $c->data($_);
                    $c->remove_comments( exceptions => [ qr/copyright/i ] );
                    $c->replace_white_space;
                    $c->remove_blank_lines;
                    my $new = $c->data;
                }
            },
            {
                prefix       => '/.shared.css',
                content_type => 'text/css; charset=utf8',
            }
        ],
        verifier => sub {
            my ($version, $prefix) = @_;
            1;
        };

    enable "Plack::Middleware::Static",
        path => qr{^/(images|js|css)/},
        root => $root->subdir('static');

    enable "Plack::Middleware::ReverseProxy";
    enable 'Session';

    \&<?= $_->{module} ?>::Web::run;
};


