local Lib = {}

function Lib:Init(Theme, Assets)
    local WindowData = {}
    WindowData.Data = {
        Keybind = Enum.KeyCode.Insert,
        Tabs = {},
    }
    
    local VisionClient = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local Tabs = Instance.new("ScrollingFrame")
    
    local UIListLayout = Instance.new("UIListLayout")
    local WindowBar = Instance.new("Frame")
    local Logo = Instance.new("ImageLabel")
    local Minimize = Instance.new("ImageButton")
    local Exit = Instance.new("ImageButton")
    local UiStroke = Instance.new("UIStroke")

    Lib.Data.UI = VisionClient

    VisionClient.Name = "VisionClient"
    VisionClient.Parent = game:WaitForChild("CoreGui")
    VisionClient.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    MainFrame.Name = "MainFrame"
    MainFrame.Parent = VisionClient
    MainFrame.BackgroundColor3 = Theme.LightBackgroundColor
    MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Position = UDim2.new(0.246803075, 0, 0.0928338766, 0)
    MainFrame.Size = UDim2.new(0.510230184, 0, 0.812703609, 0)

    if Theme.WindowBorderVisble then
        UiStroke.Parent = MainFrame
    end

    UiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UiStroke.Thickness = Theme.StrokeThickness
    UiStroke.Color = Theme.StrokeColor

    Tabs.Name = "Tabs"
    Tabs.Parent = MainFrame
    Tabs.Active = true
    Tabs.BackgroundColor3 = Theme.BackgroundColor
    Tabs.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Tabs.BorderSizePixel = 0
    Tabs.Position = UDim2.new(0, 0, 0.0561122522, 0)
    Tabs.Size = UDim2.new(0.200501248, 0, 0.943887711, 0)
    Tabs.ScrollBarThickness = Theme.ScrollBarThickness

    UIListLayout.Parent = Tabs
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    WindowBar.Name = "WindowBar"
    WindowBar.Parent = MainFrame
    WindowBar.BackgroundColor3 = Theme.DarkBackgroundColor
    WindowBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
    WindowBar.BorderSizePixel = 0
    WindowBar.Size = UDim2.new(1, 0, 0.0561122261, 0)

    Logo.Name = "Logo"
    Logo.Parent = MainFrame
    Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Logo.BackgroundTransparency = 1.000
    Logo.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Logo.BorderSizePixel = 0
    Logo.Size = UDim2.new(0.0350877196, 0, 0.0561122261, 0)
    Logo.Image = Assets.VisionLogo

    Minimize.Name = "Minimize"
    Minimize.Parent = MainFrame
    Minimize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Minimize.BackgroundTransparency = 1.000
    Minimize.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Minimize.BorderSizePixel = 0
    Minimize.Position = UDim2.new(0.914786994, 0, 0, 0)
    Minimize.Size = UDim2.new(0.0350877196, 0, 0.0561122261, 0)
    Minimize.AutoButtonColor = false
    Minimize.Image = Assets.MinimizeWindowIcon
    Minimize.ImageRectOffset = Vector2.new(0, 292)
    Minimize.ImageRectSize = Vector2.new(72, 72)
    Minimize.ScaleType = Enum.ScaleType.Fit

    Exit.Name = "Exit"
    Exit.Parent = MainFrame
    Exit.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Exit.BackgroundTransparency = 1.000
    Exit.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Exit.BorderSizePixel = 0
    Exit.Position = UDim2.new(0.962406039, 0, 0, 0)
    Exit.Size = UDim2.new(0.0350877196, 0, 0.0561122261, 0)
    Exit.AutoButtonColor = false
    Exit.Image = Assets.CloseWindowIcon

    Exit.MouseButton1Click:Connect(function()
        VisionClient:Destroy()
        _G.VisionClient.CloseAllThreads = true
    end)

    Minimize.MouseButton1Click:Connect(function()
        VisionClient.Enabled = not VisionClient.Enabled
    end)

    Exit.MouseEnter:Connect(function()
        Exit.BackgroundColor3 = Theme.BackgroundColor
    end)

    Exit.MouseLeave:Connect(function()
        Exit.BackgroundColor3 = Theme.DarkBackgroundColor
    end)

    Minimize.MouseEnter:Connect(function()
        Minimize.BackgroundColor3 = Theme.BackgroundColor
    end)

    Minimize.MouseLeave:Connect(function()
        Minimize.BackgroundColor3 = Theme.BackgroundColor
    end)

    game.UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if GameProcessed then return end
        if Input.KeyCode == Lib.Data["Keybind"] then
            VisionClient.Enabled = not VisionClient.Enabled
        end
    end)

    local function DraggingThread() 
        local DragToggle = nil
        local DragSpeed = 0.25
        local DragStart = nil
        local StartPos = nil

        local function UpdateInput(Input)
            local Delta = Input.Position - DragStart
            local Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X,StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)

            game:GetService('TweenService'):Create(MainFrame, TweenInfo.new(DragSpeed), {Position = Position}):Play()
        end

        local ConnectionInputBegan = MainFrame.InputBegan:Connect(function(Input)
            if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then 
                DragToggle = true
                DragStart = Input.Position
                StartPos = MainFrame.Position

                Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        DragToggle = false
                    end
                end)
            end
        end)

        local ConnectionInputChanged = game.UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                if DragToggle then
                    UpdateInput(input)
                end
            end
        end)

        while task.wait(1) do
            if _G.VisionClient.CloseAllThreads then
                ConnectionInputBegan:Disconnect()
                ConnectionInputChanged:Disconnect()
                return
            end
        end
    end

    coroutine.wrap(DraggingThread)()

    return WindowData
end

function Lib:InitTab(UIData, Theme, TabData)
    local TabObject = {}
    TabObject.Data = {
        Selected = false
    }

    local Tab = Instance.new("TextButton")
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

    Tab.Name = TabData.Title
    Tab.Parent = UIData.UI
    Tab.BackgroundColor3 = Color3.fromRGB(26, 23, 29)
    Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Tab.BorderSizePixel = 0
    Tab.Size = UDim2.new(1, 0, 0.0811965838, 0)
    Tab.AutoButtonColor = false
    Tab.Font = Enum.Font.ArialBold
    Tab.Text = TabData.Title
    Tab.TextColor3 = Theme.TextColor
    Tab.TextScaled = true
    Tab.TextSize = 14.000
    Tab.TextTransparency = 0.5
    Tab.TextWrapped = true

    UITextSizeConstraint.Parent = Tab

    local TabPage = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")

    TabPage.Name = "TabPage"
    TabPage.Parent = UIData.UI
    TabPage.Active = true
    TabPage.BackgroundColor3 = Color3.fromRGB(38, 32, 42)
    TabPage.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabPage.BorderSizePixel = 0
    TabPage.Position = UDim2.new(0.19924812, 0, 0.0561122224, 0)
    TabPage.Size = UDim2.new(0.799498737, 0, 0.943887711, 0)
    TabPage.ScrollBarThickness = Theme.ScrollBarThickness
    TabPage.Visible = false

    UIListLayout.Parent = TabPage
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    TabObject.TabButton = Tab

    Tab.MouseButton1Click:Connect(function()
        for _, TabObject in pairs(UIData.UI.Tabs:GetChildren()) do
            if TabObject:IsA("TextButton") then
                TabObject.TextTransparency = 0.5
            end
        end

        for _, TabDataObject in pairs(UIData.Tabs:GetChildren()) do
            if not TabDataObject.TabButton == Tab then
                TabDataObject.UI.Visible = false
                TabDataObject.Selected = false
                TabDataObject.TabButton.TextTransparency = 0.5
            end
        end

        Tab.TextTransparency = 0
        TabPage.Visible = true
        TabObject.Selected = true
    end)

    table.insert(UIData.Tabs, TabObject)

    return Tab
end


return Lib