#!/bin/sh
exec 2>&1
cd /home/httpd/apps/<?= $_->{module} ?>/releases || exit 1
export PERL5LIB=/home/httpd/apps/lib/lib/perl5:/home/httpd/apps/lib/lib/perl5/x86_64-linux-thread-multi
export PLACK_ENV=production
export SERVER_STATUS_CLASS=httpd

exec setuidgid apache \
    /usr/local/bin/start_server --port=10204 \
    /home/httpd/apps/lib/bin/twiggy \
    script/app.psgi

