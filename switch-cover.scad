use <fillet.scad>
use <MCAD/array/mirror.scad>
use <MCAD/shapes/boxes.scad>
use <MCAD/shapes/2Dshapes.scad>
include <MCAD/units/metric.scad>

switch_dimensions = [10, 40, 10];
min_wall_thickness = 3;
strip_width = 65;
strip_depth = 19;

cover_length = 30;

// automated calculations
cover_width = strip_width + min_wall_thickness * 2;
foot_thickness = min_wall_thickness;
foot_length = foot_thickness + 1;
cover_base = foot_thickness + strip_depth;
cover_surface = cover_base + min_wall_thickness;


$fs = 0.4;
$fa = 1;

module switch_cover_basic_shape ()
{
    fillet (r = 5, steps = 10) {
        strip_grip_piece ();

        place_switch ()
        switch_housing ();
    }
}

module switch_hole ()
{
    translate ([0, 0, -epsilon])
    ccube (switch_dimensions, center = X + Y);
}

module switch_housing ()
{
    dimensions = switch_dimensions + [1, 1, 1] * min_wall_thickness;

    translate ([0, 0, dimensions[2] / 2])
    mcad_rounded_box (
        dimensions,
        radius = min_wall_thickness,
        sidesonly = false,
        center = true
    );
}

module strip_grip_piece ()
{
    rotate (-90, Y)
    linear_extrude (height = cover_length, center = true)
    union () {
        intersection () {
            offset (r = -5)
            offset (r = 5)
            union () {
                // top piece
                translate ([cover_base, -cover_width / 2])
                square ([min_wall_thickness, cover_width]);

                // legs
                mcad_mirror_duplicate (Y)
                translate ([0, strip_width / 2])
                square ([cover_surface, min_wall_thickness]);
            }

            offset (r = 7)
            offset (r = -7)
            square ([cover_surface * 2, cover_width], center = true);
        }

        // feet
        mcad_mirror_duplicate (Y)
        translate ([0, strip_width / 2 - foot_length])
        square ([min_wall_thickness, foot_length]);
    }
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

        place_switch ()
        switch_hole ();
    }
}

*place_switch ()
switch_housing ();

*switch_grip_piece ();

switch_cover ();
