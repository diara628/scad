// LABEL PEELER //

use <MCAD/regular_shapes.scad>

// Parameters:
drum_dia = 34;
label_width = 29;
d = 80;
h = 83;
thickness_y = 5;

// create a roll holder:
inner_roll_holder = true;

max_roll_OD = 50;
min_roll_ID = 10;

//roller = "demo";
roller = "print";
//roller = false;

rotate([90, 0, 0]) dispenser();

w = label_width + thickness_y*2;
drum_placement = [drum_dia/2,w,40];
axle_side = sqrt(pow(min_roll_ID-4-0.1, 2)/2);
guard_rotation = 10;

module dispenser()
{
difference()
{
  ensemble();
  slot(rear=!inner_roll_holder);
  translate([8,+thickness_y,52]) rotate([0,-20,0])
    cube([11,w,10]);
  roll_guard(mode="negative");
}
intersection()
{
  drum();
  body();
}

if (inner_roll_holder)
{
  //add roll holder
 roll_holder();
 roll_guard();
} else
{
  // add a guide
  rotate([0,8,0]) translate([23,0,h-27])
    cube([d-31,w,1]);

}
}


plate_offset = [drum_dia/2+drum_placement[0], 0, 3];
plate_size = [d-plate_offset[0], thickness_y, drum_placement[2]];
axle_placement = plate_offset + [plate_size[0]/2, 0, plate_size[2]/2];

module roll_holder(mode=roller)
{

roller_placement = mode == "demo" ? axle_placement :
                   mode == "print"? [min_roll_ID-1, -thickness_y, h-16-min_roll_ID] :
                   false;

echo(str("Rolls with OD < ", plate_size[0], " and ID > ",
     min_roll_ID+2, " should fit"));

union()
{

  translate(plate_offset)
    cube(plate_size);
  translate([0, w/2, 0]) union()
  {
    translate(axle_placement) rotate([0, guard_rotation, 0])
      cube([axle_side, w, axle_side], center=true);
    if (roller_placement != false)
    {
      color([0.5, 1, 0]) translate(roller_placement) rotate([90,0,0])
        cylinder_tube(height=w-2*thickness_y, radius=min_roll_ID/2,
                      wall=2, center=true, $fn=50);
    }
  }
}
}

module roll_guard(mode=roller, thickness=thickness_y/2, rotation = guard_rotation)
{
  scale = mode == "negative" ? [1.0, 5, 1] : [1, 1, 1];
  mode = mode == "negative" ? "demo" : mode;
  placement = mode == "demo" ? axle_placement + [0, w-thickness_y, 0]:
              mode == "print"? [0, 0, h-30-min_roll_ID] :
              [0, 0, 0];

  rotation = mode == "demo" ? rotation : 100;

  translate(placement + [0, scale[1]*thickness/2, 0])
    scale(scale)  rotate([90, rotation, 0]) difference()
    {
      color([0.1, 0.3, 0]) union()
      {
        cube([plate_size[0]*1.2, thickness, thickness], center=true);
        cylinder(r=min_roll_ID, h=thickness, center=true);
      }
      cube([axle_side, axle_side, thickness*2], center=true);
    }
}

module drum()
{
  difference()
  {

    drum_part(diameter=drum_dia-4,width=w-thickness_y);
    translate([0,thickness_y,0])
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
  translate([0,thickness_y,0])
    drum_part();

  cutout();
  }
  difference()
  {
    intersection()
    {
      body();
      translate([0,0,0])
        drum_part(diameter=drum_dia+(thickness_y-1)*2);
    }
    translate([0,0.99,0])
      drum_part(width=w-thickness_y+1);

  }
  foot(d,w,3);

}

}

module drum_part(diameter=drum_dia, width=w)
{
translate(drum_placement) rotate([90,0,0])
  cylinder(r=diameter/2,h=width);
}

module cutout()
{
 scale([0.9,1.2,0.9]) translate([thickness_y,-0.1,thickness_y])
  body();
}

module body()
{
intersection()
{
cube([d,w,h-20]);
rotate([0,15,0]) cube([d,w,h]);
}
}

module slot(rear=true)
{
rotate([0,5,0]) translate([8,thickness_y,h-21]) cube([40,label_width,1]);
if (rear == true)
{
  translate([w+30,thickness_y,h-36]) cube([30,label_width,6]);
}
}

module foot(l,w,h)
{
  translate([-1,0,0]) cube([l+3,w,h]);
}
