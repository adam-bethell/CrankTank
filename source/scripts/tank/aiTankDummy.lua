import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("AITankDummy").extends(gfx.sprite)

function AITankDummy:init(player, bounds, missiles, x, y)
    local baseImage = gfx.image.new("images/tank/target")
    assert(baseImage)

    self.baseSprite = gfx.sprite.new(baseImage)
    self.baseSprite:moveTo(x, y)
    self.baseSprite:add()

    self:add()
end

function AITankDummy:getPosition()
    return self.baseSprite:getPosition()
end

function AITankDummy:remove()
    TankExplosion(self:getPosition())
    self.baseSprite:remove()
    AITankDummy.super.remove(self)
end
