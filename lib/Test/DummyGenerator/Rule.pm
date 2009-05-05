package Test::DummyGenerator::Rule;

use Exporter 'import';
our @EXPORT = 'rule';

sub rule($&) {
    my ( $key, $code ) = @_;
    no warnings 'once';
    $Test::DummyGenerator::Rules->{$key} = $code;
}

1;
