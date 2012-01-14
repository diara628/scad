include <MCAD/units.scad>
use <MCAD/utilities.scad>

grape_height = 25*mm;
grape_dia = 15*mm;
structural_thickness = 3*mm;

grape_splitter();

module grape_splitter(inner_dia=grape_dia, inner_height=grape_height*7){
  difference(){
    cylinder(r=inner_dia/2+structural_thickness, h=inner_height+structural_thickness*2, center=true);
    spin(no=2, angle=180, axis=[1, 0, 0]){
      translate([0, 0, (inner_height-inner_dia)/2]) sphere(r=inner_dia/2, center=true);
    }
    cylinder(r=inner_dia/2, h=inner_height-inner_dia, center=true);
    spin(no=2, angle=90){
      translate([0, 0, structural_thickness])
        cube([inner_dia-structural_thickness*3, inner_dia+structural_thickness*4,
              inner_height+structural_thickness*2], center=true);
		}
    translate([0, 0, inner_height/2+1])
      cylinder(r=inner_dia*0.8/2, h=structural_thickness*4, center=true);
  }
}
