package seismic_synthetic_generator

// DefineParams structure
DefineParams :: struct {
    // Feature patch
    nx: int,
    ny: int,
    nz: int,

    nxy: int,
    nxyz: int,

    x0: int,
    y0: int,
    z0: int,

    // Synthetic traces
    x, y, z: []int,

    xy: []PointXY,
    xyz: []PointXYZ,

    nx_tr, ny_tr, nz_tr: int,
    nxy_tr, nxyz_tr: int,
    x0_tr, y0_tr, z0_tr: int,
}

defer_prm :: proc(params: DefineParams) {
    delete(params.x)
    delete(params.y)
    delete(params.z)
    delete(params.xy)
    delete(params.xyz)
}

make_DefineParams :: proc(patch_size: int, trace_size := 200) -> DefineParams {
    // Feature patch initialization
    nx, ny, nz := patch_size, patch_size, patch_size
    nxy := nx * ny
    nxyz := nxy * nz

    // Synthetic traces initialization
    nx_tr, ny_tr, nz_tr := trace_size, trace_size, trace_size
    nxy_tr := nx_tr * ny_tr
    nxyz_tr := nxy_tr * nz_tr

    x := make([]int, nx_tr)
    y := make([]int, ny_tr)
    z := make([]int, nz_tr)

    for i in 0..<nx_tr { x[i] = int(i) }
    for i in 0..<ny_tr { y[i] = int(i) }
    for i in 0..<nz_tr { z[i] = int(i) }

    // Generate xy grid
    xy := generate_grid(n1=nx_tr, n2=ny_tr)
    xyz := generate_grid(n1=nx_tr, n2=ny_tr, n3=nz_tr)

    //// Generate xyz grid
    //xyz := make([]Point, nxyz_tr)
    //idx = 0
    //for i in 0..<nx_tr {
    //    for j in 0..<ny_tr {
    //        for k in 0..<nz_tr {
    //            xyz[idx] = PointXYZ{idx=idx, x=i, y=j, z=k}
    //            idx += 1
    //        }
    //    }
    //}

    return DefineParams{
        nx = nx, ny = ny, nz = nz,
        nxy = nxy, nxyz = nxyz,
        x0 = nx/2, y0 = ny/2, z0 = nz/2,

        x = x, y = y, z = z,
        xy = xy, xyz = xyz,
        nx_tr = nx_tr, ny_tr = ny_tr, nz_tr = nz_tr,
        nxy_tr = nxy_tr, nxyz_tr = nxyz_tr,
        x0_tr = nx_tr/2, y0_tr = ny_tr/2, z0_tr = nz_tr/2,
    }
}
