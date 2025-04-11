local Lib = {}

function Lib:Init()
    local Data = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/refs/heads/main/Libraries/Data.luau"))()

    local GlobalConfig = game:GetService("HttpService"):JSONEDecode(Data:LoadConfig("VisionClient/GlobalConfig.json"))
    local Module = nil
    local GameConfig = nil
    
    local s,e pcall(function()
        Module = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/refs/heads/main/Games/" .. game.PlaceId .. ".luau"))()
        GameConfig = game:GetService("HttpService"):JSONEDecode(Data:LoadConfig("VisionClient/GameConfigs/" .. game.PlaceId .. ".json"))
    end)

    if not s then
        if isfile("VisionClient/GameConfigs/0.json") == false then
            writefile("VisionClient/GameConfigs/0.json", game:GetService("HttpService"):JSONEncode({}))
            GameConfig = {}
        end
        
        Module = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/refs/heads/main/Games/0.luau"))()
        GameConfig = game:GetService("HttpService"):JSONEDecode(Data:LoadConfig("VisionClient/GameConfigs/0.json"))
    end

    local Assets = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/refs/heads/main/Libraries/Assets.luau"))()
    local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/refs/heads/main/Libraries/UI.luau"))()
    local Theme = loadstring(readfile("VisionClient/Themes/" .. GlobalConfig.Theme .. ".luau"))()

    Module.Assets = Assets
    Module.Theme = Theme
    Module.Lib = UILib
    Module.Config = GameConfig

    Module:Run()
end

return Lib