-- Checking game 
if game.PlaceId == 8619263259 then
    print("Script starting...")
    local BlackMarket = workspace:FindFirstChild("Stalls"):FindFirstChild("Black Market")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character
    local HRP = Character and Character:FindFirstChild("HumanoidRootPart")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local workspace =  game:GetService("Workspace")

    local spawnTime = math.random(600, 900) -- 10 to 15 minutes in seconds
    local despawnTime = 300 -- 5 minutes in seconds
    local timer = 0
    local teleported = false
    local teleportCount = 0
    local loopCount = 0

    -- UI Setup
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BlackMarketInfo"
    screenGui.Parent = LocalPlayer.PlayerGui

    local infoFrame = Instance.new("Frame")
    infoFrame.Name = "InfoFrame"
    infoFrame.Size = UDim2.new(0, 200, 0, 100)
    infoFrame.Position = UDim2.new(1, -210, 0, 10)
    infoFrame.AnchorPoint = Vector2.new(1, 0)
    infoFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    infoFrame.BorderSizePixel = 0
    infoFrame.Parent = screenGui

    local timerLabel = Instance.new("TextLabel")
    timerLabel.Name = "TimerLabel"
    timerLabel.Size = UDim2.new(1, 0, 0.3, 0)
    timerLabel.Position = UDim2.new(0, 0, 0, 0)
    timerLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    timerLabel.BackgroundTransparency = 1
    timerLabel.TextColor3 = Color3.new(1, 1, 1)
    timerLabel.TextSize = 18
    timerLabel.Font = Enum.Font.SourceSansBold
    timerLabel.Text = "Time: 0:00"
    timerLabel.Parent = infoFrame

    local teleportLabel = Instance.new("TextLabel")
    teleportLabel.Name = "TeleportLabel"
    teleportLabel.Size = UDim2.new(1, 0, 0.3, 0)
    teleportLabel.Position = UDim2.new(0, 0, 0.3, 0)
    teleportLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    teleportLabel.BackgroundTransparency = 1
    teleportLabel.TextColor3 = Color3.new(1, 1, 1)
    teleportLabel.TextSize = 18
    teleportLabel.Font = Enum.Font.SourceSansBold
    teleportLabel.Text = "Teleports: 0"
    teleportLabel.Parent = infoFrame

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, 0, 0.3, 0)
    statusLabel.Position = UDim2.new(0, 0, 0.6, 0)
    statusLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextColor3 = Color3.new(1, 1, 1)
    statusLabel.TextSize = 18
    statusLabel.Font = Enum.Font.SourceSansBold
    statusLabel.Text = "Waiting..."
    statusLabel.Parent = infoFrame

    local function formatTime(seconds)
        local minutes = math.floor(seconds / 60)
        local remainingSeconds = seconds % 60
        return string.format("%d:%02d", minutes, remainingSeconds)
    end

    local function findGrani()
        for _, v in pairs(BlackMarket:GetDescendants()) do
            if v.Name == "Grani" and v.Parent.Parent.Name == "Grani" then
                return v
            end
        end
        return nil
    end

    local function teleportToGrani(graniPart)
        if HRP and graniPart then
            HRP.CFrame = graniPart.CFrame
            teleportCount = teleportCount + 1
            teleported = true
            teleportLabel.Text = "Teleports: " .. teleportCount
            statusLabel.Text = "Teleported!"
        end
    end

    local function resetLoop()
        timer = 0
        teleported = false
        loopCount = loopCount + 1
        statusLabel.Text = "Waiting..."
        spawnTime = math.random(600, 900)
    end

    local function despawnGrani()
        for _, v in pairs(BlackMarket:GetDescendants()) do
            if v.Name == "Grani" and v.Parent.Parent.Name == "Grani" then
                v.Parent.Parent:Destroy()
            end
        end
    end

    local function spawnGrani()
        local newGrani = ReplicatedStorage.Grani:Clone()
        newGrani.Parent = BlackMarket
        newGrani.Name = "Grani"
        newGrani:SetPrimaryPartCFrame(CFrame.new(BlackMarket.Position + Vector3.new(0, 5, 0)))
    end

    RunService.Heartbeat:Connect(function()
        timerLabel.Text = "Time: " .. formatTime(tick()) -- Using tick() for uptime

        if loopCount < 10 then
            if timer >= spawnTime and not findGrani() then
                spawnGrani()
                timer = 0
                statusLabel.Text = "Grani Spawned!"
            end

            local graniPart = findGrani()
            if graniPart and not teleported then
                teleportToGrani(graniPart)
            end

            if graniPart and timer >= despawnTime and teleported then
                despawnGrani()
                resetLoop()
            end

        else
            statusLabel.Text = "Loop Complete"
        end
    end)
end
