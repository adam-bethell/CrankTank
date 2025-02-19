import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/animation"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("TankExplosion").extends(gfx.sprite)

local tankExplosionImagetable = gfx.imagetable.new("images/tank/tankExplosion")
assert(tankExplosionImagetable)

function TankExplosion:init(x, y)
    self.tankExplosionAnimation = gfx.animation.loop.new(1000/30, tankExplosionImagetable, false)
    self:setImage(self.tankExplosionAnimation:image())
    self:moveTo(x,y)
    self:add()
    self.update = function()
        self:setImage(self.tankExplosionAnimation:image())
        -- Optionally, removing the sprite when the animation finished
        if not self.tankExplosionAnimation:isValid() then
            self:remove()
        end
    end
end