type value = [128]f32
type dist = f32
type index = i32

let distance (a: value) (b: value) =
  reduce (+) 0 (map (\x -> x*x) (map2 (-) a b))

type twoNearestNeighboursResult = ((dist, index), (dist, index))

entry twoNearestNeighbours [n][m]
  (as: [n]value)
  (bs: [m]value):
  [n]twoNearestNeighboursResult = -- using type alias to silence warning "Entry point return type ... will have an opaque type"
    map
      (\a ->
        let
          minByFirst (a, ai) (b, bi) = if a <= b then (a, ai) else (b, bi)
        let
          nearer 'a (((a1, a1i), (a2, a2i)): ((dist, a), (dist, a)))
                    (((b1, b1i), (b2, b2i)): ((dist, a), (dist, a))):
                                             ((dist, a), (dist, a)) =
            if a1 <= b1 then ((a1, a1i), minByFirst (a2, a2i) (b1, b1i))
                        else ((b1, b1i), minByFirst (b2, b2i) (a1, a1i))

        let worst = (f32.highest, -1)

        let
          twoNearest (a: value): ((dist, index), (dist, index)) =
            reduce nearer (worst, worst) (
              map2 (\b bi -> ( (distance a b, bi), worst ) ) bs (indices bs)
            )

        in
          twoNearest a
      )
      as


-- For testing directly. Invoke like:
--     echo 16000 | ./twoNN -t time.log && cat time.log
let main (n: i64) =
  -- The `as` must depend on user-provided runtime input, otherwise Futhark
  -- is too clever and supercompiles the O(n^2) problem to O(n), making
  -- our benchmark useless.
  let as =
        map (\x -> map (\y -> f32.i64 (x+y)) (iota 128)) (iota n)

  -- Compute some scalar value from the result so we can print it easily.
  let summarise outputs =
        f32.sum ((map (\((dist1, _), (dist2, _)) -> dist1 + dist2) outputs))

  in
    summarise
      (twoNearestNeighbours as as)
