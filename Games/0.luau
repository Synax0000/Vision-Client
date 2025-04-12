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

    local s,e = pcall(function() 
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

    if not s then
        print(e)
    end
    
    return ClosestPlayer
end

function Module:CombatTabFunctions(CombatTab)
    -- TODO: ADD
    -- Orbit Aura
    -- Lock On
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
        Number = 8,
    })

    Module.Lib:SpawnLabel(TpAuraContainer, Module.Theme, {Text = "Distance Behind",})
    local DistanceBehind = Module.Lib:SpawnSlider(TpAuraContainer, Module.Theme, {
        Text = "TpAura-DistanceBehind",
        RawInt = true,
        Min = 0,
        Max = 100,
        Number = 2,
    })

    -- Just make the orbit aura set the players cframe in a circle around the player

    local OrbitAuraContainer = Module.Lib:InitItemContainer(CombatTab, Module.Theme)
    Module.Lib:SpawnLabel(OrbitAuraContainer, Module.Theme, {Text = "Orbit Aura",})

    local OrbitAuraEnabled = false
    Module.Lib:SpawnToggle(OrbitAuraContainer, Module.Theme, {
        Text = "OrbitAura-Enabled",
        DisplayText = "Enabled",
        Callback = function(Value)
            OrbitAuraEnabled = Value
        end
    })

    Module.Lib:SpawnLabel(OrbitAuraContainer, Module.Theme, {Text = "Target Range",})
    local OrbitAuraRange = Module.Lib:SpawnSlider(OrbitAuraContainer, Module.Theme, {
        Text = "OrbitAura-Range",
        Min = 0,
        Max = 100,
        RawInt = true,
        Number = 8,
    })

    local OrbitAngle = 0;
    Module.Lib:SpawnLabel(OrbitAuraContainer, Module.Theme, {Text = "Rotation Speed",})
    local DistanceBehind = Module.Lib:SpawnSlider(OrbitAuraContainer, Module.Theme, {
        Text = "OrbitAura-RotateSpeed",
        RawInt = true,
        Min = 0,
        Max = 6,
        Number = 2,
    })

    coroutine.wrap(function()
        while _G.VisionClient.CloseAllThreads == false do
            task.wait()
            local s,e = pcall(function() -- final failsafe
                if TpAuraEnabled then
                    local Player = Module:FindNearistPlayer(TpAuraRange.Number)
    
                    if Player then
                        game.Players.LocalPlayer.Character.PrimaryPart.CFrame = Player.Character.PrimaryPart.CFrame + -(Player.Character.PrimaryPart.CFrame.LookVector * DistanceBehind.Number)
                    end
                end

                if OrbitAuraEnabled then
                    local Player = Module:FindNearistPlayer(OrbitAuraRange.Number)
                
                    if Player then
                        local TargetPos = Player.Character.PrimaryPart.Position
                        local Radius = OrbitAuraRange.Number/2
                        local Speed = DistanceBehind.Number / 10
                
                        OrbitAngle += Speed
                
                        local X = math.cos(OrbitAngle) * Radius
                        local Z = math.sin(OrbitAngle) * Radius
                
                        local NewPosition = Vector3.new(TargetPos.X + X, TargetPos.Y, TargetPos.Z + Z)
                
                        game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(NewPosition, TargetPos))
                    end
                end
                
            end)

            if not s then
                print(e)
            end
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