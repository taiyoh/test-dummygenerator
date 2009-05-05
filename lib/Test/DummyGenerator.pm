package Test::DummyGenerator;
use utf8;

use Any::Moose;

sub import {
    my $pkg = shift;
    $pkg->load_rules(@_);
}

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
        $self->load_file or die 'schema not found ...';
    }
}

no Any::Moose;

our $VERSION = '0.001';

our $Rules = {};

sub load_rules {
    my $class = shift;
    my $tdgr = 'Test::DummyGenerator::Rule';
    my @rules = @_;
    unshift @rules, 'Default';
    for (@rules) {
        my $rule;
        if (/^\+/) {
            ( $rule = $_ ) =~ s/^\+//;
        }
        else {
            $rule = join '::', ( $tdgr, $_ );
        }
        Any::Moose::load_class($rule) if !Any::Moose::is_class_loaded($rule);
    }
}

sub load_file {
    my $self = shift;
    return '' if !$self->file || !-f $self->file;
    Any::Moose::load_class('YAML') if !Any::Moose::is_class_loaded('YAML');
    no warnings 'once';
    local $YAML::UseAliases = 0;
    my $yaml = eval { YAML::Dump( YAML::LoadFile( $self->file ) ) };
    return '' if $@;
    utf8::decode($yaml);
    $self->schema(YAML::Load($yaml));
}

sub generate {
    my $self = shift;
    my $loop = shift || 1;
    my $tdgo = 'Test::DummyGenerator::Object';
    Any::Moose::load_class($tdgo) if !Any::Moose::is_class_loaded($tdgo);
    my @data_list = map {
        my $dg = $tdgo->new( schema => $self->schema, num => $_ );
        $dg->generate;
    } ( 1 .. $loop );
    return wantarray ? @data_list : ( $data_list[1] ? \@data_list : $data_list[0] );
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
