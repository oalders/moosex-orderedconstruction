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
    }
    if $Moose::VERSION >= 1.9900;

Moose::Exporter->setup_import_methods(%metaroles);
1;

# ABSTRACT: Initialize Moose attributes in a predictable order

=head1 DESCRIPTION

This module allows you to not worry about attribute initialisation order in
your Moose constructors. It does so by considering all attributes to be lazy,
and forcing generation of attribute values from defaults and builders that
aren't explicitly lazy at the end of the construction stage.

As such, it automates the following common pattern:

  has foo => (
    is => 'ro',
    lazy => 1, # not necessary with this module
    default => sub ($self) {
      ... # something that might depend on other attributes
    },
  );

  # also not necessary with this module
  sub BUILD ($) { $self->foo } # force "foo" value to be built during construction

=cut
