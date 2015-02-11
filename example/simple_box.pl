#!perl
use v5.14;
use Graphics::BoxMaker;
use Graphics::BoxMaker::SVG;

my $SIZE = shift or die "Need size of box\n";


my $box = Graphics::BoxMaker->new({
    width_mm     => $SIZE,
    height_mm    => $SIZE,
    depth_mm     => $SIZE,
    thickness_mm => 3.175,
    kerf_mm      => 0.5,
    joins        => 'simple',
});
my $svg_plotter = Graphics::BoxMaker::SVG->new;

my $svg = $svg_plotter->plot( $box->make_box );
print $svg->xmlify;
