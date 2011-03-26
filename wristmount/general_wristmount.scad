/*
 *  General Wristmount
 *  Copyright (C) 2010 Elmo Mäntynen <elmo.mantynen@iki.fi>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
*/

// Imports:
<openscad/shapes.scad> // GPL shapes library by Catarina Mota

/*
*Description*

This is a general wristmount with a (non)-standard interlocking mechanism for
attaching gadgets with a compatible slot.

Examples include:
	* a pocket size computer (like freerunner, N900), as no-hander gps map etc.
	* a laser for some Buzz Lightyear lasering action
	* a watch (retro ftw!)
*/


// *Parameters*

// Adapt these dimensions for your needs/anatomy

len=30;	//length along the arm

// wrist dimensions:
th=40;	//thickness
wi=55;	//width

// strap dimensions
strapt=5;	//thickness
strapw=15;	//width

// magnet dimensions
magt=2;	//thickness
magr=5;	//radius


/*********************************/

// Magic follows:

module ovalInTube(r, w, t, len,) {
	// r: radius of the outside wall
	// w, t: width and thickness of the inside oval
	// len: lenght of the tube
	difference(){
		cylinder(len, r=r);
		scale([w/(2*r), t/(2*r), 1.1]) translate([0,0,-1]) cylinder(len+2, r=r);
		}
}


module wristBand(t, w, len){
	r=w/2+5; // minimum wall thickness 10mm
	module band(){ovalInTube(r, w, t, len, $fn=100);}
	translate([0, 0, -len/2]) // centering
	difference(){
		band();
		// remove the lower part of the tube by subtracting a box
		translate([-r, 5, -0.5]) cube([2*r, r+1, len+1]);
		// subtract cyliders to make holes:
		for (rot=[-60, -25, 25, 60]){ 
			rotate(rot, [0,0,1]) translate([0,0,len/2]) rotate(90, [1,0,0]) cylinder(r+1, r=len/5);
		}
	}
}


module interfaceShape(len, t, w) {
	difference(){
		translate([0, t/2, 0]) box(w, t, len);
		for (rot=[0, 180]){
			rotate(rot, [0, 1, 0]) rotate(-30, [0,0,1]) translate([11.5,5,0]) box(15,30,len+10);
		}
	}
}


module interfaceSlot(len, magr, magt, neg=false){
	// You can import this to implement this interface in your gadget/mount

	// If neg==true, export the shape suitable for subtracting to make female slot
	// If neg==false (default), gives a shape add for mating with a female slot
	// See finalWristmount for an example use

	// These dimensions are suggestions. Good dimensions to be determined and standardised on
	t=5;	//thickness
	w=15;	//width of the bottom
	//deg=30 hardcoded for now

	module magnetSlot(){translate([0, t-magt, 0]) rotate(-90, [1, 0, 0]) cylinder(magt*2, r=magr);}

	if (neg){
		union(){
			interfaceShape(len, t, w);
			magnetSlot();
		}
	}
	if (!neg) {
		scale([-99/100]) difference(){
			interfaceShape(len, t, w);
			magnetSlot();
		}
	}
}
	

module finalWristmount(){
	difference(){
		wristBand(th, wi, len);
		// subtract the inteface slot:
		translate([0, -(wi/2+5.01), 0]) interfaceSlot(len+1, magr, magt, neg=true);
		// subtract the holes for the strap:
		translate([0, -1, 0]) box(wi*2,strapt,strapw);
	}
}

//finalWristmount();