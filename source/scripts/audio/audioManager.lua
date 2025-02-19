import "CoreLibs/object"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("AudioManager").extends()

function AudioManager:init()
    self.voPlayer = pd.sound.sampleplayer.new("audio/crank_tank_vo")
    self.voPlayer:setVolume(0.8)
    self.voPlayer:setFinishCallback(function() self.music:play(0) end)

    self.music = pd.sound.fileplayer.new("audio/music")
    self.music:setVolume(0.3)
end

function AudioManager:playCrankTankVO()
    self.voPlayer:play()
end

function AudioManager:muteMusic(mute)
    if mute then
        self.music:setVolume(0)
    else
        self.music:setVolume(0.3)
    end
end