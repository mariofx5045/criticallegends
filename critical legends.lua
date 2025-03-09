-- Checking game 
if game.PlaceId == 8619263259 then
    -- Version of the script
    local CurrentVersion = "Auto Blackmarket" 

    -- Call library
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

    -- Main shit
    local Window = Library.CreateLib(CurrentVersion,"DarkTheme")
    
    -- Blackmarket tab

    local ATab = Window:NewTab("Auto Blackmarket")
    local ASection = Window:NewSection("Auto Blackmarket")

    -- Toggle Variables

    local workspace = game:GetService("Workspace")
    local Players = game:GetService("Players")
    local task = require(game:GetService("ReplicatedStorage").task) -- Required for task.wait

    local Tp = true -- Default toggle state
    ASection:NewToggle("Check and auto teleports notifies Blackmarket", function(state)
        Tp = state
        task.spawn(function()
            while true do
                if Tp then
                    local BlackMarket = workspace:FindFirstChild("Stalls"):FindFirstChild("Black Market")
                    if BlackMarket then
                        local graniPart = nil
                        for _, descendant in ipairs(BlackMarket:GetDescendants()) do
                            if descendant.Name == "Grani" and descendant.Parent.Parent.Name == "Grani" then
                                graniPart = descendant
                                break
                            end
                        end
        
                        if graniPart then
                            local HRP = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if HRP then
                                HRP.CFrame = graniPart.CFrame
                                local notificationText = "Teleported to Black Market."
                                game:GetService("StarterGui"):SetCore("SendNotification", {
                                    Title = "Teleport",
                                    Text = notificationText,
                                    Duration = 8,
                                })
                                print("Teleported player to Black Market.")
                            else
                                print("Character not loaded yet.")
                            end
        
                            local function onGraniRemoved(removedPart)
                                if removedPart == graniPart then
                                    print("Grani part removed.")
                                    return true
                                end
                                return false
                            end
        
                            local connection
                            connection = workspace.DescendantRemoving:Connect(function(removedPart)
                                if onGraniRemoved(removedPart) then
                                    connection:Disconnect()
                                end
                            end)
        
                            repeat task.wait() until not graniPart or not graniPart.Parent
                            print("Grani part or parent no longer exists. Waiting for respawn.")
                        else
                            print("Grani part not found.")
                        end
                    else
                        print("Black Market not found.")
                    end
                    repeat task.wait() until workspace:FindFirstChild("Stalls"):FindFirstChild("Black Market")
                else
                    task.wait(1) -- Wait when toggle is off to reduce CPU usage
                end
            end
        end)
    end)
end