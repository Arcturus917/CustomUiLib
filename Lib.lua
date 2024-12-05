local UILibrary = {}
UILibrary.__index = UILibrary

-- Helper Functions
local function addUICorner(parent, radius)
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, radius)
    uiCorner.Parent = parent
end

local function addUIStroke(parent, color, thickness)
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = color
    uiStroke.Thickness = thickness
    uiStroke.Parent = parent
end

-- Create a draggable frame
local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, startPos, dragStart

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            update(input)
        end
    end)
end

-- Main UI Window
function UILibrary:NewWindow(title)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.Parent = screenGui
    addUICorner(mainFrame, 10)
    addUIStroke(mainFrame, Color3.fromRGB(80, 80, 80), 2)

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    titleBar.Parent = mainFrame
    addUICorner(titleBar, 10)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -10, 1, 0)
    titleLabel.Position = UDim2.new(0, 5, 0, 0)
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    makeDraggable(mainFrame, titleBar)

    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, 0, 1, -40)
    tabContent.Position = UDim2.new(0, 0, 0, 40)
    tabContent.BackgroundTransparency = 1
    tabContent.Parent = mainFrame

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabContent

    return {
        MainFrame = mainFrame,
        TabContent = tabContent,
    }
end

-- Add a section
function UILibrary:NewSection(window, sectionTitle)
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Size = UDim2.new(1, 0, 0, 50)
    sectionFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sectionFrame.Parent = window.TabContent
    addUICorner(sectionFrame, 10)

    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size = UDim2.new(1, -10, 1, 0)
    sectionLabel.Position = UDim2.new(0, 5, 0, 0)
    sectionLabel.Text = sectionTitle
    sectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sectionLabel.TextSize = 16
    sectionLabel.Font = Enum.Font.GothamBold
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Parent = sectionFrame

    return sectionFrame
end

-- Add a button
function UILibrary:CreateButton(section, buttonText, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Text = buttonText
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.Parent = section
    addUICorner(button, 8)

    button.MouseButton1Click:Connect(function()
        callback()
    end)
end

-- Add a toggle
function UILibrary:CreateToggle(section, toggleText, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = section

    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(0.8, 0, 1, 0)
    toggleLabel.Text = toggleText
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextSize = 14
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0.2, 0, 1, 0)
    toggleButton.Position = UDim2.new(0.8, 0, 0, 0)
    toggleButton.Text = default and "ON" or "OFF"
    toggleButton.TextColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    toggleButton.Font = Enum.Font.Gotham
    toggleButton.TextSize = 14
    toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    toggleButton.Parent = toggleFrame
    addUICorner(toggleButton, 8)

    toggleButton.MouseButton1Click:Connect(function()
        default = not default
        toggleButton.Text = default and "ON" or "OFF"
        toggleButton.TextColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        callback(default)
    end)
end

-- Dropdowns and sliders can be added similarly.

return UILibrary
