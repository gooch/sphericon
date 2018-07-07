RADIUS = 40;
VERTEX_RADIUS = 5;
OFFSET = 0;
SIDES  = 6;
INDENT = true;
VERTEX_CIRCLES = true;


function extent() = RADIUS + VERTEX_RADIUS + OFFSET;

module positive_x_plane(){
    polygon([
        [0, -extent()],
        [0, extent()],
        [extent(), extent()],
        [extent(), -extent()]
    ]);
}


module negative_x_space(){
    translate([-extent()/2, 0, 0])
        cube([extent(), extent()*2, extent()*2], true);
}

module positive_x_space(){
    mirror([1, 0, 0]) negative_x_space();
}

module base_shape_2d(){
    intersection(){
        difference(){
            offset(r = OFFSET)
            union(){
                circle(r = RADIUS, $fn = SIDES);
                if(VERTEX_CIRCLES == true){
                    for(i = [0:SIDES]){
                        rotate([0, 0, (360/SIDES) * i])
                        translate([RADIUS, 0])
                        circle(r = VERTEX_RADIUS, $fn = 50);
                    }
                }
            }
            
            if(INDENT == true){
                for(i = [0:SIDES]){
                    rotate([0, 0, (360/SIDES) * i])
                    translate(
                        [0, cos(360/SIDES/2) * RADIUS + OFFSET]
                    )
                    scale([1, 0.5])
                    circle(
                        r = sin(360 / SIDES / 2) * RADIUS - OFFSET - VERTEX_RADIUS);
                }
            }
        }

        positive_x_plane();
    }
}

module base_shape(){
    rotate_extrude($fn = 120)
    base_shape_2d();
}

//base_shape_2d();

module sphericon(){
    // the part of the shape in negative x space
    // remains unchanged.
    intersection(){
        base_shape();
        negative_x_space();
    }
    
    // the part of the shape in positive x space
    // gets rotated around x by 360 degress / SIDES
    rotate([360/SIDES, 0, 0])
    intersection(){
        base_shape();
        positive_x_space();
    }
}

module print(){
    intersection(){
        base_shape();
        negative_x_space();
    }
}    

//print();
sphericon();