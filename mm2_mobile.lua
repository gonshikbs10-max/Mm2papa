-- PAPA SCRIPT MM2
local P = game:GetService("Players")
local R = game:GetService("RunService")
local U = game:GetService("UserInputService")
local LP = P.LocalPlayer
local C = workspace.CurrentCamera

local cfg = {
    esp = true, aim = true, fov = 120, smooth = 0.15,
    fling = false, orbit = false, troll = false, fps = false
}
local hold = false

-- UI
local g = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
g.ResetOnSpawn = false
g.IgnoreGuiInset = true

local icon = Instance.new("ImageButton", g)
icon.Size = UDim2.new(0, 60, 0, 60)
icon.Position = UDim2.new(0, 15, 0, 80)
icon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
icon.Image = "rbxassetid://7734068321" -- Круглая иконка (замени на свою)
icon.ScaleType = Enum.ScaleType.Crop
icon.Parent = g
Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)

local aimBtn = Instance.new("TextButton", g)
aimBtn.Size = UDim2.new(0, 80, 0, 80)
aimBtn.Position = UDim2.new(1, -100, 0.6, 0)
aimBtn.BackgroundColor3 = Color3.fromRGB(150, 20, 20)
aimBtn.Text = "AIM"
aimBtn.TextColor3 = Color3.new(1,1,1)
aimBtn.Font = Enum.Font.GothamBold
aimBtn.Parent = g
Instance.new("UICorner", aimBtn).CornerRadius = UDim.new(1, 0)

local menu = Instance.new("Frame", g)
menu.Size = UDim2.new(0, 280, 0, 350)
menu.Position = UDim2.new(0.5, -140, 0.5, -175)
menu.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
menu.Visible = false
menu.Parent = g
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", menu)
stroke.Color = Color3.fromRGB(80, 80, 100)

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
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 8)

local function addToggle(text, key)
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
    end)
end

icon.MouseButton1Click:Connect(function() menu.Visible = not menu.Visible end)
aimBtn.MouseButton1Down:Connect(function() hold = true end)
aimBtn.MouseButton1Up:Connect(function() hold = false end)
aimBtn.MouseLeave:Connect(function() hold = false end)

addToggle("Role ESP (from start)", "esp")
addToggle("Aimbot (Murderer)", "aim")
addToggle("FPS Boost", "fps")
addToggle("Orbit (Troll)", "orbit")
addToggle("Fling (Touch)", "fling")
addToggle("Troll (Drag)", "troll")

-- FPS Boost
if cfg.fps then
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.Material = Enum.Material.SmoothPlastic end
        if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end
    end
    game:GetService("Lighting").GlobalShadows = false
end

-- Logic
local function getRole(p)
    local ch = p.Character
    if not ch then return nil end
    local bp = p:FindFirstChild("Backpack")
    if (ch:FindFirstChild("Knife") or (bp and bp:FindFirstChild("Knife"))) then return "Murderer" end
    if (ch:FindFirstChild("Gun") or (bp and bp:FindFirstChild("Gun"))) then return "Sheriff" end
    return "Innocent"
end

local function applyESP()
    if not cfg.esp then return end
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= LP and p.Character then
            local role = getRole(p)
            if role == "Murderer" then
                if not p.Character:FindFirstChild("PAPA_ESP") then
                    local h = Instance.new("Highlight", p.Character)
                    h.Name = "PAPA_ESP"
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                    h.OutlineColor = Color3.fromRGB(255, 0, 0)
                    h.FillTransparency = 0.5
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
            elseif role == "Sheriff" then
                if not p.Character:FindFirstChild("PAPA_ESP") then
                    local h = Instance.new("Highlight", p.Character)
                    h.Name = "PAPA_ESP"
                    h.FillColor = Color3.fromRGB(0, 100, 255)
                    h.OutlineColor = Color3.fromRGB(0, 100, 255)
                    h.FillTransparency = 0.5
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
            end
        end
    end
end

-- Aim & Troll & Fling
local function findMurderer()
    local closest, dist = nil, cfg.fov
    local center = Vector2.new(C.ViewportSize.X/2, C.ViewportSize.Y/2)
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= LP and getRole(p) == "Murderer" then
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

R.RenderStepped:Connect(function()
    applyESP()
    
    if cfg.aim and hold then
        local target = findMurderer()
        if target then
            C.CFrame = C.CFrame:Lerp(CFrame.new(C.CFrame.Position, target.Position), cfg.smooth)
        end
    end

    local myChar = LP.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if myHRP then
        if cfg.orbit then
            local angle = tick() * 3
            myHRP.CFrame = myHRP.CFrame * CFrame.Angles(0, math.rad(angle), 0)
        end
        if cfg.fling then
            for _, p in ipairs(P:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (myHRP.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 5 then
                        myHRP.Velocity = Vector3.new(99999, 99999, 99999)
                    end
                end
            end
        end
    end
end)

print("PAPA SCRIPT MM2 loaded")
