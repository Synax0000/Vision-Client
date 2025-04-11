-- Universal

local Module = {
    Assets = nil,
    Theme = nil,
    Lib = nil,
}

function Module:Run() 
    Module.UIOBJECT = Module.Lib:Init(Module.Theme, Module.Assets)

    Module.UIOBJECT:InitTab(Module.UIOBJECT, Module.Theme, {
        Title = "Combat",
    })

    Module.UIOBJECT:InitTab(Module.UIOBJECT, Module.Theme, {
        Title = "Movement",
    })

    Module.UIOBJECT:InitTab(Module.UIOBJECT, Module.Theme, {
        Title = "Visuals",
    })

    Module.UIOBJECT:InitTab(Module.UIOBJECT, Module.Theme, {
        Title = "Utilities",
    })

    Module.UIOBJECT:InitExtras(Module.UIOBJECT, Module.Theme);
end

return Module 