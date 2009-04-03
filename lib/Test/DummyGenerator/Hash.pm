package Test::DummyGenerator::Hash;

use Mouse;
extends 'Test::DummyGenerator';

has num => (
    is => 'ro',
    isa => 'Int',
    required => 1,
);

has sr => (
    is      => 'ro',
    isa     => 'String::Random',
    lazy    => 1,
    default => sub {
        require String::Random;
        String::Random->new;
    }
);

no Mouse;

sub _generate_string {
    my $self = shift;
    my $data = shift;
    local $_ = $self->num;
    if ( $data =~ /__str\((.+?)\)__/ ) {
        return $self->sr->randregex($1);
    }
    elsif ( $data =~ /__rand\((.+?)\)__/ ) {
        return int(rand $1) + 1;
    }
    elsif ( $data =~ /__exp\((.+?)\)__/ ) {
        (my $exp = $1) =~ s/_/$_/g;
        return eval $exp;
    }
    elsif ( $data =~ /__range\((\d+?),(\d+?)\)__/ ) {
        my $r = $2 - $1 + 1;
        return int(rand($r)) + $1;
    }
    return $data;
}

sub generate {
    my $self = shift;
    my $data;
    my $klass = ref $self;
    my $n = $self->num;
    for my $key ( keys %{ $self->schema } ) {
        my $ref = $self->schema->{$key};
        if ( !ref $ref ) {
            $data->{$key} = $self->_generate_string($ref);
        }
        elsif ( ref $ref eq 'HASH' ) {
            my $dg = $klass->new( schema => $ref, num => $n );
            $data->{$key} = $dg->generate;
        }
        elsif ( ref $ref eq 'ARRAY' ) {
            for my $h ( @$ref ) {
                my $dg = $klass->new( schema => $h, num => $n );
                push @{ $data->{$key} }, $dg->generate;
            }
        }
    }
    return $data;
}

1;
