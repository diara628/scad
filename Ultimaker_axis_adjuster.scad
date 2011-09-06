use <MCAD/triangles.scad>

// Parameters:
thickness = 10;
lenght = 50;

// Magic numbers:
a = 23;
b = 6;
c = 5;
d = 8;
//e = 0; //x axis
e = 32.95; //y axis
g = b+2*c;
f = c+e+d;

module t(){
  mirror([1, 0, 0]) rotate([0, 0, 90]) translate([-.01, -.01, -.01]) triangle(lenght+.01, f-g+.01, thickness+.02);
}

union(){
  translate([-a-lenght/2+.02, 0, 0]) difference(){
    cube([a, g, thickness]);
    translate([-.01, c, -1]) cube([a, b, thickness+2]);
  }
  translate([-lenght/2, -f+g, 0]) difference(){
    cube([lenght, f, thickness]);
    t();
    translate([lenght, f, 0]) rotate([0, 0, 180]) t();
  }
  translate([lenght/2-.02, -f+g, 0]) difference(){
    cube([d+c, g, thickness]);
    translate([.01, -.01, -1]) cube([d, d+3, thickness+2]);
  }
}

