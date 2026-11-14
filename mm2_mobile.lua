-- PAPA SCRIPT MM2 v7 [MEGA]
local P = game:GetService("Players")
local R = game:GetService("RunService")
local U = game:GetService("UserInputService")
local L = game:GetService("Lighting")
local T = game:GetService("TweenService")
local VIM = game:GetService("VirtualInputManager")
local LP = P.LocalPlayer
local C = workspace.CurrentCamera

local cfg = {
    esp = true, aim = true, aimFOV = 360, smooth = 1, wallCheck = false,
    autoFarm = false, bunny = false, shaders = false, killAura = false,
    antiFling = false, autoGrab = false, spin = false, fpsBoost = false,
    autoShoot = false, autoKill = false, tpMurder = false, infiniteJump = false
}

local connections = {}
local function clearConnection(name)
    if connections[name] then connections[name]:Disconnect() connections[name] = nil end
end

-- ===== UI =====
local g = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
g.ResetOnSpawn = false; g.IgnoreGuiInset = true; g.DisplayOrder = 999
g.Name = "PapaScriptUI"

local icon = Instance.new("ImageButton", g)
icon.Size = UDim2.new(0, 55, 0, 55); icon.Position = UDim2.new(0, 15, 0, 100)
icon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
icon.Image = "rbxassetid://118814584997415"; icon.ScaleType = Enum.ScaleType.Crop
icon.Parent = g; Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)
local uis = Instance.new("UIStroke", icon); uis.Color = Color3.fromRGB(255, 255, 255); uis.Thickness = 1

local menu = Instance.new("Frame", g)
menu.Size = UDim2.new(0, 260, 0, 400); menu.Position = UDim2.new(0.5, -130, 0.5, -200)
menu.BackgroundColor3 = Color3.fromRGB(15, 15, 18); menu.Visible = false
menu.Parent = g; Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 10)
local ms = Instance.new("UIStroke", menu); ms.Color = Color3.fromRGB(80, 80, 100); ms.Thickness = 1.5

local topBar = Instance.new("Frame", menu)
topBar.Size = UDim2.new(1, 0, 0, 40); topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
topBar.Parent = menu; Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, -40, 1, 0); title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1; title.Text = "PAPA SCRIPT v7 MEGA"
title.TextColor3 = Color3.fromRGB(255, 255, 255); title.Font = Enum.Font.GothamBold
title.TextSize = 15; title.TextXAlignment = Enum.TextXAlignment.Left; title.Parent = topBar

local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 25, 0, 25); closeBtn.Position = UDim2.new(1, -30, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1); closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar; Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -10, 1, -45); scroll.Position = UDim2.new(0, 5, 0, 40)
scroll.BackgroundTransparency = 1; scroll.ScrollBarThickness = 2
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = menu; Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 4)

local function addToggle(text, key, cb)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, 0, 0, 30); btn.BackgroundColor3 = cfg[key] and Color3.fromRGB(35, 45, 55) or Color3.fromRGB(25, 25, 30)
    btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.Gotham; btn.TextSize = 12
    btn.Text = "  " .. text .. ": " .. (cfg[key] and "ON" or "OFF"); btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(function()
        cfg[key] = not cfg[key]; btn.Text = "  " .. text .. ": " .. (cfg[key] and "ON" or "OFF")
        btn.BackgroundColor3 = cfg[key] and Color3.fromRGB(35, 45, 55) or Color3.fromRGB(25, 25, 30)
        if cb then cb(cfg[key]) end
    end)
end

local function addBtn(text, cb)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, 0, 0, 30); btn.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
    btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.Gotham; btn.TextSize = 12
    btn.Text = text; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(cb)
end

local function addBox(placeholder, cb)
    local b = Instance.new("TextBox", scroll)
    b.Size = UDim2.new(1, 0, 0, 30); b.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    b.TextColor3 = Color3.new(1,1,1); b.PlaceholderText = placeholder
    b.Font = Enum.Font.Gotham; b.TextSize = 12; b.Text = ""
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    b.FocusLost:Connect(function(enter) if enter and b.Text ~= "" then cb(b.Text) end end)
end

icon.MouseButton1Click:Connect(function() icon.Visible = false; menu.Visible = true end)
closeBtn.MouseButton1Click:Connect(function() menu.Visible = false; icon.Visible = true end)

-- ===== DRAG =====
local dragging, dragInput, dragStart, startPos
local function makeDrag(frame)
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    U.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
makeDrag(icon); makeDrag(menu); makeDrag(topBar)

-- ===== LOGIC =====
local function getRole(p)
    if p == LP then return "You" end
    local char = p.Character; local bp = p:FindFirstChild("Backpack")
    if (char and char:FindFirstChild("Knife")) or (bp and bp:FindFirstChild("Knife")) then return "Murderer" end
    if (char and char:FindFirstChild("Gun")) or (bp and bp:FindFirstChild("Gun")) then return "Sheriff" end
    return "Innocent"
end

local function findTarget(filterRole)
    local closest, dist = nil, cfg.aimFOV
    local center = Vector2.new(C.ViewportSize.X/2, C.ViewportSize.Y/2)
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= LP and getRole(p) == filterRole then
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
    return closest
end

-- SKINS
local function applySkin(tool, isKnife)
    if not tool or not tool:FindFirstChild("Handle") then return end
    local mesh = tool.Handle:FindFirstChildOfClass("SpecialMesh") or Instance.new("SpecialMesh", tool.Handle)
    mesh.MeshType = Enum.MeshType.FileMesh
    if isKnife then mesh.MeshId = "rbxassetid://6094373434"; mesh.TextureId = "rbxassetid://6094373438" 
    else mesh.MeshId = "rbxassetid://132576701"; mesh.TextureId = "rbxassetid://132576704" end
end
LP.CharacterAdded:Connect(function(c) for _, t in ipairs(c:GetChildren()) do if t.Name == "Knife" then applySkin(t, true) elseif t.Name == "Gun" then applySkin(t, false) end end end)
if LP.Character then for _, t in ipairs(LP.Character:GetChildren()) do if t.Name == "Knife" then applySkin(t, true) elseif t.Name == "Gun" then applySkin(t, false) end end end

-- MENU ITEMS
addToggle("Role ESP", "esp")
addToggle("Aimbot (Murderer)", "aim")
addToggle("Wall Check (Aim)", "wallCheck")
addToggle("Kill Aura", "killAura")
addToggle("Auto Shoot", "autoShoot")
addToggle("Auto Farm", "autoFarm")
addToggle("BunnyHop", "bunny")
addToggle("Infinite Jump", "infiniteJump")
addToggle("Spin Fast", "spin")
addToggle("Anti-Fling (NoClip)", "antiFling")
addToggle("FPS Boost", "fpsBoost")
addToggle("Shaders", "shaders")

addBox("Anim ID (e.g. 507771019)", function(id)
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    local anim = hum and hum:FindFirstChildOfClass("Animator")
    if anim then local a = Instance.new("Animation"); a.AnimationId = "rbxassetid://"..id; anim:LoadAnimation(a):Play() end
end)

addBtn("Fling Murderer", function()
    for _, p in ipairs(P:GetPlayers()) do if getRole(p) == "Murderer" then
        local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.AssemblyLinearVelocity = Vector3.new(math.random(-500,500), 5000, math.random(-500,500)) end
    end end
end)

addBtn("Fling Sheriff", function()
    for _, p in ipairs(P:GetPlayers()) do if getRole(p) == "Sheriff" then
        local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.AssemblyLinearVelocity = Vector3.new(math.random(-500,500), 5000, math.random(-500,500)) end
    end end
end)

addBtn("TP to Murderer", function()
    local target = findTarget("Murderer")
    if target and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        LP.Character.HumanoidRootPart.CFrame = target.CFrame * CFrame.new(0,0,3)
    end
end)

addBtn("Auto Grab Gun", function()
    for _, o in ipairs(workspace:GetDescendants()) do
        if o.Name == "Gun" and o:IsA("Tool") and o.Parent == workspace then
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character.HumanoidRootPart.CFrame = o.Handle.CFrame
            end
        end
    end
end)

addBtn("Kill All (Murderer)", function()
    if getRole(LP) ~= "Murderer" then return end
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= LP and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp and myHRP then myHRP.CFrame = hrp.CFrame * CFrame.new(0, 0, 2); task.wait(0.05); local k = LP.Character:FindFirstChild("Knife"); if k then k:Activate() end end
        end
    end
end)

-- ===== MAIN LOOPS =====
R.RenderStepped:Connect(function()
    -- ESP
    if cfg.esp then
        for _, p in ipairs(P:GetPlayers()) do
            if p ~= LP and p.Character then
                local role = getRole(p)
                local esp = p.Character:FindFirstChild("PAPA_ESP")
                if not esp then esp = Instance.new("Highlight", p.Character); esp.Name = "PAPA_ESP"; esp.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop end
                if role == "Murderer" then esp.FillColor = Color3.fromRGB(255, 0, 0)
                elseif role == "Sheriff" then esp.FillColor = Color3.fromRGB(0, 100, 255)
                else esp.FillColor = Color3.fromRGB(0, 255, 0) end
            end
        end
    end

    -- AIM
    if cfg.aim then
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum and math.abs(hum.CameraOffset.Z) > 0.01 then
            local target = findTarget("Murderer")
            if target then
                C.CFrame = C.CFrame:Lerp(CFrame.lookAt(C.CFrame.Position, target.Position), cfg.smooth)
                if cfg.killAura and getRole(LP) == "Murderer" then local k = LP.Character:FindFirstChild("Knife"); if k then k:Activate() end end
            end
        end
    end

    -- SPIN
    local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if cfg.spin and myHRP then myHRP.CFrame = myHRP.CFrame * CFrame.Angles(0, math.rad(45), 0) end

    -- ANTI FLING
    if cfg.antiFling and LP.Character then
        for _, part in ipairs(LP.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
    end

    -- AUTO FARM
    if cfg.autoFarm and myHRP then
        local coinFound = false
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == "Coin" and obj:IsA("BasePart") then coinFound = true; myHRP.CFrame = obj.CFrame end
        end
    end

    -- BUNNY HOP
    if cfg.bunny and LP.Character then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.FloorMaterial ~= Enum.Material.Air then hum.Jump = true end
    end
end)

R.Stepped:Connect(function()
    if cfg.infiniteJump and LP.Character then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

print("PAPA SCRIPT MM2 v7 MEGA loaded")
