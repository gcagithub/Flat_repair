// battery + pipe

use <./serial_hull.scad>

multi = 1000; //milimeters

delta = 0.1;

bat_height = 0.4 * multi;
bat_length = 1.2 * multi;
bat_th = 0.1 * multi;

space_wall_bat = 0.96 * multi;
space_wall_pipe = 0.32 * multi;
space_floor_bat = 0.2 * multi;
space_pipes = 0.1 * multi;

pipe_length = space_wall_bat-space_wall_pipe;
pipe_height = space_floor_bat + 0.3 * multi;
pipe_height_low = space_floor_bat + 0.1 * multi;
pipe_d = 0.02 * multi;
pipe_2d = 2*pipe_d;

function batThickness() = bat_th;

module battery() {
    translate([space_wall_bat,bat_th/2,space_floor_bat])
    rotate([90, 0, 0]) {
        color("white") cube([bat_length, bat_height, bat_th]);
    }
}

module round_pipe() {
    translate([pipe_d*2,0,0])
        rotate([0, -90, 90]) {
            wedge(angle=90, extent = pipe_d*3, height = pipe_d)
                rotate_extrude()
                    translate([pipe_2d,0,0]) circle(d=pipe_d, $fn=20);
        }
}

module pipe_top() {
    color("brown") union() {
        translate([0, 0, pipe_height]) round_pipe();
        translate([pipe_2d - delta, 0, pipe_height + pipe_2d])    
            rotate([0,90,0])
                cylinder(d=pipe_d, pipe_length - pipe_2d + delta);
        cylinder(d=pipe_d, pipe_height + delta);
    }
}

module pipe_low() {
   color("brown") union() {
        translate([space_pipes, 0, pipe_height_low - space_pipes])
            round_pipe();
        translate([space_pipes,0,0])
            cylinder(d=pipe_d, pipe_height_low + delta - space_pipes);
        translate([
            pipe_2d - delta + space_pipes,
            0,
            pipe_height_low + pipe_2d- space_pipes])    
                rotate([0,90,0])
                    cylinder(
                        d=pipe_d,
                        pipe_length - pipe_2d - space_pipes + delta);
        }
}


module create_bat() {
   union() {
        battery();
        translate([space_wall_pipe,0,0]) {
            pipe_top();
            pipe_low();
        }
    }
}

create_bat();