# futhark-featurematch-2nn

Futhark implementation of two-nearest-neighbour brute-force quadratic feature matching.

See [this CudaSift presentation](https://github.com/Celebrandil/CudaSift/raw/5bc874af176224770da573eb0135b3494e553690/match.pdf) for what performance should be possible.


## Current results

For the presentation's benchmark input of matching 2 inputs of 16K * 128 float32, I get:

* `pyopencl` backend:
  ```sh
  futhark pyopencl --library twoNN.fut && python3 twoNNrun.py 16000
  ```
  * `GeForce 980` with `Futhark 0.18.5`:
    ```
    Computation took 0.393 s
    Throughput: 250.3 Gflop/s
    ```
  * `GeForce 940MX` with `Futhark 0.18.5`:
    ```
    Computation took 1.638 s
    Throughput: 60.0 Gflop/s
    ```
* `cuda` backend:
  * Slower by factor 1.5x for both machines measured.

This is under the assumption of:

```py
flops_per_elem = 3  # 1 subtraction, 1 multiplication (squaring), 1 addition
```
