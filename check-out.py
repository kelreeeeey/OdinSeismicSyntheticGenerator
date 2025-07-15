# coding: utf-8 -*-

"""Description

File: check-out.py
Author: Kelrey
Email: taufiqkelrey1@gmail.com
Github: kelreeeey
Description: description
"""

import array as ar
import matplotlib.pyplot as plt
import json

SAMPLE_TYPE: chr = "d"


def get_array_from_file(filepath: str, n_traces: int, trace_sample: int) -> ar.array:
    data = open(filepath, "rb")
    x = ar.array(SAMPLE_TYPE, [])
    x.fromfile(data, (n_traces * trace_sample))
    data.close()
    return x


def main() -> int:
    FILE:         str = "./out-examples/all-trace.dat"
    with open("./example_parameter.json", "r") as f:
        PARAM:       dict = json.load(f)
    X_SIZE:       int = PARAM["data_dim"]["patch_size"] # index
    Y_SIZE:       int = PARAM["data_dim"]["patch_size"] # stride
    TRACE_SAMPLE: int = PARAM["data_dim"]["trace_size"]
    N_TRACES:     int = int(X_SIZE * Y_SIZE)

    all_trace = get_array_from_file(
        filepath=FILE, n_traces=N_TRACES, trace_sample=TRACE_SAMPLE
    )

    idx: int = 20
    slice_x = [all_trace[(i+idx)*Y_SIZE:(i+idx+1)*Y_SIZE] for i in range(1, X_SIZE)]

    plt.title(f"X SLICE {idx}")
    plt.imshow(slice_x, cmap="inferno")
    plt.ylabel("Y"); plt.xlabel("Z")
    plt.show()

    return 0


if __name__ == "__main__":
    main()
