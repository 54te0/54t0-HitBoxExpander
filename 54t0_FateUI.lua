--[[
    FateUI - Traza's HitBox Expander
    Made by ! 54t0
    Custom UI Library
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Globals
getgenv().HitboxSize = 15
getgenv().HitboxTransparency = 0.9
getgenv().HitboxStatus = false
getgenv().TeamCheck = false
getgenv().Walkspeed = 16
getgenv().Jumppower = 50
getgenv().LoopWS = false
getgenv().LoopJP = false
getgenv().TPSpeed = 3
getgenv().TPWalk = false
getgenv().InfiniteJump = false
getgenv().NoClip = false
getgenv().AntiFall = false
getgenv().ESPEnabled = false
getgenv().NameTags = false
getgenv().HealthBars = false
getgenv().TeamESP = false
getgenv().ChamsEnabled = false
getgenv().ESPDistance = 500

-- =====================
--    UI CONSTRUCTION
-- =====================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FateUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game.CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = game.CoreGui
end

-- Colors
local C = {
    BG        = Color3.fromRGB(14, 14, 15),
    Sidebar   = Color3.fromRGB(17, 17, 19),
    Panel     = Color3.fromRGB(20, 20, 22),
    Card      = Color3.fromRGB(26, 26, 29),
    Border    = Color3.fromRGB(34, 34, 38),
    Border2   = Color3.fromRGB(42, 42, 46),
    Accent    = Color3.fromRGB(229, 57, 53),
    AccentSoft= Color3.fromRGB(40, 15, 15),
    Text      = Color3.fromRGB(240, 240, 242),
    Muted     = Color3.fromRGB(102, 102, 112),
    Muted2    = Color3.fromRGB(68, 68, 74),
    Success   = Color3.fromRGB(76, 175, 80),
    White     = Color3.fromRGB(255, 255, 255),
}

-- Helper: Create instance
local function New(class, props, children)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    for _, child in pairs(children or {}) do
        child.Parent = obj
    end
    return obj
end

-- Helper: Tween
local function Tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quad), props):Play()
end

-- Helper: Corner
local function Corner(r, parent)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = parent
    return c
end

-- Helper: Stroke
local function Stroke(color, thickness, parent)
    local s = Instance.new("UIStroke")
    s.Color = color or C.Border
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

-- Helper: Padding
local function Padding(top, bottom, left, right, parent)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, top or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)
    p.PaddingLeft = UDim.new(0, left or 0)
    p.PaddingRight = UDim.new(0, right or 0)
    p.Parent = parent
    return p
end

-- =====================
--      MAIN WINDOW
-- =====================

local MainFrame = New("Frame", {
    Name = "MainFrame",
    Size = UDim2.new(0, 560, 0, 400),
    Position = UDim2.new(0.5, -280, 0.5, -200),
    BackgroundColor3 = C.BG,
    BorderSizePixel = 0,
    Parent = ScreenGui,
})
Corner(10, MainFrame)
Stroke(C.Border, 1, MainFrame)

-- Drop shadow
local Shadow = New("ImageLabel", {
    Name = "Shadow",
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1,
    Position = UDim2.new(0.5, 0, 0.5, 4),
    Size = UDim2.new(1, 30, 1, 30),
    Image = "rbxassetid://6014261993",
    ImageColor3 = Color3.fromRGB(0,0,0),
    ImageTransparency = 0.5,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(49, 49, 450, 450),
    ZIndex = 0,
    Parent = MainFrame,
})

-- =====================
--       SIDEBAR
-- =====================

local Sidebar = New("Frame", {
    Name = "Sidebar",
    Size = UDim2.new(0, 155, 1, 0),
    BackgroundColor3 = C.Sidebar,
    BorderSizePixel = 0,
    Parent = MainFrame,
})
Corner(10, Sidebar)

-- Mask right corners of sidebar
New("Frame", {
    Size = UDim2.new(0, 10, 1, 0),
    Position = UDim2.new(1, -10, 0, 0),
    BackgroundColor3 = C.Sidebar,
    BorderSizePixel = 0,
    Parent = Sidebar,
})
Stroke(C.Border, 1, Sidebar)

-- Sidebar Header
local SidebarHeader = New("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 52),
    BackgroundTransparency = 1,
    Parent = Sidebar,
})

local AppName = New("TextLabel", {
    Text = "FateUI",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = C.Text,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 18),
    Position = UDim2.new(0, 14, 0, 14),
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = SidebarHeader,
})

local AppVersion = New("TextLabel", {
    Text = "v2.1  ·  ! 54t0",
    Font = Enum.Font.Code,
    TextSize = 9,
    TextColor3 = C.Muted,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 12),
    Position = UDim2.new(0, 14, 0, 33),
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = SidebarHeader,
})

-- Divider
New("Frame", {
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0, 0, 0, 52),
    BackgroundColor3 = C.Border,
    BorderSizePixel = 0,
    Parent = Sidebar,
})

-- Nav Container
local NavContainer = New("ScrollingFrame", {
    Name = "Nav",
    Size = UDim2.new(1, 0, 1, -120),
    Position = UDim2.new(0, 0, 0, 53),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Parent = Sidebar,
})
Padding(8, 8, 8, 8, NavContainer)

local NavLayout = New("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 2),
    Parent = NavContainer,
})

-- User Card at bottom
New("Frame", {
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0, 0, 1, -67),
    BackgroundColor3 = C.Border,
    BorderSizePixel = 0,
    Parent = Sidebar,
})

local UserCard = New("Frame", {
    Name = "UserCard",
    Size = UDim2.new(1, 0, 0, 66),
    Position = UDim2.new(0, 0, 1, -66),
    BackgroundTransparency = 1,
    Parent = Sidebar,
})
Padding(0, 0, 12, 12, UserCard)

local Avatar = New("Frame", {
    Size = UDim2.new(0, 26, 0, 26),
    Position = UDim2.new(0, 0, 0.5, -13),
    BackgroundColor3 = C.AccentSoft,
    BorderSizePixel = 0,
    Parent = UserCard,
})
Corner(13, Avatar)
Stroke(C.Accent, 1, Avatar)

New("TextLabel", {
    Text = "S",
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    TextColor3 = C.Accent,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, 0),
    TextXAlignment = Enum.TextXAlignment.Center,
    Parent = Avatar,
})

New("TextLabel", {
    Text = "! 54t0",
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    TextColor3 = C.Text,
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 80, 0, 14),
    Position = UDim2.new(0, 34, 0.5, -16),
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = UserCard,
})

New("TextLabel", {
    Text = "@Trazadev",
    Font = Enum.Font.Code,
    TextSize = 9,
    TextColor3 = C.Muted,
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 80, 0, 12),
    Position = UDim2.new(0, 34, 0.5, 2),
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = UserCard,
})

-- =====================
--    CONTENT AREA
-- =====================

local Content = New("Frame", {
    Name = "Content",
    Size = UDim2.new(1, -155, 1, 0),
    Position = UDim2.new(0, 155, 0, 0),
    BackgroundTransparency = 1,
    Parent = MainFrame,
})

-- Content Header
local ContentHeader = New("Frame", {
    Size = UDim2.new(1, 0, 0, 46),
    BackgroundTransparency = 1,
    Parent = Content,
})

local PageTitle = New("TextLabel", {
    Text = "Combat",
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextColor3 = C.Text,
    BackgroundTransparency = 1,
    Size = UDim2.new(0.5, 0, 1, 0),
    Position = UDim2.new(0, 18, 0, 0),
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = ContentHeader,
})

-- Status pill
local StatusPill = New("Frame", {
    Size = UDim2.new(0, 70, 0, 20),
    Position = UDim2.new(1, -90, 0.5, -10),
    BackgroundColor3 = C.Card,
    BorderSizePixel = 0,
    Parent = ContentHeader,
})
Corner(10, StatusPill)
Stroke(C.Border2, 1, StatusPill)

local StatusDot = New("Frame", {
    Size = UDim2.new(0, 5, 0, 5),
    Position = UDim2.new(0, 8, 0.5, -2),
    BackgroundColor3 = C.Muted2,
    BorderSizePixel = 0,
    Parent = StatusPill,
})
Corner(3, StatusDot)

local StatusText = New("TextLabel", {
    Text = "OFF",
    Font = Enum.Font.Code,
    TextSize = 9,
    TextColor3 = C.Muted,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, -20, 1, 0),
    Position = UDim2.new(0, 18, 0, 0),
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = StatusPill,
})

-- Divider
New("Frame", {
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0, 0, 0, 46),
    BackgroundColor3 = C.Border,
    BorderSizePixel = 0,
    Parent = Content,
})

-- Content Body
local ContentBody = New("ScrollingFrame", {
    Name = "Body",
    Size = UDim2.new(1, 0, 1, -68),
    Position = UDim2.new(0, 0, 0, 47),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = C.Border2,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Parent = Content,
})
Padding(10, 10, 18, 18, ContentBody)

local BodyLayout = New("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 8),
    Parent = ContentBody,
})

-- Footer
New("Frame", {
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0, 0, 1, -21),
    BackgroundColor3 = C.Border,
    BorderSizePixel = 0,
    Parent = Content,
})

local Footer = New("Frame", {
    Size = UDim2.new(1, 0, 0, 20),
    Position = UDim2.new(0, 0, 1, -20),
    BackgroundTransparency = 1,
    Parent = Content,
})
Padding(0, 0, 18, 18, Footer)

New("TextLabel", {
    Text = "FATE UI  ·  ! 54t0",
    Font = Enum.Font.Code,
    TextSize = 8,
    TextColor3 = C.Muted2,
    BackgroundTransparency = 1,
    Size = UDim2.new(0.5, 0, 1, 0),
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Footer,
})

local FPSLabel = New("TextLabel", {
    Text = "FPS —",
    Font = Enum.Font.Code,
    TextSize = 8,
    TextColor3 = C.Muted2,
    BackgroundTransparency = 1,
    Size = UDim2.new(0.5, 0, 1, 0),
    Position = UDim2.new(0.5, 0, 0, 0),
    TextXAlignment = Enum.TextXAlignment.Right,
    Parent = Footer,
})

-- =====================
--    UI COMPONENTS
-- =====================

-- Section label
local function MakeSection(text, order)
    local f = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 16),
        LayoutOrder = order or 0,
        Parent = ContentBody,
    })
    New("TextLabel", {
        Text = text:upper(),
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextColor3 = C.Muted,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = f,
    })
    return f
end

-- Card container
local function MakeCard(order)
    local card = New("Frame", {
        BackgroundColor3 = C.Card,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BorderSizePixel = 0,
        LayoutOrder = order or 0,
        Parent = ContentBody,
    })
    Corner(7, card)
    Stroke(C.Border, 1, card)
    New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = card,
    })
    return card
end

-- Toggle row
local function MakeToggle(parent, labelText, descText, order, callback)
    local row = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 38),
        LayoutOrder = order or 0,
        Parent = parent,
    })

    -- Divider
    if order and order > 0 then
        New("Frame", {
            Size = UDim2.new(1, -24, 0, 1),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundColor3 = C.Border,
            BorderSizePixel = 0,
            Parent = row,
        })
    end

    New("TextLabel", {
        Text = labelText,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = C.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -60, 0, 16),
        Position = UDim2.new(0, 12, 0, 10),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })

    if descText then
        New("TextLabel", {
            Text = descText,
            Font = Enum.Font.Gotham,
            TextSize = 10,
            TextColor3 = C.Muted,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -60, 0, 12),
            Position = UDim2.new(0, 12, 0, 26),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = row,
        })
    end

    local toggleBG = New("Frame", {
        Size = UDim2.new(0, 32, 0, 17),
        Position = UDim2.new(1, -44, 0.5, -8),
        BackgroundColor3 = C.Border2,
        BorderSizePixel = 0,
        Parent = row,
    })
    Corner(9, toggleBG)

    local toggleKnob = New("Frame", {
        Size = UDim2.new(0, 11, 0, 11),
        Position = UDim2.new(0, 3, 0.5, -5),
        BackgroundColor3 = C.White,
        BorderSizePixel = 0,
        Parent = toggleBG,
    })
    Corner(6, toggleKnob)

    local on = false
    local btn = New("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        Parent = row,
    })

    btn.MouseButton1Click:Connect(function()
        on = not on
        Tween(toggleBG, { BackgroundColor3 = on and C.Accent or C.Border2 })
        Tween(toggleKnob, { Position = on and UDim2.new(0, 18, 0.5, -5) or UDim2.new(0, 3, 0.5, -5) })
        if callback then callback(on) end
    end)

    -- Hover
    btn.MouseEnter:Connect(function()
        Tween(row, { BackgroundColor3 = Color3.fromRGB(255,255,255) })
        row.BackgroundTransparency = 0.97
    end)
    btn.MouseLeave:Connect(function()
        row.BackgroundTransparency = 1
    end)

    return { row = row, toggle = toggleBG, knob = toggleKnob, getValue = function() return on end }
end

-- Slider row
local function MakeSlider(parent, labelText, min, max, default, suffix, order, callback)
    local row = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 48),
        LayoutOrder = order or 0,
        Parent = parent,
    })

    if order and order > 0 then
        New("Frame", {
            Size = UDim2.new(1, -24, 0, 1),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundColor3 = C.Border,
            BorderSizePixel = 0,
            Parent = row,
        })
    end

    New("TextLabel", {
        Text = labelText,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = C.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.6, 0, 0, 16),
        Position = UDim2.new(0, 12, 0, 8),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })

    local valLabel = New("TextLabel", {
        Text = tostring(default) .. (suffix or ""),
        Font = Enum.Font.Code,
        TextSize = 10,
        TextColor3 = C.Accent,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.4, -14, 0, 16),
        Position = UDim2.new(0.6, 0, 0, 8),
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = row,
    })

    local track = New("Frame", {
        Size = UDim2.new(1, -24, 0, 3),
        Position = UDim2.new(0, 12, 0, 32),
        BackgroundColor3 = C.Border2,
        BorderSizePixel = 0,
        Parent = row,
    })
    Corner(2, track)

    local fill = New("Frame", {
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = C.Accent,
        BorderSizePixel = 0,
        Parent = track,
    })
    Corner(2, fill)

    local knob = New("Frame", {
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6),
        BackgroundColor3 = C.White,
        BorderSizePixel = 0,
        Parent = track,
    })
    Corner(6, knob)

    local value = default
    local dragging = false

    local function updateSlider(input)
        local trackPos = track.AbsolutePosition
        local trackSize = track.AbsoluteSize
        local rel = math.clamp((input.Position.X - trackPos.X) / trackSize.X, 0, 1)
        value = math.floor(min + (max - min) * rel)
        local pct = (value - min) / (max - min)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, -6, 0.5, -6)
        valLabel.Text = tostring(value) .. (suffix or "")
        if callback then callback(value) end
    end

    local btn = New("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        Parent = row,
    })

    btn.MouseButton1Down:Connect(function(x, y)
        dragging = true
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    btn.MouseButton1Down:Connect(function()
        local input = UserInputService:GetMouseLocation()
        local trackPos = track.AbsolutePosition
        local trackSize = track.AbsoluteSize
        local rel = math.clamp((input.X - trackPos.X) / trackSize.X, 0, 1)
        value = math.floor(min + (max - min) * rel)
        local pct = (value - min) / (max - min)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, -6, 0.5, -6)
        valLabel.Text = tostring(value) .. (suffix or "")
        if callback then callback(value) end
    end)

    return row
end

-- Button row
local function MakeButton(parent, labelText, icon, order, callback)
    local row = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 34),
        LayoutOrder = order or 0,
        Parent = parent,
    })

    if order and order > 0 then
        New("Frame", {
            Size = UDim2.new(1, -24, 0, 1),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundColor3 = C.Border,
            BorderSizePixel = 0,
            Parent = row,
        })
    end

    local btn = New("TextButton", {
        Text = "",
        BackgroundColor3 = C.Panel,
        Size = UDim2.new(1, -24, 0, 26),
        Position = UDim2.new(0, 12, 0, 4),
        BorderSizePixel = 0,
        Parent = row,
    })
    Corner(5, btn)
    Stroke(C.Border2, 1, btn)

    New("TextLabel", {
        Text = (icon or "") .. "  " .. labelText,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = C.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = btn,
    })

    btn.MouseEnter:Connect(function() Tween(btn, { BackgroundColor3 = C.Card }) end)
    btn.MouseLeave:Connect(function() Tween(btn, { BackgroundColor3 = C.Panel }) end)
    btn.MouseButton1Click:Connect(function() if callback then callback() end end)

    return row
end

-- Input row
local function MakeInput(parent, labelText, placeholder, order, callback)
    local row = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 52),
        LayoutOrder = order or 0,
        Parent = parent,
    })

    if order and order > 0 then
        New("Frame", {
            Size = UDim2.new(1, -24, 0, 1),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundColor3 = C.Border,
            BorderSizePixel = 0,
            Parent = row,
        })
    end

    New("TextLabel", {
        Text = labelText,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = C.Muted,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 12, 0, 6),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })

    local box = New("TextBox", {
        Text = "",
        PlaceholderText = placeholder or "",
        PlaceholderColor3 = C.Muted2,
        Font = Enum.Font.Code,
        TextSize = 11,
        TextColor3 = C.Text,
        BackgroundColor3 = C.BG,
        Size = UDim2.new(1, -24, 0, 24),
        Position = UDim2.new(0, 12, 0, 22),
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Parent = row,
    })
    Corner(5, box)
    Stroke(C.Border2, 1, box)
    Padding(0, 0, 8, 8, box)

    box.FocusLost:Connect(function(enter)
        if enter and callback then callback(box.Text) end
    end)

    return row
end

-- Notification
local NotifFrame = New("Frame", {
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 220, 0, 0),
    Position = UDim2.new(1, -230, 1, -10),
    AnchorPoint = Vector2.new(0, 1),
    AutomaticSize = Enum.AutomaticSize.Y,
    Parent = ScreenGui,
})
New("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    Padding = UDim.new(0, 6),
    Parent = NotifFrame,
})

local function Notify(title, message, duration)
    local n = New("Frame", {
        BackgroundColor3 = C.Card,
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundTransparency = 1,
        Parent = NotifFrame,
    })
    Corner(7, n)
    Stroke(C.Border, 1, n)

    local accent = New("Frame", {
        Size = UDim2.new(0, 3, 0.6, 0),
        Position = UDim2.new(0, 0, 0.2, 0),
        BackgroundColor3 = C.Accent,
        BorderSizePixel = 0,
        Parent = n,
    })
    Corner(2, accent)

    New("TextLabel", {
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = C.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -18, 0, 16),
        Position = UDim2.new(0, 12, 0, 8),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = n,
    })

    New("TextLabel", {
        Text = message or "",
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextColor3 = C.Muted,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -18, 0, 14),
        Position = UDim2.new(0, 12, 0, 26),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = n,
    })

    Tween(n, { BackgroundTransparency = 0 }, 0.2)
    task.delay(duration or 3, function()
        Tween(n, { BackgroundTransparency = 1 }, 0.3)
        task.wait(0.35)
        n:Destroy()
    end)
end

-- =====================
--   TAB PANEL SYSTEM
-- =====================

local tabPanels = {}
local currentTab = nil

local function showTab(name)
    for k, v in pairs(tabPanels) do
        v.Visible = (k == name)
    end
    currentTab = name
end

-- Build a tab panel (returns container to put rows into)
local function NewTabPanel(name)
    local panel = New("Frame", {
        Name = name,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = ContentBody,
    })
    New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = panel,
    })
    tabPanels[name] = panel
    return panel
end

-- =====================
--     NAV BUTTONS
-- =====================

local navTabs = {
    { name = "Combat",   icon = "⚔",  title = "Combat"   },
    { name = "Player",   icon = "🧍", title = "Player"   },
    { name = "Visuals",  icon = "👁",  title = "Visuals"  },
    { name = "Misc",     icon = "⚙",  title = "Misc"     },
    { name = "Settings", icon = "🎨", title = "Settings" },
}

local function MakeNavItem(data, i)
    local btn = New("TextButton", {
        Text = "",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        LayoutOrder = i,
        Parent = NavContainer,
    })
    Corner(6, btn)

    local highlight = New("Frame", {
        Size = UDim2.new(0, 2, 0.6, 0),
        Position = UDim2.new(0, 0, 0.2, 0),
        BackgroundColor3 = C.Accent,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        Parent = btn,
    })
    Corner(2, highlight)

    New("TextLabel", {
        Text = data.icon .. "  " .. data.name,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextColor3 = C.Muted,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Name = "Label",
        Parent = btn,
    })

    btn.MouseButton1Click:Connect(function()
        -- Reset all
        for _, child in ipairs(NavContainer:GetChildren()) do
            if child:IsA("TextButton") then
                Tween(child, { BackgroundTransparency = 1 })
                local lbl = child:FindFirstChild("Label")
                if lbl then Tween(lbl, { TextColor3 = C.Muted }) end
                local hl = child:FindFirstChild("Frame")
                if hl then Tween(hl, { BackgroundTransparency = 1 }) end
            end
        end
        -- Activate
        Tween(btn, { BackgroundTransparency = 0.92 })
        btn.BackgroundColor3 = C.AccentSoft
        local lbl = btn:FindFirstChild("Label")
        if lbl then Tween(lbl, { TextColor3 = C.Accent }) end
        Tween(highlight, { BackgroundTransparency = 0 })
        PageTitle.Text = data.title
        showTab(data.name)
    end)

    return btn
end

local navBtns = {}
for i, data in ipairs(navTabs) do
    navBtns[i] = MakeNavItem(data, i)
end

-- =====================
--      BUILD TABS
-- =====================

-- COMBAT
local CombatPanel = NewTabPanel("Combat")

local function MakeCardInPanel(panel, order)
    local card = New("Frame", {
        BackgroundColor3 = C.Card,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BorderSizePixel = 0,
        LayoutOrder = order or 0,
        Parent = panel,
    })
    Corner(7, card)
    Stroke(C.Border, 1, card)
    New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = card })
    return card
end

local function SecLabel(panel, text, order)
    local f = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 18),
        LayoutOrder = order or 0,
        Parent = panel,
    })
    New("TextLabel", {
        Text = text:upper(),
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextColor3 = C.Muted,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = f,
    })
end

-- Combat cards
SecLabel(CombatPanel, "Hitbox", 0)
local HitboxCard = MakeCardInPanel(CombatPanel, 1)
MakeToggle(HitboxCard, "Hitbox Expand", "Expand enemy hitboxes", 0, function(on)
    getgenv().HitboxStatus = on
    Tween(StatusDot, { BackgroundColor3 = on and C.Success or C.Muted2 })
    StatusText.Text = on and "ON" or "OFF"
    Tween(StatusText, { TextColor3 = on and C.Success or C.Muted })
    Notify("Hitbox Expander", on and "Enabled" or "Disabled", 2)
end)
MakeToggle(HitboxCard, "Team Check", "Ignore teammates", 1, function(on)
    getgenv().TeamCheck = on
end)
MakeSlider(HitboxCard, "Hitbox Size", 1, 50, 15, "", 2, function(v)
    getgenv().HitboxSize = v
end)
MakeSlider(HitboxCard, "Transparency", 0, 10, 9, "", 3, function(v)
    getgenv().HitboxTransparency = v / 10
end)

SecLabel(CombatPanel, "Extra", 2)
local ExtraCard = MakeCardInPanel(CombatPanel, 3)
MakeToggle(ExtraCard, "Infinite Jump", "Jump infinitely", 0, function(on)
    getgenv().InfiniteJump = on
end)
MakeToggle(ExtraCard, "No Clip", "Walk through walls", 1, function(on)
    getgenv().NoClip = on
end)
MakeToggle(ExtraCard, "Anti Fall Damage", "Ignore fall damage", 2, function(on)
    getgenv().AntiFall = on
end)

-- PLAYER
local PlayerPanel = NewTabPanel("Player")
SecLabel(PlayerPanel, "Movement", 0)
local MovCard = MakeCardInPanel(PlayerPanel, 1)
MakeSlider(MovCard, "Walk Speed", 0, 500, 16, " ws", 0, function(v)
    getgenv().Walkspeed = v
    if not LoopWS then pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = v end) end
end)
MakeToggle(MovCard, "Loop WalkSpeed", nil, 1, function(on)
    getgenv().LoopWS = on
end)
MakeSlider(MovCard, "Jump Power", 0, 500, 50, " jp", 2, function(v)
    getgenv().Jumppower = v
    if not LoopJP then pcall(function() LocalPlayer.Character.Humanoid.JumpPower = v end) end
end)
MakeToggle(MovCard, "Loop JumpPower", nil, 3, function(on)
    getgenv().LoopJP = on
end)

SecLabel(PlayerPanel, "Teleport", 2)
local TpCard = MakeCardInPanel(PlayerPanel, 3)
MakeSlider(TpCard, "TP Speed", 1, 20, 3, "", 0, function(v)
    getgenv().TPSpeed = v
end)
MakeToggle(TpCard, "TP Walk", nil, 1, function(on)
    getgenv().TPWalk = on
end)
MakeInput(TpCard, "Teleport to Player", "Enter username...", 2, function(name)
    local target = Players:FindFirstChild(name)
    if target and target.Character then
        local root = target.Character:FindFirstChild("HumanoidRootPart")
        local mine = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root and mine then
            mine.CFrame = root.CFrame + Vector3.new(3, 0, 0)
            Notify("Teleported", "→ " .. name, 3)
        end
    else
        Notify("Not Found", name .. " is not in the server", 3)
    end
end)

-- VISUALS
local VisualsPanel = NewTabPanel("Visuals")
SecLabel(VisualsPanel, "ESP", 0)
local EspCard = MakeCardInPanel(VisualsPanel, 1)
MakeToggle(EspCard, "ESP Enabled", nil, 0, function(on) getgenv().ESPEnabled = on end)
MakeToggle(EspCard, "Name Tags", nil, 1, function(on) getgenv().NameTags = on end)
MakeToggle(EspCard, "Health Bars", nil, 2, function(on) getgenv().HealthBars = on end)
MakeToggle(EspCard, "Team Color ESP", nil, 3, function(on) getgenv().TeamESP = on end)
MakeSlider(EspCard, "ESP Distance", 100, 2000, 500, " studs", 4, function(v) getgenv().ESPDistance = v end)

SecLabel(VisualsPanel, "Chams", 2)
local ChamsCard = MakeCardInPanel(VisualsPanel, 3)
MakeToggle(ChamsCard, "Chams Enabled", nil, 0, function(on) getgenv().ChamsEnabled = on end)

-- MISC
local MiscPanel = NewTabPanel("Misc")
SecLabel(MiscPanel, "Utilities", 0)
local UtilCard = MakeCardInPanel(MiscPanel, 1)
MakeButton(UtilCard, "Reset Character", "↺", 0, function()
    pcall(function() LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0 end)
end)
MakeButton(UtilCard, "Rejoin Server", "⟳", 1, function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)
MakeButton(UtilCard, "Show Player List", "👥", 2, function()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do table.insert(list, p.Name) end
    Notify("Players (" .. #list .. ")", table.concat(list, ", "), 6)
end)

SecLabel(MiscPanel, "Info", 2)
local InfoCard = MakeCardInPanel(MiscPanel, 3)
MakeToggle(InfoCard, "FateUI v2.1  ·  ! 54t0", "@Trazadev", 0, nil)

-- SETTINGS (basic)
local SettingsPanel = NewTabPanel("Settings")
SecLabel(SettingsPanel, "UI", 0)
local UiCard = MakeCardInPanel(SettingsPanel, 1)
MakeButton(UiCard, "Toggle UI Visibility", "👁", 0, function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- =====================
--       DRAGGING
-- =====================

local dragging, dragStart, startPos = false, nil, nil

SidebarHeader.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

ContentHeader.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- =====================
--      KEYBIND
-- =====================

local toggleKey = Enum.KeyCode.RightShift

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == toggleKey then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- =====================
--      MAIN LOOPS
-- =====================

-- Activate first tab
navBtns[1]:InvokeButton and navBtns[1]:InvokeButton() or navBtns[1].MouseButton1Click:Fire()

-- Hitbox
RunService.RenderStepped:Connect(function()
    if not HitboxStatus then
        for _, v in next, Players:GetPlayers() do
            if v ~= LocalPlayer then
                pcall(function()
                    v.Character.HumanoidRootPart.Size = Vector3.new(2,2,1)
                    v.Character.HumanoidRootPart.Transparency = 1
                    v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Medium stone grey")
                    v.Character.HumanoidRootPart.Material = Enum.Material.Plastic
                    v.Character.HumanoidRootPart.CanCollide = false
                end)
            end
        end
        return
    end
    for _, v in next, Players:GetPlayers() do
        if v ~= LocalPlayer then
            local pass = (not TeamCheck) or (LocalPlayer.Team ~= v.Team)
            if pass then
                pcall(function()
                    v.Character.HumanoidRootPart.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                    v.Character.HumanoidRootPart.Transparency = HitboxTransparency
                    v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really black")
                    v.Character.HumanoidRootPart.Material = Enum.Material.Neon
                    v.Character.HumanoidRootPart.CanCollide = false
                end)
            end
        end
    end
end)

-- Loop WS/JP
RunService.Heartbeat:Connect(function()
    pcall(function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if LoopWS then hum.WalkSpeed = Walkspeed end
        if LoopJP then hum.JumpPower = Jumppower end
    end)
end)

-- No Clip
RunService.Stepped:Connect(function()
    if NoClip and LocalPlayer.Character then
        for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if InfiniteJump then
        pcall(function()
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end)
    end
end)

-- FPS counter
local frames, last2 = 0, tick()
RunService.RenderStepped:Connect(function()
    frames += 1
    if tick() - last2 >= 0.5 then
        FPSLabel.Text = "FPS " .. math.round(frames / (tick() - last2))
        frames = 0
        last2 = tick()
    end
end)

-- Show first tab
showTab("Combat")
Notify("FateUI Loaded", "Made by ! 54t0  ·  RShift to toggle", 4)
