import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/animation"

import "scripts/tank/tankMissile"
import "scripts/tank/tankExplosion"
import "scripts/util/bounds"
import "scripts/audio/engineSfx"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("Tank").extends(gfx.sprite)

function Tank:init(bounds, missiles, x, y)
    self.bounds = bounds
    self.missiles = missiles

    self.up, self.down, self.left, self.right = false, false, false, false
    self.moveSpeed = 0.03
    self.turnSpeed = 0.12
    self.turretSpeed = 0.2
    self.missileWait = 360 * 2.5
    self.missileCharge = 0

    self.engineSfx = EngineSFX()

    local tracksImage = gfx.image.new("images/tank/TankTracks")
    assert(tracksImage)
    local baseImage = gfx.image.new("images/tank/TankTurretBase")
    assert(baseImage)
    local turretImage = gfx.image.new("images/tank/TankTurret")
    assert(turretImage)

    local tankExplosionImagetable = gfx.imagetable.new("images/tank/tankExplosion")
    assert(tankExplosionImagetable)
    self.tankExplosionAnimation = gfx.animation.loop.new(1000/30, tankExplosionImagetable, false)
    self.tankExplosionSprite = gfx.sprite.new(self.tankExplosionAnimation:image())
    self.tankExplosionSprite.update = function()
        self.tankExplosionSprite:setImage(self.tankExplosionAnimation:image())
        -- Optionally, removing the sprite when the animation finished
        if not self.tankExplosionAnimation:isValid() then
            self.tankExplosionSprite:remove()
        end
    end

    self.tracksSprite = gfx.sprite.new(tracksImage)
    self.baseSprite = gfx.sprite.new(baseImage)
    self.turretSprite = gfx.sprite.new(turretImage)
    self.tracksSprite:moveTo(x, y)
    self.baseSprite:moveTo(x, y)
    self.turretSprite:moveTo(x, y)
    self.tracksSprite:add()
    self.baseSprite:add()
    self.turretSprite:add()

    self:add()
end

function Tank:update()
    if pd.buttonJustPressed(pd.kButtonUp) then
        self.up = not self.up
    end
    if pd.buttonJustPressed(pd.kButtonDown) then
        self.down = not self.down
    end
    if pd.buttonJustPressed(pd.kButtonLeft) then
        self.left = not self.left
    end
    if pd.buttonJustPressed(pd.kButtonRight) then
        self.right = not self.right
    end

    local change = pd.getCrankChange()

    if self.down then
        local rot = self.tracksSprite:getRotation() + (change * self.turnSpeed)
        self.tracksSprite:setRotation(rot)
    end

    if self.up then
        local rot = self.tracksSprite:getRotation()
        local rads = math.rad(rot-90)
        local x = math.cos(rads) * (change * self.moveSpeed)
        local y = math.sin(rads) * (change * self.moveSpeed)

        self.tracksSprite:moveBy(x,y)
        self.baseSprite:moveBy(x,y)
        self.turretSprite:moveBy(x,y)

        x, y = self.tracksSprite:getPosition()
        x, y = self.bounds:clamp(x, y, 16)
        self.tracksSprite:moveTo(x,y)
        self.baseSprite:moveTo(x,y)
        self.turretSprite:moveTo(x,y)

        self.engineSfx:setSpeed(math.min(math.abs(change), 56) / 56.0)
    else
        self.engineSfx:setSpeed(0)
    end

    if self.left then
        local rot = self.turretSprite:getRotation() + (change * self.turretSpeed)
        self.turretSprite:setRotation(rot)
    end

    if self.right then
        self.missileCharge = self.missileCharge + math.abs(change)
        if self.missileCharge >= self.missileWait then
            -- FIRE
            self:fire()
            self.missileCharge = 0
        end
    end
end

function Tank:fire()
    local rot = self.turretSprite:getRotation()
    local x, y = self.turretSprite:getPosition()
    self.missiles[#self.missiles+1] = TankMissile(x, y, rot, "player")
end

function Tank:getPosition()
    return self.tracksSprite:getPosition()
end

function Tank:remove()
    self.engineSfx:setSpeed(0)
    TankExplosion(self:getPosition())
    self.tracksSprite:remove()
    self.baseSprite:remove()
    self.turretSprite:remove()
    Tank.super.remove(self)
end