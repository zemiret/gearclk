include <gears.scad>

base_R = 100;
base_bore = 10;
angle_skew = -35;

gear0801_1601_m = 100 / 12;
gear0802_1602_m = 55 / 8;
gear0803_2401_m = 31 / 8;
gear0804_2001_m = 31 / 8;
gear0805_1603_m = 100 / 12;

gear_width = 5;

function angle(ang) = ang + angle_skew;

module helper_circle() {
	translate([0, 0, -20])
		color([0.9, 0.9, 0.9])
			circle(d=2*base_R);
}

/* 
 * theta = angle at which gear center should be positioned (as in 2d axes plane)
 *
 */
module gear_at_circle(modul, tooth_number, width, bore, pressure_angle = 20, helix_angle = 0, optimized = false, theta, rotation = 0) {
	x = base_R * cos(theta);
	y = base_R * sin(theta);

	translate([x, y, 0])
		gear(modul, tooth_number, width, bore, pressure_angle, helix_angle, optimized, rotation);
}

module gear(modul, tooth_number, width, bore, pressure_angle = 20, helix_angle = 0, optimized = false, rotation=0) {
	rotate([0, 0, rotation])
		spur_gear(modul, tooth_number, width, bore, pressure_angle, helix_angle, optimized);
}

module bottom_frame() {

}

helper_circle();

bottom_frame() {
	difference(
		
	);
}

gear(gear0801_1601_m, 8, gear_width, base_bore, rotation=22.5);
gear_at_circle(gear0801_1601_m, 16, gear_width, base_bore, theta=angle(180));

color([0.7, 0, 0])
	translate([0, 0, 2 + gear_width])
		gear_at_circle(gear0802_1602_m, 8, gear_width, base_bore, theta=angle(180), rotation=-5);
color([0.7, 0, 0])
	translate([0, 0, 2 + gear_width])
		gear_at_circle(gear0802_1602_m, 16, gear_width, base_bore, theta=angle(131.5));

color([0, 0.7, 0])
	translate([0, 0, 4 + gear_width*2])
		gear_at_circle(gear0803_2401_m, 8, gear_width, base_bore, theta=angle(131.5), rotation=26);
color([0, 0.7, 0])
	translate([0, 0, 4 + gear_width*2])
		gear_at_circle(gear0803_2401_m, 24, gear_width, base_bore, theta=angle(95.5));

color([0, 0, 0.7])
	translate([0, 0, 6 + gear_width*3])
		gear_at_circle(gear0804_2001_m, 8, gear_width, base_bore, theta=angle(95.5), rotation=0);
color([0, 0, 0.7])
	translate([0, 0, 6 + gear_width*3])
		gear_at_circle(gear0804_2001_m, 20, gear_width, base_bore, theta=angle(64), rotation=0);


translate([0, 0, 8 + gear_width*4])
	gear_at_circle(gear0805_1603_m, 8, gear_width, base_bore, theta=angle(64), rotation=20.0);

translate([0, 0, 8 + gear_width*4])
	gear(gear0805_1603_m, 16, gear_width, base_bore, rotation=0);
