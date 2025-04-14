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
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game:WaitForChild("CoreGui")

    local AimAssistFOVCircle = Instance.new("Frame")
    AimAssistFOVCircle.BackgroundTransparency = 1.000
    AimAssistFOVCircle.Visible = false
    AimAssistFOVCircle.Parent = ScreenGui

    local AimAssistFOVCircleCorner = Instance.new("UICorner")
    AimAssistFOVCircleCorner.Parent = AimAssistFOVCircle
    AimAssistFOVCircleCorner.CornerRadius = UDim.new(100, 0)

    local AimAssistFOVCircleStroke = Instance.new("UIStroke")
    AimAssistFOVCircleStroke.Parent = AimAssistFOVCircle
    AimAssistFOVCircleStroke.Thickness = 1
    AimAssistFOVCircleStroke.LineJoinMode = Enum.LineJoinMode.Round
    AimAssistFOVCircleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    AimAssistFOVCircleStroke.Color = Module.Theme.TextColor

    local AimbotFOVCircle = Instance.new("Frame")
    AimbotFOVCircle.Visible = false
    AimbotFOVCircle.BackgroundTransparency = 1.000
    AimbotFOVCircle.Parent = ScreenGui

    local AimbotFOVCircleCorner = Instance.new("UICorner")
    AimbotFOVCircleCorner.Parent = AimbotFOVCircle
    AimbotFOVCircleCorner.CornerRadius = UDim.new(100, 0)

    local AimbotFOVCircleStroke = Instance.new("UIStroke")
    AimbotFOVCircleStroke.Parent = AimbotFOVCircle
    AimbotFOVCircleStroke.Thickness = 1
    AimbotFOVCircleStroke.LineJoinMode = Enum.LineJoinMode.Round
    AimbotFOVCircleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    AimbotFOVCircleStroke.Color = Module.Theme.TextColor

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
            AimAssistFOVCircle.Visible = Value
        end
    })

    Module.Lib:SpawnLabel(AimAssistContainer, Module.Theme, {Text = "Aim Assist FOV",})
    local AimAssistFOVRange = Module.Lib:SpawnSlider(AimAssistContainer, Module.Theme, {
        Text = "AimAssist-FOV",
        Min = 50,
        Max = 1000,
        RawInt = true,
        Number = 200,
    })

    Module.Lib:SpawnLabel(AimAssistContainer, Module.Theme, {Text = "Hold Rightclick to AimAssist",})

    local AimbotContainer = Module.Lib:InitItemContainer(CombatTab, Module.Theme)
    Module.Lib:SpawnLabel(AimbotContainer, Module.Theme, {Text = "Aimbot",})

    local AimbotEnabled = false
    Module.Lib:SpawnToggle(AimbotContainer, Module.Theme, {
        Text = "Aimbot-Enabled",
        DisplayText = "Enabled",
        Callback = function(Value)
            AimbotEnabled = Value
            AimbotFOVCircle.Visible = Value
        end
    })

    Module.Lib:SpawnLabel(AimbotContainer, Module.Theme, {Text = "Aimbot FOV",})
    local AimbotFOVRange = Module.Lib:SpawnSlider(AimbotContainer, Module.Theme, {
        Text = "Aimbot-FOV",
        Min = 50,
        Max = 1000,
        RawInt = true,
        Number = 200,
    })

    Module.Lib:SpawnLabel(AimbotContainer, Module.Theme, {Text = "Hold Rightclick to Aimbot",})

    AimAssistFOVCircle.Size = UDim2.new(0, AimAssistFOVRange.Number, 0, AimAssistFOVRange.Number)
    AimAssistFOVCircle.Position = UDim2.new(0.5, -AimAssistFOVRange.Number / 2, 0.5, -AimAssistFOVRange.Number / 2)

    AimbotFOVCircle.Size = UDim2.new(0, AimbotFOVRange.Number, 0, AimbotFOVRange.Number)
    AimbotFOVCircle.Position = UDim2.new(0.5, -AimbotFOVRange.Number / 2, 0.5, -AimbotFOVRange.Number / 2)

    Module.UIOBJECT.UI.Destroying:Connect(function()
        ScreenGui:Destroy()
    end)

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
                        local Delta = (BestPlayer - MousePosition) * 0.04
                        mousemoverel(Delta.X, Delta.Y)
                    end
                end

                if AimbotEnabled and Module.HoldingRightClick then
                    local BestPlayer = Module:GetBestPlayerInFov(AimbotFOVRange.Number)

                    if BestPlayer then
                        local Camera = workspace.CurrentCamera
                        local MousePosition = game:GetService("UserInputService"):GetMouseLocation()     
                        
                        local MousePosition = game.UserInputService:GetMouseLocation()
                        local Delta = (BestPlayer - MousePosition) * 0.15
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
    local SpeedContainer = Module.Lib:InitItemContainer(MovementTab, Module.Theme)
    Module.Lib:SpawnLabel(SpeedContainer, Module.Theme, {Text = "Speed",})

    local SpeedEnabled = false
    Module.Lib:SpawnToggle(SpeedContainer, Module.Theme, {
        Text = "Speed-Enabled",
        DisplayText = "Enabled",
        Callback = function(Value)
            SpeedEnabled = Value
        end
    })

    local SpeedRange = Module.Lib:SpawnSlider(SpeedContainer, Module.Theme, {
        Text = "Speed",
        Min = 1,
        Max = 10,
        RawInt = true,
        Number = 4,
    })

    local UseWalkSpeed = false
    Module.Lib:SpawnToggle(SpeedContainer, Module.Theme, {
        Text = "Use-Walk-Speed",
        DisplayText = "Use Walkspeed",
        Callback = function(Value)
            UseWalkSpeed = Value
        end
    })

    local WalkSpeedRange = Module.Lib:SpawnSlider(SpeedContainer, Module.Theme, {
        Text = "Walk Speed",
        Min = 1,
        Max = 1000,
        RawInt = true,
        Number = 30,
    })

    local InfinteJumpContainer = Module.Lib:InitItemContainer(MovementTab, Module.Theme)
    Module.Lib:SpawnLabel(InfinteJumpContainer, Module.Theme, {Text = "Infinte Jump",})

    local InfinteJumpEnabled = false
    Module.Lib:SpawnToggle(InfinteJumpContainer, Module.Theme, {
        Text = "InfinteJump-Enabled",
        DisplayText = "Enabled",
        Callback = function(Value)
            InfinteJumpEnabled = Value
        end
    })

    local InfinteJumpPlatform = nil

    local UsePlatform = false
    Module.Lib:SpawnToggle(InfinteJumpContainer, Module.Theme, {
        Text = "Use-Platform",
        DisplayText = "Use Platform",
        Callback = function(Value)
            UsePlatform = Value

            if Value then
                InfinteJumpPlatform.Transparency = 0.5
                InfinteJumpPlatform.CanCollide = true
            else
                InfinteJumpPlatform.Transparency = 1
                InfinteJumpPlatform.CanCollide = false
            end
        end
    })

    local ClickToTPContainer = Module.Lib:InitItemContainer(MovementTab, Module.Theme)
    Module.Lib:SpawnLabel(ClickToTPContainer, Module.Theme, {Text = "Click To TP",})

    local ClickToTPEnabled = false
    Module.Lib:SpawnToggle(ClickToTPContainer, Module.Theme, {
        Text = "ClickToTP-Enabled",
        DisplayText = "Enabled",
        Callback = function(Value)
            ClickToTPEnabled = Value
        end
    })

    Module.Lib:SpawnLabel(ClickToTPContainer, Module.Theme, {Text = "Click To TP Range",})
    local ClickToTPRange = Module.Lib:SpawnSlider(ClickToTPContainer, Module.Theme, {
        Text = "ClickToTP-Range",
        Min = 0,
        Max = 10000,
        RawInt = true,
        Number = 1000,
    })

    game.UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if GameProcessed then return end
        if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == Enum.KeyCode.Space then
            if InfinteJumpEnabled then
                if UsePlatform then
                    if not InfinteJumpPlatform then
                        InfinteJumpPlatform = Instance.new("Part")
                        InfinteJumpPlatform.Anchored = true
                        InfinteJumpPlatform.CanCollide = true
                        InfinteJumpPlatform.Transparency = 0.5
                        InfinteJumpPlatform.Size = Vector3.new(5, 1, 5)
                        InfinteJumpPlatform.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame - Vector3.new(0, 0.5, 0)
                        InfinteJumpPlatform.Parent = game.Workspace
                    else
                        InfinteJumpPlatform.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame - Vector3.new(0, 0.5, 0)
                    end

                    game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                else
                    game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end

        if Input.UserInputType == Enum.UserInputType.MouseButton1 and ClickToTPEnabled then
            local MouseHit = game.Players.LocalPlayer:GetMouse().Hit
            
            
            local Distance = (MouseHit.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

            if Distance > ClickToTPRange.Number then
                return
            end

            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = MouseHit
        end
    end)


    coroutine.wrap(function()
        while _G.VisionClient.CloseAllThreads == false do
            task.wait()

            local s,e = pcall(function()
                if SpeedEnabled then
                    if UseWalkSpeed then
                        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeedRange.Number
                    else
                        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame += game.Players.LocalPlayer.Character.Humanoid.MoveDirection * SpeedRange.Number
                    end
                end
            end)
        end

        InfinteJumpPlatform:Destroy()
    end)()
end

function Module:VisualsTabFunctions(VisualsTab)
    -- TODO: ADD
    -- Nametags
    -- Tracers
    -- Health Bar

    local ESPStrokeColor = nil
    local ESPColor = nil

    local function AttachESP(Character)
        local FillColorParsed = string.split(ESPColor.TextboxText, ",")

        for i = 1, #FillColorParsed do
            local Number = tonumber(FillColorParsed[i])

            if Number then
                FillColorParsed[i] = Number
            else
                table.remove(FillColorParsed, i)
            end
        end

        local FillR = tonumber(FillColorParsed[1])
        local FillG = tonumber(FillColorParsed[2])
        local FillB = tonumber(FillColorParsed[3])

        local StrokeColorParsed = string.split(ESPStrokeColor.TextboxText, ",")

        for i = 1, #StrokeColorParsed do
            local Number = tonumber(StrokeColorParsed[i])

            if Number then
                StrokeColorParsed[i] = Number
            else
                table.remove(StrokeColorParsed, i)
            end
        end

        local StrokeR = tonumber(StrokeColorParsed[1])
        local StrokeG = tonumber(StrokeColorParsed[2])
        local StrokeB = tonumber(StrokeColorParsed[3])

        local ESP = Instance.new("Highlight")
        ESP.Name = "ESP"
        ESP.Enabled = true

        if StrokeR == nil then
            ESP.StrokeTransparency = 1
        else
            ESP.StrokeTransparency = 0.5
            ESP.StrokeColor = Color3.fromRGB(StrokeR, StrokeG, StrokeB)
        end

        if FillR == nil then
            ESP.FillTransparency = 1
        else
            ESP.FillTransparency = 0.5
            ESP.FillColor = Color3.fromRGB(FillR, FillG, FillB)
        end

        ESP.Parent = Character
    end

    local ESPContainer = Module.Lib:InitItemContainer(VisualsTab, Module.Theme)
    Module.Lib:SpawnLabel(ESPContainer, Module.Theme, {Text = "ESP",})

    local ESPEnabled = false
    Module.Lib:SpawnToggle(ESPContainer, Module.Theme, {
        Text = "ESP-Enabled",
        DisplayText = "Enabled",
        Callback = function(Value)
            ESPEnabled = Value

            if Value then
                for _, Player in pairs(game.Players:GetPlayers()) do
                    if Player.Character and not Player.Character:FindFirstChild("ESP") then
                        AttachESP(Player.Character)
                    end
                end
            else
                for _, Player in pairs(game.Players:GetPlayers()) do
                    if Player.Character and Player.Character:FindFirstChild("ESP") then
                        Player.Character.ESP:Destroy()
                    end
                end
            end
        end
    })

    Module.Lib:SpawnLabel(ESPContainer, Module.Theme, {Text = "ESP Color - Leave empty for no fill",})
    ESPColor = Module.Lib:SpawnTextBox(ESPContainer, Module.Theme, {
        Text = "ESP-Color",
        TextboxText = "255,0,0",
        PlaceholderText = "R,G,B",
    })

    Module.Lib:SpawnLabel(ESPContainer, Module.Theme, {Text = "ESP Stroke Color - Leave empty for no stroke",})
    ESPStrokeColor = Module.Lib:SpawnTextBox(ESPContainer, Module.Theme, {
        Text = "ESP-Stroke-Color",
        TextboxText = "255,255,255",
        PlaceholderText = "R,G,B",
    })

    local Connection = game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(Character)
        if ESPEnabled then
            AttachESP(Character)
        end
    end)

    while _G.VisionClient.CloseAllThreads == false do
        task.wait()
    end

    Connection:Disconnect()
end

function Module:UtilitiesTabFunctions(UtilitiesTab)
    local NoUtilityContainer = Module.Lib:InitItemContainer(UtilitiesTab, Module.Theme)
    Module.Lib:SpawnLabel(NoUtilityContainer, Module.Theme, {Text = "No Utilities - for now",})
end

return Module 