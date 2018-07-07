RADIUS = 40;
SIDES  = 6;

module positive_x_plane(){
    polygon([
        [0, -RADIUS],
        [0, RADIUS],
        [RADIUS, RADIUS],
        [RADIUS, -RADIUS]
    ]);
}

module negative_x_space(){
    translate([-RADIUS/2, 0, 0])
        cube([RADIUS, RADIUS*2, RADIUS*2], true);
}

module positive_x_space(){
    mirror([1, 0, 0]) negative_x_space();
}

module base_shape(){
    rotate_extrude($fn = 120)
    intersection(){
        circle(r = RADIUS, $fn = SIDES);
        positive_x_plane();
    }
}

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

sphericon();