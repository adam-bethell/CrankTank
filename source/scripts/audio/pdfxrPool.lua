import "CoreLibs/object"
import "scripts/audio/PDFXR"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("PDFXRPool").extends(gfx.sprite)

function PDFXRPool:init(volume)
    self.pool = {}
    for i=1, 5 do
        self.pool[i] = PDFXR()
    end
    if volume == nil then
        volume = 1
    end
    self.vol = volume
end

function PDFXRPool:getPDFXR()
    for i=1, #self.pool do
        if not self.pool[i]:isPlaying() then
            return self.pool[i]
        end
    end

    print("New PDFXR added to pool")
    self.pool[#self.pool+1] = PDFXR()
    return self.pool[#self.pool]
end