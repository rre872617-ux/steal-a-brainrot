-- == [ MHX HUB STEAL A BRAINROT v2 ] ==
-- Compatible 1:1 con el original. Nombres intactos. Optimizado.
-- Solo para cuentas desechables.

-- ✅ Validación de entorno
if game.PlaceId ~= 123456789 then -- ⚠️ REEMPLAZA 123456789 con el Place ID REAL de "Steal a Brainrot"
    warn("[MHX HUB] ❌ Este script solo funciona en 'Steal a Brainrot'")
    return
end

-- ✅ Carga segura de Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield', true))()

local Window = Rayfield:CreateWindow({
    Name = "MHX HUB STEAL A BRAİNROT",
    Icon = 0,
    LoadingTitle = "MHX HUB",
    LoadingSubtitle = "by Sirius",
    ShowText = "MHX HUB",
    Theme = "Default",
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MHX_HUB",
        FileName = "StealABrainrot"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false
})

-- ✅ Gestor global de conexiones (evita memory leaks)
local ActiveConnections = {}

local function CleanupConnections(key)
    if ActiveConnections[key] then
        for _, conn in ipairs(ActiveConnections[key]) do
            if conn and typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
        ActiveConnections[key] = nil
    end
end

-- ✅ Función robusta para FireServer
local function SafeFire(remote)
    pcall(function()
        remote:FireServer()
    end)
end

-- PLAYER Tab
local PlayerTab = Window:CreateTab("Player", 0)

-- 1) Speed 50
local SpeedEnabled = false
PlayerTab:CreateToggle({
    Name = "Speed 50",
    CurrentValue = false,
    Callback = function(Value)
        SpeedEnabled = Value
        local player = game.Players.LocalPlayer
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        if humanoid then
            if SpeedEnabled then
                humanoid.WalkSpeed = 50
                CleanupConnections("Speed")
                table.insert(ActiveConnections, humanoid.StateChanged:Connect(function(_, newState)
                    if newState == Enum.HumanoidStateType.Running and SpeedEnabled then
                        local root = humanoid.Parent:FindFirstChild("HumanoidRootPart")
                        if root then
                            local moveDir = humanoid.MoveDirection
                            if moveDir.Magnitude > 0 then
                                root.Velocity = Vector3.new(moveDir.X * 50, root.Velocity.Y, moveDir.Z * 50)
                            end
                        end
                    end
                end))
            else
                humanoid.WalkSpeed = 16
                CleanupConnections("Speed")
            end
        end
    end
})

-- 2) Wall Hack
local WallHackEnabled = false
PlayerTab:CreateToggle({
    Name = "Wall Hack",
    CurrentValue = false,
    Callback = function(Value)
        WallHackEnabled = Value
        if WallHackEnabled then
            for _, base in pairs(workspace:GetDescendants()) do
                if base:IsA("BasePart") and base.CanCollide then
                    base.CanCollide = false
                end
            end
            CleanupConnections("WallHack")
            table.insert(ActiveConnections, game:GetService("RunService").Stepped:Connect(function()
                if WallHackEnabled then
                    local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
                    end
                end
            end))
        else
            for _, base in pairs(workspace:GetDescendants()) do
                if base:IsA("BasePart") then
                    base.CanCollide = true
                end
            end
            CleanupConnections("WallHack")
        end
    end
})

-- 3) Fly
local FlyEnabled = false
PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(Value)
        FlyEnabled = Value
        local player = game.Players.LocalPlayer
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            if FlyEnabled then
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.Parent = root
                CleanupConnections("Fly")
                table.insert(ActiveConnections, game:GetService("RunService").RenderStepped:Connect(function()
                    if FlyEnabled then
                        local UIS = game:GetService("UserInputService")
                        local cam = workspace.CurrentCamera
                        local move = Vector3.new(
                            (UIS:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UIS:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
                            (UIS:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) - (UIS:IsKeyDown(Enum.KeyCode.LeftShift) and 1 or 0),
                            (UIS:IsKeyDown(Enum.KeyCode.W) and 1 or 0) - (UIS:IsKeyDown(Enum.KeyCode.S) and 1 or 0)
                        )
                        bodyVelocity.Velocity = cam.CFrame:VectorToWorldSpace(move * 50)
                    end
                end))
            else
                for _, v in pairs(root:GetChildren()) do
                    if v:IsA("BodyVelocity") then v:Destroy() end
                end
                CleanupConnections("Fly")
            end
        end
    end
})

-- ESP Tab
local ESPTab = Window:CreateTab("ESP", 0)

-- 1) Player ESP
local PlayerESPEnabled = false
ESPTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(Value)
        PlayerESPEnabled = Value
        if PlayerESPEnabled then
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr ~= game.Players.LocalPlayer and plr.Character then
                    local hl = Instance.new("Highlight")
                    hl.FillColor = Color3.fromRGB(128, 0, 128)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 0)
                    hl.Parent = plr.Character
                end
            end
            game.Players.PlayerAdded:Connect(function(plr)
                plr.CharacterAdded:Connect(function(char)
                    if PlayerESPEnabled then
                        local hl = Instance.new("Highlight")
                        hl.FillColor = Color3.fromRGB(128, 0, 128)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 0)
                        hl.Parent = char
                    end
                end)
            end)
        else
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr.Character then
                    for _, v in pairs(plr.Character:GetChildren()) do
                        if v:IsA("Highlight") then v:Destroy() end
                    end
                end
            end
        end
    end
})

-- 2) Brainrots ESP
local BrainrotsESPEnabled = false
ESPTab:CreateToggle({
    Name = "Brainrots ESP",
    CurrentValue = false,
    Callback = function(Value)
        BrainrotsESPEnabled = Value
        if BrainrotsESPEnabled then
            for _, item in pairs(workspace:GetDescendants()) do
                if item.Name:match("Brainrot") or item.Name:match("Tralelero") or item.Name:match("Saturnita") then
                    local hl = Instance.new("Highlight")
                    hl.FillColor = Color3.fromRGB(0, 0, 255)
                    hl.OutlineColor = Color3.fromRGB(255, 0, 0)
                    hl.Parent = item
                end
            end
        else
            for _, item in pairs(workspace:GetDescendants()) do
                for _, v in pairs(item:GetChildren()) do
                    if v:IsA("Highlight") then v:Destroy() end
                end
            end
        end
    end
})

-- Explosions Tab
local ExplosionsTab = Window:CreateTab("Explosions 💥", 0)

-- Función para obtener delay inteligente
local function GetSmartDelay()
    return 0.22 + math.random() * 0.06 -- 0.22 a 0.28s
end

-- 1) Play Most Valuable Brainrot
ExplosionsTab:CreateButton({
    Name = "Play Most Valuable Brainrot",
    Callback = function()
        local player = game.Players.LocalPlayer
        local mostValuable = nil
        local highestValue = 0
        for _, item in pairs(workspace:GetDescendants()) do
            if item.Name:match("Brainrot") and item:FindFirstChild("Value") then
                local value = item.Value.Value
                if value > highestValue then
                    highestValue = value
                    mostValuable = item
                end
            end
        end
        if mostValuable and player.Character then
            mostValuable.Parent = player.Character
            local base = workspace:FindFirstChild("Base")
            if base then
                player.Character.HumanoidRootPart.CFrame = base.CFrame
            end
        end
    end
})

-- 2) Tung Bat All Players
ExplosionsTab:CreateButton({
    Name = "Tung Bat All Players",
    Callback = function()
        local player = game.Players.LocalPlayer
        for _, target in pairs(game.Players:GetPlayers()) do
            if target ~= player and target.Character then
                local tool = player.Backpack:FindFirstChild("TungYarasa") or player.Character:FindFirstChild("TungYarasa")
                if tool then
                    SafeFire(tool)
                    target.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(5, 0, 0)
                end
            end
        end
    end
})

-- 3) Steal Brainrots
ExplosionsTab:CreateButton({
    Name = "Steal Brainrots",
    Callback = function()
        local player = game.Players.LocalPlayer
        local valuableBrainrots = {"Tralelero", "Saturnita", "Balerina Capucina", "Coco Fanto Ele Fanto", "orcalero Orcala", "odin din dun", "Dragons"}
        for _, item in pairs(workspace:GetDescendants()) do
            for _, brainrot in pairs(valuableBrainrots) do
                if item.Name == brainrot then
                    item.Parent = player.Character
                end
            end
        end
    end
})

-- 4) Auto Close
ExplosionsTab:CreateButton({
    Name = "Auto Close",
    Callback = function()
        wait(27)
        local player = game.Players.LocalPlayer
        local base = workspace:FindFirstChild("Base")
        if base and base:FindFirstChild("CloseButton") then
            player.Character.HumanoidRootPart.CFrame = base.CloseButton.CFrame
            local cd = base.CloseButton:FindFirstChildOfClass("ClickDetector")
            if cd then
                fireclickdetector(cd)
            end
        end
    end
})

-- 5) No Falling
local NoFallingEnabled = false
ExplosionsTab:CreateToggle({
    Name = "No Falling",
    CurrentValue = false,
    Callback = function(Value)
        NoFallingEnabled = Value
        if NoFallingEnabled then
            local player = game.Players.LocalPlayer
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                CleanupConnections("NoFalling")
                table.insert(ActiveConnections, humanoid.StateChanged:Connect(function(_, newState)
                    if newState == Enum.HumanoidStateType.FallingDown and NoFallingEnabled then
                        humanoid:ChangeState(Enum.HumanoidStateType.Running)
                        local brainrot = player.Character:FindFirstChildWhichIsA("Tool")
                        if brainrot then
                            local base = workspace:FindFirstChild("Base")
                            if base then
                                brainrot.Parent = base
                            end
                        end
                    end
                end))
            end
        else
            CleanupConnections("NoFalling")
        end
    end
})

-- 6) Go Base
ExplosionsTab:CreateButton({
    Name = "Go Base",
    Callback = function()
        local player = game.Players.LocalPlayer
        local base = workspace:FindFirstChild("Base")
        if base and player.Character then
            player.Character.HumanoidRootPart.CFrame = base.CFrame
        end
    end
})

-- 7) Laser Block
ExplosionsTab:CreateButton({
    Name = "Laser Block",
    Callback = function()
        for _, base in pairs(workspace:GetDescendants()) do
            if base.Name:match("Laser") then
                base:Destroy()
            end
        end
    end
})

-- ✅ Ghost Mode: ocultar UI y detener loops al presionar K
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.K and not processed then
        if Window then
            local isVisible = Rayfield:IsVisible()
            Rayfield:SetVisibility(not isVisible)
            if not isVisible then
                -- Al mostrar, no reactivar loops (solo el usuario lo hace manualmente)
            else
                -- Al ocultar, detener TODO
                SpeedEnabled = false
                WallHackEnabled = false
                FlyEnabled = false
                PlayerESPEnabled = false
                BrainrotsESPEnabled = false
                NoFallingEnabled = false
                for k in pairs(ActiveConnections) do
                    CleanupConnections(k)
                end
            end
        end
    end
end)

-- Notificación final
Rayfield:Notify({
    Title = "MHX HUB v2",
    Content = "Optimizado. Menos ruido, más control.",
    Duration = 5
})

-- Fin del script
