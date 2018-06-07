package Local::Ordered::Roles;

use Moose::Role;

our ( $was_set, $was_set_via_default );

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
    $was_set = 1;
    $self->was_set( $self->set_me );
    return $self->set_me;
}

has read_me_with_default => (
    is      => 'ro',
    isa     => 'Str',
    default => sub {
        my $self = shift;
        $was_set_via_default = 1;
        $self->was_set( $self->set_me );
        return $self->set_me;
    },
);

has was_set => (
    is  => 'rw',
    isa => 'Str',
);

1;
