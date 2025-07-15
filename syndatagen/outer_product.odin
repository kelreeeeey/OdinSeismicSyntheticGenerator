package seismic_synthetic_generator

outer_product_f32 :: proc(x, y: []f32) -> [][]f32 {
    result := make([][]f32, len(x))
    for i in 0..<len(x) {
        result[i] = make([]f32, len(y))
        for j in 0..<len(y) {
            result[i][j] = x[i] * y[j]  // Direct element-wise product
        }
    }
    return result
}

outer_product_f64 :: proc(x, y: []f64) -> [][]f64 {
    result := make([][]f64, len(x))
    for i in 0..<len(x) {
        result[i] = make([]f64, len(y))
        for j in 0..<len(y) {
            result[i][j] = x[i] * y[j]  // Direct element-wise product
        }
    }
    return result
}
outer_product :: proc{
    outer_product_f32,
    outer_product_f64,
}

