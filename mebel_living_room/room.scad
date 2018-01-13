use <./bat.scad>

multi = 1000; //millimeters

delta = 0.1;
delta2 = delta * 2;
delta3 = delta * 3;

room_length = 4.94 * multi;
room_width = 2.93 * multi;
room_height = 3.20 * multi;

wall_th = 0.2 * multi;

coord_floor = [room_length, room_width, wall_th];
coord_north_wall = [room_height, room_width, wall_th];

space_door_wall = 0.7 * multi;
space_balk_door_step = 0.21 * multi;
space_floor_window = 0.75 * multi;
space_window_balk_door = 0.05 * multi;
space_floor_door = 0 * multi;
space_wall_bat = 0.04 * multi + batThickness()/2;

trans_floor = [0, -room_width, -wall_th];
trans_north_wall = [0, -room_width, 0];
trans_south_wall = [room_length + wall_th, -room_width, 0];
trans_west_wall = [0, -room_width-wall_th, 0];
trans_east_wall = [0, 0, 0];
trans_door = [space_door_wall, -delta, space_floor_door];

width_door = 0.9 * multi;
width_balk_door = 0.7 * multi;
width_window = 2 * multi;

height_door = 2.06 * multi;
height_balk_door = 1.96 * multi;
height_window = 1.43 * multi;

function getRoomLength() = room_length;
function getRoomWidth() = room_width;
function getRoomHeight() = room_height;
function getSpaceWallBat() = space_wall_bat;
function getWallTh() = wall_th;

module room_floor() {
    translate (trans_floor) cube(coord_floor);
}

module north_wall(trans) {
    translate(trans) rotate([0, -90, 0]) cube(coord_north_wall); 
}

module west_wall(trans) {
    translate(trans) cube([room_length, wall_th, room_height]);
}

module door(trans, width, height = height_door) {
    translate(trans) cube([width, wall_th + delta2, height]);
}

module balk_door() {
    door([
         space_door_wall+width_window+space_window_balk_door,
        -room_width - wall_th - delta, space_balk_door_step
        ],
        width_balk_door, height=height_balk_door
    );
}

module window() {
    translate([space_door_wall, -room_width - wall_th - delta, space_floor_window])
        cube([width_window, wall_th + delta2, height_window]);
}

module bat() {
    translate([0,-room_width + space_wall_bat,0]) create_bat();
}

module create_room(f=true, n=true, s=true, w=true, e=true ) {
    if(f) room_floor();
    if(n) north_wall(trans_north_wall);
    if(s) north_wall(trans_south_wall);
    
    if(w) {
        difference() {
            west_wall(trans_west_wall);
            union() {
                #window();
                balk_door();
            }
        }
    }
    
    if(e) {
        difference() {
            west_wall(trans_east_wall);
            door(trans_door, width_door);
        }
    }

}

color("wheat") create_room(e=true, s=true);
bat();



