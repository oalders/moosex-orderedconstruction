use strict;
use warnings;

package MooseX::OrderedConstruction;

use Moose ();
use Moose::Exporter;
use Moose::Util::MetaRole;

Moose::Exporter->setup_import_methods( also => 'Moose' );

sub init_meta {
    shift;
    my %args = @_;
    Moose->init_meta(%args);
    return $args{for_class}->meta;
}

my %metaroles = (
    class_metaroles => {
        attribute => [
            'MooseX::OrderedConstruction::Meta::Attribute::Trait::OrderedConstruction'
        ],
        class => [
            'MooseX::OrderedConstruction::Meta::Class::Trait::OrderedConstruction'
        ],
    },
);

$metaroles{role_metaroles} = {
    applied_attribute => [
        'MooseX::OrderedConstruction::Meta::Attribute::Trait::OrderedConstruction'
    ],
    class => [
        'MooseX::OrderedConstruction::Meta::Class::Trait::OrderedConstruction'
    ],
    }
    if $Moose::VERSION >= 1.9900;

Moose::Exporter->setup_import_methods(%metaroles);
1;
