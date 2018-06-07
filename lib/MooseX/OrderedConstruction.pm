use strict;
use warnings;

package MooseX::OrderedConstruction;

use Moose ();
use Moose::Exporter;

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

# ABSTRACT: Initialize Moose attributes in a predictable order
