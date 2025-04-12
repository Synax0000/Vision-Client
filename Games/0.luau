-- Universal

local Module = {
    Assets = nil,
    Theme = nil,
    Lib = nil,
}

function Module:Run() 
    Module.UIOBJECT = Module.Lib:Init(Module.Theme, Module.Assets)

    local Combat = Module.Lib:InitTab(Module.UIOBJECT, Module.Theme, {
        Title = "Combat",
    })

    local Movement = Module.Lib:InitTab(Module.UIOBJECT, Module.Theme, {
        Title = "Movement",
    })

    local Visuals = Module.Lib:InitTab(Module.UIOBJECT, Module.Theme, {
        Title = "Visuals",
    })

    local Utilities = Module.Lib:InitTab(Module.UIOBJECT, Module.Theme, {
        Title = "Utilities",
    })

    Module.Lib:InitExtras(Module.Lib, Module.UIOBJECT, Module.Theme);

    Module:CombatTabFunctions(Combat)
    Module:MovementTabFunctions(Movement)
    Module:VisualsTabFunctions(Visuals)
    Module:UtilitiesTabFunctions(Utilities)
end

function Module:FindNearistPlayer(Range) 
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character
    local CharacterPosition = Character.PrimaryPart.Position
    local ClosestPlayer = nil
    local ClosestDistance = math.huge

    pcall(function() 
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer then
                local PlayerCharacter = Player.Character
    
                if PlayerCharacter and PlayerCharacter.PrimaryPart then
                    local PlayerPosition = PlayerCharacter.PrimaryPart.Position
                    local Distance = (PlayerPosition - CharacterPosition).Magnitude
    
                    if Distance < ClosestDistance and Distance <= Range then
                        ClosestPlayer = Player
                        ClosestDistance = Distance
                    end
                end
            end
        end
    end)
    

    return ClosestPlayer
end

function Module:CombatTabFunctions(CombatTab)
    -- TODO: ADD
    -- Tp Aura
    -- Orbit Aura
    -- Click Aura
    -- Auto Clicker
    -- Aimbot
    -- Aim Assist

    local TpAuraContainer = Module.Lib:InitItemContainer(CombatTab, Module.Theme)
    Module.Lib:SpawnLabel(TpAuraContainer, Module.Theme, {Text = "Tp Aura",})

    local TpAuraEnabled = false
    Module.Lib:SpawnToggle(TpAuraContainer, Module.Theme, {
        Text = "TpAura-Enabled",
        DisplayText = "Enabled",
        Callback = function(Value)
            TpAuraEnabled = Value
        end
    })

    Module.Lib:SpawnLabel(TpAuraContainer, Module.Theme, {Text = "Target Range",})
    local TpAuraRange = Module.Lib:SpawnSlider(TpAuraContainer, Module.Theme, {
        Text = "TpAura-Range",
        Min = 0,
        Max = 100,
        RawInt = true,
        Number = 20,
    })

    Module.Lib:SpawnLabel(TpAuraContainer, Module.Theme, {Text = "Distance Behind",})
    local DistanceBehind = Module.Lib:SpawnSlider(TpAuraContainer, Module.Theme, {
        Text = "TpAura-DistanceBehind",
        RawInt = true,
        Min = 0,
        Max = 100,
        Number = 4,
    })

    coroutine.wrap(function()
        while _G.VisionClient.CloseAllThreads == false do
            task.wait()
            pcall(function() -- final failsafe
                if TpAuraEnabled then
                    local Player = Module:FindNearistPlayer(TpAuraRange.Value)
    
                    if Player then
                        Player.Character.PrimaryPart.CFrame = game.Players.LocalPlayer.Character.PrimaryPart.CFrame + -(game.Players.LocalPlayer.Character.PrimaryPart.CFrame.LookVector * DistanceBehind.Value)
                    end
                end
            end)
        end
    end)()
end

function Module:MovementTabFunctions(MovementTab)
    -- TODO: ADD    
    -- Speed
    -- Flight
    -- Infinite Jump
    -- Platform Float
    -- Click To Tp    
end

function Module:VisualsTabFunctions(VisualsTab)
    -- TODO: ADD
    -- ESP
    -- Aimbot
    -- Box ESP
    -- Nametags
    -- Tracers
    -- Health Bar
end

function Module:UtilitiesTabFunctions(UtilitiesTab)
    -- TODO: ADD
    -- Gravity Changer
    -- Noclip
    -- rejoin
end

return Module 