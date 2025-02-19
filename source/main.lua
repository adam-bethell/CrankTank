import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "scripts/audio/audioManager"
import "scripts/levels/sceneManager"
import "scripts/levels/levelSelect"
import "scripts/levels/tankLevel"

local pd <const> = playdate
local gfx <const> = pd.graphics

math.randomseed(pd.getSecondsSinceEpoch())

playdate.getSystemMenu():addCheckmarkMenuItem("Music", true, function(value)
    AUDIO_MANAGER:muteMusic(not value)
end)

PDFXR_POOL = PDFXRPool()
AUDIO_MANAGER = AudioManager()
SCENE_MANAGER = SceneManager()
LevelSelect()

AUDIO_MANAGER:playCrankTankVO()

function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
    --pd.drawFPS(380, 0)
end