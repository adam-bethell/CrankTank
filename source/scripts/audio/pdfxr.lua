import "CoreLibs/object"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("PDFXR").extends(gfx.sprite)

function PDFXR:init()
    --print("new PDFXR")
    self.synth = pd.sound.synth.new(pd.sound.kWaveNoise)
    self.synthDouble = pd.sound.synth.new(pd.sound.kWaveNoise)
    
    self.synthChannel = pd.sound.channel.new()
    self.synthChannel:setVolume(1)
    self.synthChannel:addSource(self.synth)
    self.synthChannel:addSource(self.synthDouble)

    self.delayLine = pd.sound.delayline.new(2)
    self.delayLine:setMix(0)
    self.synthChannel:addEffect(self.delayLine)

    self.delayChannel = pd.sound.channel.new()
    self.delayChannel:setVolume(1)
    self.delayTaps = {
        self.delayLine:addTap(0),
        self.delayLine:addTap(0),
        self.delayLine:addTap(0),
        self.delayLine:addTap(0)
    }
    for i=1, #self.delayTaps do
        self.delayTaps[i]:setVolume(0)
        self.delayChannel:addSource(self.delayTaps[i])
    end

    self.vibrato = pd.sound.lfo.new(pd.sound.kLFOSine)
    self.vibrato:setRetrigger(true)

    self.phaserLine = pd.sound.delayline.new(0.1)
    self.phaserLine:setMix(0)
    self.synthChannel:addEffect(self.phaserLine)
    self.phaserTap = self.phaserLine:addTap(0)
    self.phaserTap:setVolume(0)
    self.delayChannel:addSource(self.phaserTap)

    self.freqLFO = pd.sound.lfo.new(pd.sound.kLFOSquare)
    self.freqLFO:setRetrigger(true)

end

function PDFXR:play()
    self.synth:playNote(self.baseFreq, 1, self.noteLength)
    if self.secondNoteEnabled then
        self.synth:playNote(
            self.baseFreq * self.secondNoteFreqMult,
            1,
            self.noteLength,
            pd.sound.getCurrentTime() + self.secondNoteDelay
        )
    end
    if self.playDouble then
        self.synthDouble:playNote(self.baseFreq * self.doubleFreqOffsetMult, 1, self.noteLength)
    end
end

function PDFXR:setVolume(volume)
    self.synthChannel:setVolume(volume)
    self.delayChannel:setVolume(volume)
end

function PDFXR:isPlaying()
    return self.synth:isPlaying() or self.synthDouble:isPlaying()
end

function PDFXR:resetParameters()
    -- Waveform
    self.synth:setVolume(1)
    -- ADSR
    self.synth:setAttack(0)
    self.synth:setDecay(0.05)
    self.synth:setSustain(0.2)
    self.synth:setRelease(0.1)
    -- Note
    self.baseFreq = 440
    self.noteLength = 1
    -- Delay
    for i=1, #self.delayTaps do
        self.delayTaps[i]:setVolume(0)
    end
    -- Vibrato
    self.synth:setAmplitudeMod(nil)
    -- Phaser
    self.synth:setVolume(1)
    self.phaserTap:setVolume(0)
    -- LFO Pitch
    self.synth:setFrequencyMod(nil)
    -- Second Note
    self.secondNoteEnabled = false
    -- Double Note
    self.playDouble = false
end

function PDFXR:generateTick(vol, hiLo)
    self:resetParameters()
    self:setVolume(vol)

    -- Waveform
    self.synth:setWaveform(pd.sound.kWaveNoise)

    -- ADSR
    self.synth:setAttack(0)
    self.synth:setDecay(0)
    self.synth:setSustain(1)
    self.synth:setRelease(0.05)

    -- Note
    if hiLo then
        self.baseFreq = ((math.random()^2) * 20) + 16000
    else
        self.baseFreq = ((math.random()^2) * 20) + 10000
    end
    self.noteLength = 0.02

    self:play()
end

function PDFXR:generatePickup(vol)
    self:resetParameters()
    self:setVolume(vol)

    -- Waveform
    self.synth:setWaveform(pd.sound.kWaveSawtooth)

    -- ADSR
    self.synth:setAttack(0)
    self.synth:setDecay(0.2 + (math.random()*0.3))
    self.synth:setSustain(0.7 + (math.random()*0.3))
    self.synth:setRelease(0.2 + (math.random()*0.3))

    -- Note
    self.baseFreq = ((math.random()^2) * 200) + 800
    self.noteLength = 0.1 + (math.random()*0.2)

    -- Second Note
    self.secondNoteEnabled = true
    self.secondNoteFreqMult = 2
    self.secondNoteDelay = 0.1

    self:play()
end

function PDFXR:generateShot(vol)
    self:resetParameters()
    self:setVolume(vol)

    -- Waveform
    self.synth:setWaveform(pd.sound.kWaveSawtooth)

    -- ADSR
    self.synth:setAttack(0)
    self.synth:setDecay(0)
    self.synth:setSustain(0.7 + (math.random()*0.3))
    self.synth:setRelease(0.05 + (math.random()*0.1))

    -- Note
    self.baseFreq = ((math.random()^2) * 30) + 500
    self.noteLength = 0.2 + (math.random()*0.1)

    -- Delay
    for i=1, #self.delayTaps do
        self.delayTaps[i]:setVolume(0)
    end

    -- Vibrato
    self.synth:setAmplitudeMod(nil)

    -- Phaser
    self.phaserTap:setDelay(0.002 + (math.random() * 0.018))
    self.synth:setVolume(0.35)
    self.phaserTap:setVolume(0.35)

    -- LFO Pitch
    self.synth:setFrequencyMod(self.freqLFO)
    self.freqLFO:setType(pd.sound.kLFOSawtoothDown)
    self.freqLFO:setRate(self.noteLength)
    self.freqLFO:setDepth(20)
    self.freqLFO:setCenter(-20)
    self.freqLFO:setStartPhase(0)

    -- Second Note
    self.secondNoteEnabled = false

    -- Double Note
    self.playDouble = false

    self:play()
end

function PDFXR:generateUIBeep(vol, hiLo)
    self:resetParameters()
    self:setVolume(vol)

    -- Waveform
    self.synth:setWaveform(pd.sound.kWaveSquare)
    self.synth:setVolume(0.4)

    -- ADSR
    self.synth:setAttack(0)
    self.synth:setDecay(0.05)
    self.synth:setSustain(0.2)
    self.synth:setRelease(0.1)

    -- Note
    if hiLo then
        self.baseFreq = ((math.random()^2) * 20) + 2000
    else
        self.baseFreq = ((math.random()^2) * 20) + 1800
    end
    self.noteLength = 0.05

    -- Double Note
    self.playDouble = true
    self.synthDouble = self.synth:copy()
    self.synthChannel:addSource(self.synthDouble)
    self.synthDouble:setVolume(0.4)
    self.doubleFreqOffsetMult = 1.01

    self:play()
end

function PDFXR:generateUISelect(vol)
    self:resetParameters()
    self:setVolume(vol)

    -- Waveform
    self.synth:setWaveform(pd.sound.kWaveSquare)
    self.synth:setVolume(1)

    -- ADSR
    self.synth:setAttack(0)
    self.synth:setDecay(0.05)
    self.synth:setSustain(0.2)
    self.synth:setRelease(0.2)

    -- Note
    self.baseFreq = ((math.random()^2) * 20) + 1400
    self.noteLength = 0.15

    -- Delay
    local delayLife = 0.6
    local delay = 0.1 + (math.random()*0.03)
    local delaySum = delay
    for i=1, #self.delayTaps do
        self.delayTaps[i]:setDelay(delaySum)
        local volume = 1.0 - (delaySum / delayLife)
        self.delayTaps[i]:setVolume(volume)
        delaySum += delay
    end

    -- LFO Pitch
    self.synth:setFrequencyMod(self.freqLFO)
    self.freqLFO:setType(pd.sound.kLFOSampleAndHold)
    self.freqLFO:setRate(20)
    self.freqLFO:setDepth(1)
    self.freqLFO:setCenter(-1)
    self.freqLFO:setStartPhase(0.5)

    self:play()
end

function PDFXR:generateLazer(vol)
    self:resetParameters()
    self:setVolume(vol)

    -- Waveform
    self.synth:setWaveform(pd.sound.kWaveTriangle)

    -- ADSR
    self.synth:setAttack(0)
    self.synth:setDecay(0)
    self.synth:setSustain(0.7 + (math.random()*0.3))
    self.synth:setRelease(0.03 + (math.random()*0.1))

    -- Note
    self.baseFreq = ((math.random()^2) * 30) + 1000
    self.noteLength = 0.1 + (math.random()*0.1)

    -- Phaser
    self.phaserTap:setDelay(0.02 + (math.random() * 0.02))
    self.synth:setVolume(0.45)
    self.phaserTap:setVolume(0.45)

    -- LFO Pitch
    self.synth:setFrequencyMod(self.freqLFO)
    self.freqLFO:setType(pd.sound.kLFOSawtoothDown)
    self.freqLFO:setRate(self.noteLength)
    self.freqLFO:setDepth(50)
    self.freqLFO:setCenter(-50)
    self.freqLFO:setStartPhase(0)

    self:play()
end

function PDFXR:generatePlink(vol)
    self:resetParameters()
    self:setVolume(vol)

    -- Waveform
    self.synth:setWaveform(pd.sound.kWaveNoise)

    -- ADSR
    self.synth:setAttack(0)
    self.synth:setDecay(0)
    self.synth:setSustain(0.7 + (math.random()*0.3))
    self.synth:setRelease(0.05 + (math.random()*0.1))

    -- Note
    self.baseFreq = ((math.random()^2) * 30) + 200
    self.noteLength = 0.03 + (math.random()*0.04)

    -- Phaser
    self.phaserTap:setDelay(0.002 + (math.random() * 0.018))
    self.synth:setVolume(0.45)
    self.phaserTap:setVolume(0.45)

    self:play()
end

function PDFXR:generateExplosion(vol)
    self:resetParameters()
    self:setVolume(vol)

    -- Waveform
    self.synth:setWaveform(pd.sound.kWaveNoise)

    -- ADSR
    self.synth:setAttack(0)
    self.synth:setDecay(0.2 + (math.random()*0.3))
    self.synth:setSustain(0.15 + (math.random()*0.25))
    self.synth:setRelease(0.5 + (math.random()*0.5))

    -- Note
    self.baseFreq = ((math.random()^2) * 50) + 35
    self.noteLength = 0.15 + (math.random()*0.25)

    -- Delay
    local delayLife = 0.6
    local delay = 0.07 + (math.random()*0.3)
    local delaySum = delay
    for i=1, #self.delayTaps do
        self.delayTaps[i]:setDelay(delaySum)
        local volume = 1.0 - (delaySum / delayLife)
        self.delayTaps[i]:setVolume(volume)
        delaySum += delay
    end
    
    -- Vibrato
    if math.random(0, 1) == 0 then
        self.synth:setAmplitudeMod(nil)
    else
        local depth = 0.07 + (math.random()*0.1)
        self.vibrato:setDepth(depth)
        self.vibrato:setCenter(0.9 - (depth/2))
        self.vibrato:setRate(4 + (math.random()*3))
        self.synth:setAmplitudeMod(self.vibrato)
    end
    
    -- Phaser
    if math.random(0, 1) == 0 then
        self.phaserTap:setVolume(0)
        self.synth:setVolume(1)
    else
        self.phaserTap:setDelay(0.002 + (math.random() * 0.018))
        self.synth:setVolume(0.45)
        self.phaserTap:setVolume(0.45)
    end

    self:play()
end
