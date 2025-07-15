package seismic_synthetic_generator

//@(require_result)
generate_2d_grid :: proc(n1, n2: int) -> []PointXY {
    n := n1 * n2
    points := make([]PointXY, n)
    idx := 0
    for i in 0..<n1 {
        for j in 0..<n2 {
            points[idx] = PointXY{idx=idx, x=i, y=j}
            idx += 1
        }
    }
    return points
}

//@(require_result)
generate_3d_grid :: proc(n1, n2, n3: int) -> []PointXYZ {
    n := n1 * n2 * n3
    points := make([]PointXYZ, n)
    idx := 0
    for i in 0..<n1 {
        for j in 0..<n2 {
            for k in 0..<n2 {
                points[idx] = PointXYZ{idx=idx, x=i, y=j, z=k}
                idx += 1
            }
        }
    }
    return points
}

generate_grid :: proc {
    generate_2d_grid,
    generate_3d_grid }
