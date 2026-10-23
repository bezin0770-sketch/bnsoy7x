-- ============================================================
-- bnsoy7x | Steal an Egg
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local CG = game:GetService("CoreGui")
local LP = Players.LocalPlayer

if CG:FindFirstChild("bnsoy7x") then CG.bnsoy7x:Destroy() end

local EggDB = {
    ["Petal Beetle"] = {Rar = "Mythic", Val = 9670000, Color = Color3.fromRGB(200, 50, 200)},
    ["Bronto"] = {Rar = "Cosmic", Val = 1390000, Color = Color3.fromRGB(100, 150, 255)},
    ["Divine"] = {Rar = "Divine", Val = 1500000, Color = Color3.fromRGB(255, 215, 0)},
    ["Secret"] = {Rar = "Secret", Val = 5000000, Color = Color3.fromRGB(255, 50, 50)},
    ["Eternal"] = {Rar = "Eternal", Val = 20000000, Color = Color3.fromRGB(150, 0, 255)},
    ["Default"] = {Rar = "Comum", Val = 1000, Color = Color3.fromRGB(200, 200, 200)}
}

local Cfg = {AutoSteal = false, OneShot = false, Filter = "All", SelectedEgg = nil, BasePos = nil}

local Gui = Instance.new("ScreenGui", CG)
Gui.Name = "bnsoy7x"
Gui.ResetOnSpawn = false

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 260, 0, 360)
Main.Position = UDim2.new(0.5, -130, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(10, 15, 10)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 100, 0)

local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 40)
Top.BackgroundColor3 = Color3.fromRGB(15, 25, 15)
Instance.new("UICorner", Top).CornerRadius = UDim.new(0, 8)

local Logo = Instance.new("TextLabel", Top)
Logo.Size = UDim2.new(1, -40, 1, 0)
Logo.Position = UDim2.new(0, 10, 0, 0)
Logo.BackgroundTransparency = 1
Logo.Text = "⚡ bnsoy7x"
Logo.TextColor3 = Color3.fromRGB(200, 255, 200)
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 14
Logo.TextXAlignment = Enum.TextXAlignment.Left

local Close = Instance.new("TextButton", Top)
Close.Size = UDim2.new(0, 25, 0, 25)
Close.Position = UDim2.new(1, -30, 0, 7)
Close.BackgroundColor3 = Color3.fromRGB(30, 50, 30)
Close.Text = "x"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 4)
Close.MouseButton1Click:Connect(function() Main.Visible = false end)

local BestFrame = Instance.new("Frame", Main)
BestFrame.Size = UDim2.new(1, -20, 0, 50)
BestFrame.Position = UDim2.new(0, 10, 0, 45)
BestFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 20)
Instance.new("UICorner", BestFrame).CornerRadius = UDim.new(0, 6)

local BestTitle = Instance.new("TextLabel", BestFrame)
BestTitle.Size = UDim2.new(1, -10, 0, 15)
BestTitle.Position = UDim2.new(0, 5, 0, 2)
BestTitle.BackgroundTransparency = 1
BestTitle.Text = "BEST EGG"
BestTitle.TextColor3 = Color3.fromRGB(100, 150, 100)
BestTitle.Font = Enum.Font.GothamBold
BestTitle.TextSize = 10
BestTitle.TextXAlignment = Enum.TextXAlignment.Left

local BestInfo = Instance.new("TextLabel", BestFrame)
BestInfo.Size = UDim2.new(1, -10, 0, 25)
BestInfo.Position = UDim2.new(0, 5, 0, 15)
BestInfo.BackgroundTransparency = 1
BestInfo.Text = "Nenhum ovo..."
BestInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
BestInfo.Font = Enum.Font.GothamBold
BestInfo.TextSize = 12
BestInfo.TextXAlignment = Enum.TextXAlignment.Left

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 0, 110)
Scroll.Position = UDim2.new(0, 10, 0, 105)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 2
Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 2)

local FilterFrame = Instance.new("Frame", Main)
FilterFrame.Size = UDim2.new(1, -20, 0, 35)
FilterFrame.Position = UDim2.new(0, 10, 0, 225)
FilterFrame.BackgroundTransparency = 1

local function MakeFilter(txt, col, x, y)
    local B = Instance.new("TextButton", FilterFrame)
    B.Size = UDim2.new(0.5, -2, 0, 15)
    B.Position = UDim2.new(x, 0, y, 0)
    B.BackgroundColor3 = col
    B.Text = txt
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    B.Font = Enum.Font.GothamBold
    B.TextSize = 9
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 2)
    B.MouseButton1Click:Connect(function()
        Cfg.Filter = txt
        UpdateList()
    end)
end

MakeFilter("Cosmic", Color3.fromRGB(100, 50, 200), 0, 0)
MakeFilter("Eternal", Color3.fromRGB(200, 50, 200), 0.5, 0)
MakeFilter("Secret", Color3.fromRGB(50, 200, 50), 0, 1)
MakeFilter("Divine", Color3.fromRGB(200, 150, 50), 0.5, 1)

local function MakeBtn(txt, y, key)
    local B = Instance.new("TextButton", Main)
    B.Size = UDim2.new(1, -20, 0, 30)
    B.Position = UDim2.new(0, 10, 0, y)
    B.BackgroundColor3 = Cfg[key] and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(30, 40, 30)
    B.Text = txt
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    B.Font = Enum.Font.GothamBold
    B.TextSize = 11
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)
    B.MouseButton1Click:Connect(function()
        Cfg[key] = not Cfg[key]
        B.BackgroundColor3 = Cfg[key] and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(30, 40, 30)
        if key == "AutoSteal" and Cfg.AutoSteal then
            Cfg.BasePos = LP.Character and LP.Character.HumanoidRootPart.Position
        end
    end)
end

MakeBtn("Auto Steal (Loop)", 270, "AutoSteal")
MakeBtn("One Shot", 305, "OneShot")

local function GetEggData(name)
    for k, v in pairs(EggDB) do
        if name:lower():find(k:lower()) then return v end
    end
    return EggDB["Default"]
end

function UpdateList()
    for _, c in pairs(Scroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    local y = 5
    local bestEgg = nil
    local bestVal = 0

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():find("egg") or obj.Name:lower():find("ovo")) then
            local data = GetEggData(obj.Name)
            
            if Cfg.Filter == "All" or data.Rar == Cfg.Filter then
                local B = Instance.new("TextButton", Scroll)
                B.Size = UDim2.new(1, -5, 0, 30)
                B.Position = UDim2.new(0, 0, 0, y)
                B.BackgroundColor3 = Color3.fromRGB(20, 30, 20)
                B.Text = "  "..obj.Name.." | "..data.Rar.." | "..(data.Val/1000000).."M"
                B.TextColor3 = data.Color
                B.TextXAlignment = Enum.TextXAlignment.Left
                B.Font = Enum.Font.GothamBold
                B.TextSize = 11
                Instance.new("UICorner", B).CornerRadius = UDim.new(0, 4)
                
                B.MouseButton1Click:Connect(function()
                    Cfg.SelectedEgg = obj
                    for _, btn in pairs(Scroll:GetChildren()) do if btn:IsA("TextButton") then btn.BackgroundColor3 = Color3.fromRGB(20, 30, 20) end end
                    B.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
                end)
                y = y + 32
            end

            if data.Val > bestVal then
                bestVal = data.Val
                bestEgg = obj.Name.." ("..data.Rar..")"
            end
        end
    end

    if y == 5 then
        local L = Instance.new("TextLabel", Scroll)
        L.Size = UDim2.new(1, 0, 0, 30)
        L.BackgroundTransparency = 1
        L.Text = "Nenhum ovo encontrado."
        L.TextColor3 = Color3.fromRGB(150, 150, 150)
        L.Font = Enum.Font.GothamMedium
        L.TextSize = 11
    end
    
    Scroll.CanvasSize = UDim2.new(0, 0, 0, y + 5)
    if bestEgg then BestInfo.Text = bestEgg end
end

local function Steal(target)
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    hrp.CFrame = CFrame.new(target:GetPivot().Position + Vector3.new(0, 3, 0))
    task.wait(0.3)
    
    local prompt = target:FindFirstChildWhichIsA("ProximityPrompt", true)
    if prompt then pcall(function() fireproximityprompt(prompt, 0, true) end) end
    
    pcall(function() firetouchinterest(hrp, target:IsA("BasePart") and target or target.PrimaryPart, 0) task.wait(0.1) firetouchinterest(hrp, target:IsA("BasePart") and target or target.PrimaryPart, 1) end)
    
    pcall(function()
        VIM:SendMouseButtonEvent(0,0,0,true,game,1)
        task.wait(0.05)
        VIM:SendMouseButtonEvent(0,0,0,false,game,1)
    end)
    
    task.wait(0.5)
    if Cfg.BasePos then hrp.CFrame = CFrame.new(Cfg.BasePos) end
end

task.spawn(function() while task.wait(2) do pcall(UpdateList) end end)

task.spawn(function()
    while task.wait(0.5) do
        if Cfg.AutoSteal and Cfg.BasePos then
            local target = Cfg.SelectedEgg
            if not target or not target.Parent then
                local best, bv = nil, 0
                for _, o in pairs(workspace:GetDescendants()) do
                    if o:IsA("Model") and (o.Name:lower():find("egg") or o.Name:lower():find("ovo")) then
                        local d = GetEggData(o.Name)
                        if d.Val > bv then best = o bv = d.Val end
                    end
                end
                target = best
            end

            if target then
                Steal(target)
                if Cfg.OneShot then Cfg.AutoSteal = false end
                task.wait(3)
            end
        end
    end
end)

UIS.InputBegan:Connect(function(i, g) if g then return end if i.KeyCode == Enum.KeyCode.RightShift then Main.Visible = not Main.Visible end end)
print("[bnsoy7x] Executado com sucesso.")
