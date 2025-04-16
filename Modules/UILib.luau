local UILib = {} 
 
function UILib:AttachDrag(Object)
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")

    local Dragging = false

    local DragStart = Vector2.new()
    local StartPosition = UDim2.new()

    Object.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = Input.Position
            StartPosition = Object.Position
            
            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
            local Delta = Input.Position - DragStart
            local NewPosition = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)

            TweenService:Create(Object, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = NewPosition}):Play()
        end
    end)
end

function UILib:Init() 
    local VisionClient = Instance.new("ScreenGui")
    local VisionLogo = Instance.new("ImageLabel")
    local Background = Instance.new("Frame")

    VisionClient.Name = "VisionClient"
    VisionClient.Parent = game:WaitForChild("CoreGui")
    VisionClient.ResetOnSpawn = false
    VisionClient.IgnoreGuiInset = true
    VisionClient.ZIndexBehavior = Enum.ZIndexBehavior.Global
    VisionClient.DisplayOrder = 0

    VisionLogo.Name = "VisionLogo"
    VisionLogo.Parent = VisionClient
    VisionLogo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    VisionLogo.BackgroundTransparency = 1.000
    VisionLogo.BorderColor3 = Color3.fromRGB(0, 0, 0)
    VisionLogo.BorderSizePixel = 0
    VisionLogo.Position = UDim2.new(0.00767263444, 0, 0.0436815924, 0)
    VisionLogo.Size = UDim2.new(0.064, 0,0.124, 0)
    VisionLogo.Image = _G.VisionGlobals.Assets["visionclientlogo.png"]

    Background.Name = "Background"
    Background.Parent = VisionClient
    Background.BackgroundColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.MenuEnabledBackgroundColor
    Background.BackgroundTransparency = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.MenuEnabledTransparency 
    Background.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Background.BorderSizePixel = 0
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.ZIndex = 0

    _G.VisionGlobals.UIGLOBALS.VisionClientUI = VisionClient
    UILib:AttachDrag(VisionLogo) 
    
    game.UserInputService.InputBegan:Connect(function(Input)
        if Input.KeyCode == Enum.KeyCode[_G.VisionGlobals.Configs.GlobalConfig.UIKeybind] then
            VisionClient.Enabled = not VisionClient.Enabled 
        end
    end)
end

return UILib