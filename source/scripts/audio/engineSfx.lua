import "CoreLibs/object"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("EngineSFX").extends(gfx.sprite)

function EngineSFX:init()
    self.channel = pd.sound.channel.new()

    self.osc1 = pd.sound.synth.new(pd.sound.kWaveSawtooth)
    self.osc1:setADSR(0.2, 0, 1, 0.1)
    self.osc2 = pd.sound.synth.new(pd.sound.kWaveSawtooth)
    self.osc2:setADSR(0.2, 0, 1, 0.1)

    self.inst1 = pd.sound.instrument.new(self.osc1)
    self.inst2 = pd.sound.instrument.new(self.osc2)

    self.channel:addSource(self.inst1)
    self.channel:addSource(self.inst2)

    self.freq = 20

    self.channel:setVolume(0.1)
end

function EngineSFX:setSpeed(value)
    --self.freq = 20 + (value * 40)
    value *= 2
    self.inst1:setPitchBend(value)
    self.inst2:setPitchBend(value)

    if value == 0 and self.osc1:isPlaying() then
        self:stop()
    elseif value > 0 and not self.osc1:isPlaying() then
        self:start()
    end
end

function EngineSFX:start()
    self.inst1:playNote(20)
    self.inst2:playNote(24)
    --self.osc1:playNote(self.freq, 1)
    --self.osc2:playNote((self.freq * 2) * 0.98, 1)
end

function EngineSFX:stop()
    self.inst1:allNotesOff()
    self.inst2:allNotesOff()
    --self.osc1:noteOff()
    --self.osc2:noteOff()
end

