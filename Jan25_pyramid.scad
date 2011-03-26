use <MCAD/regular_shapes.scad>
include <MCAD/units.scad>

// Dimensions;
height = 45*mm;
width = 60*mm;

square_pyramid(base_x=width, base_y=width, height=height);
