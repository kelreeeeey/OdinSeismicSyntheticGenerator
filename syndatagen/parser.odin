package seismic_synthetic_generator

import "core:encoding/json"
import "core:os"
import "core:fmt"

ParamDataDim :: struct {
    patch_size: int,
    trace_size: int,
    layer_position: []int,
}

ParamFolding :: struct {
    a: f64,
    b, c, d, sigma: []f64
}

Parameters :: struct {
    data_dim : ParamDataDim,
    folding: ParamFolding,
    verbose: bool
}

read_params :: proc(filename: string) -> Parameters {

    data, ok := os.read_entire_file_from_filename(filename)
    if !ok {
        fmt.eprintln("Failed to load the file!")
        os.exit(1)
    }
    defer delete(data) // Free the memory at the end

    settings: Parameters
    unmarshal_err := json.unmarshal(data, &settings)
    if unmarshal_err != nil {
        fmt.eprintln("Failed to unmarshal the file!")
        os.exit(1)
    }

    return settings
}
