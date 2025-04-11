local Lib = {}

function Lib:UpdateThemes()
    CurrentExistingThemes = listfiles("VisionClient/Themes")
    LiveThemes = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/refs/heads/main/Themes/themes.luau"))()
    
    for _,Theme in pairs(LiveThemes) do
        if not table.find(CurrentExistingThemes, Theme) then
            ThemeContents = game:HttpGet(Theme)
            ThemeName = loadstring(ThemeContents)()["ThemeName"]
            writefile("VisionClient/Themes/" .. ThemeName .. ".luau", ThemeContents)
        end
    end

    ThemeConfig = game:GetService("HttpService"):JSONDecode(readfile("VisionClient/GlobalConfig.json"))
    ThemeConfig.Themes = listfiles("VisionClient/Themes")
    writefile("VisionClient/GlobalConfig.json", game:GetService("HttpService"):JSONEncode(ThemeConfig))
end

function Lib:LoadConfig(Path)
    local s,e = pcall(function()
        if isfolder("VisionClient") then
            Lib:UpdateThemes()
            return readfile(Path)
        else
            makefolder("VisionClient")
            makefolder("VisionClient/GameConfigs")
            makefolder("VisionClient/Themes")
            
            ThemeLinks = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/refs/heads/main/Themes/themes.luau"))()

            Config = {
                ["Theme"] = "default",
                ["Themes"] = listfiles("VisionClient/Themes"),
                ["GameConfigs"] = listfiles("VisionClient/GameConfigs"),
                ["Keybind"] = Enum.KeyCode.Insert,
            }

            writefile("VisionClient/GlobalConfig.json", game:GetService("HttpService"):JSONEncode(Config))
            
            Lib:UpdateThemes()
            return readfile("VisionClient/GlobalConfig.json")
        end
    end)

    if not s then
        return nil
    end
end

function Lib:SaveConfig(Config, Path)
    writefile(Path, game:GetService("HttpService"):JSONEncode(Config))
end

return Lib

