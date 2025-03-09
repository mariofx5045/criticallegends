-- Checking game 
if game.PlaceId == 8619263259 then
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer and LocalPlayer.Character
    local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

    local teleportCount = 0
    local teleportedThisSpawn = false

    local function notify(message)
        local gui = LocalPlayer:FindFirstChild("PlayerGui")
        if gui then
            local notification = Instance.new("ScreenGui")
            notification.Name = "NotificationGui"
            notification.Parent = gui

            local textLabel = Instance.new("TextLabel")
            textLabel.Parent = notification
            textLabel.BackgroundTransparency = 0.5
            textLabel.BackgroundColor3 = Color3.new(0, 0, 0)
            textLabel.TextColor3 = Color3.new(1, 1, 1)
            textLabel.Size = UDim2.new(0, 200, 0, 50)
            textLabel.Position = UDim2.new(0.5, -100, 0.9, -25)
            textLabel.Text = message
            textLabel.TextScaled = true

            game:GetService("TweenService"):Create(textLabel, TweenInfo.new(1), {BackgroundTransparency = 0}):Play()
            game:GetService("TweenService"):Create(textLabel, TweenInfo.new(7, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
            game:GetService("Debris"):AddItem(notification, 8)
        end
    end

    local function teleportToGrani()
        local blackMarket = workspace:FindFirstChild("Stalls"):FindFirstChild("Black Market")
        if not blackMarket then
            notify("Black Market stall not found.")
            return false
        end

        local graniPart = nil
        for _, v in ipairs(blackMarket:GetDescendants()) do
            if v.Name == "Grani" and v.Parent.Parent.Name == "Grani" then
                graniPart = v
                break
            end
        end

        if graniPart then
            if HRP and not teleportedThisSpawn then
                notify("Teleporting to Grani...")
                HRP.CFrame = graniPart.CFrame
                teleportCount = teleportCount + 1
                teleportedThisSpawn = true
                notify("Teleported to Grani. Teleport count: " .. teleportCount)
                return true
            elseif teleportedThisSpawn then
                return true;
            else
                notify("HumanoidRootPart not found. Character may not be fully loaded.")
                return false
            end
        else
            return false
        end
    end

    local function checkAndTeleport()
        teleportToGrani()
    end

    local function loopCheck()
        while true do
            if graniExists() then
                checkAndTeleport()
            else
                teleportedThisSpawn = false
            end
            wait(1)
        end
    end

    local function graniExists()
        local blackMarket = workspace:FindFirstChild("Stalls"):FindFirstChild("Black Market")
        if not blackMarket then
            return false
        end
        for _, v in ipairs(blackMarket:GetDescendants()) do
            if v.Name == "Grani" and v.Parent.Parent.Name == "Grani" then
                return true
            end
        end
        return false
    end

    -- Initial check and loop
    if LocalPlayer and LocalPlayer.Character then
        if graniExists() then
            notify("Grani is currently present.")
        else
            notify("Grani is not currently present.")
        end
        loopCheck()
    else
        local playerAddedConnection
        playerAddedConnection = Players.PlayerAdded:Connect(function(player)
            if player == LocalPlayer then
                playerAddedConnection:Disconnect()
                local characterAddedConnection
                characterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(char)
                    Character = char
                    HRP = char:FindFirstChild("HumanoidRootPart")
                    if graniExists() then
                        notify("Grani is currently present.")
                    else
                        notify("Grani is not currently present.")
                    end
                    loopCheck()
                    characterAddedConnection:Disconnect()
                end)
            end
        end)
    end
end
