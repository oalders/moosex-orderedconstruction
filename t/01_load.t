use strict;
use warnings;

package Local::Ordered;

use strict;
use warnings;
use Moose;
use MooseX::OrderedConstruction;

has set_me => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has read_me => (
    is      => 'ro',
    isa     => 'Str',
    builder => '_build_read_me',
);

sub _build_read_me {
    my $self = shift;
    $::was_set = 1;
    $self->was_set( $self->set_me );
    return $self->set_me;
}

has read_me_with_default => (
    is      => 'ro',
    isa     => 'Str',
    default => sub {
        my $self = shift;
        $::was_set_via_default = 1;
        $self->was_set( $self->set_me );
        return $self->set_me;
    },
);

has was_set => (
    is  => 'rw',
    isa => 'Str',
);

1;

package main;

use Test::More;

for my $i ( 0 .. 9 ) {
    subtest "object iteration $i" => sub { test_object() };
}

Local::Ordered->meta->make_immutable;
for my $i ( 0 .. 9 ) {
    subtest "inlined object iteration $i" => sub { test_object() };
}

sub test_object {
    $::was_set = 0;
    $::was_set_via_default = 0;
    my $ordered = Local::Ordered->new( set_me => 'donuts' );
    ok( $::was_set, 'was_set' );
    ok( $::was_set_via_default, 'was_set_via_default' );
    ok( $ordered->set_me,  'set_me' );
    ok( $ordered->read_me, 'read_me' );
    ok( $ordered->read_me_with_default, 'read_me_with_default' );
    ok( $ordered->was_set, 'was_set' );
}

done_testing();
