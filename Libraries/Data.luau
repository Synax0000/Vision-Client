local Lib = {}

function Lib:UpdateThemes()
    CurrentExistingThemes = listfiles("VisionClient/Themes")
    LiveThemes = game:httpget("https://raw.githubusercontent.com/Synax0000/Vision-Client/refs/heads/main/Themes/themes.luau")

    for Theme in pairs(LiveThemes) do
        if not table.find(CurrentExistingThemes, Theme) then
            ThemeContents = game:httpget(Theme)
            ThemeName = loadstring(ThemeContents)()["ThemeName"]
            writefile("VisionClient/Themes/" .. ThemeName .. ".luau", Theme)
        end
    end
end

function Lib:LoadConfig(Path)
    Lib:UpdateThemes()

    if isfolder("VisionClient") then
        return readfile(Path)
    else
        makefolder("VisionClient")
        makefolder("VisionClient/GameConfigs")
        makefolder("VisionClient/Themes")
        
        ThemeLinks = game:httpget("https://raw.githubusercontent.com/Synax0000/Vision-Client/refs/heads/main/Themes/themes.luau")

        for Theme in pairs(ThemeLinks) do
            ThemeContents = game:httpget(Theme)
            ThemeName = loadstring(ThemeContents)()["ThemeName"]
            writefile("VisionClient/Themes/" .. ThemeName .. ".luau", Theme)
        end

        Config = {
            ["Theme"] = "default",
            ["Themes"] = listfiles("VisionClient/Themes"),
            ["GameConfigs"] = listfiles("VisionClient/GameConfigs"),
            ["Keybind"] = Enum.KeyCode.Insert
        }

        writefile("VisionClient/GlobalConfig.json", game:GetService("HttpService"):JSONEncode(Config))

        return readfile("VisionClient/GlobalConfig.json")
    end
end

function Lib:SaveConfig(Config, Path)
    writefile(Path, game:GetService("HttpService"):JSONEncode(Config))
end

return Lib
