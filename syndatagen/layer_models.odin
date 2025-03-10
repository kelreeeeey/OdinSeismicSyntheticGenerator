package seismic_synthetic_generator

import rndm "core:math/rand"
import "core:slice"

LayerModel :: struct {
    reflections, layers, boundaries: [][]f64
}

defer_layer_model :: proc(model: LayerModel) {
    for arr in model.reflections do delete(arr)
    delete(model.reflections)

    for arr in model.layers { delete(arr) }
    delete(model.layers)

    for arr in model.boundaries { delete(arr) }
    delete(model.boundaries)
}

create_1d_model :: proc(
    nz_tr: int,
    nxy_tr: int,
    layer_pos: []int
) -> LayerModel {

    // Sort layer positions in descending order
    n_layers := len(layer_pos)
    sorted_pos := make([]int, len(layer_pos))
    copy(sorted_pos, layer_pos)
    slice.reverse_sort(sorted_pos)

    // Initialize arrays
    reflections := make([][]f64, nxy_tr)
    layers := make([][]f64, nxy_tr)
    boundaries := make([][]f64, nxy_tr)

    for i in 0..<nxy_tr {
        reflections[i] = make([]f64, nz_tr)
        layers[i] = make([]f64, nz_tr)
        boundaries[i] = make([]f64, nz_tr)

        // Set reflection coefficients
        for pos in sorted_pos {
            reflections[i][pos] = 2 * rndm.float64_range(0.0,1.0) - 1
            boundaries[i][pos] = 1
        }

        // Create layers
        current_layer: f64 = 0
        for j in 1..<len(sorted_pos) {
            start := sorted_pos[j]
            end := sorted_pos[j-1]
            current_layer += 1
            for k in start..<end {
                layers[i][k] = current_layer
            }
        }
    }

    return LayerModel { reflections=reflections, layers=layers, boundaries=boundaries }
}

