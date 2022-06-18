// Connector for a VHF/UHF ground plane antenna
// Author: Alessandro Paganelli (alessandro.paganelli@gmail.com)

// Measures: in mm

// Constants
$fn = 50;

// Radius + approx 3% tolerance
RADIATOR_RADIUS = 3.1;

// Slab data
SLAB_THICKNESS = 2.5;

// Hole radius - 3% tolerance
SLAB_HOLE_RADIUS = 5.1;

// Connector data
CONNECTOR_HEIGHT = 10.0;
CONNECTOR_WASHER_GAP = 5.0;
CONNECTOR_WASHER_THICKNESS = 2.5;

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

// Actual script
union()
{
    cylinder_with_hole(SLAB_HOLE_RADIUS, RADIATOR_RADIUS, CONNECTOR_HEIGHT);
    washer(SLAB_HOLE_RADIUS + CONNECTOR_WASHER_GAP, SLAB_HOLE_RADIUS, CONNECTOR_WASHER_THICKNESS);
}