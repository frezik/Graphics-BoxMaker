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
use Test::More tests => 2;
use v5.12;
use warnings;
use Graphics::BoxMaker;

my $kerf         = 0.5;
my $half_kerf    = $kerf / 2;
my $thick        = 3.175; # 1/8 inches
my $double_thick = 2 * $thick;
my $box = Graphics::BoxMaker->new({
    width_mm     => 10,
    height_mm    => 10,
    depth_mm     => 10,
    thickness_mm => $thick,
    kerf_mm      => $kerf,
    joins        => 'simple',
});
isa_ok( $box => 'Graphics::BoxMaker' );


my $box_description = $box->make_box;
is_deeply( $box_description, {
    width_mm     => 10,
    height_mm    => 10,
    depth_mm     => 10,
    thickness_mm => $thick,
    kerf_mm      => $kerf,
    box          => [
        { # A
            kerf => [
                [ 0, 0 ],
                [ (10 + $kerf - $double_thick), 0 ],
                [ (10 + $kerf - $double_thick), (10 + $kerf) ],
                [ 0, (10 + $kerf) ],
            ],
            raw => [
                [ $half_kerf, $half_kerf ],
                [ (10 + $half_kerf - $double_thick), $half_kerf ],
                [ (10 + $half_kerf - $double_thick), 10 + $half_kerf ],
                [ $half_kerf, 10 + $half_kerf ],
            ],
        },
        { # B
            kerf => [
                [ 0, 0 ],
                [ 10 + $kerf, 0 ],
                [ 10 + $kerf, 10 + $kerf ],
                [ 0, 10 + $kerf ],
            ],
            raw => [
                [ $half_kerf, $half_kerf ],
                [ 10 + $half_kerf, $half_kerf ],
                [ 10 + $half_kerf, 10 + $half_kerf ],
                [ $half_kerf, 10 + $half_kerf ],
            ],
        },
        { # C
            kerf => [
                [ 0, 0 ],
                [ (10 + $kerf - $double_thick), 0 ],
                [ (10 + $kerf - $double_thick), (10 + $kerf - $double_thick) ],
                [ 0, (10 + $kerf - $double_thick) ],
            ],
            raw => [
                [ $half_kerf, $half_kerf ],
                [ (10 + $half_kerf - $double_thick), $half_kerf ],
                [ (10 + $half_kerf - $double_thick),
                    (10 + $half_kerf - $double_thick) ],
                [ $half_kerf, (10 + $half_kerf - $double_thick) ],
            ],
        },
    ]
});
