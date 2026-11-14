-- PAPA SCRIPT MM2 v11
local P = game:GetService("Players")
local R = game:GetService("RunService")
local U = game:GetService("UserInputService")
local LP = P.LocalPlayer
local C = workspace.CurrentCamera

local cfg = {
    esp = true, aim = true, autoShoot = false, fling = false
}

-- UI
local g = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
g.ResetOnSpawn = false; g.IgnoreGuiInset = true

local icon = Instance.new("ImageButton", g)
icon.Size = UDim2.new(0, 50, 0, 50); icon.Position = UDim2.new(0, 15, 0, 80)
icon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
icon.Image = "rbxassetid://118814584997415"; icon.Parent = g
Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)

local menu = Instance.new("Frame", g)
menu.Size = UDim2.new(0, 180, 0, 200); menu.Position = UDim2.new(0.5, -90, 0.5, -100)
menu.BackgroundColor3 = Color3.fromRGB(15, 15, 18); menu.Visible = false; menu.Parent = g
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 8)

local closeBtn = Instance.new("TextButton", menu)
closeBtn.Size = UDim2.new(0, 25, 0, 25); closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1); closeBtn.Parent = menu

local scroll = Instance.new("ScrollingFrame", menu)
scroll.Size = UDim2.new(1, -10, 1, -40); scroll.Position = UDim2.new(0, 5, 0, 35)
scroll.BackgroundTransparency = 1; scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = menu; Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 4)

local function addToggle(text, key)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, 0, 0, 28); btn.BackgroundColor3 = cfg[key] and Color3.fromRGB(35, 45, 55) or Color3.fromRGB(25, 25, 30)
    btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.Gotham; btn.TextSize = 12
    btn.Text = "  " .. text .. ": " .. (cfg[key] and "ON" or "OFF"); btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.MouseButton1Click:Connect(function()
        cfg[key] = not cfg[key]; btn.Text = "  " .. text .. ": " .. (cfg[key] and "ON" or "OFF")
        btn.BackgroundColor3 = cfg[key] and Color3.fromRGB(35, 45, 55) or Color3.fromRGB(25, 25, 30)
    end)
end

icon.MouseButton1Click:Connect(function() icon.Visible = false; menu.Visible = true end)
closeBtn.MouseButton1Click:Connect(function() menu.Visible = false; icon.Visible = true end)

-- LOGIC
local function getRole(p)
    if p == LP then return "You" end
    local char = p.Character; local bp = p:FindFirstChild("Backpack")
    if (char and char:FindFirstChild("Knife")) or (bp and bp:FindFirstChild("Knife")) then return "Murderer" end
    if (char and char:FindFirstChild("Gun")) or (bp and bp:FindFirstChild("Gun")) then return "Sheriff" end
    return "Innocent"
end

local function findMurderer()
    local closest, dist = nil, math.huge
    for _, p in ipairs(P:GetPlayers()) do
        if getRole(p) == "Murderer" then
            local head = p.Character and p.Character:FindFirstChild("Head")
            if head then
                local d = (head.Position - C.CFrame.Position).Magnitude
                if d < dist then dist = d; closest = head end
            end
        end
    end
    return closest
end

-- AIM
R:BindToRenderStep("PAPA_AIM", Enum.RenderPriority.Camera.Value + 1, function()
    if cfg.aim then
        local t = findMurderer()
        if t then C.CFrame = CFrame.lookAt(C.CFrame.Position, t.Position) end
    end
end)

-- AUTO SHOOT
R.Heartbeat:Connect(function()
    if cfg.autoShoot then
        local char = LP.Character
        if char and findMurderer() then
            local gun = char:FindFirstChild("Gun") or (LP:FindFirstChild("Backpack") and LP.Backpack:FindFirstChild("Gun"))
            if gun then
                gun.Parent = char
                gun:Activate()
            end
        end
    end
end)

-- FLING (ФИКС: БЕЗ ПОЛЕТА ТЕБЯ, ТОЛЬКО ЦЕЛИ)
R.Heartbeat:Connect(function()
    local myHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if myHRP and cfg.fling then
        for _, p in ipairs(P:GetPlayers()) do
            if p ~= LP and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - myHRP.Position).Magnitude < 15 then
                    -- Кидаем ТОЛЬКО цель
                    hrp.AssemblyLinearVelocity = Vector3.new(math.random(-1000,1000), 5000, math.random(-1000,1000))
                end
            end
        end
    end
end)

-- ESP
R.RenderStepped:Connect(function()
    if cfg.esp then
        for _, p in ipairs(P:GetPlayers()) do
            if p ~= LP and p.Character then
                local role = getRole(p)
                local h = p.Character:FindFirstChild("PAPA_ESP") or Instance.new("Highlight", p.Character)
                h.Name = "PAPA_ESP"; h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                if role == "Murderer" then h.FillColor = Color3.fromRGB(255, 0, 0)
                elseif role == "Sheriff" then h.FillColor = Color3.fromRGB(0, 100, 255)
                else h.FillColor = Color3.fromRGB(0, 255, 0) end
            end
        end
    end
end)

addToggle("ESP", "esp")
addToggle("Aimbot", "aim")
addToggle("Auto Shoot (Murder)", "autoShoot")
addToggle("Fling (Touch)", "fling")

print("PAPA SCRIPT v11 loaded")
