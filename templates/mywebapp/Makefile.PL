use inc::Module::Install;

name '<?= $_->{module} ?>';
all_from '<?= $_->{path} ?>.pm';

requires 'Encode' => 2.42;

requires 'Plack';
requires 'Plack::Session';
requires 'Plack::Middleware::ReverseProxy';
requires 'Plack::Middleware::StaticShared';
requires 'Plack::Middleware::Auth::Basic';

requires 'Router::Simple';

requires 'Text::Xslate';
requires 'Text::Xslate::Bridge::TT2Like';

requires 'Teng';

build_requires 'Test::Most';

WriteAll;
