-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- Libraries
local Settings = require(script.Parent.Parent.SettingsLib.Settings)
local Translation = require(script.Parent.Parent.translation.translation)

-- MakeDraggable Function
local function MakeDraggable(TopBar, Frame)
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")

    local dragging
    local dragInput
    local dragStart
    local startPosition

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = Frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.Ended then
                    dragging = false
                end
            end)
        end
    end)

    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    RunService.Heartbeat:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            Frame.Position = UDim2.new(
                startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
            )
        end
    end)
end

-- AutoUp Function
local function AutoUp(ScrollingFrame)
    local function updateCanvasSize()
        local contentHeight = 0
        for _, child in ipairs(ScrollingFrame:GetChildren()) do
            if child:IsA("GuiObject") and child.Visible then
                contentHeight = contentHeight + child.AbsoluteSize.Y + ScrollingFrame.UIListLayout.Padding.Offset
            end
        end
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
    end

    ScrollingFrame.ChildAdded:Connect(updateCanvasSize)
    ScrollingFrame.ChildRemoved:Connect(updateCanvasSize)
    ScrollingFrame.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("GuiObject") then
            descendant.Changed:Connect(function(property)
                if property == "Size" or property == "Visible" then
                    updateCanvasSize()
                end
            end)
        end
    end)
    updateCanvasSize()
end

-- EnterMouse Function
local function EnterMouse(Object)
    local OriginalColor = Object.BackgroundColor3
    Object.MouseEnter:Connect(function()
        Object.BackgroundColor3 = OriginalColor:Lerp(Color3.fromRGB(255, 255, 255), 0.1)
    end)
    Object.MouseLeave:Connect(function()
        Object.BackgroundColor3 = OriginalColor
    end)
end

-- Anti-AFK
spawn(function()
    while wait(60) do
        pcall(function()
            LocalPlayer.Idled:fire()
        end)
    end
end)

-- Key System
if Settings.EnableKeySystem then
    local KeySystemGui = Instance.new("ScreenGui", CoreGui)
    KeySystemGui.Name = "KeySystemGui"
    KeySystemGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame", KeySystemGui)
    MainFrame.Size = UDim2.new(0, 300, 0, 150)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundColor3 = Settings.BackgroundColor
    MainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
    MainFrame.BorderSizePixel = 2

    local TitleLabel = Instance.new("TextLabel", MainFrame)
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.Text = Translation:Translate("Key System")
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextColor3 = Settings.TextColor
    TitleLabel.BackgroundColor3 = Settings.BackgroundColor

    local KeyInput = Instance.new("TextBox", MainFrame)
    KeyInput.Size = UDim2.new(0, 260, 0, 40)
    KeyInput.Position = UDim2.new(0.5, -130, 0.5, -20)
    KeyInput.PlaceholderText = Translation:Translate("Enter Key...")
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.TextColor3 = Settings.TextColor
    KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    local SubmitButton = Instance.new("TextButton", MainFrame)
    SubmitButton.Size = UDim2.new(0, 100, 0, 30)
    SubmitButton.Position = UDim2.new(0.5, -50, 0.8, 0)
    SubmitButton.Text = Translation:Translate("Submit")
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.TextColor3 = Settings.TextColor
    SubmitButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    local function checkKey(key)
        if key == Settings.Key then
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
    GuiConfig.Color = GuiConfig.Color or Settings.MainColor
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
    Main.BackgroundColor3 = Settings.BackgroundColor
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
    TopDescription.TextColor3 = Settings.DescriptionTextColor
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
    DropShadow.ImageColor3 = Settings.ShadowColor
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
    NamePlayer.TextColor3 = Settings.DescriptionTextColor
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
    LogTitle.TextColor3 = Settings.DescriptionTextColor
    LogTitle.TextSize = 18
    LogTitle.TextXAlignment = Enum.TextXAlignment.Left
    LogTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LogTitle.BackgroundTransparency = 1
    LogTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LogTitle.BorderSizePixel = 0
    LogTitle.Position = UDim2.new(0, 12, 0, 10)
    LogTitle.Size = UDim2.new(0, 0, 0, 18)
    LogTitle.Name = "LogTitle"
    LogTitle.Parent = LogFrame

    LogDescription.Font = Enum.Font.GothamBold
    LogDescription.Text = Translation:Translate(GuiConfig["Info Description"])
    LogDescription.TextColor3 = Settings.DescriptionTextColor
    LogDescription.TextSize = 12
    LogDescription.TextWrapped = true
    LogDescription.TextXAlignment = Enum.TextXAlignment.Left
    LogDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LogDescription.BackgroundTransparency = 1
    LogDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LogDescription.BorderSizePixel = 0
    LogDescription.Position = UDim2.new(0, 12, 0.5, 0)
    LogDescription.Size = UDim2.new(1, -20, 0.5, 0)
    LogDescription.Name = "LogDescription"
    LogDescription.Parent = LogFrame

    LogoInfo.Image = GuiConfig["Logo Player"]
    LogoInfo.AnchorPoint = Vector2.new(0.5, 0.5)
    LogoInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LogoInfo.BackgroundTransparency = 1
    LogoInfo.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LogoInfo.BorderSizePixel = 0
    LogoInfo.Position = UDim2.new(1, -25, 0, 25)
    LogoInfo.Size = UDim2.new(0, 30, 0, 30)
    LogoInfo.Name = "LogoInfo"
    LogoInfo.Parent = LogFrame

    UICorner33.CornerRadius = UDim.new(0, 1000)
    UICorner33.Parent = LogoInfo

    UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke5.Color = Color3.fromRGB(0, 0, 0)
    UIStroke5.LineJoinMode = Enum.LineJoinMode.Round
    UIStroke5.Thickness = 1
    UIStroke5.Transparency = 0.5
    UIStroke5.Parent = LogoInfo

    InfoButton.MouseButton1Click:Connect(function()
        AnotherFrame.Visible = not AnotherFrame.Visible
        if AnotherFrame.Visible then
            TweenService:Create(LogFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 300, 0, 200)}):Play()
        else
            TweenService:Create(LogFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        end
    end)

    AnotherButton.MouseButton1Click:Connect(function()
        AnotherFrame.Visible = not AnotherFrame.Visible
        if AnotherFrame.Visible then
            TweenService:Create(LogFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 300, 0, 200)}):Play()
        else
            TweenService:Create(LogFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        end
    end)

    --// Section
    local SectionHolder = Instance.new("Frame");
    local SectionScroll = Instance.new("ScrollingFrame");
    local UIListLayout2 = Instance.new("UIListLayout");

    SectionHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SectionHolder.BackgroundTransparency = 1
    SectionHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SectionHolder.BorderSizePixel = 0
    SectionHolder.Position = UDim2.new(0, 145, 0, 34)
    SectionHolder.Size = UDim2.new(1, -155, 1, -44)
    SectionHolder.Name = "SectionHolder"
    SectionHolder.Parent = Main

    SectionScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    SectionScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
    SectionScroll.ScrollBarThickness = 0
    SectionScroll.Active = true
    SectionScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SectionScroll.BackgroundTransparency = 1
    SectionScroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SectionScroll.BorderSizePixel = 0
    SectionScroll.Position = UDim2.new(0, 0, 0, 0)
    SectionScroll.Size = UDim2.new(1, 0, 1, 0)
    SectionScroll.Name = "SectionScroll"
    SectionScroll.Parent = SectionHolder

    UIListLayout2.Padding = UDim.new(0, 3)
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout2.Parent = SectionScroll

    AutoUp(SectionScroll)

    function SapphireHubLib:AddTab(TabName, CallBack)
        local Tab = Instance.new("Frame");
        local UICorner2 = Instance.new("UICorner");
        local TabButton = Instance.new("TextButton");

        Tab.BackgroundColor3 = Settings.MainColor
        Tab.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Tab.BorderSizePixel = 0
        Tab.Size = UDim2.new(1, 0, 0, 30)
        Tab.Name = "Tab"
        Tab.Parent = ScrollTab

        EnterMouse(Tab)

        UICorner2.CornerRadius = UDim.new(0, 3)
        UICorner2.Parent = Tab

        TabButton.Font = Enum.Font.GothamBold
        TabButton.Text = Translation:Translate(TabName)
        TabButton.TextColor3 = Settings.TextColor
        TabButton.TextSize = 14
        TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.BackgroundTransparency = 1
        TabButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 1, 0)
        TabButton.Name = "TabButton"
        TabButton.Parent = Tab

        local Section = Instance.new("Frame");
        local UIListLayout3 = Instance.new("UIListLayout");

        Section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Section.BackgroundTransparency = 1
        Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Section.BorderSizePixel = 0
        Section.Size = UDim2.new(1, 0, 0, 0)
        Section.Name = TabName
        Section.Parent = SectionScroll

        UIListLayout3.Padding = UDim.new(0, 3)
        UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout3.Parent = Section

        TabButton.MouseButton1Click:Connect(function()
            for i, v in pairs(SectionScroll:GetChildren()) do
                if v:IsA("Frame") then
                    v.Visible = false
                end
            end
            Section.Visible = true
            CallBack(Section)
        end)

        function SapphireHubLib:AddButton(Section, ButtonName, CallBack)
            local Button = Instance.new("Frame");
            local UICorner3 = Instance.new("UICorner");
            local ButtonText = Instance.new("TextLabel");
            local ButtonClick = Instance.new("TextButton");

            Button.BackgroundColor3 = Settings.MainColor
            Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Button.BorderSizePixel = 0
            Button.Size = UDim2.new(1, 0, 0, 30)
            Button.Name = "Button"
            Button.Parent = Section

            EnterMouse(Button)

            UICorner3.CornerRadius = UDim.new(0, 3)
            UICorner3.Parent = Button

            ButtonText.Font = Enum.Font.GothamBold
            ButtonText.Text = Translation:Translate(ButtonName)
            ButtonText.TextColor3 = Settings.TextColor
            ButtonText.TextSize = 14
            ButtonText.TextXAlignment = Enum.TextXAlignment.Left
            ButtonText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ButtonText.BackgroundTransparency = 1
            ButtonText.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ButtonText.BorderSizePixel = 0
            ButtonText.Position = UDim2.new(0, 10, 0, 0)
            ButtonText.Size = UDim2.new(1, -10, 1, 0)
            ButtonText.Name = "ButtonText"
            ButtonText.Parent = Button

            ButtonClick.Font = Enum.Font.SourceSans
            ButtonClick.Text = ""
            ButtonClick.TextColor3 = Color3.fromRGB(0, 0, 0)
            ButtonClick.TextSize = 14
            ButtonClick.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ButtonClick.BackgroundTransparency = 1
            ButtonClick.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ButtonClick.BorderSizePixel = 0
            ButtonClick.Size = UDim2.new(1, 0, 1, 0)
            ButtonClick.Name = "ButtonClick"
            ButtonClick.Parent = Button

            ButtonClick.MouseButton1Click:Connect(function()
                CallBack()
            end)
        end

        function SapphireHubLib:AddToggle(Section, ToggleName, CallBack)
            local Toggle = Instance.new("Frame");
            local UICorner4 = Instance.new("UICorner");
            local ToggleText = Instance.new("TextLabel");
            local ToggleButton = Instance.new("TextButton");
            local ToggleCircle = Instance.new("Frame");
            local UICorner8 = Instance.new("UICorner");

            Toggle.BackgroundColor3 = Settings.MainColor
            Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Toggle.BorderSizePixel = 0
            Toggle.Size = UDim2.new(1, 0, 0, 30)
            Toggle.Name = "Toggle"
            Toggle.Parent = Section

            EnterMouse(Toggle)

            UICorner4.CornerRadius = UDim.new(0, 3)
            UICorner4.Parent = Toggle

            ToggleText.Font = Enum.Font.GothamBold
            ToggleText.Text = Translation:Translate(ToggleName)
            ToggleText.TextColor3 = Settings.TextColor
            ToggleText.TextSize = 14
            ToggleText.TextXAlignment = Enum.TextXAlignment.Left
            ToggleText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleText.BackgroundTransparency = 1
            ToggleText.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ToggleText.BorderSizePixel = 0
            ToggleText.Position = UDim2.new(0, 10, 0, 0)
            ToggleText.Size = UDim2.new(1, -10, 1, 0)
            ToggleText.Name = "ToggleText"
            ToggleText.Parent = Toggle

            ToggleButton.Font = Enum.Font.SourceSans
            ToggleButton.Text = ""
            ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            ToggleButton.TextSize = 14
            ToggleButton.AnchorPoint = Vector2.new(1, 0.5)
            ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleButton.BackgroundTransparency = 1
            ToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Position = UDim2.new(1, -10, 0.5, 0)
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Parent = Toggle

            ToggleCircle.AnchorPoint = Vector2.new(0.5, 0.5)
            ToggleCircle.BackgroundColor3 = Settings.TextColor
            ToggleCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Position = UDim2.new(0.25, 0, 0.5, 0)
            ToggleCircle.Size = UDim2.new(0, 15, 0, 15)
            ToggleCircle.Name = "ToggleCircle"
            ToggleCircle.Parent = ToggleButton

            UICorner8.CornerRadius = UDim.new(0, 1000)
            UICorner8.Parent = ToggleCircle

            local Toggled = false

            ToggleButton.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                if Toggled then
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0.75, 0, 0.5, 0), BackgroundColor3 = GuiConfig.Color}):Play()
                else
                    TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0.25, 0, 0.5, 0), BackgroundColor3 = Settings.TextColor}):Play()
                end
                CallBack(Toggled)
            end)
        end

        function SapphireHubLib:AddSlider(Section, SliderName, Min, Max, Default, CallBack)
            local Slider = Instance.new("Frame");
            local UICorner9 = Instance.new("UICorner");
            local SliderText = Instance.new("TextLabel");
            local SliderValue = Instance.new("TextLabel");
            local SliderBar = Instance.new("Frame");
            local UICorner10 = Instance.new("UICorner");
            local SliderFill = Instance.new("Frame");
            local UICorner11 = Instance.new("UICorner");
            local SliderButton = Instance.new("TextButton");
            local SliderCircle = Instance.new("Frame");
            local UICorner12 = Instance.new("UICorner");

            Slider.BackgroundColor3 = Settings.MainColor
            Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Slider.BorderSizePixel = 0
            Slider.Size = UDim2.new(1, 0, 0, 40)
            Slider.Name = "Slider"
            Slider.Parent = Section

            EnterMouse(Slider)

            UICorner9.CornerRadius = UDim.new(0, 3)
            UICorner9.Parent = Slider

            SliderText.Font = Enum.Font.GothamBold
            SliderText.Text = Translation:Translate(SliderName)
            SliderText.TextColor3 = Settings.TextColor
            SliderText.TextSize = 14
            SliderText.TextXAlignment = Enum.TextXAlignment.Left
            SliderText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderText.BackgroundTransparency = 1
            SliderText.BorderColor3 = Color3.fromRGB(0, 0, 0)
            SliderText.BorderSizePixel = 0
            SliderText.Position = UDim2.new(0, 10, 0, 0)
            SliderText.Size = UDim2.new(1, -10, 0.5, 0)
            SliderText.Name = "SliderText"
            SliderText.Parent = Slider

            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.Text = Default
            SliderValue.TextColor3 = Settings.TextColor
            SliderValue.TextSize = 14
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderValue.BackgroundTransparency = 1
            SliderValue.BorderColor3 = Color3.fromRGB(0, 0, 0)
            SliderValue.BorderSizePixel = 0
            SliderValue.Position = UDim2.new(0, -10, 0, 0)
            SliderValue.Size = UDim2.new(1, -10, 0.5, 0)
            SliderValue.Name = "SliderValue"
            SliderValue.Parent = Slider

            SliderBar.BackgroundColor3 = Settings.TextColor
            SliderBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
            SliderBar.BorderSizePixel = 0
            SliderBar.Position = UDim2.new(0, 10, 0.7, 0)
            SliderBar.Size = UDim2.new(1, -20, 0, 5)
            SliderBar.Name = "SliderBar"
            SliderBar.Parent = Slider

            UICorner10.CornerRadius = UDim.new(0, 3)
            UICorner10.Parent = SliderBar

            SliderFill.BackgroundColor3 = GuiConfig.Color
            SliderFill.BorderColor3 = Color3.fromRGB(0, 0, 0)
            SliderFill.BorderSizePixel = 0
            SliderFill.Size = UDim2.new(0, 0, 1, 0)
            SliderFill.Name = "SliderFill"
            SliderFill.Parent = SliderBar

            UICorner11.CornerRadius = UDim.new(0, 3)
            UICorner11.Parent = SliderFill

            SliderButton.Font = Enum.Font.SourceSans
            SliderButton.Text = ""
            SliderButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            SliderButton.TextSize = 14
            SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderButton.BackgroundTransparency = 1
            SliderButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
            SliderButton.BorderSizePixel = 0
            SliderButton.Size = UDim2.new(1, 0, 1, 0)
            SliderButton.Name = "SliderButton"
            SliderButton.Parent = Slider

            SliderCircle.AnchorPoint = Vector2.new(0.5, 0.5)
            SliderCircle.BackgroundColor3 = GuiConfig.Color
            SliderCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
            SliderCircle.BorderSizePixel = 0
            SliderCircle.Position = UDim2.new(0, 0, 0.5, 0)
            SliderCircle.Size = UDim2.new(0, 15, 0, 15)
            SliderCircle.Name = "SliderCircle"
            SliderCircle.Parent = SliderFill

            UICorner12.CornerRadius = UDim.new(0, 1000)
            UICorner12.Parent = SliderCircle

            local Dragging = false
            local CurrentValue = Default

            SliderButton.MouseButton1Down:Connect(function()
                Dragging = true
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local MouseX = input.Position.X
                    local RelativeX = MouseX - SliderBar.AbsolutePosition.X
                    local Percentage = math.clamp(RelativeX / SliderBar.AbsoluteSize.X, 0, 1)
                    CurrentValue = math.floor(Min + (Max - Min) * Percentage)

                    SliderValue.Text = CurrentValue
                    SliderFill.Size = UDim2.new(Percentage, 0, 1, 0)
                    CallBack(CurrentValue)
                end
            end)
        end

        function SapphireHubLib:AddDropdown(Section, DropdownName, Options, CallBack)
            local Dropdown = Instance.new("Frame");
            local UICorner13 = Instance.new("UICorner");
            local DropdownText = Instance.new("TextLabel");
            local DropdownButton = Instance.new("TextButton");
            local DropdownArrow = Instance.new("ImageLabel");
            local DropdownHolder = Instance.new("Frame");
            local UIListLayout4 = Instance.new("UIListLayout");

            Dropdown.BackgroundColor3 = Settings.MainColor
            Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Dropdown.BorderSizePixel = 0
            Dropdown.Size = UDim2.new(1, 0, 0, 30)
            Dropdown.Name = "Dropdown"
            Dropdown.Parent = Section

            EnterMouse(Dropdown)

            UICorner13.CornerRadius = UDim.new(0, 3)
            UICorner13.Parent = Dropdown

            DropdownText.Font = Enum.Font.GothamBold
            DropdownText.Text = Translation:Translate(DropdownName)
            DropdownText.TextColor3 = Settings.TextColor
            DropdownText.TextSize = 14
            DropdownText.TextXAlignment = Enum.TextXAlignment.Left
            DropdownText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            DropdownText.BackgroundTransparency = 1
            DropdownText.BorderColor3 = Color3.fromRGB(0, 0, 0)
            DropdownText.BorderSizePixel = 0
            DropdownText.Position = UDim2.new(0, 10, 0, 0)
            DropdownText.Size = UDim2.new(1, -10, 1, 0)
            DropdownText.Name = "DropdownText"
            DropdownText.Parent = Dropdown

            DropdownButton.Font = Enum.Font.SourceSans
            DropdownButton.Text = ""
            DropdownButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            DropdownButton.TextSize = 14
            DropdownButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
            DropdownButton.BorderSizePixel = 0
            DropdownButton.Size = UDim2.new(1, 0, 1, 0)
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Parent = Dropdown

            DropdownArrow.Image = "rbxassetid://3926305904"
            DropdownArrow.AnchorPoint = Vector2.new(0.5, 0.5)
            DropdownArrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            DropdownArrow.BackgroundTransparency = 1
            DropdownArrow.BorderColor3 = Color3.fromRGB(0, 0, 0)
            DropdownArrow.BorderSizePixel = 0
            DropdownArrow.Position = UDim2.new(1, -15, 0.5, 0)
            DropdownArrow.Size = UDim2.new(0, 15, 0, 15)
            DropdownArrow.Name = "DropdownArrow"
            DropdownArrow.Parent = Dropdown

            DropdownHolder.BackgroundColor3 = Settings.MainColor
            DropdownHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
            DropdownHolder.BorderSizePixel = 0
            DropdownHolder.Position = UDim2.new(0, 0, 1, 5)
            DropdownHolder.Size = UDim2.new(1, 0, 0, 0)
            DropdownHolder.Visible = false
            DropdownHolder.ZIndex = 2
            DropdownHolder.Name = "DropdownHolder"
            DropdownHolder.Parent = Dropdown

            UIListLayout4.Padding = UDim.new(0, 3)
            UIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout4.Parent = DropdownHolder

            local Expanded = false

            DropdownButton.MouseButton1Click:Connect(function()
                Expanded = not Expanded
                if Expanded then
                    TweenService:Create(DropdownHolder, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, #Options * 25)}):Play()
                else
                    TweenService:Create(DropdownHolder, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                end
            end)

            for i, v in pairs(Options) do
                local Option = Instance.new("Frame");
                local UICorner14 = Instance.new("UICorner");
                local OptionButton = Instance.new("TextButton");

                Option.BackgroundColor3 = Settings.MainColor
                Option.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Option.BorderSizePixel = 0
                Option.Size = UDim2.new(1, 0, 0, 20)
                Option.Name = "Option"
                Option.Parent = DropdownHolder

                EnterMouse(Option)

                UICorner14.CornerRadius = UDim.new(0, 3)
                UICorner14.Parent = Option

                OptionButton.Font = Enum.Font.GothamBold
                OptionButton.Text = Translation:Translate(v)
                OptionButton.TextColor3 = Settings.TextColor
                OptionButton.TextSize = 12
                OptionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                OptionButton.BackgroundTransparency = 1
                OptionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
                OptionButton.BorderSizePixel = 0
                OptionButton.Size = UDim2.new(1, 0, 1, 0)
                OptionButton.Name = "OptionButton"
                OptionButton.Parent = Option

                OptionButton.MouseButton1Click:Connect(function()
                    DropdownText.Text = Translation:Translate(v)
                    Expanded = false
                    TweenService:Create(DropdownHolder, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    CallBack(v)
                end)
            end
        end

        function SapphireHubLib:AddColorPicker(Section, ColorPickerName, CallBack)
            local ColorPicker = Instance.new("Frame");
            local UICorner15 = Instance.new("UICorner");
            local ColorPickerText = Instance.new("TextLabel");
            local ColorPickerButton = Instance.new("TextButton");
            local ColorPickerColor = Instance.new("Frame");
            local UICorner16 = Instance.new("UICorner");
            local ColorPickerHolder = Instance.new("Frame");
            local ColorPickerHue = Instance.new("Frame");
            local UICorner17 = Instance.new("UICorner");
            local ColorPickerHueSlider = Instance.new("TextButton");
            local ColorPickerHueCircle = Instance.new("Frame");
            local UICorner18 = Instance.new("UICorner");
            local ColorPickerSV = Instance.new("Frame");
            local UICorner19 = Instance.new("UICorner");
            local ColorPickerSVOverlay = Instance.new("Frame");
            local ColorPickerSVOverlay2 = Instance.new("Frame");
            local ColorPickerSVCircle = Instance.new("Frame");
            local UICorner20 = Instance.new("UICorner");
            local ColorPickerSVButton = Instance.new("TextButton");

            ColorPicker.BackgroundColor3 = Settings.MainColor
            ColorPicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ColorPicker.BorderSizePixel = 0
            ColorPicker.Size = UDim2.new(1, 0, 0, 30)
            ColorPicker.Name = "ColorPicker"
            ColorPicker.Parent = Section

            EnterMouse(ColorPicker)

            UICorner15.CornerRadius = UDim.new(0, 3)
            UICorner15.Parent = ColorPicker

            ColorPickerText.Font = Enum.Font.GothamBold
            ColorPickerText.Text = Translation:Translate(ColorPickerName)
            ColorPickerText.TextColor3 = Settings.TextColor
            ColorPickerText.TextSize = 14
            ColorPickerText.TextXAlignment = Enum.TextXAlignment.Left
            ColorPickerText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorPickerText.BackgroundTransparency = 1
            ColorPickerText.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ColorPickerText.BorderSizePixel = 0
            ColorPickerText.Position = UDim2.new(0, 10, 0, 0)
            ColorPickerText.Size = UDim2.new(1, -10, 1, 0)
            ColorPickerText.Name = "ColorPickerText"
            ColorPickerText.Parent = ColorPicker

            ColorPickerButton.Font = Enum.Font.SourceSans
            ColorPickerButton.Text = ""
            ColorPickerButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            ColorPickerButton.TextSize = 14
            ColorPickerButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorPickerButton.BackgroundTransparency = 1
            ColorPickerButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ColorPickerButton.BorderSizePixel = 0
            ColorPickerButton.Size = UDim2.new(1, 0, 1, 0)
            ColorPickerButton.Name = "ColorPickerButton"
            ColorPickerButton.Parent = ColorPicker

            ColorPickerColor.AnchorPoint = Vector2.new(1, 0.5)
            ColorPickerColor.BackgroundColor3 = Settings.MainColor
            ColorPickerColor.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ColorPickerColor.BorderSizePixel = 0
            ColorPickerColor.Position = UDim2.new(1, -10, 0.5, 0)
            ColorPickerColor.Size = UDim2.new(0, 20, 0, 20)
            ColorPickerColor.Name = "ColorPickerColor"
            ColorPickerColor.Parent = ColorPicker

            UICorner16.CornerRadius = UDim.new(0, 3)
            UICorner16.Parent = ColorPickerColor

            ColorPickerHolder.BackgroundColor3 = Settings.MainColor
            ColorPickerHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ColorPickerHolder.BorderSizePixel = 0
            ColorPickerHolder.Position = UDim2.new(0, 0, 1, 5)
            ColorPickerHolder.Size = UDim2.new(1, 0, 0, 0)
            ColorPickerHolder.Visible = false
            ColorPickerHolder.ZIndex = 2
            ColorPickerHolder.Name = "ColorPickerHolder"
            ColorPickerHolder.Parent = ColorPicker

            ColorPickerHue.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            ColorPickerHue.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ColorPickerHue.BorderSizePixel = 0
            ColorPickerHue.Position = UDim2.new(0, 5, 0, 5)
            ColorPickerHue.Size = UDim2.new(0, 20, 1, -10)
            ColorPickerHue.Name = "ColorPickerHue"
            ColorPickerHue.Parent = ColorPickerHolder

            UICorner17.CornerRadius = UDim.new(0, 3)
            UICorner17.Parent = ColorPickerHue

            ColorPickerHueSlider.Font = Enum.Font.SourceSans
            ColorPickerHueSlider.Text = ""
            ColorPickerHueSlider.TextColor3 = Color3.fromRGB(0, 0, 0)
            ColorPickerHueSlider.TextSize = 14
            ColorPickerHueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorPickerHueSlider.BackgroundTransparency = 1
            ColorPickerHueSlider.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ColorPickerHueSlider.BorderSizePixel = 0
            ColorPickerHueSlider.Size = UDim2.new(1, 0, 1, 0)
            ColorPickerHueSlider.Name = "ColorPickerHueSlider"
            ColorPickerHueSlider.Parent = ColorPickerHue

            ColorPickerHueCircle.AnchorPoint = Vector2.new(0.5, 0.5)
            ColorPickerHueCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorPickerHueCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ColorPickerHueCircle.BorderSizePixel = 0
            ColorPickerHueCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
            ColorPickerHueCircle.Size = UDim2.new(0, 15, 0, 15)
            ColorPickerHueCircle.Name = "ColorPickerHueCircle"
            ColorPickerHueCircle.Parent = ColorPickerHueSlider

            UICorner18.CornerRadius = UDim.new(0, 1000)
            UICorner18.Parent = ColorPickerHueCircle

            ColorPickerSV.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorPickerSV.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ColorPickerSV.BorderSizePixel = 0
            ColorPickerSV.Position = UDim2.new(0, 30, 0, 5)
            ColorPickerSV.Size = UDim2.new(1, -35, 1, -10)
            ColorPickerSV.Name = "ColorPickerSV"
            ColorPickerSV.Parent = ColorPickerHolder

            UICorner19.CornerRadius = UDim.new(0, 3)
            UICorner19.Parent = ColorPickerSV

            ColorPickerSVOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            ColorPickerSVOverlay.BackgroundTransparency = 0.5
            ColorPickerSVOverlay.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ColorPickerSVOverlay.BorderSizePixel = 0
            ColorPickerSVOverlay.Size = UDim2.new(1, 0, 1, 0)
            ColorPickerSVOverlay.Name = "ColorPickerSVOverlay"
            ColorPickerSVOverlay.Parent = ColorPickerSV

            ColorPickerSVOverlay2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorPickerSVOverlay2.BackgroundTransparency = 0.5
            ColorPickerSVOverlay2.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ColorPickerSVOverlay2.BorderSizePixel = 0
            ColorPickerSVOverlay2.Size = UDim2.new(1, 0, 1, 0)
            ColorPickerSVOverlay2.Name = "ColorPickerSVOverlay2"
            ColorPickerSVOverlay2.Parent = ColorPickerSV

            ColorPickerSVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
            ColorPickerSVCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorPickerSVCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ColorPickerSVCircle.BorderSizePixel = 0
            ColorPickerSVCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
            ColorPickerSVCircle.Size = UDim2.new(0, 15, 0, 15)
            ColorPickerSVCircle.Name = "ColorPickerSVCircle"
            ColorPickerSVCircle.Parent = ColorPickerSV

            UICorner20.CornerRadius = UDim.new(0, 1000)
            UICorner20.Parent = ColorPickerSVCircle

            ColorPickerSVButton.Font = Enum.Font.SourceSans
            ColorPickerSVButton.Text = ""
            ColorPickerSVButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            ColorPickerSVButton.TextSize = 14
            ColorPickerSVButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorPickerSVButton.BackgroundTransparency = 1
            ColorPickerSVButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ColorPickerSVButton.BorderSizePixel = 0
            ColorPickerSVButton.Size = UDim2.new(1, 0, 1, 0)
            ColorPickerSVButton.Name = "ColorPickerSVButton"
            ColorPickerSVButton.Parent = ColorPickerSV

            local Hue = 0
            local Saturation = 1
            local Value = 1

            local function UpdateColor()
                local Color = Color3.fromHSV(Hue, Saturation, Value)
                ColorPickerColor.BackgroundColor3 = Color
                ColorPickerSV.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
                CallBack(Color)
            end

            ColorPickerButton.MouseButton1Click:Connect(function()
                TweenService:Create(ColorPickerHolder, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 150)}):Play()
            end)

            ColorPickerHueSlider.MouseButton1Down:Connect(function()
                local DraggingHue = true
                local StartY = UserInputService:GetMouseLocation().Y
                local StartHue = Hue

                local Connection
                Connection = UserInputService.InputChanged:Connect(function(input)
                    if DraggingHue and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local DeltaY = input.Position.Y - StartY
                        local Percentage = math.clamp(DeltaY / ColorPickerHueSlider.AbsoluteSize.Y, -1, 1)
                        Hue = math.clamp(StartHue + Percentage, 0, 1)
                        ColorPickerHueCircle.Position = UDim2.new(0.5, 0, Hue, 0)
                        UpdateColor()
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        DraggingHue = false
                        Connection:Disconnect()
                    end
                end)
            end)

            ColorPickerSVButton.MouseButton1Down:Connect(function()
                local DraggingSV = true
                local StartX = UserInputService:GetMouseLocation().X
                local StartY = UserInputService:GetMouseLocation().Y
                local StartSaturation = Saturation
                local StartValue = Value

                local Connection
                Connection = UserInputService.InputChanged:Connect(function(input)
                    if DraggingSV and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local DeltaX = input.Position.X - StartX
                        local DeltaY = input.Position.Y - StartY
                        local PercentageX = math.clamp(DeltaX / ColorPickerSVButton.AbsoluteSize.X, -1, 1)
                        local PercentageY = math.clamp(DeltaY / ColorPickerSVButton.AbsoluteSize.Y, -1, 1)
                        Saturation = math.clamp(StartSaturation + PercentageX, 0, 1)
                        Value = math.clamp(StartValue - PercentageY, 0, 1)
                        ColorPickerSVCircle.Position = UDim2.new(Saturation, 0, 1 - Value, 0)
                        UpdateColor()
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        DraggingSV = false
                        Connection:Disconnect()
                    end
                end)
            end)

            UpdateColor()
        end

        function SapphireHubLib:AddTextBox(Section, TextBoxName, DefaultText, CallBack)
            local TextBox = Instance.new("Frame");
            local UICorner21 = Instance.new("UICorner");
            local TextBoxText = Instance.new("TextLabel");
            local TextBoxInput = Instance.new("TextBox");
            local UICorner22 = Instance.new("UICorner");

            TextBox.BackgroundColor3 = Settings.MainColor
            TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
            TextBox.BorderSizePixel = 0
            TextBox.Size = UDim2.new(1, 0, 0, 40)
            TextBox.Name = "TextBox"
            TextBox.Parent = Section

            EnterMouse(TextBox)

            UICorner21.CornerRadius = UDim.new(0, 3)
            UICorner21.Parent = TextBox

            TextBoxText.Font = Enum.Font.GothamBold
            TextBoxText.Text = Translation:Translate(TextBoxName)
            TextBoxText.TextColor3 = Settings.TextColor
            TextBoxText.TextSize = 14
            TextBoxText.TextXAlignment = Enum.TextXAlignment.Left
            TextBoxText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextBoxText.BackgroundTransparency = 1
            TextBoxText.BorderColor3 = Color3.fromRGB(0, 0, 0)
            TextBoxText.BorderSizePixel = 0
            TextBoxText.Position = UDim2.new(0, 10, 0, 0)
            TextBoxText.Size = UDim2.new(1, -10, 0.5, 0)
            TextBoxText.Name = "TextBoxText"
            TextBoxText.Parent = TextBox

            TextBoxInput.Font = Enum.Font.Gotham
            TextBoxInput.PlaceholderText = Translation:Translate(DefaultText)
            TextBoxInput.Text = DefaultText
            TextBoxInput.TextColor3 = Settings.TextColor
            TextBoxInput.TextSize = 14
            TextBoxInput.TextXAlignment = Enum.TextXAlignment.Left
            TextBoxInput.BackgroundColor3 = Settings.TextColor
            TextBoxInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
            TextBoxInput.BorderSizePixel = 0
            TextBoxInput.Position = UDim2.new(0, 10, 0.5, 0)
            TextBoxInput.Size = UDim2.new(1, -20, 0.5, -5)
            TextBoxInput.Name = "TextBoxInput"
            TextBoxInput.Parent = TextBox

            UICorner22.CornerRadius = UDim.new(0, 3)
            UICorner22.Parent = TextBoxInput

            TextBoxInput.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    CallBack(TextBoxInput.Text)
                end
            end)
        end

        function SapphireHubLib:AddKeybind(Section, KeybindName, CallBack)
            local Keybind = Instance.new("Frame");
            local UICorner23 = Instance.new("UICorner");
            local KeybindText = Instance.new("TextLabel");
            local KeybindButton = Instance.new("TextButton");
            local KeybindKey = Instance.new("TextLabel");
            local UICorner24 = Instance.new("UICorner");

            Keybind.BackgroundColor3 = Settings.MainColor
            Keybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Keybind.BorderSizePixel = 0
            Keybind.Size = UDim2.new(1, 0, 0, 30)
            Keybind.Name = "Keybind"
            Keybind.Parent = Section

            EnterMouse(Keybind)

            UICorner23.CornerRadius = UDim.new(0, 3)
            UICorner23.Parent = Keybind

            KeybindText.Font = Enum.Font.GothamBold
            KeybindText.Text = Translation:Translate(KeybindName)
            KeybindText.TextColor3 = Settings.TextColor
            KeybindText.TextSize = 14
            KeybindText.TextXAlignment = Enum.TextXAlignment.Left
            KeybindText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            KeybindText.BackgroundTransparency = 1
            KeybindText.BorderColor3 = Color3.fromRGB(0, 0, 0)
            KeybindText.BorderSizePixel = 0
            KeybindText.Position = UDim2.new(0, 10, 0, 0)
            KeybindText.Size = UDim2.new(1, -10, 1, 0)
            KeybindText.Name = "KeybindText"
            KeybindText.Parent = Keybind

            KeybindButton.Font = Enum.Font.SourceSans
            KeybindButton.Text = ""
            KeybindButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            KeybindButton.TextSize = 14
            KeybindButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            KeybindButton.BackgroundTransparency = 1
            KeybindButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
            KeybindButton.BorderSizePixel = 0
            KeybindButton.Size = UDim2.new(1, 0, 1, 0)
            KeybindButton.Name = "KeybindButton"
            KeybindButton.Parent = Keybind

            KeybindKey.AnchorPoint = Vector2.new(1, 0.5)
            KeybindKey.BackgroundColor3 = Settings.TextColor
            KeybindKey.BorderColor3 = Color3.fromRGB(0, 0, 0)
            KeybindKey.BorderSizePixel = 0
            KeybindKey.Position = UDim2.new(1, -10, 0.5, 0)
            KeybindKey.Size = UDim2.new(0, 50, 0, 20)
            KeybindKey.Text = "NONE"
            KeybindKey.TextColor3 = Settings.MainColor
            KeybindKey.TextSize = 14
            KeybindKey.Name = "KeybindKey"
            KeybindKey.Parent = Keybind

            UICorner24.CornerRadius = UDim.new(0, 3)
            UICorner24.Parent = KeybindKey

            local Binding = false

            KeybindButton.MouseButton1Click:Connect(function()
                Binding = not Binding
                if Binding then
                    KeybindKey.Text = "..."
                else
                    KeybindKey.Text = "NONE"
                end
            end)

            UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
                if Binding and not gameProcessedEvent then
                    KeybindKey.Text = input.KeyCode.Name
                    CallBack(input.KeyCode)
                    Binding = false
                end
            end)
        end

        function SapphireHubLib:AddParagraph(Section, ParagraphName, ParagraphText)
            local Paragraph = Instance.new("Frame");
            local UICorner25 = Instance.new("UICorner");
            local ParagraphTitle = Instance.new("TextLabel");
            local ParagraphDescription = Instance.new("TextLabel");

            Paragraph.BackgroundColor3 = Settings.MainColor
            Paragraph.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Paragraph.BorderSizePixel = 0
            Paragraph.Size = UDim2.new(1, 0, 0, 60)
            Paragraph.Name = "Paragraph"
            Paragraph.Parent = Section

            EnterMouse(Paragraph)

            UICorner25.CornerRadius = UDim.new(0, 3)
            UICorner25.Parent = Paragraph

            ParagraphTitle.Font = Enum.Font.GothamBold
            ParagraphTitle.Text = Translation:Translate(ParagraphName)
            ParagraphTitle.TextColor3 = Settings.TextColor
            ParagraphTitle.TextSize = 14
            ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
            ParagraphTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ParagraphTitle.BackgroundTransparency = 1
            ParagraphTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ParagraphTitle.BorderSizePixel = 0
            ParagraphTitle.Position = UDim2.new(0, 10, 0, 0)
            ParagraphTitle.Size = UDim2.new(1, -10, 0.5, 0)
            ParagraphTitle.Name = "ParagraphTitle"
            ParagraphTitle.Parent = Paragraph

            ParagraphDescription.Font = Enum.Font.Gotham
            ParagraphDescription.Text = Translation:Translate(ParagraphText)
            ParagraphDescription.TextColor3 = Settings.DescriptionTextColor
            ParagraphDescription.TextSize = 12
            ParagraphDescription.TextWrapped = true
            ParagraphDescription.TextXAlignment = Enum.TextXAlignment.Left
            ParagraphDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ParagraphDescription.BackgroundTransparency = 1
            ParagraphDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
            ParagraphDescription.BorderSizePixel = 0
            ParagraphDescription.Position = UDim2.new(0, 10, 0.5, 0)
            ParagraphDescription.Size = UDim2.new(1, -20, 0.5, 0)
            ParagraphDescription.Name = "ParagraphDescription"
            ParagraphDescription.Parent = Paragraph
        end

        function SapphireHubLib:AddDivider(Section)
            local Divider = Instance.new("Frame");
            local UICorner26 = Instance.new("UICorner");

            Divider.BackgroundColor3 = Settings.TextColor
            Divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
            Divider.BorderSizePixel = 0
            Divider.Size = UDim2.new(1, -20, 0, 1)
            Divider.Name = "Divider"
            Divider.Parent = Section

            UICorner26.CornerRadius = UDim.new(0, 3)
            UICorner26.Parent = Divider
        end

        return Section
    end

    return SapphireHubLib
end

return SapphireHubLib
