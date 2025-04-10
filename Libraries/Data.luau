local Lib = {}

function Lib:LoadConfig()
    if isfolder("VisionClient") then
        return readfile("VisionClient/Config.json")
    else
        createfolder("VisionClient")
        -- TODO
    end
end

return Lib