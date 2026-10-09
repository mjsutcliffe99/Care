--- Trigonometric and geometric utility functions.
local trig = {}

--- Calculates the angle between two points.
--- The angle is measured in radians, with 0 pointing north
--- (upwards on the screen) and increasing clockwise.
---
--- @param x1 number X coordinate of the first point.
--- @param y1 number Y coordinate of the first point.
--- @param x2 number X coordinate of the second point.
--- @param y2 number Y coordinate of the second point.
--- @return number angle The angle in radians.
---
--- Example:
--- ```lua
--- local angle = trig.angle_to(0, 0, 100, 0)
--- print(angle) -- pi/2
--- ```
function trig.angle_to(x1, y1, x2, y2)
    return math.atan2(y2-y1, x2-x1) + math.pi/2
end

--- Calculates the Euclidean distance between two points.
---
--- @param x1 number X coordinate of the first point.
--- @param y1 number Y coordinate of the first point.
--- @param x2 number X coordinate of the second point.
--- @param y2 number Y coordinate of the second point.
--- @return number distance The distance between the points.
---
--- Example:
--- ```lua
--- local distance = trig.distance_to(0, 0, 3, 4)
--- print(distance) -- 5
--- ```
function trig.distance_to(x1, y1, x2, y2)
    return math.sqrt((x2-x1)^2 + (y2-y1)^2)
end

return trig
