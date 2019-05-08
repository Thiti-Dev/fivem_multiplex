print("------------------- Thiti Data Saver Start -------------------")

RegisterServerEvent("updatePosition")
AddEventHandler("updatePosition", function(x,y,z,h)
    userData[source].X,userData[source].Y,userData[source].Z,userData[source].HEADING = x,y,z,h
    --print("Update x :" .. userData[source].X .. " y : " .. userData[source].Y .. " z : " .. userData[source].Z .. " h : " .. userData[source].HEADING)
end)

RegisterServerEvent("updateInventory")
AddEventHandler("updateInventory", function(newInv,removeTask)
    userData[source].INVENTORY = newInv
    userData[source].NOMOREINV = removeTask
    --print("Update new inventory length = " .. #newInv)
end)

RegisterServerEvent("updateApsInventory")
AddEventHandler("updateApsInventory", function(newInv,removeTask)
    userData[source].APSINV = newInv
    userData[source].APSINVREMOVE = removeTask
    print("------------- UPDATE APS INV ---------------")
    --print("Update new inventory length = " .. #newInv)
end)

RegisterServerEvent("updateLooks")
AddEventHandler("updateLooks", function(face,hair,shirt,pant,shoe,gender)
    local Source = source 
    userData[Source].APPEARANCE.SHIRT = shirt
    userData[Source].APPEARANCE.PANT = pant
    userData[Source].APPEARANCE.SHOE = shoe
    TriggerEvent('updateAdvance', userData[Source].NAME, {face=face,hair=hair,shirt=shirt,pant=pant,shoe=shoe,gender=gender})
    print("Update New look")
end)

RegisterServerEvent("updateDressed")
AddEventHandler("updateDressed", function(which,what)
    local Source = source 
    --[[userData[Source].APPEARNACE.SHIRT = shirt
    userData[Source].APPEARNACE.PANT = pant
    userData[Source].APPEARNACE.SHOE = shoe]]
    if which == "shirt" then
        userData[Source].APPEARANCE.SHIRT = what
    elseif which == "pant" then
        userData[Source].APPEARANCE.PANT = what
    elseif which == "shoe" then
        userData[Source].APPEARANCE.SHOE = what
    end
    --TriggerEvent('updateAdvance', userData[Source].NAME, {face=face,hair=hair,shirt=shirt,pant=pant,shoe=shoe,gender=gender})
    print("Update Clothing use")
end)

RegisterServerEvent("updateMoney")
AddEventHandler("updateMoney", function(lastest)
    userData[source].MONEY = lastest
    print("Money updated")
end)

RegisterServerEvent("updateJob")
AddEventHandler("updateJob", function(newjob)
    local Source = source 
    userData[source].JOB = newjob
    TriggerEvent('updateAdvance', userData[Source].NAME, {job=newjob})
end)

RegisterServerEvent("updateExp")
AddEventHandler("updateExp", function(stringExp)
    print("EXP UPDATE == " .. stringExp)
    userData[source].LEVEL = stringExp
end)

RegisterServerEvent("updateDead")
AddEventHandler("updateDead", function(isDead)
    print("Death UPDATE == " .. tostring(isDead))
    userData[source].DEAD = isDead
end)

RegisterServerEvent("updateInside")
AddEventHandler("updateInside", function(instring)
    print("Inside UPDATE == " .. tostring(instring))
    userData[source].INSIDE = instring
end)

RegisterServerEvent("updateCrime")
AddEventHandler("updateCrime", function(stringCrime)
    print("Crime UPDATE == " .. stringCrime)
    userData[source].LISTCRIMINAL = stringCrime
end)

RegisterServerEvent("updateJailTime")
AddEventHandler("updateJailTime", function(timeleft)
    print("JailTime Crime UPDATE == " .. timeleft)
    userData[source].JAILTIME = timeleft
end)

AddEventHandler('playerDropped', function()
    --print("Last identifier = " .. GetPlayerIdentifiers(source))
	local Source = source
    if(userData[Source])then
        -- Save player position
        local finalpos = tostring(userData[Source].X) .. ":" .. tostring(userData[Source].Y) ..  ":" .. tostring(userData[Source].Z) ..  ":" .. tostring(userData[Source].HEADING)
        TriggerEvent('updateAdvance', userData[Source].NAME, {
            position=finalpos,money=userData[Source].MONEY,
            shirt=userData[Source].APPEARANCE.SHIRT,pant=userData[Source].APPEARANCE.PANT,shoe=userData[Source].APPEARANCE.SHOE,
            level=userData[Source].LEVEL,isdead=userData[Source].DEAD,inside=userData[Source].INSIDE,
            criminal=userData[Source].LISTCRIMINAL,jailtime=userData[Source].JAILTIME
        })
        ----------------------

        -- Save player inventory
        local charnameForSave = userData[Source].NAME
        local invSave = userData[Source].INVENTORY
        local invRemove = userData[Source].NOMOREINV
        local apsInv = userData[Source].APSINV
        local apsInvRemove = userData[Source].APSINVREMOVE


        if apsInvRemove then
            for _, z in ipairs(apsInvRemove) do
                MySQL.Async.fetchAll('SELECT * FROM `apsinventory` WHERE `character_name` = @charname AND `item_name` = @itemname AND `place` = @places', {
                    ['@charname'] = charnameForSave,
                    ['@itemname'] = z.Name,
                    ['@places'] = z.Place
                }, function (result)
                    if #result > 0 then
                        print("Try to Delete the variable")
                        MySQL.Async.execute('DELETE FROM `apsinventory` WHERE `character_name`=@identifier AND `item_name` = @itemname AND `place` = @places', {
                            ['@identifier'] = charnameForSave,
                            ['@itemname'] = z.Name,
                            ['@places'] = z.Place
                        }, function(rowsChanged)
                            if callback then
                                callback(true)
                            end
                        end)
                    else
                        print("Skipped Not found to remove")   
                    end
                end)
            end
        end


        if apsInv then
            for placestr, x in pairs(apsInv) do
                --print(json.encode(x.INVENTORY))
                for _ , z in ipairs(x.INVENTORY) do
                    MySQL.Async.fetchAll('SELECT * FROM `apsinventory` WHERE `character_name` = @charname AND `item_name` = @itemname AND `place` = @places', {
                        ['@charname'] = charnameForSave,
                        ['@itemname'] = z.Name,
                        ['@places'] = placestr
                    }, function (result)
                        if #result > 0 then
                            print("--------- TRY TO UPDATE APS INV ------------")
                            if result[1].amount ~= z.Amount then
                                MySQL.Async.execute('UPDATE apsinventory SET `amount` = @amount WHERE `character_name`=@identifier AND `item_name` = @itemname AND `place` = @places', {
                                    ['@amount'] = z.Amount,
                                    ['@identifier'] = charnameForSave,
                                    ['@itemname'] = z.Name,
                                    ['@places'] = placestr
                                }, function(rowsChanged)
                                    if callback then
                                        callback(true)
                                    end
                                end)
                            else
                                print("--------- VALUE STILL THE SAME ------------")
                            end
                        else
                            print("--------- CREATE NEW INV TABLE ------------")
                            print("Name = " .. charnameForSave)
                            MySQL.Async.execute(
                            'INSERT INTO apsinventory (character_name, item_name , amount, place) VALUES (@identifier, @item_name , @amount , @places)',
                            {
                                ['@identifier'] = charnameForSave,
                                ['@item_name']       = z.Name,
                                ['@amount']   =  z.Amount,
                                ['@places'] = placestr
                            })                   
                        end
                    end)
                end
            end
        end










        if invRemove then
            for _, z in ipairs(invRemove) do
                MySQL.Async.fetchAll('SELECT * FROM `inventory` WHERE `character_name` = @charname AND `item_name` = @itemname', {
                    ['@charname'] = charnameForSave,
                    ['@itemname'] = z.Name
                }, function (result)
                    if #result > 0 then
                        print("Try to Delete the variable")
                        MySQL.Async.execute('DELETE FROM `inventory` WHERE `character_name`=@identifier AND `item_name` = @itemname', {
                            ['@identifier'] = charnameForSave,
                            ['@itemname'] = z.Name
                        }, function(rowsChanged)
                            if callback then
                                callback(true)
                            end
                        end)
                    else
                        print("Skipped Not found to remove")   
                    end
                end)
            end
        end


        if invSave then
            for _, x in ipairs(invSave) do
                MySQL.Async.fetchAll('SELECT * FROM `inventory` WHERE `character_name` = @charname AND `item_name` = @itemname', {
                    ['@charname'] = charnameForSave,
                    ['@itemname'] = x.Name
                }, function (result)
                    if #result > 0 then
                        print("Try to update the variable")
                        if result[1].amount ~= x.Amount then
                            MySQL.Async.execute('UPDATE inventory SET `amount` = @amount WHERE `character_name`=@identifier AND `item_name` = @itemname', {
                                ['@amount'] = x.Amount,
                                ['@identifier'] = charnameForSave,
                                ['@itemname'] = x.Name
                            }, function(rowsChanged)
                                if callback then
                                    callback(true)
                                end
                            end)
                        else
                            print("The values still the same , ignored it")
                        end
                    else
                        print("Try to create new table with")
                        print("Name = " .. charnameForSave)
                        MySQL.Async.execute(
                        'INSERT INTO inventory (character_name, item_name , amount) VALUES (@identifier, @item_name , @amount)',
                        {
                            ['@identifier'] = charnameForSave,
                            ['@item_name']       = x.Name,
                            ['@amount']   =  x.Amount
                        })                   
                    end
                end)
            end
        end
        -----------------------

        print("Set userData[Source] to nil")
        userData[Source] = nil
        TriggerClientEvent("recieveTrueList", -1, userData) --update the scoreboard
	end
end)
