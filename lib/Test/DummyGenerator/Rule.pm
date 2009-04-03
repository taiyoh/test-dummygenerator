package Test::DummyGenerator::Rule;

use Mouse;
extends 'Mouse::Role';

sub import {
    my $class = shift;
    my $pkg   = caller(0);
    no strict 'refs';
    *{"${pkg}::rule"} = \&rule;
    __PACKAGE__->export_to_level(1, @_);
}

sub rule {
    my ( $key, $code ) = @_;
    $Test::DummyGenerator::Hash::Rules->{$key} = $code;
}

1;
