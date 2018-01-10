//serial_hull() {
//    cube(10, center=true);
//    translate([20,0,0]) sphere(10);
//    translate([30,0,0]) sphere(5);
//}


module serial_hull() {
    for(i=[0:$children-2]) {
        hull() {
            children(i);
            children(i+1);
        }
    }
}

module wedge(angle, extent=100, height=100, center=true) {
    module wedge_if(sub) {
        rotate([0,0,(angle > sub ? sub : angle)])
            translate([0,0,(center==true ? -height/2 : 0)])
                cube([extent,0.1,height]);
    }
    
    module wedge_wall() {
        for(r=[0:45:angle-1])
        rotate([0,0,r])
            translate([0,0,(center==true ? -height/2 : 0)])
                cube([extent,0.1,height]);
    }
    
    module convex_wedge(a) {
        translate([0,0,(center==true ? -height/2 : 0)])
            serial_hull() {
                for(r=[0:45:a-1])
                    rotate([0,0,r]) cube([extent,0.1,height]);
                rotate([0,0,a]) cube([extent,0.1,height]);
            }
    }
    
    if(angle<=180) {
        intersection() {
            for(i=[0:$children-1]) children(i);
            convex_wedge(angle);
        }
    } else {
        difference() {
            for(i=[0:$children-1]) children(i);
            scale([1,-1,1]) convex_wedge(360-angle);
        }
    }

//    serial_hull() {
//        wedge_if(0);
//        wedge_if(45*1);
//        wedge_if(45*2);
//        wedge_if(45*3);
//        wedge_if(45*4);
//        wedge_if(45*5);
//        wedge_if(45*6);
//        wedge_if(45*7);
//        wedge_if(45*8);
//    }
}

//difference() {
//    rotate_extrude() translate([40,0,0]) circle(r=30);
//    wedge(angle=247);
//}

wedge(angle=90)
    rotate_extrude(convexity=10) translate([40,0,0]) circle(r=30);