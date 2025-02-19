import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "scripts/tank/tank"
import "scripts/tank/tankUI"
import "scripts/tank/aiTankDummy"
import "scripts/tank/aiTankEasy"
import "scripts/tank/aiTankMedium"
import "scripts/tank/aiTankHard"
import "scripts/util/bounds"
import "scripts/util/vector"
import "scripts/audio/audioManager"
import "scripts/audio/PDFXR"
import "scripts/audio/PDFXRPool"
import "scripts/levels/sceneManager"
import "scripts/levels/levelSelect"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("TankLevel").extends(gfx.sprite)

local goalImage = gfx.image.new("images/tank/goal")
assert(goalImage)

function TankLevel:init(data)
    self.levelName = data.name
    self.bounds = Bounds(35, 0, 400, 240)
    self.missiles = {}
    self.missileDepot = {}
    self.missilesImage = gfx.image.new(400, 240)
    self.missilesSprite = gfx.sprite.new(self.missilesImage)
    self.missilesSprite:moveTo(200,120)
    self.missilesSprite:add()

    self.tankUI = TankUI()
    self.tank = Tank(self.bounds, self.missileDepot, data.startX, data.startY)

    self.goalSprite = gfx.sprite.new(goalImage)
    self.goalSprite:moveTo(data.goalX, data.goalY)
    self.goalSprite:add()

    self.enemies = {}
    for i=1, #data.enemiesClass do
        self.enemies[#self.enemies+1] = data.enemiesClass[i](self.tank, self.bounds, self.missileDepot, table.unpack(data.enemiesArgs[i]))
    end

    self:add()
end

function TankLevel:update()
    self:checkGoal()
    self:addMissiles()
    self:cleanupMissiles()
    self:drawMissiles()
    self:checkMissiles()
end

function TankLevel:checkGoal()
    if self.tank == nil then return end

    local x1, y1 = self.tank:getPosition()
    local x2, y2 = self.goalSprite:getPosition()
    local d = Vector.distance(x1, y1, x2, y2)
    if d <= 20 then
        self:cleanup()
        SCENE_MANAGER:changeScene(LevelSelect)
    end
end

function TankLevel:addMissiles()
    for i=1, #self.missileDepot do
        self.missiles[#self.missiles+1] = self.missileDepot[i]
        self.missileDepot[i] = nil
    end
    
end
function TankLevel:cleanupMissiles()
    if #self.missiles > 0 then
        local toKeep = {}
        for i=1, #self.missiles do
            if self.missiles[i] ~= nil then
                table.insert(toKeep, self.missiles[i])
            end
        end

        self.missiles = nil
        self.missiles = table.create(#toKeep)
        for i=1, #toKeep do
            self.missiles[i] = toKeep[i]
        end
    end
end

function TankLevel:drawMissiles()
    self.missilesImage:clear(gfx.kColorClear)
    gfx.pushContext(self.missilesImage)
        for i=1, #self.missiles do
            local x, y = self.missiles[i]:getPosition()
            gfx.setColor(gfx.kColorBlack)
            gfx.fillCircleAtPoint(x, y, 5)
        end
    gfx.popContext()
    self.missilesSprite:setImage(self.missilesImage)
    self.missilesSprite:markDirty()
end
function TankLevel:checkMissiles()
    for i=1, #self.missiles do
        if self.missiles[i] ~= nil then
            local x, y = self.missiles[i]:getPosition()

            -- Check out of bounds
            if not self.bounds:isInBounds(x, y, 10) then
                self.missiles[i] = nil
                PDFXR_POOL:getPDFXR():generatePlink(0.4)
                goto continue
            end

            -- Check enemies hit
            for j=1, #self.enemies do
                if self.enemies[j] ~= nil then
                    local x2, y2 = self.enemies[j]:getPosition()
                    local d = Vector.distance(x, y, x2, y2)
                    if d <= 20 then
                        self.missiles[i] = nil
                        self.enemies[j]:remove()
                        self.enemies[j] = nil
                        PDFXR_POOL:getPDFXR():generateExplosion(0.4)
                        goto continue
                    end
                end
            end

            -- Check player hit
            if self.tank == nil then goto continue end

            if self.missiles[i].tag ~= "player" then
                local x2, y2 = self.tank:getPosition()
                local d = Vector.distance(x, y, x2, y2)
                if d <= 20 then
                    self.missiles[i] = nil
                    self.tank:remove()
                    self.tank = nil
                    PDFXR_POOL:getPDFXR():generateExplosion(0.4)
                    pd.timer.new(1500, function () SCENE_MANAGER:changeScene(LevelSelect) end)
                    goto continue
                end
            end
        end
        ::continue::
    end
end

function TankLevel:cleanup()
    if self.tank ~= nil then
        self.tank:remove()
    end

    for j=1, #self.enemies do
        if self.enemies[j] ~= nil then
            self.enemies[j]:remove()
        end
    end

    self.missilesImage:clear(gfx.kColorClear)
    self.missilesSprite:setImage(self.missilesImage)
    self.missilesSprite:markDirty()
end