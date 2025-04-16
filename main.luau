_G.VisionGlobals = {}
_G.VisionGlobals.Assets = {}
_G.VisionGlobals.Modules = {}
_G.VisionGlobals.Configs = {}
_G.VisionGlobals.CLOSETHREADS = false


local SourceLoader = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/main/Modules/SourceLoader.luau"))()
SourceLoader:LoadSource()

_G.VisionGlobals.Modules.AssetSystem = loadstring(readfile("Vision-Client\\Modules\\AssetSystem.luau"))()
_G.VisionGlobals.Modules.DataSystem = loadstring(readfile("Vision-Client\\Modules\\DataSystem.luau"))()
_G.VisionGlobals.Modules.UILib = loadstring(readfile("Vision-Client\\Modules\\UILib.luau"))()

_G.VisionGlobals.Modules.AssetSystem:LoadAssetSources()

local PlaceID = game.PlaceId

if not isfolder("Vision-Client\\Games\\" .. PlaceID .. ".luau") then
    PlaceID = 0
end

_G.VisionGlobals.Modules.DataSystem:LoadConfigs(PlaceID)
loadstring(readfile("Vision-Client\\Games\\" .. PlaceID .. ".luau"))()


