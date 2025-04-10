local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/refs/heads/main/Libraries/UI.luau"))()
local Assets = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/refs/heads/main/Libraries/Assets.luau"))()
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/refs/heads/main/Themes/default.luau"))()

_G.VisionClient = {} -- temp
_G.VisionClient.CloseAllThreads = false -- temp

local Ui = Lib:Init(Theme, Assets)
local TestTab = Lib:InitTab(Ui, Theme, {
    ["Title"] = "Test Tab",
})

local container = Lib:InitItemContainer(TestTab, Theme, "Test Container", {})