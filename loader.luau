_G.VisionClient = {} 
_G.VisionClient.CloseAllThreads = false 

local Compactibility = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/refs/heads/main/Libraries/Compatibility.luau"))()
Compactibility:Check()

local Main = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/refs/heads/main/main.luau"))()
Main:Init()