local QBCore = exports["qb-core"]:GetCoreObject()
local PlayerData = {}
local Booths = {}


AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then return end
	PlayerData = QBCore.Functions.GetPlayerData()
    DestroyBooths()
    Wait(500)
    CreateBooths()
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    CreateBooths()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
    DestroyBooths()
    Wait(500)
    CreateBooths()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
    DestroyBooths()
end)

local function GetBooths()
    local p = promise.new()
    QBCore.Functions.TriggerCallback("dj:getBooths", function(r)
        p:resolve(r)
    end)
    return Citizen.Await(p)
end


function CreateBooths()
    Citizen.CreateThread(function()
        local booths = GetBooths()
        for booth, data in pairs(booths) do 
            exports['qb-target']:AddCircleZone("booth-"..booth, vector3(data['coords']['x'], data['coords']['y'], data['coords']['z']), 0.5, {
                "booth-"..booth,
                debugPoly=false,
                useZ=true,
            }, {
                options = {
                    {
                        type = "client",
                        event = "dj:openBooth",
                        icon = "fas fa-circle",
                        label = "DJ Booth",
                        id = booth,
                    },
                },
                distance = 2.5
            })
            Booths[#Booths+1] = "booth"..booth
        end
    end)
end

function DestroyBooths()
    for booth, data in pairs(Booths) do 
        exports['qb-target']:RemoveZone("booth-"..booth)
    end
end


RegisterNetEvent("dj:openBooth", function(data)
    openDj(data.id)
end)

function openDj(booth)
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "open", booth = booth})
end

RegisterNUICallback('Close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('Play', function(data)
    TriggerServerEvent('dj:ManageBooth', "play", data.booth, data.song)
end)

RegisterNUICallback('Resume', function(data)
    TriggerServerEvent('dj:ManageBooth', "resume", data.booth)
end)

RegisterNUICallback('Pause', function(data)
    TriggerServerEvent('dj:ManageBooth', "pause", data.booth)
end)

RegisterNUICallback('Volume', function(data)
    local volume = data.volume * 0.01
    if volume <= 0.00 then volume = 0.01 end
    if volume >= 1.0 then volume = 1.0 end
    TriggerServerEvent('dj:ManageBooth', "volume", data.booth, volume)
end)