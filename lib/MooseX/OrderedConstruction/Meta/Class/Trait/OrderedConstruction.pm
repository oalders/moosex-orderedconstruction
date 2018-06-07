package MooseX::OrderedConstruction::Meta::Class::Trait::OrderedConstruction;

## no critic (Subroutines::ProhibitSubroutinePrototypes)

use Moose::Role;
use List::AllUtils 'pairmap', 'pairgrep', 'sort_by', 'zip';

use experimental 'signatures';
around new_object => sub ( $orig, $self, @args ) {
    my $obj = $self->$orig(@args);
    $_->get_value( $obj, 0 )
        for grep { $_->is_implicitly_lazy } $self->get_all_attributes;
    return $obj;
};

around _inline_BUILDALL => sub ( $orig, $self, @args ) {
    my @attrs = sort_by { $_->name } $self->get_all_attributes;
    return (
        $self->$orig(@args),
        pairmap { _inline_read( $a, $b ) }
        pairgrep { $a->is_implicitly_lazy } &zip( \@attrs, [ 0 .. $#attrs ] )
    );
};

sub _inline_read ( $attr, $idx ) {
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
