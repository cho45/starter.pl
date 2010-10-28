use inc::Module::Install;
name '<?= $_->{dist} ?>';
all_from 'lib/<?= $_->{path} ?>';

requires 'Exporter::Lite';

build_requires 'Test::Most';

# Module::Install::AuthorTests
author_tests('xt');

# Module::Install::Repository
auto_set_repository;

# Module::Install::TestBase
use_test_base;

# Module::Install::ReadmeFromPod
readme_from 'lib/<?= $_->{path} ?>';

auto_include;
WriteAll;
