--==============================================================
-- FLOWERHUB UI LIBRARY
-- Crimson • Black • Mobile Friendly
--==============================================================
-- Reusable library version of the original FlowerHub UI.
--
-- Usage:
-- local FlowerHub = loadstring(game:HttpGet("YOUR_URL"))()
-- local Window = FlowerHub:CreateWindow({
--     Title = "FlowerHub",
--     Size = UDim2.fromOffset(250, 350)
-- })
--
-- Window:AddButton("Execute", function() print("Clicked") end)
-- Window:AddToggle("Auto Farm", false, function(v) print(v) end)
-- Window:AddInput("Speed", "16", function(v) print(v) end)
-- Window:AddDropdown("Mode", {"Normal","Fast"}, "Normal", function(v) print(v) end)
-- Window:AddMultiDropdown("Targets", {"Flowers","Coins"}, {"Flowers"}, function(v) end)
-- Window:AddSlider("Walk Speed", 16, 100, 16, function(v) print(v) end)
--
-- Window:Destroy()
--==============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local FlowerHub = {}
FlowerHub.__index = FlowerHub

--==============================================================
-- COLORS
--==============================================================

local CRIMSON = Color3.fromRGB(220, 20, 60)
local CRIMSON_DARK = Color3.fromRGB(170, 15, 45)

local BG = Color3.fromRGB(17, 17, 20)
local PANEL = Color3.fromRGB(24, 24, 28)
local ELEMENT = Color3.fromRGB(30, 30, 35)
local ELEMENT_HOVER = Color3.fromRGB(40, 40, 47)

local DROPDOWN_BG = Color3.fromRGB(23, 23, 27)
local SELECTED_BG = Color3.fromRGB(45, 25, 35)

local TEXT = Color3.fromRGB(240, 240, 245)
local SUBTEXT = Color3.fromRGB(155, 155, 165)
local OUTLINE = Color3.fromRGB(55, 55, 62)

local function Tween(instance, properties, duration)
    return TweenService:Create(
        instance,
        TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        properties
    )
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 7)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or OUTLINE
    stroke.Thickness = thickness or 1
    stroke.Parent = parent
    return stroke
end

--==============================================================
-- WINDOW
--==============================================================

function FlowerHub:CreateWindow(config)
    config = config or {}

    local self = setmetatable({}, FlowerHub)

    self.Title = config.Title or "FlowerHub"
    self.Size = config.Size or UDim2.fromOffset(250, 350)
    self.Position = config.Position or UDim2.new(0.5, -125, 0.5, -175)
    self.Parent = config.Parent or LocalPlayer:WaitForChild("PlayerGui")
    self.Destroyed = false
    self.Minimized = false
    self.OpenDropdown = nil
    self.NormalSize = self.Size

    --==========================================================
    -- SCREEN GUI
    --==========================================================

    local gui = Instance.new("ScreenGui")
    gui.Name = config.Name or "FlowerHub"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = self.Parent

    self.Gui = gui

    --==========================================================
    -- MAIN
    --==========================================================

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = self.Size
    Main.Position = self.Position
    Main.BackgroundColor3 = BG
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = false
    Main.Parent = gui

    CreateCorner(Main, 10)
    CreateStroke(Main, OUTLINE, 1)

    self.Main = Main

    --==========================================================
    -- DROPDOWN OVERLAY
    --==========================================================

    local Overlay = Instance.new("Frame")
    Overlay.Name = "DropdownOverlay"
    Overlay.Size = UDim2.fromScale(1, 1)
    Overlay.BackgroundTransparency = 1
    Overlay.BorderSizePixel = 0
    Overlay.ZIndex = 100
    Overlay.Parent = gui

    self.Overlay = Overlay

    --==========================================================
    -- TOP BAR
    --==========================================================

    local Top = Instance.new("Frame")
    Top.Name = "TopBar"
    Top.Size = UDim2.new(1, 0, 0, 38)
    Top.BackgroundColor3 = PANEL
    Top.BorderSizePixel = 0
    Top.Parent = Main

    CreateCorner(Top, 10)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -75, 1, 0)
    Title.Position = UDim2.fromOffset(12, 0)
    Title.BackgroundTransparency = 1
    Title.Text = self.Title
    Title.TextColor3 = TEXT
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Top

    self.TitleLabel = Title
    self.Top = Top

    --==========================================================
    -- MINIMIZE
    --==========================================================

    local Minimize = Instance.new("TextButton")
    Minimize.Size = UDim2.fromOffset(28, 28)
    Minimize.Position = UDim2.new(1, -63, 0, 5)
    Minimize.BackgroundTransparency = 1
    Minimize.BorderSizePixel = 0
    Minimize.Text = "−"
    Minimize.TextColor3 = SUBTEXT
    Minimize.TextSize = 16
    Minimize.Font = Enum.Font.GothamBold
    Minimize.AutoButtonColor = false
    Minimize.Parent = Top

    self.MinimizeButton = Minimize

    --==========================================================
    -- CLOSE
    --==========================================================

    local Close = Instance.new("TextButton")
    Close.Size = UDim2.fromOffset(28, 28)
    Close.Position = UDim2.new(1, -32, 0, 5)
    Close.BackgroundTransparency = 1
    Close.BorderSizePixel = 0
    Close.Text = "×"
    Close.TextColor3 = Color3.fromRGB(225, 95, 105)
    Close.TextSize = 20
    Close.Font = Enum.Font.GothamBold
    Close.AutoButtonColor = false
    Close.Parent = Top

    self.CloseButton = Close

    --==========================================================
    -- CONTENT
    --==========================================================

    local Content = Instance.new("ScrollingFrame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -12, 1, -48)
    Content.Position = UDim2.fromOffset(6, 44)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.ScrollBarThickness = 4
    Content.ScrollBarImageColor3 = CRIMSON
    Content.ScrollBarImageTransparency = 0.2
    Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Content.CanvasSize = UDim2.new()
    Content.ClipsDescendants = true
    Content.Parent = Main

    self.Content = Content

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 7)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Content

    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingLeft = UDim.new(0, 2)
    UIPadding.PaddingRight = UDim.new(0, 4)
    UIPadding.PaddingTop = UDim.new(0, 2)
    UIPadding.PaddingBottom = UDim.new(0, 6)
    UIPadding.Parent = Content

    --==========================================================
    -- HELPERS
    --==========================================================

    function self:_CreateContainer(height)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, height)
        Frame.BackgroundColor3 = ELEMENT
        Frame.BorderSizePixel = 0
        Frame.Parent = Content
        CreateCorner(Frame, 7)
        return Frame
    end

    function self:_CloseActiveDropdown()
        if self.OpenDropdown and self.OpenDropdown.Close then
            self.OpenDropdown.Close()
        end
        self.OpenDropdown = nil
    end

    function self:_CreateArrow(parent)
        local Arrow = Instance.new("Frame")
        Arrow.Name = "Arrow"
        Arrow.Size = UDim2.fromOffset(12, 12)
        Arrow.Position = UDim2.new(1, -20, 0.5, -6)
        Arrow.BackgroundTransparency = 1
        Arrow.BorderSizePixel = 0
        Arrow.Parent = parent

        local Left = Instance.new("Frame")
        Left.Size = UDim2.fromOffset(6, 2)
        Left.Position = UDim2.fromOffset(2, 6)
        Left.BackgroundColor3 = SUBTEXT
        Left.BorderSizePixel = 0
        Left.Rotation = 45
        Left.AnchorPoint = Vector2.new(0.5, 0.5)
        Left.Parent = Arrow

        local Right = Instance.new("Frame")
        Right.Size = UDim2.fromOffset(6, 2)
        Right.Position = UDim2.fromOffset(6, 6)
        Right.BackgroundColor3 = SUBTEXT
        Right.BorderSizePixel = 0
        Right.Rotation = -45
        Right.AnchorPoint = Vector2.new(0.5, 0.5)
        Right.Parent = Arrow

        return Arrow
    end

    local function SetArrow(Arrow, opened)
        Tween(Arrow, {Rotation = opened and 180 or 0}, 0.15):Play()
    end

    -- Keep dropdowns aligned while the content scrolls.
    Content:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        if self.OpenDropdown and self.OpenDropdown.UpdatePos then
            self.OpenDropdown.UpdatePos()
        end
    end)

    --==========================================================
    -- BUTTON
    --==========================================================

    function self:AddButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 36)
        Button.BackgroundColor3 = CRIMSON
        Button.BorderSizePixel = 0
        Button.Text = text
        Button.TextColor3 = Color3.new(1, 1, 1)
        Button.TextSize = 13
        Button.Font = Enum.Font.GothamBold
        Button.AutoButtonColor = false
        Button.Parent = Content

        CreateCorner(Button, 7)

        Button.MouseEnter:Connect(function()
            Tween(Button, {BackgroundColor3 = CRIMSON_DARK}, 0.12):Play()
        end)

        Button.MouseLeave:Connect(function()
            Tween(Button, {BackgroundColor3 = CRIMSON}, 0.12):Play()
        end)

        Button.MouseButton1Click:Connect(function()
            self:_CloseActiveDropdown()
            if callback then
                callback()
            end
        end)

        return Button
    end

    --==========================================================
    -- TOGGLE
    --==========================================================

    function self:AddToggle(text, default, callback)
        local Frame = self:_CreateContainer(40)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -65, 1, 0)
        Label.Position = UDim2.fromOffset(12, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = TEXT
        Label.TextSize = 13
        Label.Font = Enum.Font.GothamMedium
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        local Toggle = Instance.new("TextButton")
        Toggle.Size = UDim2.fromOffset(38, 20)
        Toggle.Position = UDim2.new(1, -48, 0.5, -10)
        Toggle.BackgroundColor3 = default and CRIMSON or Color3.fromRGB(55, 55, 60)
        Toggle.BorderSizePixel = 0
        Toggle.Text = ""
        Toggle.AutoButtonColor = false
        Toggle.Parent = Frame

        CreateCorner(Toggle, 20)

        local Circle = Instance.new("Frame")
        Circle.Size = UDim2.fromOffset(16, 16)
        Circle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.fromOffset(2, 2)
        Circle.BackgroundColor3 = Color3.new(1, 1, 1)
        Circle.BorderSizePixel = 0
        Circle.Parent = Toggle
        CreateCorner(Circle, 20)

        local state = default == true

        local function Apply(value, animate)
            state = value == true

            local bg = state and CRIMSON or Color3.fromRGB(55, 55, 60)
            local pos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.fromOffset(2, 2)

            if animate then
                Tween(Toggle, {BackgroundColor3 = bg}, 0.15):Play()
                Tween(Circle, {Position = pos}, 0.15):Play()
            else
                Toggle.BackgroundColor3 = bg
                Circle.Position = pos
            end
        end

        Toggle.MouseButton1Click:Connect(function()
            self:_CloseActiveDropdown()
            Apply(not state, true)
            if callback then
                callback(state)
            end
        end)

        local control = {}

        function control:Set(value, fireCallback)
            Apply(value, true)
            if fireCallback and callback then
                callback(state)
            end
        end

        function control:Get()
            return state
        end

        control.Instance = Frame
        return control
    end

    --==========================================================
    -- INPUT
    --==========================================================

    function self:AddInput(text, placeholder, callback)
        local Frame = self:_CreateContainer(40)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.5, -10, 1, 0)
        Label.Position = UDim2.fromOffset(12, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = TEXT
        Label.TextSize = 13
        Label.Font = Enum.Font.GothamMedium
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        local InputBg = Instance.new("Frame")
        InputBg.Size = UDim2.new(0.5, -12, 0, 26)
        InputBg.Position = UDim2.new(0.5, 0, 0.5, -13)
        InputBg.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        InputBg.BorderSizePixel = 0
        InputBg.Parent = Frame
        CreateCorner(InputBg, 5)

        local InputStroke = CreateStroke(InputBg, Color3.fromRGB(50, 50, 58), 1)

        local TextBox = Instance.new("TextBox")
        TextBox.Size = UDim2.new(1, -10, 1, 0)
        TextBox.Position = UDim2.fromOffset(5, 0)
        TextBox.BackgroundTransparency = 1
        TextBox.Text = ""
        TextBox.PlaceholderText = placeholder or "Value..."
        TextBox.PlaceholderColor3 = SUBTEXT
        TextBox.TextColor3 = TEXT
        TextBox.TextSize = 12
        TextBox.Font = Enum.Font.GothamMedium
        TextBox.TextXAlignment = Enum.TextXAlignment.Center
        TextBox.ClearTextOnFocus = false
        TextBox.Parent = InputBg

        TextBox.Focused:Connect(function()
            self:_CloseActiveDropdown()
            Tween(InputStroke, {Color = CRIMSON}, 0.15):Play()
        end)

        TextBox.FocusLost:Connect(function(enterPressed)
            Tween(InputStroke, {Color = Color3.fromRGB(50, 50, 58)}, 0.15):Play()
            if callback then
                callback(TextBox.Text, enterPressed)
            end
        end)

        local control = {}

        function control:Get()
            return TextBox.Text
        end

        function control:Set(value)
            TextBox.Text = tostring(value)
        end

        function control:Focus()
            TextBox:CaptureFocus()
        end

        control.Instance = Frame
        control.TextBox = TextBox
        return control
    end

    --==========================================================
    -- SINGLE DROPDOWN
    --==========================================================

    function self:AddDropdown(text, options, default, callback)
        options = options or {}

        local Frame = self:_CreateContainer(38)

        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -8, 1, -8)
        Button.Position = UDim2.fromOffset(4, 4)
        Button.BackgroundTransparency = 1
        Button.BorderSizePixel = 0
        Button.Text = ""
        Button.AutoButtonColor = false
        Button.Parent = Frame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.5, 0, 1, 0)
        Label.Position = UDim2.fromOffset(8, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = TEXT
        Label.TextSize = 13
        Label.Font = Enum.Font.GothamMedium
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Button

        local selected = default or options[1] or "None"

        local Value = Instance.new("TextLabel")
        Value.Size = UDim2.new(0.5, -30, 1, 0)
        Value.Position = UDim2.new(0.5, 0, 0, 0)
        Value.BackgroundTransparency = 1
        Value.Text = tostring(selected)
        Value.TextColor3 = CRIMSON
        Value.TextSize = 12
        Value.Font = Enum.Font.GothamMedium
        Value.TextXAlignment = Enum.TextXAlignment.Right
        Value.TextTruncate = Enum.TextTruncate.AtEnd
        Value.Parent = Button

        local Arrow = self:_CreateArrow(Button)
        local itemHeight = 28
        local maxHeight = math.min(#options * itemHeight, 112)

        local List = Instance.new("ScrollingFrame")
        List.Name = "Dropdown"
        List.Size = UDim2.fromOffset(Frame.AbsoluteSize.X, maxHeight)
        List.BackgroundColor3 = DROPDOWN_BG
        List.BorderSizePixel = 0
        List.ScrollBarThickness = 3
        List.ScrollBarImageColor3 = CRIMSON
        List.CanvasSize = UDim2.fromOffset(0, #options * itemHeight)
        List.Visible = false
        List.ZIndex = 110
        List.ClipsDescendants = true
        List.Parent = Overlay

        CreateCorner(List, 7)
        CreateStroke(List, OUTLINE, 1)

        local ListLayout = Instance.new("UIListLayout")
        ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ListLayout.Parent = List

        local optionButtons = {}
        local dropdownRef = {}

        function dropdownRef.UpdatePos()
            List.Size = UDim2.fromOffset(Frame.AbsoluteSize.X, maxHeight)
            List.Position = UDim2.fromOffset(
                Frame.AbsolutePosition.X,
                Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y + 4
            )
        end

        function dropdownRef.Close()
            List.Visible = false
            SetArrow(Arrow, false)
            if self.OpenDropdown == dropdownRef then
                self.OpenDropdown = nil
            end
        end

        local function ApplySelection(option, fireCallback)
            selected = option
            Value.Text = tostring(option)

            for name, btn in pairs(optionButtons) do
                local active = name == selected
                btn.BackgroundColor3 = active and SELECTED_BG or DROPDOWN_BG
                btn.TextColor3 = active and CRIMSON or TEXT
            end

            if fireCallback and callback then
                callback(option)
            end
        end

        for _, option in ipairs(options) do
            local isSelected = option == selected

            local Option = Instance.new("TextButton")
            Option.Size = UDim2.new(1, 0, 0, itemHeight)
            Option.BackgroundColor3 = isSelected and SELECTED_BG or DROPDOWN_BG
            Option.BorderSizePixel = 0
            Option.Text = tostring(option)
            Option.TextColor3 = isSelected and CRIMSON or TEXT
            Option.TextSize = 12
            Option.Font = Enum.Font.GothamMedium
            Option.TextXAlignment = Enum.TextXAlignment.Left
            Option.AutoButtonColor = false
            Option.ZIndex = 111
            Option.Parent = List

            local Padding = Instance.new("UIPadding")
            Padding.PaddingLeft = UDim.new(0, 12)
            Padding.Parent = Option

            optionButtons[option] = Option

            Option.MouseEnter:Connect(function()
                if option ~= selected then
                    Tween(Option, {BackgroundColor3 = ELEMENT_HOVER}, 0.1):Play()
                end
            end)

            Option.MouseLeave:Connect(function()
                if option ~= selected then
                    Tween(Option, {BackgroundColor3 = DROPDOWN_BG}, 0.1):Play()
                end
            end)

            Option.MouseButton1Click:Connect(function()
                ApplySelection(option, true)
                dropdownRef.Close()
            end)
        end

        Button.MouseButton1Click:Connect(function()
            if List.Visible then
                dropdownRef.Close()
            else
                self:_CloseActiveDropdown()
                dropdownRef.UpdatePos()
                List.Visible = true
                SetArrow(Arrow, true)
                self.OpenDropdown = dropdownRef
            end
        end)

        local control = {}

        function control:Get()
            return selected
        end

        function control:Set(value, fireCallback)
            for _, option in ipairs(options) do
                if option == value then
                    ApplySelection(value, fireCallback == true)
                    return true
                end
            end
            return false
        end

        function control:Open()
            self:_CloseActiveDropdown()
            dropdownRef.UpdatePos()
            List.Visible = true
            SetArrow(Arrow, true)
            self.OpenDropdown = dropdownRef
        end

        function control:Close()
            dropdownRef.Close()
        end

        control.Instance = Frame
        control.Dropdown = List
        return control
    end

    --==========================================================
    -- MULTI DROPDOWN
    --==========================================================

    function self:AddMultiDropdown(text, options, defaults, callback)
        options = options or {}

        local Frame = self:_CreateContainer(38)

        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, -8, 1, -8)
        Button.Position = UDim2.fromOffset(4, 4)
        Button.BackgroundTransparency = 1
        Button.BorderSizePixel = 0
        Button.Text = ""
        Button.AutoButtonColor = false
        Button.Parent = Frame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.55, 0, 1, 0)
        Label.Position = UDim2.fromOffset(8, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = TEXT
        Label.TextSize = 13
        Label.Font = Enum.Font.GothamMedium
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Button

        local Value = Instance.new("TextLabel")
        Value.Size = UDim2.new(0.45, -30, 1, 0)
        Value.Position = UDim2.new(0.55, 0, 0, 0)
        Value.BackgroundTransparency = 1
        Value.Text = "0 selected"
        Value.TextColor3 = CRIMSON
        Value.TextSize = 12
        Value.Font = Enum.Font.GothamMedium
        Value.TextXAlignment = Enum.TextXAlignment.Right
        Value.Parent = Button

        local Arrow = self:_CreateArrow(Button)
        local itemHeight = 28
        local maxHeight = math.min(#options * itemHeight, 112)

        local List = Instance.new("ScrollingFrame")
        List.Name = "MultiDropdown"
        List.Size = UDim2.fromOffset(Frame.AbsoluteSize.X, maxHeight)
        List.BackgroundColor3 = DROPDOWN_BG
        List.BorderSizePixel = 0
        List.ScrollBarThickness = 3
        List.ScrollBarImageColor3 = CRIMSON
        List.CanvasSize = UDim2.fromOffset(0, #options * itemHeight)
        List.Visible = false
        List.ZIndex = 110
        List.ClipsDescendants = true
        List.Parent = Overlay

        CreateCorner(List, 7)
        CreateStroke(List, OUTLINE, 1)

        local ListLayout = Instance.new("UIListLayout")
        ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ListLayout.Parent = List

        local selected = {}

        for _, value in ipairs(defaults or {}) do
            selected[value] = true
        end

        local optionButtons = {}
        local dropdownRef = {}

        local function CountSelected()
            local count = 0
            for _, value in pairs(selected) do
                if value then
                    count += 1
                end
            end
            return count
        end

        local function Update(fireCallback)
            Value.Text = tostring(CountSelected()) .. " selected"

            if fireCallback and callback then
                callback(selected)
            end
        end

        function dropdownRef.UpdatePos()
            List.Size = UDim2.fromOffset(Frame.AbsoluteSize.X, maxHeight)
            List.Position = UDim2.fromOffset(
                Frame.AbsolutePosition.X,
                Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y + 4
            )
        end

        function dropdownRef.Close()
            List.Visible = false
            SetArrow(Arrow, false)
            if self.OpenDropdown == dropdownRef then
                self.OpenDropdown = nil
            end
        end

        for _, option in ipairs(options) do
            local isSelected = selected[option] == true

            local Option = Instance.new("TextButton")
            Option.Size = UDim2.new(1, 0, 0, itemHeight)
            Option.BackgroundColor3 = isSelected and SELECTED_BG or DROPDOWN_BG
            Option.BorderSizePixel = 0
            Option.Text = tostring(option)
            Option.TextColor3 = isSelected and CRIMSON or TEXT
            Option.TextSize = 12
            Option.Font = Enum.Font.GothamMedium
            Option.TextXAlignment = Enum.TextXAlignment.Left
            Option.AutoButtonColor = false
            Option.ZIndex = 111
            Option.Parent = List

            local Padding = Instance.new("UIPadding")
            Padding.PaddingLeft = UDim.new(0, 12)
            Padding.Parent = Option

            optionButtons[option] = Option

            Option.MouseEnter:Connect(function()
                if not selected[option] then
                    Tween(Option, {BackgroundColor3 = ELEMENT_HOVER}, 0.1):Play()
                end
            end)

            Option.MouseLeave:Connect(function()
                if not selected[option] then
                    Tween(Option, {BackgroundColor3 = DROPDOWN_BG}, 0.1):Play()
                end
            end)

            Option.MouseButton1Click:Connect(function()
                selected[option] = not selected[option]

                local active = selected[option] == true

                Tween(Option, {
                    BackgroundColor3 = active and SELECTED_BG or DROPDOWN_BG
                }, 0.12):Play()

                Option.TextColor3 = active and CRIMSON or TEXT
                Update(true)
            end)
        end

        Button.MouseButton1Click:Connect(function()
            if List.Visible then
                dropdownRef.Close()
            else
                self:_CloseActiveDropdown()
                dropdownRef.UpdatePos()
                List.Visible = true
                SetArrow(Arrow, true)
                self.OpenDropdown = dropdownRef
            end
        end)

        Update(false)

        local control = {}

        function control:Get()
            local values = {}
            for _, option in ipairs(options) do
                if selected[option] then
                    table.insert(values, option)
                end
            end
            return values
        end

        function control:Set(values, fireCallback)
            selected = {}

            for _, value in ipairs(values or {}) do
                selected[value] = true
            end

            for option, btn in pairs(optionButtons) do
                local active = selected[option] == true
                btn.BackgroundColor3 = active and SELECTED_BG or DROPDOWN_BG
                btn.TextColor3 = active and CRIMSON or TEXT
            end

            Update(fireCallback == true)
        end

        function control:Open()
            self:_CloseActiveDropdown()
            dropdownRef.UpdatePos()
            List.Visible = true
            SetArrow(Arrow, true)
            self.OpenDropdown = dropdownRef
        end

        function control:Close()
            dropdownRef.Close()
        end

        control.Instance = Frame
        control.Dropdown = List
        return control
    end

    --==========================================================
    -- SLIDER
    --==========================================================

    function self:AddSlider(text, min, max, default, callback)
        min = tonumber(min) or 0
        max = tonumber(max) or 100
        default = math.clamp(tonumber(default) or min, min, max)

        local Frame = self:_CreateContainer(55)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -55, 0, 25)
        Label.Position = UDim2.fromOffset(10, 3)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = TEXT
        Label.TextSize = 12
        Label.Font = Enum.Font.GothamMedium
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        local Value = Instance.new("TextLabel")
        Value.Size = UDim2.fromOffset(40, 25)
        Value.Position = UDim2.new(1, -48, 0, 3)
        Value.BackgroundTransparency = 1
        Value.TextColor3 = CRIMSON
        Value.TextSize = 12
        Value.Font = Enum.Font.GothamBold
        Value.Text = tostring(default)
        Value.Parent = Frame

        local Bar = Instance.new("Frame")
        Bar.Size = UDim2.new(1, -20, 0, 5)
        Bar.Position = UDim2.new(0, 10, 1, -15)
        Bar.BackgroundColor3 = Color3.fromRGB(55, 55, 62)
        Bar.BorderSizePixel = 0
        Bar.Parent = Frame
        CreateCorner(Bar, 10)

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new(
            math.clamp((default - min) / math.max(max - min, 1), 0, 1),
            0, 1, 0
        )
        Fill.BackgroundColor3 = CRIMSON
        Fill.BorderSizePixel = 0
        Fill.Parent = Bar
        CreateCorner(Fill, 10)

        local value = default
        local draggingSlider = false

        local function Update(input, fireCallback)
            local percent = math.clamp(
                (input.Position.X - Bar.AbsolutePosition.X) /
                    math.max(Bar.AbsoluteSize.X, 1),
                0, 1
            )

            value = math.floor(min + ((max - min) * percent))
            Fill.Size = UDim2.new(percent, 0, 1, 0)
            Value.Text = tostring(value)

            if fireCallback and callback then
                callback(value)
            end
        end

        Bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then

                self:_CloseActiveDropdown()
                draggingSlider = true
                Update(input, true)
            end
        end)

        local changedConnection = UserInputService.InputChanged:Connect(function(input)
            if not draggingSlider then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                Update(input, true)
            end
        end)

        local endedConnection = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                draggingSlider = false
            end
        end)

        local control = {}

        function control:Get()
            return value
        end

        function control:Set(newValue, fireCallback)
            value = math.clamp(tonumber(newValue) or min, min, max)

            local percent = math.clamp(
                (value - min) / math.max(max - min, 1),
                0, 1
            )

            Fill.Size = UDim2.new(percent, 0, 1, 0)
            Value.Text = tostring(value)

            if fireCallback and callback then
                callback(value)
            end
        end

        control.Instance = Frame
        control.Bar = Bar
        control._Connections = {changedConnection, endedConnection}

        return control
    end

    --==========================================================
    -- DRAGGING
    --==========================================================

    local draggingWindow = false
    local dragStart
    local startPos

    Top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            self:_CloseActiveDropdown()

            draggingWindow = true
            dragStart = input.Position
            startPos = Main.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    draggingWindow = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not draggingWindow then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then

            local delta = input.Position - dragStart

            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )

            if self.OpenDropdown and self.OpenDropdown.UpdatePos then
                self.OpenDropdown.UpdatePos()
            end
        end
    end)

    --==========================================================
    -- MINIMIZE
    --==========================================================

    Minimize.MouseButton1Click:Connect(function()
        self:_CloseActiveDropdown()

        self.Minimized = not self.Minimized

        if self.Minimized then
            Content.Visible = false
            Minimize.Text = "+"
            Tween(Main, {Size = UDim2.fromOffset(self.Size.X.Offset, 38)}, 0.18):Play()
        else
            Minimize.Text = "−"

            Tween(Main, {Size = self.NormalSize}, 0.18):Play()

            task.delay(0.18, function()
                if not self.Minimized and not self.Destroyed then
                    Content.Visible = true
                end
            end)
        end
    end)

    --==========================================================
    -- CLOSE
    --==========================================================

    Close.MouseButton1Click:Connect(function()
        self:Destroy()
    end)

    return self
end

--==============================================================
-- WINDOW METHODS
--==============================================================

function FlowerHub:SetTitle(title)
    if self.TitleLabel then
        self.TitleLabel.Text = tostring(title)
    end
end

function FlowerHub:SetPosition(position)
    if self.Main then
        self.Main.Position = position
    end
end

function FlowerHub:SetSize(size)
    if self.Main then
        self.NormalSize = size
        if not self.Minimized then
            self.Main.Size = size
        end
    end
end

function FlowerHub:Minimize()
    if not self.Minimized and self.MinimizeButton then
        self.MinimizeButton:Activate()
    end
end

function FlowerHub:Restore()
    if self.Minimized and self.MinimizeButton then
        self.MinimizeButton:Activate()
    end
end

function FlowerHub:Toggle()
    if self.MinimizeButton then
        self.MinimizeButton:Activate()
    end
end

function FlowerHub:Destroy()
    if self.Destroyed then
        return
    end

    self.Destroyed = true

    if self.OpenDropdown and self.OpenDropdown.Close then
        self.OpenDropdown.Close()
    end

    if self.Gui then
        self.Gui:Destroy()
    end
end

--==============================================================
-- RETURN LIBRARY
--==============================================================

return FlowerHub
