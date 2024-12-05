-- Load UI Library
local UILibrary = {}

-- Function to create a new window
function UILibrary:NewWindow(title)
    local window = Instance.new("ScreenGui")
    local mainFrame = Instance.new("Frame")
    local titleLabel = Instance.new("TextLabel")

    -- ScreenGui setup
    window.Name = title .. "_UI"
    window.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Main Frame setup
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = window

    -- Title Label setup
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleLabel.BorderSizePixel = 0
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 20
    titleLabel.Parent = mainFrame

    return mainFrame
end

-- Function to create a new section
function UILibrary:NewSection(parent, name)
    local section = Instance.new("Frame")
    local titleLabel = Instance.new("TextLabel")
    local layout = Instance.new("UIListLayout")

    -- Section Frame setup
    section.Name = name .. "_Section"
    section.Size = UDim2.new(1, 0, 0, 0)
    section.BackgroundTransparency = 1
    section.Parent = parent

    -- Title Label setup
    titleLabel.Name = "SectionTitle"
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = name
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 18
    titleLabel.Parent = section

    -- UIListLayout setup
    layout.Name = "SectionLayout"
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = section

    return section
end

-- Function to create a button
function UILibrary:CreateButton(section, text, callback)
    local button = Instance.new("TextButton")

    -- Button setup
    button.Name = text .. "_Button"
    button.Size = UDim2.new(1, 0, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 16
    button.Parent = section

    -- Button click event
    button.MouseButton1Click:Connect(callback)
end

-- Function to create a toggle
function UILibrary:CreateToggle(section, text, default, callback)
    local toggle = Instance.new("Frame")
    local label = Instance.new("TextLabel")
    local checkbox = Instance.new("TextButton")

    -- Toggle Frame setup
    toggle.Name = text .. "_Toggle"
    toggle.Size = UDim2.new(1, 0, 0, 30)
    toggle.BackgroundTransparency = 1
    toggle.Parent = section

    -- Label setup
    label.Name = "ToggleLabel"
    label.Size = UDim2.new(0.8, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggle

    -- Checkbox setup
    checkbox.Name = "Checkbox"
    checkbox.Size = UDim2.new(0.2, 0, 1, 0)
    checkbox.Position = UDim2.new(0.8, 0, 0, 0)
    checkbox.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    checkbox.BorderSizePixel = 0
    checkbox.Text = ""
    checkbox.Parent = toggle

    -- Toggle functionality
    local state = default
    checkbox.MouseButton1Click:Connect(function()
        state = not state
        checkbox.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        callback(state)
    end)
end

-- Function to create a dropdown
function UILibrary:CreateDropdown(section, text, options, default, callback)
    local dropdown = Instance.new("TextButton")

    -- Dropdown setup
    dropdown.Name = text .. "_Dropdown"
    dropdown.Size = UDim2.new(1, 0, 0, 30)
    dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    dropdown.BorderSizePixel = 0
    dropdown.Text = text .. " (Select)"
    dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdown.Font = Enum.Font.SourceSans
    dropdown.TextSize = 16
    dropdown.Parent = section

    -- Dropdown click event (example of functionality, no menu implementation)
    dropdown.MouseButton1Click:Connect(function()
        print("Dropdown clicked - Selected:", default)
        callback(default) -- Pass the default for simplicity
    end)
end

-- Function to create a slider
function UILibrary:CreateSlider(section, text, min, max, default, callback)
    local slider = Instance.new("Frame")
    local label = Instance.new("TextLabel")
    local bar = Instance.new("Frame")
    local knob = Instance.new("TextButton")

    -- Slider Frame setup
    slider.Name = text .. "_Slider"
    slider.Size = UDim2.new(1, 0, 0, 50)
    slider.BackgroundTransparency = 1
    slider.Parent = section

    -- Label setup
    label.Name = "SliderLabel"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = slider

    -- Bar setup
    bar.Name = "Bar"
    bar.Size = UDim2.new(1, 0, 0, 10)
    bar.Position = UDim2.new(0, 0, 0.5, 0)
    bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    bar.BorderSizePixel = 0
    bar.Parent = slider

    -- Knob setup
    knob.Name = "Knob"
    knob.Size = UDim2.new(0, 10, 0, 10)
    knob.Position = UDim2.new((default - min) / (max - min), -5, 0, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Text = ""
    knob.Parent = bar

    -- Slider functionality
    knob.MouseButton1Down:Connect(function()
        local inputChanged
        inputChanged = game:GetService("UserInputService").InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local relativePosition = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                local value = math.floor(relativePosition * (max - min) + min)
                knob.Position = UDim2.new(relativePosition, -5, 0, 0)
                label.Text = text .. ": " .. tostring(value)
                callback(value)
            end
        end)

        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                inputChanged:Disconnect()
            end
        end)
    end)
end

return UILibrary
