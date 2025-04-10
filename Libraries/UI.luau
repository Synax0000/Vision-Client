local Lib = {}

function Lib:Init(Theme, Assets)
    local WindowData = {
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

    WindowData.UI = VisionClient

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

    game.UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if GameProcessed then return end
        print(WindowData.Keybind)
        if Input.KeyCode == WindowData.Keybind then
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
    local UiPadding = Instance.new("UIPadding")

    Tab.Name = TabData.Title
    Tab.Parent = UIData.UI.MainFrame.Tabs
    Tab.BackgroundColor3 = Color3.fromRGB(26, 23, 29)
    Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Tab.BorderSizePixel = 0
    Tab.Size = UDim2.new(1, 0, 0.0511965838, 0)
    Tab.AutoButtonColor = false
    Tab.Font = Enum.Font.ArialBold
    Tab.Text = TabData.Title
    Tab.TextColor3 = Theme.TextColor
    Tab.TextWrapped = false
    Tab.TextScaled = true
    Tab.TextTransparency = 0.5

    UITextSizeConstraint.Parent = Tab

    UiPadding.Parent = Tab
    UiPadding.PaddingLeft = UDim.new(0.1, 0)
    UiPadding.PaddingRight = UDim.new(0.1, 0)
    UiPadding.Parent = Tab

    local TabPage = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")

    TabPage.Name = "TabPage"
    TabPage.Parent = UIData.UI.MainFrame
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
    TabObject.TabPage = TabPage

    Tab.MouseButton1Click:Connect(function()
        for _, TabObject in pairs(UIData.UI.MainFrame.Tabs:GetChildren()) do
            if TabObject:IsA("TextButton") then
                TabObject.TextTransparency = 0.5
            end
        end

        for _, TabDataObject in pairs(UIData.UI.MainFrame.Tabs:GetChildren()) do
            if not TabDataObject == Tab and TabDataObject:IsA("TextButton") then
                TabDataObject.TabPage.Visible = false
                TabDataObject.Selected = false
                TabDataObject.TabButton.TextTransparency = 0.5
            end
        end

        Tab.TextTransparency = 0
        TabPage.Visible = true
        TabObject.Selected = true
    end)

    table.insert(UIData.Tabs, TabObject)

    return TabObject
end


function Lib:InitItemContainer(TabData, Theme, ContainerName, ItemData)
    local ContainerObject = {}

    local ItemContainer = Instance.new("Frame")
    local Container = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    local UIStroke = Instance.new("UIStroke")

    ItemContainer.Name = "ItemContainer"
    ItemContainer.Parent = TabData.TabPage
    ItemContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ItemContainer.BackgroundTransparency = 1.000
    ItemContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ItemContainer.BorderSizePixel = 0
    ItemContainer.ClipsDescendants = true
    ItemContainer.Size = UDim2.new(0.996865213, 0, 1, 0)

    Container.Name = "Container"
    Container.Parent = ItemContainer
    Container.BackgroundColor3 = Theme.BackgroundColor
    Container.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Container.BorderSizePixel = 0
    Container.ClipsDescendants = true
    Container.Position = UDim2.new(0.0156985875, 0, 0.0339702778, 0)

    UIListLayout.Parent = Container
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    UIStroke.Parent = Container
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Theme.StrokeColor
    UIStroke.Thickness = Theme.StrokeThickness

    ContainerObject.Container = Container
    Container.Size = UDim2.new(Container.Size.X.Scale, Container.Size.X.Offset, 0, UIListLayout.AbsoluteContentSize.Y)

    return ContainerObject
end

return Lib