-- Universal

local Module = {
    Assets = nil,
    Theme = nil,
    Lib = nil,
}

function Module:Run() 
    Module.UIOBJECT = Module.Lib:Init(Module.Theme, Module.Assets)

    Module.Lib:InitTab(Module.UIOBJECT, Module.Theme, {
        Title = "Combat",
    })

    Module.Lib:InitTab(Module.UIOBJECT, Module.Theme, {
        Title = "Movement",
    })

    Module.Lib:InitTab(Module.UIOBJECT, Module.Theme, {
        Title = "Visuals",
    })

    Module.Lib:InitTab(Module.UIOBJECT, Module.Theme, {
        Title = "Utilities",
    })

    Module.Lib:InitExtras(Module.Lib, Module, Module.Theme);
end

return Module 