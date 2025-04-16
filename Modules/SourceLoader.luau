local HttpService = game:GetService("HttpService")
local SourceLoader = {}

function SourceLoader:LoadFolder(FolderName, InfoText) 
    InfoText.Text = "Loading Folder '" .. FolderName .. "' 'Contents..."

    local HttpService = game:GetService("HttpService")
    local HttpRequest = http_request or http.request or request
    local APIURL = "https://api.github.com/repos/Synax0000/Vision-Client/contents/"
    
    local Response = HttpRequest({
        Url = APIURL .. FolderName,
        Method = "GET"
    })

    local Data = HttpService:JSONDecode(Response.Body)

    for _,File in pairs(Data) do
        if File.type == "file" then
            local FileResponse = HttpRequest({
                Url = File.download_url,
                Method = "GET"
            })
            
            InfoText.Text = "Loading File'" .. FolderName .. "\\" .. File.name .. "'..."
            writefile("Vision-Client" .. "\\" .. FolderName .. "\\" .. File.name, FileResponse.Body)
        end
    end
end

function SourceLoader:LoadSource() 
    local TempScreenGui = Instance.new("ScreenGui")
    TempScreenGui.Name = "Vision-Client"
    TempScreenGui.Parent = game.CoreGui

    local InfoText = Instance.new("TextLabel")
    InfoText.Name = "InfoText"
    InfoText.Parent = TempScreenGui
    InfoText.BackgroundTransparency = 1.000
    InfoText.Position = UDim2.new(0, 0, 0, 0)
    InfoText.TextColor3 = Color3.fromRGB(216, 119, 255)
    InfoText.Size = UDim2.new(1, 0, 0.1, 0)
    InfoText.Font = Enum.Font.Arimo
    InfoText.Text = ""
    InfoText.TextScaled = true

    makefolder("Vision-Client")
    local RequiredFolders = {
        "Modules",
        "Games",
        "Assets",
        "Configs",
        "Themes"
    }

    for _,Folder in pairs(RequiredFolders) do
        InfoText.Text = "Loading Folder'" .. Folder .. "'..."
        makefolder("Vision-Client\\" .. Folder)

        local s,e = pcall(function()
            SourceLoader:LoadFolder(Folder, InfoText)
        end)

        if not s and Folder ~= "Configs" then
            print(e)
        end
    end

    TempScreenGui:Destroy()
end

return SourceLoader