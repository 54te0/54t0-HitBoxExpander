--[[
    ███████╗ █████╗ ████████╗███████╗    ██╗   ██╗██╗
    ██╔════╝██╔══██╗╚══██╔══╝██╔════╝    ██║   ██║██║
    █████╗  ███████║   ██║   █████╗      ██║   ██║██║
    ██╔══╝  ██╔══██║   ██║   ██╔══╝      ██║   ██║██║
    ██║     ██║  ██║   ██║   ███████╗    ╚██████╔╝██║
    ╚═╝     ╚═╝  ╚═╝   ╚═╝   ╚══════╝     ╚═════╝ ╚═╝

    FateUI - Roblox UI Library
    Style: Cyan Cyberpunk (matches original HTML UI)
    Made by ! 54t0  |  @Trazadev
    Version: 2.1

    ==============================
    HOW DEVELOPERS USE THIS:
    ==============================

    local FateUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/54te0/FaitUI/refs/heads/(root)/FateUI_Library.lua"))()

    local Window = FateUI:CreateWindow({
        Title = "My Script",
        SubTitle = "Traza's Private Edition",
    })

    local Tab = Window:CreateTab("Home")
    local Tab2 = Window:CreateTab("Player")

    Tab:CreateSection("Configuration")

    Tab:CreateToggle({
        Name = "My Toggle",
        Description = "Does something cool",
        Default = false,
        Callback = function(state)
            print("Toggle:", state)
        end
    })

    Tab:CreateSlider({
        Name = "My Slider",
        Min = 1,
        Max = 100,
        Default = 50,
        Callback = function(value)
            print("Value:", value)
        end
    })

    Tab:CreateButton({
        Name = "My Button",
        Callback = function()
            print("Clicked!")
        end
    })

    Tab:CreateInput({
        Name = "My Input",
        Placeholder = "Type here...",
        Callback = function(text)
            print("Text:", text)
        end
    })

    Tab:CreateKeybind({
        Name = "Toggle UI",
        Default = Enum.KeyCode.F,
        Callback = function()
            print("Key pressed!")
        end
    })

    FateUI:Notify({
        Title = "Loaded!",
        Message = "Script is ready.",
        Duration = 4,
    })
]]

-- =====================
--    SERVICES
-- =====================
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")
local LocalPlayer      = Players.LocalPlayer

-- =====================
--    LIBRARY TABLE
-- =====================
local FateUI = {}
FateUI.__index = FateUI

-- =====================
--    THEME
--    Matches the cyan cyberpunk HTML UI exactly
-- =====================
FateUI.Theme = {
    BG         = Color3.fromRGB(8,  13, 20),   -- Deep dark navy
    Surface    = Color3.fromRGB(11, 17, 26),   -- Slightly lighter
    Card       = Color3.fromRGB(14, 22, 32),   -- Card bg
    CardHover  = Color3.fromRGB(18, 28, 40),   -- Hover state
    Border     = Color3.fromRGB(0,  140, 180), -- Cyan border
    BorderDim  = Color3.fromRGB(15, 35, 50),   -- Dim border
    Accent     = Color3.fromRGB(0,  200, 255), -- Cyan accent
    AccentDim  = Color3.fromRGB(0,  80,  110), -- Dim accent
    AccentSoft = Color3.fromRGB(0,  30,  45),  -- Soft accent bg
    Text       = Color3.fromRGB(190, 220, 235),-- Main text
    Muted      = Color3.fromRGB(80, 110, 130), -- Muted text
    Muted2     = Color3.fromRGB(35, 55,  70),  -- Very muted
    Success    = Color3.fromRGB(100, 230, 50), -- Green for active
    Warning    = Color3.fromRGB(255, 184, 0),  -- Yellow warning
    White      = Color3.fromRGB(255, 255, 255),
    Black      = Color3.fromRGB(0,   0,   0),
}

-- =====================
--    HELPERS
-- =====================
local function New(class, props)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    return o
end

local function Tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad), props):Play()
end

local function Corner(r, p)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 4)
    c.Parent = p
end

local function Stroke(col, thick, trans, p)
    local s = Instance.new("UIStroke")
    s.Color = col
    s.Thickness = thick or 1
    s.Transparency = trans or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    return s
end

local function Pad(t, b, l, r, p)
    local u = Instance.new("UIPadding")
    u.PaddingTop    = UDim.new(0, t or 0)
    u.PaddingBottom = UDim.new(0, b or 0)
    u.PaddingLeft   = UDim.new(0, l or 0)
    u.PaddingRight  = UDim.new(0, r or 0)
    u.Parent = p
end

local function List(p, gap, dir)
    local l = Instance.new("UIListLayout")
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Padding = UDim.new(0, gap or 0)
    if dir then l.FillDirection = dir end
    l.Parent = p
    return l
end

local function HLine(parent, yPos)
    return New("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, yPos or 0),
        BackgroundColor3 = FateUI.Theme.BorderDim,
        BorderSizePixel = 0,
        Parent = parent,
    })
end

-- =====================
--    CREATE WINDOW
-- =====================
function FateUI:CreateWindow(options)
    local T = self.Theme
    options = options or {}
    local Title     = options.Title     or "FateUI"
    local SubTitle  = options.SubTitle  or "Traza's Private Edition"
    local ToggleKey = options.ToggleKey or Enum.KeyCode.RightShift

    -- ScreenGui
    local SG = New("ScreenGui", {
        Name = "FateUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999,
    })

    if syn and syn.protect_gui then
        syn.protect_gui(SG)
        SG.Parent = game.CoreGui
    elseif gethui then
        SG.Parent = gethui()
    else
        SG.Parent = game.CoreGui
    end

    -- Main Frame
    local Main = New("Frame", {
        Name = "FateUI_Main",
        Size = UDim2.new(0, 480, 0, 410),
        Position = UDim2.new(0.5, -240, 0.5, -205),
        BackgroundColor3 = T.BG,
        BorderSizePixel = 0,
        Parent = SG,
        ClipsDescendants = true,
    })
    Corner(4, Main)
    Stroke(T.Border, 1, 0.75, Main)

    -- Cyan glow shadow
    New("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 8),
        Size = UDim2.new(1, 50, 1, 50),
        Image = "rbxassetid://6014261993",
        ImageColor3 = T.Accent,
        ImageTransparency = 0.88,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = 0,
        Parent = Main,
    })

    -- =====================
    --      TITLE BAR
    -- =====================
    local TitleBar = New("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = T.Surface,
        BorderSizePixel = 0,
        Parent = Main,
    })
    HLine(TitleBar, 43)

    -- Hex icon
    local HexFrame = New("Frame", {
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(0, 10, 0.5, -14),
        BackgroundColor3 = T.AccentSoft,
        BorderSizePixel = 0,
        Parent = TitleBar,
    })
    Corner(4, HexFrame)
    Stroke(T.Accent, 1, 0.5, HexFrame)
    New("TextLabel", {
        Text = "⬡",
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = T.Accent,
        BackgroundTransparency = 1,
        Size = UDim2.new(1,0,1,0),
        Parent = HexFrame,
    })

    -- Title
    New("TextLabel", {
        Text = string.upper(Title),
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = T.Accent,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, 0, 0, 16),
        Position = UDim2.new(0, 46, 0, 8),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleBar,
    })
    New("TextLabel", {
        Text = SubTitle,
        Font = Enum.Font.Code,
        TextSize = 8,
        TextColor3 = T.Muted,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, 0, 0, 12),
        Position = UDim2.new(0, 46, 0, 25),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleBar,
    })

    -- Win buttons (top right, same style as screenshot)
    local WinBtnHolder = New("Frame", {
        Size = UDim2.new(0, 52, 0, 12),
        Position = UDim2.new(1, -62, 0.5, -6),
        BackgroundTransparency = 1,
        Parent = TitleBar,
    })
    List(WinBtnHolder, 6, Enum.FillDirection.Horizontal)

    local function MkWinBtn(col)
        local b = New("TextButton", {
            Size = UDim2.new(0,12,0,12),
            BackgroundColor3 = col,
            BorderSizePixel = 0,
            Text = "",
            Parent = WinBtnHolder,
        })
        Corner(6, b)
        return b
    end
    local CloseBtn = MkWinBtn(Color3.fromRGB(255,95,87))
    local MinBtn   = MkWinBtn(Color3.fromRGB(255,189,46))
    local MaxBtn   = MkWinBtn(Color3.fromRGB(40,200,64))

    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main, {Size = UDim2.new(0,480,0,0)}, 0.2)
        task.wait(0.25)
        SG:Destroy()
    end)
    MinBtn.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
    end)

    -- =====================
    --     STATUS BAR
    -- =====================
    local StatBar = New("Frame", {
        Size = UDim2.new(1, 0, 0, 22),
        Position = UDim2.new(0, 0, 0, 44),
        BackgroundColor3 = T.Black,
        BackgroundTransparency = 0.65,
        BorderSizePixel = 0,
        Parent = Main,
    })
    HLine(StatBar, 21)

    local StatusDot = New("Frame", {
        Size = UDim2.new(0, 6, 0, 6),
        Position = UDim2.new(0, 12, 0.5, -3),
        BackgroundColor3 = T.Muted,
        BorderSizePixel = 0,
        Parent = StatBar,
    })
    Corner(3, StatusDot)

    local StatusText = New("TextLabel", {
        Text = "INACTIVE",
        Font = Enum.Font.Code,
        TextSize = 8,
        TextColor3 = T.Muted,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 80, 1, 0),
        Position = UDim2.new(0, 22, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = StatBar,
    })

    New("TextLabel", {
        Text = "v2.1",
        Font = Enum.Font.Code,
        TextSize = 8,
        TextColor3 = T.Muted,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 40, 1, 0),
        Position = UDim2.new(0.5, -20, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = StatBar,
    })

    local PlayerCountLabel = New("TextLabel", {
        Text = #Players:GetPlayers() .. " PLAYERS",
        Font = Enum.Font.Code,
        TextSize = 8,
        TextColor3 = T.Muted,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 80, 1, 0),
        Position = UDim2.new(1, -90, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = StatBar,
    })

    Players.PlayerAdded:Connect(function() PlayerCountLabel.Text = #Players:GetPlayers() .. " PLAYERS" end)
    Players.PlayerRemoving:Connect(function() task.wait() PlayerCountLabel.Text = #Players:GetPlayers() .. " PLAYERS" end)

    -- =====================
    --       TAB BAR
    -- =====================
    local TabBar = New("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 66),
        BackgroundColor3 = T.Black,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        Parent = Main,
    })
    HLine(TabBar, 29)

    local TabBtnFrame = New("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = TabBar,
    })
    List(TabBtnFrame, 0, Enum.FillDirection.Horizontal)

    -- =====================
    --    CONTENT BODY
    -- =====================
    local Body = New("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -118),
        Position = UDim2.new(0, 0, 0, 97),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = T.Accent,
        ScrollBarImageTransparency = 0.5,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = Main,
    })
    Pad(10, 10, 14, 14, Body)
    List(Body, 8)

    -- =====================
    --      FOOTER
    -- =====================
    local FooterFrame = New("Frame", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 1, -20),
        BackgroundColor3 = T.Black,
        BackgroundTransparency = 0.65,
        BorderSizePixel = 0,
        Parent = Main,
    })
    New("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = T.BorderDim,
        BorderSizePixel = 0,
        Parent = FooterFrame,
    })

    New("TextLabel", {
        Text = "MADE BY ! 54T0",
        Font = Enum.Font.Code,
        TextSize = 8,
        TextColor3 = T.Accent,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0, 14, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = FooterFrame,
    })

    local FPSLabel = New("TextLabel", {
        Text = "FPS: —",
        Font = Enum.Font.Code,
        TextSize = 8,
        TextColor3 = T.Muted,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, -14, 1, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = FooterFrame,
    })

    -- FPS counter
    local ff, fl = 0, tick()
    RunService.RenderStepped:Connect(function()
        ff += 1
        if tick() - fl >= 0.5 then
            FPSLabel.Text = "FPS: " .. math.round(ff / (tick() - fl))
            ff = 0; fl = tick()
        end
    end)

    -- =====================
    --    NOTIFICATIONS
    -- =====================
    local NotifHolder = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 220, 0, 0),
        Position = UDim2.new(1, -230, 1, -10),
        AnchorPoint = Vector2.new(0, 1),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = SG,
    })
    local nl = List(NotifHolder, 6)
    nl.VerticalAlignment = Enum.VerticalAlignment.Bottom

    self._notifHolder = NotifHolder
    self._theme = T

    -- =====================
    --    DRAGGING
    -- =====================
    local drag, ds, sp = false, nil, nil
    TitleBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true; ds = i.Position; sp = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - ds
            Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset+d.X, sp.Y.Scale, sp.Y.Offset+d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)

    -- Toggle key
    UserInputService.InputBegan:Connect(function(i, gpe)
        if gpe then return end
        if i.KeyCode == ToggleKey then Main.Visible = not Main.Visible end
    end)

    -- =====================
    --    WINDOW OBJECT
    -- =====================
    local Window = {}
    local tabPanels = {}
    local tabBtns   = {}
    local tabCount  = 0

    -- Notify
    function Window:Notify(opts)
        opts = opts or {}
        local n = New("Frame", {
            BackgroundColor3 = T.Surface,
            Size = UDim2.new(1,0,0,54),
            BackgroundTransparency = 1,
            Parent = NotifHolder,
        })
        Corner(4, n)
        Stroke(T.Accent, 1, 0.6, n)
        New("Frame", {
            Size = UDim2.new(0,2,0.6,0),
            Position = UDim2.new(0,0,0.2,0),
            BackgroundColor3 = T.Accent,
            BorderSizePixel = 0,
            Parent = n,
        })
        New("TextLabel", {
            Text = opts.Title or "FateUI",
            Font = Enum.Font.GothamBold, TextSize = 11,
            TextColor3 = T.Accent, BackgroundTransparency = 1,
            Size = UDim2.new(1,-16,0,16), Position = UDim2.new(0,12,0,8),
            TextXAlignment = Enum.TextXAlignment.Left, Parent = n,
        })
        New("TextLabel", {
            Text = opts.Message or "",
            Font = Enum.Font.Gotham, TextSize = 10,
            TextColor3 = T.Muted, BackgroundTransparency = 1,
            Size = UDim2.new(1,-16,0,14), Position = UDim2.new(0,12,0,26),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, Parent = n,
        })
        Tween(n, {BackgroundTransparency = 0}, 0.2)
        task.delay(opts.Duration or 3, function()
            Tween(n, {BackgroundTransparency = 1}, 0.3)
            task.wait(0.35); n:Destroy()
        end)
    end

    -- Set status
    function Window:SetStatus(text, active)
        StatusText.Text = text or "INACTIVE"
        if active ~= nil then
            Tween(StatusDot, {BackgroundColor3 = active and T.Success or T.Muted})
            Tween(StatusText, {TextColor3 = active and T.Success or T.Muted})
        end
    end

    -- Create Tab
    function Window:CreateTab(name)
        tabCount += 1
        local order = tabCount

        -- Tab button
        local TBtn = New("TextButton", {
            Text = string.upper(name),
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            TextColor3 = T.Muted,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 90, 1, 0),
            BorderSizePixel = 0,
            LayoutOrder = order,
            Parent = TabBtnFrame,
        })

        local TUnderline = New("Frame", {
            Size = UDim2.new(0.65, 0, 0, 2),
            Position = UDim2.new(0.175, 0, 1, -2),
            BackgroundColor3 = T.Accent,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Parent = TBtn,
        })

        -- Panel
        local Panel = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1,0,0,0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Visible = false,
            LayoutOrder = order,
            Parent = Body,
        })
        List(Panel, 8)
        tabPanels[name] = Panel
        table.insert(tabBtns, {btn=TBtn, line=TUnderline})

        local function activate()
            for _, tb in ipairs(tabBtns) do
                Tween(tb.btn, {TextColor3 = T.Muted})
                Tween(tb.line, {BackgroundTransparency = 1})
            end
            for _, p in pairs(tabPanels) do p.Visible = false end
            Tween(TBtn, {TextColor3 = T.Accent})
            Tween(TUnderline, {BackgroundTransparency = 0})
            Panel.Visible = true
        end

        TBtn.MouseButton1Click:Connect(activate)
        if tabCount == 1 then task.defer(activate) end

        -- =====================
        --    TAB METHODS
        -- =====================
        local Tab = {}
        local rc = 0
        local function no() rc+=1 return rc end

        -- Section
        function Tab:CreateSection(text)
            local f = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1,0,0,20),
                LayoutOrder = no(),
                Parent = Panel,
            })
            New("TextLabel", {
                Text = string.upper(text),
                Font = Enum.Font.GothamBold, TextSize = 9,
                TextColor3 = T.Accent, BackgroundTransparency = 1,
                Size = UDim2.new(0,120,1,0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = f,
            })
            New("Frame", {
                Size = UDim2.new(1,-128,0,1),
                Position = UDim2.new(0,124,0.5,0),
                BackgroundColor3 = T.Accent,
                BackgroundTransparency = 0.75,
                BorderSizePixel = 0,
                Parent = f,
            })
        end

        -- Label
        function Tab:CreateLabel(text)
            local f = New("Frame", {
                BackgroundColor3 = T.AccentSoft,
                Size = UDim2.new(1,0,0,28),
                BorderSizePixel = 0,
                LayoutOrder = no(),
                Parent = Panel,
            })
            Corner(4, f)
            Stroke(T.Border, 1, 0.8, f)
            New("TextLabel", {
                Text = "  ⚠  " .. text,
                Font = Enum.Font.Gotham, TextSize = 10,
                TextColor3 = T.Muted, BackgroundTransparency = 1,
                Size = UDim2.new(1,-10,1,0),
                Position = UDim2.new(0,5,0,0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = f,
            })
        end

        -- Toggle
        function Tab:CreateToggle(opts)
            opts = opts or {}
            local h = opts.Description and 42 or 36
            local row = New("Frame", {
                BackgroundColor3 = T.Card,
                Size = UDim2.new(1,0,0,h),
                BorderSizePixel = 0,
                LayoutOrder = no(),
                Parent = Panel,
            })
            Corner(4, row)
            Stroke(T.BorderDim, 1, 0, row)

            New("TextLabel", {
                Text = opts.Name or "Toggle",
                Font = Enum.Font.Gotham, TextSize = 12,
                TextColor3 = T.Text, BackgroundTransparency = 1,
                Size = UDim2.new(1,-56,0,16),
                Position = UDim2.new(0,12,0, opts.Description and 8 or 10),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = row,
            })

            if opts.Description then
                New("TextLabel", {
                    Text = opts.Description,
                    Font = Enum.Font.Gotham, TextSize = 9,
                    TextColor3 = T.Muted, BackgroundTransparency = 1,
                    Size = UDim2.new(1,-56,0,12),
                    Position = UDim2.new(0,12,0,26),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = row,
                })
            end

            local tbg = New("Frame", {
                Size = UDim2.new(0,34,0,18),
                Position = UDim2.new(1,-46,0.5,-9),
                BackgroundColor3 = T.Muted2,
                BorderSizePixel = 0,
                Parent = row,
            })
            Corner(9, tbg)

            local tknob = New("Frame", {
                Size = UDim2.new(0,12,0,12),
                Position = UDim2.new(0,3,0.5,-6),
                BackgroundColor3 = T.White,
                BorderSizePixel = 0,
                Parent = tbg,
            })
            Corner(6, tknob)

            local on = opts.Default or false
            if on then
                tbg.BackgroundColor3 = T.Accent
                tknob.Position = UDim2.new(0,19,0.5,-6)
            end

            local btn = New("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1,0,1,0),
                Text = "", ZIndex = 2,
                Parent = row,
            })

            btn.MouseButton1Click:Connect(function()
                on = not on
                Tween(tbg, {BackgroundColor3 = on and T.Accent or T.Muted2})
                Tween(tknob, {Position = on and UDim2.new(0,19,0.5,-6) or UDim2.new(0,3,0.5,-6)})
                if opts.Callback then opts.Callback(on) end
            end)
            btn.MouseEnter:Connect(function() Tween(row, {BackgroundColor3 = T.CardHover}) end)
            btn.MouseLeave:Connect(function() Tween(row, {BackgroundColor3 = T.Card}) end)

            return {GetValue = function() return on end}
        end

        -- Slider
        function Tab:CreateSlider(opts)
            opts = opts or {}
            local min = opts.Min or 0
            local max = opts.Max or 100
            local default = opts.Default or min
            local suffix = opts.Suffix or ""

            local row = New("Frame", {
                BackgroundColor3 = T.Card,
                Size = UDim2.new(1,0,0,52),
                BorderSizePixel = 0,
                LayoutOrder = no(),
                Parent = Panel,
            })
            Corner(4, row)
            Stroke(T.BorderDim, 1, 0, row)

            New("TextLabel", {
                Text = opts.Name or "Slider",
                Font = Enum.Font.Gotham, TextSize = 12,
                TextColor3 = T.Text, BackgroundTransparency = 1,
                Size = UDim2.new(0.6,0,0,16),
                Position = UDim2.new(0,12,0,8),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = row,
            })

            -- Value box (like in screenshot)
            local valBox = New("Frame", {
                Size = UDim2.new(0,44,0,18),
                Position = UDim2.new(1,-56,0,7),
                BackgroundColor3 = T.AccentSoft,
                BorderSizePixel = 0,
                Parent = row,
            })
            Corner(3, valBox)
            Stroke(T.Accent, 1, 0.6, valBox)

            local valLabel = New("TextLabel", {
                Text = tostring(default),
                Font = Enum.Font.Code, TextSize = 10,
                TextColor3 = T.Accent, BackgroundTransparency = 1,
                Size = UDim2.new(1,0,1,0),
                TextXAlignment = Enum.TextXAlignment.Center,
                Parent = valBox,
            })

            -- Track
            local track = New("Frame", {
                Size = UDim2.new(1,-24,0,3),
                Position = UDim2.new(0,12,0,36),
                BackgroundColor3 = T.Muted2,
                BorderSizePixel = 0,
                Parent = row,
            })
            Corner(2, track)

            local pct = (default-min)/(max-min)

            local fill = New("Frame", {
                Size = UDim2.new(pct,0,1,0),
                BackgroundColor3 = T.Accent,
                BorderSizePixel = 0,
                Parent = track,
            })
            Corner(2, fill)

            -- Cyan circle knob like in screenshot
            local knob = New("Frame", {
                Size = UDim2.new(0,13,0,13),
                Position = UDim2.new(pct,-6,0.5,-6),
                BackgroundColor3 = T.Accent,
                BorderSizePixel = 0,
                Parent = track,
            })
            Corner(7, knob)
            Stroke(T.BG, 2, 0, knob)

            local value = default
            local draggingSlider = false

            local function update(mx)
                local rel = math.clamp((mx - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max-min) * rel)
                local p = (value-min)/(max-min)
                fill.Size = UDim2.new(p,0,1,0)
                knob.Position = UDim2.new(p,-6,0.5,-6)
                valLabel.Text = tostring(value) .. suffix
                if opts.Callback then opts.Callback(value) end
            end

            local sb = New("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1,0,1,0),
                Text = "", ZIndex = 2,
                Parent = row,
            })

            sb.MouseButton1Down:Connect(function()
                draggingSlider = true
                update(UserInputService:GetMouseLocation().X)
            end)
            UserInputService.InputChanged:Connect(function(i)
                if draggingSlider and i.UserInputType == Enum.UserInputType.MouseMovement then
                    update(i.Position.X)
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = false
                end
            end)
            sb.MouseEnter:Connect(function() Tween(row, {BackgroundColor3 = T.CardHover}) end)
            sb.MouseLeave:Connect(function() Tween(row, {BackgroundColor3 = T.Card}) end)

            return {GetValue = function() return value end}
        end

        -- Button
        function Tab:CreateButton(opts)
            opts = opts or {}
            local btn = New("TextButton", {
                Text = "  " .. (opts.Icon or "") .. "  " .. (opts.Name or "Button"),
                Font = Enum.Font.Gotham, TextSize = 12,
                TextColor3 = T.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundColor3 = T.Card,
                Size = UDim2.new(1,0,0,34),
                BorderSizePixel = 0,
                LayoutOrder = no(),
                Parent = Panel,
            })
            Corner(4, btn)
            Stroke(T.BorderDim, 1, 0, btn)
            btn.MouseEnter:Connect(function()
                Tween(btn, {BackgroundColor3 = T.CardHover})
                Stroke(T.Accent, 1, 0.7, btn)
            end)
            btn.MouseLeave:Connect(function() Tween(btn, {BackgroundColor3 = T.Card}) end)
            btn.MouseButton1Click:Connect(function()
                if opts.Callback then opts.Callback() end
            end)
        end

        -- Input
        function Tab:CreateInput(opts)
            opts = opts or {}
            local row = New("Frame", {
                BackgroundColor3 = T.Card,
                Size = UDim2.new(1,0,0,54),
                BorderSizePixel = 0,
                LayoutOrder = no(),
                Parent = Panel,
            })
            Corner(4, row)
            Stroke(T.BorderDim, 1, 0, row)

            New("TextLabel", {
                Text = opts.Name or "Input",
                Font = Enum.Font.Gotham, TextSize = 10,
                TextColor3 = T.Muted, BackgroundTransparency = 1,
                Size = UDim2.new(1,-24,0,14),
                Position = UDim2.new(0,12,0,5),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = row,
            })

            local box = New("TextBox", {
                Text = "",
                PlaceholderText = opts.Placeholder or "",
                PlaceholderColor3 = T.Muted2,
                Font = Enum.Font.Code, TextSize = 11,
                TextColor3 = T.Accent,
                BackgroundColor3 = T.BG,
                Size = UDim2.new(1,-24,0,24),
                Position = UDim2.new(0,12,0,24),
                BorderSizePixel = 0,
                ClearTextOnFocus = false,
                ZIndex = 2,
                Parent = row,
            })
            Corner(3, box)
            Stroke(T.Accent, 1, 0.7, box)
            Pad(0,0,8,8,box)

            box.FocusLost:Connect(function(enter)
                if enter and opts.Callback then opts.Callback(box.Text) end
            end)

            return {GetValue = function() return box.Text end}
        end

        -- Keybind (like screenshot's "F" badge)
        function Tab:CreateKeybind(opts)
            opts = opts or {}
            local currentKey = opts.Default or Enum.KeyCode.F
            local recording = false

            local row = New("Frame", {
                BackgroundColor3 = T.Card,
                Size = UDim2.new(1,0,0,36),
                BorderSizePixel = 0,
                LayoutOrder = no(),
                Parent = Panel,
            })
            Corner(4, row)
            Stroke(T.BorderDim, 1, 0, row)

            New("TextLabel", {
                Text = opts.Name or "Keybind",
                Font = Enum.Font.Gotham, TextSize = 12,
                TextColor3 = T.Text, BackgroundTransparency = 1,
                Size = UDim2.new(1,-70,1,0),
                Position = UDim2.new(0,12,0,0),
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = row,
            })

            -- Key badge (looks like the "F" in screenshot)
            local badge = New("TextButton", {
                Text = currentKey.Name:len() > 3 and currentKey.Name:sub(1,3) or currentKey.Name,
                Font = Enum.Font.Code, TextSize = 10,
                TextColor3 = T.Accent,
                BackgroundColor3 = T.AccentSoft,
                Size = UDim2.new(0,36,0,20),
                Position = UDim2.new(1,-48,0.5,-10),
                BorderSizePixel = 0,
                ZIndex = 2,
                Parent = row,
            })
            Corner(3, badge)
            Stroke(T.Accent, 1, 0.5, badge)

            badge.MouseButton1Click:Connect(function()
                if recording then return end
                recording = true
                badge.Text = "..."
                Tween(badge, {TextColor3 = T.Warning})
                local conn
                conn = UserInputService.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = i.KeyCode
                        local name = i.KeyCode.Name
                        badge.Text = name:len() > 3 and name:sub(1,3) or name
                        Tween(badge, {TextColor3 = T.Accent})
                        recording = false
                        conn:Disconnect()
                    end
                end)
            end)

            UserInputService.InputBegan:Connect(function(i, gpe)
                if gpe or recording then return end
                if i.KeyCode == currentKey then
                    if opts.Callback then opts.Callback() end
                end
            end)

            return {GetKey = function() return currentKey end}
        end

        -- Divider
        function Tab:CreateDivider()
            New("Frame", {
                BackgroundColor3 = T.BorderDim,
                BorderSizePixel = 0,
                Size = UDim2.new(1,0,0,1),
                LayoutOrder = no(),
                Parent = Panel,
            })
        end

        return Tab
    end

    return Window
end

-- Top-level Notify
function FateUI:Notify(opts)
    if not self._notifHolder then return end
    local T = self._theme or FateUI.Theme
    opts = opts or {}
    local n = New("Frame", {
        BackgroundColor3 = T.Surface,
        Size = UDim2.new(1,0,0,54),
        BackgroundTransparency = 1,
        Parent = self._notifHolder,
    })
    Corner(4, n)
    Stroke(T.Accent, 1, 0.6, n)
    New("Frame", {Size=UDim2.new(0,2,0.6,0), Position=UDim2.new(0,0,0.2,0), BackgroundColor3=T.Accent, BorderSizePixel=0, Parent=n})
    New("TextLabel", {Text=opts.Title or "FateUI", Font=Enum.Font.GothamBold, TextSize=11, TextColor3=T.Accent, BackgroundTransparency=1, Size=UDim2.new(1,-16,0,16), Position=UDim2.new(0,12,0,8), TextXAlignment=Enum.TextXAlignment.Left, Parent=n})
    New("TextLabel", {Text=opts.Message or "", Font=Enum.Font.Gotham, TextSize=10, TextColor3=T.Muted, BackgroundTransparency=1, Size=UDim2.new(1,-16,0,14), Position=UDim2.new(0,12,0,26), TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd, Parent=n})
    Tween(n, {BackgroundTransparency=0}, 0.2)
    task.delay(opts.Duration or 3, function()
        Tween(n, {BackgroundTransparency=1}, 0.3)
        task.wait(0.35); n:Destroy()
    end)
end

return FateUI
