AddEventHandler('playerConnecting', function()
    --TriggerClientEvent('showNotification', -1,"~g~".. GetPlayerName(source).."~w~ joined.")
    local identifiers = GetPlayerIdentifiers(source)
    for i in ipairs(identifiers) do
        print('Player: ' .. GetPlayerName(source) .. ', Identifier #' .. i .. ': ' .. identifiers[i])
    end
end)

AddEventHandler('playerDropped', function()
	--TriggerClientEvent('showNotification', -1,"~r~".. GetPlayerName(source).."~w~ left.")
end)