
local guilib = loadstring(game:HttpGet("https://raw.githubusercontent.com/kiurgjirkgk/NightForRoblox/main/uilib.lua"))()
local executortext = "(Unknown Executor)"
if identifyexecutor() and 15 >= #identifyexecutor() then
    executortext = string.format("(%s)", identifyexecutor())
end 
guilib:Init({title = string.format("Night RBX%s ", executortext)})
local tabs = {
    Main = guilib:NewTab({name = "Main", icon = "rbxassetid://17873742976"}),
    player = guilib:NewTab({name = "Player", icon = "rbxassetid://17873721855"}),
}

local plrs = cloneref(game:GetService("Players"))
local lp = plrs.LocalPlayer
local rs = cloneref(game:GetService("RunService"))

local playrewardscontroller
local rewardinfo
local gotcontrollers = pcall(function()
    playrewardscontroller = require(game:GetService("ReplicatedStorage").Controllers.UI.PlaytimeRewardsController)
    rewardinfo = require(game:GetService("ReplicatedStorage").Common.PlaytimeRewardsInfo).Rewards
end)


local hitremote 
for i,v in next, game:GetDescendants() do
    if v and v.Name:find("\n") and v:IsA("RemoteEvent") then
        hitremote = v
        break
    end
end

if not hitremote then
    lp:Kick("Failed to find remote send this message in bug reports")
    return
end

getnearestball = function()
    local ball
    local dist = math.huge
    local istrain = true
    local ballpath = game:GetService("Workspace"):FindFirstChild("TrainingBalls")
    if lp.Character:IsDescendantOf(game:GetService("Workspace"):FindFirstChild("Alive")) then
        istrain = false
        ballpath = game:GetService("Workspace"):FindFirstChild("Balls")
    end
    for i,v in next, ballpath:GetChildren() do
        if v and v:IsA("Part") and v:GetAttribute("realBall") and v:GetAttribute("realBall") == true then
            local mag = lp:DistanceFromCharacter(v.Position)
            if dist > mag then
                ball = v
                dist = mag
            end
        end
    end
    if ball and ball.Position then
        return ball, dist, ball.Position, istrain
    end
    return ball, dist, nil, istrain
end

getballtarget = function()
    local ball, mag, pos = getnearestball()
    if ball and ball:GetAttribute("target") then
        return ball:GetAttribute("target")
    end
end

isballtargetingplr = function()
    local ball, mag, pos = getnearestball()
    if getballtarget() == lp.Name then
        return true
    end
    return false
end

getplrs = function()
    local plrss = {}
    for i,v in next, plrs:GetPlayers() do
        if v and v.Character and v.Character:IsDescendantOf(game:GetService("Workspace"):FindFirstChild("Alive")) then
            plrss[v.Name] = v.Character.PrimaryPart.Position + Vector3.new(10, 10, 10)
        end
    end
    return plrss
end

getcloseplr = function()
    local plr
    local dista = math.huge
    for i,v in next, plrs:GetPlayers() do
        if v and v ~= lp and v.Character and v.Character:IsDescendantOf(game:GetService("Workspace"):FindFirstChild("Alive")) and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 and v.Character.PrimaryPart then
            local dist = lp:DistanceFromCharacter(v.Character.PrimaryPart.Position)
            if dist < dista then
                dista = dist
                plr = v
            end
        end
    end
    return plr
end

getplrfromname = function(plr)
    return plrs:FindFirstChild(plr)
end


getmap = function()
    for i,v in next, game:GetService("Workspace"):FindFirstChild("Map"):GetChildren() do
        return v
    end
end

getfrom = function()
    for i,v in next, game:GetService("Workspace"):FindFirstChild("Balls"):GetChildren() do
        if v and v:GetAttribute("realBall") and v:GetAttribute("realBall") == true and v:GetAttribute("from") and v:GetAttribute("from") ~= lp.Name then
            return v:GetAttribute("from")
        end
    end
    return false
end

getfrom = function()
    local ball, mag, pos = getnearestball()
    if ball and ball:GetAttribute("realBall") and ball:GetAttribute("realBall") == true and ball:GetAttribute("from") and ball:GetAttribute("from") ~= lp.Name then
        return ball:GetAttribute("from")
    end
    return false
end

getplr = function(plrname)
    return game:GetService("Workspace"):FindFirstChild("Alive"):FindFirstChild(plrname)
end

getplrmag = function(plr)
    return (lp.Character.PrimaryPart.Position - plr.Position).Magnitude
end

checkplr = function(plr)
    if plr and plr.Character and plr.Character:FindFirstChildWhichIsA("Humanoid") and plr.Character:FindFirstChildWhichIsA("Humanoid").Health > 0 and plr.Character.PrimaryPart then
        if plr.Character:IsDescendantOf(game:GetService("Workspace"):FindFirstChild("Alive")) then
            return true
        end
    end
end

local cframes = {
    CFrame.new(-Random.new():NextNumber(200, 500), Random.new():NextNumber(0, 40), -Random.new():NextNumber(70, 120), -Random.new():NextNumber(0, 4), Random.new():NextNumber(0, 4), Random.new():NextNumber(0, 4), math.random(0, 4), Random.new():NextNumber(0, 4), Random.new():NextNumber(0, 4), Random.new():NextNumber(0, 4), Random.new():NextNumber(0, 4),Random.new():NextNumber(0, 4)),
    CFrame.new(-Random.new():NextNumber(200, 500), Random.new():NextNumber(0, 40), -Random.new():NextNumber(70, 120), -Random.new():NextNumber(0, 4), Random.new():NextNumber(0, 4), Random.new():NextNumber(0, 4), math.random(0, 4), Random.new():NextNumber(0, 4), -Random.new():NextNumber(0, 4), -Random.new():NextNumber(0, 4), -Random.new():NextNumber(0, 4),-Random.new():NextNumber(0, 4)),
    CFrame.new(-Random.new():NextNumber(200, 500), Random.new():NextNumber(0, 80), -Random.new():NextNumber(70, 120), -Random.new():NextNumber(0, 4), Random.new():NextNumber(0, 4), Random.new():NextNumber(0, 4), math.random(0, 4), Random.new():NextNumber(0, 4), -Random.new():NextNumber(0, 4), -Random.new():NextNumber(0, 4), -Random.new():NextNumber(0, 4),-Random.new():NextNumber(0, 4)),
    CFrame.new(-Random.new():NextNumber(200, 600), Random.new():NextNumber(0, 80), -Random.new():NextNumber(70, 120), -Random.new():NextNumber(0, 4), Random.new():NextNumber(0, 4), Random.new():NextNumber(0, 4), math.random(0, 4), Random.new():NextNumber(0, 4), Random.new():NextNumber(0, 4), Random.new():NextNumber(0, 4), Random.new():NextNumber(0, 4),Random.new():NextNumber(0, 4))
}

local canautoparry = false
local canautorapture = false
local canautospam = false
local canautocurve = false
local parrydist = 1.65
local oldparrydist = 1.65
local autospamspeed = 12
local parrycon = {}

startautoparry = function()
    spawn(function()
        local raptureremote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("PlrRaptured")
        local lasthit = tick()
        local reset = nil
        local spamnoti = true
        local canhit = true
        table.insert(parrycon, game:GetService("RunService").PreRender:Connect(function()
            if not canautoparry then
                for i,v in next, parrycon do
                    v:Disconnect()
                end
                table.clear(parrycon)
            end
            local ball, mag, ballpos, istraining = getnearestball()
            if ball and mag and ballpos and isballtargetingplr() then
                
                reset = true 
                local speed = ball.AssemblyLinearVelocity.Magnitude
                local speedy = ball.AssemblyLinearVelocity.Y
                local args = {
                    [1] = 0.5,
                    [2] = canautocurve and cframes[math.random(1, #cframes)] or CFrame.new(0,0,0),
                    [3] = getcloseplr() and {[tostring(getcloseplr().Name)] = getcloseplr().Character.PrimaryPart.Position} or getplrs(),
                    [4] = {
                        [1] = math.random(200, 500),
                        [2] = math.random(100, 200)
                    },
                    [5] = false
                }
                local magplr = 40
                if canautospam and canautoparry and not istraining then
                    local plrname = getfrom()
                    if plrname and getplr(plrname) and getplrmag(getplr(plrname).PrimaryPart) then 
                        magplr = getplrmag(getplr(plrname).PrimaryPart)
                    end
                    if tick() - lasthit < 0.35 or 24 >= magplr and canhit and speed >= 300 then
                        for i = 1, autospamspeed do
                            if 23.5 < mag and speed <= 210 then
                                task.wait(mag/170)
                            end
                            if spamnoti then
                                spamnoti = false
                                guilib:notify({
                                    title = "Auto Spam Trigger", 
                                    info = "Auto spam has been triggered!", 
                                    dur = 4
                                })
                                task.delay(8, function()
                                    spamnoti = true 
                                end)
                            end
                            for i = 1,autospamspeed do
                                hitremote:FireServer(unpack(args))
                                if not magplr or getplr(plrname):FindFirstChildWhichIsA("Humanoid").Health < 0.1 or  magplr >= 26 or 270 >= speed or tick() - lasthit > 0.85 or not lp.Character:IsDescendantOf(game:GetService("Workspace"):FindFirstChild("Alive")) or not canautoparry then
                                    break
                                end
                            end        
                        end
                    end
                end
                if canautorapture then
                    if (speed / mag) >= (parrydist - 0.05) then
                        raptureremote:FireServer(unpack(args))
                    end
                end
                speed -= 15
                if lp.Character:FindFirstChildWhichIsA("Humanoid") and lp.Character:FindFirstChildWhichIsA("Humanoid").MoveDirection ~= Vector3.zero then
                    speed -= 2.75
                end
                if (speed / mag) >= (parrydist) and speed > 50 or 25 > mag then
                    if canautoparry and canhit and speed > 0 then
                        if speedy > 30 and speed >= 280 then
                            task.wait(speedy/(speed/0.5))
                        end
                        canhit = false
                        hitremote:FireServer(unpack(args))
                        task.delay(2, function()
                            canhit = true
                        end)
                    end
                end
            else
                if reset then
                    canhit = true
                    if not isballtargetingplr() or not ball then
                        lasthit = tick()
                    end
                    reset = nil
                end
            end
        end))
    end)
end

local autoparry = tabs.Main:Toggle({
    name = "AutoParry",
    def = false, 
    button = false,
    callback = function(call) 
        canautoparry = call
        if canautoparry then
            startautoparry()
        else
            for i,v in next, parrycon do
                v:Disconnect()
            end
            table.clear(parrycon)
        end
    end
})
autoparry:Slider({
    name = "ParryDistance",
    min = 0,
    max = 5,
    def = parrydist,
    decimals = 2,
    callback = function(call)
        parrydist = tonumber(call)
        oldparrydist = tonumber(call)
    end
})
autoparry:Slider({
    name = "AutoSpamSpeed",
    min = 1,
    max = 15,
    def = autospamspeed,
    decimals = 0,
    callback = function(call)
        autospamspeed = tonumber(call)
    end
})
autoparry:MiniToggle({
    name = "AutoRapture",
    def = true,
    callback = function(call)
        canautorapture = call
    end
})
autoparry:MiniToggle({
    name = "AutoSpam",
    def = true,
    callback = function(call)
        canautospam = call
    end
})
autoparry:MiniToggle({
    name = "AutoCurve",
    def = true,
    callback = function(call)
        canautocurve = call
    end
})



spawn(function()
    local enabled = false
    local manualspamspeed = 8
    local manspamcons = {}
    local manspam = tabs.Main:Toggle({
        name = "ManualSpam",
        def = false, 
        button = false,
        callback = function(call) 
            enabled = call
            if enabled then
                table.insert(manspamcons, game:GetService("RunService").PreRender:Connect(function() 
                    for i = 1,manualspamspeed do
                        if not enabled then break end
                        local args = {
                            [1] = 0.5,
                            [2] = cframes[math.random(1, #cframes)],
                            [3] = getcloseplr() and {[tostring(getcloseplr().Name)] = getcloseplr().Character.PrimaryPart.Position} or getplrs(),
                            [4] = {
                                [1] = math.random(200, 500),
                                [2] = math.random(100, 200)
                            },
                            [5] = false
                        }
                        hitremote:FireServer(unpack(args))
                    end
                end))
            else
                for i,v in next, manspamcons do
                    v:Disconnect()
                end
                table.clear(manspamcons)
            end
        end
    })
    manspam:Slider({
        name = "SpamSpeed",
        min = 1,
        max = 15,
        def = manualspamspeed,
        decimals = 0,
        callback = function(call)
            manualspamspeed = tonumber(call)
        end
    })
end)

spawn(function()
    local cansentnoti = true
    repeat
        local old = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        task.wait(1)
        local new = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        local added = old - new
        if added < -110 and cansentnoti then
            local pingadded = tostring(math.round(added)):gsub("-", "")
            guilib:notify({
                title = "Ping Spike Detected", 
                info = string.format("A ping spike of %s may have been detected!", pingadded), 
                dur = 4
            })
            cansentnoti = false
            task.delay(6, function()
                cansentnoti = true
            end)
        end
    until not shared.nightrunning
end)


spawn(function()
    local enabled = false
    local automovecon = {}
    local targetplr
    tabs.Main:Toggle({
        name = "AutoPlay",
        def = false, 
        button = false,
        callback = function(call) 
            enabled = call
            if enabled then
                table.insert(automovecon, rs.PreRender:connect(function()
                    if getballtarget() and not isballtargetingplr() then
                        targetplr = getplrfromname(getballtarget())
                    else
                        if getfrom() and getfrom() ~= lp.Name then
                            targetplr = getplrfromname(getfrom())
                        end
                    end
                    if targetplr and checkplr(targetplr) then
                        if checkplr(lp) then
                            lp.Character:FindFirstChildWhichIsA("Humanoid"):MoveTo(targetplr.Character.PrimaryPart.Position + targetplr.Character.PrimaryPart.CFrame.LookVector * 24.5)
                            lp.Character:FindFirstChildWhichIsA("Humanoid"):MoveTo(targetplr.Character.PrimaryPart.Position + targetplr.Character.PrimaryPart.CFrame.LookVector * 20.5)
                            lp.Character:FindFirstChildWhichIsA("Humanoid"):MoveTo(targetplr.Character.PrimaryPart.Position + targetplr.Character.PrimaryPart.CFrame.LookVector * 25.5)
                        end
                    end
                end))
            else
                for i,v in next, automovecon do
                    v:Disconnect()
                end
                table.clear(automovecon)
                parrydist = oldparrydist
            end
        end
    })
end)


spawn(function()
    local antiafk = false
    local afkcon = {}
    tabs.player:Toggle({
        name = "AntiAfk",
        def = false, 
        button = false,
        callback = function(call) 
            antiafk = call
            if antiafk then
                table.insert(afkcon, lp.Idled:Connect(function()
                    if not antiafk then return end
                    if getconnections then
                        for i,v in next, getconnections(lp.Idled) do
                            v:Disable()
                        end
                    end
                    if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
                        lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end))
            else
                if getconnections then
                    for i,v in next, getconnections(lp.Idled) do
                        v:Enable()
                    end
                end
                for i,v in next, afkcon do
                    v:Disconnect()
                end
                table.clear(afkcon)
            end
        end
    })
end)

spawn(function()
    local canwalkspeed = false
    local walkspeedcon  = {}
    local walkspeedspped = 180
    local walkspeed = tabs.player:Toggle({
        name = "WalkSpeed",
        def = false, 
        button = false,
        callback = function(call) 
            canwalkspeed = call
            if canwalkspeed then
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
                    lp.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 50
                end
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
    local canautoexplode = false
    local canopensword = false
    local enabled = false
    local autocrate = tabs.player:Toggle({
        name = "AutoOpenCrate",
        def = false, 
        button = false,
        callback = function(call) 
            enabled = call
            if enabled then
                repeat
                    if canautoexplode then
                        game:GetService("ReplicatedStorage").Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", game:GetService("Workspace"):FindFirstChild("Spawn"):FindFirstChild("Crates"):FindFirstChild("NormalExplosionCrate"))
                    end
                    if canopensword then
                        game:GetService("ReplicatedStorage").Remote.RemoteFunction:InvokeServer("PromptPurchaseCrate", game:GetService("Workspace"):FindFirstChild("Spawn"):FindFirstChild("Crates"):FindFirstChild("NormalSwordCrate"))

                    end
                    task.wait(0.05)
                until not enabled
            end
        end
    })
    autocrate:MiniToggle({
        name = "Sword",
        def = true,
        callback = function(call)
            canopensword = call
        end
    })
    autocrate:MiniToggle({
        name = "Explosion",
        def = true,
        callback = function(call)
            canautoexplode = call
        end
    })
end)


spawn(function()
    local blatant = false
    local enabled = false
    local autodrops = tabs.player:Toggle({
        name = "AutoCollectDrops",
        def = false, 
        button = false,
        callback = function(call) 
            enabled = call
            if enabled then
                repeat
                    if getmap() then 
                        for i,v in next, getmap():GetChildren() do
                            if v.Name == "Drop" and v:IsA("Part") and v:FindFirstChildWhichIsA("TouchTransmitter") and lp.Character:IsDescendantOf(game:GetService("Workspace"):FindFirstChild("Alive")) then
                                if firetouchintrest and not blatant then
                                    firetouchintrest(lp.Character.PrimaryPart, v:FindFirstChildWhichIsA("TouchTransmitter"), 0)
                                    firetouchintrest(lp.Character.PrimaryPart, v:FindFirstChildWhichIsA("TouchTransmitter"), 1)
                                elseif blatant then
                                    lp.Character.PrimaryPart.CFrame = v.CFrame
                                    task.wait(0.3)
                                end
                            end
                        end
                    end
                    task.wait(0.05)
                until not enabled
            end
        end
    })
    autodrops:MiniToggle({
        name = "Blatant",
        def = false,
        callback = function(call)
            blatant = call
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
        for i,v in next, plrs:GetPlayers() do
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
        table.insert(nametagcons, plrs.ChildAdded:Connect(function(v)
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
    local enabled = false
    tabs.player:Toggle({
        name = "AutoCollectPlayRewards",
        def = false, 
        button = false, 
        callback = function(call)
            enabled = call
            if enabled then
                repeat
                    if not gotcontrollers then 
                        return guilib:notify({
                            title = "Error", 
                            info = "Failed to get playtime controllers!", 
                            dur = 8
                        })
                    end
                    for i,v in next, rewardinfo do
                        getupvalue(playrewardscontroller.Start, 7):InvokeServer(i)
                    end
                    task.wait(1)
                until not enabled
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
tabs.Main:Toggle({name = "Serverhop", def = false, button = true, callback = function(value) if value then serverhop()  end end})


serverhop = function()
    local req = http.request({Url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true"}).Body
    local encoded = game:GetService("HttpService"):JSONDecode(req)
    local jobids = {}
    for i,v in next, encoded.data do
        if v.id ~= game.JobId and v.maxPlayers > v.playing then
            table.insert(jobids, v.id)
        end
    end
    local randomserver = jobids[math.random(0, #jobids)]
    if randomserver then
        local queue = game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, randomserver)
        game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
            if State == Enum.TeleportState.Failed then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Telport failed",
                    Text = "Server Hop Teleport Failed Retrying",
                    Duration = 5
                })
                serverhop()
            end
        end)
    end
end
