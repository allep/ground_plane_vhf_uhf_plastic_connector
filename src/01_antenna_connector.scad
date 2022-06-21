// Connector for a VHF/UHF ground plane antenna
// Author: Alessandro Paganelli (alessandro.paganelli@gmail.com)

// Measures: in mm

// Constants
$fn = 50;

// Mode
IS_LOWER_PIECE = false;

// Radius + approx 6% tolerance
RADIATOR_RADIUS = 3.2;

// Slab data
METAL_SLAB_THICKNESS = 2.5;

// Hole radius - 3% tolerance
SLAB_HOLE_RADIUS = 4.0;

// Connector data
CONNECTOR_HEIGHT = 10.0;
CONNECTOR_WASHER_GAP = 5.0;
CONNECTOR_WASHER_THICKNESS = 2.5;

// Radiator holder
RADIATOR_HOLDER_THICKNESS = 15.0;

// Screws data
SCREW_HEAD_RADIUS = 3.0;
SCREW_HEAD_HEIGHT = 3.0;
SLAB_SCREW_HOLE_RADIUS = 2.25;
SLAB_SCREW_HOLE_DISTANCE_X = 19.0;
SLAB_SCREW_HOLE_DISTANCE_Y = 22.0;
SLAB_THICKNESS = 1.5;

// Slab data

// External gap to be measured from the hole perimeter
SLAB_SCREW_EXTERNAL_GAP = 3.0;

// Modules
module cylinder_with_hole(radius, hole_radius, height)
{
    difference()
    {
        cylinder(h=height, r=radius);
        cylinder(h=height, r=hole_radius);
    }
}

module test_holes(radiator_hole_length, distance_x, distance_y, screw_head_height, screw_head_radius, radiator_radius_external, radiator_radius_internal, create_for_internal_hole)
{
    rotation_angle_x = 45;
    rotation_angle_y = 0;
    rotation_angle_z = 45;
    
    hole_x = distance_x / 2;
    hole_y = distance_y / 2;
    
    // choose how to produce the holder
    radiator_radius = (create_for_internal_hole == true) ? radiator_radius_internal : radiator_radius_external;
    
    echo(radiator_radius);
    
    border_separation_z = screw_head_radius / tan(rotation_angle_x);
    offset_z = border_separation_z + radiator_radius_external / sin(rotation_angle_x) + screw_head_height;
    
    // simulation of screw heads
    translate([-hole_x, hole_y, 0])
    cylinder(h=screw_head_height, r=screw_head_radius);

    translate([-hole_x, -hole_y, 0])
    cylinder(h=screw_head_height, r=screw_head_radius);

    translate([hole_x, -hole_y, 0])
    cylinder(h=screw_head_height, r=screw_head_radius);

    translate([hole_x, hole_y, 0])
    cylinder(h=screw_head_height, r=screw_head_radius);
    
    // radiator holes - the hard part!
    
    translate([-hole_x, hole_y, offset_z])
    rotate([rotation_angle_x, rotation_angle_y, rotation_angle_z])
    cylinder(h=radiator_hole_length, r=radiator_radius, center = true);

    translate([-hole_x, -hole_y, offset_z])
    rotate([rotation_angle_x, rotation_angle_y, 3 * rotation_angle_z])
    cylinder(h=radiator_hole_length, r=radiator_radius, center = true);

    translate([hole_x, -hole_y, offset_z])
    rotate([rotation_angle_x, -rotation_angle_y, 5 * rotation_angle_z])
    cylinder(h=radiator_hole_length, r=radiator_radius, center = true);

    translate([hole_x, hole_y, offset_z])
    rotate([rotation_angle_x, -rotation_angle_y, 7 * rotation_angle_z])
    cylinder(h=radiator_hole_length, r=radiator_radius, center = true);
}

module radiator_holder(side_x, side_y, distance_x, distance_y, screw_head_radius, screw_head_height, main_hole_radius, radiator_radius, thickness)
{
    hole_x = distance_x / 2;
    hole_y = distance_y / 2;
    
    difference()
    {
        translate([-side_x / 2, -side_y / 2, 0])
        cube([side_x, side_y, thickness]);
        
        // main hole
        cylinder(h=thickness, r=main_hole_radius);
        
        // screw head holes
        translate([-hole_x, -hole_y, 0])
        cylinder(h=screw_head_height, r=screw_head_radius);
        translate([+hole_x, -hole_y, 0])
        cylinder(h=screw_head_height, r=screw_head_radius);
        translate([+hole_x, +hole_y, 0])
        cylinder(h=screw_head_height, r=screw_head_radius);
        translate([-hole_x, +hole_y, 0])
        cylinder(h=screw_head_height, r=screw_head_radius);
        
        // radiator holes - the hard part!
        radiator_hole_length = thickness*1.4; // FIXME
        radiator_hole_offset_z = -3*thickness/4; // FIXME
        radiator_hole_offset_after_rotate_z = screw_head_height + 10; // FIXME
            
        translate([-hole_x, -hole_y, radiator_hole_offset_after_rotate_z])
        rotate([-45, 45, 0])
        translate([0, 0, radiator_hole_offset_z])
        cylinder(h=radiator_hole_length, r=radiator_radius);
        
        translate([-hole_x, hole_y, radiator_hole_offset_after_rotate_z])
        rotate([45, 45, 0])
        translate([0, 0, radiator_hole_offset_z])
        cylinder(h=radiator_hole_length, r=radiator_radius);
        
        translate([hole_x, hole_y, radiator_hole_offset_after_rotate_z])
        rotate([45, -45, 0])
        translate([0, 0, radiator_hole_offset_z])
        cylinder(h=radiator_hole_length, r=radiator_radius);
        
        translate([hole_x, -hole_y, radiator_hole_offset_after_rotate_z])
        rotate([-45, -45, 0])
        translate([0, 0, radiator_hole_offset_z])
        cylinder(h=radiator_hole_length, r=radiator_radius);
    }
}

module base_with_screws(side_x, side_y, distance_x, distance_y, screw_hole_radius, main_hole_radius, thickness)
{
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

// data
side_x = SLAB_SCREW_HOLE_DISTANCE_X + 2*(SLAB_SCREW_HOLE_RADIUS + SLAB_SCREW_EXTERNAL_GAP);
side_y = SLAB_SCREW_HOLE_DISTANCE_Y + 2*(SLAB_SCREW_HOLE_RADIUS + SLAB_SCREW_EXTERNAL_GAP);

if (IS_LOWER_PIECE == true)
{
    // Lower piece - slab connection with 4 screws
    union()
    {
        cylinder_with_hole(SLAB_HOLE_RADIUS, RADIATOR_RADIUS, CONNECTOR_HEIGHT);
        
        base_with_screws(side_x, side_y, SLAB_SCREW_HOLE_DISTANCE_X, SLAB_SCREW_HOLE_DISTANCE_Y, SLAB_SCREW_HOLE_RADIUS, SLAB_HOLE_RADIUS, SLAB_THICKNESS);
    }
}
else
{
    // Upper piece - radiator holder
    // radiator_holder(side_x, side_y, SLAB_SCREW_HOLE_DISTANCE_X, SLAB_SCREW_HOLE_DISTANCE_Y, SCREW_HEAD_RADIUS, SCREW_HEAD_HEIGHT, SLAB_HOLE_RADIUS, RADIATOR_RADIUS, RADIATOR_HOLDER_THICKNESS);
    difference()
    {
        test_holes(RADIATOR_HOLDER_THICKNESS*1.6, SLAB_SCREW_HOLE_DISTANCE_X, SLAB_SCREW_HOLE_DISTANCE_Y, SCREW_HEAD_HEIGHT, SCREW_HEAD_RADIUS, RADIATOR_RADIUS + 1.0, RADIATOR_RADIUS, false);
                test_holes(RADIATOR_HOLDER_THICKNESS*1.6, SLAB_SCREW_HOLE_DISTANCE_X, SLAB_SCREW_HOLE_DISTANCE_Y, SCREW_HEAD_HEIGHT, SCREW_HEAD_RADIUS, RADIATOR_RADIUS + 1.0, RADIATOR_RADIUS, true);
    }
}