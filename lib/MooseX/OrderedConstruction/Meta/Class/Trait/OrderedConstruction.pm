package MooseX::OrderedConstruction::Meta::Class::Trait::OrderedConstruction;

## no critic (Subroutines::ProhibitSubroutinePrototypes)

use Moose::Role;
use List::AllUtils 'pairmap', 'pairgrep', 'zip';

use experimental 'signatures';
around new_object => sub ( $orig, $self, @args ) {
    my $obj = $self->$orig(@args);
    $_->get_value( $obj, 0 )
        for grep { $_->is_implicitly_lazy } $self->get_all_attributes;
    return $obj;
};

around _inline_BUILDALL => sub ( $orig, $self, @args ) {
	    my @attrs = $self->get_all_attributes;
    return (
        $self->$orig(@args),
        pairmap      { _inline_read($a, $b) }
            pairgrep { $a->is_implicitly_lazy } &zip(\@attrs, [0..$#attrs]),
    );
};

sub _inline_read ($attr, $idx) {
    sprintf 'sub { my $attr_default = %s; %s }->();' =>
        _attr_env( $attr->name, '$attr_default' ),
        join q{} => $attr->_inline_get_value(
        '$instance',
	"\$type_constraint_bodies[$idx]",
	"\$type_coercions[$idx]",
	"\$type_constraint_messages[$idx]",
        );
}

sub _attr_env ( $attr_name, $env_name ) {
    sprintf '$attr_envs->{%s}->{q[%s]}' => B::perlstring($attr_name),
        $env_name;
}

around _eval_environment => sub ( $orig, $self, @args ) {
    +{
        $self->$orig(@args)->%*,
        '$attr_envs' => \{
            map {
                $_->name =>
                    { pairmap { $a => $$b } $_->_eval_environment->%* }
            } $self->get_all_attributes
        }
    };
};

1;
