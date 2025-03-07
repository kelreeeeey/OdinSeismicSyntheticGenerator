package main

import "core:fmt"
import "core:time"
import "core:os"

import pts "syndatagen/point_and_grid"
import param "syndatagen/parameters"
import lyr "syndatagen/layer_model"

main :: proc() {
    start_time := time.now()

    input_params := param.read_params(filename = os.args[1])
    data_dim := input_params.data_dim
    folding := input_params.folding

    prm := param.make_DefineParams(
        patch_size=data_dim.patch_size,
        trace_size=data_dim.trace_size)
    defer param.defer_prm(params=prm)

    layer_models := lyr.create_1d_model(
        prm.nz_tr,
        prm.nxy_tr,
        data_dim.layer_position)
    fmt.printfln("Reflection: %v",
        len(layer_models.reflections))
    fmt.printfln("Reflection[0]: %v",
        len(layer_models.reflections[0]))
    defer lyr.defer_layer_model(model=layer_models)

    c := folding.c
    d := folding.d
    sigma := folding.sigma

    gaussed_refl := lyr.infer_folding(
        reflection=layer_models.reflections,
        xy=prm.xy,
        a = folding.a,
        z = prm.z,
        nxy_tr = prm.nxy_tr,
        b = folding.b,
        c = folding.c,
        d = folding.d,
        sigma = folding.sigma,
        verbose = input_params.verbose)
    defer delete(gaussed_refl)

    fmt.println("Gaussed-reflection",
        len(gaussed_refl), typeid_of( type_of(gaussed_refl) ))

    point := prm.xy[1000]
    fmt.printfln("Params XY[1000]: [%v], X[0]: [%v], Y[0]: [%v]",
        point,
        point.x,
        point.y,
    )

    fmt.printfln(
        "Layer Models: Reflection: len(%d), Layers: len(%d)",
        len(layer_models.reflections),
        len(layer_models.layers))

    fmt.printfln(
        "Layer Models: Reflection[0]: len(%d), Layers[0]: len(%d)",
        len(layer_models.reflections[0]),
        len(layer_models.layers[0]))

    fmt.printf(
        "Creating things takes: %v seconds",
        time.duration_seconds( time.diff(start_time, time.now()) ))

}
