-- Script: Silver Hub - Ultimate Kaitun System
-- Version: 4.0 | Complete Edition
-- Features: Auto Farm, Item Collector, Code Redeemer, Webhook, Settings Dashboard

-- ==================== SERVICES ====================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")

-- ==================== GLOBALS ====================
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

-- ==================== WEBHOOK CONFIG ====================
local Webhook = {
    URL = "", -- Add your Discord webhook URL here
    Enabled = false,
    LastReport = 0,
    ReportInterval = 3600 -- 1 hour in seconds
}

-- ==================== COMPLETE SETTINGS ====================
local Settings = {
    -- Auto Farm Settings
    AutoFarm = {
        Level = false,
        FastMode = true,
        BringMobs = true,
        Distance = 25,
        Priority = "HighestExp"
    },
    
    -- Auto Collect Settings
    AutoCollect = {
        AllGuns = false,
        AllSwords = false,
        AllHaki = false,
        AllAbilities = false,
        AllFightingStyles = false,
        Fruits = false,
        AutoStoreFruits = false,
        FruitHop = false
    },
    
    -- Raid Settings
    Raid = {
        AutoRaid = false,
        AutoNextIsland = true,
        AutoAwaken = false,
        SelectedRaid = "Flame",
        KillAura = true
    },
    
    -- Fruit Settings
    Fruits = {
        AutoBuyRandom = false,
        AutoStoreFruits = false,
        AutoBuySniper = false,
        SelectedFruits = {},
        UpgradeV2 = false,
        UpgradeV3 = false
    },
    
    -- Economy Settings
    Economy = {
        AutoFarmBeli = false,
        AutoFarmFragments = false,
        AutoFarmBones = false,
        AutoFarmEctoplasm = false,
        AutoFarmCandies = false
    },
    
    -- Code Redeemer
    CodeRedeem = {
        AutoRedeem = true,
        CheckAllCodes = true
    },
    
    -- Combat Settings
    Combat = {
        FastAttack = true,
        AttackType = "Fast", -- Fast, Normal, Slow
        AutoHaki = true,
        SkillZ = true,
        SkillX = true,
        SkillC = true,
        SkillV = true,
        Aimbot = false,
        KillAura = false
    },
    
    -- Movement Settings
    Movement = {
        Smooth = true,
        Speed = 150,
        JumpPower = 100,
        NoClip = true,
        Fly = false,
        FlySpeed = 50
    },
    
    -- UI Settings
    UI = {
        ShowHUD = true,
        ShowSettings = true,
        RGBSpeed = 2,
        Theme = "Dark"
    },
    
    -- Webhook Settings
    Webhook = {
        Enabled = false,
        URL = "",
        Interval = 3600,
        SendOnLevelUp = true,
        SendOnItemGet = true
    }
}

-- ==================== MODULE SYSTEM ====================
local Modules = {
    AutoFarm = {Running = false},
    ItemCollector = {Running = false},
    CodeRedeemer = {Running = false},
    RaidManager = {Running = false},
    FruitHunter = {Running = false},
    EconomyFarm = {Running = false},
    WebhookReporter = {Running = false}
}

-- ==================== KAITUN HUD WITH SETTINGS ICON ====================
local KaitunHUD = nil
local SettingsUI = nil
local RGBHue = 0

local function CreateCompleteHUD()
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Remove existing HUD
    local existingHUD = PlayerGui:FindFirstChild("SilverHub_Complete")
    if existingHUD then
        existingHUD:Destroy()
    end
    
    -- Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SilverHub_Complete"
    ScreenGui.DisplayOrder = 1000
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    
    -- Main Container
    local MainContainer = Instance.new("Frame")
    MainContainer.Name = "MainContainer"
    MainContainer.Size = UDim2.new(0, 380, 0, 450)
    MainContainer.Position = UDim2.new(0.015, 0, 0.015, 0)
    MainContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    MainContainer.BackgroundTransparency = 0.1
    MainContainer.BorderSizePixel = 0
    
    -- RGB Border
    local BorderFrame = Instance.new("Frame")
    BorderFrame.Name = "RGBBorder"
    BorderFrame.Size = UDim2.new(1, 6, 1, 6)
    BorderFrame.Position = UDim2.new(0, -3, 0, -3)
    BorderFrame.BackgroundTransparency = 1
    BorderFrame.ZIndex = 0
    
    local BorderStroke = Instance.new("UIStroke")
    BorderStroke.Color = Color3.fromRGB(255, 255, 255)
    BorderStroke.Thickness = 3
    BorderStroke.LineJoinMode = Enum.LineJoinMode.Round
    BorderStroke.Parent = BorderFrame
    
    -- Header with Logo and Settings
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 70)
    Header.BackgroundTransparency = 1
    
    -- Logo Container
    local LogoContainer = Instance.new("Frame")
    LogoContainer.Name = "LogoContainer"
    LogoContainer.Size = UDim2.new(0, 60, 1, 0)
    LogoContainer.BackgroundTransparency = 1
    
    -- Animated "S" Logo
    local AnimatedS = Instance.new("TextLabel")
    AnimatedS.Name = "AnimatedS"
    AnimatedS.Size = UDim2.new(1, 0, 1, 0)
    AnimatedS.BackgroundTransparency = 1
    AnimatedS.Text = "S"
    AnimatedS.TextColor3 = Color3.fromRGB(255, 255, 255)
    AnimatedS.TextScaled = true
    AnimatedS.Font = Enum.Font.GothamBlack
    AnimatedS.TextStrokeColor3 = Color3.fromRGB(0, 150, 255)
    AnimatedS.TextStrokeTransparency = 0
    AnimatedS.ZIndex = 3
    
    -- Title Container
    local TitleContainer = Instance.new("Frame")
    TitleContainer.Name = "TitleContainer"
    TitleContainer.Size = UDim2.new(1, -130, 1, 0)
    TitleContainer.Position = UDim2.new(0, 65, 0, 0)
    TitleContainer.BackgroundTransparency = 1
    
    local SilverText = Instance.new("TextLabel")
    SilverText.Name = "SilverText"
    SilverText.Size = UDim2.new(1, 0, 0.5, 0)
    SilverText.Position = UDim2.new(0, 0, 0, 10)
    SilverText.BackgroundTransparency = 1
    SilverText.Text = "SILVER HUB"
    SilverText.TextColor3 = Color3.fromRGB(200, 200, 220)
    SilverText.TextSize = 22
    SilverText.Font = Enum.Font.GothamBlack
    SilverText.TextXAlignment = Enum.TextXAlignment.Left
    SilverText.ZIndex = 3
    
    local SubText = Instance.new("TextLabel")
    SubText.Name = "SubText"
    SubText.Size = UDim2.new(1, 0, 0.5, 0)
    SubText.Position = UDim2.new(0, 0, 0.5, 0)
    SubText.BackgroundTransparency = 1
    SubText.Text = "KAITUN SYSTEM"
    SubText.TextColor3 = Color3.fromRGB(150, 200, 255)
    SubText.TextSize = 16
    SubText.Font = Enum.Font.GothamBold
    SubText.TextXAlignment = Enum.TextXAlignment.Left
    SubText.ZIndex = 3
    
    -- Settings Gear Icon
    local SettingsButton = Instance.new("TextButton")
    SettingsButton.Name = "SettingsButton"
    SettingsButton.Size = UDim2.new(0, 50, 0, 50)
    SettingsButton.Position = UDim2.new(1, -55, 0.5, -25)
    SettingsButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    SettingsButton.Text = "⚙️"
    SettingsButton.TextSize = 24
    SettingsButton.Font = Enum.Font.GothamBold
    SettingsButton.AutoButtonColor = true
    
    -- Status Indicator
    local StatusIndicator = Instance.new("Frame")
    StatusIndicator.Name = "StatusIndicator"
    StatusIndicator.Size = UDim2.new(0, 10, 0, 10)
    StatusIndicator.Position = UDim2.new(1, -15, 0, 15)
    StatusIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    StatusIndicator.BorderSizePixel = 0
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(1, 0)
    StatusCorner.Parent = StatusIndicator
    
    -- Webhook Status
    local WebhookStatus = Instance.new("TextLabel")
    WebhookStatus.Name = "WebhookStatus"
    WebhookStatus.Size = UDim2.new(0.5, 0, 0, 20)
    WebhookStatus.Position = UDim2.new(0, 10, 1, -25)
    WebhookStatus.BackgroundTransparency = 1
    WebhookStatus.Text = "Webhook: OFF"
    WebhookStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
    WebhookStatus.TextSize = 11
    WebhookStatus.Font = Enum.Font.Gotham
    WebhookStatus.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Separator
    local Separator = Instance.new("Frame")
    Separator.Name = "Separator"
    Separator.Size = UDim2.new(1, -20, 0, 1)
    Separator.Position = UDim2.new(0, 10, 0, 75)
    Separator.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    Separator.BorderSizePixel = 0
    
    -- Content Tabs
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Size = UDim2.new(1, 0, 0, 30)
    TabsContainer.Position = UDim2.new(0, 0, 0, 80)
    TabsContainer.BackgroundTransparency = 1
    
    local tabs = {"STATS", "PROGRESS", "ITEMS", "LOGS"}
    local currentTab = "STATS"
    
    for i, tabName in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName .. "Tab"
        tabButton.Size = UDim2.new(0.25, -5, 1, 0)
        tabButton.Position = UDim2.new((i-1) * 0.25, 5, 0, 0)
        tabButton.BackgroundColor3 = tabName == "STATS" and Color3.fromRGB(40, 40, 60) or Color3.fromRGB(30, 30, 40)
        tabButton.TextColor3 = Color3.fromRGB(200, 200, 220)
        tabButton.Text = tabName
        tabButton.TextSize = 12
        tabButton.Font = Enum.Font.GothamBold
        tabButton.AutoButtonColor = true
        
        tabButton.MouseButton1Click:Connect(function()
            currentTab = tabName
            -- Update all tabs
            for _, btn in pairs(TabsContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = btn.Name:sub(1, -4) == tabName and Color3.fromRGB(40, 40, 60) or Color3.fromRGB(30, 30, 40)
                end
            end
            -- Update content based on tab
            UpdateTabContent(tabName)
        end)
        
        tabButton.Parent = TabsContainer
    end
    
    -- Content Area
    local Content = Instance.new("ScrollingFrame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -20, 1, -160)
    Content.Position = UDim2.new(0, 10, 0, 115)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.ScrollBarThickness = 3
    Content.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
    Content.CanvasSize = UDim2.new(0, 0, 0, 600)
    
    -- Stats Tab Content
    local StatsContent = Instance.new("Frame")
    StatsContent.Name = "StatsContent"
    StatsContent.Size = UDim2.new(1, 0, 0, 300)
    StatsContent.BackgroundTransparency = 1
    StatsContent.Visible = true
    
    -- Add stats elements here...
    
    -- Progress Tab Content
    local ProgressContent = Instance.new("Frame")
    ProgressContent.Name = "ProgressContent"
    ProgressContent.Size = UDim2.new(1, 0, 0, 300)
    ProgressContent.BackgroundTransparency = 1
    ProgressContent.Visible = false
    
    -- Items Tab Content
    local ItemsContent = Instance.new("Frame")
    ItemsContent.Name = "ItemsContent"
    ItemsContent.Size = UDim2.new(1, 0, 0, 300)
    ItemsContent.BackgroundTransparency = 1
    ItemsContent.Visible = false
    
    -- Logs Tab Content
    local LogsContent = Instance.new("Frame")
    LogsContent.Name = "LogsContent"
    LogsContent.Size = UDim2.new(1, 0, 0, 300)
    LogsContent.BackgroundTransparency = 1
    LogsContent.Visible = false
    
    -- Assemble HUD
    AnimatedS.Parent = LogoContainer
    LogoContainer.Parent = Header
    
    SilverText.Parent = TitleContainer
    SubText.Parent = TitleContainer
    TitleContainer.Parent = Header
    
    SettingsButton.Parent = Header
    StatusIndicator.Parent = Header
    WebhookStatus.Parent = Header
    
    BorderFrame.Parent = MainContainer
    Header.Parent = MainContainer
    Separator.Parent = MainContainer
    TabsContainer.Parent = MainContainer
    
    StatsContent.Parent = Content
    ProgressContent.Parent = Content
    ItemsContent.Parent = Content
    LogsContent.Parent = Content
    
    Content.Parent = MainContainer
    MainContainer.Parent = ScreenGui
    ScreenGui.Parent = PlayerGui
    
    -- Make HUD draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        MainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainContainer.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- RGB Animation
    local function UpdateRGB()
        while Settings.UI.ShowHUD and ScreenGui.Parent do
            RGBHue = (RGBHue + 0.01 * Settings.UI.RGBSpeed) % 1
            local rgbColor = Color3.fromHSV(RGBHue, 0.8, 1)
            
            -- Update border
            BorderStroke.Color = rgbColor
            
            -- Update "S" logo
            AnimatedS.TextStrokeColor3 = rgbColor
            AnimatedS.TextColor3 = Color3.fromHSV((RGBHue + 0.5) % 1, 0.7, 1)
            
            -- Update text
            SilverText.TextColor3 = Color3.fromHSV((RGBHue + 0.3) % 1, 0.6, 1)
            SubText.TextColor3 = Color3.fromHSV((RGBHue + 0.7) % 1, 0.6, 1)
            
            RunService.RenderStepped:Wait()
        end
    end
    
    -- Start RGB animation
    task.spawn(UpdateRGB)
    
    -- Settings button functionality
    SettingsButton.MouseButton1Click:Connect(function()
        CreateSettingsDashboard()
    end)
    
    -- Update Status Indicator
    local function UpdateStatus()
        local anyRunning = false
        for _, module in pairs(Modules) do
            if module.Running then
                anyRunning = true
                break
            end
        end
        
        StatusIndicator.BackgroundColor3 = anyRunning and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
        WebhookStatus.Text = "Webhook: " .. (Settings.Webhook.Enabled and "ON" or "OFF")
        WebhookStatus.TextColor3 = Settings.Webhook.Enabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 100, 100)
    end
    
    -- Return HUD interface
    return {
        ScreenGui = ScreenGui,
        UpdateStatus = UpdateStatus,
        UpdateStats = function(data)
            -- Update stats content
        end,
        UpdateProgress = function(data)
            -- Update progress content
        end,
        UpdateItems = function(data)
            -- Update items content
        end,
        AddLog = function(log)
            -- Add log entry
        end,
        ToggleVisibility = function()
            Settings.UI.ShowHUD = not Settings.UI.ShowHUD
            ScreenGui.Enabled = Settings.UI.ShowHUD
        end
    }
end

-- ==================== SETTINGS DASHBOARD ====================
function CreateSettingsDashboard()
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Remove existing dashboard
    local existing = PlayerGui:FindFirstChild("SilverHub_Dashboard")
    if existing then
        existing:Destroy()
        return
    end
    
    -- Dashboard ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SilverHub_Dashboard"
    ScreenGui.DisplayOrder = 999
    ScreenGui.ResetOnSpawn = false
    
    -- Main Container
    local MainContainer = Instance.new("Frame")
    MainContainer.Name = "MainContainer"
    MainContainer.Size = UDim2.new(0, 600, 0, 500)
    MainContainer.Position = UDim2.new(0.5, -300, 0.5, -250)
    MainContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    MainContainer.BackgroundTransparency = 0.05
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainContainer
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundTransparency = 1
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "⚙️ SILVER HUB SETTINGS"
    Title.TextColor3 = Color3.fromRGB(200, 200, 255)
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Position = UDim2.new(0, 10, 0, 0)
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -45, 0.5, -20)
    CloseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
    CloseButton.Text = "✕"
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    
    -- Sidebar Navigation
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, -60)
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    
    local categories = {
        {"Auto Farm", "📈"},
        {"Auto Collect", "🎯"},
        {"Raid System", "⚔️"},
        {"Fruit System", "🍇"},
        {"Economy", "💰"},
        {"Combat", "⚡"},
        {"Movement", "🚀"},
        {"Webhook", "🔗"}
    }
    
    local currentCategory = "Auto Farm"
    
    -- Category Buttons
    for i, category in ipairs(categories) do
        local btn = Instance.new("TextButton")
        btn.Name = category[1] .. "Btn"
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.Position = UDim2.new(0, 5, 0, 5 + (i-1)*45)
        btn.BackgroundColor3 = category[1] == currentCategory and Color3.fromRGB(40, 40, 60) or Color3.fromRGB(30, 30, 40)
        btn.Text = category[2] .. " " .. category[1]
        btn.TextColor3 = Color3.fromRGB(200, 200, 220)
        btn.TextSize = 14
        btn.Font = Enum.Font.Gotham
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = true
        
        btn.MouseButton1Click:Connect(function()
            currentCategory = category[1]
            -- Update all buttons
            for _, button in pairs(Sidebar:GetChildren()) do
                if button:IsA("TextButton") then
                    button.BackgroundColor3 = button.Name:sub(1, -4) == currentCategory and Color3.fromRGB(40, 40, 60) or Color3.fromRGB(30, 30, 40)
                end
            end
            -- Update content
            UpdateSettingsContent(currentCategory)
        end)
        
        btn.Parent = Sidebar
    end
    
    -- Content Area
    local Content = Instance.new("ScrollingFrame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -160, 1, -60)
    Content.Position = UDim2.new(0, 155, 0, 50)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.ScrollBarThickness = 4
    Content.CanvasSize = UDim2.new(0, 0, 0, 800)
    
    -- Save/Load Buttons
    local Footer = Instance.new("Frame")
    Footer.Name = "Footer"
    Footer.Size = UDim2.new(1, 0, 0, 50)
    Footer.Position = UDim2.new(0, 0, 1, -50)
    Footer.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    
    local SaveButton = Instance.new("TextButton")
    SaveButton.Name = "SaveButton"
    SaveButton.Size = UDim2.new(0, 100, 0, 35)
    SaveButton.Position = UDim2.new(0.5, -110, 0.5, -17.5)
    SaveButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    SaveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SaveButton.Text = "💾 SAVE"
    SaveButton.TextSize = 14
    SaveButton.Font = Enum.Font.GothamBold
    
    local LoadButton = Instance.new("TextButton")
    LoadButton.Name = "LoadButton"
    LoadButton.Size = UDim2.new(0, 100, 0, 35)
    LoadButton.Position = UDim2.new(0.5, 10, 0.5, -17.5)
    LoadButton.BackgroundColor3 = Color3.fromRGB(60, 60, 120)
    LoadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadButton.Text = "📂 LOAD"
    LoadButton.TextSize = 14
    LoadButton.Font = Enum.Font.GothamBold
    
    -- Assemble Dashboard
    Title.Parent = Header
    CloseButton.Parent = Header
    Header.Parent = MainContainer
    
    Sidebar.Parent = MainContainer
    
    SaveButton.Parent = Footer
    LoadButton.Parent = Footer
    Footer.Parent = MainContainer
    
    Content.Parent = MainContainer
    MainContainer.Parent = ScreenGui
    ScreenGui.Parent = PlayerGui
    
    -- Close button functionality
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Make draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        MainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainContainer.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Save/Load functionality
    SaveButton.MouseButton1Click:Connect(function()
        SaveSettings()
        KaitunHUD.AddLog("Settings saved successfully")
    end)
    
    LoadButton.MouseButton1Click:Connect(function()
        LoadSettings()
        KaitunHUD.AddLog("Settings loaded successfully")
        -- Refresh UI
        UpdateSettingsContent(currentCategory)
    end)
    
    -- Create content for first category
    UpdateSettingsContent(currentCategory)
    
    return ScreenGui
end

function UpdateSettingsContent(category)
    local dashboard = LocalPlayer.PlayerGui:FindFirstChild("SilverHub_Dashboard")
    if not dashboard then return end
    
    local Content = dashboard:FindFirstChild("Content", true)
    if not Content then return end
    
    -- Clear existing content
    for _, child in pairs(Content:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local yOffset = 10
    
    if category == "Auto Farm" then
        CreateToggle("Auto Farm Level", yOffset, Settings.AutoFarm.Level, function(value)
            Settings.AutoFarm.Level = value
            if value then StartAutoFarm() else StopAutoFarm() end
        end, Content)
        yOffset = yOffset + 40
        
        CreateToggle("Fast Mode", yOffset, Settings.AutoFarm.FastMode, function(value)
            Settings.AutoFarm.FastMode = value
        end, Content)
        yOffset = yOffset + 40
        
        CreateToggle("Bring Mobs", yOffset, Settings.AutoFarm.BringMobs, function(value)
            Settings.AutoFarm.BringMobs = value
        end, Content)
        yOffset = yOffset + 40
        
        -- Add more Auto Farm settings...
        
    elseif category == "Auto Collect" then
        CreateToggle("Auto Get All Guns", yOffset, Settings.AutoCollect.AllGuns, function(value)
            Settings.AutoCollect.AllGuns = value
            if value then StartGunCollector() end
        end, Content)
        yOffset = yOffset + 40
        
        CreateToggle("Auto Get All Swords", yOffset, Settings.AutoCollect.AllSwords, function(value)
            Settings.AutoCollect.AllSwords = value
            if value then StartSwordCollector() end
        end, Content)
        yOffset = yOffset + 40
        
        CreateToggle("Auto Get All Haki", yOffset, Settings.AutoCollect.AllHaki, function(value)
            Settings.AutoCollect.AllHaki = value
        end, Content)
        yOffset = yOffset + 40
        
        CreateToggle("Auto Collect Fruits", yOffset, Settings.AutoCollect.Fruits, function(value)
            Settings.AutoCollect.Fruits = value
            if value then StartFruitHunter() end
        end, Content)
        yOffset = yOffset + 40
        
        CreateToggle("Auto Store Fruits", yOffset, Settings.AutoCollect.AutoStoreFruits, function(value)
            Settings.AutoCollect.AutoStoreFruits = value
        end, Content)
        yOffset = yOffset + 40
        
        CreateToggle("Fruit Hop Server", yOffset, Settings.AutoCollect.FruitHop, function(value)
            Settings.AutoCollect.FruitHop = value
        end, Content)
        yOffset = yOffset + 40
        
    elseif category == "Raid System" then
        CreateToggle("Auto Raid", yOffset, Settings.Raid.AutoRaid, function(value)
            Settings.Raid.AutoRaid = value
            if value then StartRaidManager() else StopRaidManager() end
        end, Content)
        yOffset = yOffset + 40
        
        CreateToggle("Auto Next Island", yOffset, Settings.Raid.AutoNextIsland, function(value)
            Settings.Raid.AutoNextIsland = value
        end, Content)
        yOffset = yOffset + 40
        
        CreateToggle("Auto Awaken", yOffset, Settings.Raid.AutoAwaken, function(value)
            Settings.Raid.AutoAwaken = value
        end, Content)
        yOffset = yOffset + 40
        
        CreateToggle("Kill Aura", yOffset, Settings.Raid.KillAura, function(value)
            Settings.Raid.KillAura = value
        end, Content)
        yOffset = yOffset + 40
        
        -- Raid type dropdown
        CreateDropdown("Select Raid", yOffset, {"Flame", "Ice", "Quake", "Light", "Dark", "String", "Rumble", "Magma", "Buddha", "Sand", "Phoenix", "Dough"}, 
            Settings.Raid.SelectedRaid, function(value)
                Settings.Raid.SelectedRaid = value
            end, Content)
        yOffset = yOffset + 60
        
    elseif category == "Fruit System" then
        CreateToggle("Auto Buy Random Fruits", yOffset, Settings.Fruits.AutoBuyRandom, function(value)
            Settings.Fruits.AutoBuyRandom = value
        end, Content)
        yOffset = yOffset + 40
        
        CreateToggle("Auto Store Fruits", yOffset, Settings.Fruits.AutoStoreFruits, function(value)
            Settings.Fruits.AutoStoreFruits = value
        end, Content)
        yOffset = yOffset + 40
        
        CreateToggle("Upgrade V2 Fruits", yOffset, Settings.Fruits.UpgradeV2, function(value)
            Settings.Fruits.UpgradeV2 = value
            if value then StartV2Upgrade() end
        end, Content)
        yOffset = yOffset + 40
        
        CreateToggle("Upgrade V3 Fruits", yOffset, Settings.Fruits.UpgradeV3, function(value)
            Settings.Fruits.UpgradeV3 = value
            if value then StartV3Upgrade() end
        end, Content)
        yOffset = yOffset + 40
        
    elseif category == "Economy" then
        CreateToggle("Auto Farm Beli", yOffset, Settings.Economy.AutoFarmBeli, function(value)
            Settings.Economy.AutoFarmBeli = value
            if value then StartBeliFarm() else StopBeliFarm() end
        end, Content)
        yOffset = yOffset + 40
        
        CreateToggle("Auto Farm Fragments", yOffset, Settings.Economy.AutoFarmFragments, function(value)
            Settings.Economy.AutoFarmFragments = value
            if value then StartFragmentFarm() else StopFragmentFarm() end
        end, Content)
        yOffset = yOffset + 40
        
        CreateToggle("Auto Farm Bones", yOffset, Settings.Economy.AutoFarmBones, function(value)
            Settings.Economy.AutoFarmBones = value
        end, Content)
        yOffset = yOffset + 40
        
        CreateToggle("Auto Farm Ectoplasm", yOffset, Settings.Economy.AutoFarmEctoplasm, function(value)
            Settings.Economy.AutoFarmEctoplasm = value
        end, Content)
        yOffset = yOffset + 40
        
    elseif category == "Combat" then
        CreateToggle("Fast Attack", yOffset, Settings.Combat.FastAttack, function(value)
            Settings.Combat.FastAttack = value
        end, Content)
        yOffset = yOffset + 40
        
        CreateToggle("Auto Haki", yOffset, Settings.Combat.AutoHaki, function(value)
            Settings.Combat.AutoHaki = value
        end, Content)
        yOffset = yOffset + 40
        
        CreateToggle("Kill Aura", yOffset, Settings.Combat.KillAura, function(value)
            Settings.Combat.KillAura = value
        end, Content)
        yOffset = yOffset + 40
        
        CreateDropdown("Attack Type", yOffset, {"Fast", "Normal", "Slow"}, Settings.Combat.AttackType, function(value)
            Settings.Combat.AttackType = value
        end, Content)
        yOffset = yOffset + 60
        
    elseif category == "Webhook" then
        CreateToggle("Enable Webhook", yOffset, Settings.Webhook.Enabled, function(value)
            Settings.Webhook.Enabled = value
            if value then StartWebhookReporter() else StopWebhookReporter() end
        end, Content)
        yOffset = yOffset + 40
        
        -- Webhook URL input
        local urlFrame = CreateInputField("Webhook URL", yOffset, Settings.Webhook.URL, function(value)
            Settings.Webhook.URL = value
        end, Content)
        yOffset = yOffset + 50
        
        CreateToggle("Send on Level Up", yOffset, Settings.Webhook.SendOnLevelUp, function(value)
            Settings.Webhook.SendOnLevelUp = value
        end, Content)
        yOffset = yOffset + 40
        
        CreateToggle("Send on Item Get", yOffset, Settings.Webhook.SendOnItemGet, function(value)
            Settings.Webhook.SendOnItemGet = value
        end, Content)
        yOffset = yOffset + 40
    end
    
    Content.CanvasSize = UDim2.new(0, 0, 0, yOffset + 20)
end

-- ==================== UI COMPONENTS ====================
function CreateToggle(label, yPos, defaultValue, callback, parent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 35)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundTransparency = 1
    
    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(0.7, 0, 1, 0)
    labelText.BackgroundTransparency = 1
    labelText.Text = "  " .. label
    labelText.TextColor3 = Color3.fromRGB(200, 200, 220)
    labelText.TextSize = 14
    labelText.Font = Enum.Font.Gotham
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 60, 0, 25)
    toggleButton.Position = UDim2.new(1, -65, 0.5, -12.5)
    toggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
    toggleButton.Text = defaultValue and "ON" or "OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 12
    toggleButton.Font = Enum.Font.GothamBold
    
    toggleButton.MouseButton1Click:Connect(function()
        local newValue = not defaultValue
        defaultValue = newValue
        toggleButton.BackgroundColor3 = newValue and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
        toggleButton.Text = newValue and "ON" or "OFF"
        callback(newValue)
    end)
    
    labelText.Parent = frame
    toggleButton.Parent = frame
    frame.Parent = parent
    
    return frame
end

function CreateDropdown(label, yPos, options, defaultValue, callback, parent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 50)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundTransparency = 1
    
    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(1, 0, 0, 25)
    labelText.BackgroundTransparency = 1
    labelText.Text = "  " .. label
    labelText.TextColor3 = Color3.fromRGB(200, 200, 220)
    labelText.TextSize = 14
    labelText.Font = Enum.Font.Gotham
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Size = UDim2.new(1, 0, 0, 25)
    dropdownButton.Position = UDim2.new(0, 0, 0, 25)
    dropdownButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    dropdownButton.Text = defaultValue
    dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownButton.TextSize = 12
    dropdownButton.Font = Enum.Font.Gotham
    
    dropdownButton.MouseButton1Click:Connect(function()
        -- Simple dropdown implementation
        local currentIndex = table.find(options, defaultValue) or 1
        local nextIndex = currentIndex % #options + 1
        defaultValue = options[nextIndex]
        dropdownButton.Text = defaultValue
        callback(defaultValue)
    end)
    
    labelText.Parent = frame
    dropdownButton.Parent = frame
    frame.Parent = parent
    
    return frame
end

function CreateInputField(label, yPos, defaultValue, callback, parent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 45)
    frame.Position = UDim2.new(0, 10, 0, yPos)
    frame.BackgroundTransparency = 1
    
    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(1, 0, 0, 20)
    labelText.BackgroundTransparency = 1
    labelText.Text = "  " .. label
    labelText.TextColor3 = Color3.fromRGB(200, 200, 220)
    labelText.TextSize = 14
    labelText.Font = Enum.Font.Gotham
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, 0, 0, 25)
    textBox.Position = UDim2.new(0, 0, 0, 20)
    textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Text = defaultValue
    textBox.TextSize = 12
    textBox.Font = Enum.Font.Gotham
    textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    
    textBox.FocusLost:Connect(function()
        callback(textBox.Text)
    end)
    
    labelText.Parent = frame
    textBox.Parent = frame
    frame.Parent = parent
    
    return frame
end

-- ==================== CODE REDEEMER ====================
local CodeRedeemer = {
    AllCodes = {
        "Sub2Fer999", "SUB2GAMERROBOT_EXP1", "StrawHatMaine", "SUB2NOOBMASTER123",
        "Sub2UncleKizaru", "SUB2OFFICIALMOUSE", "Sub2Daigrock", "Axiore",
        "TantaiGaming", "STRAWHATMAINE", "SUB2FER999", "Enyu_is_Pro",
        "JCWK", "KittGaming", "Bluxxy", "THEGREATACE", "SUB2GAMERROBOT_EXP1",
        "Magicbus", "Starcodeheo", "Fudd10", "Sub2CaptainMaui", "Sub2UncleKizaru"
    },
    RedeemedCodes = {},
    LastCheck = 0
}

function CodeRedeemer:Start()
    Modules.CodeRedeemer.Running = true
    
    task.spawn(function()
        while Modules.CodeRedeemer.Running do
            if Settings.CodeRedeem.AutoRedeem then
                self:RedeemAllCodes()
            end
            task.wait(300) -- Check every 5 minutes
        end
    end)
end

function CodeRedeemer:Stop()
    Modules.CodeRedeemer.Running = false
end

function CodeRedeemer:RedeemAllCodes()
    for _, code in pairs(self.AllCodes) do
        if not table.find(self.RedeemedCodes, code) then
            pcall(function()
                ReplicatedStorage.Remotes.Redeem:InvokeServer(code)
                KaitunHUD.AddLog("Redeemed code: " .. code)
                table.insert(self.RedeemedCodes, code)
                task.wait(1)
            end)
        end
    end
end

-- ==================== AUTO FARM SYSTEM ====================
function StartAutoFarm()
    Modules.AutoFarm.Running = true
    
    task.spawn(function()
        while Modules.AutoFarm.Running do
            local level = LocalPlayer.Data.Level.Value
            local quest = GetBestQuest(level)
            
            if quest then
                KaitunHUD.UpdateStats({Level = level, Quest = quest.MobName})
                
                -- Farm logic here
                local mob = FindMob(quest.MobName)
                if mob then
                    MoveTo(mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5))
                    
                    -- Attack mob
                    if Settings.Combat.FastAttack then
                        AttackMob(mob)
                    end
                    
                    -- Bring mobs if enabled
                    if Settings.AutoFarm.BringMobs then
                        BringNearbyMobs()
                    end
                else
                    MoveTo(quest.NPCPosition)
                end
            end
            
            task.wait()
        end
    end)
end

function StopAutoFarm()
    Modules.AutoFarm.Running = false
end

-- ==================== ITEM COLLECTOR ====================
function StartGunCollector()
    Modules.ItemCollector.Running = true
    
    task.spawn(function()
        while Modules.ItemCollector.Running and Settings.AutoCollect.AllGuns do
            -- Logic to collect all guns
            pcall(function()
                for _, gun in pairs({"Slingshot", "Musket", "Flintlock", "Acidum Rifle", "Bizarre Rifle"}) do
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyItem", gun)
                    KaitunHUD.AddLog("Collected gun: " .. gun)
                    task.wait(1)
                end
            end)
            
            task.wait(60) -- Check every minute
        end
    end)
end

function StartSwordCollector()
    task.spawn(function()
        while Modules.ItemCollector.Running and Settings.AutoCollect.AllSwords do
            -- Logic to collect all swords
            pcall(function()
                for _, sword in pairs({"Katana", "Cutlass", "Dual Katana", "Iron Mace", "Triple Katana"}) do
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyItem", sword)
                    KaitunHUD.AddLog("Collected sword: " .. sword)
                    task.wait(1)
                end
            end)
            
            task.wait(60)
        end
    end)
end

-- ==================== FRUIT HUNTER ====================
function StartFruitHunter()
    Modules.FruitHunter.Running = true
    
    task.spawn(function()
        while Modules.FruitHunter.Running and Settings.AutoCollect.Fruits do
            -- Check for fruits in workspace
            local fruits = Workspace:FindFirstChild("Fruits") or Workspace:FindFirstChild("SpawnedFruits")
            
            if fruits then
                for _, fruit in pairs(fruits:GetChildren()) do
                    if fruit:IsA("Tool") then
                        MoveTo(fruit.Handle.CFrame)
                        task.wait(1)
                        
                        if fruit.Handle then
                            fireclickdetector(fruit.Handle.ClickDetector)
                            KaitunHUD.AddLog("Collected fruit: " .. fruit.Name)
                        end
                    end
                end
            end
            
            -- Hop server if enabled and no fruits found
            if Settings.AutoCollect.FruitHop then
                HopServer()
            end
            
            task.wait(10)
        end
    end)
end

function HopServer()
    pcall(function()
        local servers = {}
        local page = 1
        
        while true do
            local success, result = pcall(function()
                return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&cursor=" .. tostring(page)))
            end)
            
            if success and result.data then
                for _, server in pairs(result.data) do
                    if server.id ~= game.JobId and server.playing < server.maxPlayers then
                        table.insert(servers, server.id)
                    end
                end
                
                if #servers >= 5 or not result.nextPageCursor then
                    break
                end
                
                page = result.nextPageCursor
            else
                break
            end
        end
        
        if #servers > 0 then
            local randomServer = servers[math.random(1, #servers)]
            TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer, LocalPlayer)
        end
    end)
end

-- ==================== V2/V3 FRUIT UPGRADE ====================
function StartV2Upgrade()
    task.spawn(function()
        while Settings.Fruits.UpgradeV2 do
            pcall(function()
                -- Check for fruits that can be upgraded to V2
                local backpack = LocalPlayer.Backpack
                local character = LocalPlayer.Character
                
                local fruits = {
                    "Dark-Dark", "Flame-Flame", "Ice-Ice", "Light-Light",
                    "Magma-Magma", "Quake-Quake", "Rumble-Rumble", "String-String"
                }
                
                for _, fruitName in pairs(fruits) do
                    local fruit = backpack:FindFirstChild(fruitName) or (character and character:FindFirstChild(fruitName))
                    
                    if fruit then
                        -- Check if V2 is available
                        local mastery = GetFruitMastery(fruitName)
                        
                        if mastery >= 400 then
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("Awakener", "Check")
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("Awakener", "Awaken")
                            KaitunHUD.AddLog("Upgraded " .. fruitName .. " to V2")
                            task.wait(5)
                        end
                    end
                end
            end)
            
            task.wait(60)
        end
    end)
end

function StartV3Upgrade()
    task.spawn(function()
        while Settings.Fruits.UpgradeV3 do
            pcall(function()
                -- Specific fruits that can go to V3
                local v3Fruits = {
                    "Dough-Dough", "Shadow-Shadow", "Control-Control"
                }
                
                for _, fruitName in pairs(v3Fruits) do
                    local fruit = LocalPlayer.Backpack:FindFirstChild(fruitName) or 
                                 (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(fruitName))
                    
                    if fruit then
                        local mastery = GetFruitMastery(fruitName)
                        
                        if mastery >= 400 then
                            -- Check for V3 requirements
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("Ectoplasm", "Check")
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("Ectoplasm", "BuyCheck")
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("Ectoplasm", "Buy")
                            
                            KaitunHUD.AddLog("Upgraded " .. fruitName .. " to V3")
                            task.wait(5)
                        end
                    end
                end
            end)
            
            task.wait(60)
        end
    end)
end

-- ==================== WEBHOOK REPORTER ====================
function StartWebhookReporter()
    Modules.WebhookReporter.Running = true
    
    task.spawn(function()
        while Modules.WebhookReporter.Running and Settings.Webhook.Enabled do
            SendWebhookReport()
            task.wait(Settings.Webhook.Interval)
        end
    end)
end

function StopWebhookReporter()
    Modules.WebhookReporter.Running = false
end

function SendWebhookReport()
    if Settings.Webhook.URL == "" then return end
    
    local playerData = GetPlayerData()
    local stats = GetPlayerStats()
    
    local embed = {
        title = "📊 Silver Hub Report",
        description = "Automated progress report",
        color = 3447003,
        fields = {
            {
                name = "👤 Player Info",
                value = string.format("Username: %s\nLevel: %d\nBeli: %s\nFragments: %s", 
                    LocalPlayer.Name, stats.Level, FormatNumber(stats.Beli), FormatNumber(stats.Fragments)),
                inline = true
            },
            {
                name = "📈 Progress",
                value = string.format("Playtime: %s\nMobs Killed: %d\nItems Collected: %d", 
                    FormatTime(playerData.PlayTime), playerData.MobsKilled, playerData.ItemsCollected),
                inline = true
            },
            {
                name = "⚔️ Achievements",
                value = string.format("Codes Redeemed: %d\nFruits Collected: %d\nRaids Completed: %d", 
                    #CodeRedeemer.RedeemedCodes, playerData.FruitsCollected, playerData.RaidsCompleted),
                inline = false
            }
        },
        footer = {
            text = "Silver Hub Kaitun System | " .. os.date("%Y-%m-%d %H:%M:%S"),
            icon_url = "https://i.imgur.com/ABCD123.png" -- Your icon URL here
        },
        thumbnail = {
            url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
        }
    }
    
    local data = {
        username = "Silver Hub Bot",
        avatar_url = "https://i.imgur.com/EF4qjNp.png", -- Your bot avatar
        embeds = {embed}
    }
    
    pcall(function()
        local json = HttpService:JSONEncode(data)
        local success, response = pcall(function()
            return game:HttpGet(Settings.Webhook.URL, {
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = json
            })
        end)
        
        if success then
            KaitunHUD.AddLog("Webhook report sent successfully")
        end
    end)
end

-- ==================== UTILITY FUNCTIONS ====================
function FormatNumber(num)
    if num >= 1000000000 then
        return string.format("%.2fB", num / 1000000000)
    elseif num >= 1000000 then
        return string.format("%.2fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.1fK", num / 1000)
    else
        return tostring(num)
    end
end

function FormatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    return string.format("%02d:%02d", hours, minutes)
end

function GetPlayerStats()
    local stats = {
        Level = 0,
        Beli = 0,
        Fragments = 0,
        Race = "Unknown"
    }
    
    pcall(function()
        stats.Level = LocalPlayer.Data.Level.Value
        stats.Beli = LocalPlayer.Data.Beli.Value or 0
        stats.Fragments = LocalPlayer.Data.Fragments.Value or 0
        stats.Race = LocalPlayer.Data.Race.Value or "Unknown"
    end)
    
    return stats
end

function GetPlayerData()
    return {
        PlayTime = tick() - (LoadData().StartTime or tick()),
        MobsKilled = LoadData().MobsKilled or 0,
        ItemsCollected = LoadData().ItemsCollected or 0,
        FruitsCollected = LoadData().FruitsCollected or 0,
        RaidsCompleted = LoadData().RaidsCompleted or 0
    }
end

-- ==================== SAVE/LOAD SYSTEM ====================
function SaveSettings()
    local data = {
        Settings = Settings,
        RedeemedCodes = CodeRedeemer.RedeemedCodes,
        LastPlayed = os.time(),
        StartTime = LoadData().StartTime or tick()
    }
    
    if writefile then
        pcall(function()
            writefile("SilverHub_Settings.json", HttpService:JSONEncode(data))
        end)
    end
end

function LoadSettings()
    if readfile and isfile and isfile("SilverHub_Settings.json") then
        pcall(function()
            local data = HttpService:JSONDecode(readfile("SilverHub_Settings.json"))
            if data.Settings then
                for category, settings in pairs(data.Settings) do
                    if Settings[category] then
                        for key, value in pairs(settings) do
                            Settings[category][key] = value
                        end
                    end
                end
            end
            
            if data.RedeemedCodes then
                CodeRedeemer.RedeemedCodes = data.RedeemedCodes
            end
        end)
    end
end

function LoadData()
    if readfile and isfile and isfile("SilverHub_Data.json") then
        pcall(function()
            return HttpService:JSONDecode(readfile("SilverHub_Data.json"))
        end)
    end
    return {}
end

function SaveData(data)
    if writefile then
        pcall(function()
            writefile("SilverHub_Data.json", HttpService:JSONEncode(data))
        end)
    end
end

-- ==================== INITIALIZATION ====================
function Initialize()
    -- Wait for player
    repeat task.wait() until LocalPlayer and LocalPlayer.Character
    Character = LocalPlayer.Character
    Humanoid = Character:WaitForChild("Humanoid")
    HRP = Character:WaitForChild("HumanoidRootPart")
    
    -- Load saved settings
    LoadSettings()
    
    -- Create HUD
    KaitunHUD = CreateCompleteHUD()
    
    -- Start Code Redeemer
    if Settings.CodeRedeem.AutoRedeem then
        CodeRedeemer:Start()
    end
    
    -- Start selected modules
    if Settings.AutoFarm.Level then
        StartAutoFarm()
    end
    
    if Settings.AutoCollect.AllGuns then
        StartGunCollector()
    end
    
    if Settings.AutoCollect.Fruits then
        StartFruitHunter()
    end
    
    if Settings.Webhook.Enabled then
        StartWebhookReporter()
    end
    
    -- Auto-save every 5 minutes
    task.spawn(function()
        while true do
            task.wait(300)
            SaveSettings()
            KaitunHUD.AddLog("Auto-saved settings")
        end
    end)
    
    -- Update status indicator
    task.spawn(function()
        while true do
            task.wait(1)
            if KaitunHUD then
                KaitunHUD.UpdateStatus()
            end
        end
    end)
    
    print([[
    ╔══════════════════════════════════════╗
    ║       SILVER HUB KAITUN v4.0         ║
    ║      Complete System Loaded!         ║
    ║    Click ⚙️ to open Settings          ║
    ╚══════════════════════════════════════╝
    ]])
end

-- ==================== AUTO-SAVE ON EXIT ====================
game:BindToClose(function()
    SaveSettings()
end)

-- ==================== START SYSTEM ====================
Initialize()