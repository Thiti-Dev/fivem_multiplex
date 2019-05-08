local isFishing = false
local countInterval = 0 -- second
local targetInterval = 1000
local boatUse = nil
RegisterNetEvent("checkIfCanFish")
AddEventHandler("checkIfCanFish", function()
    if not isFishing then
        local posFishing = GetEntityCoords(PlayerPedId())
        local boat = GetClosestVehicle(posFishing.x, posFishing.y, posFishing.z, 6.000, 0, 12294)

        if DoesEntityExist(boat) then
            Citizen.Trace("Boat Exist")
            if IsEntityInWater(boat) and not IsEntityInWater(PlayerPedId())then
                Citizen.Trace("Player on boat , boat on water ... you can fish here")
                RequestAnimDict("amb@world_human_stand_fishing@base")
                while (not HasAnimDictLoaded("amb@world_human_stand_fishing@base")) do Citizen.Wait(0) end
                TaskPlayAnim(GetPlayerPed(-1), 'amb@world_human_stand_fishing@base', 'base', 5.0, -1, -1, 9, 0, false, false, false)  
                DrawMissionText("You are ~g~Fishing . . .", 5000) 
                countInterval = 0
                randomNewInterval()
                boatUse = boat
            end
        else
            Citizen.Trace("NO ANY VEHICLE EXIST")
        end
    else
        stopFishing()
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if IsEntityPlayingAnim(GetPlayerPed(-1), "amb@world_human_stand_fishing@base", "base", 3) then
            isFishing = true
            countInterval = countInterval + 1
            if countInterval >= targetInterval then
                RequestAnimDict("amb@world_human_stand_fishing@idle_a")
                while (not HasAnimDictLoaded("amb@world_human_stand_fishing@idle_a")) do Citizen.Wait(0) end
                TaskPlayAnim(GetPlayerPed(-1), 'amb@world_human_stand_fishing@idle_a', 'idle_c', 5.0, -1, -1, 9, 0, false, false, false)  
                Citizen.Wait(2000) -- getting fish
                StopAnimTask(GetPlayerPed(-1), "amb@world_human_stand_fishing@idle_a","idle_c", 1.0)
                math.randomseed(GetGameTimer())
                math.random(); math.random(); math.random()
                local randomPhase = math.random(1,10)
                if randomPhase < 8 then
                    math.randomseed(GetGameTimer())
                    math.random(); math.random(); math.random()
                    local randomKg = math.random(1,3)                   
                    TriggerEvent("onAddItem", "UNKNOWN-FISH->Weight:" .. randomKg)
                    if playerData.JOB == "Pro Fishing" then
                        earnExp(1.8)
                        Citizen.Trace("Earn exp , becuz job")
                    end
                    --playerData.EXP = playerData.EXP + 1.8
                else
                    math.randomseed(GetGameTimer())
                    math.random(); math.random(); math.random()
                    local randomKg = math.random(1,10)                   
                    TriggerEvent("onAddItem", "UNKNOWN-FISH->Weight:" .. randomKg)
                    if playerData.JOB == "Pro Fishing" then
                        earnExp(5.6)
                        Citizen.Trace("Earn exp , becuz job")
                    end
                    --playerData.EXP = playerData.EXP + 5.6                    
                end

                stopFishing()
            end
        else
            isFishing = false
        end


        --check 
        if IsEntityPlayingAnim(GetPlayerPed(-1), "amb@world_human_stand_fishing@base", "base", 3) then
            if playerData.HOLDING ~= "Fishing-Rod" or IsEntityInWater(PlayerPedId()) then -- fuck0off behavior
                stopFishing()
            end
            local posFishing = GetEntityCoords(PlayerPedId())
            local boat = GetClosestVehicle(posFishing.x, posFishing.y, posFishing.z, 6.000, 0, 12294)
            if boat ~= boatUse then -- out range
                stopFishing()
            end
        end

    end
end)

function randomNewInterval()

    math.randomseed(GetGameTimer())
    math.random(); math.random(); math.random()
    local randomTime = math.random(15,20)
    targetInterval = randomTime
end


function stopFishing()
    StopAnimTask(GetPlayerPed(-1), "amb@world_human_stand_fishing@base","base", 1.0)
    StopAnimTask(GetPlayerPed(-1), "amb@world_human_stand_fishing@idle_a","idle_c", 1.0)
    DrawMissionText("You are stop ~r~Fishing . . .", 3000) 
    countInterval = 0
    targetInterval = 1000
    boatUse = nil
end