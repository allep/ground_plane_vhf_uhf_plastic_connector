// Connector for a VHF/UHF ground plane antenna
// Author: Alessandro Paganelli (alessandro.paganelli@gmail.com)

// Measures: in mm

// Constants
$fn = 50;

// Radius + approx 6% tolerance
RADIATOR_RADIUS = 3.2;

// Slab data
SLAB_THICKNESS = 2.5;

// Hole radius - 3% tolerance
SLAB_HOLE_RADIUS = 4.0;

// Connector data
CONNECTOR_HEIGHT = 10.0;
CONNECTOR_WASHER_GAP = 5.0;
CONNECTOR_WASHER_THICKNESS = 2.5;

// Screws data
SLAB_SCREW_HOLE_RADIUS = 2.25;
SLAB_SCREW_HOLE_DISTANCE_X = 19.0;
SLAB_SCREW_HOLE_DISTANCE_Y = 22.0;
SLAB_WITH_SCREWS_THICKNESS = 1.5;

// Slab data

// External gap to be measured from the hole perimeter
SLAB_SCREW_EXTERNAL_GAP = 4.0;

// Modules
module cylinder_with_hole(radius, hole_radius, height)
{
    difference()
    {
        cylinder(h=height, r=radius);
        cylinder(h=height, r=hole_radius);
    }
}

module washer(external_radius, internal_radius, thickness)
{
    difference()
    {
        cylinder(h=thickness, r=external_radius);
        cylinder(h=thickness, r=internal_radius);
    }
}

module base_with_screws(distance_x, distance_y, screw_hole_radius, external_gap, main_hole_radius, thickness)
{
    side_x = distance_x + 2*(screw_hole_radius + external_gap);
    side_y = distance_y + 2*(screw_hole_radius + external_gap);
    hole_x = distance_x / 2;
    hole_y = distance_y / 2;
    
    difference()
    {
        // actual base
        translate([-side_x / 2, -side_y / 2, 0])
        cube([side_x, side_y, thickness]);
        
        // main hole
        cylinder(h=thickness, r=main_hole_radius);
        
        // screw holes
        translate([-hole_x, -hole_y, 0])
        cylinder(h=thickness, r=screw_hole_radius);
        translate([+hole_x, -hole_y, 0])
        cylinder(h=thickness, r=screw_hole_radius);
        translate([+hole_x, +hole_y, 0])
        cylinder(h=thickness, r=screw_hole_radius);
        translate([-hole_x, +hole_y, 0])
        cylinder(h=thickness, r=screw_hole_radius);
    }
}

// Actual script
union()
{
    cylinder_with_hole(SLAB_HOLE_RADIUS, RADIATOR_RADIUS, CONNECTOR_HEIGHT);
    base_with_screws(SLAB_SCREW_HOLE_DISTANCE_X, SLAB_SCREW_HOLE_DISTANCE_Y, SLAB_SCREW_HOLE_RADIUS, SLAB_SCREW_EXTERNAL_GAP, SLAB_HOLE_RADIUS, SLAB_WITH_SCREWS_THICKNESS);
}