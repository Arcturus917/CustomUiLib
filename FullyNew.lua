local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local CustomUILib = {
    Elements = {},
    Themes = {
        Dark = {
            Main = Color3.fromRGB(30, 30, 30),
            Secondary = Color3.fromRGB(45, 45, 45),
            Accent = Color3.fromRGB(0, 170, 255),
            Text = Color3.fromRGB(240, 240, 240)
        }
    },
    CurrentTheme = "Dark",
    UIInstances = {},
    Flags = {}
}

-- Core GUI Creation
local MainGUI = Instance.new("ScreenGui")
MainGUI.Name = "CustomUI"
MainGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainGUI.DisplayOrder = 999

if syn and syn.protect_gui then
    syn.protect_gui(MainGUI)
    MainGUI.Parent = game:GetService("CoreGui")
else
    MainGUI.Parent = gethui and gethui() or game:GetService("CoreGui")
end

-- Utility Functions
local function CreateElement(className, properties)
    local element = Instance.new(className)
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    return element
end

local function ApplyTheme(element, elementType)
    if CustomUILib.Themes[CustomUILib.CurrentTheme][elementType] then
        if element:IsA("TextLabel") or element:IsA("TextButton") then
            element.TextColor3 = CustomUILib.Themes[CustomUILib.CurrentTheme].Text
        elseif element:IsA("Frame") then
            element.BackgroundColor3 = CustomUILib.Themes[CustomUILib.CurrentTheme][elementType]
        end
    end
end

-- Window Creation
function CustomUILib:CreateWindow(config)
    local windowConfig = config or {}
    windowConfig.Title = windowConfig.Title or "Custom UI"
    windowConfig.Size = windowConfig.Size or UDim2.new(0, 400, 0, 500)
    windowConfig.Position = windowConfig.Position or UDim2.new(0.5, -200, 0.5, -250)

    local mainWindow = CreateElement("Frame", {
        Name = "MainWindow",
        Size = windowConfig.Size,
        Position = windowConfig.Position,
        BackgroundTransparency = 0.1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = MainGUI
    })
    
    ApplyTheme(mainWindow, "Main")
    
    local titleBar = CreateElement("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 0.2,
        Parent = mainWindow
    })
    ApplyTheme(titleBar, "Secondary")
    
    local titleLabel = CreateElement("TextLabel", {
        Name = "TitleLabel",
        Text = windowConfig.Title,
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })
    ApplyTheme(titleLabel, "Text")
    
    local closeButton = CreateElement("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -30, 0, 0),
        Text = "X",
        Parent = titleBar
    })
    ApplyTheme(closeButton, "Text")
    
    -- Dragging functionality
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainWindow.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainWindow.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Close button functionality
    closeButton.MouseButton1Click:Connect(function()
        mainWindow:Destroy()
    end)
    
    -- Tab system implementation
    local tabSystem = {
        Tabs = {},
        CurrentTab = nil
    }
    
    function tabSystem:CreateTab(tabName)
        local newTab = {
            Name = tabName,
            Container = CreateElement("ScrollingFrame", {
                Size = UDim2.new(1, 0, 1, -40),
                Position = UDim2.new(0, 0, 0, 40),
                BackgroundTransparency = 1,
                ScrollBarThickness = 5,
                Parent = mainWindow
            })
        }
        
        table.insert(self.Tabs, newTab)
        return newTab
    end
    
    return tabSystem
end

-- Notification System
function CustomUILib:Notify(message, duration)
    local notification = CreateElement("Frame", {
        Size = UDim2.new(0, 300, 0, 60),
        Position = UDim2.new(1, -320, 1, -80),
        BackgroundTransparency = 0.2,
        Parent = MainGUI
    })
    ApplyTheme(notification, "Secondary")
    
    local messageLabel = CreateElement("TextLabel", {
        Text = message,
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        TextWrapped = true,
        Parent = notification
    })
    ApplyTheme(messageLabel, "Text")
    
    -- Animation
    notification.Position = UDim2.new(1, 300, 1, -80)
    TweenService:Create(notification, TweenInfo.new(0.3), {
        Position = UDim2.new(1, -320, 1, -80)
    }):Play()
    
    delay(duration or 3, function()
        TweenService:Create(notification, TweenInfo.new(0.3), {
            Position = UDim2.new(1, 300, 1, -80)
        }):Play()
        wait(0.3)
        notification:Destroy()
    end)
end

-- Configuration Handling
function CustomUILib:SaveConfiguration(filename)
    local configData = {}
    for flag, value in pairs(self.Flags) do
        configData[flag] = value
    end
    
    if writefile then
        writefile(filename, HttpService:JSONEncode(configData))
    end
end

function CustomUILib:LoadConfiguration(filename)
    if readfile and isfile(filename) then
        local configData = HttpService:JSONDecode(readfile(filename))
        for flag, value in pairs(configData) do
            if self.Flags[flag] then
                self.Flags[flag]:Set(value)
            end
        end
    end
end

-- Button Element
function CustomUILib:CreateButton(parent, config)
    local buttonConfig = config or {}
    buttonConfig.Text = buttonConfig.Text or "Button"
    buttonConfig.Size = buttonConfig.Size or UDim2.new(0, 100, 0, 30)
    buttonConfig.Position = buttonConfig.Position or UDim2.new(0.5, -50, 0, 10)
    buttonConfig.Callback = buttonConfig.Callback or function() end

    local button = CreateElement("TextButton", {
        Text = buttonConfig.Text,
        Size = buttonConfig.Size,
        Position = buttonConfig.Position,
        Parent = parent
    })
    ApplyTheme(button, "Text")

    button.MouseButton1Click:Connect(function()
        buttonConfig.Callback()
    end)

    return button
end

return CustomUILib
