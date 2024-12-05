local UILibrary = {}
UILibrary.__index = UILibrary

local function addUICorner(parent, radius)
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, radius)
    uiCorner.Parent = parent
    return uiCorner
end

local function addUIStroke(parent, color, thickness)
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = color
    uiStroke.Thickness = thickness
    uiStroke.Parent = parent
    return uiStroke
end

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

function UILibrary:NewWindow(title)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local window = Instance.new("Frame")
    window.Size = UDim2.new(0, 400, 0, 300)
    window.Position = UDim2.new(0.5, -200, 0.5, -150)
    window.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    window.BorderSizePixel = 0
    window.Parent = screenGui

    addUICorner(window, 10)
    addUIStroke(window, Color3.fromRGB(80, 80, 80), 2)

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = window
    addUICorner(titleBar, 10)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 20
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = titleBar

    makeDraggable(window, titleBar)

    local sectionContainer = Instance.new("ScrollingFrame")
    sectionContainer.Size = UDim2.new(1, -10, 1, -50)
    sectionContainer.Position = UDim2.new(0, 5, 0, 45)
    sectionContainer.BackgroundTransparency = 1
    sectionContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    sectionContainer.ScrollBarThickness = 6
    sectionContainer.Parent = window

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = sectionContainer

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sectionContainer.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    return sectionContainer
end

function UILibrary:CreateDropdown(section, dropdownName, options, callback)
    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(1, 0, 0, 40)
    dropdown.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    dropdown.Parent = section
    addUICorner(dropdown, 8)

    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Size = UDim2.new(1, 0, 1, 0)
    dropdownButton.BackgroundTransparency = 1
    dropdownButton.Text = dropdownName
    dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownButton.TextSize = 16
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.Parent = dropdown

    local dropdownArrow = Instance.new("TextLabel")
    dropdownArrow.Size = UDim2.new(0, 20, 0, 20)
    dropdownArrow.Position = UDim2.new(1, -25, 0.5, -10)
    dropdownArrow.BackgroundTransparency = 1
    dropdownArrow.Text = "▼"
    dropdownArrow.TextColor3 = Color3.fromRGB(200, 200, 200)
    dropdownArrow.TextSize = 16
    dropdownArrow.Font = Enum.Font.Gotham
    dropdownArrow.Parent = dropdown

    local dropdownContainer = Instance.new("Frame")
    dropdownContainer.Size = UDim2.new(1, 0, 0, 0)
    dropdownContainer.Position = UDim2.new(0, 0, 1, 5)
    dropdownContainer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    dropdownContainer.ClipsDescendants = true
    dropdownContainer.Parent = dropdown
    addUICorner(dropdownContainer, 8)
    addUIStroke(dropdownContainer, Color3.fromRGB(90, 90, 90), 1)

    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, -10, 1, -10)
    scrollingFrame.Position = UDim2.new(0, 5, 0, 5)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    scrollingFrame.Parent = dropdownContainer

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = scrollingFrame

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)

    local clickSound = Instance.new("Sound")
    clickSound.SoundId = "rbxassetid://876939830"
    clickSound.Volume = 1.5
    clickSound.Parent = dropdown

    for _, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        optionButton.Text = option
        optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionButton.TextSize = 16
        optionButton.Font = Enum.Font.Gotham
        optionButton.Parent = scrollingFrame
        addUICorner(optionButton, 6)

        optionButton.MouseButton1Click:Connect(function()
            dropdownButton.Text = option
            callback(option)
            clickSound:Play()
            dropdownContainer:TweenSize(UDim2.new(1, 0, 0, 0), "Out", "Quad", 0.3, true)
            dropdownArrow.Text = "▼"
        end)
    end

    local isOpen = false

    dropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            dropdownContainer:TweenSize(UDim2.new(1, 0, 0, math.min(150, layout.AbsoluteContentSize.Y)), "Out", "Quad", 0.3, true)
            dropdownArrow.Text = "▲"
        else
            dropdownContainer:TweenSize(UDim2.new(1, 0, 0, 0), "Out", "Quad", 0.3, true)
            dropdownArrow.Text = "▼"
        end
    end)
end

return UILibrary
