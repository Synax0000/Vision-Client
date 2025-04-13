_G.VisionClient = {} 
_G.VisionClient.CloseAllThreads = false 

local Compatibility = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/main/Libraries/Compatibility.luau"))()
Status, Reasons = Compatibility:Check()
if Status == "NOT COMPATIBLE" then
    warn("Vision Client is not compatible with the executor you are useing.")

    for i, v in pairs(Reasons) do
        warn(v .. " Is not supported by your executor.")
    end

    return
end


local Main = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/main/main.luau"))()
Main:Init()