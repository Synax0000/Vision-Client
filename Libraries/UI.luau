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
    ItemContainer.Size = UDim2.new(0.997, 0,0.55, 0)

    Container.Name = "Container"
    Container.Parent = ItemContainer
    Container.BackgroundColor3 = Theme.BackgroundColor
    Container.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Container.BorderSizePixel = 0
    Container.ClipsDescendants = true
    Container.Position = UDim2.new(0.0156985875, 0, 0.0339702778, 0)
    Container.Size = UDim2.new(0.978, 0, 0.5, 0)

    UIListLayout.Parent = Container
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    UIStroke.Parent = Container
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Theme.StrokeColor
    UIStroke.Thickness = Theme.StrokeThickness

    ContainerObject.Container = Container

    return ContainerObject
end

function Lib:SpawnLabel(ContainerObject, Theme, LabelData) 
    local LabelContainer = Instance.new("Frame")
    local Label = Instance.new("TextLabel")
    local UIPadding_2 = Instance.new("UIPadding")
    local UIStroke = Instance.new("UIStroke")

    LabelContainer.Name = "LabelContainer"
    LabelContainer.Parent = ContainerObject.Container
    LabelContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LabelContainer.BackgroundTransparency = 1.000
    LabelContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LabelContainer.BorderSizePixel = 0
    LabelContainer.Size = UDim2.new(1, 0, 0.121004567, 0)

    Label.Name = "Label"
    Label.Parent = LabelContainer
    Label.BackgroundColor3 = Theme.DarkBackgroundColor
    Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Label.BorderSizePixel = 0
    Label.Position = UDim2.new(0.0210696924, 0, 0.192780986, 0)
    Label.Size = UDim2.new(0.956239879, 0, 0.603773594, 0)
    Label.Font = Enum.Font.ArimoBold
    Label.Text = LabelData.Text
    Label.TextColor3 = Theme.TextColor
    Label.TextScaled = true
    Label.TextSize = 14.000
    Label.TextWrapped = true
    Label.TextXAlignment = Enum.TextXAlignment.Left

    UIPadding_2.Parent = Label
    UIPadding_2.PaddingLeft = UDim.new(0.00999999978, 0)

    UIStroke.Parent = Label
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Theme.StrokeColor
    UIStroke.Thickness = Theme.StrokeThickness
end

function Lib:SpawnButton(ContainerObject, Theme, ButtonData) 
    local ButtonContainer = Instance.new("Frame")
    local TextButton = Instance.new("TextButton")
    local UIPadding = Instance.new("UIPadding")
    local UIStroke = Instance.new("UIStroke")

    ButtonContainer.Name = "ButtonContainer"
    ButtonContainer.Parent = ContainerObject.Container
    ButtonContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ButtonContainer.BackgroundTransparency = 1.000
    ButtonContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ButtonContainer.BorderSizePixel = 0
    ButtonContainer.Size = UDim2.new(1, 0, 0.121004567, 0)

    TextButton.Parent = ButtonContainer
    TextButton.BackgroundColor3 = Theme.DarkBackgroundColor
    TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextButton.BorderSizePixel = 0
    TextButton.Position = UDim2.new(0.0209999997, 0, 0.193000004, 0)
    TextButton.Size = UDim2.new(0.956239879, 0, 0.603773594, 0)
    TextButton.Font = Enum.Font.ArimoBold
    TextButton.Text = ButtonData.Text
    TextButton.TextColor3 = Theme.TextColor
    TextButton.TextScaled = true
    TextButton.TextSize = 14.000
    TextButton.TextWrapped = true
    TextButton.TextXAlignment = Enum.TextXAlignment.Left

    UIPadding.Parent = TextButton
    UIPadding.PaddingLeft = UDim.new(0.00999999978, 0)

    UIStroke.Parent = TextButton
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Theme.StrokeColor
    UIStroke.Thickness = Theme.StrokeThickness

    TextButton.MouseButton1Click:Connect(ButtonData.Callback)
end

function Lib:SpawnToggle(ContainerObject, Theme, ToggleData) 
    local ButtonContainer = Instance.new("Frame")
    local TextButton = Instance.new("TextButton")
    local UIPadding = Instance.new("UIPadding")
    local UIStroke = Instance.new("UIStroke")

    ButtonContainer.Name = "ButtonContainer"
    ButtonContainer.Parent = ContainerObject.Container
    ButtonContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ButtonContainer.BackgroundTransparency = 1.000
    ButtonContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ButtonContainer.BorderSizePixel = 0
    ButtonContainer.Size = UDim2.new(1, 0, 0.121004567, 0)

    TextButton.Parent = ButtonContainer
    TextButton.BackgroundColor3 = Theme.DarkBackgroundColor
    TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextButton.BorderSizePixel = 0
    TextButton.Position = UDim2.new(0.0209999997, 0, 0.193000004, 0)
    TextButton.Size = UDim2.new(0.956239879, 0, 0.603773594, 0)
    TextButton.Font = Enum.Font.ArimoBold
    TextButton.Text = ToggleData.Text
    TextButton.TextColor3 = Theme.TextColor
    TextButton.TextScaled = true
    TextButton.TextSize = 14.000
    TextButton.TextWrapped = true
    TextButton.TextXAlignment = Enum.TextXAlignment.Left

    UIPadding.Parent = TextButton
    UIPadding.PaddingLeft = UDim.new(0.00999999978, 0)

    UIStroke.Parent = TextButton
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Theme.StrokeColor
    UIStroke.Thickness = Theme.StrokeThickness

    TextButton.MouseButton1Click:Connect(function()
        if TextButton.BackgroundColor3 == Theme.DarkBackgroundColor then
            TextButton.BackgroundColor3 = Theme.ButtonToggledColor
            ToggleData.Callback(true)
        else
            TextButton.BackgroundColor3 = Theme.DarkBackgroundColor
            ToggleData.Callback(false)
        end
    end)
end

function Lib:SpawnSlider(ContainerObject, Theme, SliderData) 
    local SliderContainer = Instance.new("Frame")
    local SliderDetector = Instance.new("TextButton")
    local Slider = Instance.new("Frame")
    local Bar = Instance.new("Frame")
    local Display = Instance.new("TextLabel")
    local UiStroke = Instance.new("UIStroke")

    SliderContainer.Name = "SliderContainer"
    SliderContainer.Parent = ContainerObject.Container
    SliderContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderContainer.BackgroundTransparency = 1.000
    SliderContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SliderContainer.BorderSizePixel = 0
    SliderContainer.Size = UDim2.new(1, 0, 0.121004567, 0)

    SliderDetector.Name = "SliderDetector"
    SliderDetector.Parent = Slider
    SliderDetector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderDetector.BackgroundTransparency = 1.000
    SliderDetector.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SliderDetector.BorderSizePixel = 0
    SliderDetector.Position = UDim2.new(0.0209999997, 0, 0.193000004, 0)
    SliderDetector.Size = UDim2.new(1,0,1,0)
    SliderDetector.Font = Enum.Font.ArimoBold
    SliderDetector.Text = ""
    SliderDetector.TextColor3 = Theme.TextColor
    SliderDetector.TextScaled = true
    SliderDetector.TextSize = 14.000
    SliderDetector.TextWrapped = true
    SliderDetector.TextXAlignment = Enum.TextXAlignment.Left

    Slider.Name = "Slider"
    Slider.Parent = SliderContainer
    Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Slider.BackgroundTransparency = 1.000
    Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Slider.BorderSizePixel = 0
    Slider.Position = UDim2.new(0.0209999997, 0, 0.193000004, 0)
    Slider.Size = UDim2.new(0.956239879, 0, 0.603773594, 0)

    Bar.Name = "Bar"
    Bar.Parent = Slider
    Bar.BackgroundColor3 = Theme.SliderFillColor
    Bar.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Bar.BorderSizePixel = 0
    Bar.Position = UDim2.new(4.16344754e-08, 0, 0, 0)
    Bar.Size = UDim2.new(0.5, 0, 1, 0)

    Display.Name = "Display"
    Display.Parent = Slider
    Display.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Display.BackgroundTransparency = 1.000
    Display.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Display.BorderSizePixel = 0
    Display.Size = UDim2.new(1, 0, 1, 0)
    Display.Font = Enum.Font.Arimo
    Display.Text = SliderData.Number
    Display.TextColor3 = Theme.TextColor
    Display.TextScaled = true
    Display.TextSize = 14.000
    Display.TextWrapped = true

    UiStroke.Parent = Slider
    UiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UiStroke.Color = Theme.StrokeColor
    UiStroke.Thickness = Theme.StrokeThickness

    SliderDetector.MouseButton1Down:Connect(function()
        local MousePosition = game:GetService("UserInputService"):GetMouseLocation()
        local SliderPosition = Slider.AbsolutePosition
        local SliderWidth = Slider.AbsoluteSize.X
        local Value = math.clamp((MousePosition.X - SliderPosition.X) / SliderWidth, 0, 1)
        Slider.Bar.Size = UDim2.new(Value, 0, 1, 0)

        if SliderData.RawInt then
            SliderData.Number = math.floor((Value * SliderData.Max) + 0.5)
            Display.Text = SliderData.Number
        else
            SliderData.Number = (Value * SliderData.Max) + 0.5
            Display.Text = SliderData.Number
        end
    end)
end

function Lib:SpawnTextBox(ContainerObject, Theme, TextBoxData) 
    local TextboxContainer = Instance.new("Frame")
    local TextBox = Instance.new("TextBox")
    local UIPadding_3 = Instance.new("UIPadding")
    local UIStroke = Instance.new("UIStroke")

    TextboxContainer.Name = "TextboxContainer"
    TextboxContainer.Parent = ContainerObject.Container
    TextboxContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextboxContainer.BackgroundTransparency = 1.000
    TextboxContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextboxContainer.BorderSizePixel = 0
    TextboxContainer.Size = UDim2.new(1, 0, 0.121004567, 0)

    TextBox.Parent = TextboxContainer
    TextBox.BackgroundColor3 = Theme.DarkBackgroundColor
    TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextBox.BorderSizePixel = 0
    TextBox.Position = UDim2.new(0.0209999997, 0, 0.193000004, 0)
    TextBox.Size = UDim2.new(0.956239879, 0, 0.603773594, 0)
    TextBox.Font = Enum.Font.ArimoBold
    TextBox.PlaceholderColor3 = Theme.PlaceholderTextColor
    TextBox.PlaceholderText = TextBoxData.PlaceholderText
    TextBox.Text = TextBoxData.Text
    TextBox.TextColor3 = Theme.TextColor
    TextBox.TextScaled = true
    TextBox.TextSize = 14.000
    TextBox.TextWrapped = true
    TextBox.TextXAlignment = Enum.TextXAlignment.Left

    UIPadding_3.Parent = TextBox
    UIPadding_3.PaddingLeft = UDim.new(0.00999999978, 0)

    UIStroke.Parent = TextBox
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Theme.StrokeColor
end

return Lib