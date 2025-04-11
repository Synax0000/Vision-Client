_G.VisionClient = {} 
_G.VisionClient.CloseAllThreads = false 

local Compatibility = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/refs/heads/main/Libraries/Compatibility.luau"))()
if Compatibility:Check() == "NOT COMPATIBLE" then
    warn("Vision Client is not compatible with the executor you are useing.")
    return
end


local Main = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/main/main.luau"))()
Main:Init()