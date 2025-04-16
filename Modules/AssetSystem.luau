local AssetSystem = {}

function AssetSystem:LoadAssetSources() 
    local TempScreenGui = Instance.new("ScreenGui")
    TempScreenGui.Name = "Vision-Client"
    TempScreenGui.Parent = game.CoreGui

    local InfoText = Instance.new("TextLabel")
    InfoText.Name = "InfoText"
    InfoText.Parent = TempScreenGui
    InfoText.BackgroundTransparency = 1.000
    InfoText.Position = UDim2.new(0, 0, 0, 0)
    InfoText.Size = UDim2.new(1, 0, 0.1, 0)
    InfoText.Font = Enum.Font.Arimo
    InfoText.Text = ""
    InfoText.TextScaled = true

    InfoText.Text = "Loading Assets..."

    local HttpService = game:GetService("HttpService")
    local HttpRequest = http_request or http.request or request
    local APIURL = "https://api.github.com/repos/Synax0000/Vision-Client/contents/"
    
    local Response = HttpRequest({
        Url = APIURL .. "Assets",
        Method = "GET"
    })

    local Data = HttpService:JSONDecode(Response.Body)

    for _,File in pairs(Data) do
        if File.type == "file" and (File.name:match(".png") or File.name:match(".jpg")) then
            local FileResponse = HttpRequest({
                Url = File.download_url,
                Method = "GET"
            })
            
            InfoText.Text = "Loading Asset '" .. File.name .. "'..."
            writefile("Vision-Client\\Assets\\" .. File.name, FileResponse.Body)
            
            _G.VisionGlobals.Assets[File.name] = getcustomasset("Vision-Client\\Assets\\" .. File.name)
        end
    end

    TempScreenGui:Destroy()
end

return AssetSystem