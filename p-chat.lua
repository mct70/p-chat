local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("PChatGui") then
    playerGui.PChatGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PChatGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = playerGui

local pChatButton = Instance.new("TextButton")
pChatButton.Name = "PChatButton"
pChatButton.Size = UDim2.new(0, 100, 0, 44)
pChatButton.Position = UDim2.new(0, 15, 0, -46)
pChatButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
pChatButton.Text = ""
pChatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
pChatButton.TextSize = 14
pChatButton.Font = Enum.Font.GothamBold
pChatButton.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = pChatButton

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(60, 60, 60)
btnStroke.Thickness = 1.5
btnStroke.Parent = pChatButton

local chatPanel = Instance.new("Frame")
chatPanel.Name = "ChatPanel"
chatPanel.Size = UDim2.new(0, 475, 0, 325)
chatPanel.Position = UDim2.new(0, 10, 0, 5)
chatPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
chatPanel.BackgroundTransparency = 0.2
chatPanel.Visible = false
chatPanel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 12)
panelCorner.Parent = chatPanel

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.fromRGB(80, 80, 80)
panelStroke.Thickness = 1.5
panelStroke.Parent = chatPanel

local messageScroll = Instance.new("ScrollingFrame")
messageScroll.Name = "MessageScroll"
messageScroll.Size = UDim2.new(1, -20, 1, -20)
messageScroll.Position = UDim2.new(0, 10, 0, 10)
messageScroll.BackgroundTransparency = 1
messageScroll.BorderSizePixel = 0
messageScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
messageScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
messageScroll.ScrollBarThickness = 4
messageScroll.Parent = chatPanel

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0, 6)
uiListLayout.Parent = messageScroll

local function addMessage(senderName, messageText)
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, 0, 0, 0)
    msgLabel.AutomaticSize = Enum.AutomaticSize.Y
    msgLabel.BackgroundTransparency = 1
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextSize = 13
    msgLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextWrapped = true
    
    msgLabel.RichText = true
    msgLabel.Text = string.format("<b>%s</b>: %s", senderName, messageText)
    msgLabel.Parent = messageScroll
    
    task.defer(function()
        messageScroll.CanvasPosition = Vector2.new(0, messageScroll.AbsoluteCanvasSize.Y)
    end)
end

local textChannels = TextChatService:FindFirstChild("TextChannels")
if textChannels then
    local rbxGeneral = textChannels:FindFirstChild("RBXGeneral")
    if rbxGeneral then
        rbxGeneral.MessageReceived:Connect(function(textChatMessage)
            local sender = textChatMessage.TextSource
            local senderName = "Bilinmeyen"
            
            if sender then
                senderName = sender.Name
                local plr = Players:GetPlayerByUserId(sender.UserId)
                if plr then
                    senderName = plr.DisplayName or plr.Name
                end
            elseif textChatMessage.Metadata ~= "" then
                senderName = textChatMessage.Metadata
            end
            
            addMessage(senderName, textChatMessage.Text)
        end)
    end
end

local isOpen = false

pChatButton.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    
    if isOpen then
        chatPanel.Visible = true
        pChatButton.Text = ""
        messageScroll.CanvasPosition = Vector2.new(0, messageScroll.AbsoluteCanvasSize.Y)
    else
        chatPanel.Visible = false
        pChatButton.Text = ""
    end
end)
