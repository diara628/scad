include <MCAD/units.scad>

use <MCAD/regular_shapes.scad>

module base(lenght, w1, w2, base_thickness){
    difference(){
        cylinder(r=w1/2, h=lenght);
        translate([0, 0, (lenght+base_thickness)/2]) oval_torus(inner_radius=w2/2, thickness=[w1-w2, lenght-base_thickness]);
    }
    cylinder(r=w1/2, h=base_thickness);
    translate([0, 0, base_thickness/2]) torus2(r1=w1/2, r2=base_thickness/2);
}

module egg(width, lenght){
    rotate_extrude()
        difference(){
            egg_outline(width, lenght);
            translate([-lenght, 0, 0]) square(2*lenght, center=true);
        }
}

module egg_on_a_pedestal(){
    width=5.5*cm;
    lenght=1.35*width;
    base_lenght = width;
    w1 = width;
    w2 = 10*mm;
    base_thickness=4*mm;
    $fn = 100;

    egg_placement = .84*base_lenght;
    translate([0, 0, egg_placement]) egg(width=width, lenght=lenght);
    difference(){
        base(base_lenght, w1, w2, base_thickness);
        translate([0, 0, egg_placement+1.07*lenght]) cube(lenght*2, center=true);
    }
}

egg_on_a_pedestal();
