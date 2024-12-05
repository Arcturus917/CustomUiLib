local UILibrary = {}

-- Helper: Add UICorner
local function addUICorner(parent, radius)
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, radius)
    uiCorner.Parent = parent
end

-- Helper: Make frame draggable
local function makeDraggable(frame, handle)
    local UIS = game:GetService("UserInputService")
    local dragging, dragInput, startPos, dragStart

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Create main UI window
function UILibrary:NewWindow(title)
    local screenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))

    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    addUICorner(mainFrame, 10)

    local titleBar = Instance.new("Frame", mainFrame)
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    addUICorner(titleBar, 10)

    local titleLabel = Instance.new("TextLabel", titleBar)
    titleLabel.Size = UDim2.new(1, -10, 1, 0)
    titleLabel.Position = UDim2.new(0, 5, 0, 0)
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    makeDraggable(mainFrame, titleBar)

    return {MainFrame = mainFrame}
end

-- Add a button
function UILibrary:CreateButton(parent, text, callback)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    addUICorner(button, 8)

    button.MouseButton1Click:Connect(callback)
end

-- Add a toggle
function UILibrary:CreateToggle(parent, text, default, callback)
    local toggle = Instance.new("Frame", parent)
    toggle.Size = UDim2.new(1, 0, 0, 30)

    local label = Instance.new("TextLabel", toggle)
    label.Size = UDim2.new(0.8, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left

    local button = Instance.new("TextButton", toggle)
    button.Size = UDim2.new(0.2, 0, 1, 0)
    button.Position = UDim2.new(0.8, 0, 0, 0)
    button.Text = default and "ON" or "OFF"
    button.TextColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    addUICorner(button, 8)

    button.MouseButton1Click:Connect(function()
        default = not default
        button.Text = default and "ON" or "OFF"
        button.TextColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        callback(default)
    end)
end

return UILibrary
