use strict;
use warnings;

use Test::More;
use Test::Fatal qw( exception );

package Local::InvalidDefault;

use Moose;
use MooseX::OrderedConstruction;

has foo => (
    is      => 'ro',
    isa     => 'ArrayRef',
    default => sub { return +{} },
);

1;

package Local::Message;

use Moose;
use MooseX::OrderedConstruction;
use Moose::Util::TypeConstraints;

subtype 'PositiveInt',
    as 'Int',
    where { $_ > 0 },
    message { "The number you provided, $_, was not a positive number" };

has foo => (
    is      => 'ro',
    isa     => 'PositiveInt',
    default => sub { return +{} },
);

1;

package Local::Coercion;

use Moose;
use MooseX::OrderedConstruction;
use Moose::Util::TypeConstraints;

coerce 'Num',
    from 'ArrayRef',
    via { $_->[0] };

has foo => (
    is      => 'ro',
    isa     => 'Num',
    default => sub { return ['NOTANUMBER'] },
    coerce  => 1,
);

1;

package main;

like(
    exception( sub { Local::InvalidDefault->new } ),
    qr{Validation failed for 'ArrayRef'}
);

like(
    exception( sub { Local::Message->new } ),
    qr{was not a positive number}
);

like(
    exception( sub { Local::Coercion->new } ),
    qr{Validation failed for 'Num' with value NOTANUMBER}
);

done_testing();
