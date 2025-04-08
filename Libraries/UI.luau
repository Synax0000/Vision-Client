local Lib = {}

--[[
local Tab = Instance.new("TextButton")
local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

Tab.Name = "Tab"
Tab.Parent = Tabs
Tab.BackgroundColor3 = Color3.fromRGB(26, 23, 29)
Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
Tab.BorderSizePixel = 0
Tab.Size = UDim2.new(1, 0, 0.0811965838, 0)
Tab.AutoButtonColor = false
Tab.Font = Enum.Font.ArialBold
Tab.Text = "N/A"
Tab.TextColor3 = Color3.fromRGB(240, 222, 255)
Tab.TextScaled = true
Tab.TextSize = 14.000
Tab.TextStrokeTransparency = 0.000
Tab.TextWrapped = true

UITextSizeConstraint.Parent = Tab

]]

function Lib:Init(Theme, Assets)
    Lib.Data = {
        
    }
    
    local VisionClient = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local Tabs = Instance.new("ScrollingFrame")
    
    local UIListLayout = Instance.new("UIListLayout")
    local WindowBar = Instance.new("Frame")
    local Logo = Instance.new("ImageLabel")
    local Minimize = Instance.new("ImageButton")
    local Exit = Instance.new("ImageButton")

    Lib.UI = VisionClient

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

    Tabs.Name = "Tabs"
    Tabs.Parent = MainFrame
    Tabs.Active = true
    Tabs.BackgroundColor3 = Theme.BackgroundColor
    Tabs.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Tabs.BorderSizePixel = 0
    Tabs.Position = UDim2.new(0, 0, 0.0561122261, 0)
    Tabs.Size = UDim2.new(0.200501248, 0, 0.937875748, 0)
    Tabs.ScrollBarThickness = 4

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

    return Lib
end

return Lib