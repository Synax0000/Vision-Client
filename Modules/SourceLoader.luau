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
            local FileContent = HttpRequest({
                Url = File.download_url,
                Method = "GET"
            })

            writefile(FolderName .. "/" .. File.name, game:HttpGet(File.download_url))
        end
    end
end

function SourceLoader:LoadSource() 
    local RequiredFolders = {
        "Modules",
        "Games",
        "Assets"
    }

    for _,Folder in pairs(RequiredFolders) do
        makefolder(Folder)
        SourceLoader:LoadFolder(FolderName)
    end
end

return SourceLoader