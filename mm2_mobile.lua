-- PAPA SCRIPT MM2 v2
local P = game:GetService("Players")
local R = game:GetService("RunService")
local U = game:GetService("UserInputService")
local T = game:GetService("TweenService")
local LP = P.LocalPlayer
local C = workspace.CurrentCamera

local cfg = {
    esp = true, aim = true, aimFOV = 360, smooth = 0.85,
    shoot = false, autoFarm = false, bunny = false,
    skin = "None"
}

local isDragging, dragInput, dragStart, startPos
local function makeDraggable(frame)
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then isDragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    U.InputChanged:Connect(function(input)
        if input == dragInput and isDragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local g = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
g.ResetOnSpawn = false
g.IgnoreGuiInset = true

local icon = Instance.new("ImageButton", g)
icon.Size = UDim2.new(0, 60, 0, 60)
icon.Position = UDim2.new(0, 15, 0, 80)
icon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
icon.Image = "rbxassetid://7734068321"
icon.ScaleType = Enum.ScaleType.Crop
icon.Parent = g
Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)
makeDraggable(icon)

local aimBtn = Instance.new("TextButton", g)
aimBtn.Size = UDim2.new(0, 70, 0, 70)
aimBtn.Position = UDim2.new(1, -90, 0.6, 0)
aimBtn.BackgroundColor3 = Color3.fromRGB(150, 20, 20)
aimBtn.Text = "AIM"
aimBtn.TextColor3 = Color3.new(1,1,1)
aimBtn.Font = Enum.Font.GothamBold
aimBtn.Parent = g
Instance.new("UICorner", aimBtn).CornerRadius = UDim.new(1, 0)
makeDraggable(aimBtn)

local menu = Instance.new("Frame", g)
menu.Size = UDim2.new(0, 290, 0, 400)
menu.Position = UDim2.new(0.5, -145, 0.5, -200)
menu.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
menu.Visible = false
menu.Parent = g
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", menu).Color = Color3.fromRGB(80, 80, 100)
makeDraggable(menu)

local title = Instance.new("TextLabel", menu)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "PAPA SCRIPT MM2"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = menu

local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -20, 1, -50)
scroll.Position = UDim2.new(0, 10, 0, 45)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 2
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = menu
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 8)

local function addToggle(text, key, cb)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = cfg[key] and Color3.fromRGB(0, 120, 60) or Color3.fromRGB(35, 35, 45)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = text .. ": " .. (cfg[key] and "ON" or "OFF")
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        cfg[key] = not cfg[key]
        btn.Text = text .. ": " .. (cfg[key] and "ON" or "OFF")
        btn.BackgroundColor3 = cfg[key] and Color3.fromRGB(0, 120, 60) or Color3.fromRGB(35, 35, 45)
        if cb then cb(cfg[key]) end
    end)
end

local function addButton(text, cb)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = text
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(cb)
end

icon.MouseButton1Click:Connect(function() menu.Visible = not menu.Visible end)

-- SHIFT LOCK AIM
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

local function findTarget(isMurdererOnly)
    local closest, dist = nil, cfg.aimFOV
    local center = Vector2.new(C.ViewportSize.X/2, C.ViewportSize.Y/2)
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= LP then
            local role = getRole(p)
            if not isMurdererOnly or role == "Murderer" then
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
local function applySkin()
    local bp = LP:FindFirstChild("Backpack")
    local char = LP.Character
    if not bp and not char then return end
    
    local tool = char:FindFirstChild("Gun") or (bp and bp:FindFirstChild("Gun"))
    if not tool then return end
    
    local mesh = tool:FindFirstChild("Handle") and tool.Handle:FindFirstChildOfClass("SpecialMesh")
    if not mesh then return end
    
    if cfg.skin == "AWP" then
        mesh.MeshId = "rbxassetid://132576701" -- AWP-like mesh
        mesh.TextureId = "rbxassetid://132576704"
    elseif cfg.skin == "Deagle" then
        mesh.MeshId = "rbxassetid://132576705" -- Deagle-like mesh
        mesh.TextureId = "rbxassetid://132576708"
    end
end

addToggle("Role ESP", "esp")
addToggle("Aimbot (ShiftLock)", "aim")
addToggle("Auto Shoot", "shoot")
addToggle("Auto Farm Coins", "autoFarm")
addToggle("BunnyHop", "bunny")

addButton("Kill All (Aim)", function()
    cfg.aim = true
    local originalSmooth = cfg.smooth
    cfg.smooth = 1
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= LP and p.Character and getRole(p) == "Murderer" then
            local head = p.Character:FindFirstChild("Head")
            if head then
                C.CFrame = CFrame.lookAt(C.CFrame.Position, head.Position)
                local gun = LP.Character:FindFirstChild("Gun")
                if gun then gun:Activate() end
                task.wait(0.1)
            end
        end
    end
    cfg.smooth = originalSmooth
end)

addButton("Skin: AWP (CS2)", function() cfg.skin = "AWP"; applySkin() end)
addButton("Skin: Deagle (CS2)", function() cfg.skin = "Deagle"; applySkin() end)
addButton("Skin: None", function() cfg.skin = "None" end)

-- SHOOT HOOK (Sound logic)
local function hookGun(tool)
    if tool.Name == "Gun" then
        tool.Activated:Connect(function()
            local snd = Instance.new("Sound", tool.Handle)
            if cfg.skin == "AWP" then
                snd.SoundId = "rbxassetid://131886172" -- AWP sound
            elseif cfg.skin == "Deagle" then
                snd.SoundId = "rbxassetid://131886173" -- Deagle sound
            end
            snd.Volume = 1
            snd:Play()
            game:GetService("Debris"):AddItem(snd, 2)
        end)
    end
end

LP.CharacterAdded:Connect(function(c)
    c.ChildAdded:Connect(function(ch)
        if ch:IsA("Tool") then hookGun(ch) end
    end)
    for _, ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") then hookGun(ch) end end
end)

-- MAIN LOOP
R.RenderStepped:Connect(function()
    -- ESP
    if cfg.esp then
        for _, p in ipairs(P:GetPlayers()) do
            if p ~= LP and p.Character then
                local role = getRole(p)
                local esp = p.Character:FindFirstChild("PAPA_ESP")
                if role == "Murderer" and not esp then
                    local h = Instance.new("Highlight", p.Character)
                    h.Name = "PAPA_ESP"
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                elseif role ~= "Murderer" and esp then esp:Destroy() end
            end
        end
    end

    -- AIM (ShiftLock trigger)
    if cfg.aim and isShiftLock() then
        local target = findTarget(true) -- ONLY murderer
        if target then
            C.CFrame = C.CFrame:Lerp(CFrame.lookAt(C.CFrame.Position, target.Position), cfg.smooth)
        end
    end

    -- AUTO FARM
    if cfg.autoFarm and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local coinFound = false
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == "Coin" and obj:IsA("BasePart") then
                coinFound = true
                LP.Character.HumanoidRootPart.CFrame = obj.CFrame
            end
        end
        if not coinFound then
            local target = findTarget(true)
            if target and LP.Character.HumanoidRootPart then
                LP.Character.HumanoidRootPart.Velocity = (target.Position - LP.Character.HumanoidRootPart.Position).Unit * 50
            end
        end
    end

    -- BUNNYHOP
    if cfg.bunny and LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum.FloorMaterial ~= Enum.Material.Air then
            hum.Jump = true
        end
    end
end)

-- TROLL FLING (Physics based)
R.Heartbeat:Connect(function()
    if cfg.esp and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        for _, p in ipairs(P:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist < 5 then
                    local bv = Instance.new("BodyVelocity", p.Character.HumanoidRootPart)
                    bv.Velocity = Vector3.new(math.random(-500,500), 1000, math.random(-500,500))
                    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    game:GetService("Debris"):AddItem(bv, 0.2)
                end
            end
        end
    end
end)

print("PAPA SCRIPT MM2 v2 loaded")
