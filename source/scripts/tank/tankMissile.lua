import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "scripts/audio/pdfxr"
import "scripts/audio/pdfxrPool"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("TankMissile").extends(gfx.sprite)

function TankMissile:init(x, y, dir, tag, speed)
    self.missileSpeed = 1
    if speed ~= nil then
        self.missileSpeed = speed
    end
    self.tag = tag
    self.rads = math.rad(dir-90)
    
    local xOffset = math.cos(self.rads) * 21
    local yOffset = math.sin(self.rads) * 21
    self.x = x+xOffset
    self.y = y+yOffset

    if tag == "player" then
        PDFXR_POOL:getPDFXR():generateShot(0.5)
    else
        PDFXR_POOL:getPDFXR():generateLazer(0.5)
    end

    self:add()
end

function TankMissile:update()
    local x = math.cos(self.rads) * self.missileSpeed
    local y = math.sin(self.rads) * self.missileSpeed
    self.x += x
    self.y += y
end

function TankMissile:getPosition()
    return self.x, self.y
end