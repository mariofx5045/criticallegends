-- Checking game 
if game.PlaceId == 8619263259 then
    local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local HRP = Character and Character:FindFirstChild("HumanoidRootPart")
local workspace = game:GetService("Workspace")
local teleportCount = 0 -- Initialize the teleport counter

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
    if HRP then
      print("Teleporting to Grani...")
      HRP.CFrame = graniPart.CFrame
      teleportCount = teleportCount + 1 -- Increment the counter
      print("Teleported to Grani. Teleport count:", teleportCount)
      return true
    else
      print("HumanoidRootPart not found. Character may not be fully loaded.")
      return false
    end
  else
    print("Grani part not found.")
    return false
  end
end

local function checkAndTeleport()
  if teleportToGrani() then
    -- Grani was found and teleported to.
  else
    -- Grani was not found.
  end
end

local function loopCheck()
  while true do
    checkAndTeleport()
    wait(1) -- Adjust the wait time as needed (e.g., 0.5, 2)
  end
end

local function graniExists()
    local blackMarket = workspace:FindFirstChild("Stalls"):FindFirstChild("Black Market")
    if not blackMarket then
        return false;
    end
    for _, v in ipairs(blackMarket:GetDescendants()) do
        if v.Name == "Grani" and v.Parent.Parent.Name == "Grani" then
            return true;
        end
    end
    return false;
end

-- Initial check and loop
if Character then
    if graniExists() then
        print("Grani is currently present.")
    else
        print("Grani is not currently present.")
    end
    loopCheck()
else
    CharacterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(char)
        Character = char
        HRP = char:FindFirstChild("HumanoidRootPart")
        if graniExists() then
            print("Grani is currently present.")
        else
            print("Grani is not currently present.")
        end
        loopCheck()
        CharacterAddedConnection:Disconnect()
    end)
end
end
