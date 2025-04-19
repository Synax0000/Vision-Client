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

    Bar.Name = "Bar"
    Bar.Parent = Item
    Bar.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Bar.BorderSizePixel = 0
    Bar.BackgroundTransparency = 0
    Bar.Size = UDim2.new(0, 0, 1, 0)
    Bar.ZIndex = 2

    local BarTweenFull = game:GetService("TweenService"):Create(Bar, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 1, 0)})
    local BarTweenEmpty = game:GetService("TweenService"):Create(Bar, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 1, 0)})

    local TweenButtonTextColorBlack = game:GetService("TweenService"):Create(Item, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(0, 0, 0)})
    local TweenButtonTextColorNormal = game:GetService("TweenService"):Create(Item, TweenInfo.new(0.3), {TextColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.TextColor})

    local Enabled = false
    
    Item.MouseButton1Click:Connect(function()
        if Bar.Size.X.Offset <= 0 then
            Bar.BackgroundColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.ButtonToggledColor
            BarTweenFull:Play()
            TweenButtonTextColorBlack:Play()

            BarTweenFull.Completed:Connect(function()
                ItemData["Callback"](true)
                Enabled = true
            end)
        else
            Bar.BackgroundColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.ButtonToggledColor
            BarTweenEmpty:Play()
            TweenButtonTextColorNormal:Play()

            BarTweenEmpty.Completed:Connect(function()
                ItemData["Callback"](false)
                Enabled = false
            end)
        end
    end)

    Item.MouseEnter:Connect(function()
        if not Enabled then
            Bar.BackgroundColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.ButtonHoverColor
            BarTweenFull:Play()
            TweenButtonTextColorBlack:Play()
        end
    end)

    Item.MouseLeave:Connect(function()
        if not Enabled then
            Bar.BackgroundColor3 = _G.VisionGlobals.Configs.GlobalConfig.ThemeData.ButtonHoverColor
            BarTweenEmpty:Play()
            TweenButtonTextColorNormal:Play()
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