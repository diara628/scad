/* *Label Dispenser*
 *
 * Copyright (C) 2011: Erik/Ultimaker, Elmo Mäntynen
 * GPL 2.1
 */

use <MCAD/regular_shapes.scad>
//use <MCAD/transformations.scad>

// Parameters:
label_width = 29; // This is the most important one
min_dx = 80;
min_height = 63;
drum_dia = 33;
wall_thickness = 4;


// Create a roll holder?
inner_roll_holder = true;
//inner_roll_holder = false;

max_roll_OD = 30;
min_roll_ID = 10;

// Use a roller?
roller = true;
//roller = false;


// A switch for orienting and placing for printing or demoing:
mode = "demo";
//mode = "print";


if (mode == "print") {
rotate([90, 0, 0]) dispenser();
} else {
dispenser();
}

dx = inner_roll_holder ? max(max_roll_OD+drum_dia+wall_thickness*2, min_dx) : min_dx;
height = inner_roll_holder ? max(max_roll_OD+drum_dia/2+wall_thickness*2, min_height) : min_height;

width = label_width + wall_thickness*2;
drum_placement = [drum_dia/2,width,height-wall_thickness*3/2-drum_dia/2];
axle_side = sqrt(pow(min_roll_ID-4-0.1, 2)/2);
guard_rotation = 25;


module dispenser()
{
difference()
{
  union()
  {
    intersection()
    {
      drum();
      body();
    }
    ensemble();
  }
  slot(rear=!inner_roll_holder);
  translate([10,wall_thickness,height-wall_thickness*4]) rotate([0,-20,0])
    cube([11,width,wall_thickness*4]);
  roll_guard(mode="negative");
}

if (inner_roll_holder)
{
  //add roll holder
 roll_holder();
 roll_guard();
} else
{
  // add a guide
  rotate([0,8,0]) translate([23,0,height-7])
    cube([dx-31,width,1]);
}
}


plate_offset = [drum_dia/2+drum_placement[0]-wall_thickness, 0, 3];
plate_size = [dx-plate_offset[0], wall_thickness-1, drum_placement[2]];
axle_placement = plate_offset + [plate_size[0]/2, 0, plate_size[2]/2];

module roll_holder(mode=mode)
{

roller_placement = mode == "demo" ? axle_placement :
                   mode == "print"? [min_roll_ID-1, -wall_thickness, height+4-min_roll_ID] :
                   false;

echo(str("Rolls with OD < ", min(plate_size[0], plate_size[2])-wall_thickness*2, " and ID > ",
     min_roll_ID, " should fit"));

union()
{

  translate(plate_offset)
    cube(plate_size);
  translate([0, width/2, 0]) union()
  {
    translate(axle_placement) rotate([0, guard_rotation, 0])
      cube([axle_side, width, axle_side], center=true);
    if (roller != false)
    {
      color([0.5, 1, 0]) translate(roller_placement) rotate([90,0,0])
        cylinder_tube(height=width-2*wall_thickness, radius=min_roll_ID/2,
                      wall=2, center=true, $fn=50);
    }
  }
}
}

module roll_guard(mode=mode, thickness=wall_thickness/2, rotation = guard_rotation)
{
  scale = mode == "negative" ? [1.0, 5, 1] : [1, 1, 1];
  mode = mode == "negative" ? "demo" : mode;
  placement = mode == "demo" ? axle_placement + [0, width-wall_thickness, 0]:
              mode == "print"? [0, 0, height-10-min_roll_ID] :
              [0, 0, 0];

  rotation = mode == "demo" ? rotation : 100;

  translate(placement + [0, scale[1]*thickness/2, 0])
    scale(scale)  rotate([90, rotation, 0]) difference()
    {
      color([0.1, 0.3, 0]) union()
      {
        cube([plate_size[0]*1.25, thickness, thickness], center=true);
        cylinder(r=min_roll_ID, h=thickness, center=true);
      }
      cube([axle_side, axle_side, thickness*2], center=true);
    }
}

module drum()
{
  difference()
  {

    drum_part(diameter=drum_dia-4,width=width-wall_thickness);
    translate([0,wall_thickness,0])
      drum_part(diameter=drum_dia-10);
  }
}

module ensemble()
{
union()
{
  difference()
  {
  body();
  translate([0,wall_thickness,0])
    drum_part();

  cutout();
  }
  difference()
  {
    intersection()
    {
      body();
      drum_part(diameter=drum_dia+(wall_thickness)*2);
    }
    translate([0,0.1,0])
      drum_part(width=width-wall_thickness);

  }
  foot(dx,width,3);

}

}

module drum_part(diameter=drum_dia, width=width)
{
translate(drum_placement) rotate([90,0,0])
  cylinder(r=diameter/2,h=width);
}

function scaling_factor(dimension) = (dimension-wall_thickness*2)/dimension;

module cutout()
{
reference = [dx/2, width/2, height/2];
translate([wall_thickness,-0.1,wall_thickness])
//translate(reference)
//scale([scaling_factor(dx),1.2,scaling_factor(width)])
  //translate(-reference)
  body(scaling_factor(dx)*dx, 1.2*width, scaling_factor(height)*height);
}

module body(dx=dx, width=width, height=height)
{
intersection()
{
cube([dx,width,height]);
rotate([0,15,0]) cube([dx*2,width,height*2]);
}
}

module slot(rear=true)
{
rotate([0,12,0]) translate([-dx/2,wall_thickness,height-wall_thickness+3]) cube([dx,label_width,1]);
if (rear == true)
{
  translate([dx-30/2,wall_thickness,height-16]) cube([30,label_width,4]);
}
}

module foot(l,w,h)
{
  translate([-1,0,0]) cube([l+3,w,h]);
}
