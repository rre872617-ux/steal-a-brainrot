-- AMS ULTIMATE SCRIPT v3.0 - STEAL A BRAINROT EDITION
-- LE MEILLEUR SCRIPT AVEC TOUTES LES FONCTIONS
-- Compatible tous executors - Spécialement optimisé pour Steal a Brainrot
 
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
 
-- Variables globales
local player = Players.LocalPlayer
repeat wait() until player
repeat wait() until player.Character
repeat wait() until player.Character:FindFirstChild("HumanoidRootPart")
 
-- États des fonctions
local ScriptState = {
    basePosition = nil,
    baseMarked = false,
    espEnabled = false,
    noCollisionEnabled = false,
    flyEnabled = false,
    speedEnabled = false,
    godModeEnabled = false,
    infiniteJumpEnabled = false,
    wallhackEnabled = false,
    autoFarmEnabled = false,
    antiAfkEnabled = false,
    superJumpEnabled = false,
    connections = {}
}
 
-- Notification système
local function notify(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "🔥 " .. title,
            Text = text,
            Duration = duration or 3,
            Icon = "rbxassetid://2541869220"
        })
    end)
end
 
-- ESP WALLHACK SYSTEM - Ultra avancé
local function createESP(targetPlayer)
    if targetPlayer == player or not targetPlayer.Character then return end
    
    local char = targetPlayer.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Supprimer ancien ESP
    for _, v in pairs(hrp:GetChildren()) do
        if v.Name == "AMS_ESP" then v:Destroy() end
    end
    
    -- Créer ESP avancé
    local esp = Instance.new("BillboardGui")
    esp.Name = "AMS_ESP"
    esp.Adornee = hrp
    esp.Size = UDim2.new(0, 250, 0, 150)
    esp.StudsOffset = Vector3.new(0, 5, 0)
    esp.AlwaysOnTop = true
    esp.Parent = hrp
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.new(1, 0.1, 0.5)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 3
    frame.BorderColor3 = Color3.new(0, 1, 0.2)
    frame.Parent = esp
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.0, Color3.new(1, 0.2, 0.8)),
        ColorSequenceKeypoint.new(1.0, Color3.new(0.8, 0.1, 1))
    }
    gradient.Rotation = 45
    gradient.Parent = frame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.3, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "🎯 " .. targetPlayer.Name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.Parent = frame
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, 0, 0.25, 0)
    distLabel.Position = UDim2.new(0, 0, 0.3, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "📏 0m"
    distLabel.TextColor3 = Color3.new(1, 1, 0)
    distLabel.TextScaled = true
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextStrokeTransparency = 0
    distLabel.Parent = frame
    
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 0.25, 0)
    healthLabel.Position = UDim2.new(0, 0, 0.55, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "❤️ 100%"
    healthLabel.TextColor3 = Color3.new(0, 1, 0)
    healthLabel.TextScaled = true
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.TextStrokeTransparency = 0
    healthLabel.Parent = frame
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 0.2, 0)
    statusLabel.Position = UDim2.new(0, 0, 0.8, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "🔥 VISIBLE"
    statusLabel.TextColor3 = Color3.new(1, 0.5, 0)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.GothamSemibold
    statusLabel.TextStrokeTransparency = 0
    statusLabel.Parent = frame
    
    -- Mise à jour temps réel
    local connection = RunService.Heartbeat:Connect(function()
        if hrp and hrp.Parent and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            distLabel.Text = "📏 " .. math.floor(distance) .. "m"
            
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
                healthLabel.Text = "❤️ " .. healthPercent .. "%"
                healthLabel.TextColor3 = healthPercent > 75 and Color3.new(0, 1, 0) or 
                                       healthPercent > 25 and Color3.new(1, 1, 0) or Color3.new(1, 0, 0)
                
                -- Statut du joueur
                if humanoid.MoveDirection.Magnitude > 0 then
                    statusLabel.Text = "🏃 MOVING"
                elseif humanoid.Jump then
                    statusLabel.Text = "🦘 JUMPING"
                else
                    statusLabel.Text = "🧍 IDLE"
                end
            end
        else
            connection:Disconnect()
        end
    end)
    
    ScriptState.connections[targetPlayer.Name] = {esp, connection}
end
 
local function toggleESP()
    ScriptState.espEnabled = not ScriptState.espEnabled
    
    if ScriptState.espEnabled then
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if targetPlayer ~= player and targetPlayer.Character then
                createESP(targetPlayer)
            end
        end
        
        -- Auto-create ESP for new players
        ScriptState.connections.playerAdded = Players.PlayerAdded:Connect(function(newPlayer)
            newPlayer.CharacterAdded:Connect(function()
                wait(2)
                if ScriptState.espEnabled then
                    createESP(newPlayer)
                end
            end)
        end)
        
        notify("ESP WALLHACK", "Activé - Voir tous les joueurs", 2)
    else
        -- Nettoyer tous les ESP
        for playerName, data in pairs(ScriptState.connections) do
            if type(data) == "table" and data[1] and data[2] then
                data[1]:Destroy()
                data[2]:Disconnect()
                ScriptState.connections[playerName] = nil
            end
        end
        
        if ScriptState.connections.playerAdded then
            ScriptState.connections.playerAdded:Disconnect()
            ScriptState.connections.playerAdded = nil
        end
        
        notify("ESP WALLHACK", "Désactivé", 2)
    end
end
 
-- NO COLLISION SYSTEM - Traverse tout
local function toggleNoCollision()
    ScriptState.noCollisionEnabled = not ScriptState.noCollisionEnabled
    
    if ScriptState.noCollisionEnabled then
        local function setNoCollision()
            if player.Character then
                for _, part in pairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = false
                    end
                end
            end
        end
        
        setNoCollision()
        ScriptState.connections.noCollision = RunService.Heartbeat:Connect(function()
            setNoCollision()
        end)
        
        notify("NO COLLISION", "Activé - Traverse TOUT!", 2)
    else
        if ScriptState.connections.noCollision then
            ScriptState.connections.noCollision:Disconnect()
            ScriptState.connections.noCollision = nil
        end
        
        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
        
        notify("NO COLLISION", "Désactivé", 2)
    end
end
 
-- FLY SYSTEM - Vol avancé
local function toggleFly()
    ScriptState.flyEnabled = not ScriptState.flyEnabled
    
    if ScriptState.flyEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = hrp
        
        local bodyPosition = Instance.new("BodyPosition")
        bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyPosition.Position = hrp.Position
        bodyPosition.Parent = hrp
        
        ScriptState.connections.fly = RunService.Heartbeat:Connect(function()
            if ScriptState.flyEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                local camera = workspace.CurrentCamera
                local moveVector = Vector3.new(0, 0, 0)
                local speed = 80
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveVector = moveVector + camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveVector = moveVector - camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveVector = moveVector - camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveVector = moveVector + camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveVector = moveVector + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveVector = moveVector - Vector3.new(0, 1, 0)
                end
                
                bodyVelocity.Velocity = moveVector * speed
                bodyPosition.Position = hrp.Position + (moveVector * 3)
            end
        end)
        
        notify("FLY MODE", "Activé - WASD + Space/Shift", 3)
    else
        if ScriptState.connections.fly then
            ScriptState.connections.fly:Disconnect()
            ScriptState.connections.fly = nil
        end
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, obj in pairs(player.Character.HumanoidRootPart:GetChildren()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") then
                    obj:Destroy()
                end
            end
        end
        
        notify("FLY MODE", "Désactivé", 2)
    end
end
 
-- SPEED SYSTEM - Vitesse ultra
local function toggleSpeed()
    ScriptState.speedEnabled = not ScriptState.speedEnabled
    
    if ScriptState.speedEnabled then
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 150
            notify("SPEED BOOST", "Vitesse MAX activée!", 2)
        end
    else
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
            notify("SPEED BOOST", "Vitesse normale", 2)
        end
    end
end
 
-- SUPER JUMP SYSTEM
local function toggleSuperJump()
    ScriptState.superJumpEnabled = not ScriptState.superJumpEnabled
    
    if ScriptState.superJumpEnabled then
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = 150
            player.Character.Humanoid.JumpHeight = 150
            notify("SUPER JUMP", "Saut ultra-puissant!", 2)
        end
    else
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = 50
            player.Character.Humanoid.JumpHeight = 7.2
            notify("SUPER JUMP", "Saut normal", 2)
        end
    end
end
 
-- INFINITE JUMP SYSTEM
local function toggleInfiniteJump()
    ScriptState.infiniteJumpEnabled = not ScriptState.infiniteJumpEnabled
    
    if ScriptState.infiniteJumpEnabled then
        ScriptState.connections.infiniteJump = UserInputService.JumpRequest:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        notify("INFINITE JUMP", "Saut infini activé!", 2)
    else
        if ScriptState.connections.infiniteJump then
            ScriptState.connections.infiniteJump:Disconnect()
            ScriptState.connections.infiniteJump = nil
        end
        notify("INFINITE JUMP", "Désactivé", 2)
    end
end
 
-- GOD MODE SYSTEM - Invincibilité
local function toggleGodMode()
    ScriptState.godModeEnabled = not ScriptState.godModeEnabled
    
    if ScriptState.godModeEnabled then
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.MaxHealth = math.huge
            player.Character.Humanoid.Health = math.huge
            
            ScriptState.connections.godMode = player.Character.Humanoid.HealthChanged:Connect(function()
                if ScriptState.godModeEnabled then
                    player.Character.Humanoid.Health = math.huge
                end
            end)
            
            notify("GOD MODE", "Invincibilité ON!", 2)
        end
    else
        if ScriptState.connections.godMode then
            ScriptState.connections.godMode:Disconnect()
            ScriptState.connections.godMode = nil
        end
        
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.MaxHealth = 100
            player.Character.Humanoid.Health = 100
        end
        
        notify("GOD MODE", "Désactivé", 2)
    end
end
 
-- ANTI AFK SYSTEM
local function toggleAntiAFK()
    ScriptState.antiAfkEnabled = not ScriptState.antiAfkEnabled
    
    if ScriptState.antiAfkEnabled then
        ScriptState.connections.antiAfk = RunService.Heartbeat:Connect(function()
            if ScriptState.antiAfkEnabled then
                local VirtualUser = game:GetService("VirtualUser")
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end
        end)
        notify("ANTI AFK", "Protection AFK activée!", 2)
    else
        if ScriptState.connections.antiAfk then
            ScriptState.connections.antiAfk:Disconnect()
            ScriptState.connections.antiAfk = nil
        end
        notify("ANTI AFK", "Désactivé", 2)
    end
end
 
-- BASE TELEPORT SYSTEM - Amélioré
local function markBase()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        ScriptState.basePosition = player.Character.HumanoidRootPart.Position
        ScriptState.baseMarked = true
        
        -- Marqueur visuel ultra
        local marker = Instance.new("Part")
        marker.Name = "AMS_BaseMarker"
        marker.Shape = Enum.PartType.Cylinder
        marker.Material = Enum.Material.ForceField
        marker.BrickColor = BrickColor.new("Bright green")
        marker.Size = Vector3.new(2, 20, 20)
        marker.Anchored = true
        marker.CanCollide = false
        marker.Position = ScriptState.basePosition + Vector3.new(0, -5, 0)
        marker.Rotation = Vector3.new(0, 0, 90)
        marker.Parent = workspace
        
        -- Effet lumineux
        local pointLight = Instance.new("PointLight")
        pointLight.Color = Color3.new(0, 1, 0)
        pointLight.Brightness = 2
        pointLight.Range = 50
        pointLight.Parent = marker
        
        -- Animation rotation
        local tween = TweenService:Create(marker, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = Vector3.new(0, 360, 90)})
        tween:Play()
        
        -- Animation pulsation
        local scaleTween = TweenService:Create(marker, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Size = Vector3.new(2, 25, 25)})
        scaleTween:Play()
        
        notify("BASE MARQUÉE", "Position sauvegardée avec effets!", 3)
    end
end
 
local function teleportToBase()
    if ScriptState.baseMarked and ScriptState.basePosition and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(ScriptState.basePosition + Vector3.new(0, 10, 0))
        
        -- Effet de téléportation amélioré
        local explosion = Instance.new("Explosion")
        explosion.Position = player.Character.HumanoidRootPart.Position
        explosion.BlastRadius = 0
        explosion.BlastPressure = 0
        explosion.Visible = true
        explosion.Parent = workspace
        
        -- Particules
        for i = 1, 10 do
            local part = Instance.new("Part")
            part.Size = Vector3.new(0.5, 0.5, 0.5)
            part.Material = Enum.Material.Neon
            part.BrickColor = BrickColor.new("Bright blue")
            part.Position = player.Character.HumanoidRootPart.Position + Vector3.new(math.random(-5, 5), math.random(-2, 8), math.random(-5, 5))
            part.Anchored = false
            part.CanCollide = false
            part.Parent = workspace
            
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyVelocity.Velocity = Vector3.new(math.random(-10, 10), math.random(5, 15), math.random(-10, 10))
            bodyVelocity.Parent = part
            
            game:GetService("Debris"):AddItem(part, 3)
        end
        
        notify("TÉLÉPORTÉ", "Retour à la base avec style!", 2)
    else
        notify("ERREUR", "Marquez d'abord une base!", 2)
    end
end
 
-- BYPASS WALLS/DOORS SYSTEM - Spécial Steal a Brainrot
local function bypassWalls()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("wall") or obj.Name:lower():find("door") or obj.Name:lower():find("barrier")) then
            obj.CanCollide = false
        end
    end
    notify("WALL BYPASS", "Tous les murs/portes désactivés!", 2)
end
 
-- INTERFACE GUI ULTRA-MODERNE
local function createUltimateInterface()
    -- Supprimer l'ancienne interface
    if player.PlayerGui:FindFirstChild("AMS_UltimateScript") then
        player.PlayerGui.AMS_UltimateScript:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AMS_UltimateScript"
    screenGui.ResetOnSpawn = false
    
    -- Protection GUI
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(screenGui)
        elseif gethui then
            screenGui.Parent = gethui()
        else
            screenGui.Parent = player.PlayerGui
        end
    end)
    
    if not screenGui.Parent then
        screenGui.Parent = player.PlayerGui
    end
    
    -- Frame principal ultra-moderne
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 480, 0, 650)
    mainFrame.Position = UDim2.new(0.5, -240, 0.5, -325)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Coins arrondis
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 25)
    mainCorner.Parent = mainFrame
    
    -- Bordure néon
    local border = Instance.new("UIStroke")
    border.Color = Color3.fromRGB(255, 100, 200)
    border.Thickness = 3
    border.Parent = mainFrame
    
    -- Gradient animé
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(25, 25, 40)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 15, 25)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(30, 10, 35))
    }
    gradient.Rotation = 45
    gradient.Parent = mainFrame
    
    -- Animation du gradient
    spawn(function()
        while screenGui.Parent do
            for i = 0, 360, 5 do
                if not screenGui.Parent then break end
                gradient.Rotation = i
                wait(0.05)
            end
        end
    end)
    
    -- Header ultra-premium
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 80)
    header.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 25)
    headerCorner.Parent = header
    
    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 100, 200)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 50, 150)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(200, 50, 255))
    }
    headerGradient.Rotation = 90
    headerGradient.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🔥 AMS ULTIMATE - STEAL A BRAINROT 🔥"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.TextStrokeTransparency = 0
    title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    title.Parent = header
    
    -- Animation du titre
    spawn(function()
        while screenGui.Parent do
            for i = 1, 10 do
                title.TextColor3 = Color3.fromHSV(i/10, 1, 1)
                wait(0.1)
            end
        end
    end)
    
    -- Bouton fermer stylé
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 60, 0, 60)
    closeBtn.Position = UDim2.new(1, -70, 0, 10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = header
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 20)
    closeBtnCorner.Parent = closeBtn
    
    -- Fonction pour créer des boutons ultra-stylés
    local function createUltraButton(text, position, size, color, callback, isToggle)
        local btn = Instance.new("TextButton")
        btn.Size = size
        btn.Position = position
        btn.BackgroundColor3 = color
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.Parent = mainFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 15)
        btnCorner.Parent = btn
        
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = Color3.fromRGB(255, 255, 255)
        btnStroke.Thickness = 2
        btnStroke.Transparency = 0.5
        btnStroke.Parent = btn
        
        local btnGradient = Instance.new("UIGradient")
        btnGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0.0, Color3.fromRGB(math.min(color.R * 255 + 30, 255), math.min(color.G * 255 + 30, 255), math.min(color.B * 255 + 30, 255))),
            ColorSequenceKeypoint.new(1.0, color)
        }
        btnGradient.Rotation = 45
        btnGradient.Parent = btn
        
        -- Effet de texte
        btn.TextStrokeTransparency = 0
        btn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        
        btn.MouseButton1Click:Connect(callback)
        
        -- Animations avancées
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                Size = size + UDim2.new(0, 8, 0, 8),
                BackgroundColor3 = Color3.fromRGB(math.min(color.R * 255 + 50, 255), math.min(color.G * 255 + 50, 255), math.min(color.B * 255 + 50, 255))
            }):Play()
            TweenService:Create(btnGradient, TweenInfo.new(0.2), {Rotation = 135}):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0, Thickness = 3}):Play()
        end)
        
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {Size = size, BackgroundColor3 = color}):Play()
            TweenService:Create(btnGradient, TweenInfo.new(0.2), {Rotation = 45}):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0.5, Thickness = 2}):Play()
        end)
        
        return btn
    end
    
    -- BOUTONS PRINCIPAUX (Ligne 1)
    local markBtn = createUltraButton("🏠 MARQUER BASE", UDim2.new(0, 20, 0, 100), UDim2.new(0.3, -15, 0, 50), Color3.fromRGB(0, 200, 100), markBase)
    local tpBtn = createUltraButton("🚀 TÉLÉPORTER", UDim2.new(0.33, 0, 0, 100), UDim2.new(0.34, -10, 0, 50), Color3.fromRGB(0, 150, 255), teleportToBase)
    local bypassBtn = createUltraButton("🔓 BYPASS WALLS", UDim2.new(0.67, 10, 0, 100), UDim2.new(0.3, -15, 0, 50), Color3.fromRGB(255, 150, 0), bypassWalls)
    
    -- BOUTONS TOGGLE AVANCÉS
    local espBtn = createUltraButton("👁️ ESP: OFF", UDim2.new(0, 20, 0, 170), UDim2.new(1, -40, 0, 55), Color3.fromRGB(200, 50, 50), function()
        toggleESP()
        espBtn.Text = ScriptState.espEnabled and "👁️ ESP WALLHACK: ON" or "👁️ ESP WALLHACK: OFF"
        espBtn.BackgroundColor3 = ScriptState.espEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    end, true)
    
    local ncBtn = createUltraButton("👻 NO COLLISION: OFF", UDim2.new(0, 20, 0, 240), UDim2.new(1, -40, 0, 55), Color3.fromRGB(200, 50, 50), function()
        toggleNoCollision()
        ncBtn.Text = ScriptState.noCollisionEnabled and "👻 NO COLLISION: ON" or "👻 NO COLLISION: OFF"
        ncBtn.BackgroundColor3 = ScriptState.noCollisionEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    end, true)
    
    local flyBtn = createUltraButton("✈️ FLY MODE: OFF", UDim2.new(0, 20, 0, 310), UDim2.new(0.48, -10, 0, 55), Color3.fromRGB(200, 50, 50), function()
        toggleFly()
        flyBtn.Text = ScriptState.flyEnabled and "✈️ FLY MODE: ON" or "✈️ FLY MODE: OFF"
        flyBtn.BackgroundColor3 = ScriptState.flyEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    end, true)
    
    local speedBtn = createUltraButton("⚡ SPEED: OFF", UDim2.new(0.52, 10, 0, 310), UDim2.new(0.48, -30, 0, 55), Color3.fromRGB(200, 50, 50), function()
        toggleSpeed()
        speedBtn.Text = ScriptState.speedEnabled and "⚡ SPEED BOOST: ON" or "⚡ SPEED BOOST: OFF"
        speedBtn.BackgroundColor3 = ScriptState.speedEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    end, true)
    
    local superJumpBtn = createUltraButton("🦘 SUPER JUMP: OFF", UDim2.new(0, 20, 0, 380), UDim2.new(0.48, -10, 0, 55), Color3.fromRGB(200, 50, 50), function()
        toggleSuperJump()
        superJumpBtn.Text = ScriptState.superJumpEnabled and "🦘 SUPER JUMP: ON" or "🦘 SUPER JUMP: OFF"
        superJumpBtn.BackgroundColor3 = ScriptState.superJumpEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    end, true)
    
    local infJumpBtn = createUltraButton("🔄 INFINITE JUMP: OFF", UDim2.new(0.52, 10, 0, 380), UDim2.new(0.48, -30, 0, 55), Color3.fromRGB(200, 50, 50), function()
        toggleInfiniteJump()
        infJumpBtn.Text = ScriptState.infiniteJumpEnabled and "🔄 INFINITE JUMP: ON" or "🔄 INFINITE JUMP: OFF"
        infJumpBtn.BackgroundColor3 = ScriptState.infiniteJumpEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    end, true)
    
    local godBtn = createUltraButton("🛡️ GOD MODE: OFF", UDim2.new(0, 20, 0, 450), UDim2.new(0.48, -10, 0, 55), Color3.fromRGB(200, 50, 50), function()
        toggleGodMode()
        godBtn.Text = ScriptState.godModeEnabled and "🛡️ GOD MODE: ON" or "🛡️ GOD MODE: OFF"
        godBtn.BackgroundColor3 = ScriptState.godModeEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    end, true)
    
    local antiAfkBtn = createUltraButton("😴 ANTI AFK: OFF", UDim2.new(0.52, 10, 0, 450), UDim2.new(0.48, -30, 0, 55), Color3.fromRGB(200, 50, 50), function()
        toggleAntiAFK()
        antiAfkBtn.Text = ScriptState.antiAfkEnabled and "😴 ANTI AFK: ON" or "😴 ANTI AFK: OFF"
        antiAfkBtn.BackgroundColor3 = ScriptState.antiAfkEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    end, true)
    
    -- INFORMATIONS PREMIUM EN BAS
    local infoFrame = Instance.new("Frame")
    infoFrame.Size = UDim2.new(1, -40, 0, 80)
    infoFrame.Position = UDim2.new(0, 20, 1, -100)
    infoFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    infoFrame.BorderSizePixel = 0
    infoFrame.Parent = mainFrame
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 15)
    infoCorner.Parent = infoFrame
    
    local infoStroke = Instance.new("UIStroke")
    infoStroke.Color = Color3.fromRGB(100, 255, 200)
    infoStroke.Thickness = 2
    infoStroke.Parent = infoFrame
    
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, 0, 1, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "💎 AMS ULTIMATE - Spécial STEAL A BRAINROT 💎\n🎮 Fly: WASD + Space/Shift | 🔥 Toutes fonctions actives"
    infoLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
    infoLabel.TextScaled = true
    infoLabel.Font = Enum.Font.GothamBold
    infoLabel.TextStrokeTransparency = 0
    infoLabel.Parent = infoFrame
    
    -- Animation des infos
    spawn(function()
        while screenGui.Parent do
            for i = 1, 20 do
                infoStroke.Color = Color3.fromHSV(i/20, 1, 1)
                wait(0.1)
            end
        end
    end)
    
    -- Bouton minimiser premium
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 150, 0, 50)
    minimizeBtn.Position = UDim2.new(0, 20, 1, -60)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
    minimizeBtn.Text = "📱 MINIMISER"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.TextScaled = true
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = screenGui
    minimizeBtn.Visible = false
    
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 15)
    minCorner.Parent = minimizeBtn
    
    -- Événements
    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        minimizeBtn.Visible = true
    end)
    
    minimizeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = true
        minimizeBtn.Visible = false
    end)
end
 
-- GESTION DES RESPAWNS AVANCÉE
player.CharacterAdded:Connect(function(character)
    repeat wait() until character:FindFirstChild("HumanoidRootPart")
    wait(2)
    
    -- Réappliquer les fonctions actives après respawn
    if ScriptState.noCollisionEnabled then
        ScriptState.noCollisionEnabled = false
        toggleNoCollision()
    end
    
    if ScriptState.speedEnabled then
        ScriptState.speedEnabled = false
        toggleSpeed()
    end
    
    if ScriptState.superJumpEnabled then
        ScriptState.superJumpEnabled = false
        toggleSuperJump()
    end
    
    if ScriptState.godModeEnabled then
        ScriptState.godModeEnabled = false
        toggleGodMode()
    end
    
    if ScriptState.infiniteJumpEnabled then
        ScriptState.infiniteJumpEnabled = false
        toggleInfiniteJump()
    end
    
    notify("RESPAWN", "Toutes les fonctions réappliquées!", 2)
end)
 
-- INITIALISATION COMPLÈTE
wait(3)
notify("AMS ULTIMATE", "Script chargé! Interface créée avec succès.", 5)
createUltimateInterface()
 
-- Auto-bypass des murs au démarrage
bypassWalls()
 
print("=== AMS ULTIMATE SCRIPT v3.0 LOADED ===")
print("✅ Interface ultra-moderne créée")
print("🎮 Toutes les fonctions opérationnelles")
print("🔥 ESP Wallhack avancé")
print("👻 No Collision perfectionné") 
print("✈️ Fly system premium")
print("⚡ Speed boost ultra")
print("🦘 Super Jump + Infinite Jump")
print("🛡️ God Mode invincibilité")
print("😴 Anti AFK automatique")
print("🔓 Bypass walls/doors")
print("💎 Spécialement optimisé pour STEAL A BRAINROT")
print("=======================================")
