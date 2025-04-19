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

function UILib:InitSettings(Container, SettingsData) 
    local UIListLayout = Instance.new("UIListLayout")
    local Settings = Instance.new("ScrollingFrame")

    Settings.Name = "Settings"
    Settings.Parent = Container
    Settings.Active = true
    Settings.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Settings.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Settings.BorderSizePixel = 0
    Settings.Position = UDim2.new(0, 0, 0.0679245293, 0)
    Settings.Size = UDim2.new(1, 0, 0, 0)
    Settings.ScrollBarThickness = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.ScrollBarThickness
    Settings.ScrollBarImageColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.ScrollBarColor
    Settings.ScrollBarImageTransparency = 1

    UIListLayout.Parent = Settings 
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local s,e = pcall(function()
        for Key,Data in pairs(SettingsData) do
            if Data["Type"] == "Toggle" then
                local Button = Instance.new("TextButton")
                local Bar = Instance.new("Frame")

                Button.Name = "Button"
                Button.Parent = Settings
                Button.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
                Button.BackgroundTransparency = 1.000
                Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Button.BorderSizePixel = 0
                Button.Position = UDim2.new(0, 0, 0.159999996, 0)
                Button.Size = UDim2.new(1, 0, 0.02678832, 0)
                Button.Font = Enum.Font.Arial
                Button.TextColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.TextColor
                Button.TextScaled = true
                Button.TextSize = 14.000
                Button.TextWrapped = true

                Bar.Name = "Bar"
                Bar.Parent = Button
                Bar.BackgroundColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.ButtonToggledColor
                Bar.BackgroundTransparency = 0.800
                Bar.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Bar.BorderSizePixel = 0
                Bar.Size = UDim2.new(0, 0, 1, 0)

                local Enabled = false

                Button.MouseButton1Click:Connect(function()
                    if Bar.Size.X.Scale <= 0 then
                        Enabled = true
                        Data["Callback"](true)

                        Bar.BackgroundColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.ButtonToggledColor
                        Bar:TweenSize(UDim2.new(1, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.3, true)
                        
                    else
                        Enabled = false
                        Data["Callback"](false)
                        
                        Bar.BackgroundColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.ButtonToggledColor
                        Bar:TweenSize(UDim2.new(0, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.3, true)
                    end
                end)

                Button.MouseEnter:Connect(function()
                    if not Enabled then
                        Bar.BackgroundColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.ButtonHoverColor
                        Bar:TweenSize(UDim2.new(1, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.3, true)
                    end
                end)

                Button.MouseLeave:Connect(function()
                    if not Enabled then
                        Bar.BackgroundColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.ButtonToggledColor
                        Bar:TweenSize(UDim2.new(0, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.3, true)
                    end
                end)
            elseif Data["Type"] == "Button" then
                local Button = Instance.new("TextButton")
                local Bar = Instance.new("Frame")

                Button.Name = "Button"
                Button.Parent = Settings
                Button.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
                Button.BackgroundTransparency = 1.000
                Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Button.BorderSizePixel = 0
                Button.Position = UDim2.new(0, 0, 0.159999996, 0)
                Button.Size = UDim2.new(1, 0, 0.02678832, 0)
                Button.Font = Enum.Font.Arial
                Button.TextColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.TextColor
                Button.TextScaled = true
                Button.TextSize = 14.000
                Button.TextWrapped = true

                Bar.Name = "Bar"
                Bar.Parent = Button
                Bar.BackgroundColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.ButtonToggledColor
                Bar.BackgroundTransparency = 0.800
                Bar.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Bar.BorderSizePixel = 0
                Bar.Size = UDim2.new(0, 0, 1, 0)

                local ButtonTweenFull = game:GetService("TweenService"):Create(Bar, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 1, 0)})
                local ButtonTweenEmpty = game:GetService("TweenService"):Create(Bar, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 1, 0)})

                Button.MouseButton1Click:Connect(function()
                    Data["Callback"]()
                end)

                Button.MouseButton1Down:Connect(function()
                    Bar.BackgroundColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.ButtonHoverColor
                end)

                Button.MouseButton1Up:Connect(function()
                    Bar.BackgroundColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.ButtonToggledColor
                end)

                Button.MouseEnter:Connect(function()
                    Bar.BackgroundColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.ButtonHoverColor
                    ButtonTweenFull:Play()
                end)

                Button.MouseLeave:Connect(function()
                    Bar.BackgroundColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.ButtonToggledColor
                    ButtonTweenEmpty:Play()
                end)
            elseif Data["Type"] == "Label" then
                local Label = Instance.new("TextLabel")

                Label.Name = "Label"
                Label.Text = Data["Text"]
                Label.Parent = Settings
                Label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                Label.BackgroundTransparency = 0.800
                Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Label.BorderSizePixel = 0
                Label.Size = UDim2.new(1, 0, 0.02678832, 0)
                Label.Font = Enum.Font.Arimo
                Label.TextColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.TextColor
                Label.TextScaled = true
                Label.TextSize = 14.000
                Label.TextWrapped = true
            elseif Data["Type"] == "Slider" then
                local Slider = Instance.new("Frame")
                local SliderBackground = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local SliderBar = Instance.new("Frame")
                local UICorner_2 = Instance.new("UICorner")
                local SliderDisplay = Instance.new("TextLabel")

                Slider.Name = "Slider"
                Slider.Parent = Settings
                Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Slider.BackgroundTransparency = 1.000
                Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Slider.BorderSizePixel = 0
                Slider.Position = UDim2.new(0, 0, 0.319999993, 0)
                Slider.Size = UDim2.new(1, 0, 0.02678832, 0)

                SliderBackground.Name = "SliderBackground"
                SliderBackground.Parent = Slider
                SliderBackground.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                SliderBackground.BackgroundTransparency = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.SliderBackgroundTransparency
                SliderBackground.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SliderBackground.BorderSizePixel = 0
                SliderBackground.Position = UDim2.new(0.100000001, 0, 0.200000003, 0)
                SliderBackground.Size = UDim2.new(0.800000012, 0, 0.615384638, 0)

                UICorner.Parent = SliderBackground

                SliderBar.Name = "SliderBar"
                SliderBar.Parent = Slider
                SliderBar.BackgroundColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.SliderBarColor
                SliderBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SliderBar.BorderSizePixel = 0
                SliderBar.Position = UDim2.new(0.100000001, 0, 0.200000003, 0)
                SliderBar.Size = UDim2.new(0.800000012, 0, 0.615384638, 0)

                UICorner_2.Parent = SliderBar

                SliderDisplay.Name = "SliderDisplay"
                SliderDisplay.Parent = Slider
                SliderDisplay.BackgroundTransparency = 1
                SliderDisplay.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SliderDisplay.BorderSizePixel = 0
                SliderDisplay.Position = UDim2.new(0.100000001, 0, 0.192307696, 0)
                SliderDisplay.Size = UDim2.new(0.800000012, 0, 0.615384638, 0)
                SliderDisplay.Font = Enum.Font.Arimo
                SliderDisplay.TextColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.SliderBarColor
                SliderDisplay.TextScaled = true
                SliderDisplay.TextSize = 14.000
                SliderDisplay.TextTransparency = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.SliderBarTextTransparency
                SliderDisplay.TextWrapped = true

                local SliderDragging = false
                local UserInputService = game:GetService("UserInputService")
                
                local NormalizedInitialValue = (Data["CurrentValue"] - Data["MinValue"]) / (Data["MaxValue"] - Data["MinValue"])
                SliderBar.Size = UDim2.new(NormalizedInitialValue, 0, SliderBar.Size.Y.Scale, 0)
                Data["Value"] = Data["CurrentValue"]
                SliderDisplay.Text = Data["DisplayText"] .. tostring(Data["CurrentValue"]) .. "/" .. tostring(Data["MaxValue"])
                
                SliderBackground.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        SliderDragging = true
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        SliderDragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(Input)
                    if SliderDragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
                        local RelativeX = math.clamp((Input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1)
                        local CurrentValue = math.floor((RelativeX * (Data["MaxValue"] - Data["MinValue"])) + Data["MinValue"])
                        local NormalizedX = (CurrentValue - Data["MinValue"]) / (Data["MaxValue"] - Data["MinValue"])
                        SliderBar.Size = UDim2.new(NormalizedX, 0, SliderBar.Size.Y.Scale, 0)
                        Data["Value"] = CurrentValue
                        SliderDisplay.Text = Data["DisplayText"] .. tostring(CurrentValue) .. "/" .. tostring(Data["MaxValue"])
                    end
                end)            
            end
        end
    end)

    if not s then 
        warn(e)
    end

    return Settings
end

function UILib:InitItem(ItemData, Container) 
    local Item = Instance.new("TextButton")
    local DropdownDots = Instance.new("ImageButton")
    local Bar = Instance.new("Frame")

    Item.Name = "Item"
    Item.Parent = Container
    Item.BackgroundColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.ButtonBackgroundColor
    Item.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Item.BackgroundTransparency = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.ButtonBackgroundTransparency
    Item.BorderSizePixel = 0
    Item.Size = UDim2.new(1, 0, 0.0679245293, 0)
    Item.AutoButtonColor = false
    Item.Font = Enum.Font.Arimo
    Item.TextColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.TextColor
    Item.TextScaled = true
    Item.TextSize = 14.000
    Item.TextWrapped = true
    Item.Text = ItemData["Title"]
    Item.TextXAlignment = Enum.TextXAlignment.Left
    Item.ZIndex = 3

    DropdownDots.Name = "DropdownDots"
    DropdownDots.Parent = Item
    DropdownDots.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DropdownDots.BackgroundTransparency = 1.000
    DropdownDots.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DropdownDots.BorderSizePixel = 0
    DropdownDots.Position = UDim2.new(0.793622553, 0, 0.14722231, 0)
    DropdownDots.Size = UDim2.new(0.15625, 0, 0.694444418, 0)
    DropdownDots.AutoButtonColor = false
    DropdownDots.Image = _G.VisionGlobals.Assets["threedots.png"]
    DropdownDots.ZIndex = 3
    DropdownDots.Rotation = 180

    Bar.Name = "Bar"
    Bar.Parent = Item
    Bar.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Bar.BorderSizePixel = 0
    Bar.BackgroundTransparency = 0
    Bar.Size = UDim2.new(0, 0, 1, 0)
    Bar.ZIndex = 2

    local TweenButtonTextColorBlack = game:GetService("TweenService"):Create(Item, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(0, 0, 0)})
    local TweenButtonTextColorNormal = game:GetService("TweenService"):Create(Item, TweenInfo.new(0.3), {TextColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.TextColor})

    local Enabled = false
    
    Item.MouseButton1Click:Connect(function()
        if Bar.Size.X.Scale <= 0 then
            Enabled = true
            ItemData["Callback"](true)

            Bar.BackgroundColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.ButtonToggledColor
            Bar:TweenSize(UDim2.new(1, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.3, true)
            TweenButtonTextColorBlack:Play()
        else
            Enabled = false
            ItemData["Callback"](false)

            Bar.BackgroundColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.ButtonToggledColor
            Bar:TweenSize(UDim2.new(0, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.3, true)
            TweenButtonTextColorNormal:Play()
        end
    end)

    Item.MouseEnter:Connect(function()
        if not Enabled then
            Bar.BackgroundColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.ButtonHoverColor
            Bar:TweenSize(UDim2.new(1, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.3, true)
            TweenButtonTextColorBlack:Play()
        end
    end)

    Item.MouseLeave:Connect(function()
        if not Enabled then
            Bar.BackgroundColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.ButtonHoverColor
            Bar:TweenSize(UDim2.new(0, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.3, true)
            TweenButtonTextColorNormal:Play()
        end
    end)

    local Settings = UILib:InitSettings(Container, ItemData["Settings"])
    local SettingsFullY = 0.258490562

    local SettingsTweenFull = game:GetService("TweenService"):Create(Settings, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, SettingsFullY, 0)})
    local SettingsTweenEmpty = game:GetService("TweenService"):Create(Settings, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 0)})

    local DropdownDotsRotated = game:GetService("TweenService"):Create(DropdownDots, TweenInfo.new(0.3), {Rotation = -180})
    local DropdownDotsNotRotated = game:GetService("TweenService"):Create(DropdownDots, TweenInfo.new(0.3), {Rotation = 180})

    DropdownDots.MouseButton1Click:Connect(function()
        if DropdownDots.Rotation == 180 then
            DropdownDotsRotated:Play()
            SettingsTweenFull:Play()

            SettingsTweenFull.Completed:Connect(function()
                Settings.ScrollBarImageTransparency = 1
            end)
        else
            DropdownDotsNotRotated:Play()
            SettingsTweenEmpty:Play()
            Settings.ScrollBarImageTransparency = 1
        end
    end)
end

function UILib:InitTab(TabData,TabPosition) 
    local Tab = Instance.new("Frame")
    local DropdownContainer = Instance.new("Frame")
    local TabName = Instance.new("TextLabel")
    local UIPadding = Instance.new("UIPadding")
    local TabIcon = Instance.new("ImageLabel")
    local DropdownArrow = Instance.new("ImageButton")
    local Dropdown = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")

    Tab.Name = "Tab"
    Tab.Parent = _G.VisionGlobals.UIGLOBALS.VisionClientUI 
    Tab.BackgroundColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.TabBackgroundColor
    Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Tab.BorderSizePixel = 0
    Tab.Position = TabPosition
    Tab.Size = UDim2.new(0.102301791, 0, 0.0497512445, 0)

    DropdownContainer.Name = "DropdownContainer"
    DropdownContainer.Parent = Tab
    DropdownContainer.BackgroundColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.TabBackgroundColor
    DropdownContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DropdownContainer.BorderSizePixel = 0
    DropdownContainer.Position = UDim2.new(0, 0, 0.675000012, 0)
    DropdownContainer.Size = UDim2.new(1, 0, 13.5749998, 0)

    TabName.Name = "TabName"
    TabName.Parent = Tab
    TabName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabName.BackgroundTransparency = 1.000
    TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabName.BorderSizePixel = 0
    TabName.Position = UDim2.new(0.193749994, 0, 0.25, 0)
    TabName.Size = UDim2.new(0.606249988, 0, 0.5, 0)
    TabName.Font = Enum.Font.Arimo
    TabName.Text = TabData["Title"]
    TabName.TextColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.TextColor
    TabName.TextScaled = true
    TabName.TextSize = 14.000
    TabName.TextWrapped = true
    TabName.TextXAlignment = Enum.TextXAlignment.Left

    UIPadding.Parent = TabName
    UIPadding.PaddingLeft = UDim.new(0.0500000007, 0)

    TabIcon.Name = "TabIcon"
    TabIcon.Parent = Tab
    TabIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabIcon.BackgroundTransparency = 1.000
    TabIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabIcon.BorderSizePixel = 0
    TabIcon.Position = UDim2.new(0.0375000015, 0, 0.174999997, 0)
    TabIcon.Size = UDim2.new(0.15625, 0, 0.625, 0)
    TabIcon.ScaleType = Enum.ScaleType.Fit
    TabIcon.Image = _G.VisionGlobals.Assets["visionclientlogo.png"]

    DropdownArrow.Name = "DropdownArrow"
    DropdownArrow.Parent = Tab
    DropdownArrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DropdownArrow.BackgroundTransparency = 1.000
    DropdownArrow.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DropdownArrow.BorderSizePixel = 0
    DropdownArrow.Position = UDim2.new(0.800000012, 0, 0.174999997, 0)
    DropdownArrow.Size = UDim2.new(0.15625 -0.04, 0, 0.6205 -0.04, 0)
    DropdownArrow.AutoButtonColor = false
    DropdownArrow.Rotation = -90
    DropdownArrow.Image = _G.VisionGlobals.Assets["threedots.png"]

    Dropdown.Name = "Dropdown"
    Dropdown.Parent = Tab
    Dropdown.Active = true
    Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dropdown.BackgroundTransparency = 1.000
    Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Dropdown.BorderSizePixel = 0
    Dropdown.Position = UDim2.new(0, 0, 1, 0)
    Dropdown.Size = UDim2.new(1, 0, 13.25, 0)
    Dropdown.ScrollBarImageColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.ScrollBarColor
    Dropdown.ScrollBarThickness = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.ScrollBarThickness

    UIListLayout.Parent = Dropdown
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local CollapseDropdownTween = game:GetService("TweenService"):Create(Dropdown, TweenInfo.new(0.5), {Size = UDim2.new(1, 0, 0, 0)})
    local ExpandDropdownTween = game:GetService("TweenService"):Create(Dropdown, TweenInfo.new(0.5), {Size = UDim2.new(1, 0, 13.25, 0)})
    local CollapseContainerTween = game:GetService("TweenService"):Create(DropdownContainer, TweenInfo.new(0.5), {Size = UDim2.new(1, 0, 0, 0)})
    local ExpandContainerTween = game:GetService("TweenService"):Create(DropdownContainer, TweenInfo.new(0.5), {Size = UDim2.new(1, 0, 13.5749998, 0)})
    
    local ArrowToRightTween = game:GetService("TweenService"):Create(DropdownArrow, TweenInfo.new(0.3), {Rotation = 90})
    local ArrowToDownTween = game:GetService("TweenService"):Create(DropdownArrow, TweenInfo.new(0.3), {Rotation = -90})
    
    DropdownArrow.MouseButton1Click:Connect(function()
        if DropdownArrow.Rotation == -90 then
            CollapseDropdownTween:Play()
            CollapseContainerTween:Play()
            ArrowToRightTween:Play()
            Dropdown.ScrollBarImageTransparency = 1
        else
            ExpandDropdownTween:Play()
            ExpandContainerTween:Play()
            ArrowToDownTween:Play()
            Dropdown.ScrollBarImageTransparency = 0
        end
    end)
    
    UILib:AttachDrag(Tab)

    for Key,Data in pairs(TabData.Items) do
        UILib:InitItem(Data, Dropdown)
    end
end

function UILib:InitVisionTab() 
    UILib:InitTab({
        Title = "Vision",
        Items = {
            Uninject = {
                Title = "Uninject",
                Settings = {},
                Callback = function(...) 
                    _G.VisionGlobals.UIGLOBALS.VisionClientUI:Destroy()
                    _G.VisionGlobals.CLOSETHREADS = true
                    task.wait(1)
                    _G.VisionGlobals = {}
                end
            }
        }
    }, UDim2.new(0.1,0,0.15,0))
end

function UILib:Init(UIData) 
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

    UILib:InitVisionTab()
end

return UILib