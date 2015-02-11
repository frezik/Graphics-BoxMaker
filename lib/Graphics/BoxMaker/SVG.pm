package Graphics::BoxMaker::SVG;
use v5.12;
use warnings;
use Moose;
use namespace::autoclean;
use SVG;

# According to SVG spec, there are 3.543307 pixels per mm.  See:
# http://www.w3.org/TR/SVG/coords.html#Units
use constant MM_IN_PX => 3.543307;


sub plot
{
    my ($self, $desc) = @_;
    my $svg = SVG->new;
    my $cut_group = $svg->group(
        id    => 'cut',
        style => {
            stroke         => 'black',
            'stroke-width' => 1,
            fill           => 'none',
        },
    );

    my $kref_mm = $desc->{kerf_mm};

    my $anchor_y = 0;
    foreach my $box (@{ $desc->{box} }) {
        $anchor_y = $self->_draw_box( $cut_group, $box, $anchor_y, $kref_mm );
    }

    return $svg;
}

sub _draw_box
{
    my ($self, $svg, $box, $anchor_y, $kref_mm) = @_;
    my @kerf      = @{ $box->{kerf} };
    my $anchor_x  = 0;
    my $xv = [ map { ($anchor_x + $_->[0]) * MM_IN_PX } @kerf, $kerf[0] ];
    my $yv = [ map { ($anchor_y + $_->[1]) * MM_IN_PX } @kerf, $kerf[0] ];

    my $points = $svg->get_path(
        x       => $xv,
        y       => $yv,
        -type   => 'polyline',
        -closed => 'true',
    );
    $svg->polyline(
        %$points,
    );

    return $anchor_y + $kerf[2][1] + $kref_mm;
}


no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

