/**
 * Customizable version of MX Ergo stand.
 * Allows adjustable tilt and origin angle of tilt (to allow a little forward tilt).
 *
 * Original STL from Logitech MX Ergo Stand by darknao
 * https://www.thingiverse.com/thing:2640807
 * Under license: https://creativecommons.org/licenses/by/4.0/
 */

// Degrees of tilt for the stand.
tilt = 17; // [0:35]

// Origin angle of tilt: 0 = right of mouse, positive = front of mouse, negative = rear of mouse
tilt_origin = 45; // [-60:60]

/* [Hidden] */
$fa = 1;
$fs = $preview ? 5 : 2;

y_off = 44.6;
ring_rad = 75;
ring_y_off = 29.5;

// Import the original STL, normalize the position, and apply tilt_origin
module stand_norm() {
    translate([0, -ring_y_off - y_off, 0])
        rotate([0, 0, -tilt_origin])
        translate([0.5, ring_y_off, -12])
        rotate([15, 0, 0]) import("orig/mxergo_15stand.stl");
}

// 2D projection
module stand_profile() {
    projection() stand_norm();
}

// Just the nice top with sculpted lip
module stand_top() {
    difference_plane([0, 0, 0], near = false) {
        stand_norm();
    }
}

// A version of the stand extended below, ready for tilt / trim
module stand_extended(extend = 100) {
    stand_top();
    translate([0, 0, -extend]) linear_extrude(height = extend) stand_profile();
}

// The modified stand
module stand_modified() {
    difference_plane([0, 0, 0], near = false)
        rotate([0, 0, tilt_origin])
        translate([0, y_off, 0.1])
        rotate([-tilt, 0, 0])
        stand_extended();
}

stand_modified();

// Requires my utility functions in your OpenSCAD lib or as local submodule
// https://github.com/Lenbok/scad-lenbok-utils.git
use<Lenbok_Utils/utils.scad>
