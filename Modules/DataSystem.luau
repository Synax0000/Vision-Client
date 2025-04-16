local DataSystem = {}

function DataSystem:LoadConfigs(PlaceID) 
    local HttpService = game:GetService("HttpService")

    if isfile("Vision-Client\\Configs\\GlobalConfig.json") then
        _G.VisionGlobals.Configs.GlobalConfig = HttpService:JSONDecode(readfile("Vision-Client\\Configs\\GlobalConfig.json"))
        _G.VisionGlobals.Configs.PlaceConfig = HttpService:JSONDecode(readfile("Vision-Client\\Configs\\" .. PlaceID .. ".json"))
    else
        _G.VisionGlobals.Configs.GlobalConfig = {
            ["UIKeybind"] = "Insert",
            ["Theme"] = "Default"
        }
        _G.VisionGlobals.Configs.PlaceConfig = {}

        writefile("Vision-Client\\Configs\\GlobalConfig.json", HttpService:JSONEncode(_G.VisionGlobals.Configs.GlobalConfig))
        writefile("Vision-Client\\Configs\\" .. PlaceID .. ".json", HttpService:JSONEncode(_G.VisionGlobals.Configs.PlaceConfig))
    end

    _G.VisionGlobals.Configs.GlobalConfig.ThemeData = loadstring(readfile("Vision-Client\\Themes\\" .. _G.VisionGlobals.Configs.GlobalConfig.Theme .. ".luau"))()
end

return DataSystem