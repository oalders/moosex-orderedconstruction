package MooseX::OrderedConstruction::Meta::Attribute::Trait::OrderedConstruction;

use Moose::Role;

has is_implicitly_lazy => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);

after _process_options => sub {
    my ( $class, $name, $options ) = @_;

    #$options->{is_implicitly_lazy} = !$options->{lazy};
    $options->{lazy}               = 1;
};

package    # hide
    Moose::Meta::Attribute::Custom::Trait::OrderedConstruction;

sub register_implementation {
    'MooseX::OrderedConstruction::Meta::Attribute::Trait::OrderedConstruction';
}

1;
