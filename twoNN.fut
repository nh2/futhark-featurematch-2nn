-- import "prelude/math"

-- let maxBound = 99999999

type value = i32
type dist = f32
type index = i32

type twoNearestNeighboursResult = ((dist, index), (dist, index))

let twoNearestNeighbours [n][m]
  (as: [n]value)
  (bs: [m]value):
  []twoNearestNeighboursResult = -- using type alias to silence warning "Entry point return type ... will have an opaque type"
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

        let worst = (999, -1)

        let
          twoNearest (a: value): ((dist, index), (dist, index)) =
            reduce nearer (worst, worst) (
              map ( \(b, bi) -> ( (f32.abs (r32 a - r32 b), i32.i64 bi), worst ) ) (zip bs (iota m))
            )

        in
          twoNearest a
      )
      as

let main as bs = twoNearestNeighbours as bs

-- For testing directly
-- let main = twoNearestNeighbours (1...300000) (1...300000)
