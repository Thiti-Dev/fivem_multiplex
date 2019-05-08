RegisterServerEvent("onRegisterCheckExist")
AddEventHandler("onRegisterCheckExist", function(username)
    --TriggerClientEvent("chatMessage",source, "[CHECKING]", {1,170,0}, "Done with " .. username)

    local sourceuse = source
    local usernamelast = username

    MySQL.Async.fetchAll('SELECT * FROM `users` WHERE `username` = @username ', {['@username'] = username}, function (result)
        --print("data : ", result[1].character_name)
        if #result > 0 then
            TriggerClientEvent("chatMessage",sourceuse, "^0[^a 🔗 System ^0] ", {1,170,0}, "Username : " .. result[1].username .. " Already Exist")
        else
            TriggerClientEvent("onRegisterLast", sourceuse, usernamelast)
            --TriggerClientEvent("chatMessage",sourceuse, "[CHECKING]", {1,170,0}, "You can use this")
        end
        --TriggerClientEvent("chatMessage",source, "[CHECKING]", {1,170,0}, "Worked")
    end)
end)

RegisterServerEvent("onRegisterAppend")
AddEventHandler("onRegisterAppend", function(username,password,character_name)
    local sourceuse = source
    local usernamelast = username
    local passwordlast = password
    local charnameLast = character_name

    MySQL.Async.fetchAll('SELECT * FROM `users` WHERE `character_name` = @charname ', {['@charname'] = charnameLast}, function (result)
        if #result > 0 then
            TriggerClientEvent("chatMessage",sourceuse, "^0[^a 🔗 System ^0] ", {1,170,0}, "Character_Name : " .. result[1].character_name .. " Already Exist")
        else
            MySQL.Async.execute(
            'INSERT INTO users (username, character_name , password) VALUES (@identifier, @name , @password)',
            {
                ['@identifier'] = usernamelast,
                ['@name']       = charnameLast,
                ['@password']   = passwordlast
            },function(rowsChanged)
                TriggerClientEvent("chatMessage",sourceuse, "^0[^a 🔗 System ^0] ", {1,170,0}, "Character creation success")
            end)
        end
    end)
end)

RegisterServerEvent("onLoginAppend")
AddEventHandler("onLoginAppend", function(username,password)

    local sourceuse = source
    local usernamelast = username
    local passwordlast = username

    MySQL.Async.fetchAll('SELECT * FROM `users` WHERE `username` = @username AND `password` = @password ', {['@username'] = username,['@password'] = password}, function (result)
        --print("data : ", result[1].character_name)
        if #result > 0 then
            TriggerClientEvent("chatMessage",sourceuse, "^0[^a 🔗 System ^0] ", {1,170,0}, "Login successful")
            TriggerClientEvent("onLoginSuccess", sourceuse,result[1])
            userData[sourceuse] = {
                NAME=result[1].character_name,MONEY=result[1].money,X=nil,Y=nil,Z=nil,HEADING=nil,
                APPEARANCE={SHIRT=result[1].shirt,PANT=result[1].pant,SHOE=result[1].shoe},
                LEVEL=result[1].level,JOB=result[1].job,DEAD=result[1].isdead,INSIDE=result[1].inside,
                LISTCRIMINAL=result[1].criminal,JAILTIME=result[1].jailtime
            }
            TriggerClientEvent("recieveTrueList", -1, userData) --update the scoreboard
        else
            TriggerClientEvent("chatMessage",sourceuse, "^0[^a 🔗 System ^0] ", {1,170,0}, "False Credential , please try another password / username")
            --TriggerClientEvent("onRegisterLast", sourceuse, usernamelast)
            --TriggerClientEvent("chatMessage",sourceuse, "[CHECKING]", {1,170,0}, "You can use this")
        end
        --TriggerClientEvent("chatMessage",source, "[CHECKING]", {1,170,0}, "Worked")
    end)
end)

RegisterServerEvent("onLoadInventory")
AddEventHandler("onLoadInventory", function(username)

    local sourceuse = source
    local usernamelast = username

    MySQL.Async.fetchAll('SELECT * FROM `inventory` WHERE `character_name` = @charname', {['@charname'] = usernamelast}, function (result)
        --print("data : ", result[1].character_name)
        if #result > 0 then
            TriggerClientEvent("chatMessage",sourceuse, "^0[^a 🔗 System ^0] ", {1,170,0}, "Load inventory successful")
            TriggerClientEvent("onLoadInvSuccess", sourceuse,result)
        else
            TriggerClientEvent("chatMessage",sourceuse, "^0[^a 🔗 System ^0] ", {1,170,0}, "Inventory not found in database")
            TriggerClientEvent("onLoadInvSuccess", sourceuse,result)
        end
    end)
end)

RegisterServerEvent("onLoadVehicle")
AddEventHandler("onLoadVehicle", function(username)

    local sourceuse = source
    local usernamelast = username

    MySQL.Async.fetchAll('SELECT * FROM `playervehicles` WHERE `owner` = @charname', {['@charname'] = usernamelast}, function (result)
        --print("data : ", result[1].character_name)
        if #result > 0 then
            TriggerClientEvent("chatMessage",sourceuse, "^0[^a 🔗 System ^0] ", {1,170,0}, "Load player vehicles from database successful")
            TriggerClientEvent("onLoadCarSuccess", sourceuse,result)
        else
            TriggerClientEvent("chatMessage",sourceuse, "^0[^a 🔗 System ^0] ", {1,170,0}, "Player vehicles not found in database")
            TriggerClientEvent("onLoadCarSuccess", sourceuse,result)
        end
    end)
end)

RegisterServerEvent("onLoadApartment")
AddEventHandler("onLoadApartment", function(username)

    local sourceuse = source
    local usernamelast = username

    MySQL.Async.fetchAll('SELECT * FROM `apartments` WHERE `owner` = @charname', {['@charname'] = usernamelast}, function (result)
        --print("data : ", result[1].character_name)
        if #result > 0 then
            TriggerClientEvent("chatMessage",sourceuse, "^0[^a 🔗 System ^0] ", {1,170,0}, "Load apartments from database successful")
            TriggerClientEvent("onLoadApsSuccess", sourceuse,result)
        else
            TriggerClientEvent("chatMessage",sourceuse, "^0[^a 🔗 System ^0] ", {1,170,0}, "Player apartments not found in database")
            TriggerClientEvent("onLoadApsSuccess", sourceuse,result)
        end
    end)
end)

RegisterServerEvent("onLoadApartmentInv")
AddEventHandler("onLoadApartmentInv", function(username,place)

    local sourceuse = source
    local usernamelast = username
    local placeStr = place

    MySQL.Async.fetchAll('SELECT * FROM `apsinventory` WHERE `character_name` = @charname AND `place` = @places', {['@charname'] = usernamelast,['@places'] = placeStr}, function (result)
        --print("data : ", result[1].character_name)
        if #result > 0 then
            --TriggerClientEvent("chatMessage",sourceuse, "^0[^a 🔗 System ^0] ", {1,170,0}, "Load inventory successful")
            TriggerClientEvent("onLoadApsInvSuccess", sourceuse,result)
        else
            --TriggerClientEvent("chatMessage",sourceuse, "^0[^a 🔗 System ^0] ", {1,170,0}, "Inventory not found in database")
            TriggerClientEvent("onLoadApsInvSuccess", sourceuse,result)
        end
    end)
end)