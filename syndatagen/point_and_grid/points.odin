package points_and_grid

// Points
PointXY :: struct { idx, x, y:int }
PointXYZ :: struct { using xy: PointXY , z:int }
