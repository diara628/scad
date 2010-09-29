// Grooved Insulator Mount Adapter #3
// by Tony Buser <tbuser@gmail.com>
// uses teardrop module by Erik de Bruijn <info@erikdebruijn.nl>
// GPLv2 or later

// set them slightly larger if printer isn't perfect
barrel_diameter = 16.6; // 16 + .6
barrel_inset_diameter = 13.2; // 13 + .2

plate_length = barrel_diameter+1;
plate_width = barrel_diameter+1;

// probably don't want to touch the height
plate_height = 5;

// mounting bolts will need to be 15mm long?
mounting_bolt_diameter = 4;

mounting_bolt_head_diameter = 8;

// single horizontal bolt to clamp and hold insulator in place
// will need to be around 45mm long?
clamp_bolt_diameter = 4;

$fn = 32;

module and(){
	difference(){
		child(0);
		difference(){
			child(0);
			child(1);
		}
	}
}

module plate() {
	difference() {
		cube([plate_length, plate_width, plate_height/2]);

		// barrel inset
		translate([plate_length/2, plate_width/2, -1]) {
			cylinder(r=barrel_inset_diameter/2, h=plate_height/2+2);
		}


		// clamp bolt		
//		translate([-1, plate_width/2-barrel_inset_diameter/2-clamp_bolt_diameter/2, plate_height/2-clamp_bolt_diameter/2]) {
//			rotate([0, 90, 0]) {
//				teardrop(clamp_bolt_diameter/2, plate_length+2, false);
//			}
//		}
	}
}

module cutout() {
	intersection() {
		// carve a curve around the border
//		union() {
//			translate([plate_length/2, plate_width/2/2, -1]) {
//				cylinder(r=plate_length/2, h=plate_height+2);
//			}
//			translate([0, -plate_width/2/2-plate_width/2, -1]) {		
//				cube([plate_length, plate_width, plate_height+2]);
//			}
//		}

		difference() {
			plate();


			// bottom cutout
			translate([plate_length/2-barrel_inset_diameter/2, -1, -1]) {
				cube([barrel_inset_diameter, plate_width/2+1, plate_height/2+2]);
			}
		}
	}
}

module print() {	
	// center and orient it to print correctly
	translate([-plate_length/2, -plate_width/2, 0]) cutout();
}

module base(){
	union(){
		difference(){
			translate([-28.5, 25, -30.5])
				rotate([0, 0, -90])
				translate([0, 0, 0]) import_stl("base.stl", convexity = 5);
			translate([0, plate_width/4+1, -1]) {
				cube([barrel_diameter, plate_width/2+2, 11], center=true);
			}
		}
		rotate ([0, 0, 180]) translate([-plate_length/2, -plate_width/2, 0]) cutout();
	}
}

module separator() {
	translate([0, 1.5, -1]) cube([barrel_diameter+2, plate_width+3, 10.9], center=true);
}

module separate(base=false){
	if (base==true) {
		difference(){
			base();
			separator();
		}
	}
	if (base==false) {
		intersection(){
			base();
			separator();
		}
	}
}

separate();
//separate(base=true);

//plate();
//cutout();
//print();
