use <./room.scad>

// cm
multi = 10;

delta = 0.1 * multi;
panel_th = 1 * multi;

meb_width = 50 * multi;
meb_length = 270*multi + 2*(panel_th + delta);

space_door_sm = 0.5 * multi;

door_th = 1 * multi;

door_vert_width = 43.5 * multi;
door_vert_width_dbl = door_vert_width*2 + space_door_sm;
door_vert_height = 196 * multi;

door_hor_lenght = door_vert_height;
door_hor_width = 39 * multi;

door_middle_height = 45 * multi;
door_middle_lenght = meb_length-2*door_vert_width_dbl-2*delta;

panel_h_sm_width = door_vert_width_dbl - 2*panel_th - 2*delta;
panel_h_sm_height = 10 * multi;

panel_v_width = meb_width;
panel_v_height = panel_h_sm_height+door_vert_height;

panel_h_md_width = meb_width;
panel_h_md_length = panel_h_sm_width;

panel_h_width = meb_width;
panel_h_length = 270*multi;

panel_v_upper_height = getRoomHeight()-panel_v_height-delta;
panel_v_upper_width = meb_width;

echo("Середина = ", meb_length-2*door_vert_width_dbl-2*delta);

module meb_bg() {
    translate([0,-meb_length, -getWallTh() + delta])
    cube([meb_width, meb_length, getWallTh()]);
}

module door_vert(position = meb_length, c="SandyBrown") {
    color(c) translate([meb_width + delta, -position, panel_h_sm_height]) 
        cube([door_th, door_vert_width, door_vert_height]);
}

module door_hor(position = meb_length,
                height = panel_v_height + panel_v_upper_height - door_hor_width,
                c="SandyBrown") {
    color(c)
        translate([meb_width + delta, -position, height])
            cube([door_th, door_hor_lenght, door_hor_width]);
}

module door_middle(c="SandyBrown") {
    color(c)
        translate([meb_width + delta,
            -meb_length+door_vert_width_dbl+delta,
            panel_h_sm_height + delta])
            cube([door_th, door_middle_lenght, door_middle_height]);
    
}

module panel_vert(position = meb_length,
                    c="NavajoWhite") {
    color(c) translate([0, -position, 0])
        cube([panel_v_width, panel_th, panel_v_height]);
}

module panel_h_sm(position = meb_length-panel_th,
                    lenght=panel_h_sm_width,
                    c="NavajoWhite") {
    color(c) translate([meb_width-panel_th-delta, -position + delta, 0]) 
        cube([panel_th, lenght, panel_h_sm_height]);

}

module panel_h_md(position = meb_length-panel_th,
                    height = panel_h_sm_height + delta, c="BurlyWood") {
    color(c) translate([0, -position + delta, height]) 
        cube([panel_h_md_width, panel_h_md_length, panel_th]);

}

module panel_middle(position=meb_length-door_vert_width_dbl,
                    height=panel_h_sm_height + delta,
                    c="BurlyWood") {
    color(c) translate([0, -position + delta, height]) 
        cube([meb_width, meb_length - 2*door_vert_width_dbl -2*delta, panel_th]);

}

module panel_hor(height=panel_v_height, c="BurlyWood") {
    color(c) translate([0, -panel_h_length - panel_th - delta, height + delta]) 
        cube([panel_h_width, panel_h_length, panel_th]);
}


module panel_vert_upper(position = meb_length,
                        c="NavajoWhite") {
    color(c) translate([0, -position, panel_v_height + delta])
        cube([panel_v_upper_width, panel_th, panel_v_upper_height]);
}

module panel_vert_inner(position=meb_length-door_vert_width_dbl,
                        position_vert = (panel_v_height + 2*delta 
                            + panel_th),
                        c="BurlyWood") {
    height=panel_v_upper_height - 
           2*door_hor_width - panel_th - 2*delta -2*delta;
    color(c)
    translate([0, - position - panel_th, position_vert])
            cube([meb_width, panel_th, height]);
}

module door_hor_group_1() {
        position = meb_length - (meb_length-door_hor_lenght)/2;
        door_hor(position);
        door_hor(position,
                    panel_v_height + panel_v_upper_height - 
                        2*door_hor_width -  delta);

}

module door_hor_group_2() {
    position = meb_length - (meb_length-door_hor_lenght)/2;
    door_hor(position,
                    panel_v_height + delta);
    door_hor(position, height=panel_v_height+door_hor_width+2*delta);
        
}

module panel_upper_group_1() {
        panel_hor(getRoomHeight()-delta-panel_th);
        panel_hor(getRoomHeight()-door_hor_width - delta - panel_th);
        panel_hor(getRoomHeight()-2*door_hor_width - 2*delta);
        //#panel_hor(getRoomHeight()-2*panel_v_upper_height/3-panel_th);
        panel_hor();
        
        panel_vert_upper();
        panel_vert_upper(panel_th);
        
        panel_vert_inner();
        panel_vert_inner(door_vert_width_dbl-panel_th);
}

module panel_upper_group_2() {
        panel_hor();    
        panel_hor(panel_v_height+door_hor_width + delta - panel_th);
        panel_hor(panel_v_height+2*door_hor_width + delta - panel_th);
        panel_hor(panel_v_height+panel_v_upper_height - delta - panel_th);
        
        panel_vert_upper();
        panel_vert_upper(panel_th);
        
        panel_vert_inner(position_vert=panel_v_height
            +3*delta+2*door_hor_width);
        panel_vert_inner(position=door_vert_width_dbl-panel_th,
                            position_vert=panel_v_height
            +3*delta+2*door_hor_width);
}

module create_doors() {
    door_vert(meb_length);
    door_vert(meb_length - door_vert_width - space_door_sm);
    door_vert(door_vert_width*2 + space_door_sm);
    door_vert(door_vert_width);
  
    door_hor_group_2();
    
    door_middle();
}

module create_panels() {
    panel_vert(meb_length);
    panel_vert(meb_length - door_vert_width_dbl + panel_th);
    panel_vert(door_vert_width_dbl);
    panel_vert(panel_th);
    
    panel_h_sm(meb_length-panel_th);
    panel_h_sm(position=meb_length-door_vert_width_dbl,
                lenght=meb_length-2*(door_vert_width_dbl)-2*delta);
    panel_h_sm(door_vert_width_dbl-panel_th);
    
    panel_h_md();
    panel_h_md(height=panel_v_height-panel_th);
    panel_h_md(position=door_vert_width_dbl-panel_th);
    panel_h_md(height=panel_v_height-panel_th,
                position=door_vert_width_dbl-panel_th);
    
    panel_upper_group_2();
    
    panel_middle();
    panel_middle(height=panel_h_sm_height+
                    door_middle_height-panel_th+delta);
    pan_mid_h = panel_h_sm_height+
                    door_middle_height-panel_th+delta;
    panel_middle(height=pan_mid_h+door_middle_height/2);
    panel_middle(height=panel_h_sm_height
                    +2*delta+2*door_middle_height);
}

color("wheat") create_room(n=true, w=true ,e=true,s=false);
bat();
color("green") meb_bg();
create_doors();
create_panels();