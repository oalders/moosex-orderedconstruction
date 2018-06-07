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
