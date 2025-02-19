import "CoreLibs/object"

class("Bounds").extends()

function Bounds:init(x1, y1, x2, y2)
    self.x1, self.y1, self.x2, self.y2 = x1, y1, x2, y2
end

function Bounds:isInBounds(x, y, padding)
    if padding == nil then
        padding = 0
    end

    if x - padding < self.x1 or x + padding > self.x2 or y - padding < self.y1 or y + padding > self.y2 then
        return false
    end
    return true
end

function Bounds:clamp(x, y, padding)
    if padding == nil then
        padding = 0
    end

    if x - padding < self.x1 then
        x = self.x1 + padding
    elseif x + padding > self.x2 then
        x = self.x2 - padding
    end
    if y - padding < self.y1 then
        y = self.y1 + padding
    elseif y + padding > self.y2 then
        y = self.y2 - padding
    end
    return x, y
end