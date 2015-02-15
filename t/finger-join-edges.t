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
use Test::More tests => 1;
use v5.12;
use Test::Differences;
use Graphics::BoxMaker;

my $kerf        = 0.5;
my $length      = 100;
my $thick       = 3.175;
my $join_length = $thick * 3;

my $box = Graphics::BoxMaker->new({
    width_mm     => $length,
    height_mm    => $length,
    depth_mm     => $length,
    thickness_mm => $thick,
    kerf_mm      => $kerf,
    joins        => 'finger',
});


my $total_len = ($kerf / 2) + $join_length;
my $half_total_len = $total_len / 2;
my @edge_center_points = $box->_calc_side_a_edge_b( $length, $kerf, $thick );
eq_or_diff( \@edge_center_points, [
    $half_total_len,
    $half_total_len + ($total_len * 2),
    $half_total_len + ($total_len * 4),
    $length - ($half_total_len + ($total_len * 4)),
    $length - ($half_total_len + ($total_len * 2)),
    $length - ($half_total_len),
]);
