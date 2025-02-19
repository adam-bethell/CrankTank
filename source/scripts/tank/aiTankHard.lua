import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "scripts/tank/tankMissile"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("AITankHard").extends(gfx.sprite)

function AITankHard:init(player, bounds, missiles, x, y)
    self.player = player
    self.bounds = bounds
    self.missiles = missiles

    self.missileTimer = pd.timer.new(500,
        function()
            self:fire()
        end
    )
    self.missileTimer.repeats = true

    self.moveSpeed = 0.5
    
    local tankImage = gfx.image.new("images/tank/AITankHard")
    assert(tankImage)

    self.tankSprite = gfx.sprite.new(tankImage)
    self.tankSprite:moveTo(x, y)
    self.tankSprite:add()

    self:add()
end

function AITankHard:update()
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

function AITankHard:fire()
    local rot = self.tankSprite:getRotation()
    local x, y = self.tankSprite:getPosition()
    self.missiles[#self.missiles+1] = TankMissile(x, y, rot, nil, 8)
end

function AITankHard:getPosition()
    return self.tankSprite:getPosition()
end

function AITankHard:remove()
    TankExplosion(self:getPosition())
    self.missileTimer:remove()
    self.tankSprite:remove()
    AITankHard.super.remove(self)
end
