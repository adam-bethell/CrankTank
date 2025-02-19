import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "scripts/audio/PDFXR"
import "scripts/audio/PDFXRPool"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("TankUI").extends(gfx.sprite)

local upOnImage = gfx.image.new("images/tank/up_on")
assert(upOnImage)
local upOffImage = gfx.image.new("images/tank/up_off")
assert(upOffImage)
local downOnImage = gfx.image.new("images/tank/down_on")
assert(downOnImage)
local downOffImage = gfx.image.new("images/tank/down_off")
assert(downOffImage)
local leftOnImage = gfx.image.new("images/tank/left_on")
assert(leftOnImage)
local leftOffImage = gfx.image.new("images/tank/left_off")
assert(leftOffImage)
local rightOnImage = gfx.image.new("images/tank/right_on")
assert(rightOnImage)
local rightOffImage = gfx.image.new("images/tank/right_off")
assert(rightOffImage)

local logoImage = gfx.image.new("images/tank/logo")
assert(logoImage)

function TankUI:init()
    self.upSprite = gfx.sprite.new(upOffImage)
    self.upSprite:moveTo(17,17)
    self.upSprite:add()

    self.downSprite = gfx.sprite.new(downOffImage)
    self.downSprite:moveTo(17,17+33)
    self.downSprite:add()

    self.leftSprite = gfx.sprite.new(leftOffImage)
    self.leftSprite:moveTo(17,17+33+33)
    self.leftSprite:add()

    self.rightSprite = gfx.sprite.new(rightOffImage)
    self.rightSprite:moveTo(17,17+33+33+33)
    self.rightSprite:add()

    self.up, self.down, self.left, self.right = false, false, false, false

    self.setBackgroundDrawingCallback(
        function(x, y, width, height)
            gfx.setLineWidth(3)
            gfx.drawLine(34, 0, 34, 240)
            logoImage:draw(1, 140)
        end
    )

    self:add()
end

function TankUI:update()
    if pd.buttonJustPressed(pd.kButtonUp) then
        self.up = not self.up

        if self.up then
            self.upSprite:setImage(upOnImage)
            PDFXR_POOL:getPDFXR():generateTick(0.4, true)
        else
            self.upSprite:setImage(upOffImage)
            PDFXR_POOL:getPDFXR():generateTick(0.4, false)
        end
    end
    if pd.buttonJustPressed(pd.kButtonDown) then
        self.down = not self.down

        if self.down then
            self.downSprite:setImage(downOnImage)
            PDFXR_POOL:getPDFXR():generateTick(0.4, true)
        else
            self.downSprite:setImage(downOffImage)
            PDFXR_POOL:getPDFXR():generateTick(0.4, false)
        end
    end
    if pd.buttonJustPressed(pd.kButtonLeft) then
        self.left = not self.left

        if self.left then
            self.leftSprite:setImage(leftOnImage)
            PDFXR_POOL:getPDFXR():generateTick(0.4, true)
        else
            self.leftSprite:setImage(leftOffImage)
            PDFXR_POOL:getPDFXR():generateTick(0.4, false)
        end
    end
    if pd.buttonJustPressed(pd.kButtonRight) then
        self.right = not self.right

        if self.right then
            self.rightSprite:setImage(rightOnImage)
            PDFXR_POOL:getPDFXR():generateTick(0.4, true)
        else
            self.rightSprite:setImage(rightOffImage)
            PDFXR_POOL:getPDFXR():generateTick(0.4, false)
        end
    end
end