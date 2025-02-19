Vector = {}

function Vector.distance(x1, y1, x2, y2)
    --Math.Sqrt(Math.Pow (a.X-b.X, 2) + Math.Pow (a.Y-b.Y, 2));
    return math.sqrt(((x1-x2)^2) + ((y1-y2)^2))
end