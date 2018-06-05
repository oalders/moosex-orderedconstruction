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

    use DDP;
    p %args;

    Moose->init_meta( %args );

    return $args{for_class}->meta;
}
1;
