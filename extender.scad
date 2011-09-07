include <MCAD/units.scad>

use <MCAD/unregular_shapes.scad>
use <MCAD/regular_shapes.scad>

rod_thickness = 25*mm;

structural_thickness = 5*mm;

beak_size = 3*cm;
beak_lenght = 15*cm;
beak_tip_scale = 0.4;
beak_tip_size = beak_tip_scale*beak_size;


module beak(){
    for (i = [1, -1]){ // Mirroring
        connect_squares([[0, 0, 0], [0, i*beak_size/2, 0], // Base
                         [0, i*.8*beak_size/2, .5*beak_size],
                         [0, 0, .8*beak_size],
                         [beak_lenght, 0, 0], // Tip
                         [beak_lenght, i*beak_tip_size/2, 0],
                         [beak_lenght, i*.8*beak_tip_size/2, .8*beak_tip_size],
                         [beak_lenght, 0, .8*beak_tip_size]]);
    }
}

module connector(){
    translate([-rod_thickness, 0, 0]) cylinder_tube(height=.8*beak_size,
               radius=rod_thickness+structural_thickness, wall=structural_thickness);
}

module assembly(){
    beak();
    connector();
}

assembly();
