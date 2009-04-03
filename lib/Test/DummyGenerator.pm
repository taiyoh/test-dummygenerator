package Test::DummyGenerator;

use Mouse;
use utf8;

use Test::DummyGenerator::Hash;

our $VERSION = '0.001';

has schema => (
    is => 'rw',
    isa => 'HashRef',
    lazy => 1,
    default => sub { {} }
);

has file => (
    is => 'ro',
    isa => 'Str',
    lazy => 1,
    default => sub { '' }
);

sub BUILD {
    my $self = shift;
    unless ( $self->schema ) {
        $self->load_file or die;
    }
}

no Mouse;

sub load_file {
    my $self = shift;
    return '' if !$self->file || !-f $self->file;
    Mouse::load_class('YAML') if !Mouse::is_class_loaded('YAML');
    local $YAML::UseAliases = 0;
    my $yaml = eval { YAML::Dump( YAML::LoadFile( $self->file ) ) };
    return '' if $@;
    utf8::decode($yaml);
    $self->schema(YAML::Load($yaml));
}

sub generate {
    my $self = shift;
    my $loop = shift || 1;
    my @datas = map {
        Test::DummyGenerator::Hash->new( schema => $self->schema, num => $_ )->generate;
    } ( 1 .. $loop );
    return wantarray ? @datas : ( $datas[1] ? \@datas : $datas[0] );
}

1;
__END__

=head1 NAME

Test::DummyGenerator -

=head1 SYNOPSIS

  use Test::DummyGenerator;

=head1 DESCRIPTION

Test::DummyGenerator is

=head1 AUTHOR

taiyoh E<lt>sun.basix@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
