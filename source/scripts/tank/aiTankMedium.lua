import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "scripts/tank/tankMissile"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("AITankMedium").extends(gfx.sprite)

function AITankMedium:init(player, bounds, missiles, x, y)
    self.player = player
    self.bounds = bounds
    self.missiles = missiles

    self.missileTimer = pd.timer.new(math.random(4000, 4500), function() self:fire() end)
    self.missileTimer.repeats = true

    self.moveSpeed = 0.5
    
    local tankImage = gfx.image.new("images/tank/AITankMedium")
    assert(tankImage)

    self.tankSprite = gfx.sprite.new(tankImage)
    self.tankSprite:moveTo(x, y)
    self.tankSprite:add()

    self:add()
end

function AITankMedium:update()
    local x2, y2 = self.tankSprite:getPosition()
    local x1, y1 = self.player:getPosition()
    local target = math.deg(math.atan(y2 - y1, x2 - x1)) - 90
    
    -- Movment
    local dX = math.cos(math.rad(target - 90)) * self.moveSpeed
    local dY = math.sin(math.rad(target - 90)) * self.moveSpeed
    self.tankSprite:moveBy(dX, dY)
    
    -- Turret
    self.tankSprite:setRotation(target)
end

function AITankMedium:fire()
    local rot = self.tankSprite:getRotation()
    local x, y = self.tankSprite:getPosition()
    self.missiles[#self.missiles+1] = TankMissile(x, y, rot)
end

function AITankMedium:getPosition()
    return self.tankSprite:getPosition()
end

function AITankMedium:remove()
    TankExplosion(self:getPosition())
    self.missileTimer:remove()
    self.tankSprite:remove()
    AITankMedium.super.remove(self)
end
