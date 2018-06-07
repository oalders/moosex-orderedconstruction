package MooseX::OrderedConstruction::Meta::Class::Trait::OrderedConstruction;

## no critic (Subroutines::ProhibitSubroutinePrototypes)

use Moose::Role;

use experimental 'signatures';
around new_object => sub ( $orig, $self, @args ) {
    my $obj = $self->$orig(@args);
    $_->get_value( $obj, 0 )
        for grep { $_->is_implicitly_lazy } $self->get_all_attributes;
    return $obj;
};

around _inline_BUILDALL => sub ( $orig, $self, @args ) {
    return (
        $self->$orig(@args),
        map      { _inline_read($_) }
            grep { $_->is_implicitly_lazy } $self->get_all_attributes
    );
};

sub _inline_read ($attr) {
    sprintf 'sub { %s }->();' => join q{} =>
        $attr->_inline_get_value(
		'$instance',
		_attr_env($attr->name, '$type_constraint'),
		_attr_env($attr->name, '$type_coercion'),
		_attr_env($attr->name, '$type_message'),
	);
}

sub _attr_env ($attr_name, $env_name) {
    sprintf '${$attr_envs->{%s}->{q[%s]}}' => B::perlstring($attr_name), $env_name
}

around _eval_environment => sub ( $orig, $self, @args ) {
    +{
        $self->$orig(@args)->%*,
        '$attr_envs' => \{
            map { $_->name => $_->_eval_environment }
                $self->get_all_attributes
        }
    };
};

1;
