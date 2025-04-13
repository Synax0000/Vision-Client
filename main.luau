local Lib = {}

function Lib:Init()
    local Data = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/main/Libraries/Data.luau"))()

    local GlobalConfig = game:GetService("HttpService"):JSONDecode(Data:LoadConfig("VisionClient/GlobalConfig.json"))
    local Module = nil
    local GameConfig = nil
    
    local s,e = pcall(function()
        Module = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/main/Games/" .. game.PlaceId .. ".luau"))()
        GameConfig = game:GetService("HttpService"):JSONDecode(Data:LoadConfig("VisionClient/GameConfigs/" .. game.PlaceId .. ".json"))
    end)

    local PlaceId = game.PlaceId

    if not s then
        if isfile("VisionClient/GameConfigs/0.json") == false then
            writefile("VisionClient/GameConfigs/0.json", game:GetService("HttpService"):JSONEncode({}))
        end
        
        GameConfig = {}
        PlaceId = 0
        
        Module = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/main/Games/0.luau"))()
        GameConfig = game:GetService("HttpService"):JSONDecode(Data:LoadConfig("VisionClient/GameConfigs/0.json"))
    end


    local Assets = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/main/Libraries/Assets.luau"))()
    local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/main/Libraries/UI.luau"))()
    local Theme = loadstring(readfile("VisionClient/Themes/" .. GlobalConfig.Theme .. ".luau"))()

    Module.Assets = Assets
    Module.Theme = Theme
    Module.Lib = UILib

    _G.VisionClient.LocalConfig = GameConfig
    _G.VisionClient.GlobalConfig = GlobalConfig

    if GlobalConfig == "null" then
        _G.VisionClient.GlobalConfig = {}
    end

    if GameConfig == "null" then
        _G.VisionClient.LocalConfig = {}
    end

    coroutine.wrap(function() 
        while task.wait(math.random(5, 20)) do
            print("📃 Saving configs...")
            writefile("VisionClient/GameConfigs/" .. PlaceId .. ".json", game:GetService("HttpService"):JSONEncode(_G.VisionClient.LocalConfig))
            writefile("VisionClient/GlobalConfig.json", game:GetService("HttpService"):JSONEncode(_G.VisionClient.GlobalConfig))
            print("✅ Saved configs.")
        end
    end)()

    local PlayerGUI = game.Players.LocalPlayer.PlayerGui

    PlayerGUI.Destroying:Connect(function() -- Likely means player is leaving
        print("📃 Saving configs...")
        writefile("VisionClient/GameConfigs/" .. PlaceId .. ".json", game:GetService("HttpService"):JSONEncode(_G.VisionClient.LocalConfig))
        writefile("VisionClient/GlobalConfig.json", game:GetService("HttpService"):JSONEncode(_G.VisionClient.GlobalConfig))
        print("✅ Saved configs.")
    end)

    Module:Run()
end

return Lib