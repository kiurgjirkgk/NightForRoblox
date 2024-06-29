local rootid = game.PlaceId
local https = game:GetService("HttpService")
local mainrepgames = "https://github.com/kiurgjirkgk/NightForRoblox/blob/main/games/"
local rawmainrep = "https://raw.githubusercontent.com/kiurgjirkgk/NightForRoblox/main/games/"

local suc, err = pcall(function()
    local req 
    req = http.request({
        Url = string.format("https://apis.roblox.com/universes/v1/places/%s/universe", game.PlaceId),
        Method = "GET"
    }).Body
    local unid = https:JSONDecode(req).universeId
    req = http.request({
        Url = "https://games.roblox.com/v1/games?universeIds="..tostring(unid),
        Method = "GET"
    }).Body
    rootid = https:JSONDecode(req).data[1].rootPlaceId
end)

local gamexists = pcall(function()
    local game = game:HttpGet(mainrepgames..rootid..".lua")
end)

if gamexists  then
    loadstring(game:HttpGet(rawmainrep..rootid..".lua"))()
elseif suc and not gamexists then
    print("game not supported")
else
    print("failed to get game(solara issue im guessing) or not supported")
end
