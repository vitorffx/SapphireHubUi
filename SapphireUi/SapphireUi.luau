
-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local CoreGui = gethui and gethui() or game:GetService("CoreGui")

-- Libraries
local Settings = require(game.ReplicatedStorage.SettingsLib.Settings)
local Translation = require(game.ReplicatedStorage.TranslationLib.Translation)

-- Anti-AFK
spawn(function()
    while wait(60) do
        pcall(function()
            LocalPlayer.Idled:fire()
        end)
    end
end)

-- Key System
if Settings.Settings.EnableKeySystem then
    local KeySystemGui = Instance.new("ScreenGui", CoreGui)
    KeySystemGui.Name = "KeySystemGui"
    KeySystemGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame", KeySystemGui)
    MainFrame.Size = UDim2.new(0, 300, 0, 150)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundColor3 = Settings.Settings.BackgroundColor
    MainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
    MainFrame.BorderSizePixel = 2

    local TitleLabel = Instance.new("TextLabel", MainFrame)
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.Text = Translation:Translate("Key System")
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextColor3 = Settings.Settings.TextColor
    TitleLabel.BackgroundColor3 = Settings.Settings.BackgroundColor

    local KeyInput = Instance.new("TextBox", MainFrame)
    KeyInput.Size = UDim2.new(0, 260, 0, 40)
    KeyInput.Position = UDim2.new(0.5, -130, 0.5, -20)
    KeyInput.PlaceholderText = Translation:Translate("Enter Key...")
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.TextColor3 = Settings.Settings.TextColor
    KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    local SubmitButton = Instance.new("TextButton", MainFrame)
    SubmitButton.Size = UDim2.new(0, 100, 0, 30)
    SubmitButton.Position = UDim2.new(0.5, -50, 0.8, 0)
    SubmitButton.Text = Translation:Translate("Submit")
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.TextColor3 = Settings.Settings.TextColor
    SubmitButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    local function checkKey(key)
        if key == Settings.Settings.Key then
            KeySystemGui:Destroy()
            return true
        else
            TitleLabel.Text = Translation:Translate("Invalid Key")
            TitleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            return false
        end
    end

    SubmitButton.MouseButton1Click:Connect(function()
        checkKey(KeyInput.Text)
    end)

    KeyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            checkKey(KeyInput.Text)
        end
    end)

    -- Wait until the key is correct
    while not checkKey(KeyInput.Text) do
        wait(0.1)
    end
end

local SapphireHubLib = {}

function SapphireHubLib:Create(GuiConfig)
    --// Config
    local GuiConfig = GuiConfig or {}
    GuiConfig.Name = GuiConfig.Name or "SapphireHub"
    GuiConfig.Description = GuiConfig.Description or "v1.0"
    GuiConfig.Color = GuiConfig.Color or Settings.Settings.MainColor
    GuiConfig["Logo Info"] = GuiConfig["Logo Info"] or "rbxassetid://13698223452"
    GuiConfig["Name Info"] = GuiConfig["Name Info"] or LocalPlayer.Name
    GuiConfig["Info Color"] = GuiConfig["Info Color"] or Color3.fromRGB(25, 25, 25)
    GuiConfig["Name Player"] = GuiConfig["Name Player"] or LocalPlayer.Name
    GuiConfig["Info Description"] = GuiConfig["Info Description"] or "Welcome to SapphireHub!"
    GuiConfig["Logo Player"] = GuiConfig["Logo Player"] or "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=420&height=420&format=png"
    GuiConfig.CloseCallBack = GuiConfig.CloseCallBack or function() end

    --// Gui
    local SapphireGui = Instance.new("ScreenGui");
    local Main = Instance.new("Frame");
    local UICorner = Instance.new("UICorner");
    local Top = Instance.new("Frame");
    local TopTitle = Instance.new("TextLabel");
    local TopDescription = Instance.new("TextLabel");
    local CloseButton = Instance.new("TextButton");
    local CloseImage = Instance.new("ImageLabel");
    local DropShadowHolder = Instance.new("Frame");
    local DropShadow = Instance.new("ImageLabel");
    local MinimizeButton = Instance.new("ImageButton")
    local UICornerMinimize = Instance.new("UICorner")

    SapphireGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    SapphireGui.Name = "SapphireGui"
    SapphireGui.Parent = CoreGui

    local ScreenFind = CoreGui:FindFirstChild(SapphireGui.Name)
    if ScreenFind and ScreenFind ~= SapphireGui then
        ScreenFind:Destroy()
    end

    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Settings.Settings.BackgroundColor
    Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Main.BorderSizePixel = 0
    Main.Size = UDim2.new(0, 500, 0, 300)
    Main.Name = "Main"
    Main.Parent = SapphireGui
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)

    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = Main

    Top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Top.BackgroundTransparency = 1
    Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Top.BorderSizePixel = 0
    Top.Size = UDim2.new(1, 0, 0, 34)
    Top.Name = "Top"
    Top.Parent = Main

    TopTitle.Font = Enum.Font.GothamBold
    TopTitle.Text = Translation:Translate(GuiConfig.Name)
    TopTitle.TextColor3 = GuiConfig.Color
    TopTitle.TextSize = 14
    TopTitle.TextXAlignment = Enum.TextXAlignment.Left
    TopTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TopTitle.BackgroundTransparency = 1
    TopTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TopTitle.BorderSizePixel = 0
    TopTitle.Position = UDim2.new(0, 12, 0, 10)
    TopTitle.Size = UDim2.new(0, 0, 0, 14)
    TopTitle.Name = "TopTitle"
    TopTitle.Parent = Top

    TopDescription.Font = Enum.Font.GothamBold
    TopDescription.Text = Translation:Translate(GuiConfig.Description)
    TopDescription.TextColor3 = Settings.Settings.DescriptionTextColor
    TopDescription.TextSize = 14
    TopDescription.TextXAlignment = Enum.TextXAlignment.Left
    TopDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TopDescription.BackgroundTransparency = 1
    TopDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TopDescription.BorderSizePixel = 0
    TopDescription.Position = UDim2.new(0, 16 + TopTitle.TextBounds.X, 0, 10)
    TopDescription.Size = UDim2.new(0, 0, 0, 14)
    TopDescription.Name = "TopDescription"
    TopDescription.Parent = Top

    CloseButton.Font = Enum.Font.SourceSans
    CloseButton.Text = ""
    CloseButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    CloseButton.TextSize = 14
    CloseButton.AnchorPoint = Vector2.new(1, 0)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.BackgroundTransparency = 1
    CloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(1, 0, 0, 0)
    CloseButton.Size = UDim2.new(0, 34, 0, 34)
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = Top

    CloseImage.Image = "rbxassetid://18328658828"
    CloseImage.AnchorPoint = Vector2.new(0.5, 0.5)
    CloseImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CloseImage.BackgroundTransparency = 1
    CloseImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
    CloseImage.BorderSizePixel = 0
    CloseImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    CloseImage.Size = UDim2.new(1, -15, 1, -15)
    CloseImage.Name = "CloseImage"
    CloseImage.Parent = CloseButton

    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.BorderSizePixel = 0
    DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
    DropShadowHolder.ZIndex = 0
    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.Parent = Main

    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = Settings.Settings.ShadowColor
    DropShadow.ImageTransparency = 0.6
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.BorderSizePixel = 0
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 47, 1, 47)
    DropShadow.ZIndex = 0
    DropShadow.Name = "DropShadow"
    DropShadow.Parent = DropShadowHolder

    MakeDraggable(Top, Main)

    function SapphireHubLib:ToggleUI()
        Main.Visible = not Main.Visible
    end

    function SapphireHubLib:CloseUI()
        SapphireGui:Destroy()
        MinimizeButton:Destroy()
    end

    CloseButton.Activated:Connect(function()
        SapphireHubLib:CloseUI()
        GuiConfig.CloseCallBack()
    end)

    MinimizeButton.Size = UDim2.fromOffset(35, 35)
    MinimizeButton.Position = UDim2.fromScale(0.10, 0.30)
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Image = "rbxassetid://16022917595"
    MinimizeButton.BackgroundColor3 = GuiConfig.Color
    MinimizeButton.AutoButtonColor = false
    MinimizeButton.Draggable = true
    MinimizeButton.Active = true
    MinimizeButton.Selectable = true
    MinimizeButton.Parent = SapphireGui

    UICornerMinimize.CornerRadius = UDim.new(0, 5)
    UICornerMinimize.Parent = MinimizeButton

    MinimizeButton.MouseButton1Click:Connect(function() SapphireHubLib:ToggleUI() end)

    --// Tab
    local LayersTab = Instance.new("Frame");
    local ScrollTab = Instance.new("ScrollingFrame");
    local UIListLayout = Instance.new("UIListLayout");

    LayersTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LayersTab.BackgroundTransparency = 1
    LayersTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LayersTab.BorderSizePixel = 0
    LayersTab.Position = UDim2.new(0, 10, 0, 34)
    LayersTab.Size = UDim2.new(0, 135, 1, -44)
    LayersTab.Name = "LayersTab"
    LayersTab.Parent = Main

    ScrollTab.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollTab.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
    ScrollTab.ScrollBarThickness = 0
    ScrollTab.Active = true
    ScrollTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ScrollTab.BackgroundTransparency = 1
    ScrollTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ScrollTab.BorderSizePixel = 0
    ScrollTab.Position = UDim2.new(0, 0, 0, 40)
    ScrollTab.Size = UDim2.new(1, 0, 1, -40)
    ScrollTab.Name = "ScrollTab"
    ScrollTab.Parent = LayersTab

    UIListLayout.Padding = UDim.new(0, 3)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollTab

    AutoUp(ScrollTab)

    --// Info
    local Info = Instance.new("Frame");
    local UICorner5 = Instance.new("UICorner");
    local NamePlayer = Instance.new("TextLabel");
    local LogoFrame = Instance.new("Frame");
    local LogoPlayer = Instance.new("ImageLabel");
    local UICorner6 = Instance.new("UICorner");
    local UICorner7 = Instance.new("UICorner");
    local InfoButton = Instance.new("TextButton");

    Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Info.BackgroundTransparency = 1
    Info.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Info.BorderSizePixel = 0
    Info.Size = UDim2.new(1, 0, 0, 35)
    Info.Name = "Info"
    Info.Parent = LayersTab

    EnterMouse(Info)

    UICorner5.CornerRadius = UDim.new(0, 3)
    UICorner5.Parent = Info

    NamePlayer.Font = Enum.Font.GothamBold
    NamePlayer.Text = Translation:Translate(GuiConfig["Name Info"])
    NamePlayer.TextColor3 = Settings.Settings.DescriptionTextColor
    NamePlayer.TextSize = 12
    NamePlayer.TextWrapped = true
    NamePlayer.TextXAlignment = Enum.TextXAlignment.Left
    NamePlayer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NamePlayer.BackgroundTransparency = 1
    NamePlayer.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NamePlayer.BorderSizePixel = 0
    NamePlayer.Position = UDim2.new(0, 35, 0, 0)
    NamePlayer.Size = UDim2.new(1, -35, 1, 0)
    NamePlayer.Name = "NamePlayer"
    NamePlayer.Parent = Info

    LogoFrame.AnchorPoint = Vector2.new(0, 0.5)
    LogoFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LogoFrame.BackgroundTransparency = 1
    LogoFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LogoFrame.BorderSizePixel = 0
    LogoFrame.Position = UDim2.new(0, 5, 0.5, 0)
    LogoFrame.Size = UDim2.new(0, 25, 0, 25)
    LogoFrame.Name = "LogoFrame"
    LogoFrame.Parent = Info

    LogoPlayer.Image = GuiConfig["Logo Info"]
    LogoPlayer.AnchorPoint = Vector2.new(0.5, 0.5)
    LogoPlayer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LogoPlayer.BackgroundTransparency = 1
    LogoPlayer.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LogoPlayer.BorderSizePixel = 0
    LogoPlayer.Position = UDim2.new(0.5, 0, 0.5, 0)
    LogoPlayer.Size = UDim2.new(1, 0, 1, 0)
    LogoPlayer.Name = "LogoPlayer"
    LogoPlayer.Parent = LogoFrame

    UICorner6.CornerRadius = UDim.new(0, 1000)
    UICorner6.Parent = LogoPlayer

    UICorner7.CornerRadius = UDim.new(0, 1000)
 UICorner7.Parent = LogoFrame

    InfoButton.Font = Enum.Font.SourceSans
    InfoButton.Text = ""
    InfoButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    InfoButton.TextSize = 14
    InfoButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    InfoButton.BackgroundTransparency = 1
    InfoButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    InfoButton.BorderSizePixel = 0
    InfoButton.Size = UDim2.new(1, 0, 1, 0)
    InfoButton.Name = "InfoButton"
    InfoButton.Parent = Info

    local AnotherFrame = Instance.new("Frame");
    local UICorner30 = Instance.new("UICorner");
    local AnotherButton = Instance.new("TextButton");
    local LogFrame = Instance.new("Frame");
    local UICorner31 = Instance.new("UICorner");
    local LogUnder = Instance.new("Frame");
    local UICorner32 = Instance.new("UICorner");
    local LogTitle = Instance.new("TextLabel");
    local LogDescription = Instance.new("TextLabel");
    local LogoInfo = Instance.new("ImageLabel");
    local UICorner33 = Instance.new("UICorner");
    local UIStroke5 = Instance.new("UIStroke");

    AnotherFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    AnotherFrame.BackgroundTransparency = 0.5
    AnotherFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    AnotherFrame.BorderSizePixel = 0
    AnotherFrame.Size = UDim2.new(1, 0, 1, 0)
    AnotherFrame.Visible = false
    AnotherFrame.ZIndex = 2
    AnotherFrame.Name = "AnotherFrame"
    AnotherFrame.Parent = Main

    UICorner30.CornerRadius = UDim.new(0, 3)
    UICorner30.Parent = AnotherFrame

    AnotherButton.Font = Enum.Font.SourceSans
    AnotherButton.Text = ""
    AnotherButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    AnotherButton.TextSize = 14
    AnotherButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    AnotherButton.BackgroundTransparency = 1
    AnotherButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    AnotherButton.BorderSizePixel = 0
    AnotherButton.Size = UDim2.new(1, 0, 1, 0)
    AnotherButton.Name = "AnotherButton"
    AnotherButton.Parent = AnotherFrame

    LogFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    LogFrame.BackgroundColor3 = GuiConfig["Info Color"]
    LogFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LogFrame.BorderSizePixel = 0
    LogFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    LogFrame.Size = UDim2.new(0, 0, 0, 0)
    LogFrame.Name = "LogFrame"
    LogFrame.ClipsDescendants = true
    LogFrame.Parent = AnotherFrame

    UICorner31.CornerRadius = UDim.new(0, 5)
    UICorner31.Parent = LogFrame

    LogUnder.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    LogUnder.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LogUnder.BorderSizePixel = 0
    LogUnder.Position = UDim2.new(0, 0, 0, 50)
    LogUnder.Size = UDim2.new(1, 0, 1, -50)
    LogUnder.Name = "LogUnder"
    LogUnder.Parent = LogFrame

    UICorner32.CornerRadius = UDim.new(0, 3)
    UICorner32.Parent = LogUnder

    LogTitle.Font = Enum.Font.GothamBold
    LogTitle.Text = Translation:Translate(GuiConfig["Name Player"])
    LogTitle.TextColor3 = Settings.Settings.DescriptionTextColor
    LogTitle.TextSize = 18
    LogTitle.TextXAlignment = Enum.TextXAlignment.Left
    LogTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LogTitle.BackgroundTransparency = 1
    LogTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LogTitle.BorderSizePixel = 0
    LogTitle.Position = UDim2.new(0, 12, 0, 34)
    LogTitle.Size = UDim2.new(0, 35, 0, 16)
    LogTitle.Name = "LogTitle"
    LogTitle.Parent = LogUnder

    LogDescription.Font = Enum.Font.GothamBold
    LogDescription.Text = Translation:Translate(GuiConfig["Info Description"])
    LogDescription.TextColor3 = Settings.Settings.DescriptionTextColor
    LogDescription.TextSize = 12
    LogDescription.TextTransparency = 0.5
    LogDescription.TextXAlignment = Enum.TextXAlignment.Left
    LogDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LogDescription.BackgroundTransparency = 1
    LogDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LogDescription.BorderSizePixel = 0
    LogDescription.Position = UDim2.new(0, 12, 0, 50)
    LogDescription.Size = UDim2.new(0, 35, 0, 14)
    LogDescription.Name = "LogDescription"
    LogDescription.Parent = LogUnder

    LogoInfo.Image = GuiConfig["Logo Player"]
    LogoInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LogoInfo.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LogoInfo.BorderSizePixel = 0
    LogoInfo.Position = UDim2.new(0, 15, 0, 25)
    LogoInfo.Size = UDim2.new(0, 50, 0, 50)
    LogoInfo.Name = "LogoInfo"
    LogoInfo.Parent = LogFrame

    UICorner33.CornerRadius = UDim.new(0, 100)
    UICorner33.Parent = LogoInfo

    UIStroke5.Color = Color3.fromRGB(10, 10, 10)
    UIStroke5.Thickness = 4
    UIStroke5.Parent = LogoInfo

    InfoButton.Activated:Connect(function()
        AnotherFrame.Visible = true
        TweenService:Create(
			LogFrame,
			TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
			{Size = UDim2.new(0, 250, 0, 125)}
		):Play()
    end)
    AnotherButton.Activated:Connect(function()
        TweenService:Create(
			LogFrame,
			TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
			{Size = UDim2.new(0, 0, 0, 0)}
		):Play()
        task.wait(0.3)
        AnotherFrame.Visible = false
    end)

    --// Layers
    local Layers = Instance.new("Frame");
    local RealLayers = Instance.new("Frame");
    local LayersFolder = Instance.new("Folder");
    local UIPageLayout = Instance.new("UIPageLayout");

    Layers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Layers.BackgroundTransparency = 1
    Layers.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Layers.BorderSizePixel = 0
    Layers.Position = UDim2.new(0, 158, 0, 34)
    Layers.Size = UDim2.new(1, -166, 1, -44)
    Layers.Name = "Layers"
    Layers.Parent = Main

    RealLayers.AnchorPoint = Vector2.new(1, 1)
    RealLayers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    RealLayers.BackgroundTransparency = 1
    RealLayers.BorderColor3 = Color3.fromRGB(0, 0, 0)
    RealLayers.BorderSizePixel = 0
    RealLayers.ClipsDescendants = true
    RealLayers.Position = UDim2.new(1, 0, 1, 0)
    RealLayers.Size = UDim2.new(1, 0, 1, -25)
    RealLayers.Name = "RealLayers"
    RealLayers.Parent = Layers

    LayersFolder.Name = "LayersFolder"
    LayersFolder.Parent = RealLayers

    UIPageLayout.EasingDirection = Enum.EasingDirection.InOut
    UIPageLayout.EasingStyle = Enum.EasingStyle.Quad
    UIPageLayout.FillDirection = Enum.FillDirection.Vertical
    UIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIPageLayout.TweenTime = 0.3
    UIPageLayout.Parent = LayersFolder

    --// Back
    local Back = Instance.new("Frame");
    local NameBack = Instance.new("Frame");
    local BackButton = Instance.new("TextButton");
    local NameBack1 = Instance.new("Frame");
    local BackButton1 = Instance.new("TextButton");
    local ForwardImage = Instance.new("ImageLabel");

    Back.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Back.BackgroundTransparency = 1
    Back.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Back.BorderSizePixel = 0
    Back.Size = UDim2.new(1, 0, 0, 25)
    Back.Name = "Back"
    Back.Parent = Layers

    NameBack.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NameBack.BackgroundTransparency = 1
    NameBack.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NameBack.BorderSizePixel = 0
    NameBack.Size = UDim2.new(0, 30, 1, 0)
    NameBack.Name = "NameBack"
    NameBack.Parent = Back

    BackButton.Font = Enum.Font.GothamBold
    BackButton.Text = ""
    BackButton.TextColor3 = Settings.Settings.TextColor
    BackButton.TextSize = 13
    BackButton.TextXAlignment = Enum.TextXAlignment.Left
    BackButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BackButton.BackgroundTransparency = 1
    BackButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    BackButton.BorderSizePixel = 0
    BackButton.Position = UDim2.new(0, 5, 0, 0)
    BackButton.Size = UDim2.new(0, 0, 1, 0)
    BackButton.Name = "BackButton"
    BackButton.Parent = NameBack

    NameBack1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NameBack1.BackgroundTransparency = 1
    NameBack1.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NameBack1.BorderSizePixel = 0
    NameBack1.Position = UDim2.new(0, 30, 0, 0)
    NameBack1.Size = UDim2.new(1, -30, 1, 0)
    NameBack1.Name = "NameBack1"
    NameBack1.Parent = Back

    BackButton1.Font = Enum.Font.GothamBold
    BackButton1.Text = ""
    BackButton1.TextColor3 = Settings.Settings.TextColor
    BackButton1.TextSize = 13
    BackButton1.TextTransparency = 1
    BackButton1.TextXAlignment = Enum.TextXAlignment.Left
    BackButton1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BackButton1.BackgroundTransparency = 1
    BackButton1.BorderColor3 = Color3.fromRGB(0, 0, 0)
    BackButton1.BorderSizePixel = 0
    BackButton1.Position = UDim2.new(0, 5, 0, 0)
    BackButton1.Size = UDim2.new(1, 0, 1, 0)
    BackButton1.Name = "BackButton1"
    BackButton1.Parent = NameBack1

    ForwardImage.Image = "rbxassetid://3926307971"
    ForwardImage.ImageRectOffset = Vector2.new(84, 404)
    ForwardImage.ImageRectSize = Vector2.new(36, 36)
    ForwardImage.ImageTransparency = 1
    ForwardImage.AnchorPoint = Vector2.new(0, 0.5)
    ForwardImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ForwardImage.BackgroundTransparency = 1
    ForwardImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ForwardImage.BorderSizePixel = 0
    ForwardImage.Position = UDim2.new(0, -5, 0.5, 0)
    ForwardImage.Size = UDim2.new(0, 15, 0, 15)
    ForwardImage.Name = "ForwardImage"
    ForwardImage.Parent = BackButton1

    local function JumpTo(TabOrder, TabName)
        UIPageLayout:JumpToIndex(TabOrder)
        TweenService:Create(
            BackButton,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            {TextTransparency = 0}
        ):Play()
        TweenService:Create(
            BackButton1,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            {TextTransparency = 1}
        ):Play()
        TweenService:Create(
            ForwardImage,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            {ImageTransparency = 1}
        ):Play()
        BackButton.Size = UDim2.new(0, BackButton.TextBounds.X + 3, 1, 0)
        NameBack.Size = UDim2.new(0, BackButton.Size.X.Offset, 1, 0)
        NameBack1.Position = UDim2.new(0, NameBack.Size.X.Offset, 0, 0)
        NameBack1.Size = UDim2.new(1,-(NameBack1.Position.X.Offset), 1, 0)
    end
    BackButton.Activated:Connect(function()
        JumpTo(BackButton.LayoutOrder, BackButton.Text)
    end)

    --// Tabs
    local Tabs = {}
    local CountTab = 0

    function Tabs:MakeTab(NameTab)
        local NameTab = NameTab or ""
        local ScrollLayer = Instance.new("ScrollingFrame")
        local UIListLayout1 = Instance.new("UIListLayout")

        ScrollLayer.ScrollBarImageColor3 = Color3.fromRGB(55, 55, 55)
        ScrollLayer.ScrollBarThickness = 3
        ScrollLayer.Active = true
        ScrollLayer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ScrollLayer.BackgroundTransparency = 1
        ScrollLayer.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ScrollLayer.BorderSizePixel = 0
        ScrollLayer.Size = UDim2.new(1, 0, 1, 0)
        ScrollLayer.Name = "ScrollLayer"
        ScrollLayer.LayoutOrder = CountTab
        ScrollLayer.Parent = LayersFolder

        UIListLayout1.Padding = UDim.new(0, 4)
        UIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout1.Parent = ScrollLayer

        AutoUp(ScrollLayer)

        local Tab = Instance.new("Frame");
        local UICorner1 = Instance.new("UICorner");
        local ChoosingFrame = Instance.new("Frame");
        local UIStroke = Instance.new("UIStroke");
        local UICorner2 = Instance.new("UICorner");
        local TabName = Instance.new("TextLabel");
        local TabButton = Instance.new("TextButton");

        Tab.BackgroundColor3 = Settings.Settings.BackgroundColor
        Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Tab.BorderSizePixel = 0
        Tab.Size = UDim2.new(1, 0, 0, 25)
        Tab.Name = "Tab"
        Tab.LayoutOrder = CountTab
        Tab.Parent = ScrollTab

        UICorner1.CornerRadius = UDim.new(0, 3)
        UICorner1.Parent = Tab

        ChoosingFrame.AnchorPoint = Vector2.new(0, 1)
        ChoosingFrame.BackgroundColor3 = GuiConfig.Color
        ChoosingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ChoosingFrame.BorderSizePixel = 0
        ChoosingFrame.Position = UDim2.new(0, 5, 1, -6)
        ChoosingFrame.Size = UDim2.new(0, 2, 0, 0)
        ChoosingFrame.Name = "ChoosingFrame"
        ChoosingFrame.Parent = Tab

        UIStroke.Color = GuiConfig.Color
        UIStroke.Thickness = 0.8
        UIStroke.Transparency = 1
        UIStroke.Parent = ChoosingFrame

        UICorner2.CornerRadius = UDim.new(0, 3)
        UICorner2.Parent = ChoosingFrame

        TabName.Font = Enum.Font.GothamBold
        TabName.LineHeight = 0.9
        TabName.Text = Translation:Translate(NameTab)
        TabName.TextColor3 = Settings.Settings.TextColor
        TabName.TextSize = 12
        TabName.TextWrapped = true
        TabName.TextXAlignment = Enum.TextXAlignment.Left
        TabName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabName.BackgroundTransparency = 1
        TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TabName.BorderSizePixel = 0
        TabName.Position = UDim2.new(0, 14, 0, 0)
        TabName.Size = UDim2.new(1, -25, 1, 0)
        TabName.Name = "TabName"
        TabName.Parent = Tab

        TabButton.Font = Enum.Font.SourceSans
        TabButton.Text = ""
        TabButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        TabButton.TextSize = 14
        TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.BackgroundTransparency = 1
        TabButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 1, 0)
        TabButton.Name = "TabButton"
        TabButton.Parent = Tab

        if CountTab == 0 then
            UIPageLayout:JumpToIndex(0)
            BackButton.Text = TabName.Text
            BackButton.Size = UDim2.new(0, BackButton.TextBounds.X, 1, 0)
            NameBack.Size = UDim2.new(0, BackButton.Size.X.Offset + 3, 1, 0)
            NameBack1.Position = UDim2.new(0, NameBack.Size.X.Offset, 0, 0)
            NameBack1.Size = UDim2.new(1,-(NameBack1.Position.X.Offset), 1, 0)
            ChoosingFrame.AnchorPoint = Vector2.new(0, 0)
            ChoosingFrame.Position = UDim2.new(0, 5, 0, 6)
            ChoosingFrame.Size = UDim2.new(0, 2, 0, 14)
            Tab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            UIStroke.Transparency = 0
        end

        TabButton.Activated:Connect(function()
            if Tab.LayoutOrder ~= UIPageLayout.CurrentPage.LayoutOrder then
                for _, TabFrame in ScrollTab:GetChildren() do
                    if TabFrame.Name ~= "UIListLayout" then
                        TabFrame.ChoosingFrame.AnchorPoint = Vector2.new(0, 1)
                        TabFrame.ChoosingFrame.Position = UDim2.new(0, 5, 1, -6)
                        TweenService:Create(
                            TabFrame,
                            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                            {BackgroundColor3 = Settings.Settings.BackgroundColor}
                        ):Play()
                        TweenService:Create(
                            TabFrame.ChoosingFrame,
                            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                            {Size = UDim2.new(0, 2, 0, 0), Transparency = 1}
                        ):Play()
                        TweenService:Create(
                            TabFrame.ChoosingFrame.UIStroke,
                            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                            {Transparency = 1}
                        ):Play()
                    end
                end
                ChoosingFrame.AnchorPoint = Vector2.new(0, 0)
                ChoosingFrame.Position = UDim2.new(0, 5, 0, 6)
                TweenService:Create(
                    Tab,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                    {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}
                ):Play()
                TweenService:Create(
                    ChoosingFrame,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                    {Size = UDim2.new(0, 2, 0, 14), Transparency = 0}
                ):Play()
                TweenService:Create(
                    UIStroke,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                    {Transparency = 0}
                ):Play()
                JumpTo(Tab.LayoutOrder, TabName.Text)
            end
        end)

        local Sections = {}
        local CountSection = 0

        function Sections:Section(SectionConfig)
            local SectionConfig = SectionConfig or {}
            SectionConfig.Title = SectionConfig.Title or "Title"
            SectionConfig.Content = SectionConfig.Content or ""

            local ScrollLayer1 = Instance.new("ScrollingFrame");
            local UIListLayout3 = Instance.new("UIListLayout");

            ScrollLayer1.CanvasSize = UDim2.new(0, 0, 0, 0)
            ScrollLayer1.ScrollBarImageTransparency = 0.9
            ScrollLayer1.ScrollBarThickness = 3
            ScrollLayer1.Active = true
            ScrollLayer1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ScrollLayer1.BackgroundTransparency = 1
            ScrollLayer1.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ScrollLayer1.BorderSizePixel = 0
            ScrollLayer1.LayoutOrder = CountTab
            ScrollLayer1.Size = UDim2.new(1, 0, 1, 0)
            ScrollLayer1.Name = "ScrollLayer"
            ScrollLayer1.Parent = LayersFolder

            UIListLayout3.Padding = UDim.new(0, 4)
            UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout3.Parent = ScrollLayer1

            AutoUp(ScrollLayer1)

            local Section = Instance.new("Frame");
            local UICorner29 = Instance.new("UICorner");
            local SectionName = Instance.new("TextLabel");
            local SectionDescription = Instance.new("TextLabel");
            local SectionImage = Instance.new("ImageLabel");
            local SectionButton = Instance.new("TextButton");

            Section.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
            Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Section.BorderSizePixel = 0
            Section.Size = UDim2.new(1, -8, 0, 44)
            Section.Name = "Section"
            Section.LayoutOrder = CountSection
            Section.Parent = ScrollLayer

            UICorner29.CornerRadius = UDim.new(0, 3)
            UICorner29.Parent = Section

            SectionName.Font = Enum.Font.GothamBold
            SectionName.Text = Translation:Translate(SectionConfig.Title)
            SectionName.TextColor3 = Settings.Settings.TextColor
            SectionName.TextSize = 13
            SectionName.TextXAlignment = Enum.TextXAlignment.Left
            SectionName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SectionName.BackgroundTransparency = 1
            SectionName.BorderColor3 = Color3.fromRGB(0, 0, 0)
            SectionName.BorderSizePixel = 0
            SectionName.Position = UDim2.new(0, 10, 0, 10)
            SectionName.Size = UDim2.new(1, -70, 0, 13)
            SectionName.Name = "SectionName"
            SectionName.Parent = Section

            SectionDescription.Font = Enum.Font.GothamBold
            SectionDescription.LineHeight = 0.9
            SectionDescription.Text = Translation:Translate(SectionConfig.Content)
            SectionDescription.TextColor3 = Settings.Settings.DescriptionTextColor
            SectionDescription.TextSize = 11
            SectionDescription.TextTransparency = 0.5
            SectionDescription.TextXAlignment = Enum.TextXAlignment.Left
            SectionDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SectionDescription.BackgroundTransparency = 1
            SectionDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
            SectionDescription.BorderSizePixel = 0
            SectionDescription.Position = UDim2.new(0, 10, 0, 22)
            SectionDescription.Size = UDim2.new(1, -70, 0, 11)
            SectionDescription.Name = "SectionDescription"
            SectionDescription.Parent = Section

            if SectionDescription.Text == "" then
                Section.Size = UDim2.new(1, -8, 0, 33)
            else
                SectionDescription:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                    SectionDescription.TextWrapped = false
                    SectionDescription.Size = UDim2.new(1, -70, 0, 11 + (11 * (SectionDescription.TextBounds.X // SectionDescription.AbsoluteSize.X)))
                    Section.Size = UDim2.new(1, -8, 0, SectionDescription.AbsoluteSize.Y + 33)
                    SectionDescription.TextWrapped = true
                    UpSize(ScrollLayer)
                end)

                SectionDescription.TextWrapped = false
                SectionDescription.Size = UDim2.new(1, -70, 0, 11 + (11 * (SectionDescription.TextBounds.X // SectionDescription.AbsoluteSize.X)))
                Section.Size = UDim2.new(1, -8, 0, SectionDescription.AbsoluteSize.Y + 33)
                SectionDescription.TextWrapped = true
                UpSize(ScrollLayer1)
            end

            SectionImage.Image = "rbxassetid://16851841101"
            SectionImage.ImageTransparency = 0.7
            SectionImage.AnchorPoint = Vector2.new(1, 0.5)
            SectionImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SectionImage.BackgroundTransparency = 1
            SectionImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
            SectionImage.BorderSizePixel = 0
            SectionImage.Position = UDim2.new(1, -10, 0.5, 0)
            SectionImage.Rotation = -90
            SectionImage.Size = UDim2.new(0, 22, 0, 22)
            SectionImage.Name = "SectionImage"
            SectionImage.Parent = Section

            SectionButton.Font = Enum.Font.SourceSans
            SectionButton.Text = ""
            SectionButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            SectionButton.TextSize = 14
            SectionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SectionButton.BackgroundTransparency = 1
            SectionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
            SectionButton.BorderSizePixel = 0
            SectionButton.Size = UDim2.new(1, 0, 1, 0)
            SectionButton.Name = "SectionButton"
            SectionButton.Parent = Section

            SectionButton.Activated:Connect(function()
                UIPageLayout:JumpToIndex(ScrollLayer1.LayoutOrder)
                TweenService:Create(
                    BackButton,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                    {TextTransparency = 0.7}
                ):Play()
                BackButton1.Text = SectionName.Text
                TweenService:Create(
                    BackButton1,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                    {TextTransparency = 0}
                ):Play()
                TweenService:Create(
                    ForwardImage,
                    TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                    {ImageTransparency = 0}
                ):Play()
            end)
            EnterMouse(Section)

            local Items = {}
            local CountItem = 0

            function Items:Seperator(SeperatorName)
                local SeperatorName = SeperatorName or "Seperator"
                local SeperatorFunc = {Value = SeperatorName}
                local Seperator = Instance.new("TextLabel");

                Seperator.Font = Enum.Font.GothamBold
                Seperator.Text = Translation:Translate(SeperatorName)
                Seperator.TextColor3 = Settings.Settings.TextColor
                Seperator.TextSize = 11
                Seperator.TextXAlignment = Enum.TextXAlignment.Left
                Seperator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Seperator.BackgroundTransparency = 1
                Seperator.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Seperator.BorderSizePixel = 0
                Seperator.Size = UDim2.new(1, -8, 0, 16)
                Seperator.Name = "Seperator"
                Seperator.LayoutOrder = CountItem
                Seperator.Parent = ScrollLayer1

                Seperator:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                    Seperator.TextWrapped = false
                    Seperator.Size = UDim2.new(1, -8, 0, 16 + (11 * (Seperator.TextBounds.X // Seperator.AbsoluteSize.X)))
                    Seperator.TextWrapped = true
                    UpSize(ScrollLayer1)
                end)

                Seperator.TextWrapped = false
                Seperator.Size = UDim2.new(1, -8, 0, 16 + (11 * (Seperator.TextBounds.X // Seperator.AbsoluteSize.X)))
                Seperator.TextWrapped = true
                UpSize(ScrollLayer1)

                function SeperatorFunc:Set(Value)
                    local Value = Value or "Seperator"
                    Seperator.Text = Translation:Translate(Value)
                    SeperatorFunc.Value = Value
                end

                CountItem = CountItem + 1
                return SeperatorFunc
            end

            function Items:Button(ButtonConfig)
                local ButtonConfig = ButtonConfig or {}
                ButtonConfig.Title = ButtonConfig.Title or "Title"
                ButtonConfig.Callback = ButtonConfig.Callback or function() end
                local ButtonFunc = {}

                local Button = Instance.new("Frame");
                local UICorner14 = Instance.new("UICorner");
                local ButtonTitle = Instance.new("TextLabel");
                local ButtonButton = Instance.new("TextButton");
                local ClickFrame = Instance.new("Frame");
                local UICorner15 = Instance.new("UICorner");
                local ClickText = Instance.new("TextLabel");

                Button.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
                Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Button.BorderSizePixel = 0
                Button.LayoutOrder = CountItem
                Button.Size = UDim2.new(1, -8, 0, 33)
                Button.Name = "Button"
                Button.Parent = ScrollLayer1

                UICorner14.CornerRadius = UDim.new(0, 3)
                UICorner14.Parent = Button

                ButtonTitle.Font = Enum.Font.GothamBold
                ButtonTitle.Text = Translation:Translate(ButtonConfig.Title)
                ButtonTitle.TextColor3 = Settings.Settings.TextColor
                ButtonTitle.TextSize = 12
                ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
                ButtonTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ButtonTitle.BackgroundTransparency = 1
                ButtonTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ButtonTitle.BorderSizePixel = 0
                ButtonTitle.Position = UDim2.new(0, 10, 0, 10)
                ButtonTitle.Size = UDim2.new(1, -150, 0, 12)
                ButtonTitle.Name = "ButtonTitle"
                ButtonTitle.Parent = Button

                ButtonButton.Font = Enum.Font.SourceSans
                ButtonButton.Text = ""
                ButtonButton.TextColor3 = Color3.fromRGB(0, 0, 0)
                ButtonButton.TextSize = 14
                ButtonButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ButtonButton.BackgroundTransparency = 1
                ButtonButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ButtonButton.BorderSizePixel = 0
                ButtonButton.Size = UDim2.new(1, 0, 1, 0)
                ButtonButton.Name = "ButtonButton"
                ButtonButton.Parent = Button

                ClickFrame.AnchorPoint = Vector2.new(1, 0.5)
                ClickFrame.BackgroundColor3 = Settings.Settings.MainColor
                ClickFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ClickFrame.BorderSizePixel = 0
                ClickFrame.Position = UDim2.new(1, -10, 0.5, 0)
                ClickFrame.Size = UDim2.new(0, 120, 0, 26)
                ClickFrame.Name = "ClickFrame"
                ClickFrame.Parent = Button

                UICorner15.CornerRadius = UDim.new(0, 3)
                UICorner15.Parent = ClickFrame

                ClickText.Font = Enum.Font.GothamBold
                ClickText.Text = Translation:Translate("Click")
                ClickText.TextColor3 = Settings.Settings.DescriptionTextColor
                ClickText.TextSize = 12
                ClickText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ClickText.BackgroundTransparency = 1
                ClickText.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ClickText.BorderSizePixel = 0
                ClickText.Size = UDim2.new(1, 0, 1, 0)
                ClickText.Name = "ClickText"
                ClickText.Parent = ClickFrame

                ButtonButton.Activated:Connect(function()
                    ButtonConfig.Callback()
                end)
                EnterMouse(Button)
                CountItem = CountItem + 1
                return ButtonFunc
            end

            function Items:TextInput(TextInputConfig)
                local TextInputConfig = TextInputConfig or {}
                TextInputConfig.Title = TextInputConfig.Title or "Title"
                TextInputConfig.Content = TextInputConfig.Content or ""
                TextInputConfig["Place Holder Text"] = TextInputConfig["Place Holder Text"] or "Enter your text here..."
                TextInputConfig["Clear Text On Focus"] = TextInputConfig["Clear Text On Focus"] or true
                TextInputConfig.Default = TextInputConfig.Default or ""
                TextInputConfig.Callback = TextInputConfig.Callback or function() end
                local TextInputFunc = {Value = TextInputConfig.Default}

                local TextInput = Instance.new("Frame");
                local UICorner16 = Instance.new("UICorner");
                local TextInputContent = Instance.new("TextLabel");
                local TextInputTitle = Instance.new("TextLabel");
                local InputFrame = Instance.new("Frame");
                local UICorner17 = Instance.new("UICorner");
                local InputBox = Instance.new("TextBox");

                TextInput.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
                TextInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
                TextInput.BorderSizePixel = 0
                TextInput.LayoutOrder = CountItem
                TextInput.Size = UDim2.new(1, -8, 0, 45)
                TextInput.Name = "TextInput"
                TextInput.Parent = ScrollLayer1

                UICorner16.CornerRadius = UDim.new(0, 3)
                UICorner16.Parent = TextInput

                TextInputContent.Font = Enum.Font.GothamBold
                TextInputContent.LineHeight = 0.9
                TextInputContent.Text = Translation:Translate(TextInputConfig.Content)
                TextInputContent.TextColor3 = Settings.Settings.DescriptionTextColor
                TextInputContent.TextSize = 11
                TextInputContent.TextTransparency = 0.5
                TextInputContent.TextXAlignment = Enum.TextXAlignment.Left
                TextInputContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                TextInputContent.BackgroundTransparency = 1
                TextInputContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
                TextInputContent.BorderSizePixel = 0
                TextInputContent.Position = UDim2.new(0, 10, 0, 22)
                TextInputContent.Size = UDim2.new(1, -150, 0, 11)
                TextInputContent.Name = "TextInputContent"
                TextInputContent.Parent = TextInput

                if TextInputContent.Text == "" then
                    TextInput.Size = UDim2.new(1, -8, 0, 33)
                else
                    TextInputContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                        TextInputContent.TextWrapped = false
                        TextInputContent.Size = UDim2.new(1, -150, 0, 11 + (11 * (TextInputContent.TextBounds.X // TextInputContent.AbsoluteSize.X)))
                        TextInput.Size = UDim2.new(1, -8, 0, TextInputContent.AbsoluteSize.Y + 33)
                        TextInputContent.TextWrapped = true
                        UpSize(ScrollLayer1)
                    end)

                    TextInputContent.TextWrapped = false
                    TextInputContent.Size = UDim2.new(1, -150, 0, 11 + (11 * (TextInputContent.TextBounds.X // TextInputContent.AbsoluteSize.X)))
                    TextInput.Size = UDim2.new(1, -8, 0, TextInputContent.AbsoluteSize.Y + 33)
                    TextInputContent.TextWrapped = true
                    UpSize(ScrollLayer1)
                end

                TextInputTitle.Font = Enum.Font.GothamBold
                TextInputTitle.Text = Translation:Translate(TextInputConfig.Title)
                TextInputTitle.TextColor3 = Settings.Settings.TextColor
                TextInputTitle.TextSize = 12
                TextInputTitle.TextXAlignment = Enum.TextXAlignment.Left
                TextInputTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                TextInputTitle.BackgroundTransparency = 1
                TextInputTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                TextInputTitle.BorderSizePixel = 0
                TextInputTitle.Position = UDim2.new(0, 10, 0, 10)
                TextInputTitle.Size = UDim2.new(1, -150, 0, 12)
                TextInputTitle.Name = "TextInputTitle"
                TextInputTitle.Parent = TextInput

                InputFrame.AnchorPoint = Vector2.new(1, 0.5)
                InputFrame.BackgroundColor3 = Settings.Settings.MainColor
                InputFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                InputFrame.BorderSizePixel = 0
                InputFrame.ClipsDescendants = true
                InputFrame.Position = UDim2.new(1, -10, 0.5, 0)
                InputFrame.Size = UDim2.new(0, 120, 0, 26)
                InputFrame.Name = "InputFrame"
                InputFrame.Parent = TextInput

                UICorner17.CornerRadius = UDim.new(0, 3)
                UICorner17.Parent = InputFrame

                InputBox.CursorPosition = -1
                InputBox.Font = Enum.Font.GothamBold
                InputBox.PlaceholderText = Translation:Translate(TextInputConfig["Place Holder Text"])
                InputBox.Text = TextInputConfig.Default
                InputBox.TextColor3 = Settings.Settings.DescriptionTextColor
                InputBox.TextSize = 11
                InputBox.TextXAlignment = Enum.TextXAlignment.Left
                InputBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                InputBox.BackgroundTransparency = 1
                InputBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
                InputBox.BorderSizePixel = 0
                InputBox.Position = UDim2.new(0, 5, 0, 0)
                InputBox.Size = UDim2.new(1, -10, 1, 0)
                InputBox.Name = "InputBox"
                InputBox.ClearTextOnFocus = TextInputConfig["Clear Text On Focus"]
                InputBox.Parent = InputFrame

                function TextInputFunc:Set(Value)
                    InputBox.Text = Value
                    TextInputFunc.Value = Value
                    TextInputConfig.Callback(Value)
                end

                InputBox.FocusLost:Connect(function()
                    TextInputFunc:Set(InputBox.Text)
                end)
                CountItem = CountItem + 1
                return TextInputFunc
            end

            function Items:Toggle(ToggleConfig)
                local ToggleConfig = ToggleConfig or {}
                ToggleConfig.Title = ToggleConfig.Title or "Title"
                ToggleConfig.Content = ToggleConfig.Content or ""
                ToggleConfig.Default = ToggleConfig.Default or false
                ToggleConfig.Callback = ToggleConfig.Callback or function() end
                ToggleConfig.Flag = ToggleConfig.Flag or false
                local ToggleFunc = {Value = ToggleConfig.Default}

                local Toggle = Instance.new("Frame");
                local UICorner8 = Instance.new("UICorner");
                local ToggleContent = Instance.new("TextLabel");
                local ToggleTitle = Instance.new("TextLabel");
                local ToggleSwitch = Instance.new("Frame");
                local UICorner9 = Instance.new("UICorner");
                local ToggleSwitch2 = Instance.new("Frame");
                local UICorner10 = Instance.new("UICorner");
                local SwitchImage = Instance.new("ImageLabel");
                local ToggleButton = Instance.new("TextButton");

                Toggle.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
                Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Toggle.BorderSizePixel = 0
                Toggle.LayoutOrder = CountItem
                Toggle.Size = UDim2.new(1, -8, 0, 44)
                Toggle.Name = "Toggle"
                Toggle.Parent = ScrollLayer1

                UICorner8.CornerRadius = UDim.new(0, 3)
                UICorner8.Parent = Toggle

                ToggleContent.Font = Enum.Font.GothamBold
                ToggleContent.LineHeight = 0.9
                ToggleContent.Text = Translation:Translate(ToggleConfig.Content)
                ToggleContent.TextColor3 = Settings.Settings.DescriptionTextColor
                ToggleContent.TextSize = 11
                ToggleContent.TextTransparency = 0.5
                ToggleContent.TextXAlignment = Enum.TextXAlignment.Left
                ToggleContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleContent.BackgroundTransparency = 1
                ToggleContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ToggleContent.BorderSizePixel = 0
                ToggleContent.Position = UDim2.new(0, 10, 0, 22)
                ToggleContent.Size = UDim2.new(1, -70, 0, 11)
                ToggleContent.Name = "ToggleContent"
                ToggleContent.Parent = Toggle

                if ToggleContent.Text == "" then
                    Toggle.Size = UDim2.new(1, -8, 0, 33)
                else
                    ToggleContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                        ToggleContent.TextWrapped = false
                        ToggleContent.Size = UDim2.new(1, -70, 0, 11 + (11 * (ToggleContent.TextBounds.X // ToggleContent.AbsoluteSize.X)))
                        Toggle.Size = UDim2.new(1, -8, 0, ToggleContent.AbsoluteSize.Y + 33)
                        ToggleContent.TextWrapped = true
                        UpSize(ScrollLayer1)
                    end)

                    ToggleContent.TextWrapped = false
                    ToggleContent.Size = UDim2.new(1, -70, 0, 11 + (11 * (ToggleContent.TextBounds.X // ToggleContent.AbsoluteSize.X)))
                    Toggle.Size = UDim2.new(1, -8, 0, ToggleContent.AbsoluteSize.Y + 33)
                    ToggleContent.TextWrapped = true
                end

                ToggleTitle.Font = Enum.Font.GothamBold
                ToggleTitle.Text = Translation:Translate(ToggleConfig.Title)
                ToggleTitle.TextColor3 = Settings.Settings.TextColor
                ToggleTitle.TextSize = 12
                ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
                ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleTitle.BackgroundTransparency = 1
                ToggleTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ToggleTitle.BorderSizePixel = 0
                ToggleTitle.Position = UDim2.new(0, 10, 0, 10)
                ToggleTitle.Size = UDim2.new(1, -70, 0, 12)
                ToggleTitle.Name = "ToggleTitle"
                ToggleTitle.Parent = Toggle

                ToggleSwitch.AnchorPoint = Vector2.new(1, 0.5)
                ToggleSwitch.BackgroundColor3 = Settings.Settings.DescriptionTextColor
                ToggleSwitch.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ToggleSwitch.BorderSizePixel = 0
                ToggleSwitch.Position = UDim2.new(1, -10, 0.5, 0)
                ToggleSwitch.Size = UDim2.new(0, 40, 0, 18)
                ToggleSwitch.Name = "ToggleSwitch"
                ToggleSwitch.Parent = Toggle

                UICorner9.CornerRadius = UDim.new(1, 0)
                UICorner9.Parent = ToggleSwitch

                ToggleSwitch2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                ToggleSwitch2.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ToggleSwitch2.BorderSizePixel = 0
                ToggleSwitch2.Position = UDim2.new(0, 1, 0, 1)
                ToggleSwitch2.Size = UDim2.new(1, -2, 1, -2)
                ToggleSwitch2.Name = "ToggleSwitch2"
                ToggleSwitch2.Parent = ToggleSwitch

                UICorner10.CornerRadius = UDim.new(1, 0)
                UICorner10.Parent = ToggleSwitch2

                SwitchImage.Image = "rbxassetid://3926305904"
                SwitchImage.ImageRectOffset = Vector2.new(124, 124)
                SwitchImage.ImageRectSize = Vector2.new(36, 36)
                SwitchImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SwitchImage.BackgroundTransparency = 1
                SwitchImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SwitchImage.BorderSizePixel = 0
                SwitchImage.Position = UDim2.new(0, 0, 0, 0)
                SwitchImage.Size = UDim2.new(0, 16, 0, 16)
                SwitchImage.Name = "SwitchImage"
                SwitchImage.Parent = ToggleSwitch2

                ToggleButton.Font = Enum.Font.SourceSans
                ToggleButton.Text = ""
                ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
                ToggleButton.TextSize = 14
                ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleButton.BackgroundTransparency = 1
                ToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Size = UDim2.new(1, 0, 1, 0)
                ToggleButton.Name = "ToggleButton"
                ToggleButton.Parent = Toggle

                local function Set(Value)
                    if Value then
                        ToggleFunc.Value = true
                        TweenService:Create(
                            SwitchImage,
                            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                            {Position = UDim2.new(1, -16, 0, 0)}
                        ):Play()
                        TweenService:Create(
                            ToggleSwitch,
                            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                            {BackgroundColor3 = GuiConfig.Color}
                        ):Play()
                    else
                        ToggleFunc.Value = false
                        TweenService:Create(
                            SwitchImage,
                            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                            {Position = UDim2.new(0, 0, 0, 0)}
                        ):Play()
                        TweenService:Create(
                            ToggleSwitch,
                            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                            {BackgroundColor3 = Settings.Settings.DescriptionTextColor}
                        ):Play()
                    end
                end

                function ToggleFunc:Set(Value)
                    Set(Value)
                    ToggleConfig.Callback(Value)
                end

                ToggleButton.Activated:Connect(function()
                    ToggleFunc:Set(not ToggleFunc.Value)
                end)

                Set(ToggleConfig.Default)
                CountItem = CountItem + 1
                return ToggleFunc
            end

            return Items
        end

        CountTab = CountTab + 1
        return Sections
    end

    return Tabs
end

return SapphireHubLib

