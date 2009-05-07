package Test::DummyGenerator::Rule;

use Exporter 'import';
our @EXPORT = 'rule';

sub rule($&) { Test::DummyGenerator::add_rule(@_); }

1;
