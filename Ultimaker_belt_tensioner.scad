belt_width = 6;
bolt_diameter = 3;
thickness = 5;
belt_clearance = 5.5;
rod_clearance = 6.5;
lenght = 31 + 2*thickness;
a = 6.5;

width = belt_width + 2*thickness;
height = thickness*2 + a;
bolt_clearance = thickness/2;

module bolt(placement){
  translate(placement+[0, 0, -height]) cylinder(r=bolt_diameter/2, h=height*2, $fn=10);
}

translate([-width/2, -lenght/2, 0]) difference(){
  cube([width, lenght, height]);
  translate([-1, thickness, thickness]) cube([width*2, lenght, height]);
  translate([thickness, -.01, -.01]) cube([belt_width, lenght+1, height-thickness]);
  bolt([bolt_clearance, lenght-bolt_clearance, 0]);
  bolt([width-bolt_clearance, lenght-bolt_clearance, 0]);
}

translate([-thickness/2, -width/2, 0]) 
difference(){
  cube([thickness, width, thickness], 0);
  bolt([bolt_clearance, bolt_clearance, 0]);
  bolt([bolt_clearance, width-bolt_clearance, 0]);
}

echo(str("Required bolt lenght about ", height+2));
