-- AMS Ultimate Script Personal Edition for Steal a Brainrot

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
repeat wait() until player
repeat wait() until player.Character
repeat wait() until player.Character:FindFirstChild("HumanoidPart")

local ScriptState = {
    espEnabled = false,
    noCollisionEnabled = false,
    flyEnabled = false,
    speedEnabled = false,
    godModeEnabled = false,
    infiniteJumpEnabled = false,
    antiAfkEnabled = false,
    superJumpEnabled = false,
    baseMarked = false,
    basePosition = nil,
    connections = {}
}

local function notify(title, text, duration)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "🔥 " .. title,
            Text = text,
            Duration = duration or 3,
            Icon = "rbxassetid://2541869220"
        })
    end)
end

-- ESP Implementation
local function createESP(targetPlayer)
    if targetPlayer == player or not targetPlayer.Character then return end

    local char = targetPlayer.Character
    local hrp = char:FindFirstChild("HumanoidPart")
    if not hrp then return end

    for _, v in pairs(hrp:GetChildren()) do
        if v.Name == "Custom_ESP" then v:Destroy() end
    end

    local esp = Instance.new("BillboardGui")
    esp.Name = "Custom_ESP"
    esp.Adornee = hrp
    esp.Size = UDim2.new(0, 250, 0, 150)
    esp.StudsOffset = Vector3.new(0, 5, 0)
    esp.AlwaysOnTop = true
    esp.Parent = hrp

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 3
    frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
    frame.Parent = esp

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 12)

    local labelName = Instance.new("TextLabel", frame)
    labelName.Size = UDim2.new(1, 0, 0.3, 0)
    labelName.BackgroundTransparency = 1
    labelName.Text = "🎯 " .. targetPlayer.Name
    labelName.TextColor3 = Color3.new(1,1,1)
    labelName.Font = Enum.Font.GothamBold
    labelName.TextScaled = true
    
    local labelDistance = Instance.new("TextLabel", frame)
    labelDistance.Size = UDim2.new(1, 0, 0.25, 0)
    labelDistance.Position = UDim2.new(0, 0, 0.3, 0)
    labelDistance.BackgroundTransparency = 1
    labelDistance.TextColor3 = Color3.new(1, 1, 0)
    labelDistance.Font = Enum.Font.Gotham
    labelDistance.TextScaled = true
    
    local labelHealth = Instance.new("TextLabel", frame)
    labelHealth.Size = UDim2.new(1, 0, 0.25, 0)
    labelHealth.Position = UDim2.new(0, 0, 0.55, 0)
    labelHealth.BackgroundTransparency = 1
    labelHealth.TextColor3 = Color3.new(0,1,0)
    labelHealth.Font = Enum.Font.Gotham
    labelHealth.TextScaled = true
    
    local labelStatus = Instance.new("TextLabel", frame)
    labelStatus.Size = UDim2.new(1, 0, 0.2, 0)
    labelStatus.Position = UDim2.new(0, 0, 0.8, 0)
    labelStatus.BackgroundTransparency = 1
    labelStatus.TextColor3 = Color3.new(1, 0.5, 0)
    labelStatus.Font = Enum.Font.GothamSemibold
    labelStatus.TextScaled = true
    
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if hrp and hrp.Parent and player.Character and player.Character:FindFirstChild("HumanoidPart") then
            local dist = (player.Character.HumanoidPart.Position - hrp.Position).Magnitude
            labelDistance.Text = "📏 " .. math.floor(dist) .. "m"
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
                labelHealth.Text = "♥ " .. healthPercent .. "%"
                if healthPercent > 75 then
                    labelHealth.TextColor3 = Color3.new(0,1,0)
                elseif healthPercent > 25 then
                    labelHealth.TextColor3 = Color3.new(1,1,0)
                else
                    labelHealth.TextColor3 = Color3.new(1,0,0)
                end

                if humanoid.MoveDirection.Magnitude > 0 then
                    labelStatus.Text = "🏃 Moving"
                elseif humanoid.Jump then
                    labelStatus.Text = "🦘 Jumping"
                else
                    labelStatus.Text = "🧍 Idle"
                end
            end 
        else
            connection:Disconnect()
        end
    end)
    
    ScriptState.connections[targetPlayer.Name] = {esp, connection}
end

local function toggleESP()
    if ScriptState.espEnabled then
        -- Turn off ESP
        for _, data in pairs(ScriptState.connections) do
            if type(data) == 'table' and data[1] then
                data[1]:Destroy()
                if data[2] then data[2]:Disconnect() end
            end
        end
        ScriptState.connections = {}
        ScriptState.espEnabled = false
        notify("ESP", "Disabled", 2)
    else
        -- Turn on ESP
        ScriptState.espEnabled = true
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= player and player.Character then
                createESP(player)
            end
        end
        ScriptState.connections.playerAdded = Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function()
                wait(2)
                if ScriptState.espEnabled then
                    createESP(plr)
                end
            end)
        end)
        notify("ESP", "Enabled", 2)
    end
end

-- Implementation of other features (Fly, Speed, GodMode, etc.) would follow similar approach.

