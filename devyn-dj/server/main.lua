local QBCore = exports["qb-core"]:GetCoreObject()
local DefaultVolume = 0.01
local xSound = exports.xsound

local Booths = {
    ['test'] = {
        ['radius'] = 40,
        ['coords'] = vector3(120.55, -1281.63, 29.48), 
        ['playing'] = false,
        ['job'] = "none",
    },
}

local function CheckPerms(source, perms)
    for i = 1, #perms do 
        if QBCore.Functions.HasPermission(source, perms[i]) then 
            return true 
        end
    end
    return false
end


RegisterNetEvent('dj:ManageBooth', function(type, booth, data)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local boothCoords = Booths[booth].coords
    local dist = #(coords - boothCoords)
    if dist > 3 then return end

    if type == "play" then 
        print("here")
        xSound:PlayUrlPos(-1, booth, data, DefaultVolume, coords)
        xSound:Distance(-1, booth, Booths[booth].radius)
        Booths[booth].playing = true
    elseif type == "resume" then 
        if not Booths[booth].playing then
            Booths[booth].playing = true
            xSound:Resume(-1, booth)
        end
    elseif type == "pause" then 
        if Booths[booth].playing then
            Booths[booth].playing = false
            xSound:Pause(-1, booth)
        end
    elseif type == "volume" then 
        if not tonumber(data) then return end
        if Booths[booth].playing then
            xSound:setVolume(-1, booth, data)
        end
    end
end)


QBCore.Functions.CreateCallback("dj:getBooths", function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if CheckPerms(src, {"god", "admin"}) then 
        cb(Booths)
    else 
        local temp = {}
        for k,v in pairs(Booths) do 
            if Player.PlayerData.job.name == v['job'] then 
                table.insert(temp, k)
            end
        end
        cb(temp)
    end
end)