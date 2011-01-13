include <MCAD/units.scad>
include <MCAD/materials.scad>
use <MCAD/shapes.scad>

use <plant_holder.scad>
use <tube_connectors.scad>

// Container dimensions:
diameter = 25*cm;
height = 26*cm;
wt = 2*mm; // Wall thickness of the container
nh = 6; // Number of plant holes

module container(){
    difference(){
        cylinder(r=diameter/2, h=height);
        translate([0, 0, wt]) cylinder(r=diameter/2-wt, h=height);
    }
}

module hole(){
    linear_extrude(height=20*mm, center=true) plant_hole();
}

module lid(){
    color(Pine) difference(){
        cylinder(r=diameter/2+wt, h=15*mm);
        translate([0, 0, -wt]) cylinder(r=diameter/2, h=15*mm);
        for (i = [0:nh]){
            rotate([0, 0, 360*i/nh]) translate([0, -diameter/4, 15*mm]) hole();
        }
        cylinder(r=10*mm, h=20*mm);
    }
    for (i = [0:nh]){
        rotate([0, 0, 360*i/nh]) translate([0, -diameter/4, 15*mm]) plant_holder();
    }
    translate([0, 0, 50*mm]) rotate([180, 0, 360/nh/2])
        star_connector(out_no=nh, in=tube, out=tube, demo=true);
}

tube = [10*mm, 12*mm, 20*mm];

union(){
    color(Aluminum) container();
    translate([0, 0, height]) lid();
}
