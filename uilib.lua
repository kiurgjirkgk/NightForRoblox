local canload = true
local past = {}
local suc, err = pcall(function()
    local requiredfuncs = {
        http.request,
        cloneref,
        clonefunction,
        isfile,
        readfile,
        writefile,
        makefolder,
        isfolder
    }
    for i,v in next, requiredfuncs do
        if v then 
            table.insert(past, v)
        else
            canload = false
        end
    end
end)

if #past ~= 8 then
    canload = false
end

if not canload or err then print("not supported") return end

local guilib = {}
shared.night = guilib

local ts = cloneref(game:GetService("TweenService"))
local https = cloneref(game:GetService("HttpService"))
local fullyuninjected = false

local guilib = setmetatable({}, {
    __index = function(grr, monkey)
        grr[monkey] = guilib
        return grr[monkey]
    end
})


if not isfolder("Night") then
    makefolder("Night")
end
if not isfolder("Night/Config") then
    makefolder("Night/Config")
end

local rootid = game.PlaceId
pcall(function()
    local req 
    req = http.request({
        Url = "https://games.roblox.com/v1/games?universeIds="..tostring(game.GameId),
        Method = "GET"
    }).Body
    rootid = https:JSONDecode(req).data[1].rootPlaceId
end)
if not isfolder("Night/Config/"..rootid) then
    makefolder("Night/Config/"..rootid)
end


function smoothdrag(ui)
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        ts:Create(ui, TweenInfo.new(0.6), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
    end

    ui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = ui.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    ui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    cloneref(game:GetService("RunService")):BindToRenderStep("Drag", Enum.RenderPriority.Input.Value, function()
        if dragging then
            update(dragInput)
        end
    end)
end

if shared.nightrunning then
    print("night running")
    return
end
shared.nightrunning = true


local setgui = clonefunction(gethui) or function() return cloneref(game:GetService("Players")).LocalPlayer:FindFirstChildOfClass("PlayerGui") end
local Notifications = Instance.new("ScreenGui")
Notifications.ResetOnSpawn = false      
Notifications.Parent = setgui()

local maingui = Instance.new("ScreenGui")
maingui.Parent = setgui()

local tabs
local Core
function guilib:Init(args)
    local Title = args.title or "night"

    tabs = Instance.new("Frame")
    tabs.Parent = maingui
    tabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tabs.BackgroundTransparency = 1.000
    tabs.Size = UDim2.new(0, 1917, 0, 809)
    
    Core = Instance.new("Frame")
    Core.Parent = tabs
    Core.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Core.Position = UDim2.new(0.00730307773, 0, 0.0160692204, 0)
    Core.Size = UDim2.new(0, 240, 0, 430)
    smoothdrag(Core)
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = Core

    local titl = Instance.new("TextLabel")
    titl.Parent = Core
    titl.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    titl.BackgroundTransparency = 1.000
    titl.Position = UDim2.new(0.0957137495, 0, 0.0334538594, 0)
    titl.Size = UDim2.new(0, 97, 0, 17)
    titl.Font = Enum.Font.GothamBold
    titl.Text = Title
    titl.TextColor3 = Color3.fromRGB(229, 229, 229)
    titl.TextSize = 14.000
    titl.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    titl.TextXAlignment = Enum.TextXAlignment.Left
end

shared.togglekey = Enum.KeyCode.V

function guilib:togglegui()
    maingui.Enabled = not maingui.Enabled
end

local toggleguicon = {}

local togglebutton = Instance.new("ScreenGui", setgui())
togglebutton.ResetOnSpawn = false

local toggleframe = Instance.new("ImageButton", togglebutton)
toggleframe.Position = UDim2.new(0, 0, 0.4, 0)
toggleframe.Size = UDim2.new(0.03, 0, 0.03, 0)
toggleframe.ImageTransparency = 1
toggleframe.BackgroundColor3 = Color3.fromRGB(163, 162, 165)

if cloneref(game:GetService("UserInputService")).KeyboardEnabled then
    if togglebutton then
        togglebutton:Destroy()
    end
end

if togglebutton then
    table.insert(toggleguicon, toggleframe.MouseButton1Click:Connect(function()
        guilib:togglegui()
    end))
end

table.insert(toggleguicon, cloneref(game:GetService("UserInputService")).InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
    if input.KeyCode == shared.togglekey and maingui then
        maingui.Enabled = not maingui.Enabled
    end
end))

local Uninjected = false
function guilib:uninject()
    Uninjected = true
    task.wait(0.4)
    guilib = nil
    if togglebutton then
        togglebutton:Destroy()
    end
    for i,v in next, toggleguicon do
        v:Disconnect()
    end
    table.clear(toggleguicon)
    maingui:Destroy()
    Notifications:Destroy()
    shared.nightrunning = false
    shared.night = nil
    fullyuninjected = true
end


local mostbut = Instance.new("Frame")
local UIListLayout2 = Instance.new("UIListLayout")
local tabcount = 0
local firsttab = nil

function guilib:Divider(args)
    local Text = args.text or "Divider"
    local div = Instance.new("TextLabel")
    div.Parent = mostbut
    div.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    div.BackgroundTransparency = 1.000
    div.Position = UDim2.new(0.0957137495, 0, 0.782316327, 0)
    div.Size = UDim2.new(0, 97, 0, 17)
    div.Font = Enum.Font.GothamBold
    div.Text = Text
    div.TextColor3 = Color3.fromRGB(90, 90, 90)
    div.TextSize = 14.000
    div.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    div.TextXAlignment = Enum.TextXAlignment.Left
end  

function guilib:notify(args5)
    local title = args5.title
    local info = args5.info
    local dur = args5.dur
    spawn(function()
        for i,v in next, Notifications:GetChildren() do
            spawn(function()
                local newpos = (v.Position - UDim2.new(0, 0, 0.1, 0))
                ts:Create(v, TweenInfo.new(0.21), {Position = newpos}):Play()
            end)
        end
            local tween
            local Frame = Instance.new("Frame")
            local UICorner = Instance.new("UICorner")
            local Frame_2 = Instance.new("Frame")
            local UICorner_2 = Instance.new("UICorner")
            local Frame_3 = Instance.new("Frame")
            local UICorner_3 = Instance.new("UICorner")
            local Frame_4 = Instance.new("Frame")
            local Frame_5 = Instance.new("Frame")
            local TextLabel = Instance.new("TextLabel")
            local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
            local ImageLabel = Instance.new("ImageLabel")
            local TextLabel_2 = Instance.new("TextLabel")
            local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")
            local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")


            Frame.Parent = Notifications
            Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            Frame.Position = UDim2.new(1.778241336, 0, 0.896547914, 0)
            ts:Create(Frame, TweenInfo.new(0.19), {Position = UDim2.new(0.778241336, 0, 0.896547914, 0)}):Play()
            Frame.Size = UDim2.new(0.213414624, 0, 0.0828220844, 0)

            UICorner.CornerRadius = UDim.new(0, 12)
            UICorner.Parent = Frame

            Frame_2.Parent = Frame
            Frame_2.BackgroundColor3 = Color3.fromRGB(223, 79, 81)
            Frame_2.Size = UDim2.new(0.203007549, 0, 1, 0)

            UICorner_2.CornerRadius = UDim.new(0, 12)
            UICorner_2.Parent = Frame_2

            Frame_3.Parent = Frame
            Frame_3.BackgroundColor3 = Color3.fromRGB(223, 79, 81)
            Frame_3.Size = UDim2.new(0.206766948, 0, 1, 0)

            UICorner_3.CornerRadius = UDim.new(0, 12)
            UICorner_3.Parent = Frame_3

            Frame_4.Parent = Frame
            Frame_4.BackgroundColor3 = Color3.fromRGB(223, 79, 81)
            Frame_4.BorderSizePixel = 0
            Frame_4.Position = UDim2.new(0.0526315793, 0, 0, 0)
            Frame_4.Size = UDim2.new(0.165413558, 0, 1, 0)

            Frame_5.Parent = Frame
            Frame_5.BackgroundColor3 = Color3.fromRGB(47, 47, 47)
            Frame_5.BorderSizePixel = 0
            Frame_5.Position = UDim2.new(0.218045115, 0, 0, 0)
            Frame_5.Size = UDim2.new(0.00375939882, 0, 1, 0)

            TextLabel.Parent = Frame
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.BackgroundTransparency = 1.000
            TextLabel.Position = UDim2.new(0.258926839, 0, 0.220370382, 0)
            TextLabel.Size = UDim2.new(0.469924867, 0, 0.314814806, 0)
            TextLabel.Font = Enum.Font.GothamBold
            TextLabel.Text = title
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextScaled = true
            TextLabel.TextSize = 14.000
            TextLabel.TextWrapped = true
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left

            UITextSizeConstraint.Parent = TextLabel
            UITextSizeConstraint.MaxTextSize = 16

            ImageLabel.Parent = Frame
            ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ImageLabel.BackgroundTransparency = 1.000
            ImageLabel.Position = UDim2.new(0.0700000003, 0, 0.310000002, 0)
            ImageLabel.Size = UDim2.new(0, 20, 0, 20)
            ImageLabel.Image = "rbxassetid://12129389221"

            TextLabel_2.Parent = Frame
            TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel_2.BackgroundTransparency = 1.000
            TextLabel_2.LayoutOrder = 1
            TextLabel_2.Position = UDim2.new(0.25653857, 0, 0.524666131, 0)
            TextLabel_2.Size = UDim2.new(0.616541445, 0, 0.222222224, 0)
            TextLabel_2.Font = Enum.Font.GothamMedium
            TextLabel_2.Text = info
            TextLabel_2.TextColor3 = Color3.fromRGB(124, 124, 124)
            TextLabel_2.TextScaled = true
            TextLabel_2.TextSize = 14.000
            TextLabel_2.TextWrapped = true
            TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left

            UITextSizeConstraint_2.Parent = TextLabel_2
            UITextSizeConstraint_2.MaxTextSize = 12

            UIAspectRatioConstraint.Parent = Frame
            UIAspectRatioConstraint.AspectRatio = 4.926
            task.wait(0.12)
            task.wait(dur)
            tween = ts:Create(Frame, TweenInfo.new(0.4), {Position = UDim2.new(1.778241336, 0, 0.896547914, 0)})
            tween:Play()
            tween.Completed:Wait()
            Frame:Destroy()
        end)
    end

function guilib:NewTab(args)
    local Name = args.name or "Tab"
    local Icon = args.icon or nil
    tabcount = tabcount + 1
    
    mostbut.Name = "mostbut"
    mostbut.Parent = Core
    mostbut.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    mostbut.BackgroundTransparency = 1.000
    mostbut.Position = UDim2.new(0, 0, 0.101952277, 0)
    mostbut.Size = UDim2.new(0, 240, 0, 414)

    UIListLayout2.Parent = mostbut
    UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout2.Padding = UDim.new(0, 13)

    local ButtonHolder = Instance.new("Frame")
    ButtonHolder.Name = "ButtonHolderHolder"
    ButtonHolder.Parent = mostbut
    ButtonHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ButtonHolder.Position = UDim2.new(0.0625, 0, 0, 0)
    ButtonHolder.Size = UDim2.new(0, 209, 0, 45)
    if firsttab == nil then
        firsttab = Instance.new("BoolValue", ButtonHolder)
        firsttab.Name = "firsttab"
        firsttab.Value = true
    else
        firsttab = Instance.new("BoolValue", ButtonHolder)
        firsttab.Name = "firsttab"
        firsttab.Value = false
    end

    local stroke = Instance.new("UIStroke", ButtonHolder)
    stroke.Color = Color3.fromRGB(45,45,45)
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local UICorner_3 = Instance.new("UICorner")
    UICorner_3.CornerRadius = UDim.new(0, 12)
    UICorner_3.Parent = ButtonHolder

    local TextLabel_2 = Instance.new("TextLabel")
    TextLabel_2.Parent = ButtonHolder
    TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel_2.BackgroundTransparency = 1.000
    TextLabel_2.Position = UDim2.new(0.224880382, 0, 0.311111122, 0)
    TextLabel_2.Size = UDim2.new(0, 143, 0, 17)
    TextLabel_2.Font = Enum.Font.GothamBold
    TextLabel_2.Text = Name
    TextLabel_2.TextColor3 = Color3.fromRGB(66,66,66)
    TextLabel_2.TextSize = 14.000
    TextLabel_2.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left

    local Icon_2
    if Icon ~= nil and Icon ~= 0 then
        Icon_2 = Instance.new("ImageLabel")
        Icon_2.Name = "Icon"
        Icon_2.Parent = ButtonHolder
        Icon_2.BackgroundTransparency = 1.000
        Icon_2.ImageColor3 = Color3.fromRGB(66,66,66)
        Icon_2.Position = UDim2.new(0.0909090936, 0, 0.266666681, 0)
        Icon_2.Size = UDim2.new(0, 20, 0, 20)
        Icon_2.Image = Icon

        local UIAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")
        UIAspectRatioConstraint_2.Parent = Icon_2
    end
    local Toggle_2 = Instance.new("TextButton")
    Toggle_2.Name = "Toggle"
    Toggle_2.Parent = ButtonHolder
    Toggle_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Toggle_2.BackgroundTransparency = 1.000
    Toggle_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Toggle_2.BorderSizePixel = 0
    Toggle_2.Size = UDim2.new(0.995215297, 0, 1, 0)
    Toggle_2.ZIndex = 2
    Toggle_2.Font = Enum.Font.SourceSans
    Toggle_2.Text = ""
    Toggle_2.TextColor3 = Color3.fromRGB(0, 0, 0)
    Toggle_2.TextSize = 14.000

    local UIGradient_2 = Instance.new("UIGradient")
    UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(27, 28, 28)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(101, 62, 62))}  
    UIGradient_2.Offset = Vector2.new(0.78564592, -0.344444454)
    UIGradient_2.Rotation = -71.56504821777344
    UIGradient_2.Parent = ButtonHolder

    local uistroke = Instance.new("UIStroke")
    uistroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    uistroke.Color = Color3.fromRGB(255, 255, 255)
    uistroke.LineJoinMode = Enum.LineJoinMode.Round
    uistroke.Thickness = 1
    uistroke.Transparency = 0
    uistroke.Enabled = true

    local page1 = Instance.new("Frame")
    page1.Parent = tabs
    page1.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    page1.BackgroundTransparency = 1
    if firsttab and ButtonHolder:FindFirstChild("firsttab").Value == true then
        page1.Position = UDim2.new(0, (tabcount)*265+(tabcount-1)*280, 0.0160692204, 0)
    elseif tabcount == 2 then
        page1.Position = UDim2.new(0, (tabcount)*115+(tabcount-1)*280, 0.0160692204, 0)
    elseif tabcount == 3 then
        page1.Position = UDim2.new(0, (tabcount)*65+(tabcount-1)*280, 0.0160692204, 0)
    elseif tabcount == 4 then
        page1.Position = UDim2.new(0, (tabcount)*40+(tabcount-1)*280, 0.0160692204, 0)
    elseif tabcount == 5 then
        page1.Position = UDim2.new(0, (tabcount)*25+(tabcount-1)*280, 0.0160692204, 0)
    end
    page1.Size = UDim2.new(0, 240, 0, 520)
    page1.Visible = false

    local actualtab = Instance.new("ScrollingFrame")
    actualtab.Name = "Tab 2"
    actualtab.Parent = page1
    actualtab.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    actualtab.Size = UDim2.new(0, 240, 0, 520)
    actualtab.Visible = false
    actualtab.ScrollBarThickness = 0.1
    actualtab.BackgroundTransparency = 1
    actualtab.BorderSizePixel = 0
    actualtab.Position = UDim2.new(0, 0, 0, 0)
    actualtab.CanvasSize = UDim2.new(0,0,0,0)

    smoothdrag(page1)
    local UICorner_6 = Instance.new("UICorner")
    UICorner_6.CornerRadius = UDim.new(0, 15)
    UICorner_6.Parent = page1

    local tabname = Instance.new("TextLabel")
    tabname.Parent = actualtab
    tabname.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tabname.BackgroundTransparency = 1.000
    tabname.Position = UDim2.new(0.0998804197, 0, 0.0181635364, 0)
    tabname.TextTransparency = 1
    tabname.Size = UDim2.new(0, 97, 0, 17)
    tabname.Font = Enum.Font.GothamBold
    tabname.Text = Name
    tabname.TextColor3 = Color3.fromRGB(229, 229, 229)
    tabname.TextSize = 14.000
    tabname.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    tabname.TextXAlignment = Enum.TextXAlignment.Left

    local LOL = Instance.new("ScrollingFrame")
    LOL.Name = "LOL"
    LOL.Parent = actualtab
    LOL.Active = true
    LOL.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LOL.BackgroundTransparency = 1.000
    LOL.BorderColor3 = Color3.fromRGB(0, 0, 0)
    LOL.BorderSizePixel = 0
    LOL.Position = UDim2.new(0, 0, 0.0820692182, -7)
    LOL.Size = UDim2.new(0, 240, 0, 480)
    LOL.ScrollBarThickness = 0

    local UIListLayout_4 = Instance.new("UIListLayout")
    UIListLayout_4.Parent = LOL
    UIListLayout_4.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_4.Padding = UDim.new(0, 9)

    LOL.CanvasSize = UDim2.new(0,0,0,UIListLayout_4.AbsoluteContentSize.Y + 52)
    LOL.ChildAdded:Connect(function()
       LOL.CanvasSize = UDim2.new(0,0,0,UIListLayout_4.AbsoluteContentSize.Y + 52)
    end) 

    Toggle_2.MouseButton1Click:Connect(function()
        if actualtab.Visible == false then
            local tween = ts:Create(UIGradient_2, TweenInfo.new(0.7), {Offset = Vector2.new(0.486, -0.344444)})
            tween:Play()
            page1.Visible = true
            actualtab.Visible = true
            if Icon_2 then
                ts:Create(Icon_2, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(229, 229, 229)}):Play()
            end
            ts:Create(TextLabel_2, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(229, 229, 229)}):Play()
            ts:Create(page1, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
            for i,v in next, actualtab:GetDescendants() do
                if v:IsA("TextLabel") then
                    ts:Create(v, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
                elseif v:IsA("Frame") and v.Name ~= "Contain" and v.Name ~= "Container" or v:IsA("ImageButton") and v.Name ~= "Options" and v.Name ~= "autism" and v.Name ~= "DropDownButton" or v:IsA("ImageLabel") then
                    ts:Create(v, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
                end
            end
        else
            local tween2 = ts:Create(UIGradient_2, TweenInfo.new(0.7), {Offset = Vector2.new(0.7486, -0.344444)})
            tween2:Play()
            if Icon_2 then
                ts:Create(Icon_2, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(66, 66, 66)}):Play()
            end
            ts:Create(TextLabel_2, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(66, 66, 66)}):Play()
            ts:Create(page1, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            for i,v in next, actualtab:GetDescendants() do
                if v:IsA("TextLabel") then
                    ts:Create(v, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
                elseif v:IsA("Frame") or v:IsA("ImageButton") or v:IsA("ImageLabel") then
                    ts:Create(v, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                end
            end
            wait(0.1)
            page1.Visible = false
            actualtab.Visible = false
        end
    end)

    local elemets = {}
    function elemets:Toggle(args)
        local Name = args.name
        local default = args.def or false
        local disable = args.button or false
        local call = args.callback
        local keybindcall = args.keybindcallback or function() end

        local toggle = Instance.new("Frame")
        toggle.Name = "Enabled"
        toggle.Parent = LOL
        toggle.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
        toggle.Position = UDim2.new(0.00416666688, 0, 0.123569794, 0)
        toggle.Size = UDim2.new(0, 207, 0, 45)

        local stroke = Instance.new("UIStroke", toggle)
        stroke.Color = Color3.fromRGB(45,45,45)
        stroke.Thickness = 1
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border    

        local TextLabel_8 = Instance.new("TextLabel")
        TextLabel_8.Parent = toggle
        TextLabel_8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel_8.BackgroundTransparency = 1.000
        TextLabel_8.Position = UDim2.new(0.0904265344, 0, 0.311111122, 0)
        TextLabel_8.Size = UDim2.new(0, 111, 0, 18)
        TextLabel_8.Font = Enum.Font.GothamBold
        TextLabel_8.Text = Name
        TextLabel_8.TextColor3 = Color3.fromRGB(229, 229, 229)
        TextLabel_8.TextSize = 14.000
        TextLabel_8.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel_8.TextXAlignment = Enum.TextXAlignment.Left

        local UICorner_13 = Instance.new("UICorner")
        UICorner_13.Parent = toggle

        local Options_3 = Instance.new("ImageButton")
        Options_3.Name = "Options"
        Options_3.Parent = toggle
        Options_3.BackgroundTransparency = 1.000
        Options_3.BorderSizePixel = 0
        Options_3.Visible = false
        Options_3.Position = UDim2.new(0.85, 0, 0.288888901, 0)
        Options_3.Size = UDim2.new(0, 20, 0, 20)
        Options_3.Image = "http://www.roblox.com/asset/?id=6031104648"
        Options_3.ImageColor3 = Color3.fromRGB(163, 162, 165)
        Options_3.ZIndex = 3

        local KeyBind_2 = Instance.new("Frame")
        KeyBind_2.Name = "KeyBind"
        KeyBind_2.Parent = toggle
        KeyBind_2.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
        KeyBind_2.Position = UDim2.new(0.85, 0, 0.288888901, 0)
        KeyBind_2.Size = UDim2.new(0, 18, 0, 18)

        local UICorner_14 = Instance.new("UICorner")
        UICorner_14.CornerRadius = UDim.new(0, 5)
        UICorner_14.Parent = KeyBind_2

        local TextBox_2 = Instance.new("TextBox")
        TextBox_2.Parent = KeyBind_2
        TextBox_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextBox_2.BackgroundTransparency = 1.000
        TextBox_2.Size = UDim2.new(0, 18, 0, 18)
        TextBox_2.Font = Enum.Font.GothamBold
        TextBox_2.PlaceholderText = "?"
        TextBox_2.Text = ""
        TextBox_2.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextBox_2.TextSize = 10.000
        TextBox_2.ZIndex = 3
        TextBox_2.Position = UDim2.new(-0.02, 0, 0.00999999978, 0)

        local Toggle_7 = Instance.new("TextButton")
        Toggle_7.Name = "Toggle"
        Toggle_7.Parent = toggle
        Toggle_7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Toggle_7.BackgroundTransparency = 1.000
        Toggle_7.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Toggle_7.BorderSizePixel = 0
        Toggle_7.Size = UDim2.new(0.995215297, 0, 1, 0)
        Toggle_7.ZIndex = 2
        Toggle_7.Font = Enum.Font.SourceSans
        Toggle_7.Text = ""
        Toggle_7.TextColor3 = Color3.fromRGB(0, 0, 0)
        Toggle_7.TextSize = 14.000
        Toggle_7.AutoButtonColor = false


        local Options = Instance.new("Frame")

        Options.Name = "Options"
        Options.Parent = LOL
        Options.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
        Options.Position = UDim2.new(0.0687500015, 0, 0.0206896551, 0)
        Options.Size = UDim2.new(0, 207, 0, 0)
        Options.Visible = false
        Options.AutomaticSize = Enum.AutomaticSize.Y

        local stroke = Instance.new("UIStroke", Options)
        stroke.Color = Color3.fromRGB(45,45,45)
        stroke.Thickness = 1
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border    

        local UICorner = Instance.new("UICorner")
        UICorner.Parent = Options


        local Contain_2 = Instance.new("ScrollingFrame")
        Contain_2.Name = "Contain"
        Contain_2.Parent = Options
        Contain_2.Active = true
        Contain_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Contain_2.BackgroundTransparency = 10.000
        Contain_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Contain_2.BorderSizePixel = 0
        Contain_2.Position = UDim2.new(0.0360933021, 0, 0.1211705941, 0)
        Contain_2.Size = UDim2.new(0, 199, 0, 0)
        Contain_2.ScrollBarThickness = 0
        Contain_2.AutomaticSize = Enum.AutomaticSize.Y


        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Parent = Contain_2
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 8)
                
        function setconfigtoggle()
            if not isfolder(string.format("Night/Config/%s/toggles", rootid)) then
                makefolder(string.format("Night/Config/%s/toggles", rootid))
            end
            if not isfolder(string.format("Night/Config/%s/keybinds", rootid)) then
                makefolder(string.format("Night/Config/%s/keybinds", rootid))
            end
        end

        local toggled = false
        if isfile(string.format("Night/Config/%s/toggles/%s.lua", rootid, Name)) then
            if readfile(string.format("Night/Config/%s/toggles/%s.lua", rootid, Name)) == "true" then
                call(true)
                toggled = true
                ts:Create(toggle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 101, 104)}):Play()
                ts:Create(TextLabel_8, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(27, 27, 27)}):Play()
                ts:Create(Options_3, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(27, 27, 27)}):Play()
            end
        elseif default and not isfile(string.format("Night/Config/%s/toggles/%s.lua", rootid, Name)) then
            call(true)
            toggled = true
            ts:Create(toggle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 101, 104)}):Play()
            ts:Create(TextLabel_8, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(27, 27, 27)}):Play()
            ts:Create(Options_3, TweenInfo.new(0.3), {BackgroundImageColor3Color3 = Color3.fromRGB(27, 27, 27)}):Play()
        end


        Toggle_7.MouseButton1Click:Connect(function()
            toggled = not toggled
            if toggled and not disable then
                ts:Create(toggle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 101, 104)}):Play()
                ts:Create(TextLabel_8, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(27, 27, 27)}):Play()
                ts:Create(Options_3, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(27, 27, 27)}):Play()
            else
                ts:Create(toggle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(27, 27, 27)}):Play()
                ts:Create(TextLabel_8, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(229, 229, 229)}):Play()
                ts:Create(Options_3, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(163, 162, 165)}):Play()
            end
            call(toggled)
            setconfigtoggle()
            if disable then
                toggled = false
                call(toggled)
            else
                writefile(string.format("Night/Config/%s/toggles/%s.lua", rootid, Name), tostring(toggled))
            end
        end)
        
        spawn(function()
            repeat
                if Uninjected then
                    call(false)
                end
                task.wait()
            until fullyuninjected
        end)


    
        local file = isfile(string.format("Night/Config/%s/keybinds/%s.lua", rootid, Name)) and readfile(string.format("Night/Config/%s/keybinds/%s.lua", rootid, Name))
        local bind = ""
        if file and file ~= ""  then
            gbind = tostring(file):upper()
            bind = Enum.KeyCode[gbind]
            keybindcall(gbind)
            TextBox_2.Text = gbind
        else
            bind = ""
        end
        TextBox_2.FocusLost:Connect(function(enterPressed)
            TextBox_2.Text = TextBox_2.Text:upper()
                bind = TextBox_2.Text:upper()
                if TextBox_2.Text ~= "" then 
                    setconfigtoggle()
                    bind = Enum.KeyCode[TextBox_2.Text]
                else
                    bind = ""
                end
                writefile(string.format("Night/Config/%s/keybinds/%s.lua", rootid, Name), tostring(TextBox_2.Text))
                TextBox_2:ReleaseFocus(true)
            end)
            cloneref(game:GetService("UserInputService")).InputBegan:Connect(function(input)
                if input.KeyCode == bind and not cloneref(game:GetService("UserInputService")):GetFocusedTextBox() then
                        toggled = not toggled
                        if toggled and not disable then
                            ts:Create(toggle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255, 101, 104)}):Play()
                            ts:Create(TextLabel_8, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(27, 27, 27)}):Play()
                            ts:Create(Options_3, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(27, 27, 27)}):Play()
                        else
                            ts:Create(toggle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(27, 27, 27)}):Play()
                            ts:Create(TextLabel_8, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(229, 229, 229)}):Play()
                            ts:Create(Options_3, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(163, 162, 165)}):Play()
                        end
                        call(toggled)
                        setconfigtoggle()
                        if disable then
                            toggled = false
                            call(toggled)
                        else
                            writefile(string.format("Night/Config/%s/toggles/%s.lua", rootid, Name), tostring(toggled))
                        end
                end
            end)
            
            TextBox_2:GetPropertyChangedSignal("Text"):Connect(function()
                if TextBox_2.Text:len() > 1 then
                    TextBox_2.Text = TextBox_2.Text:sub(1, 1)
                end
                keybindcall(TextBox_2.Text)
            end)

        local candrop = false
        local drops = 0

        spawn(function()
            repeat
                if drops > 0 then
                    candrop = true
                    Options_3.Visible = true
                    KeyBind_2.Position = UDim2.new(0.73, 0, 0.311111122, 0)
                    break
                end
                task.wait(0.01)
            until candrop
        end)

        local oppsize
        local consize 
        local dropped = true
        Toggle_7.MouseButton2Click:Connect(function()
            dropped = not dropped
            if drops == 0 then return end
            if dropped then
                for i,v in next, Options:GetDescendants() do
                    if v:IsA("Frame") or v:IsA("TextLabel") or v:IsA("ImageButton") or v:IsA("TextBox") then
                        v.Visible = false
                    end
                end
                Contain_2.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y + 200)
                local tween = ts:Create(Contain_2, TweenInfo.new(0.1), {Size = UDim2.new(0, 199, 0, 0)})
                local tween = ts:Create(Options, TweenInfo.new(0.2), {Size = UDim2.new(0, 207, 0, 0)})
                tween:Play()
                tween.Completed:Wait()
                LOL.CanvasSize = UDim2.new(0,0,0,UIListLayout_4.AbsoluteContentSize.Y + 60)
                Options.AutomaticSize = Enum.AutomaticSize.Y
                Contain_2.AutomaticSize = Enum.AutomaticSize.Y
                Options.Visible = false
            else
                Contain_2.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y - 582)
                LOL.CanvasSize = UDim2.new(0,0,0,UIListLayout_4.AbsoluteContentSize.Y + 382)
                Options.Visible = true
                for i,v in next, Options:GetDescendants() do
                    if v:IsA("Frame") or v:IsA("TextLabel") or v:IsA("ImageButton") or v:IsA("TextBox") then
                        v.Visible = true
                    end
                end
                Options.AutomaticSize = Enum.AutomaticSize.Y
                oppsize = Options.AbsoluteSize
                Contain_2.AutomaticSize = Enum.AutomaticSize.Y
                consize = Contain_2.AbsoluteSize
                Options.AutomaticSize = Enum.AutomaticSize.None
                Contain_2.AutomaticSize = Enum.AutomaticSize.None
                ts:Create(Contain_2, TweenInfo.new(0.1), {Size = UDim2.new(0, 199, 0, oppsize.Y )}):Play()
                local tween = ts:Create(Options, TweenInfo.new(0.2), {Size = UDim2.new(0, 207, 0, oppsize.Y + 20)})
                tween:Play()
            end
        end)
        Options_3.MouseButton1Click:Connect(function()
            dropped = not dropped
            if drops == 0 then return end
            if dropped then
                for i,v in next, Options:GetDescendants() do
                    if v:IsA("Frame") or v:IsA("TextLabel") or v:IsA("ImageButton") or v:IsA("TextBox") then
                        v.Visible = false
                    end
                end
                Contain_2.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y + 200)
                local tween = ts:Create(Contain_2, TweenInfo.new(0.1), {Size = UDim2.new(0, 199, 0, 0)})
                local tween = ts:Create(Options, TweenInfo.new(0.2), {Size = UDim2.new(0, 207, 0, 0)})
                tween:Play()
                tween.Completed:Wait()
                LOL.CanvasSize = UDim2.new(0,0,0,UIListLayout_4.AbsoluteContentSize.Y + 60)
                Options.AutomaticSize = Enum.AutomaticSize.Y
                Contain_2.AutomaticSize = Enum.AutomaticSize.Y
                Options.Visible = false
            else
                Contain_2.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y - 582)
                LOL.CanvasSize = UDim2.new(0,0,0,UIListLayout_4.AbsoluteContentSize.Y + 382)
                Options.Visible = true
                for i,v in next, Options:GetDescendants() do
                    if v:IsA("Frame") or v:IsA("TextLabel") or v:IsA("ImageButton") or v:IsA("TextBox") then
                        v.Visible = true
                    end
                end
                Options.AutomaticSize = Enum.AutomaticSize.Y
                oppsize = Options.AbsoluteSize
                Contain_2.AutomaticSize = Enum.AutomaticSize.Y
                consize = Contain_2.AbsoluteSize
                Options.AutomaticSize = Enum.AutomaticSize.None
                Contain_2.AutomaticSize = Enum.AutomaticSize.None
                ts:Create(Contain_2, TweenInfo.new(0.1), {Size = UDim2.new(0, 199, 0, oppsize.Y )}):Play()
                local tween = ts:Create(Options, TweenInfo.new(0.2), {Size = UDim2.new(0, 207, 0, oppsize.Y + 20)})
                tween:Play()
            end
        end)

        local minielemts = {}
        function minielemts:Slider(args2)
            drops += 1
            local Nameslid = args2.name or "Slider"
            local Min = args2.min or 0
            local Max = args2.max or (max / 2)
            local Defslid = args2.def or 5
            local decimals = args2.decimals
            local Callslid = args2.callback or function() end

            local Slider = Instance.new("TextButton")
            local UICorner = Instance.new("UICorner")
            local TextLabel = Instance.new("TextLabel")
            local TextLabelsliderval = Instance.new("TextBox")
            local fill = Instance.new("TextButton")
            local UICorner_2 = Instance.new("UICorner")


            Slider.Name = "Slider"
            Slider.Parent = Contain_2
            Slider.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
            Slider.Position = UDim2.new(0, 0, 0.735042751, 0)
            Slider.Size = UDim2.new(0, 169, 0, 25)
            Slider.Text = ""

            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = Slider

            TextLabel.Parent = Slider
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.BackgroundTransparency = 1.000
            TextLabel.Position = UDim2.new(0.07, 0, 0.31, 0)
            TextLabel.ZIndex = 2
            TextLabel.Font = Enum.Font.GothamBold
            TextLabel.Text = Nameslid
            TextLabel.TextColor3 = Color3.fromRGB(27, 27, 27)
            TextLabel.TextSize = 11.000
            TextLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextWrapped = true
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.AutomaticSize = Enum.AutomaticSize.X
            TextLabel.Size = UDim2.new((TextLabel.AbsoluteSize.X / 100), 0, 0, 10)
            TextLabel.AutomaticSize = Enum.AutomaticSize.None

            TextLabelsliderval.Parent = Slider
            TextLabelsliderval.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabelsliderval.BackgroundTransparency = 1.000
            TextLabelsliderval.Position = UDim2.new(0.78, 0, 0.32, 0)
            TextLabelsliderval.Size = UDim2.new(0, 43, 0, 10)
            TextLabelsliderval.ZIndex = 2
            TextLabelsliderval.Font = Enum.Font.GothamBold
            TextLabelsliderval.Text = Defslid
            TextLabelsliderval.TextColor3 = Color3.fromRGB(27, 27, 27)
            TextLabelsliderval.TextSize = 11.000
            TextLabelsliderval.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            TextLabelsliderval.TextWrapped = true

            fill.Name = "fill"
            fill.Parent = Slider
            fill.Active = false
            fill.BackgroundColor3 = Color3.fromRGB(255, 101, 104)
            fill.Selectable = false
            fill.Size = UDim2.new(0, 100, 0, 25)
            fill.Text = ""

            UICorner_2.CornerRadius = UDim.new(0, 6)
            UICorner_2.Parent = fill

            local dragging = false
            fill.MouseButton1Down:Connect(function()
                dragging = true
            end)
            Slider.MouseButton1Down:Connect(function()
                dragging = true
            end)

            cloneref(game:GetService("UserInputService")).InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            function setconfigslider()
                if not isfolder(string.format("Night/Config/%s/sliders", rootid)) then
                    makefolder(string.format("Night/Config/%s/sliders", rootid))
                end
            end
            
            if isfile(string.format("Night/Config/%s/sliders/%s.lua", rootid, Nameslid)) then
                if readfile(string.format("Night/Config/%s/sliders/%s.lua", rootid, Nameslid)) then
                    TextLabelsliderval.Text = readfile(string.format("Night/Config/%s/sliders/%s.lua", rootid, Nameslid))
                    Callslid(TextLabelsliderval.Text)
                    if fill.Size.X.Scale >= 1 then
                        ts:Create(fill, TweenInfo.new(0.4), {Size = UDim2.new(1, 0, 0.95, 0)}):Play()
                    else
                        ts:Create(fill, TweenInfo.new(0.4), {Size = UDim2.new(TextLabelsliderval.Text / 100.2, 0, 0, 25)}):Play()
                    end
                end
            elseif Defslid and not isfile(string.format("Night/Config/%s/sliders/%s.lua", rootid, Nameslid)) then
                TextLabelsliderval.Text = Defslid
                Callslid(Defslid)
                if fill.Size.X.Scale >= 1 then
                    ts:Create(fill, TweenInfo.new(0.4), {Size = UDim2.new(1, 0, 0.95, 0)}):Play()
                else
                    ts:Create(fill, TweenInfo.new(0.4), {Size = UDim2.new(TextLabelsliderval.Text / 100.2, 0, 0, 25)}):Play()
                end
            end

            TextLabelsliderval.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            spawn(function()
            cloneref(game:GetService("UserInputService")).InputChanged:Connect(function(input)
                if dragging then
                    local mouse = cloneref(game:GetService("UserInputService")):GetMouseLocation()
                    local relativePos = mouse-fill.AbsolutePosition
                    local percent = math.clamp(relativePos.X/Slider.AbsoluteSize.X, 0, 1)
                    local value = math.floor(((((Max - Min) * percent) + Min) * (10 ^ decimals)) + 0.5) / (10 ^ decimals) 
                    ts:Create(fill, TweenInfo.new(0.45), {Size = UDim2.new(percent, 0, 0, 25)}):Play()
                    TextLabelsliderval.Text = tostring(value)
                    Callslid(value)
                    setconfigslider()
                    writefile(string.format("Night/Config/%s/sliders/%s.lua", rootid, Nameslid), tostring(value))
                end
            end)
            
            TextLabelsliderval:GetPropertyChangedSignal("Text"):Connect(function()
                local value = tonumber(TextLabelsliderval.Text)
                if value then
                    local percent = math.clamp((value-Min)/(Max-Min), 0, 1)
                    ts:Create(fill, TweenInfo.new(0.45), {Size = UDim2.new(percent, 0, 0, 25)}):Play()
                    Callslid(value)
                    setconfigslider()
                    writefile(string.format("Night/Config/%s/sliders/%s.lua", rootid, Nameslid), tostring(value))
                end
            end)
        end)
    end

        local selecteddrop = nil
        function minielemts:Dropdown(args3)
            drops += 1
            local Namedrop = args3.name or "Dropdown"
            local Defdrop = args3.def or "exo on top"
            local defoptions = args3.options or {}
            local call = args3.callback or function() end

            local DropDown = Instance.new("Frame")
            local UICorner = Instance.new("UICorner")
            local Open = Instance.new("ImageButton")
            local Textpick = Instance.new("TextLabel")


            DropDown.Name = "DropDown"
            DropDown.Parent = Contain_2
            DropDown.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
            DropDown.Size = UDim2.new(0, 171, 0, 30)

            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = DropDown

            Open.Name = "DropDownButton"
            Open.Parent = DropDown
            Open.BackgroundTransparency = 1.000
            Open.BorderSizePixel = 0
            Open.Position = UDim2.new(0.836257279, 0, 0.166666672, 0)
            Open.Size = UDim2.new(0, 20, 0, 20)
            Open.Image = "http://www.roblox.com/asset/?id=6031091004"

            Textpick.Name = "Text"
            Textpick.Parent = DropDown
            Textpick.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Textpick.BackgroundTransparency = 1.000
            Textpick.Position = UDim2.new(0.0568643659, 0, 0.266283542, 0)
            Textpick.Size = UDim2.new(0, 112, 0, 13)
            Textpick.Font = Enum.Font.GothamBold
            Textpick.Text = Namedrop.." -  "..Defdrop
            Textpick.TextColor3 = Color3.fromRGB(229, 229, 229)
            Textpick.TextScaled = true
            Textpick.TextSize = 14.000
            Textpick.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            Textpick.TextWrapped = true
            Textpick.TextXAlignment = Enum.TextXAlignment.Left
            
            local DropDownMain = Instance.new("Frame")
            local UICorner = Instance.new("UICorner")
            local Container = Instance.new("ScrollingFrame")
            local UIListLayout = Instance.new("UIListLayout")


            DropDownMain.Name = "DropDownMain"
            DropDownMain.Parent = Contain_2
            DropDownMain.Visible = false
            DropDownMain.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
            DropDownMain.Position = UDim2.new(0, 0, 0.161016956, 0)
            DropDownMain.Size = UDim2.new(0, 171, 0, 0)

            UICorner.CornerRadius = UDim.new(0, 6)
            UICorner.Parent = DropDownMain

            Container.Name = "Container"
            Container.Parent = DropDownMain
            Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Container.BackgroundTransparency = 1.000
            Container.Position = UDim2.new(0.0643274859, 0, 0.117437911, 0)
            Container.Size = UDim2.new(0, 152, 0, 46)
            Container.ScrollBarThickness = 0
            Container.CanvasSize = UDim2.new(0,0,0,0)
            

            Container.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y + 110)
            Container.ChildAdded:Connect(function()
                Container.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y + 110)
            end) 
            
            UIListLayout.Parent = Container
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 2)

            function setconfigdrop()
                if not isfolder(string.format("Night/Config/%s/dropdowns", rootid)) then
                    makefolder(string.format("Night/Config/%s/dropdowns", rootid))
                end
            end
    
            if isfile(string.format("Night/Config/%s/dropdowns/%s.lua", rootid, Namedrop)) then
                if readfile(string.format("Night/Config/%s/dropdowns/%s.lua", rootid, Namedrop)) then
                    Textpick.Text = Namedrop.." -  "..readfile(string.format("Night/Config/%s/dropdowns/%s.lua", rootid, Namedrop))
                    call(readfile(string.format("Night/Config/%s/dropdowns/%s.lua", rootid, Namedrop)))
                end
            end

            local dropopen = false
            for i,v in next, defoptions do
                local TextButton = Instance.new("TextButton")
                TextButton.Parent = Container
                TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                TextButton.BackgroundTransparency = 1.000
                TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
                TextButton.BorderSizePixel = 0
                TextButton.Size = UDim2.new(0, 112, 0, 11)
                TextButton.Font = Enum.Font.GothamBold
                TextButton.Text = v
                TextButton.TextColor3 = Color3.fromRGB(72, 72, 72)
                TextButton.TextScaled = true
                TextButton.TextSize = 14.000
                TextButton.TextWrapped = true
                TextButton.TextXAlignment = Enum.TextXAlignment.Left
                TextButton.TextTransparency = 1
                TextButton.Visible = false
                TextButton.MouseButton1Click:Connect(function()
                    Container.ScrollBarThickness = 0
                    dropopen = false
                    setconfigdrop()
                    writefile(string.format("Night/Config/%s/dropdowns/%s.lua", rootid, Namedrop), tostring(v))
                    call(v)
                    selecteddrop = v
                    Textpick.Text = Namedrop.." -  "..v
                    Contain_2.Position = UDim2.new(0.0360933021, 0, 0.191170603, 0)
                    local tween = ts:Create(DropDownMain, TweenInfo.new(0.15), {Size = UDim2.new(0, 171, 0, 0)})
                    local tween2 = ts:Create(Open, TweenInfo.new(0.15), {Rotation = 0})
                    for i,v in next, Container:GetChildren() do
                        if v:IsA("TextButton") then
                            v.Visible = true
                            ts:Create(v, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
                        end
                    end
                    ts:Create(Contain_2, TweenInfo.new(0.1), {Size = UDim2.new(0, 199, 0, Contain_2.Size.Y.Offset - 76)}):Play()
                    ts:Create(Options, TweenInfo.new(0.2), {Size = UDim2.new(0, 207, 0, Options.Size.Y.Offset - 76)}):Play()
                    tween:Play()
                    tween2:Play()
                    tween.Completed:Wait()
                    DropDownMain.Visible = false
                end)
            end
            Open.MouseButton1Click:Connect(function()
                dropopen = not dropopen
                if dropopen then
                    Container.ScrollBarThickness = 1
                    DropDownMain.Visible = true
                    Contain_2.Position = UDim2.new(0.0360933021, 0, 0.0911705941, 0)
                    ts:Create(Contain_2, TweenInfo.new(0.1), {Size = UDim2.new(0, 199, 0, Contain_2.Size.Y.Offset + 76)}):Play()
                    ts:Create(Options, TweenInfo.new(0.2), {Size = UDim2.new(0, 207, 0, Options.Size.Y.Offset + 76)}):Play()
                    local tween2 = ts:Create(Open, TweenInfo.new(0.15), {Rotation = 180})
                    local tween = ts:Create(DropDownMain, TweenInfo.new(0.15), {Size = UDim2.new(0, 171, 0, 56)})
                    for i,v in next, Container:GetChildren() do
                        if v:IsA("TextButton") then
                            v.Visible = true
                            ts:Create(v, TweenInfo.new(0.15), {TextTransparency = 0}):Play()
                        end
                    end
                    tween:Play()
                    tween2:Play()
                else
                    Container.ScrollBarThickness = 0
                    Contain_2.Position = UDim2.new(0.0360933021, 0, 0.191170603, 0)
                    local tween2 = ts:Create(Open, TweenInfo.new(0.15), {Rotation = 0})
                    local tween = ts:Create(DropDownMain, TweenInfo.new(0.15), {Size = UDim2.new(0, 171, 0, 0)})
                    for i,v in next, Container:GetChildren() do
                        if v:IsA("TextButton") then
                            v.Visible = true
                            ts:Create(v, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
                        end
                    end
                    tween:Play()
                    tween2:Play()
                    ts:Create(Contain_2, TweenInfo.new(0.1), {Size = UDim2.new(0, 199, 0, Contain_2.Size.Y.Offset - 76)}):Play()
                    ts:Create(Options, TweenInfo.new(0.2), {Size = UDim2.new(0, 207, 0, Options.Size.Y.Offset - 76)}):Play()
                    tween2.Completed:Wait()
                    DropDownMain.Visible = false
                end
            end)
            Open.MouseButton2Click:Connect(function()
                dropopen = not dropopen
                if dropopen then
                    Container.ScrollBarThickness = 1
                    DropDownMain.Visible = true
                    Contain_2.Position = UDim2.new(0.0360933021, 0, 0.0911705941, 0)
                    ts:Create(Contain_2, TweenInfo.new(0.1), {Size = UDim2.new(0, 199, 0, Contain_2.Size.Y.Offset + 76)}):Play()
                    ts:Create(Options, TweenInfo.new(0.2), {Size = UDim2.new(0, 207, 0, Options.Size.Y.Offset + 76)}):Play()
                    local tween2 = ts:Create(Open, TweenInfo.new(0.15), {Rotation = 180})
                    local tween = ts:Create(DropDownMain, TweenInfo.new(0.15), {Size = UDim2.new(0, 171, 0, 56)})
                    for i,v in next, Container:GetChildren() do
                        if v:IsA("TextButton") then
                            v.Visible = true
                            ts:Create(v, TweenInfo.new(0.15), {TextTransparency = 0}):Play()
                        end
                    end
                    tween:Play()
                    tween2:Play()
                else
                    Container.ScrollBarThickness = 0
                    Contain_2.Position = UDim2.new(0.0360933021, 0, 0.191170603, 0)
                    local tween2 = ts:Create(Open, TweenInfo.new(0.15), {Rotation = 0})
                    local tween = ts:Create(DropDownMain, TweenInfo.new(0.15), {Size = UDim2.new(0, 171, 0, 0)})
                    for i,v in next, Container:GetChildren() do
                        if v:IsA("TextButton") then
                            v.Visible = true
                            ts:Create(v, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
                        end
                    end
                    tween:Play()
                    tween2:Play()
                    ts:Create(Contain_2, TweenInfo.new(0.1), {Size = UDim2.new(0, 199, 0, Contain_2.Size.Y.Offset - 76)}):Play()
                    ts:Create(Options, TweenInfo.new(0.2), {Size = UDim2.new(0, 207, 0, Options.Size.Y.Offset - 76)}):Play()
                    tween2.Completed:Wait()
                    DropDownMain.Visible = false
                end
            end)
        end

        function minielemts:MiniToggle(args4)
            drops += 1
            local name = args4.name
            local def = args4.def
            local callback = args4.callback

            local nametext = Instance.new("TextLabel", Contain_2)
            nametext.BackgroundTransparency = 1
            nametext.Position = UDim2.new(0, 0, 0.648305058, 0)
            nametext.Size = UDim2.new(0, 165, 0, 17)
            nametext.Font = Enum.Font.GothamBold
            nametext.Text = name
            nametext.TextColor3 = Color3.fromRGB(229, 229, 229)
            nametext.TextSize = 14
            nametext.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
            nametext.TextWrapped = true
            nametext.TextXAlignment = Enum.TextXAlignment.Left

            local maintoggle = Instance.new("Frame", nametext)
            maintoggle.BackgroundColor3 = Color3.fromRGB(55,55,55)
            maintoggle.Position = UDim2.new(0.85, 0,0.187, 0)
            maintoggle.Size = UDim2.new(0,21,0,11)

            local maincorner = Instance.new("UICorner", maintoggle)
            maincorner.CornerRadius = UDim.new(0, 8)

            local togglebutton = Instance.new("ImageButton", maintoggle)
            togglebutton.Name = "autism"
            togglebutton.ImageTransparency = 1
            togglebutton.Size = UDim2.new(0,23,0,10)
            togglebutton.Position = UDim2.new(0,0,0)
            togglebutton.BackgroundTransparency = 1

            local circle = Instance.new("Frame", maintoggle)
            circle.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
            circle.Position = UDim2.new(0.149, 0,0.3, 0)
            circle.Size = UDim2.new(0,5,0,5)
            
            local circlecorner = Instance.new("UICorner", circle)
            circlecorner.CornerRadius = UDim.new(0, 8)

            local enabled = false

            function setconfigmini()
                if not isfolder(string.format("Night/Config/%s/minitoggles", rootid)) then
                    makefolder(string.format("Night/Config/%s/minitoggles", rootid))
                end
            end
    
            if isfile(string.format("Night/Config/%s/minitoggles/%s.lua", rootid, name)) then
                if readfile(string.format("Night/Config/%s/minitoggles/%s.lua", rootid, name)) == "true" then
                    enabled = true
                    callback(enabled)
                    ts:Create(maintoggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 101, 104)}):Play()
                    ts:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0.55, 0,0.3, 0)}):Play()
                end
            elseif def and not isfile(string.format("Night/Config/%s/minitoggles/%s.lua", rootid, name)) then 
                enabled = true
                callback(enabled)
                ts:Create(maintoggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 101, 104)}):Play()
                ts:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0.55, 0,0.3, 0)}):Play()
            end

            togglebutton.MouseButton1Click:Connect(function()
                enabled = not enabled
                if enabled then
                    ts:Create(maintoggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 101, 104)}):Play()
                    ts:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0.55, 0,0.3, 0)}):Play()
                else
                    ts:Create(maintoggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
                    ts:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0.149, 0,0.3, 0)}):Play()
                end
                setconfigmini()
                writefile(string.format("Night/Config/%s/minitoggles/%s.lua", rootid, name), tostring(enabled))
                callback(enabled)
            end)
        end

        return minielemts
    end
    return elemets
end
return guilib
