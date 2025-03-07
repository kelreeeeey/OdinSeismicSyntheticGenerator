package layer_model

import "base:intrinsics"
import "core:math"

convert_slice_vanilla :: proc($T: typeid, s: []$S) -> []T {
    result := make([]T, len(s))
    for v, i in s {
        result[i] = T(v)
    }
    return result
}

convert_slice_with_addition :: proc($T: typeid, s: []$S, scalar: T) -> []T {
    result := make([]T, len(s))
    for v, i in s {
        result[i] = T(v) + scalar
    }
    return result
}

convert_slice :: proc { convert_slice_vanilla, convert_slice_with_addition }

sinc :: proc(x: $T) -> T where intrinsics.type_is_numeric(T) {
    phi_x := math.PI * x
    if phi_x == 0 { return T(1) }
    else { return  T(math.sin(phi_x)/phi_x) }
}

reshape_traces :: proc(img: [][]f32, size: int = 200) -> [][][]f32 {
    assert(len(img[0]) == size)
    assert(len(img) == size * len(img[0]))

    result := make([][][]f32, size)
    for i in 0..<size {
        result[i] = make([][]f32, size)
        for j in 0..<size {
            result[i][j] = make([]f32, size)
        }
    }

    // Manual reshaping
    idx := 0
    for x in 0..<size {
        for y in 0..<size {
            for z in 0..<size {
                result[x][y][z] = img[idx][z]
            }
            idx += 1
        }
    }

    return result
}
