# Copyright (c) 2015  Timm Murray
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met:
# 
#     * Redistributions of source code must retain the above copyright notice, 
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright 
#       notice, this list of conditions and the following disclaimer in the 
#       documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.
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
) for (qw{ width_mm height_mm depth_mm thickness_mm kerf_mm });

has 'joins' => (
    is      => 'ro',
    isa     => enum([qw{ simple finger }]),
    default => 'simple',
);


sub make_box
{
    my ($self) = @_;
    my @box;

    if( $self->joins eq 'simple' ) {
        push @box, $self->_make_side_a_simple;
        push @box, $self->_make_side_b_simple;
        push @box, $self->_make_side_c_simple;
    }
    # TODO finger joins
    else {
        die "Join type: " . $self->joins . " is not yet implemented\n";
    }

    my %desc = (
        width_mm     => $self->width_mm,
        height_mm    => $self->height_mm,
        depth_mm     => $self->depth_mm,
        thickness_mm => $self->thickness_mm,
        kerf_mm      => $self->kerf_mm,
        box => \@box,
    );
    return \%desc;
}

sub _make_side_a_simple
{
    my ($self) = @_;
    my $kerf         = $self->kerf_mm;
    my $half_kerf    = $kerf / 2;
    my $thickness    = $self->thickness_mm;
    my $double_thick = $thickness * 2;
    my %side;

    $side{kerf} = [
        [ 0, 0 ],
        [
            ($self->depth_mm + $kerf - $double_thick),
            0,
        ],
        [
            ($self->depth_mm + $kerf - $double_thick),
            ($self->height_mm + $kerf),
        ],
        [
            0,
            ($self->height_mm + $kerf),
        ],
    ];

    $side{raw} = [
        [ $half_kerf, $half_kerf ],
        [
            ($self->depth_mm + $half_kerf - $double_thick),
            $half_kerf,
        ],
        [
            ($self->depth_mm + $half_kerf - $double_thick),
            ($self->height_mm + $half_kerf),
        ],
        [
            $half_kerf,
            ($self->height_mm + $half_kerf),
        ],
    ];

    return \%side;
}



sub _make_side_b_simple
{
    my ($self) = @_;
    my $kerf      = $self->kerf_mm;
    my $half_kerf = $kerf / 2;
    my %side;

    $side{kerf} = [
        [ 0, 0 ],
        [
            ($self->depth_mm + $kerf),
            0,
        ],
        [
            ($self->depth_mm + $kerf),
            ($self->height_mm + $kerf),
        ],
        [
            0,
            ($self->height_mm + $kerf),
        ],
    ];

    $side{raw} = [
        [ $half_kerf, $half_kerf ],
        [
            ($self->depth_mm + $half_kerf),
            $half_kerf,
        ],
        [
            ($self->depth_mm + $half_kerf),
            ($self->height_mm + $half_kerf),
        ],
        [
            $half_kerf,
            ($self->height_mm + $half_kerf),
        ],
    ];

    return \%side;
}



sub _make_side_c_simple
{
    my ($self) = @_;
    my $kerf         = $self->kerf_mm;
    my $half_kerf    = $kerf / 2;
    my $thickness    = $self->thickness_mm;
    my $double_thick = $thickness * 2;
    my %side;

    $side{kerf} = [
        [ 0, 0 ],
        [
            ($self->depth_mm + $kerf - $double_thick),
            0,
        ],
        [
            ($self->depth_mm + $kerf - $double_thick),
            ($self->height_mm + $kerf - $double_thick),
        ],
        [
            0,
            ($self->height_mm + $kerf - $double_thick),
        ],
    ];

    $side{raw} = [
        [ $half_kerf, $half_kerf ],
        [
            ($self->depth_mm + $half_kerf - $double_thick),
            $half_kerf,
        ],
        [
            ($self->depth_mm + $half_kerf - $double_thick),
            ($self->height_mm + $half_kerf - $double_thick),
        ],
        [
            $half_kerf,
            ($self->height_mm + $half_kerf - $double_thick),
        ],
    ];

    return \%side;
}


no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__
