-- PAPA SCRIPT MM2 v5
local P = game:GetService("Players")
local R = game:GetService("RunService")
local U = game:GetService("UserInputService")
local L = game:GetService("Lighting")
local LP = P.LocalPlayer
local C = workspace.CurrentCamera

local cfg = {
    esp = true, aim = true, aimFOV = 250, smooth = 1,
    autoFarm = false, bunny = false, shaders = false, killAura = false,
    antiFling = false, autoGrab = false
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
icon.Size = UDim2.new(0, 50, 0, 50)
icon.Position = UDim2.new(0, 15, 0, 80)
icon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
icon.Image = "rbxassetid://118814584997415" 
icon.ScaleType = Enum.ScaleType.Crop
icon.Parent = g
Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)
local uis = Instance.new("UIStroke", icon); uis.Color = Color3.fromRGB(100, 100, 120); uis.Thickness = 1
drag(icon)

local menu = Instance.new("Frame", g)
menu.Size = UDim2.new(0, 240, 0, 320)
menu.Position = UDim2.new(0.5, -120, 0.5, -160)
menu.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
menu.BorderSizePixel = 0
menu.Visible = false
menu.Parent = g
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 10)
local mstroke = Instance.new("UIStroke", menu); mstroke.Color = Color3.fromRGB(70, 70, 90); mstroke.Thickness = 1
drag(menu)

local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "PAPA SCRIPT v5"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.Parent = menu

local closeBtn = Instance.new("TextButton", menu)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = menu
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -10, 1, -40)
scroll.Position = UDim2.new(0, 5, 0, 35)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 2
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = menu
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 4)

local function addToggle(text, key, cb)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.BackgroundColor3 = cfg[key] and Color3.fromRGB(35, 45, 55) or Color3.fromRGB(25, 25, 30)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Text = "  " .. text .. ": " .. (cfg[key] and "ON" or "OFF")
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(function()
        cfg[key] = not cfg[key]
        btn.Text = "  " .. text .. ": " .. (cfg[key] and "ON" or "OFF")
        btn.BackgroundColor3 = cfg[key] and Color3.fromRGB(35, 45, 55) or Color3.fromRGB(25, 25, 30)
        if cb then cb(cfg[key]) end
    end)
end

local function addBtn(text, cb)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.Text = text
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(cb)
end

local function addBox(placeholder, cb)
    local b = Instance.new("TextBox", scroll)
    b.Size = UDim2.new(1, 0, 0, 28)
    b.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    b.TextColor3 = Color3.new(1,1,1)
    b.PlaceholderText = placeholder
    b.Font = Enum.Font.Gotham
    b.TextSize = 12
    b.Text = ""
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    b.FocusLost:Connect(function(enter) if enter and b.Text ~= "" then cb(b.Text) end end)
end

icon.MouseButton1Click:Connect(function() icon.Visible = false; menu.Visible = true end)
closeBtn.MouseButton1Click:Connect(function() menu.Visible = false; icon.Visible = true end)

-- ===== LOGIC =====
local function getRole(p)
    local ch = p.Character
    if not ch then return "Innocent" end
    local bp = p:FindFirstChild("Backpack")
    if (ch:FindFirstChild("Knife") or (bp and bp:FindFirstChild("Knife"))) then return "Murderer" end
    if (ch:FindFirstChild("Gun") or (bp and bp:FindFirstChild("Gun"))) then return "Sheriff" end
    return "Innocent"
end

local function findTarget(filterRole)
    local closest, dist = nil, cfg.aimFOV
    local center = Vector2.new(C.ViewportSize.X/2, C.ViewportSize.Y/2)
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= LP then
            local role = getRole(p)
            if role == filterRole then
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

local function doFling(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local hrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(math.random(-1000,1000), 5000, math.random(-1000,1000))
        game:GetService("Debris"):AddItem(bv, 0.5)
    end
end

addToggle("Role ESP (All)", "esp")
addToggle("Aimbot (Murderer)", "aim")
addToggle("Kill Aura", "killAura")
addToggle("Auto Farm", "autoFarm")
addToggle("BunnyHop (Hold Jump)", "bunny")
addToggle("Auto Grab Gun", "autoGrab")
addToggle("Shaders", "shaders", function(on)
    if on then L.Brightness = 2; L.EnvironmentDiffuseScale = 0.5; L.GlobalShadows = true else L.Brightness = 1; L.EnvironmentDiffuseScale = 0; L.GlobalShadows = false end
end)
addToggle("Anti-Fling (No Clip)", "antiFling")
addToggle("FPS Boost", "fpsBoost", function(on)
    if on then L.GlobalShadows = false; L.FogEnd = 100 for _, v in ipairs(workspace:GetDescendants()) do if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end end end
end)

addBox("Anim ID (e.g. 507771019)", function(id)
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    local anim = hum and hum:FindFirstChildOfClass("Animator")
    if anim then local a = Instance.new("Animation"); a.AnimationId = "rbxassetid://"..id; anim:LoadAnimation(a):Play() end
end)

addBtn("Fling Murderer", function()
    for _, p in ipairs(P:GetPlayers()) do if p ~= LP and getRole(p) == "Murderer" then doFling(p) end end
end)

addBtn("Fling Sheriff", function()
    for _, p in ipairs(P:GetPlayers()) do if p ~= LP and getRole(p) == "Sheriff" then doFling(p) end end
end)

addBtn("Fling All", function()
    for _, p in ipairs(P:GetPlayers()) do if p ~= LP then doFling(p) end end
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

-- SKINS
local function applySkin(tool, isKnife)
    if not tool or not tool:FindFirstChild("Handle") then return end
    local mesh = tool.Handle:FindFirstChildOfClass("SpecialMesh") or Instance.new("SpecialMesh", tool.Handle)
    mesh.MeshType = Enum.MeshType.FileMesh
    if isKnife then mesh.MeshId = "rbxassetid://6094373434"; mesh.TextureId = "rbxassetid://6094373438" 
    else mesh.MeshId = "rbxassetid://132576701"; mesh.TextureId = "rbxassetid://132576704" end
end
LP.CharacterAdded:Connect(function(c) 
    for _, t in ipairs(c:GetChildren()) do 
        if t.Name == "Knife" then applySkin(t, true) elseif t.Name == "Gun" then applySkin(t, false) end 
    end 
end)

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
                    h.Name = "PAPA_ESP"; h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; h.FillTransparency = 0.4
                    if role == "Murderer" then h.FillColor = Color3.fromRGB(255,0,0) elseif role == "Sheriff" then h.FillColor = Color3.fromRGB(0,100,255) else h.FillColor = Color3.fromRGB(0,255,0) end
                end
            end
        end
    end

    -- AIM
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    local shift = hum and math.abs(hum.CameraOffset.Z) > 0.01
    if cfg.aim and shift then
        local target = findTarget("Murderer")
        if target then
            C.CFrame = C.CFrame:Lerp(CFrame.lookAt(C.CFrame.Position, target.Position), cfg.smooth)
            if cfg.killAura and getRole(LP) == "Murderer" then local k = LP.Character:FindFirstChild("Knife"); if k then k:Activate() end end
        end
    end

    -- AUTO GRAB GUN
    if cfg.autoGrab and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        for _, o in ipairs(workspace:GetDescendants()) do
            if o.Name == "Gun" and o:IsA("Tool") and o.Parent == workspace then
                LP.Character.HumanoidRootPart.CFrame = o.Handle.CFrame
            end
        end
    end

    -- ANTI FLING (NOCLIP)
    if LP.Character then
        for _, part in ipairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = not cfg.antiFling end
        end
    end

    -- BUNNYHOP
    if cfg.bunny and hum and U:IsKeyDown(Enum.KeyCode.Space) then
        if hum.FloorMaterial ~= Enum.Material.Air then hum.Jump = true end
    end
end)

print("PAPA SCRIPT MM2 v5 loaded")
