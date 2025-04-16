local HttpService = game:GetService("HttpService")
local SourceLoader = {}

function SourceLoader:LoadFolder(FolderName) 
    local HttpService = game:GetService("HttpService")
    local HttpRequest = http_request or http.request or request
    local APIURL = "https://api.github.com/repos/Synax0000/Vision-Client/contents/"
    
    local Response = HttpRequest({
        Url = APIURL .. FolderName,
        Method = "GET"
    })

    local Data = HttpService:JSONDecode(Response)

    for _,File in pairs(Data) do
        if File.type == "file" then
            writefile(Vision-Client .. "\\" .. FolderName .. "\\" .. File.name, game:HttpGet(File.download_url))
        end
    end
end

function SourceLoader:LoadSource() 
    if isfolder("Vision-Client") then
        return
    end

    makefolder("Vision-Client")
    local RequiredFolders = {
        "Vision-Client\\Modules",
        "Vision-Client\\Games",
        "Vision-Client\\Assets"
    }

    for _,Folder in pairs(RequiredFolders) do
        makefolder(Folder)
        SourceLoader:LoadFolder(Folder)
    end
end

return SourceLoader