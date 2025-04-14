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

    Module.HoldingRightClick = false

    game.UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if GameProcessed then return end
        if Input.UserInputType == Enum.UserInputType.MouseButton2 then
            Module.HoldingRightClick = true
        end
    end)

    game.UserInputService.InputEnded:Connect(function(Input, GameProcessed)
        if GameProcessed then return end
        if Input.UserInputType == Enum.UserInputType.MouseButton2 then
            Module.HoldingRightClick = false
        end
    end)

    Module.Lib:InitExtras(Module.Lib, Module.UIOBJECT, Module.Theme);
    
    Module:CombatTabFunctions(Combat)
    Module:MovementTabFunctions(Movement)
    Module:VisualsTabFunctions(Visuals)
    Module:UtilitiesTabFunctions(Utilities)
end

function Module:GetPlayersWithinScreenView() 
    local VisiblePlayers = {}
    local LocalPlayer = game:GetService("Players").LocalPlayer

    for _,Player in pairs(game:GetService("Players"):GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("Head") then
            local Head = Player.Character.Head
            local ScreenPosition, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(Head.Position)

            if OnScreen and ScreenPosition.Z > 0 then
                table.insert(VisiblePlayers, Player)
            end
        end
    end

    return VisiblePlayers
end


function Module:IsPlayerObstructed(Player) 
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character}

    for _, iPlayer in pairs(game:GetService("Players"):GetPlayers()) do
        if iPlayer ~= game.Players.LocalPlayer and iPlayer ~= Player then
            table.insert(raycastParams.FilterDescendantsInstances, iPlayer.Character)
        end
    end 

    local Origin = game.Workspace.CurrentCamera.CFrame.Position
    local Direction = (Player.Character.Head.Position - Origin).Unit * (Player.Character.Head.Position - Origin).Magnitude

    local Result = workspace:Raycast(Origin, Direction, raycastParams)

    if Result then
        if Result.Instance:IsDescendantOf(Player.Character) then
            return false
        end
    end

    return true
end


function Module:GetBestPlayerInFov(Radius) 
    local Players = Module:GetPlayersWithinScreenView()
    local Camera = game.Workspace.CurrentCamera
    local MousePosition = game:GetService("UserInputService"):GetMouseLocation()
    
    local BestPlayer = nil
    local ClosestDistance = Radius/2

    for _, Player in pairs(Players) do
        if Player ~= game:GetService("Players").LocalPlayer and Player.Character:FindFirstChild("Head") and Player.Character:FindFirstChild("Humanoid").Health > 0 then
            local Head = Player.Character.Head

            if Module:IsPlayerObstructed(Player) == false then
                local PositionOnScreen, OnScreen = Camera:WorldToViewportPoint(Head.Position)
                PositionOnScreen = Vector2.new(PositionOnScreen.X, PositionOnScreen.Y)

                local Distance = (MousePosition - PositionOnScreen).Magnitude

                if OnScreen and Distance < ClosestDistance then
                    BestPlayer = PositionOnScreen
                    ClosestDistance = Distance
                end
            end
        end
    end

    return BestPlayer
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
    -- Aimbot

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

    local LockOnContainer = Module.Lib:InitItemContainer(CombatTab, Module.Theme)
    Module.Lib:SpawnLabel(LockOnContainer, Module.Theme, {Text = "Lock On",})

    local LockOnEnabled = false
    Module.Lib:SpawnToggle(LockOnContainer, Module.Theme, {
        Text = "LockOn-Enabled",
        DisplayText = "Enabled",
        Callback = function(Value)
            LockOnEnabled = Value
        end
    })

    Module.Lib:SpawnLabel(LockOnContainer, Module.Theme, {Text = "Target Range",})
    local LockOnRange = Module.Lib:SpawnSlider(LockOnContainer, Module.Theme, {
        Text = "LockOn-Range",
        Min = 0,
        Max = 100,
        RawInt = true,
        Number = 8,
    })

    Module.Lib:SpawnLabel(LockOnContainer, Module.Theme, {Text = "Smoothness",})
    local LockOnSmoothness = Module.Lib:SpawnSlider(LockOnContainer, Module.Theme, {
        Text = "LockOn-Smoothness",
        Min = 0.1,
        Max = 1,
        RawInt = false,
        Number = 0.5,
    })

    local AimAssistContainer = Module.Lib:InitItemContainer(CombatTab, Module.Theme)
    Module.Lib:SpawnLabel(AimAssistContainer, Module.Theme, {Text = "Aim Assist",})

    local AimAssistEnabled = false
    Module.Lib:SpawnToggle(AimAssistContainer, Module.Theme, {
        Text = "AimAssist-Enabled",
        DisplayText = "Enabled",
        Callback = function(Value)
            AimAssistEnabled = Value
        end
    })

    Module.Lib:SpawnLabel(AimAssistContainer, Module.Theme, {Text = "Aim Assist FOV",})
    local AimAssistFOVRange = Module.Lib:SpawnSlider(AimAssistContainer, Module.Theme, {
        Text = "AimAssist-FOV",
        Min = 0,
        Max = 500,
        RawInt = true,
        Number = 150,
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

                if LockOnEnabled then
                    local Player = Module:FindNearistPlayer(LockOnRange.Number)
                
                    if Player then
                        local Character = game.Players.LocalPlayer.Character
                        local TargetPosition = Player.Character.Head.Position
                        local Smoothness = LockOnSmoothness.Number
                        
                        local Origin = Character.PrimaryPart.Position
                        local Direction = (TargetPosition - Origin).Unit
                        local LookAt = CFrame.new(Origin, Origin + Direction)
                        local NewCFrame = Character.PrimaryPart.CFrame:Lerp(LookAt, Smoothness)
                        
                        Character:SetPrimaryPartCFrame(NewCFrame)                        
                    end
                end

                if AimAssistEnabled and Module.HoldingRightClick then
                    local BestPlayer = Module:GetBestPlayerInFov(AimAssistFOVRange.Number)

                    if BestPlayer then
                        local Camera = workspace.CurrentCamera
                        local MousePosition = game:GetService("UserInputService"):GetMouseLocation()     
                        
                        local MousePosition = game.UserInputService:GetMouseLocation()
                        local Delta = (BestPlayer - MousePosition) * 0.05
                        mousemoverel(Delta.X, Delta.Y)
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