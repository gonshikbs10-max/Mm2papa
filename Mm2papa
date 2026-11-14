-- PAPA SCRIPT MM2 v4
local P = game:GetService("Players")
local R = game:GetService("RunService")
local U = game:GetService("UserInputService")
local L = game:GetService("Lighting")
local LP = P.LocalPlayer
local C = workspace.CurrentCamera

local cfg = {
    esp = true, aim = true, aimFOV = 360, smooth = 1,
    autoFarm = false, bunny = false, shaders = false, killAura = false,
    antiFling = true, flingAll = false, spin = false, fpsBoost = false
}

-- ===== DRAG =====
local dragging, dragInput, dragStart, startPos
local function drag(frame, target)
    target = target or frame
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = target.Position
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
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ===== UI =====
local g = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
g.ResetOnSpawn = false
g.IgnoreGuiInset = true
g.DisplayOrder = 999

-- Minimized Icon
local icon = Instance.new("ImageButton", g)
icon.Size = UDim2.new(0, 60, 0, 60)
icon.Position = UDim2.new(0, 20, 0, 100)
icon.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
icon.Image = "rbxassetid://118814584997415" 
icon.ScaleType = Enum.ScaleType.Crop
icon.Visible = true
icon.Parent = g
Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)
local uis = Instance.new("UIStroke", icon); uis.Color = Color3.fromRGB(100, 100, 120); uis.Thickness = 1.5

-- Main Menu
local menu = Instance.new("Frame", g)
menu.Size = UDim2.new(0, 280, 0, 380)
menu.Position = UDim2.new(0.5, -140, 0.5, -190)
menu.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
menu.BorderSizePixel = 0
menu.Visible = false
menu.Parent = g
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 10)
local mstroke = Instance.new("UIStroke", menu); mstroke.Color = Color3.fromRGB(60, 60, 80); mstroke.Thickness = 1.5
drag(menu)

-- Top Bar
local topBar = Instance.new("Frame", menu)
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
topBar.BorderSizePixel = 0
topBar.Parent = menu
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "PAPA SCRIPT MM2"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 2
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = menu
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 6)

-- Toggles
local function addToggle(text, key, cb)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = cfg[key] and Color3.fromRGB(40, 45, 55) or Color3.fromRGB(25, 25, 30)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Text = "  " .. text .. ": " .. (cfg[key] and "ON" or "OFF")
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        cfg[key] = not cfg[key]
        btn.Text = "  " .. text .. ": " .. (cfg[key] and "ON" or "OFF")
        btn.BackgroundColor3 = cfg[key] and Color3.fromRGB(40, 45, 55) or Color3.fromRGB(25, 25, 30)
        if cb then cb(cfg[key]) end
    end)
end

local function addBtn(text, cb)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(50, 55, 70)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Text = text
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(cb)
end

local function addBox(placeholder, cb)
    local b = Instance.new("TextBox", scroll)
    b.Size = UDim2.new(1, 0, 0, 34)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    b.TextColor3 = Color3.new(1,1,1)
    b.PlaceholderText = placeholder
    b.Font = Enum.Font.Gotham
    b.TextSize = 13
    b.Text = ""
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.FocusLost:Connect(function(enter) if enter and b.Text ~= "" then cb(b.Text) end end)
end

icon.MouseButton1Click:Connect(function()
    icon.Visible = false
    menu.Visible = true
end)
closeBtn.MouseButton1Click:Connect(function()
    menu.Visible = false
    icon.Visible = true
end)

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

-- ANIMATION HUB
local animTrack
local function playAnim(id)
    local ch = LP.Character
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    local animator = hum and hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    if animTrack then animTrack:Stop(); animTrack:Destroy() end
    local a = Instance.new("Animation")
    a.AnimationId = "rbxassetid://" .. tostring(id)
    local ok, track = pcall(function() return animator:LoadAnimation(a) end)
    if ok and track then animTrack = track; track:Play() end
end

-- MENU ITEMS
addToggle("Role ESP", "esp")
addToggle("Aimbot (ShiftLock)", "aim")
addToggle("Kill Aura", "killAura")
addToggle("Auto Farm", "autoFarm")
addToggle("BunnyHop", "bunny")
addToggle("Shaders", "shaders", function(on)
    if on then
        L.Brightness = 2; L.EnvironmentDiffuseScale = 0.5; L.EnvironmentSpecularScale = 0.5; L.GlobalShadows = true; L.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
    else
        L.Brightness = 1; L.EnvironmentDiffuseScale = 0; L.EnvironmentSpecularScale = 0; L.GlobalShadows = false; L.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
end)
addToggle("Anti-Fling", "antiFling")
addToggle("Spin Fast", "spin")
addToggle("FPS Boost", "fpsBoost", function(on)
    if on then
        L.GlobalShadows = false
        L.FogEnd = 100
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end
        end
    end
end)
addToggle("Fling All (Auto)", "flingAll")

addBox("Animation ID (e.g. 507771019)", function(id) playAnim(id) end)
addBtn("Stop Animation", function() if animTrack then animTrack:Stop() end end)

addBtn("Kill All (Murderer)", function()
    if getRole(LP) ~= "Murderer" then return end
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= LP and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp and myHRP then
                myHRP.CFrame = hrp.CFrame * CFrame.new(0, 0, 2)
                task.wait(0.05)
                local knife = LP.Character:FindFirstChild("Knife")
                if knife then knife:Activate() end
            end
        end
    end
end)

-- SKINS
local function applySkin(tool, isKnife)
    if not tool or not tool:FindFirstChild("Handle") then return end
    local mesh = tool.Handle:FindFirstChildOfClass("SpecialMesh") or Instance.new("SpecialMesh", tool.Handle)
    mesh.MeshType = Enum.MeshType.FileMesh
    if isKnife then
        mesh.MeshId = "rbxassetid://6094373434"; mesh.TextureId = "rbxassetid://6094373438"; mesh.Scale = Vector3.new(1, 1, 1.2)
    else
        mesh.MeshId = "rbxassetid://132576701"; mesh.TextureId = "rbxassetid://132576704"; mesh.Scale = Vector3.new(1.2, 1.2, 1.2)
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

-- ===== MAIN LOOP =====
R.RenderStepped:Connect(function()
    -- ESP
    if cfg.esp then
        for _, p in ipairs(P:GetPlayers()) do
            if p ~= LP and p.Character then
                local role = getRole(p)
                local esp = p.Character:FindFirstChild("PAPA_ESP")
                if not esp then
                    local h = Instance.new("Highlight", p.Character)
                    h.Name = "PAPA_ESP"; h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; h.FillTransparency = 0.5
                    if role == "Murderer" then h.FillColor = Color3.fromRGB(255, 0, 0)
                    elseif role == "Sheriff" then h.FillColor = Color3.fromRGB(0, 100, 255)
                    else h.FillColor = Color3.fromRGB(0, 255, 0) end
                end
            end
        end
    end

    -- AIM
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

    -- ANTI-FLING & SPIN
    local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if myHRP then
        if cfg.antiFling then
            myHRP.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5, 1, 1)
            local bv = myHRP:FindFirstChild("AntiFlingVel")
            if not bv then
                bv = Instance.new("BodyVelocity", myHRP)
                bv.Name = "AntiFlingVel"
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Velocity = Vector3.new(0, 0, 0)
            end
            bv.Velocity = Vector3.new(myHRP.Velocity.X, math.clamp(myHRP.Velocity.Y, -50, 50), myHRP.Velocity.Z)
        else
            local bv = myHRP:FindFirstChild("AntiFlingVel")
            if bv then bv:Destroy() end
        end

        if cfg.spin then
            myHRP.CFrame = myHRP.CFrame * CFrame.Angles(0, math.rad(45), 0)
        end
    end

    -- AUTO FARM
    if cfg.autoFarm and myHRP then
        local coinFound = false
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == "Coin" and obj:IsA("BasePart") then
                coinFound = true
                myHRP.CFrame = obj.CFrame
            end
        end
        if not coinFound and getRole(LP) ~= "Murderer" then
            local target = findTarget(true)
            if target then myHRP.Velocity = (target.Position - myHRP.Position).Unit * 150 end
        end
    end

    -- BUNNYHOP
    if cfg.bunny and LP.Character then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.FloorMaterial ~= Enum.Material.Air then
            hum.Jump = true
            hum.WalkSpeed = 50
        end
    elseif LP.Character then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed > 16 then hum.WalkSpeed = 16 end
    end
end)

-- FLING ALL
R.Heartbeat:Connect(function()
    if cfg.flingAll then
        for _, p in ipairs(P:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local targetHRP = p.Character.HumanoidRootPart
                local bv = targetHRP:FindFirstChild("FlingVel")
                if not bv then
                    bv = Instance.new("BodyVelocity", targetHRP)
                    bv.Name = "FlingVel"
                    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                end
                bv.Velocity = Vector3.new(math.random(-500,500), 2000, math.random(-500,500))
            end
        end
    end
end)

print("PAPA SCRIPT MM2 v4 loaded")
