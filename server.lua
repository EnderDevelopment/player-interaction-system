local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('interactionSystem:getPlayerData', function(source, cb, targetId)
    local xPlayer = ESX.GetPlayerFromId(targetId)
    if xPlayer then
        cb(xPlayer.getIdentifier())
    else
        cb(nil)
    end
end)

RegisterServerEvent('interactionSystem:interact')
AddEventHandler('interactionSystem:interact', function(targetId, interactionType)
    local sourcePlayer = source
    local xPlayer = ESX.GetPlayerFromId(sourcePlayer)
    local xTarget = ESX.GetPlayerFromId(targetId)

    if xPlayer and xTarget then
        if interactionType == 'talk' then
            TriggerClientEvent('interactionSystem:notify', targetId, 'Player ' .. xPlayer.getName() .. ' wants to talk to you.')
        elseif interactionType == 'trade' then
            TriggerClientEvent('interactionSystem:notify', targetId, 'Player ' .. xPlayer.getName() .. ' wants to trade with you.')
        elseif interactionType == 'invite' then
            TriggerClientEvent('interactionSystem:notify', targetId, 'Player ' .. xPlayer.getName() .. ' wants to invite you.')
        end

        MySQL.Async.execute('INSERT INTO interactions (player_a_id, player_b_id, interaction_type) VALUES (@player_a_id, @player_b_id, @interaction_type)', {
            ['@player_a_id'] = xPlayer.getIdentifier(),
            ['@player_b_id'] = xTarget.getIdentifier(),
            ['@interaction_type'] = interactionType
        }, function(rowsChanged)
            if rowsChanged == 0 then
                print('Failed to log interaction to database.')
            end
        end)
    end
end)