--[[
    XYRON UI LIBRARY
    Advanced • Smooth • Mobile-First • Black + Cyan
    Font: IBM Plex Mono (with fallback)
    
    Created for Roblox Script Hubs
    Vertical layout • Tabs on top • Scrollable • Minimizable
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- // Theme
local Theme = {
    Background = Color3.fromRGB(8, 8, 12),
    BackgroundSecondary = Color3.fromRGB(14, 14, 20),
    BackgroundTertiary = Color3.fromRGB(20, 20, 28),
    Accent = Color3.fromRGB(0, 220, 255),
    AccentDark = Color3.fromRGB(0, 160, 190),
    AccentGlow = Color3.fromRGB(0, 255, 255),
    Text = Color3.fromRGB(240, 245, 255),
    TextDim = Color3.fromRGB(140, 150, 170),
    Success = Color3.fromRGB(0, 255, 170),
    Warning = Color3.fromRGB(255, 200, 50),
    Error = Color3.fromRGB(255, 70, 90),
    Stroke = Color3.fromRGB(30, 35, 50),
}

-- // Font (IBM Plex Mono with safe fallback)
local function GetFont(weight)
    weight = weight or Enum.FontWeight.Regular
    local success, font = pcall(function()
        return Font.new("rbxasset://fonts/families/IBMPlexMono.json", weight)
    end)
    if success then return font end
    return Font.new("rbxasset://fonts/families/RobotoMono.json", weight) -- excellent fallback
end

local FontRegular = GetFont(Enum.FontWeight.Regular)
local FontMedium = GetFont(Enum.FontWeight.Medium)
local FontBold = GetFont(Enum.FontWeight.Bold)

-- // Utilities
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            inst[k] = v
        end
    end
    if props and props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

local function Tween(obj, props, duration, style, direction)
    local t = TweenService:Create(obj, TweenInfo.new(duration or 0.25, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function AddCorner(parent, radius)
    return Create("UICorner", {CornerRadius = UDim.new(0, radius or 8), Parent = parent})
end

local function AddStroke(parent, color, thickness, transparency)
    return Create("UIStroke", {
        Color = color or Theme.Accent,
        Thickness = thickness or 1,
        Transparency = transparency or 0.6,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
end

local function AddPadding(parent, t, b, l, r)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, t or 0),
        PaddingBottom = UDim.new(0, b or 0),
        PaddingLeft = UDim.new(0, l or 0),
        PaddingRight = UDim.new(0, r or 0),
        Parent = parent
    })
end

-- // Main Library
local XyronUI = {}
XyronUI.__index = XyronUI

function XyronUI.Create(config)
    config = config or {}
    local self = setmetatable({}, XyronUI)

    self.Title = config.Title or "XYRON HUB"
    self.Subtitle = config.Subtitle or "ROBLOX SCRIPT UI"
    self.Width = config.Width or 320
    self.Keybind = config.Keybind or Enum.KeyCode.RightShift
    self.Minimized = false
    self.Tabs = {}
    self.CurrentTab = nil
    self.Notifications = {}

    -- // ScreenGui
    self.Gui = Create("ScreenGui", {
        Name = "XyronHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = (gethui and gethui()) or CoreGui
    })

    -- // Main Container (mobile height constrained)
    self.Main = Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, self.Width, 0, 580),
        Position = UDim2.new(0.5, -self.Width/2, 0.5, -290),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = self.Gui
    })
    AddCorner(self.Main, 14)
    AddStroke(self.Main, Theme.Accent, 1.5, 0.55)

    -- Soft glow effect
    local glow = Create("ImageLabel", {
        Name = "Glow",
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = Theme.Accent,
        ImageTransparency = 0.85,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        Parent = self.Main
    })

    -- // Header
    self.Header = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = Theme.BackgroundSecondary,
        BorderSizePixel = 0,
        Parent = self.Main
    })
    AddCorner(self.Header, 14)
    -- Fix bottom corners of header
    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.new(0, 0, 1, -16),
        BackgroundColor3 = Theme.BackgroundSecondary,
        BorderSizePixel = 0,
        Parent = self.Header
    })

    local titleLabel = Create("TextLabel", {
        Size = UDim2.new(1, -80, 0, 22),
        Position = UDim2.new(0, 16, 0, 8),
        BackgroundTransparency = 1,
        Text = self.Title,
        TextColor3 = Theme.Accent,
        TextSize = 18,
        FontFace = FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Header
    })

    local subtitleLabel = Create("TextLabel", {
        Size = UDim2.new(1, -80, 0, 14),
        Position = UDim2.new(0, 16, 0, 30),
        BackgroundTransparency = 1,
        Text = self.Subtitle,
        TextColor3 = Theme.TextDim,
        TextSize = 11,
        FontFace = FontRegular,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Header
    })

    -- Minimize Button
    self.MinimizeBtn = Create("TextButton", {
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -40, 0, 12),
        BackgroundColor3 = Theme.BackgroundTertiary,
        Text = "—",
        TextColor3 = Theme.Text,
        TextSize = 16,
        FontFace = FontMedium,
        Parent = self.Header
    })
    AddCorner(self.MinimizeBtn, 6)
    AddStroke(self.MinimizeBtn, Theme.Stroke, 1, 0.4)

    self.MinimizeBtn.MouseEnter:Connect(function()
        Tween(self.MinimizeBtn, {BackgroundColor3 = Theme.AccentDark})
    end)
    self.MinimizeBtn.MouseLeave:Connect(function()
        Tween(self.MinimizeBtn, {BackgroundColor3 = Theme.BackgroundTertiary})
    end)

    -- // Tab Bar (horizontal scroll)
    self.TabBar = Create("ScrollingFrame", {
        Size = UDim2.new(1, -20, 0, 38),
        Position = UDim2.new(0, 10, 0, 58),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.X,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        Parent = self.Main
    })
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.TabBar
    })

    -- // Content Area (vertical scroll)
    self.Content = Create("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -160),
        Position = UDim2.new(0, 10, 0, 102),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        ScrollBarImageTransparency = 0.4,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = self.Main
    })
    Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.Content
    })
    AddPadding(self.Content, 4, 10, 0, 4)

    -- // Status Bar
    self.StatusBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        Position = UDim2.new(0, 0, 1, -36),
        BackgroundColor3 = Theme.BackgroundSecondary,
        BorderSizePixel = 0,
        Parent = self.Main
    })
    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundColor3 = Theme.BackgroundSecondary,
        BorderSizePixel = 0,
        Parent = self.StatusBar
    })
    AddCorner(self.StatusBar, 14)

    local statusLayout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 18),
        Parent = self.StatusBar
    })

    local function CreateStatusItem(icon, text)
        local frame = Create("Frame", {
            Size = UDim2.new(0, 70, 1, 0),
            BackgroundTransparency = 1,
            Parent = self.StatusBar
        })
        Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 12),
            Position = UDim2.new(0, 0, 0, 4),
            BackgroundTransparency = 1,
            Text = icon,
            TextColor3 = Theme.Accent,
            TextSize = 11,
            FontFace = FontMedium,
            Parent = frame
        })
        Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 12),
            Position = UDim2.new(0, 0, 0, 18),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = Theme.TextDim,
            TextSize = 10,
            FontFace = FontRegular,
            Parent = frame
        })
        return frame
    end

    self.FPSLabel = CreateStatusItem("FPS", "60")
    self.PingLabel = CreateStatusItem("PING", "42ms")
    self.PlayersLabel = CreateStatusItem("PLAYERS", #Players:GetPlayers() .. " / 30")
    self.TimeLabel = CreateStatusItem("TIME", "00:00")

    -- Live updates
    task.spawn(function()
        local last = tick()
        local frames = 0
        RunService.RenderStepped:Connect(function()
            frames += 1
            if tick() - last >= 1 then
                self.FPSLabel:FindFirstChildOfClass("TextLabel").Text = tostring(frames)
                frames = 0
                last = tick()
            end
        end)
    end)

    task.spawn(function()
        while self.Gui.Parent do
            local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
            self.PingLabel:FindFirstChildWhichIsA("TextLabel", true).Text = ping .. "ms"
            self.PlayersLabel:FindFirstChildWhichIsA("TextLabel", true).Text = #Players:GetPlayers() .. " / 30"
            self.TimeLabel:FindFirstChildWhichIsA("TextLabel", true).Text = os.date("%H:%M:%S")
            task.wait(1)
        end
    end)

    -- // Minimize Logic
    local originalSize = self.Main.Size
    local originalPos = self.Main.Position

    self.MinimizeBtn.MouseButton1Click:Connect(function()
        self.Minimized = not self.Minimized
        if self.Minimized then
            Tween(self.Main, {Size = UDim2.new(0, self.Width, 0, 52)}, 0.35)
            Tween(self.Content, {Visible = false}, 0.1)
            Tween(self.TabBar, {Visible = false}, 0.1)
            Tween(self.StatusBar, {Visible = false}, 0.1)
            self.MinimizeBtn.Text = "+"
        else
            self.Content.Visible = true
            self.TabBar.Visible = true
            self.StatusBar.Visible = true
            Tween(self.Main, {Size = originalSize}, 0.4)
            self.MinimizeBtn.Text = "—"
        end
    end)

    -- // Keybind Toggle
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == self.Keybind then
            self.Main.Visible = not self.Main.Visible
        end
    end)

    -- // Dragging
    local dragging, dragStart, startPos
    self.Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            self.Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- // Public API
    function self:AddTab(name, icon)
        local tabBtn = Create("TextButton", {
            Size = UDim2.new(0, 78, 0, 32),
            BackgroundColor3 = Theme.BackgroundTertiary,
            Text = (icon and (icon .. "  ") or "") .. name,
            TextColor3 = Theme.TextDim,
            TextSize = 12,
            FontFace = FontMedium,
            AutoButtonColor = false,
            Parent = self.TabBar
        })
        AddCorner(tabBtn, 8)
        AddStroke(tabBtn, Theme.Stroke, 1, 0.5)

        local page = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Visible = false,
            Parent = self.Content
        })
        Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = page
        })

        local tabData = {Button = tabBtn, Page = page, Name = name}
        table.insert(self.Tabs, tabData)

        tabBtn.MouseButton1Click:Connect(function()
            self:SelectTab(name)
        end)

        tabBtn.MouseEnter:Connect(function()
            if self.CurrentTab ~= name then
                Tween(tabBtn, {BackgroundColor3 = Color3.fromRGB(25, 30, 42)})
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if self.CurrentTab ~= name then
                Tween(tabBtn, {BackgroundColor3 = Theme.BackgroundTertiary})
            end
        end)

        if #self.Tabs == 1 then
            self:SelectTab(name)
        end

        return page
    end

    function self:SelectTab(name)
        for _, tab in ipairs(self.Tabs) do
            local selected = tab.Name == name
            tab.Page.Visible = selected
            Tween(tab.Button, {
                BackgroundColor3 = selected and Theme.Accent or Theme.BackgroundTertiary,
                TextColor3 = selected and Theme.Background or Theme.TextDim
            }, 0.25)
            if selected then
                self.CurrentTab = name
            end
        end
    end

    -- // COMPONENTS

    function self:AddSection(parent, title)
        local section = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Theme.BackgroundSecondary,
            Parent = parent
        })
        AddCorner(section, 10)
        AddStroke(section, Theme.Stroke, 1, 0.45)
        AddPadding(section, 10, 10, 12, 12)

        Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = section
        })

        if title then
            Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 18),
                BackgroundTransparency = 1,
                Text = title:upper(),
                TextColor3 = Theme.Accent,
                TextSize = 12,
                FontFace = FontBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = section
            })
        end
        return section
    end

    function self:AddLabel(parent, text)
        return Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = Theme.Text,
            TextSize = 13,
            FontFace = FontRegular,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = parent
        })
    end

    function self:AddButton(parent, text, callback)
        local btn = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = Theme.BackgroundTertiary,
            Text = text,
            TextColor3 = Theme.Text,
            TextSize = 13,
            FontFace = FontMedium,
            AutoButtonColor = false,
            Parent = parent
        })
        AddCorner(btn, 8)
        local stroke = AddStroke(btn, Theme.Accent, 1.2, 0.55)

        btn.MouseEnter:Connect(function()
            Tween(btn, {BackgroundColor3 = Theme.AccentDark})
            Tween(stroke, {Transparency = 0.2})
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, {BackgroundColor3 = Theme.BackgroundTertiary})
            Tween(stroke, {Transparency = 0.55})
        end)
        btn.MouseButton1Click:Connect(function()
            Tween(btn, {BackgroundColor3 = Theme.Accent}, 0.1)
            task.wait(0.1)
            Tween(btn, {BackgroundColor3 = Theme.AccentDark}, 0.15)
            if callback then callback() end
        end)
        return btn
    end

    function self:AddToggle(parent, text, default, callback)
        local frame = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundTransparency = 1,
            Parent = parent
        })

        Create("TextLabel", {
            Size = UDim2.new(1, -55, 1, 0),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = Theme.Text,
            TextSize = 13,
            FontFace = FontRegular,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = frame
        })

        local toggle = Create("Frame", {
            Size = UDim2.new(0, 44, 0, 24),
            Position = UDim2.new(1, -44, 0.5, -12),
            BackgroundColor3 = default and Theme.Accent or Theme.BackgroundTertiary,
            Parent = frame
        })
        AddCorner(toggle, 12)
        AddStroke(toggle, Theme.Stroke, 1, 0.4)

        local circle = Create("Frame", {
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, default and 23 or 3, 0.5, -9),
            BackgroundColor3 = Theme.Text,
            Parent = toggle
        })
        AddCorner(circle, 9)

        local state = default
        local btn = Create("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            Parent = frame
        })

        btn.MouseButton1Click:Connect(function()
            state = not state
            Tween(toggle, {BackgroundColor3 = state and Theme.Accent or Theme.BackgroundTertiary}, 0.25)
            Tween(circle, {Position = UDim2.new(0, state and 23 or 3, 0.5, -9)}, 0.25)
            if callback then callback(state) end
        end)

        return {
            Set = function(v)
                state = v
                Tween(toggle, {BackgroundColor3 = state and Theme.Accent or Theme.BackgroundTertiary}, 0.25)
                Tween(circle, {Position = UDim2.new(0, state and 23 or 3, 0.5, -9)}, 0.25)
            end,
            Get = function() return state end
        }
    end

    function self:AddSlider(parent, text, min, max, default, callback)
        local frame = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 48),
            BackgroundTransparency = 1,
            Parent = parent
        })

        local valueLabel = Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundTransparency = 1,
            Text = text .. ": " .. tostring(default),
            TextColor3 = Theme.Text,
            TextSize = 13,
            FontFace = FontRegular,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = frame
        })

        local barBg = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 8),
            Position = UDim2.new(0, 0, 0, 28),
            BackgroundColor3 = Theme.BackgroundTertiary,
            Parent = frame
        })
        AddCorner(barBg, 4)

        local barFill = Create("Frame", {
            Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
            BackgroundColor3 = Theme.Accent,
            Parent = barBg
        })
        AddCorner(barFill, 4)

        local handle = Create("Frame", {
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8),
            BackgroundColor3 = Theme.Text,
            Parent = barBg
        })
        AddCorner(handle, 8)
        AddStroke(handle, Theme.Accent, 1.5, 0.3)

        local sliding = false
        local function update(input)
            local rel = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * rel + 0.5)
            barFill.Size = UDim2.new(rel, 0, 1, 0)
            handle.Position = UDim2.new(rel, -8, 0.5, -8)
            valueLabel.Text = text .. ": " .. val
            if callback then callback(val) end
        end

        barBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliding = true
                update(input)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliding = false
            end
        end)

        return {
            Set = function(v)
                v = math.clamp(v, min, max)
                local rel = (v - min) / (max - min)
                barFill.Size = UDim2.new(rel, 0, 1, 0)
                handle.Position = UDim2.new(rel, -8, 0.5, -8)
                valueLabel.Text = text .. ": " .. v
            end
        }
    end

    function self:AddDropdown(parent, text, options, default, callback)
        local frame = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundTransparency = 1,
            ClipsDescendants = false,
            Parent = parent
        })

        Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 16),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = Theme.TextDim,
            TextSize = 11,
            FontFace = FontRegular,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = frame
        })

        local selected = default or options[1]
        local open = false

        local dropBtn = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 32),
            Position = UDim2.new(0, 0, 0, 18),
            BackgroundColor3 = Theme.BackgroundTertiary,
            Text = "  " .. selected,
            TextColor3 = Theme.Text,
            TextSize = 13,
            FontFace = FontRegular,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            Parent = frame
        })
        AddCorner(dropBtn, 8)
        AddStroke(dropBtn, Theme.Stroke, 1, 0.45)

        local arrow = Create("TextLabel", {
            Size = UDim2.new(0, 24, 1, 0),
            Position = UDim2.new(1, -28, 0, 0),
            BackgroundTransparency = 1,
            Text = "▼",
            TextColor3 = Theme.Accent,
            TextSize = 10,
            FontFace = FontRegular,
            Parent = dropBtn
        })

        local list = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            Position = UDim2.new(0, 0, 0, 54),
            BackgroundColor3 = Theme.BackgroundSecondary,
            Visible = false,
            ZIndex = 10,
            Parent = frame
        })
        AddCorner(list, 8)
        AddStroke(list, Theme.Accent, 1, 0.5)
        Create("UIListLayout", {Padding = UDim.new(0, 2), Parent = list})
        AddPadding(list, 4, 4, 4, 4)

        for _, opt in ipairs(options) do
            local optBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundColor3 = Theme.BackgroundTertiary,
                Text = "  " .. opt,
                TextColor3 = Theme.Text,
                TextSize = 12,
                FontFace = FontRegular,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false,
                ZIndex = 11,
                Parent = list
            })
            AddCorner(optBtn, 6)
            optBtn.MouseEnter:Connect(function()
                Tween(optBtn, {BackgroundColor3 = Theme.AccentDark})
            end)
            optBtn.MouseLeave:Connect(function()
                Tween(optBtn, {BackgroundColor3 = Theme.BackgroundTertiary})
            end)
            optBtn.MouseButton1Click:Connect(function()
                selected = opt
                dropBtn.Text = "  " .. selected
                open = false
                list.Visible = false
                frame.Size = UDim2.new(1, 0, 0, 36)
                if callback then callback(selected) end
            end)
        end

        dropBtn.MouseButton1Click:Connect(function()
            open = not open
            list.Visible = open
            frame.Size = open and UDim2.new(1, 0, 0, 36 + (#options * 30 + 12)) or UDim2.new(1, 0, 0, 36)
            arrow.Text = open and "▲" or "▼"
        end)

        return {
            Set = function(v)
                selected = v
                dropBtn.Text = "  " .. selected
            end,
            Get = function() return selected end
        }
    end

    function self:AddInput(parent, placeholder, callback)
        local box = Create("TextBox", {
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = Theme.BackgroundTertiary,
            Text = "",
            PlaceholderText = placeholder or "Enter text...",
            PlaceholderColor3 = Theme.TextDim,
            TextColor3 = Theme.Text,
            TextSize = 13,
            FontFace = FontRegular,
            ClearTextOnFocus = false,
            Parent = parent
        })
        AddCorner(box, 8)
        AddStroke(box, Theme.Stroke, 1, 0.45)
        AddPadding(box, 0, 0, 12, 12)

        box.Focused:Connect(function()
            Tween(box:FindFirstChildOfClass("UIStroke"), {Color = Theme.Accent, Transparency = 0.2}, 0.2)
        end)
        box.FocusLost:Connect(function(enter)
            Tween(box:FindFirstChildOfClass("UIStroke"), {Color = Theme.Stroke, Transparency = 0.45}, 0.2)
            if enter and callback then callback(box.Text) end
        end)
        return box
    end

    function self:AddKeybind(parent, text, default, callback)
        local frame = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundTransparency = 1,
            Parent = parent
        })

        Create("TextLabel", {
            Size = UDim2.new(0.5, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = Theme.Text,
            TextSize = 13,
            FontFace = FontRegular,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = frame
        })

        local keyBtn = Create("TextButton", {
            Size = UDim2.new(0, 90, 0, 26),
            Position = UDim2.new(1, -90, 0.5, -13),
            BackgroundColor3 = Theme.BackgroundTertiary,
            Text = default and default.Name or "None",
            TextColor3 = Theme.Accent,
            TextSize = 12,
            FontFace = FontMedium,
            AutoButtonColor = false,
            Parent = frame
        })
        AddCorner(keyBtn, 6)
        AddStroke(keyBtn, Theme.Stroke, 1, 0.4)

        local listening = false
        keyBtn.MouseButton1Click:Connect(function()
            listening = true
            keyBtn.Text = "..."
            Tween(keyBtn, {BackgroundColor3 = Theme.AccentDark})
        end)

        local conn
        conn = UserInputService.InputBegan:Connect(function(input)
            if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                listening = false
                keyBtn.Text = input.KeyCode.Name
                Tween(keyBtn, {BackgroundColor3 = Theme.BackgroundTertiary})
                if callback then callback(input.KeyCode) end
            end
        end)

        return keyBtn
    end

    function self:Notify(title, message, duration)
        duration = duration or 3
        local notif = Create("Frame", {
            Size = UDim2.new(0, 280, 0, 0),
            Position = UDim2.new(1, -300, 1, -80),
            BackgroundColor3 = Theme.BackgroundSecondary,
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = self.Gui
        })
        AddCorner(notif, 10)
        AddStroke(notif, Theme.Accent, 1.5, 0.4)
        AddPadding(notif, 12, 12, 14, 14)

        Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = Theme.Accent,
            TextSize = 14,
            FontFace = FontBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = notif
        })
        Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Text = message,
            TextColor3 = Theme.Text,
            TextSize = 12,
            FontFace = FontRegular,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = notif
        })

        notif.Position = UDim2.new(1, 20, 1, -80)
        Tween(notif, {Position = UDim2.new(1, -300, 1, -80)}, 0.4)

        task.delay(duration, function()
            Tween(notif, {Position = UDim2.new(1, 20, 1, -80)}, 0.35)
            task.wait(0.4)
            notif:Destroy()
        end)
    end

    -- // Startup Animation
    self.Main.Size = UDim2.new(0, self.Width, 0, 0)
    self.Main.BackgroundTransparency = 1
    Tween(self.Main, {Size = originalSize, BackgroundTransparency = 0}, 0.55, Enum.EasingStyle.Back)

    return self
end

-- // DEMO (remove or comment out in production)
local UI = XyronUI.Create({
    Title = "XYRON HUB",
    Subtitle = "ADVANCED SCRIPT UI",
    Width = 320,
    Keybind = Enum.KeyCode.RightShift
})

local mainTab = UI:AddTab("Main", "⌂")
local playerTab = UI:AddTab("Player", "👤")
local worldTab = UI:AddTab("World", "🌐")
local miscTab = UI:AddTab("Misc", "⚙")
local settingsTab = UI:AddTab("Settings", "🔧")

-- Main Tab Demo
local sec1 = UI:AddSection(mainTab, "Actions")
UI:AddButton(sec1, "▶  Execute Script", function()
    UI:Notify("Success", "Script executed successfully!", 3)
end)
UI:AddButton(sec1, "Clear Output", function() end)

local sec2 = UI:AddSection(mainTab, "Options")
UI:AddToggle(sec2, "Auto Farm", true, function(v) print("Auto Farm:", v) end)
UI:AddToggle(sec2, "Auto Collect", true)
UI:AddToggle(sec2, "God Mode", true)
UI:AddToggle(sec2, "Noclip", false)
UI:AddToggle(sec2, "Infinite Jump", true)

local sec3 = UI:AddSection(mainTab, "Movement")
UI:AddSlider(sec3, "WalkSpeed", 16, 500, 100, function(v) print(v) end)
UI:AddSlider(sec3, "JumpPower", 0, 200, 50)

UI:AddDropdown(sec3, "Select Mode", {"Normal", "Combat", "Farm", "PvP"}, "Normal")
UI:AddInput(sec3, "Enter custom value...")
UI:AddKeybind(sec3, "UI Toggle Keybind", Enum.KeyCode.RightShift)

-- Player Tab
local pSec = UI:AddSection(playerTab, "Player Mods")
UI:AddToggle(pSec, "Infinite Health", false)
UI:AddSlider(pSec, "Health", 1, 1000, 100)
UI:AddButton(pSec, "Reset Character")

print("[Xyron UI] Loaded successfully • Black + Cyan • IBM Plex Mono")

return XyronUI
