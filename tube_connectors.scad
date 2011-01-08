// Copyright 2010 Elmo Mäntynen
// Licensed as GPL 2 or later

include <MCAD/units.scad>
use <MCAD/shapes.scad>

// Different kinds of tube connectors etc.

// dimensions for tubes as follows:
// connector(in=[ID, OD, contactlen], out=[ID, OD, contactlen])
// contactlen is the actual lenght of tube on connector

//Use an even number of out connectors
module star_connector(out_no=6, in, out){
    thickness = out[0];
    translate([0, 0, thickness/2]) union(){
        difference(){
            union(){
                linear_extrude(height=thickness, center=true)
                    ngon(out_no, radius=out[2], center=true);
                translate([0, 0, out[2]/2+0.1])
                    cylinder(r=in[0]/2, h=out[2]+thickness, center=true);
                for (i = [0:out_no/2]){
                    rotate([0, 90, 360*i/out_no])
                        cylinder(r=out[0]/2, h=out[2]*4, center=true);
                }
            }
            for (i = [0:out_no/2]){
                rotate([0, 90, 360*i/out_no])
                    cylinder(r=0.6*out[0]/2, h=out[2]*4+0.1, center=true);
            }
            translate([0, 0, out[2]/2+0.3*thickness])
                cylinder(r=0.6*in[0]/2, h=out[2]+thickness+0.1, center=true);
        }
    }
}

// ---------------------
// Tests

tube1 = [10*mm, 12*mm, 20*mm];
tube2 = [10*mm, 12*mm, 20*mm];

module test_star_connector(){
    star_connector(out_no=6, in=tube1, out=tube2);
}

test_star_connector();

