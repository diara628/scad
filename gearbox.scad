include <materials.scad>
use <involute_gears.scad>

module shaft(len, thickness, printable=false){
    color(Stainless) cylinder(r=thickness/2, h=len);
}

//bevel_gear_pair();

