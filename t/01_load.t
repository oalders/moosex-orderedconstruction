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
    default => sub {
        my $self = shift;
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

my $ordered = Local::Ordered->new( set_me => 'donuts' );
ok( $ordered->set_me,  'set_me' );
ok( $ordered->read_me, 'read_me' );
ok( $ordered->was_set, 'was_set' );

done_testing();
