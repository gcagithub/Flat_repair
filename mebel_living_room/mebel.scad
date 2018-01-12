use <./room.scad>

// cm
multi = 10;

delta = 0.1 * multi;
panel_th = 1.6 * multi;

meb_width = 50 * multi;
meb_length = 270*multi + 2*(panel_th + delta);

space_door_sm = 2 * delta;

door_th = 1 * multi;

door_vert_width = 43.5 * multi;
door_vert_width_dbl = door_vert_width*2 + space_door_sm;
door_vert_height = 210 * multi;

door_hor_lenght = door_vert_height;
door_hor_width = 40 * multi;

door_middle_height = 50 * multi;
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

cnt = 0;
function counter(i=1) = cnt + 1;

module echo_dimensions(type, width, height){
    echo(type, "ширина|высота (мм)", width, height);
}

/*
    Площадь основания мебельного шкафа
*/
module meb_bg() {
    translate([0,-meb_length, -getWallTh() + delta])
    cube([meb_width, meb_length, getWallTh()]);
}

/*
    Двери боковых шкафов. Всего 4 больших двери.
*/
module door_vert(position = meb_length, c="SandyBrown") {
    color(c) translate([meb_width + delta, -position, panel_h_sm_height]) 
        cube([door_th, door_vert_width, door_vert_height]);
    
    echo_dimensions("Дверь верт", door_vert_width, door_vert_height);
}

/*
    Горизонтальные двери сверху. Всего 2 больших двери.
*/
module door_hor(position = meb_length,
                height = panel_v_height + panel_v_upper_height - door_hor_width,
                c="SandyBrown") {
    color(c)
        translate([meb_width + delta, -position, height])
            cube([door_th, door_hor_lenght, door_hor_width]);
    echo_dimensions("Дверь гориз верх", door_hor_width, door_hor_lenght);
}

/*
    Малая дверь по середине в нижней части.
*/
module door_middle(c="SandyBrown") {
    color(c)
        translate([meb_width + delta,
            -meb_length+door_vert_width_dbl+delta,
            panel_h_sm_height + delta])
            cube([door_th, door_middle_lenght, door_middle_height]);
    echo_dimensions("Дверь малая средняя", door_middle_height, door_middle_lenght);
    
}

/*
    Боковая большая вертикальная панель. Всего 4 панели.
*/
module panel_vert(position = meb_length,
                    c="NavajoWhite") {
    color(c) translate([0, -position, 0])
        cube([panel_v_width, panel_th, panel_v_height]);
    echo_dimensions("Панель верт большая", panel_v_width, panel_v_height);
}

/*
    Передняя горизонтальная маленькая панель внизу. Закрывает
    ножки. Всего 3 таких панели.
*/
module panel_h_sm(position = meb_length-panel_th,
                    lenght=panel_h_sm_width,
                    c="NavajoWhite") {
    color(c) translate([meb_width-panel_th-delta, -position + delta, 0]) 
        cube([panel_th, lenght, panel_h_sm_height]);
    echo_dimensions("Панель гориз ножки", panel_h_sm_height, lenght);

}

/*
    Горизонтальная панель в закрытой части шкафа. Формирует
    верхний и нижний каркас шкафа с дверями.
*/
module panel_h_md(position = meb_length-panel_th,
                    height = panel_h_sm_height + delta, c="BurlyWood") {
    color(c) translate([0, -position + delta, height]) 
        cube([panel_h_md_width, panel_h_md_length, panel_th]);
    echo_dimensions("Панель гориз внутр шкафа", panel_h_md_width, panel_h_md_length);

}

/*
    Полка в средней нижней части.
*/
module panel_middle(position=meb_length-door_vert_width_dbl,
                    height=panel_h_sm_height + delta,
                    c="BurlyWood") {
    lenght = meb_length - 2*door_vert_width_dbl -2*delta;
    color(c) translate([0, -position + delta, height]) 
        cube([meb_width, lenght, panel_th]);
    echo_dimensions("Полка по середине", meb_width, lenght);

}

/*
    Большая горизонтальная панель в верхней части.
*/
module panel_hor(height=panel_v_height, c="BurlyWood") {
    color(c) translate([0, -panel_h_length - panel_th - delta, height]) 
        cube([panel_h_width, panel_h_length, panel_th]);
    echo_dimensions("Панель гориз длинная верх", panel_h_width, panel_h_length);
}

/*
    Боковая панель в верхней части. Всего 2 панели.
*/
module panel_vert_upper(position = meb_length,
                        c="NavajoWhite") {
    color(c) translate([0, -position, panel_v_height])
        cube([panel_v_upper_width, panel_th, panel_v_upper_height]);
    echo_dimensions("Панель боковая верх", panel_v_upper_width,
                            panel_v_upper_height);
}

/*
    Пергородкв в верхней части.
*/
module panel_vert_inner(position=meb_length-door_vert_width_dbl,
                        position_vert = (panel_v_height + delta 
                            + panel_th),
                        height,
                        c="BurlyWood") {
    color(c)
    translate([0, - position - panel_th, position_vert])
            cube([meb_width, panel_th, height]);
    echo_dimensions("Перегородка верх", meb_width, height);
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
        panel_upper_vertpos = panel_v_height+panel_v_upper_height;
        panel_hor(panel_upper_vertpos-panel_th);
        panel_hor(panel_upper_vertpos-door_hor_width-panel_th-delta);
        panel_hor(panel_upper_vertpos-2*door_hor_width-delta);

        panel_hor();
        
        panel_vert_upper();
        panel_vert_upper(panel_th);
        
    
        panel_vert_inner_sm_height = panel_v_upper_height - 
                            2*door_hor_width - panel_th - 3*delta;
        panel_vert_inner(height=panel_vert_inner_sm_height);
        panel_vert_inner(door_vert_width_dbl-panel_th,
            height=panel_vert_inner_sm_height);
}

module panel_upper_group_2() {
        panel_hor();    
        panel_hor(panel_v_height+door_hor_width + delta - panel_th);
        panel_hor(panel_v_height+2*door_hor_width + 2*delta - panel_th);
        panel_hor(panel_v_height+panel_v_upper_height - panel_th);
        
        panel_vert_upper();
        panel_vert_upper(panel_th);
        
        panel_vert_inner_sm_height = panel_v_upper_height - 
                            2*door_hor_width - panel_th - 4*delta;
        panel_vert_inner_sm_vertpos = panel_v_height
            +2*door_hor_width + 3*delta;
        panel_vert_inner(position_vert=panel_vert_inner_sm_vertpos,
            height=panel_vert_inner_sm_height);
        panel_vert_inner(position=door_vert_width_dbl-panel_th,
            position_vert=panel_vert_inner_sm_vertpos,
            height = panel_vert_inner_sm_height);
        
        // Internal partition behind horiz upper doors
        // 1. Left
        panelVertInnerHeight1 = door_hor_width - 2*panel_th - 2*delta
            + delta;
        panelVertInnerPositionVer1 = panel_v_height + panel_th + delta;
        panelVertInnerPositionHor1 = meb_length -
            (meb_length-door_hor_lenght)/2 - panel_th;
        panel_vert_inner(
            position = panelVertInnerPositionHor1,
            position_vert = panelVertInnerPositionVer1,
            height=panelVertInnerHeight1);
        // 2. Left upper
        panelVertInnerPositionVer2 = panel_v_height + 2*delta
            + door_hor_width;
        panelVertInnerHeight2 = door_hor_width - panel_th - delta;
            
        panel_vert_inner(
            position = panelVertInnerPositionHor1,
            position_vert = panelVertInnerPositionVer2,
            height=panelVertInnerHeight2);
            
        // 3. Right
        panelVertInnerPositionHor3 = (meb_length-door_hor_lenght)/2;
        panel_vert_inner(
            position = panelVertInnerPositionHor3,
            position_vert = panelVertInnerPositionVer1,
            height=panelVertInnerHeight1);
        // 4. Right upper
        panelVertInnerPositionVer4 = panel_v_height + 2*delta
            + door_hor_width;
        panel_vert_inner(
            position = panelVertInnerPositionHor3,
            position_vert = panelVertInnerPositionVer2,
            height=panelVertInnerHeight2);
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

color("wheat") create_room(n=false, w=true ,e=true,s=false);
bat();
color("green") meb_bg();
create_doors();
create_panels();