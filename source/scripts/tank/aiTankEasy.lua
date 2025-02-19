import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "scripts/tank/tankMissile"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("AITankEasy").extends(gfx.sprite)

function AITankEasy:init(player, bounds, missiles, x, y)
    self.player = player
    self.bounds = bounds
    self.missiles = missiles

    self.missileTimer = pd.timer.new(math.random(3000, 3500), function() self:fire() end)
    self.missileTimer.repeats = true

    
    local baseImage = gfx.image.new("images/tank/AITankEasy_Base")
    assert(baseImage)
    local turretImage = gfx.image.new("images/tank/AITankEasy_Turret")
    assert(turretImage)

    self.baseSprite = gfx.sprite.new(baseImage)
    self.turretSprite = gfx.sprite.new(turretImage)
    self.baseSprite:moveTo(x, y)
    self.turretSprite:moveTo(x, y)
    self.baseSprite:add()
    self.turretSprite:add()

    self:add()
end

function AITankEasy:update()
    local x2, y2 = self.baseSprite:getPosition()
    local x1, y1 = self.player:getPosition()
    local target = math.deg(math.atan(y2 - y1, x2 - x1)) - 90
    self.turretSprite:setRotation(target)
end

function AITankEasy:fire()
    local rot = self.turretSprite:getRotation()
    local x, y = self.turretSprite:getPosition()
    self.missiles[#self.missiles+1] = TankMissile(x, y, rot)
end

function AITankEasy:getPosition()
    return self.baseSprite:getPosition()
end

function AITankEasy:remove()
    TankExplosion(self:getPosition())
    self.missileTimer:remove()
    self.baseSprite:remove()
    self.turretSprite:remove()
    AITankEasy.super.remove(self)
end
