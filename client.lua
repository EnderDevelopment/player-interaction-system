local ESX = nil
local playerPed = nil
local playerId = nil
local isMenuOpen = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while true do
        Citizen.Wait(0)
        playerPed = PlayerPedId()
        playerId = PlayerId()

        if IsControlJustReleased(0, Config.InteractionKey) then
            local playerCoords = GetEntityCoords(playerPed)
            local playerHeading = GetEntityHeading(playerPed)
            local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, Config.InteractionDistance, 0.0)

            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer(inFrontOfPlayer)

            if closestPlayer ~= -1 and closestDistance <= Config.InteractionDistance then
                local targetPed = GetPlayerPed(closestPlayer)
                local targetCoords = GetEntityCoords(targetPed)
                local targetHeading = GetEntityHeading(targetPed)

                if #(playerCoords - targetCoords) <= Config.InteractionDistance then
                    DrawMarker(1, targetCoords.x, targetCoords.y, targetCoords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 255, 100, false, true, 2, false, nil, nil, false)

                    if not isMenuOpen then
                        isMenuOpen = true
                        OpenRadialMenu(closestPlayer)
                    end
                end
            end
        end
    end
end)

function OpenRadialMenu(targetPlayer)
    local elements = {}

    for i=1, #Config.RadialMenuOptions, 1 do
        table.insert(elements, {label = Config.RadialMenuOptions[i].label, value = Config.RadialMenuOptions[i].value})
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'interaction_menu', {
        title    = 'Interaction Menu',
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        TriggerServerEvent('interactionSystem:interact', GetPlayerServerId(targetPlayer), data.current.value)
        menu.close()
    end, function(data, menu)
        menu.close()
        isMenuOpen = false
    end)
end

RegisterNetEvent('interactionSystem:notify')
AddEventHandler('interactionSystem:notify', function(message)
    ESX.ShowNotification(message)
end)