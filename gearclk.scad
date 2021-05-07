include <gears.scad>

base_R = 100;
base_bore = 10;
angle_skew = -25;

gear_holder_diam = base_bore * 0.95;
gear_holder_h = 65;

gear0801_1601_m = 100 / 12;
gear0802_1602_m = 60 / 8;
gear0803_2401_m = 40 / 8;
gear0804_2001_m = 44 / 8;
gear0805_1603_m = 100 / 12;
gear0806_2402_m = 50 / 8;
gear0807_1604_m = 62 / 8;

gear_width = 5;

frame_width = 20;
frame_height = 5;

enable_gears = true;
enable_frame = true;
enable_bottom_holders = true;

function angle(ang) = ang + angle_skew;

module helper_circle() {
	translate([0, 0, -20])
		color([0.9, 0.9, 0.9])
			circle(r=base_R);
}

/* 
 * theta = angle at which gear center should be positioned (as in 2d axes plane)
 *
 */
module gear_at_circle(modul, tooth_number, width, bore, pressure_angle = 20, helix_angle = 0, theta, rotation = 0, holders_at=0, holders_r=0) {
	x = base_R * cos(theta);
	y = base_R * sin(theta);

	translate([x, y, 0])
		gear(modul, tooth_number, width, bore, pressure_angle, helix_angle, rotation, holders_at=holders_at, holders_r=holders_r);
}

module gear(modul, tooth_number, width, bore, pressure_angle = 20, helix_angle = 0, rotation=0, holders_at=0, holders_r=0) {
	if (tooth_number < 16) {
		rotate([0, 0, rotation]) {

			if (holders_r != 0) {
				difference(){
					spur_gear(modul, tooth_number, width, bore, pressure_angle, helix_angle, false);
					gear_holder_holes(holders_at, holders_r, width);
				}
			} else {
				spur_gear(modul, tooth_number, width, bore, pressure_angle, helix_angle, false);
			}
		}
	} else {
		D = modul * tooth_number;
		hole_D = 0.6 * D;
		hole_R = hole_D / 2;

		rotate([0, 0, rotation]) {
			difference(){
				spur_gear(modul, tooth_number, width, bore, pressure_angle, helix_angle, false);

				translate([0, 0, -width*0.5])
					cylinder(h=width * 2, r1=hole_R, r2=hole_R);
			}


			if (holders_r != 0) {
				difference(){
					gear_beams(bore, hole_D, width);
					gear_holder_holes(holders_at, holders_r, width);
				}
			} else {
				gear_beams(bore, hole_D, width);
			}
		}
	}
}

module gear_holder_holes(holders_at, holders_r, width) {
	translate([holders_at, 0, -width/2])
		cylinder(h=width * 2, r1=holders_r, r2=holders_r);

	translate([0, holders_at, -width/2])
		cylinder(h=width * 2, r1=holders_r, r2=holders_r);

	translate([-holders_at, 0, -width/2])
		cylinder(h=width * 2, r1=holders_r, r2=holders_r);

	translate([0, -holders_at, -width/2])
		cylinder(h=width * 2, r1=holders_r, r2=holders_r);
}

module gear_beams(bore, hole_D, width) {
	difference() {
		union() {
			translate([0, 0, width/2])
				cube(size=[bore * 2, hole_D, width], center=true);
			rotate([0, 0, 90])
				translate([0, 0, width/2])
					cube(size=[bore * 2, hole_D, width], center=true);
		}

		translate([0, 0, -width*0.5])
			cylinder(h=width*2, r1=bore/2, r2=bore/2);
	}
}

module bottom_frame() {
	linear_extrude(height=frame_height){
		difference(){
			circle(r=base_R + (frame_width / 2));
			circle(r=base_R - (frame_width / 2));
		}
	}

	translate([0, 0, frame_height / 2])
		cube(size=[frame_width, base_R * 2, frame_height], center=true);

	translate([0, 0, frame_height / 2])
		cube(size=[base_R * 2, frame_width, frame_height], center=true);
}

module gear_bottom_holder(pin_at) {
	cylinder(h=gear_holder_h, d=gear_holder_diam);
	translate([0, 0, pin_at])
		cylinder(h=2, d=base_bore*2);
}

module gear_bottom_holder_at_frame(pin_at, theta) {
	x = base_R * cos(theta);
	y = base_R * sin(theta);
	translate([x, y, -2])
		gear_bottom_holder(pin_at);
}

module single_pin() {
	linear_extrude(height=2){
		difference(){
				circle(d=base_bore*2);
				circle(d=gear_holder_diam);
		}
	}
}

module single_pin_at_frame(z, theta) {
	x = base_R * cos(theta);
	y = base_R * sin(theta);
	translate([x, y, z])
		single_pin();
}

module gear_bottom_holders() {
	gear_bottom_holder_at_frame(0, angle(180));
	single_pin_at_frame(gear_width, angle(180));
	single_pin_at_frame(gear_width*2 + 2, angle(180));

	gear_bottom_holder_at_frame(gear_width + 2, angle(127));
	single_pin_at_frame(gear_width*2 + 2, angle(127));
	single_pin_at_frame(gear_width*3 + 4, angle(127));

	gear_bottom_holder_at_frame(gear_width*2 + 4, angle(80));
	single_pin_at_frame(gear_width*3 + 4, angle(80));
	single_pin_at_frame(gear_width*4 + 6, angle(80));

	gear_bottom_holder_at_frame(gear_width*3 + 6, angle(35));
	single_pin_at_frame(gear_width*4 + 6, angle(35));
	single_pin_at_frame(gear_width*5 + 8, angle(35));
}


module gears() {
	gear(gear0801_1601_m, 8, gear_width, base_bore, rotation=22.5);
	gear_at_circle(gear0801_1601_m, 16, gear_width, base_bore, theta=angle(180), holders_at=15, holders_r=3);


	color([0.7, 0, 0])
		translate([0, 0, 2 + gear_width])
			gear_at_circle(gear0802_1602_m, 8, gear_width, base_bore, theta=angle(180), rotation=0, holders_at=15, holders_r=3);
	color([0.7, 0, 0])
		translate([0, 0, 2 + gear_width])
			gear_at_circle(gear0802_1602_m, 16, gear_width, base_bore, theta=angle(127));


	 color([0, 0.7, 0])
		translate([0, 0, 4 + gear_width*2])
			gear_at_circle(gear0803_2401_m, 8, gear_width, base_bore, theta=angle(127), rotation=26);
	 color([0, 0.7, 0])
		translate([0, 0, 4 + gear_width*2])
			gear_at_circle(gear0803_2401_m, 24, gear_width, base_bore, theta=angle(80));
	 
	 
	color([0, 0, 0.7])
		translate([0, 0, 6 + gear_width*3])
			gear_at_circle(gear0804_2001_m, 8, gear_width, base_bore, theta=angle(80), rotation=0);
	color([0, 0, 0.7])
		translate([0, 0, 6 + gear_width*3])
			gear_at_circle(gear0804_2001_m, 20, gear_width, base_bore, theta=angle(35), rotation=0);


	color([0.7, 0.7, 0])
		translate([0, 0, 8 + gear_width*4])
			gear_at_circle(gear0805_1603_m, 8, gear_width, base_bore, theta=angle(35), rotation=8);

	color([0.7, 0.7, 0])
		translate([0, 0, 8 + gear_width*4])
			gear(gear0805_1603_m, 16, gear_width, base_bore, rotation=0);



	// color([0.7, 0, 0.7])
	// 	translate([0, 0, 10 + gear_width*5])
	// 		gear(gear0806_2402_m, 8, gear_width, base_bore, rotation=-7);
	// 
	// color([0.7, 0, 0.7])
	// 	translate([0, 0, 10 + gear_width*5])
	// 		gear_at_circle(gear0806_2402_m, 24, gear_width, base_bore, theta=angle(5));
	// 
	// 
	// 
	// color([0, 0.7, 0.7])
	// 	translate([0, 0, 12 + gear_width*6])
	// 		gear_at_circle(gear0807_1604_m, 8, gear_width, base_bore, theta=angle(5), rotation=30);
	// color([0, 0.7, 0.7])
	// 	translate([0, 0, 12 + gear_width*6])
	// 		gear_at_circle(gear0807_1604_m, 16, gear_width, base_bore, theta=angle(-50.5));
	// 
	// 
	// 
	// 
}

// helper_circle();

if(enable_frame) {
	color([.5, .5, .5])
		translate([0, 0, -2 - frame_height])
			bottom_frame();
}

if (enable_gears) {
	gears();
}

if (enable_bottom_holders) {
	gear_bottom_holders();
}


