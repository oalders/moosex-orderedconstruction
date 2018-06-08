use strict;
use warnings;

use Test::More;

use lib 't/lib';

use Local::Ordered;

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
