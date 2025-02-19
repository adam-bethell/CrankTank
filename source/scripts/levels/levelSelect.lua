import "CoreLibs/object"
import "CoreLibs/ui"
import "CoreLibs/graphics"

import "scripts/levels/sceneManager"
import "scripts/levels/tankLevel"
import "scripts/levels/tankLevelData"
import "scripts/audio/pdfxr"
import "scripts/audio/pdfxrPool"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("LevelSelect").extends(gfx.sprite)

local rocketIcon = gfx.image.new("images/tank/rocketLauncherIcon")
assert(rocketIcon)
local tankIcon = gfx.image.new("images/tank/tankIcon")
assert(tankIcon)
local tankPhoto = gfx.image.new("images/tank/tankPhoto")
assert(tankPhoto)

local lastSection = nil
local lastRow = nil

function LevelSelect:init()
    self.levelList = pd.ui.gridview.new(0, 20)
    self.levelList:setContentInset(10, 10, 5, 5)
    self.levelList:setCellPadding(5, 5, 5, 0)
    self.levelList:setSectionHeaderHeight(20)
    self.levelList:setNumberOfRowsInSection(1, #TankLevelData[1])
    self.levelList:setNumberOfRowsInSection(2, #TankLevelData[2])
    function self.levelList:drawSectionHeader(section, x, y, width, height)
        if section == 1 then
            gfx.drawText("_.................. Training .................._", x, y, width, height)
        elseif section == 2 then
            gfx.drawText("_.................. Missions .................._", x, y, width, height)
        end
    end
    function self.levelList:drawCell(section, row, column, selected, x, y, width, height)
        gfx.setFont(gfx.getSystemFont("bold"))
        if not selected then
            gfx.drawText(TankLevelData[section][row].name, x, y, width, height)
        else
            tankIcon:draw(x, y)
            local w, h = gfx.drawText(TankLevelData[section][row].name, x+30, y, width, height)
            gfx.drawLine(x, y+h, x+35+w, y+h)
            --rocketIcon:draw(x+16+w+10, y)
        end
    end

    if lastSection ~= nil and lastRow ~= nil then
        self.levelList:setSelection(lastSection, lastRow, 1)
        self.levelList:scrollCellToCenter(lastSection, lastRow, 1, false)
    end

    self:moveTo(200,120)
    self:add()
end

function LevelSelect:update()
    if pd.buttonJustPressed(pd.kButtonUp) then
        self.levelList:selectPreviousRow(true, true, true)
        PDFXR_POOL:getPDFXR():generateUIBeep(0.3, false)
    end
    if pd.buttonJustPressed(pd.kButtonDown) then
        self.levelList:selectNextRow(true, true, true)
        PDFXR_POOL:getPDFXR():generateUIBeep(0.3, true)
    end

    if pd.buttonJustPressed(pd.kButtonA) then
        local col = nil
        lastSection, lastRow, col = self.levelList:getSelection()
        PDFXR_POOL:getPDFXR():generateUISelect(0.3)
        SCENE_MANAGER:changeScene(TankLevel, TankLevelData[lastSection][lastRow], "test 1", "test 2")
    end

    local image = gfx.image.new(400, 240)
    gfx.pushContext(image)
        gfx.fillRoundRect(5, 5, 390, 35, 5)
        gfx.setImageDrawMode(playdate.graphics.kDrawModeInverted)
        gfx.setFont(gfx.getSystemFont("bold"))
        gfx.drawTextInRect("Crank TANK", 5, 15, 390, 35, nil, nil, kTextAlignment.center)
        gfx.setImageDrawMode(playdate.graphics.kDrawModeCopy)

        self.levelList:drawInRect(0, 45, 400, 195)

        tankPhoto:draw(185, 65)
        gfx.setLineWidth(4)
        gfx.drawRoundRect(185, 65, 190, 160, 5)
    gfx.popContext()
    self:setImage(image)
end