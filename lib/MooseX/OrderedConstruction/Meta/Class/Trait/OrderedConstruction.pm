package MooseX::OrderedConstruction::Meta::Class::Trait::OrderedConstruction;

use Moose::Role;

use List::AllUtils 'pairmap', 'pairgrep', 'sort_by', 'zip';

around new_object => sub {
    my ( $orig, $self, @args ) = @_;
    my $obj = $self->$orig(@args);
    $_->get_value( $obj, 0 )
        for grep { $_->is_implicitly_lazy } $self->get_all_attributes;
    return $obj;
};

around _inline_BUILDALL => sub {
    my ( $orig, $self, @args ) = @_;
    my @attrs = sort_by { $_->name } $self->get_all_attributes;
    return (
        $self->$orig(@args),
        pairmap { _inline_read( $a, $b ) }
        pairgrep { $a->is_implicitly_lazy } &zip( \@attrs, [ 0 .. $#attrs ] )
    );
};

sub _inline_read {
    my ( $attr, $idx ) = @_;
    sprintf 'sub { %s }->();' => join q{} => (
        $attr->has_default
        ? ("my \$attr_default = \$defaults->[$idx];")
        : ()
        ),
        $attr->_inline_get_value(
        '$instance',
        "\$type_constraint_bodies[$idx]",
        "\$type_coercions[$idx]",
        "\$type_constraint_messages[$idx]",
        );
}

1;
