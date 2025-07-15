package seismic_synthetic_generator

// Points
PointXY :: struct { idx, x, y:int }
PointXYZ :: struct { using xy: PointXY , z:int }
