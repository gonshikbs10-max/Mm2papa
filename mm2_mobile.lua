local P = game:GetService("Players")
local R = game:GetService("RunService")
local LP = P.LocalPlayer
local C = workspace.CurrentCamera
local on = true
local hold = false

local g = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
g.ResetOnSpawn = false

local b = Instance.new("TextButton", g)
b.Size = UDim2.new(0,50,0,50)
b.Position = UDim2.new(0,15,0,80)
b.Text = "S"
b.Parent = g
Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)

local t = Instance.new("TextButton", g)
t.Size = UDim2.new(0,80,0,80)
t.Position = UDim2.new(1,-100,0.6,0)
t.Text = "AIM"
t.Parent = g
Instance.new("UICorner", t).CornerRadius = UDim.new(1,0)

local function murderer(ch)
    return ch and ch:FindFirstChild("Knife") ~= nil
end

b.MouseButton1Click:Connect(function() on = not on end)
t.MouseButton1Down:Connect(function() hold = true end)
t.MouseButton1Up:Connect(function() hold = false end)
t.MouseLeave:Connect(function() hold = false end)

R.RenderStepped:Connect(function()
    if not on or not hold then return end
    local center = Vector2.new(C.ViewportSize.X/2, C.ViewportSize.Y/2)
    local best, bd = nil, 60
    for _, p in ipairs(P:GetPlayers()) do
        if p ~= LP and murderer(p.Character) then
            local h = p.Character:FindFirstChild("Head")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if h and hum and hum.Health > 0 then
                local pos, vis = C:WorldToViewportPoint(h.Position)
                if vis then
                    local d = (Vector2.new(pos.X,pos.Y)-center).Magnitude
                    if d < bd then bd = d; best = h end
                end
            end
        end
    end
    if best then
        C.CFrame = C.CFrame:Lerp(CFrame.new(C.CFrame.Position, best.Position), 0.1)
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        if on then
            for _, p in ipairs(P:GetPlayers()) do
                if p ~= LP and murderer(p.Character) then
                    if not p.Character:FindFirstChild("SE") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "SE"
                        hl.Adornee = p.Character
                        hl.FillColor = Color3.new(1,0,0)
                        hl.Parent = p.Character
                    end
                end
            end
        end
    end
end)

print("mm2 loaded")
