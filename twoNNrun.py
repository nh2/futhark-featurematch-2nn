#! /usr/bin/env python3

import numpy as np
import time

import twoNN


def main():

  # a = np.array([1,4,9], dtype=np.int32)
  # b = np.array(range(6), dtype=np.int32)
  N = 100000
  a = np.array(range(N), dtype=np.int32)
  b = np.array(range(N), dtype=np.int32)

  futhark_module = twoNN.twoNN(interactive=True)

  perf_counter_before = time.perf_counter()

  # Compute.
  futhark_res = futhark_module.main(a, b)

  time_taken_seconds = time.perf_counter() - perf_counter_before

  print(f"Computation took {time_taken_seconds:.3f} s")

  # Download pyopencv arrays from device, turning them into numpy arrays.
  res = [arr.get() for arr in futhark_res.data]

  (nearest_dists, nearests_indices, secondnearest_dists, secondnearest_indices) = res

  # Check that the result size matches the input `a`.
  assert all(a.shape[0] == arr.shape[0] for arr in res)

  # Print results.
  for i in range(a.shape[0]):
    ix = nearests_indices[i]
    ix2 = secondnearest_indices[i]
    nearest = b[ix]
    nearest2 = b[ix2]
    # print(f"{a[i]} -> nearest: {nearest} = b[{ix}], second nearest: {nearest2} = b[{ix2}]")

  gflops = N * N / 1e9 / time_taken_seconds
  print(f"Throughput: {gflops:.1f} Gflops")

if __name__ == '__main__':
  main()
