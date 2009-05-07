package Test::DummyGenerator::Object;

use Any::Moose;

has num => (
    is => 'ro',
    isa => 'Int',
    required => 1,
);

has schema => (
    is => 'ro',
    isa => 'HashRef',
    required => 1,
);

no Any::Moose;

sub _generate_string {
    my $self = shift;
    my $data = shift;
    local $_ = $self->num;
    for my $k ( keys %{$Test::DummyGenerator::Rules} ) {
        if ( $data =~ /__${k}\((.+?)\)__/ ) {
            return $Test::DummyGenerator::Rules->{$k}->($1);
        }
    }
    return eval $data;
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
