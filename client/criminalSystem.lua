reasonTable = {}
reasonTable[0] = "Drove over speed"
reasonTable[1] = "Shoot gun in public place"
reasonTable[2] = "Vehicle stolen"
reasonTable[3] = "Drunk & Driving"
reasonTable[4] = "Murdered People"


reasonTimeTable = {}
reasonTimeTable[0] = 60
reasonTimeTable[1] = 150
reasonTimeTable[2] = 250
reasonTimeTable[3] = 250
reasonTimeTable[4] = 500

jailPlace = {
    {x=459.62634277344,y=-1002.5374755859,z=-8.2734336853027,heading=185.57926940918}, -- jail-1
    {x=462.98519897461,y=-1002.4207763672,z=-8.2734336853027,heading=182.65171813965}, -- jail-2
    {x=466.70462036133,y=-1002.8912963867,z=-8.2734336853027,heading=179.62666320801}, -- jail-3
    {x=469.47137451172,y=-1002.6400756836,z=-8.2734336853027,heading=181.39794921875}, -- jail-4
}


function saveCrimeToServer()
    local finalString = ""
    for _, x in ipairs(playerData.listCriminal) do
        finalString = finalString .. x.Reason .. "@" .. x.Expired

        if _ ~= #playerData.listCriminal then
            finalString = finalString .. ":"
        end
    end

    TriggerServerEvent("updateCrime", finalString) -- update to server
end

function putPlayerToJailed(timeleft,senderName)
    TriggerServerEvent("arrest:surrender", timeleft,senderName)
    playerData.jailTime = timeleft
    TriggerServerEvent("updateJailTime", timeleft) -- update to server
end

AddEventHandler("genarateCriminalIntoArray", function(fullListString)
    Citizen.Trace("String crime = " .. fullListString)

    local prepareExtract = stringsplit(fullListString, ":")

    for _ , x in ipairs(prepareExtract) do
        local listCriminal = stringsplit(x, "@")
        table.insert(playerData.listCriminal, {Reason=tonumber(listCriminal[1]),Expired=tonumber(listCriminal[2])})
    end
    Citizen.Trace("************** Finish Generate Crime list ***************")
    Citizen.Trace("Total amount of crime in record : " .. #playerData.listCriminal)
end)

RegisterNetEvent("onSuspectCriminal")
AddEventHandler("onSuspectCriminal", function(reason,estime)
    local realReason = tonumber(reason)
    local realTime = tonumber(estime)
    TriggerEvent("chatMessage", "Crimial Report ", {128,0,0}, "You're ^_commmitting ^rcrime Reason : ^3" .. reasonTable[realReason])
    table.insert(playerData.listCriminal, {Reason=realReason,Expired=realTime})
    
    saveCrimeToServer()
end)

AddEventHandler("safeJailMySelf", function(senderName)
    if #playerData.listCriminal > 0 then
        local currentJailTime = 0

        for _ , x in ipairs(playerData.listCriminal) do
            currentJailTime = currentJailTime + reasonTimeTable[x.Reason]
        end
        playerData.listCriminal = {}
        saveCrimeToServer()

        playerTempData.DRAG = false
        playerTempData.handCuffed = false

        putPlayerToJailed(currentJailTime,senderName)
    else
        ShowNotification("Seem like you didn't do something wrong ;P")
    end
end)
AddEventHandler("calculationPaydayEscaped", function()
    if #playerData.listCriminal > 0 then
        for index , x in ipairs(playerData.listCriminal) do
            if x.Expired - 1 < 1 then
                TriggerEvent("chatMessage", "^1[^0 ⚠️ Criminal Escaped ⚠️ ^0] ", {1,170,0}, "You've just escaped the [^1 " .. reasonTable[x.Reason] .. " ^0]")
                x.Expired = nil
            else
                x.Expired = x.Expired - 1
            end
        end

        local newArray = {}
        for count, x in ipairs(playerData.listCriminal) do
            if x.Expired ~= nil then
                table.insert(newArray, x)
            end
        end
        playerData.listCriminal = newArray

        saveCrimeToServer()
    end
end)




local currentMenu = "NONE"

Citizen.CreateThread(function()

    --Default
    WarMenu.CreateMenu('playerads', '')
    --WarMenu.CreateSubMenu('closeMenu', 'clothshop', 'Are you sure?')


    --FRONTEND OPTION
    WarMenu.SetMenuX('playerads', 0.015)
    WarMenu.SetMenuY('playerads', 0.20)
    WarMenu.SetTitleColor('playerads', 0,0,0,0)
    WarMenu.SetTitleBackgroundColor('playerads', 0, 0, 0,0)
    WarMenu.SetSubTitle('playerads', "CRIMES&BILLS LIST")
    WarMenu.SetMenuBackgroundColor('playerads', 0, 0, 0, 80)
    WarMenu.SetMenuMaxOptionCountOnScreen('playerads',10)
    --//
    --WarMenu.ResetSelection()

    while true do
        if WarMenu.IsMenuOpened('playerads') then
            
            if currentMenu == "NONE" then
                if WarMenu.Button('Criminal List & Expired time [ PAYDAY ]') then
                    currentMenu = "CRIMELIST"
                    WarMenu.ResetSelection()
                end    
                if WarMenu.Button('Bills & Payment') then
                    --currentMenu = "BILLLIST"
                    --WarMenu.ResetSelection()
                end
            elseif currentMenu == "CRIMELIST" then
                for _, x in ipairs(playerData.listCriminal) do
                    if WarMenu.Button(tostring(_) .. ". " .. reasonTable[x.Reason]) then
                        DrawMissionText( "~r~" .. tostring(x.Expired) .. " ~w~Payday left , to ~g~ESCAPE ~w~this criminal", 3000) 
                    end                   
                end
            end

            
            
            if WarMenu.Button('Exit') then
                WarMenu.CloseMenu()
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('closeMenu') then
            if WarMenu.Button('Yes') then
                WarMenu.CloseMenu()
            elseif WarMenu.MenuButton('No', 'playerads') then

            end
            WarMenu.Display()
        elseif IsControlJustReleased(0, 167) then --M by default
            if WarMenu.CurrentMenu() == nil then
                currentMenu = "NONE"
                WarMenu.OpenMenu('playerads')
            elseif WarMenu.CurrentMenu() == "playerads" then
                WarMenu.CloseMenu()
            end
        end
        Citizen.Wait(0)
    end
end)

AddEventHandler("safeJailCheck", function()
    Citizen.Trace("*********** safe jail check *************")
    Citizen.CreateThread(function()

        while true do
            Citizen.Wait(1000)
            if playerData.LOGGEDIN then
                if playerData.jailTime > 0 then
                    playerData.jailTime = playerData.jailTime - 1
                    local h,m,s = SecondsToClock(playerData.jailTime)
                    DrawMissionText("~o~Jailed time ~b~" .. m .. " ~w~minute and ~b~" .. s .. " ~w~seconds", 1000) 
                    if playerData.jailTime < 1 then
                        playerData.jailTime = 0
                        TriggerServerEvent("updateJailTime", playerData.jailTime) -- update to server
                        DrawMissionText("You've been ~g~RELEASED ~w~, Don't do it again !", 6000)
                        TriggerEvent("freezeAdjust")
                        --DoScreenFadeOut(200)
                        SetEntityCoords(GetPlayerPed(-1), 464.45407104492, -1006.4437866211, -8.2876081466675, 1, 0, 0, 1)
                        Citizen.Wait(2500)
                        --DoScreenFadeIn(1000)   
                        SetEntityHeading(GetPlayerPed(-1), 256.43310546875) 
                    end
                    if playerData.jailTime > 0 then
                        -- starting check range
                        local isInJail = false
                        for _ , x in ipairs(jailPlace) do
                            if GetDistanceBetweenCoords( x.x, x.y, x.z, GetEntityCoords(GetPlayerPed(-1))) <= 3.5 then  
                                isInJail = true
                                break
                            end
                        end
                        if not isInJail then
                            math.randomseed(GetGameTimer())
                            math.random(); math.random(); math.random()
                            local randomPhase = math.random(1,#jailPlace)
                            Citizen.Trace("You're out of radius of the jail point") 
                            TriggerEvent("freezeAdjust")
                            DoScreenFadeOut(200)
                            SetEntityCoords(GetPlayerPed(-1), jailPlace[randomPhase].x, jailPlace[randomPhase].y, jailPlace[randomPhase].z, 1, 0, 0, 1)
                            Citizen.Wait(2500)
                            DoScreenFadeIn(1000)   
                            SetEntityHeading(GetPlayerPed(-1), jailPlace[randomPhase].heading)
                        end
                    end
                end
            end
        end

    end)
end)