use strict;
use Test::Base qw/no_plan/;

use YAML qw/Dump/;
use Test::DummyGenerator;

{
    my $dummy = Test::DummyGenerator->new(
        schema => {
            name => '__str(aaaa\w{5})__',
            age  => '__range(16,70)__',
        }
    );

    isa_ok( $dummy, 'Test::DummyGenerator' );

    my $data = $dummy->generate;

    ok($data);

    like( $data->{name}, qr/aaaa\w{5}/ );
    cmp_ok( $data->{age}, '>=', 16 );
    cmp_ok( $data->{age}, '<=', 70 );

#    print Dump $data;
}

{
    my $dummy = Test::DummyGenerator->new(
        schema => {
            id   => '__exp(_)__',
            name => '__str(\w{5})__',
            age  => '__rand(50)__',
            pattern  => '__range(1,3)__',
            status => {
                param => '__exp(int( (101 - _) / _ ))__',
            }
        }
    );

    isa_ok( $dummy, 'Test::DummyGenerator' );

    my $data = $dummy->generate(10);

    #print Dump $data;
}

{
    my $dummy = Test::DummyGenerator->new(
        schema => YAML::Load(do { local $/; <DATA> })
    );
    my $data = $dummy->generate(3);
    print Dump $data;
}

__DATA__
---
id: __exp(_)__
name: __str(\w{5})__
age: __rand(50)__
pattern: __range(1,3)__
status:
  param: __exp(int( (101 - _) / _ ))__
