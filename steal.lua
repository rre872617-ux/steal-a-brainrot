-- == [ Steal An Brainrot - Optimized ] ==
-- Place ID: 100851641119066
-- Solo para cuentas desechables.

if game.PlaceId ~= 100851641119066 then
    warn("[StealABrainrot] ❌ Este script solo funciona en 'Steal An Brainrots - ADMIN MODDED'")
    return
end

-- ✅ Carga segura de Rayfield desde fuente oficial
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/refs/heads/main/source.lua', true))()

local Window = Rayfield:CreateWindow({
    Name = "Steal A Brainrot Hub",
    Icon = 4483362458,
    LoadingTitle = "Brainrot Optimus",
    LoadingSubtitle = "by Voidware",
    ShowText = "Brainrot Hub",
    Theme = "Amethyst",
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = true,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BrainrotHub",
        FileName = "Config"
    },
    KeySystem = false
})

-- Gestor de conexiones
local ActiveConnections = {}
local function Cleanup(key)
    if ActiveConnections[key] then
        for _, conn in ipairs(ActiveConnections[key]) do
            if conn and typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
        ActiveConnections[key] = nil
    end
end

-- Player Tab
local PlayerTab = Window:CreateTab("Player", 4483362458)

-- Speed 50
local SpeedEnabled = false
PlayerTab:CreateToggle({
    Name = "Speed 50",
    CurrentValue = false,
    Callback = function(Value)
        SpeedEnabled = Value
        local plr = game.Players.LocalPlayer
        local hum = plr.Character and plr.Character:FindFirstChild("Humanoid")
        if hum then
            if SpeedEnabled then
                hum.WalkSpeed = 50
                Cleanup("Speed")
                table.insert(ActiveConnections, hum.StateChanged:Connect(function(_, state)
                    if state == Enum.HumanoidStateType.Running and SpeedEnabled then
                        local root = hum.Parent:FindFirstChild("HumanoidRootPart")
                        if root then
                            local dir = hum.MoveDirection
                            if dir.Magnitude > 0 then
                                root.Velocity = Vector3.new(dir.X * 50, root.Velocity.Y, dir.Z * 50)
                            end
                        end
                    end
                end))
            else
                hum.WalkSpeed = 16
                Cleanup("Speed")
            end
        end
    end
})

-- Wall Hack
local WallHackEnabled = false
PlayerTab:CreateToggle({
    Name = "Wall Hack",
    CurrentValue = false,
    Callback = function(Value)
        WallHackEnabled = Value
        if WallHackEnabled then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.CanCollide then
                    obj.CanCollide = false
                end
            end
            Cleanup("WallHack")
            table.insert(ActiveConnections, game:GetService("RunService").Stepped:Connect(function()
                if WallHackEnabled then
                    local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
                    end
                end
            end))
        else
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    obj.CanCollide = true
                end
            end
            Cleanup("WallHack")
        end
    end
})

-- Fly
local FlyEnabled = false
PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(Value)
        FlyEnabled = Value
        local plr = game.Players.LocalPlayer
        local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if root then
            if FlyEnabled then
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.Parent = root
                Cleanup("Fly")
                table.insert(ActiveConnections, game:GetService("RunService").RenderStepped:Connect(function()
                    if FlyEnabled then
                        local UIS = game:GetService("UserInputService")
                        local cam = workspace.CurrentCamera
                        local move = Vector3.new(
                            (UIS:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UIS:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
                            (UIS:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) - (UIS:IsKeyDown(Enum.KeyCode.LeftShift) and 1 or 0),
                            (UIS:IsKeyDown(Enum.KeyCode.W) and 1 or 0) - (UIS:IsKeyDown(Enum.KeyCode.S) and 1 or 0)
                        )
                        bv.Velocity = cam.CFrame:VectorToWorldSpace(move * 50)
                    end
                end))
            else
                for _, v in pairs(root:GetChildren()) do
                    if v:IsA("BodyVelocity") then v:Destroy() end
                end
                Cleanup("Fly")
            end
        end
    end
})

-- ESP Tab
local ESPTab = Window:CreateTab("ESP", 4483362458)

-- Player ESP
ESPTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= game.Players.LocalPlayer and p.Character then
                    local hl = Instance.new("Highlight")
                    hl.FillColor = Color3.fromRGB(128, 0, 128)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 0)
                    hl.Parent = p.Character
                end
            end
            game.Players.PlayerAdded:Connect(function(p)
                p.CharacterAdded:Connect(function(c)
                    if Value then
                        local hl = Instance.new("Highlight")
                        hl.FillColor = Color3.fromRGB(128, 0, 128)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 0)
                        hl.Parent = c
                    end
                end)
            end)
        else
            for _, p in pairs(game.Players:GetPlayers()) do
                if p.Character then
                    for _, v in pairs(p.Character:GetChildren()) do
                        if v:IsA("Highlight") then v:Destroy() end
                    end
                end
            end
        end
    end
})

-- Brainrot ESP
ESPTab:CreateToggle({
    Name = "Brainrot ESP",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            for _, item in pairs(workspace:GetDescendants()) do
                if item.Name:match("Brainrot") or item.Name:match("Tralelero") or item.Name:match("Saturnita") or item.Name:match("Balerina") then
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

-- Actions Tab
local ActionsTab = Window:CreateTab("Actions", 4483362458)

-- Steal All Brainrots
ActionsTab:CreateButton({
    Name = "Steal All Brainrots",
    Callback = function()
        local valuable = {"Tralelero", "Saturnita", "Balerina Capucina", "Coco Fanto Ele Fanto", "orcalero Orcala", "odin din dun", "Dragons"}
        for _, item in pairs(workspace:GetDescendants()) do
            for _, name in pairs(valuable) do
                if item.Name == name then
                    item.Parent = game.Players.LocalPlayer.Character
                end
            end
        end
    end
})

-- Go Base
ActionsTab:CreateButton({
    Name = "Go Base",
    Callback = function()
        local base = workspace:FindFirstChild("Base")
        local plr = game.Players.LocalPlayer
        if base and plr.Character then
            plr.Character.HumanoidRootPart.CFrame = base.CFrame
        end
    end
})

-- No Falling
local NoFall = false
ActionsTab:CreateToggle({
    Name = "No Falling",
    CurrentValue = false,
    Callback = function(Value)
        NoFall = Value
        if NoFall then
            local hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then
                Cleanup("NoFall")
                table.insert(ActiveConnections, hum.StateChanged:Connect(function(_, state)
                    if state == Enum.HumanoidStateType.FallingDown and NoFall then
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end))
            end
        else
            Cleanup("NoFall")
        end
    end
})

-- Notificación final
Rayfield:Notify({
    Title = "Brainrot Hub",
    Content = "Cargado con éxito. Presiona 'K' para ocultar/mostrar.",
    Duration = 5
})
