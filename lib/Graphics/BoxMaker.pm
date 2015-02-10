package Graphics::BoxMaker;

use v5.12;
use warnings;
use Moose;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

# ABSTRACT: Create boxes for CNC machines, such as laser cutters


has $_ => (
    is       => 'ro',
    isa      => 'Num',
    required => 1,
) for (qw{ width_mm height_mm depth_mm thickness_mm kerf });

has 'joins' => (
    is      => 'ro',
    isa     => enum([qw{ simple finger }]),
    default => 'simple',
);


no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__
