-- PAPA SCRIPT MM2 v3
local P = game:GetService("Players")
local R = game:GetService("RunService")
local U = game:GetService("UserInputService")
local L = game:GetService("Lighting")
local LP = P.LocalPlayer
local C = workspace.CurrentCamera

local cfg = {
    esp = true, aim = true, aimFOV = 360, smooth = 1,
    autoFarm = false, bunny = false, shaders = false,
    killAura = false
}

-- ===== DRAG =====
local dragging, dragInput, dragStart, startPos
local function drag(frame)
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    U.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ===== UI =====
local g = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
g.ResetOnSpawn = false
g.IgnoreGuiInset = true
g.DisplayOrder = 999

local icon = Instance.new("ImageButton", g)
icon.Size = UDim2.new(0, 65, 0, 65)
icon.Position = UDim2.new(0, 20, 0, 100)
icon.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
icon.Image = "rbxassetid://7734068321" -- ЗАМЕНИ НА ID СВОЕГО КОТА
icon.ScaleType = Enum.ScaleType.Crop
icon.Parent = g
Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)
local uis = Instance.new("UIStroke", icon); uis.Color = Color3.fromRGB(255, 255, 255); uis.Thickness = 1.5
drag(icon)

local menu = Instance.new("Frame", g)
menu.Size = UDim2.new(0, 300, 0, 420)
menu.Position = UDim2.new(0.5, -150, 0.5, -210)
menu.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
menu.BorderSizePixel = 0
menu.Visible = false
menu.Parent = g
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 12)
local mstroke = Instance.new("UIStroke", menu); mstroke.Color = Color3.fromRGB(60, 60, 80); mstroke.Thickness = 1.5
drag(menu)

local topBar = Instance.new("Frame", menu)
topBar.Size = UDim2.new(1, 0, 0, 50)
topBar.BackgroundTransparency = 1
topBar.Parent = menu

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "PAPA SCRIPT MM2"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = topBar
local tGrad = Instance.new("UIGradient", title)
tGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)), ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 255))})

local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 2
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = menu
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 8)

local function addToggle(text, key, cb)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = cfg[key] and Color3.fromRGB(40, 40, 50) or Color3.fromRGB(25, 25, 30)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = "  " .. text .. ": " .. (cfg[key] and "ON" or "OFF")
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        cfg[key] = not cfg[key]
        btn.Text = "  " .. text .. ": " .. (cfg[key] and "ON" or "OFF")
        btn.BackgroundColor3 = cfg[key] and Color3.fromRGB(40, 40, 50) or Color3.fromRGB(25, 25, 30)
        if cb then cb(cfg[key]) end
    end)
end

local function addBtn(text, cb)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = text
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(cb)
end

icon.MouseButton1Click:Connect(function() menu.Visible = not menu.Visible end)

-- ===== LOGIC =====
local function isShiftLock()
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    return hum and math.abs(hum.CameraOffset.Z) > 0.01
end

local function getRole(p)
    local ch = p.Character
    if not ch then return "Innocent" end
    local bp = p:FindFirstChild("Backpack")
    if (ch:FindFirstChild("Knife") or (bp and bp:FindFirstChild("Knife"))) then return "Murderer" end
    if (ch:FindFirstChild("Gun") or (bp and bp:FindFirstChild("Gun"))) then return "Sheriff" end
    return "Innocent"
end

local function findTarget(filterMurderer)
    local closest, dist = nil, cfg.aimFOV
    local center = Vector2.new(C.ViewportSize.X/2, C.ViewportSize.Y/2)
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= LP then
            local role = getRole(p)
            if not filterMurderer or role == "Murderer" then
                local head = p.Character and p.Character:FindFirstChild("Head")
                if head then
                    local pos, vis = C:WorldToViewportPoint(head.Position)
                    if vis then
                        local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if d < dist then dist = d; closest = head end
                    end
                end
            end
        end
    end
    return closest
end

-- SKIN CHANGER
local function applySkin(tool, isKnife)
    if not tool or not tool:FindFirstChild("Handle") then return end
    local handle = tool.Handle
    local mesh = handle:FindFirstChildOfClass("SpecialMesh") or Instance.new("SpecialMesh", handle)
    mesh.MeshType = Enum.MeshType.FileMesh
    
    if isKnife then
        mesh.MeshId = "rbxassetid://6094373434" -- Butterfly Mesh
        mesh.TextureId = "rbxassetid://6094373438"
        mesh.Scale = Vector3.new(1, 1, 1.2)
    else
        mesh.MeshId = "rbxassetid://132576701"
        mesh.TextureId = "rbxassetid://132576704"
        mesh.Scale = Vector3.new(1.2, 1.2, 1.2)
    end
end

local function hookTools(char)
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") and t.Name == "Knife" then applySkin(t, true) end
        if t:IsA("Tool") and t.Name == "Gun" then applySkin(t, false) end
    end
    char.ChildAdded:Connect(function(t)
        task.wait(0.5)
        if t:IsA("Tool") and t.Name == "Knife" then applySkin(t, true) end
        if t:IsA("Tool") and t.Name == "Gun" then applySkin(t, false) end
    end)
end
LP.CharacterAdded:Connect(hookTools)
if LP.Character then hookTools(LP.Character) end

-- MENU ITEMS
addToggle("Role ESP (All)", "esp")
addToggle("Aimbot (ShiftLock)", "aim")
addToggle("Auto Farm", "autoFarm")
addToggle("BunnyHop (Speed)", "bunny")
addToggle("Visual Shaders", "shaders", function(on)
    if on then
        L.Brightness = 2
        L.EnvironmentDiffuseScale = 0.5
        L.EnvironmentSpecularScale = 0.5
        L.GlobalShadows = true
        L.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
    else
        L.Brightness = 1
        L.EnvironmentDiffuseScale = 0
        L.EnvironmentSpecularScale = 0
        L.GlobalShadows = false
        L.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
end)
addToggle("Kill Aura (Murderer)", "killAura")

addBtn("Kill All (Murderer Only)", function()
    if getRole(LP) ~= "Murderer" then return end
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= LP and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp and myHRP then
                -- Телепорт к цели и удар
                myHRP.CFrame = hrp.CFrame * CFrame.new(0, 0, 2)
                task.wait(0.05)
                local knife = LP.Character:FindFirstChild("Knife")
                if knife then knife:Activate() end
            end
        end
    end
end)

-- ===== MAIN LOOP =====
R.RenderStepped:Connect(function()
    -- ESP ON ALL
    if cfg.esp then
        for _, p in ipairs(P:GetPlayers()) do
            if p ~= LP and p.Character then
                local role = getRole(p)
                local esp = p.Character:FindFirstChild("PAPA_ESP")
                if not esp then
                    local h = Instance.new("Highlight", p.Character)
                    h.Name = "PAPA_ESP"
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    h.FillTransparency = 0.5
                    if role == "Murderer" then
                        h.FillColor = Color3.fromRGB(255, 0, 0)
                    elseif role == "Sheriff" then
                        h.FillColor = Color3.fromRGB(0, 100, 255)
                    else
                        h.FillColor = Color3.fromRGB(0, 255, 0)
                    end
                end
            end
        end
    end

    -- AIM (ShiftLock only)
    if cfg.aim and isShiftLock() then
        local target = findTarget(true)
        if target then
            C.CFrame = C.CFrame:Lerp(CFrame.lookAt(C.CFrame.Position, target.Position), cfg.smooth)
            if cfg.killAura and getRole(LP) == "Murderer" then
                local knife = LP.Character and LP.Character:FindFirstChild("Knife")
                if knife then knife:Activate() end
            end
        end
    end

    -- AUTO FARM (Coins -> Murderer Fling)
    if cfg.autoFarm and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local coinFound = false
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == "Coin" and obj:IsA("BasePart") then
                coinFound = true
                LP.Character.HumanoidRootPart.CFrame = obj.CFrame
            end
        end
        -- Если монет нет, флингуем мардера
        if not coinFound and getRole(LP) ~= "Murderer" then
            local target = findTarget(true)
            if target and LP.Character.HumanoidRootPart then
                local bv = Instance.new("BodyVelocity", LP.Character.HumanoidRootPart)
                bv.Velocity = (target.Position - LP.Character.HumanoidRootPart.Position).Unit * 150
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                game:GetService("Debris"):AddItem(bv, 0.2)
            end
        end
    end

    -- BUNNYHOP (Speed)
    if cfg.bunny and LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum.FloorMaterial ~= Enum.Material.Air then
            hum.Jump = true
            hum.WalkSpeed = 50 -- Ускорение
        end
    else
        if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
            LP.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

-- REAL FLING
R.Heartbeat:Connect(function()
    if cfg.autoFarm and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        for _, p in ipairs(P:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist < 5 and getRole(p) == "Murderer" then
                    p.Character.HumanoidRootPart.Velocity = Vector3.new(math.random(-1000,1000), 5000, math.random(-1000,1000))
                end
            end
        end
    end
end)

print("PAPA SCRIPT MM2 v3 loaded")
