-- Simple Cool Black/White UI for Roblox
-- Draggable • Mobile + PC friendly • Button, Input, Slider, Dropdown

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// Theme
local Theme = {
	Background = Color3.fromRGB(12, 12, 12),
	Secondary  = Color3.fromRGB(22, 22, 22),
	Accent     = Color3.fromRGB(255, 255, 255),
	Text       = Color3.fromRGB(240, 240, 240),
	Muted      = Color3.fromRGB(160, 160, 160),
	Stroke     = Color3.fromRGB(45, 45, 45),
	Hover      = Color3.fromRGB(35, 35, 35),
}

--// Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoolScriptUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

--// Main Window
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 320, 0, 380)
main.Position = UDim2.new(0.5, -160, 0.5, -190)
main.BackgroundColor3 = Theme.Background
main.BorderSizePixel = 0
main.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Theme.Stroke
mainStroke.Thickness = 1
mainStroke.Parent = main

-- Title Bar (drag handle)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.BackgroundColor3 = Theme.Secondary
titleBar.BorderSizePixel = 0
titleBar.Parent = main

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- Fix bottom corners of title bar
local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 12)
titleFix.Position = UDim2.new(0, 0, 1, -12)
titleFix.BackgroundColor3 = Theme.Secondary
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 14, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Cool Script UI"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextColor3 = Theme.Accent
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -38, 0.5, -16)
closeBtn.BackgroundColor3 = Theme.Background
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 22
closeBtn.TextColor3 = Theme.Accent
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- Content container
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -24, 1, -58)
content.Position = UDim2.new(0, 12, 0, 50)
content.BackgroundTransparency = 1
content.Parent = main

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 12)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = content

--// Helper: Create section label
local function createLabel(text)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 18)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 13
	label.TextColor3 = Theme.Muted
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.LayoutOrder = #content:GetChildren()
	label.Parent = content
	return label
end

--// 1. BUTTON
createLabel("Button")

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, 0, 0, 40)
button.BackgroundColor3 = Theme.Secondary
button.Text = "Click Me"
button.Font = Enum.Font.GothamBold
button.TextSize = 14
button.TextColor3 = Theme.Accent
button.BorderSizePixel = 0
button.AutoButtonColor = false
button.LayoutOrder = #content:GetChildren()
button.Parent = content

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = button

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Theme.Stroke
btnStroke.Thickness = 1
btnStroke.Parent = button

button.MouseEnter:Connect(function()
	TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Hover}):Play()
end)
button.MouseLeave:Connect(function()
	TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Secondary}):Play()
end)

button.MouseButton1Click:Connect(function()
	button.Text = "Clicked!"
	task.delay(0.8, function()
		if button and button.Parent then
			button.Text = "Click Me"
		end
	end)
end)

--// 2. TEXT INPUT
createLabel("Text Input")

local inputFrame = Instance.new("Frame")
inputFrame.Size = UDim2.new(1, 0, 0, 40)
inputFrame.BackgroundColor3 = Theme.Secondary
inputFrame.BorderSizePixel = 0
inputFrame.LayoutOrder = #content:GetChildren()
inputFrame.Parent = content

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = inputFrame

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = Theme.Stroke
inputStroke.Thickness = 1
inputStroke.Parent = inputFrame

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -16, 1, 0)
textBox.Position = UDim2.new(0, 8, 0, 0)
textBox.BackgroundTransparency = 1
textBox.PlaceholderText = "Type something..."
textBox.PlaceholderColor3 = Theme.Muted
textBox.Text = ""
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 14
textBox.TextColor3 = Theme.Accent
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.ClearTextOnFocus = false
textBox.Parent = inputFrame

textBox.Focused:Connect(function()
	TweenService:Create(inputStroke, TweenInfo.new(0.15), {Color = Theme.Accent}):Play()
end)
textBox.FocusLost:Connect(function()
	TweenService:Create(inputStroke, TweenInfo.new(0.15), {Color = Theme.Stroke}):Play()
end)

--// 3. SLIDER
createLabel("Slider")

local sliderContainer = Instance.new("Frame")
sliderContainer.Size = UDim2.new(1, 0, 0, 50)
sliderContainer.BackgroundTransparency = 1
sliderContainer.LayoutOrder = #content:GetChildren()
sliderContainer.Parent = content

local sliderValueLabel = Instance.new("TextLabel")
sliderValueLabel.Size = UDim2.new(1, 0, 0, 18)
sliderValueLabel.BackgroundTransparency = 1
sliderValueLabel.Text = "Value: 50"
sliderValueLabel.Font = Enum.Font.Gotham
sliderValueLabel.TextSize = 13
sliderValueLabel.TextColor3 = Theme.Accent
sliderValueLabel.TextXAlignment = Enum.TextXAlignment.Left
sliderValueLabel.Parent = sliderContainer

local sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.new(1, 0, 0, 8)
sliderTrack.Position = UDim2.new(0, 0, 0, 28)
sliderTrack.BackgroundColor3 = Theme.Secondary
sliderTrack.BorderSizePixel = 0
sliderTrack.Parent = sliderContainer

local trackCorner = Instance.new("UICorner")
trackCorner.CornerRadius = UDim.new(1, 0)
trackCorner.Parent = sliderTrack

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
sliderFill.BackgroundColor3 = Theme.Accent
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderTrack

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = sliderFill

local sliderThumb = Instance.new("Frame")
sliderThumb.Size = UDim2.new(0, 18, 0, 18)
sliderThumb.Position = UDim2.new(0.5, -9, 0.5, -9)
sliderThumb.BackgroundColor3 = Theme.Accent
sliderThumb.BorderSizePixel = 0
sliderThumb.ZIndex = 2
sliderThumb.Parent = sliderTrack

local thumbCorner = Instance.new("UICorner")
thumbCorner.CornerRadius = UDim.new(1, 0)
thumbCorner.Parent = sliderThumb

-- Slider logic
local minVal, maxVal = 0, 100
local currentVal = 50
local draggingSlider = false

local function updateSlider(value)
	currentVal = math.clamp(value, minVal, maxVal)
	local percent = (currentVal - minVal) / (maxVal - minVal)
	sliderFill.Size = UDim2.new(percent, 0, 1, 0)
	sliderThumb.Position = UDim2.new(percent, -9, 0.5, -9)
	sliderValueLabel.Text = "Value: " .. math.floor(currentVal)
end

local function sliderInput(input)
	local absPos = sliderTrack.AbsolutePosition.X
	local absSize = sliderTrack.AbsoluteSize.X
	local relative = math.clamp((input.Position.X - absPos) / absSize, 0, 1)
	updateSlider(minVal + relative * (maxVal - minVal))
end

sliderTrack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingSlider = true
		sliderInput(input)
	end
end)

sliderThumb.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingSlider = true
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		sliderInput(input)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingSlider = false
	end
end)

updateSlider(50)

--// 4. DROPDOWN
createLabel("Dropdown")

local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(1, 0, 0, 40)
dropdownFrame.BackgroundColor3 = Theme.Secondary
dropdownFrame.BorderSizePixel = 0
dropdownFrame.ClipsDescendants = false
dropdownFrame.LayoutOrder = #content:GetChildren()
dropdownFrame.Parent = content

local dropCorner = Instance.new("UICorner")
dropCorner.CornerRadius = UDim.new(0, 8)
dropCorner.Parent = dropdownFrame

local dropStroke = Instance.new("UIStroke")
dropStroke.Color = Theme.Stroke
dropStroke.Thickness = 1
dropStroke.Parent = dropdownFrame

local selectedLabel = Instance.new("TextLabel")
selectedLabel.Size = UDim2.new(1, -40, 1, 0)
selectedLabel.Position = UDim2.new(0, 12, 0, 0)
selectedLabel.BackgroundTransparency = 1
selectedLabel.Text = "Select option"
selectedLabel.Font = Enum.Font.Gotham
selectedLabel.TextSize = 14
selectedLabel.TextColor3 = Theme.Accent
selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
selectedLabel.Parent = dropdownFrame

local arrow = Instance.new("TextLabel")
arrow.Size = UDim2.new(0, 30, 1, 0)
arrow.Position = UDim2.new(1, -30, 0, 0)
arrow.BackgroundTransparency = 1
arrow.Text = "▼"
arrow.Font = Enum.Font.Gotham
arrow.TextSize = 12
arrow.TextColor3 = Theme.Muted
arrow.Parent = dropdownFrame

local options = {"Option 1", "Option 2", "Option 3", "Option 4"}
local isOpen = false
local optionButtons = {}

local optionsFrame = Instance.new("Frame")
optionsFrame.Size = UDim2.new(1, 0, 0, 0)
optionsFrame.Position = UDim2.new(0, 0, 1, 4)
optionsFrame.BackgroundColor3 = Theme.Secondary
optionsFrame.BorderSizePixel = 0
optionsFrame.Visible = false
optionsFrame.ZIndex = 10
optionsFrame.Parent = dropdownFrame

local optionsCorner = Instance.new("UICorner")
optionsCorner.CornerRadius = UDim.new(0, 8)
optionsCorner.Parent = optionsFrame

local optionsStroke = Instance.new("UIStroke")
optionsStroke.Color = Theme.Stroke
optionsStroke.Thickness = 1
optionsStroke.Parent = optionsFrame

local optionsLayout = Instance.new("UIListLayout")
optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
optionsLayout.Parent = optionsFrame

local function toggleDropdown()
	isOpen = not isOpen
	if isOpen then
		optionsFrame.Visible = true
		optionsFrame.Size = UDim2.new(1, 0, 0, #options * 36)
		arrow.Text = "▲"
	else
		optionsFrame.Visible = false
		optionsFrame.Size = UDim2.new(1, 0, 0, 0)
		arrow.Text = "▼"
	end
end

dropdownFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		toggleDropdown()
	end
end)

for i, option in ipairs(options) do
	local optBtn = Instance.new("TextButton")
	optBtn.Size = UDim2.new(1, 0, 0, 36)
	optBtn.BackgroundColor3 = Theme.Secondary
	optBtn.Text = option
	optBtn.Font = Enum.Font.Gotham
	optBtn.TextSize = 14
	optBtn.TextColor3 = Theme.Accent
	optBtn.BorderSizePixel = 0
	optBtn.AutoButtonColor = false
	optBtn.ZIndex = 11
	optBtn.LayoutOrder = i
	optBtn.Parent = optionsFrame

	optBtn.MouseEnter:Connect(function()
		optBtn.BackgroundColor3 = Theme.Hover
	end)
	optBtn.MouseLeave:Connect(function()
		optBtn.BackgroundColor3 = Theme.Secondary
	end)

	optBtn.MouseButton1Click:Connect(function()
		selectedLabel.Text = option
		toggleDropdown()
		print("Selected:", option)
	end)

	table.insert(optionButtons, optBtn)
end

-- Close dropdown when clicking outside
UserInputService.InputBegan:Connect(function(input)
	if isOpen and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
		local mousePos = UserInputService:GetMouseLocation()
		local absPos = optionsFrame.AbsolutePosition
		local absSize = optionsFrame.AbsoluteSize
		local inOptions = mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X
			and mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y
		local inMain = mousePos.X >= dropdownFrame.AbsolutePosition.X and mousePos.X <= dropdownFrame.AbsolutePosition.X + dropdownFrame.AbsoluteSize.X
			and mousePos.Y >= dropdownFrame.AbsolutePosition.Y and mousePos.Y <= dropdownFrame.AbsolutePosition.Y + dropdownFrame.AbsoluteSize.Y

		if not inOptions and not inMain then
			isOpen = false
			optionsFrame.Visible = false
			optionsFrame.Size = UDim2.new(1, 0, 0, 0)
			arrow.Text = "▼"
		end
	end
end)

--// DRAGGABLE (Title Bar)
local dragging = false
local dragStart = nil
local startPos = nil

local function updateDrag(input)
	local delta = input.Position - dragStart
	main.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

titleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		if dragging then
			updateDrag(input)
		end
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		updateDrag(input)
	end
end)

print("Cool Script UI loaded!")
