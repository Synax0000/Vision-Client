local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/refs/heads/main/Libraries/UI.luau"))()
local Assets = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/refs/heads/main/Libraries/Assets.luau"))()
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/Synax0000/Vision-Client/refs/heads/main/Themes/default.luau"))()

local Ui = Lib:Init(Theme, Assets)
local TestTab = Lib:InitTab(Ui, Theme, {
    ["Title"] = "Test Tab",
})

local container = Lib:InitItemContainer(TestTab, Theme, "Test Container", {})

Lib:SpawnLabel(container, Theme, {
    ["Text"] = "Test Label",
})

Lib:SpawnButton(container, Theme, {
    ["Text"] = "Test Button",
    ["Callback"] = function() end
})

Lib:SpawnToggle(container, Theme, {
    ["Text"] = "Test Toggle",
    ["Callback"] = function() end
})

Lib:SpawnSlider(container, Theme, {
    ["Text"] = "Test Slider",
    ["Min"] = 0,
    ["Max"] = 100,
    ["Number"] = 50,
    ["RawInt"] = true,
})

Lib:SpawnTextBox(container, Theme, {
    ["Text"] = "Test TextBox",
    ["PlaceholderText"] = "Placeholder"
})
