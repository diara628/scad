// Copyright 2010 Elmo Mäntynen
// Licensed as GPL 2 or later

include <MCAD/units.scad>
include <MCAD/materials.scad>
use <MCAD/shapes.scad>

// Different kinds of tube connectors etc.

// dimensions for tubes as follows:
// connector(in=[ID, OD, contactlen], out=[ID, OD, contactlen])
// contactlen is the actual lenght of tube on connector

// placement is either "flat" or "corner"

//Usable for 3-6 out connectors
module star_connector(out_no=6, in, out, placement="corner", demo=false){
    thickness = out[0];
    translate([0, 0, thickness/2]) union(){
        difference(){
            union(){
                symmetric_star_connector(no=out_no, tube=out, placement=placement, center=true, demo=demo);
                translate([0, 0, thickness/2-0.1])
                    cylinder(r=in[0]/2, h=out[2]);
            }
            translate([0, 0, out[2]/2+0.3*thickness])
                cylinder(r=0.6*in[0]/2, h=out[2]+thickness+0.1, center=true);
        }
    }
}

//Usable for 3-6 connectors
module symmetric_star_connector(no=3, tube, placement="corner", center=false, demo=false){
    thickness = tube[0];
    raise = center ? 0 : thickness/2;
    placement = placement=="flat" ? 0 : 0.5;
    translate([0, 0, raise]) union(){
        difference(){
            union(){
                linear_extrude(height=thickness, center=true)
                    ngon(sides=no, radius=tube[2], center=true);
                for (i = [0:no]){
                    rotate([0, 90, 360*(i+placement)/no]) union(){
                        translate([0, 0, tube[2]]) rotate([0, 0, 360/40])
                            cylinder(r=1.0125*tube[0]/2, h=tube[2]*2, center=true, $fn=20);
                        if (demo==true){
                            translate([0, 0, 5*mm+tube[2]]) color(BlackPaint)
                            tube2(OD=tube[1], ID=tube[0], height=7*cm);
                        }
                    }
                }
            }
            for (i = [0:no]){
                rotate([0, 90, 360*(i+placement)/no])
                    translate([0, 0, tube[2]]) cylinder(r=0.6*tube[0]/2, h=tube[2]*2+0.1, center=true);
            }
        }
    }
}

// ---------------------
// Tests

tube1 = [10*mm, 12*mm, 20*mm];
tube2 = [10*mm, 12*mm, 20*mm];

module test_star_connector_1to6(){
    star_connector(out_no=3, in=tube1, out=tube2, demo=true);
}

//test_star_connector_1to6();

module test_star_connector_1to3(){
    difference(){
        star_connector(out_no=3, in=tube1, out=tube2, demo=false);
        translate([0, 0, 15]) cube(18, center=true);
    }
}

//test_star_connector_1to3();

module test_symmetric_star_connector(){
    difference(){
        symmetric_star_connector(no=3, tube=tube1, demo=false);
        translate([0, 0, 15]) cube(18, center=true);
    }
}

//test_symmetric_star_connector();

symmetric_star_connector(no=3, tube=tube1, placement="corner", demo=false);
