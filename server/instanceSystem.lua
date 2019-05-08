globalInstace = {}

Citizen.CreateThread(function() -- save timer was created to prevent the unknown behavior of the variables
	Citizen.Wait(5*1000)
	TriggerEvent("onLoadInstance") --try to load the instance at the very first start 
end)

RegisterServerEvent("onLoadInstance")
AddEventHandler("onLoadInstance", function()
    print("Performing load global instace")

    MySQL.Async.fetchAll('SELECT * FROM `instances`', {}, function (result)
        --print("data : ", result[1].character_name)
        if result then
            print(#result .. " loaded into the global server variables")
            -- operaton where we split each string into the server data variable to contain the e&e
            for _, x in ipairs(result) do
                print(_ .. ". entrance : " .. x.entrance .. " inside : " .. x.inside)
                local entraceSplit = stringsplit(x.entrance, ":")
                local insideSplit = stringsplit(x.inside, ":")
                table.insert(globalInstace, {ENTRANCE={X=tonumber(entraceSplit[1]),Y=tonumber(entraceSplit[2]),Z=tonumber(entraceSplit[3]),HEADING=tonumber(entraceSplit[4])} , INSIDE={X=tonumber(insideSplit[1]),Y=tonumber(insideSplit[2]),Z=tonumber(insideSplit[3]),HEADING=tonumber(insideSplit[4])}})
            end


            print(#globalInstace .. " stored successfully to the server-side variables")
        else
            print("instaces database not found")
        end
    end)
end)

RegisterServerEvent("recieveInstance")
AddEventHandler("recieveInstance", function()
    TriggerClientEvent("instance:recieve", source, globalInstace)
end)

RegisterServerEvent("doneInstance")
AddEventHandler("doneInstance", function(entrance,inside,updateTable)

    local Source = source
    local entraceString = entrance
    local insideString = inside
        MySQL.Async.execute(
    'INSERT INTO instances (entrance, inside) VALUES (@1, @2)',
    {
        ['@1'] = entraceString,
        ['@2']   = insideString
    }, function(rowsChanged)
        globalInstace = updateTable -- update for the new user that just come
        TriggerClientEvent("instance:recieveAll", -1, globalInstace) -- update to all player
        TriggerClientEvent("chatMessage",Source, "System ", {1,170,0}, " created instance [ successfully ]")
         if callback then
            callback(true)
        end   
    end)
end)


RegisterServerEvent("deleteInstance")
AddEventHandler("deleteInstance", function(identity,updateTable)
    local Source = source
    local lastString = identity
    print("identity of instance[entrance] : " .. identity)
    MySQL.Async.execute('DELETE FROM `instances` WHERE `entrance`=@identifier', {
        ['@identifier'] = lastString
    }, function(rowsChanged)
        globalInstace = updateTable
        TriggerClientEvent("instance:recieveAll", -1, globalInstace) -- update to all player
        TriggerClientEvent("chatMessage",Source, "System ", {1,170,0}, " remove instance [ successfully ]")
        if callback then
            callback(true)
        end
    end)
end)