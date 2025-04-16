local HttpService = game:GetService("HttpService")
_G.VisionGlobals = {}

local SourceLoader = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/main/Modules/SourceLoader.luau"))()
SourceLoader:LoadSource()

