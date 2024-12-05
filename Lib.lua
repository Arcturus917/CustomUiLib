local UILibrary = {}
UILibrary.__index = UILibrary

-- Utility functions
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

-- Main Window
function UILibrary:NewWindow(title)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Create the main window
    local window = Instance.new("Frame")
    window.Size = UDim2.new(0, 400, 0, 300)
    window.Position = UDim2.new(0.5, -200, 0.5, -150)
    window.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    window.BorderSizePixel = 0
    window.Visible = false  -- Initially hidden
    window.Parent = screenGui

    addUICorner(window, 10)
    addUIStroke(window, Color3.fromRGB(80, 80, 80), 2)

    -- Create the title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = window
    addUICorner(titleBar, 10)

    -- Title text
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 20
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = titleBar

    makeDraggable(window, titleBar)

    -- Create the section container for UI elements
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

    -- Create the toggle button to open/close the window
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 50, 0, 50)
    toggleButton.Position = UDim2.new(0.5, -25, 0.5, -150)
    toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggleButton.Text = "+"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 24
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = screenGui
    addUICorner(toggleButton, 10)

    makeDraggable(toggleButton)  -- Make the toggle button draggable

    -- Toggle functionality
    toggleButton.MouseButton1Click:Connect(function()
        window.Visible = not window.Visible  -- Toggle visibility of the window
        toggleButton.Text = window.Visible and "-" or "+"
    end)

    return sectionContainer
end

-- Dropdown Functionality
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

-- Toggle Functionality
function UILibrary:CreateToggle(section, toggleName, defaultValue, callback)
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(1, 0, 0, 40)
    toggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    toggle.Parent = section
    addUICorner(toggle, 8)

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 50, 1, 0)
    toggleButton.Position = UDim2.new(1, -55, 0, 5)
    toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    toggleButton.Text = ""
    toggleButton.Parent = toggle
    addUICorner(toggleButton, 10)

    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(1, -60, 1, 0)
    toggleLabel.Text = toggleName
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.TextSize = 16
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Parent = toggle

    toggleButton.MouseButton1Click:Connect(function()
        defaultValue = not defaultValue
        toggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        callback(defaultValue)
    end)
end

-- Slider Functionality
function UILibrary:CreateSlider(section, sliderName, minValue, maxValue, defaultValue, callback)
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, 0, 0, 50)
    slider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    slider.Parent = section
    addUICorner(slider, 8)

    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(1, 0, 0, 20)
    sliderLabel.Text = sliderName
    sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderLabel.TextSize = 16
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Parent = slider

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -20, 0, 10)
    sliderBar.Position = UDim2.new(0, 10, 0, 25)
    sliderBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    sliderBar.Parent = slider
    addUICorner(sliderBar, 5)

    local sliderButton = Instance.new("Frame")
    sliderButton.Size = UDim2.new(0, 20, 1, 0)
    sliderButton.Position = UDim2.new(0, (defaultValue - minValue) / (maxValue - minValue) * (sliderBar.Size.X.Offset - 20), 0, 0)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
    sliderButton.Parent = sliderBar
    addUICorner(sliderButton, 5)

    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local function moveSlider(input)
                local newX = math.clamp(input.Position.X - sliderBar.AbsolutePosition.X, 0, sliderBar.Size.X.Offset - sliderButton.Size.X.Offset)
                sliderButton.Position = UDim2.new(0, newX, 0, 0)
                local value = math.floor(minValue + (newX / (sliderBar.Size.X.Offset - sliderButton.Size.X.Offset)) * (maxValue - minValue))
                callback(value)
            end

            local connection
            connection = game:GetService("UserInputService").InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    moveSlider(input)
                end
            end)

            input.Ended:Connect(function()
                connection:Disconnect()
            end)
        end
    end)
end

return UILibrary
