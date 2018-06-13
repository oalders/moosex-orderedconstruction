use strict;
use warnings;

package Local::Ordered::Roles;

use Moose::Role;
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
    our $was_set = 1;
    return $self->set_me;
}

has read_me_with_default => (
    is      => 'ro',
    isa     => 'Str',
    default => sub {
        my $self = shift;
        our $was_set_via_default = 1;
        return $self->set_me;
    },
);

1;

package Local::Ordered;

use strict;
use warnings;
use Moose;
use MooseX::OrderedConstruction;

with('Local::Ordered::Roles');

1;

use Test::More;

for my $i ( 0 .. 9 ) {
    subtest "object iteration $i" => sub { test_object() };
}

Local::Ordered->meta->make_immutable;
for my $i ( 0 .. 9 ) {
    subtest "inlined object iteration $i" => sub { test_object() };
}

sub test_object {
    $Local::Ordered::Roles::was_set             = 0;
    $Local::Ordered::Roles::was_set_via_default = 0;
    my $ordered = Local::Ordered->new( set_me => 'donuts' );
    ok( $Local::Ordered::Roles::was_set,             'was_set' );
    ok( $Local::Ordered::Roles::was_set_via_default, 'was_set_via_default' );
    ok( $ordered->set_me,                            'set_me' );
    ok( $ordered->read_me,                           'read_me' );
    ok( $ordered->read_me_with_default,              'read_me_with_default' );
}

done_testing();
