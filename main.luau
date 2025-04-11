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

    if not s then
        if isfile("VisionClient/GameConfigs/0.json") == false then
            writefile("VisionClient/GameConfigs/0.json", game:GetService("HttpService"):JSONEncode({}))
            GameConfig = {}
        end
        
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

    coroutine.wrap(function() 
        while task.wait(math.random(5, 20)) do
            print("📃 Saving configs...")
            writefile("VisionClient/GameConfigs/" .. game.PlaceId .. ".json", game:GetService("HttpService"):JSONEncode(_G.VisionClient.LocalConfig))
            writefile("VisionClient/GlobalConfig.json", game:GetService("HttpService"):JSONEncode(_G.VisionClient.GlobalConfig))
            print("✅ Saved configs.")
        end
    end)()

    game:BindToClose(function()
        print("📃 Saving configs...")
        writefile("VisionClient/GameConfigs/" .. game.PlaceId .. ".json", game:GetService("HttpService"):JSONEncode(_G.VisionClient.LocalConfig))
        writefile("VisionClient/GlobalConfig.json", game:GetService("HttpService"):JSONEncode(_G.VisionClient.GlobalConfig))
        print("✅ Saved configs.")
    end)

    Module:Run()
end

return Lib