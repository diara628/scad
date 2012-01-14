// Moon rover

use <MCAD/pins.scad>
use <MCAD/lego_compatibility.scad>

//track();
//translate([ro-h-rw,0,5])rotate([0,0,180/n])
//wheel();
//wheelpeg();
//translate([0,0,W/2])rotate([90,0,45])rover();
translate([0,0,T/2])rotate([0,0,0])rover();
//translate([0,0,-0.5])cube(size=[100,100,1],center=true);



ro=50;// outside radius of track
h=5;// track thickness (difference in radius between inside and outside)
w=15;// track width
t=0.4;// thread width
m=48;// number of teeth around the track
f=0.6;// tooth size ratio (between 0 and 1)
n=12;// number of teeth on wheel
pd=7;// pin diameter
L=123;// length between axels (measured)
W=80;// width of rover
T=11;// thickness of base
$fs=0.5;

pi=3.14159;
ri=ro-h;
ao=pi*2*ri/m;
ai=f*ao;
echo("Inside Diameter = ",2*ri);
rw=(ai+4*t)*n/(2*pi);

module track(){
difference(){
	cylinder(r=ro,h=w,$fn=m);
	for(i=[1:m])rotate([0,0,i*360/m]){
		translate([0,0,-0.03])linear_extrude(height=w+0.06)
			polygon(points=[[ri+t,ai/2-t],[ri+t,t-ai/2],[ro+h/(ai-2*t),0]],paths=[[0,1,2]]);
		translate([ri+t,0,0])cylinder(r=ai/2-t,h=3*w,center=true);
	}
}}

module wheel(){
difference(){
	union(){
		cylinder(r=rw,h=w+2,$fn=n);
		for(i=[1:n])rotate([0,0,i*360/n])
			translate([0,-2*t,0])cube(size=[rw+2*t,4*t,w+2.5]);
		cylinder(r=rw+2*t,h=1,$fn=n);
		translate([0,0,w+1.5])cylinder(r=rw+2*t,h=1,$fn=n);
	}
	for(i=[1:n])rotate([0,0,(i-0.5)*360/n])
		translate([rw,0,1])cylinder(r=ai/2,h=w+0.5);
	pinhole(r=pd/2,h=w+1,tight=false);
}}

module wheelpeg(){
	pinpeg(r=pd/2-0.2,h=2*w+1);
}

module rover(){
difference(){
	union(){
		translate([L/2,0,0])rotate([90,0,0])cylinder(r=T/2,h=80,center=true);
		translate([-L/2,0,0])rotate([90,0,0])cylinder(r=T/2,h=80,center=true);
		for (i = [1, -1]){
			translate([i*(L/2-T/3), 0, -(T-9.5)/2])cube(size=[T/2+0.7,W,9.5],center=true);
		}
		translate([0, 0, -T/2])block(10,14,1,
										//solid_bottom=true, reinforcement=false,
										solid_bottom=false, circular_hole=true, reinforcement=true,
										center=true);
		//rotate([0,0,0])translate([-5,0,20])cube(size=[5,W,40],center=true);
	}
	translate([L/2,W/2,0])rotate([90,0,0])pinhole(r=pd/2,h=w,tight=true);
	translate([-L/2,W/2,0])rotate([90,0,0])pinhole(r=pd/2,h=w,tight=true);
	translate([L/2,-W/2,0])rotate([-90,0,0])pinhole(r=pd/2,h=w,tight=true);
	translate([-L/2,-W/2,0])rotate([-90,0,0])pinhole(r=pd/2,h=w,tight=true);
	translate([L/2, 0, 0]) rotate([90, 0, 0]) cylinder(r=1.15*pd/2, h=W-w*2, center=true);
	translate([-L/2, 0, 0]) rotate([90, 0, 0]) cylinder(r=1.15*pd/2, h=W-w*2, center=true);
	//translate([L/4,0,5])cube(size=[0.5,W-1,2],center=true);
	//translate([-L/4,0,5])cube(size=[0.5,W-1,2],center=true);
	//translate([L/8,0,-5])cube(size=[0.5,W-1,2],center=true);
	//translate([3*L/8,0,-5])cube(size=[0.5,W-1,2],center=true);
	//translate([-3*L/8,0,-5])cube(size=[0.5,W-1,2],center=true);
	//translate([-L/8,0,-5])cube(size=[0.5,W-1,2],center=true);
}}