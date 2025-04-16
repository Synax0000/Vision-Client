local AssetSystem = {}

function AssetSystem:LoadAssetSources() 
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

            writefile("Vision-Client\\Assets\\" .. File.name, FileResponse.Body)
        end
    end
end

return AssetSystem