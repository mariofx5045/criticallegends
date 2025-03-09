-- Checking game 
if game.PlaceId == 8619263259 then
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer and LocalPlayer.Character
    local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

    local teleportCount = 0
    local teleportedThisSpawn = false -- Flag to track if teleported during the current Grani spawn

    local function teleportToGrani()
        local blackMarket = workspace:FindFirstChild("Stalls"):FindFirstChild("Black Market")
        if not blackMarket then
            print("Black Market stall not found.")
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
            if HRP and not teleportedThisSpawn then -- Check if HRP exists and not already teleported
                print("Teleporting to Grani...")
                HRP.CFrame = graniPart.CFrame
                teleportCount = teleportCount + 1
                teleportedThisSpawn = true -- Set the flag
                print("Teleported to Grani. Teleport count:", teleportCount)
                return true
            elseif teleportedThisSpawn then
                --Do nothing, already teleported.
                return true;
            else
                print("HumanoidRootPart not found. Character may not be fully loaded.")
                return false
            end
        else
            --print("Grani part not found.") --removed to reduce spam
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
                teleportedThisSpawn = false -- Reset the flag when Grani is gone
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
            print("Grani is currently present.")
        else
            print("Grani is not currently present.")
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
                        print("Grani is currently present.")
                    else
                        print("Grani is not currently present.")
                    end
                    loopCheck()
                    characterAddedConnection:Disconnect()
                end)
            end
        end)
    end
end
