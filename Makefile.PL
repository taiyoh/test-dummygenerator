use inc::Module::Install;
name 'Test-DummyGenerator';
all_from 'lib/Test/DummyGenerator.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
