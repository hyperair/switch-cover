use <MCAD/shapes/boxes.scad>
use <MCAD/shapes/2Dshapes.scad>
include <MCAD/units/metric.scad>

switch_dimensions = [40, 10, 10];
min_wall_thickness = 3;
strip_width = 65;
strip_depth = 19;

cover_length = 30;

// automated calculations
foot_thickness = min_wall_thickness;
cover_base = foot_thickness + strip_depth;
cover_surface = cover_base + min_wall_thickness;


$fs = 0.4;
$fa = 1;

module switch_cover_basic_shape ()
{
    fillet (r = 5) {
        strip_grip_piece ();
    }
}

module switch_hole ()
{
    translate ([0, 0, -epsilon])
    ccube (switch_dimensions, center = X + Y);
}

module place_switch ()
{
    translate ([0, 0, cover_base])
    children ();
}

module switch_cover ()
{
    difference () {
        switch_cover_basic_shape ();

        place_switch ();
        switch_hole ();
    }
}

mcad_rounded_box (
    switch_dimensions + [1, 1, 1] * min_wall_thickness,
    radius = 2,
    sidesonly = false
);
