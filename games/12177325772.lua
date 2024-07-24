
local guilib = loadstring(game:HttpGet("https://raw.githubusercontent.com/kiurgjirkgk/NightForRoblox/main/uilib.lua"))()
local executortext = "(Unknown Executor)"
if identifyexecutor() and 15 >= #identifyexecutor() then
    executortext = string.format("(%s)", identifyexecutor())
end 
guilib:Init({title = string.format("Night RBX%s", executortext)})

local tabs = {
    Main = guilib:NewTab({name = "Main", icon = "rbxassetid://17873742976"}),
    player = guilib:NewTab({name = "Player", icon = "rbxassetid://17873721855"}),
}

local pls = game:GetService("Players")
local teams = game:GetService("Teams")
local ws = game:GetService("Workspace")
local rs = game:GetService("RunService")
local rstorage = game:GetService("ReplicatedStorage")
local lp = pls.LocalPlayer

local map = ws.Map

local knit = require(rstorage.Whut.Packages._Index["sleitnick_knit@1.4.4"].knit.KnitClient)
local controllers = getupvalue(knit.Start, 5)
local controls = {
    anticheat = controllers.ACController,
    stamina = controllers.StaminaController
}

isplrhometeam = function(team)
    if teams:FindFirstChild(team) and teams:FindFirstChild(team):GetAttribute("isHomeTeam") then
        return true
    end
    return false
end

getplayerwithball = function()
    for i,v in next, pls:GetPlayers() do
        if v and v.Character and v.Character:FindFirstChildOfClass("Humanoid") and v.Character.PrimaryPart and v.Character:GetAttribute("HasBall") then
            return v
        end
    end
    return
end

getball = function(doesown)
    if ws:FindFirstChild("Gameball") and doesown or ws:FindFirstChild("Gameball") and not doesown and not ws:FindFirstChild("Gameball"):GetAttribute("OwnerName") then
        return ws:FindFirstChild("Gameball")
    end
    return
end

teleport = function(cf)
    controls.anticheat:SetValidatedLastCFrame(cf)
    lp.Character.PrimaryPart.CFrame = cf
end



local autoscoreenabled = false
local respawnball = false
spawn(function()
    local teamcheck = false
    local autoscore = tabs.Main:Toggle({
        name = "AutoScore",
        def = false,
        button = false,
        callback = function(call)
            autoscoreenabled = call
            repeat
                if not autoscoreenabled then break end
                if lp.Character.Parent == ws.Characters.Stadium and not lp.Character:GetAttribute("isGoalKeeper") then
                    local plrwithball = getplayerwithball()
                    local targetteam = isplrhometeam(lp.Team.Name) and map["Away Team"] or map["Home Team"]
                    local targetgoalspot = targetteam["Goal (Scaled)"].RootPart
                    if plrwithball then
                        if not teamcheck or teamcheck and plrwithball.Team ~= lp.Team then
                            teleport(plrwithball.Character.PrimaryPart.CFrame)
                            rstorage.RemoteEvents.Football.Tackle:FireServer()
                            task.wait(0.15)
                            if lp.Character:GetAttribute("HasBall") then
                                task.wait(0.1)
                                if targetgoalspot then
                                    if not respawnball then
                                        teleport(targetgoalspot.CFrame)
                                    end
                                    rstorage.RemoteEvents.Football.Shoot:FireServer()
                                end
                            end
                        end
                    elseif not plrwithball and getball(false) then
                        teleport(getball().CFrame)
                        task.wait(0.15)
                        if lp.Character:GetAttribute("HasBall") then
                            task.wait(0.1)
                            if targetgoalspot then
                                if not respawnball then
                                    teleport(targetgoalspot.CFrame)
                                end
                                rstorage.RemoteEvents.Football.Shoot:FireServer()
                            end
                        end
                    elseif lp.Character:GetAttribute("HasBall")  then
                        if targetgoalspot then
                            teleport(targetgoalspot.CFrame)
                            rstorage.RemoteEvents.Football.Shoot:FireServer()
                        end
                    end
                end
                task.wait(0.0001)
            until not autoscoreenabled
        end
    })
    autoscore:MiniToggle({
        name = "Teamcheck",
        def = true,
        callback = function(call)
            teamcheck = call
        end
    })
end)


spawn(function()
    tabs.Main:Toggle({
        name = "SpamRespawnBall",
        def = false,
        button = false,
        callback = function(call)
            respawnball = call
            repeat
                if not respawnball then break end
                if lp.Character.Parent == ws.Characters.Stadium and not lp.Character:GetAttribute("isGoalKeeper") then
                    local plrwithball = getplayerwithball()
                    if plrwithball then
                        if plrwithball.Team ~= lp.Team then
                            teleport(plrwithball.Character.PrimaryPart.CFrame)
                            rstorage.RemoteEvents.Football.Tackle:FireServer()
                            task.wait(0.15)
                            if lp.Character:GetAttribute("HasBall") then
                                task.wait(0.1)
                                rstorage.RemoteEvents.Football.Shoot:FireServer()
                            end
                        end
                    elseif not plrwithball and getball(false) then
                        teleport(getball().CFrame)
                        task.wait(0.15)
                        if lp.Character:GetAttribute("HasBall") then
                            task.wait(0.1)
                            rstorage.RemoteEvents.Football.Shoot:FireServer()
                        end
                    end
                end
                task.wait(0.0001)
            until not respawnball
        end
    })
end)

spawn(function()
    local old = controls.stamina.ConsumeStamina
    local enabled = false
    tabs.Main:Toggle({
        name = "InfStamina",
        def = false, 
        button = false,
        callback = function(call)
            enabled = call
            if enabled then 
                controls.stamina.ConsumeStamina = function(self, ...)
                    return old(self, 0)
                end
            else
                controls.stamina.ConsumeStamina = old
            end
        end
    })
end)

spawn(function()
    local enabled = false
    tabs.Main:Toggle({
        name = "AutoGoalKeeper",
        def = false, 
        button = false,
        callback = function(call)
            enabled = call
            if enabled then
                repeat
                    if not enabled then break end
                    if lp.Character:GetAttribute("isGoalKeeper") then
                        local plrball = getplayerwithball()
                        local normalball = getball(true)
                        if plrball then
                            local balldist = lp:DistanceFromCharacter(plrball.Character.Ball.Position)
                            if 28 > balldist then
                                teleport(plrball.Character.PrimaryPart.CFrame)
                                rstorage.RemoteEvents.Football.Tackle:FireServer()
                                task.wait(0.2)
                                if lp.Character:GetAttribute("HasBall") then
                                    rstorage.RemoteEvents.Football.Shoot:FireServer()
                                end
                            end
                        elseif not plrball and normalball then
                            local balldist = lp:DistanceFromCharacter(normalball.Position)
                            if 28 > balldist then
                                teleport(normalball.CFrame)
                                task.wait(0.2)
                                if lp.Character:GetAttribute("HasBall") then
                                    rstorage.RemoteEvents.Football.Shoot:FireServer()
                                end
                            end
                        end
                    end
                    task.wait(0.0001)
                until not enabled
            end
        end
    })
end)

spawn(function()
    local enabled = false
    tabs.Main:Toggle({
        name = "AutoTackle",
        def = false,
        button = false,
        callback = function(call)
            enabled = call
            if enabled then
                repeat
                    local plrwithball = getplayerwithball()
                    if plrwithball and plrwithball.Character and plrwithball.Character.PrimaryPart then
                        local dist = lp:DistanceFromCharacter(plrwithball.Character.PrimaryPart.Position)
                        if 12 > dist then
                            rstorage.RemoteEvents.Football.Shoot:FireServer()
                        end
                    end
                    task.wait(0.001)
                until not enabled
            end
        end
    })
end)

spawn(function()
    local canwalkspeed = false
    local walkspeedcon  = {}
    local old = controls.anticheat.DetermineWSpeed
    local walkspeedspped = 180
    local walkspeed = tabs.player:Toggle({
        name = "WalkSpeed",
        def = false, 
        button = false,
        callback = function(call) 
            canwalkspeed = call
            if canwalkspeed then
                controls.anticheat.DetermineWSpeed = function() return "oh noes!!!!" end
                if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
                    lp.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = walkspeedspped
                end
                table.insert(walkspeedcon, lp.characterAdded:connect(function()
                    task.wait(0.1)
                    if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
                        lp.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = walkspeedspped
                    end
                    table.insert(walkspeedcon, lp.Character:FindFirstChildOfClass("Humanoid"):GetPropertyChangedSignal("WalkSpeed"):connect(function()
                        task.wait(0.1)
                        if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
                            lp.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = walkspeedspped
                        end
                    end))
                end))
                table.insert(walkspeedcon, lp.Character:FindFirstChildOfClass("Humanoid"):GetPropertyChangedSignal("WalkSpeed"):connect(function()
                    task.wait(0.1)
                    if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
                        lp.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = walkspeedspped
                    end
                end))
            else
                for i,v in next, walkspeedcon do
                    v:Disconnect()
                end
                table.clear(walkspeedcon)
                if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
                    lp.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
                end
                controls.anticheat.DetermineWSpeed = old
            end
        end
    })
    walkspeed:Slider({
        name = "Speed",
        min = 0,
        max = 400,
        def = walkspeedspped,
        decimals = 0,
        callback = function(call)
            if canwalkspeed then
                if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
                    lp.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = call
                end
            end
            walkspeedspped = call
        end
    })
end)

spawn(function()
    local nametagcons = {}
    local nametags = {}
    nametagplr = function(v, user)
        nametags[v] = Instance.new("BillboardGui", v.Character.PrimaryPart)
        nametags[v].Size = UDim2.new(0, 320,0, 50)
        nametags[v].StudsOffset = Vector3.new(0, 3.2, 0)
        nametags[v].AlwaysOnTop = true
        nametags[v].ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local nametagframe = Instance.new("Frame", nametags[v])
        nametagframe.AnchorPoint = Vector2.new(0.5, 0.5)
        nametagframe.AutomaticSize = Enum.AutomaticSize.X
        nametagframe.BackgroundColor3 = Color3.fromRGB(0,0,0)
        nametagframe.BackgroundTransparency = 0.55
        nametagframe.Position = UDim2.new(0.5, 0, 0.5, 0)
        nametagframe.Size = UDim2.new(0, 0, 0, 23)
        Instance.new("UICorner", nametagframe)

        local layout = Instance.new("UIListLayout", nametagframe)
        layout.Padding = UDim.new(0, 1)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        local padding = Instance.new("UIPadding", nametagframe)
        padding.PaddingLeft = UDim.new(0, 4)
        padding.PaddingRight = UDim.new(0, 4)

        local health = Instance.new("Frame", nametagframe)
        health.AutomaticSize = Enum.AutomaticSize.X
        health.BackgroundTransparency = 1
        health.LayoutOrder = 1
        health.Size = UDim2.new(0, 0, 1, 0)
        
        local hearthealth = Instance.new("ImageLabel", health)
        hearthealth.AnchorPoint = Vector2.new(1, 0.5)
        hearthealth.BackgroundTransparency = 1
        hearthealth.LayoutOrder = 1
        hearthealth.Position = UDim2.new(1, 0, 0.5, 0)
        hearthealth.Size = UDim2.new(0, 20, 0, 20)
        hearthealth.Image = "rbxassetid://14595054463"
        hearthealth.ImageColor3 = Color3.fromRGB(250, 84, 99)

        local healthvalue = Instance.new("TextLabel", health)
        healthvalue.Font = Enum.Font.Gotham
        healthvalue.AutomaticSize = Enum.AutomaticSize.XY
        healthvalue.FontFace.Weight = Enum.FontWeight.Medium
        healthvalue.LineHeight = 1
        healthvalue.TextColor3 = Color3.fromRGB(250, 84, 99)
        healthvalue.MaxVisibleGraphemes = -1
        healthvalue.Text = v.Character:FindFirstChild("Humanoid").Health or "0"
        healthvalue.TextDirection = Enum.TextDirection.Auto
        healthvalue.TextSize = 14
        healthvalue.TextStrokeTransparency = 1
        healthvalue.TextXAlignment = Enum.TextXAlignment.Center
        healthvalue.TextYAlignment = Enum.TextYAlignment.Center
        healthvalue.BackgroundTransparency = 1
        healthvalue.Size = UDim2.new(0,0,1,0)

        local healthvaluepad = Instance.new("UIPadding", healthvalue)
        healthvaluepad.PaddingRight = UDim.new(0, 20)
        healthvaluepad.PaddingLeft = UDim.new(0, 2)

        local mag = Instance.new("Frame", nametagframe)
        mag.AutomaticSize = Enum.AutomaticSize.X
        mag.BackgroundTransparency = 1
        mag.LayoutOrder = 3
        mag.Size = UDim2.new(0,0,1,0)

        local magvalue = Instance.new("TextLabel", mag)
        magvalue.AutomaticSize = Enum.AutomaticSize.X
        magvalue.BackgroundTransparency = 1
        magvalue.Size = UDim2.new(0,0,1,0)
        magvalue.Font = Enum.Font.Gotham
        magvalue.FontFace.Weight = Enum.FontWeight.Medium
        magvalue.TextColor3 = Color3.fromRGB(170, 167, 174)
        magvalue.TextSize = 14
        magvalue.LineHeight = 1
        magvalue.MaxVisibleGraphemes = -1
        magvalue.TextStrokeTransparency = 1
        magvalue.Text = math.round(tonumber(lp:DistanceFromCharacter(v.Character.PrimaryPart.Position))).."m" or "nil"
        
        local magpad = Instance.new("UIPadding", magvalue)
        magpad.PaddingLeft = UDim.new(0,2)

        local player = Instance.new("Frame", nametagframe)
        player.AutomaticSize = Enum.AutomaticSize.X
        player.BackgroundTransparency = 1
        player.LayoutOrder = 2
        player.Size = UDim2.new(0, 0, 1, 0)

        local playername = Instance.new("TextLabel", player)
        playername.AutomaticSize = Enum.AutomaticSize.X
        playername.BackgroundTransparency = 1
        playername.Size = UDim2.new(0,0,1,0)
        playername.Font = Enum.Font.Gotham
        playername.FontFace.Weight = Enum.FontWeight.Medium
        playername.TextColor3 = Color3.fromRGB(255, 255, 255)
        playername.TextSize = 14
        playername.LineHeight = 1
        playername.MaxVisibleGraphemes = -1
        playername.TextStrokeTransparency = 1
        playername.Text = user

        local plrnamepad = Instance.new("UIPadding")
        plrnamepad.PaddingLeft = UDim.new(0,7)
        plrnamepad.PaddingRight = UDim.new(0,7)

        table.insert(nametagcons, rs.Heartbeat:Connect(function()
            pcall(function()
                if not v then return end
                healthvalue.Text = v.Character:FindFirstChild("Humanoid").Health or "0"
                magvalue.Text = math.round(tonumber(lp:DistanceFromCharacter(v.Character.PrimaryPart.Position))).."m" or "nil"
            end)
        end))
    end

    local nametagmode = "DisplayName"
    starttag = function()
        for i,v in next, pls:GetPlayers() do
            if v and v ~= lp and v.Character and v.Character.PrimaryPart and v.Character:FindFirstChild("Humanoid") then
                if nametagmode == "DisplayName" then 
                    nametagplr(v, v.DisplayName)
                else
                    nametagplr(v, v.Name)
                end
                table.insert(nametagcons, v.CharacterAdded:Connect(function()
                    repeat task.wait() until v and v.Character and v.Character.PrimaryPart and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Humanoid").Health
                    if nametagmode == "DisplayName" then 
                        nametagplr(v, v.DisplayName)
                    else
                        nametagplr(v, v.Name)
                    end
                end))
            end
        end
        table.insert(nametagcons, pls.ChildAdded:Connect(function(v)
            spawn(function()
                repeat task.wait() until v and v.Character and v.Character.PrimaryPart and v.Character:FindFirstChild("Humanoid") or not v
                if nametagmode == "DisplayName" then 
                    nametagplr(v, v.DisplayName)
                else
                    nametagplr(v, v.Name)
                end
                v.CharacterAdded:Connect(function()
                    repeat task.wait() until v and v.Character and v.Character.PrimaryPart and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Humanoid").Health
                    if nametagmode == "DisplayName" then 
                        nametagplr(v, v.DisplayName)
                    else
                        nametagplr(v, v.Name)
                    end
                end)
            end)
        end))
    end

    local enabled = false
    local nametags = tabs.player:Toggle({
        name = "NameTags",
        def = false, 
        button = false,
        callback = function(call) 
            enabled = call
            if enabled then
                starttag()
            else
                for i,v in next, nametags do
                    v:Destroy()
                end
                for i,v in next, nametagcons do
                    v:Disconnect()
                end
                table.clear(nametags)
                table.clear(nametagcons)
            end
        end
    })
    nametags:Dropdown({
        name = "Mode", 
        options = {"DisplayName", "UserName"}, 
        def = nametagmode, 
        callback = function(call) 
            nametagmode = call
            for i,v in next, nametags do
                v:Destroy()
            end
            for i,v in next, nametagcons do
                v:Disconnect()
            end
            table.clear(nametags)
            table.clear(nametagcons)
            if enabled then
                starttag()
            end
        end
    })
end)

spawn(function()
    tabs.Main:Toggle({
        name = "HUD", 
        def = false, 
        button = true, 
        callback = function(value)
            if value then
                guilib:togglegui()
            end
        end,
        keybindcallback = function(keybind)
            shared.togglekey = nil
        end
    })
end)

spawn(function()
    tabs.Main:Toggle({
        name = "Uninject", 
        def = false, 
        button = true, 
        callback = function(value)
            if value then
                guilib:uninject()
            end
        end
    })
end)
