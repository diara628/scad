include <MCAD/units.scad>
use <MCAD/shapes.scad>

//Hole dimensions
width = 7*cm;
length = 9.5*cm;

linear_extrude(height=10*mm)
difference(){
    union(){
        egg_outline(width=width+10*mm, length=length+10*mm);
        translate([0, -1*cm, 0]) cross(5*cm+width, 5*cm+length, 1*cm);
    }
    egg_outline(width=width, length=length);
}

module cross(x, y, thickness){
    union(){
        square([x, thickness], center=true);
        square([thickness, y], center=true);
    }
}
