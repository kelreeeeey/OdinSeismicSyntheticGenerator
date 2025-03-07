package layer_model

import "core:math"
import "core:slice"
import "core:fmt"
import "core:time"

import pts "../point_and_grid"

// gauss2d element-wise
// $z = b \times e^{ \frac{-{x-2}^2 + {y-d}^2}{2 \times sigma^2} }$
folding_s2 :: proc(x, y, b, c, d, sigma: f64) -> f64 {
    dx := x - c
    dy := y - d
    exponent := (dx*dx + dy*dy) / (2 * sigma*sigma)
    return b * math.exp_f64(exponent)
}

folding_s1 :: proc(z: []int, a: f64, folding2: []f64) -> [][]f64 {
    z64 := convert_slice(f64, z, f64(0.00001))
    maxZ := slice.max(z64)
    out := make([][]f64, len(folding2))
    outer_prod := outer_product( folding2, z64 )
    for i in 0..<len(folding2) {
        out[i] = make([]f64, len(z))
        for j in 0..<len(z) {
            out[i][j] = (1.5 * z64[j] / maxZ)
            out[i][j] *= outer_prod[i][j]
            out[i][j] += a
        }
        //fmt.printfln("gauss Folding1: %v", outer_prod[i][:10])
    }
    return out
}

infer_folding :: proc(
    reflection: [][]f64,
    xy: []pts.PointXY,
    a : f64,
    z : []int,
    nxy_tr : int,
    b, c, d, sigma: []f64,
    verbose: bool = false
) -> [][]f64 {

    gauss_2d := make([]f64, len(xy))
    defer delete(gauss_2d)

    out := make([][]f64, len(xy))

    // Sum contributions from all Gaussian parameters
    for i in 0..<len(xy) {
        sum: f64 = 0
        for param_idx in 0..<len(b) {
            sum += folding_s2(
                f64( xy[i].x ),
                f64( xy[i].y ),
                b[param_idx],
                c[param_idx],
                d[param_idx],
                sigma[param_idx],
            )
        }
        gauss_2d[i] = sum
        //fmt.printfln("gauss Folding2: %v %v", gauss_2d[i], z[:10])
    }

    z64 := convert_slice(f64, z)
    defer delete(z64)

    complete_folding := folding_s1(z, a, gauss_2d)
    defer delete(complete_folding)

    temp1 := make([][]f64, len(reflection))
    defer delete(temp1)

    delta := make([][]f64, len(z64))
    defer delete( delta )

    start_time := time.now()
    for i in 0..<len(reflection) {
        s := complete_folding[i]

        //defer delete( delta )
        for z1_idx in 0..<len(z64) {
            delta[z1_idx] = make([]f64, len(z64))
            for z2_idx in 0..<len(z64) {
                delta[z1_idx][z2_idx] = sinc( s[z1_idx] - z64[z2_idx] )
            }
        }

        temp1[i] = make([]f64, len(z64))
        //defer delete( temp2 )
        for z1_idx in 0..<len(z64) {
            running_sum := f64( 0.0 )
            for z2_idx in 0..<len(z64) {
                running_sum += delta[z1_idx][z2_idx] * reflection[z1_idx][z2_idx]
            }
            temp1[i][z1_idx] = (running_sum/f64(len(z64)))
        }

        if i % (len(reflection)/5) == 0 {
            if verbose {
                fmt.printfln("temp1[%v] = [%v .. %v]",
                    i, slice.max(temp1[i]), slice.min( temp1[i] ))
                fmt.printfln(
                    "Refl[%v] = [%v .. %v]\n=======(%v seconds)",
                    i, slice.max(reflection[i]), slice.min( reflection[i] ),
                    time.duration_seconds(time.diff(start_time, time.now()))
                )
            }
            else {
                fmt.printfln(
                    "Done processing XY[%v/%v] (%v seconds)",
                    i, len(reflection),
                    time.duration_seconds(time.diff(start_time, time.now()))
                )
            }
        }
    }
    copy(temp1, out)

    return out
}

