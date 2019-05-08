local hashList = {
    "prop_tool_adjspanner",
    "prop_w_me_hatchet",
    "prop_ld_health_pack",
    "prop_food_cb_nugets",
    "prop_energy_drink",
    "w_pi_vintage_pistol_mag2",
    "w_pi_pistol50",
    "prop_fishing_rod_01",
    "prop_cs_lazlow_shirt_01",
    "prop_ld_jeans_01",
    "prop_ld_shoe_01",
    "w_am_jerrycan"
}

-- offset fix--------------------------

local offsetZ = {}

offsetZ['prop_tool_adjspanner'] = -1.1
offsetZ['prop_w_me_hatchet'] = -1.1
offsetZ['prop_ld_health_pack'] = -1.0
offsetZ['prop_food_cb_nugets'] = -0.95
offsetZ['prop_energy_drink'] = -1.1
offsetZ['w_pi_vintage_pistol_mag2'] = -1.15
offsetZ['w_pi_pistol50'] = -1.1
offsetZ['prop_fishing_rod_01'] = -1.145
offsetZ['prop_cs_lazlow_shirt_01'] = -1.3
offsetZ['prop_ld_jeans_01'] = -1.1
offsetZ['prop_ld_shoe_01'] = -1.0
offsetZ['w_am_jerrycan'] = -1.1

------------------------------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local pos = GetEntityCoords(GetPlayerPed(-1))
        for _ , x in ipairs(hashList) do
            if DoesObjectOfTypeExistAtCoords(pos.x,pos.y,pos.z-1.5, 0.9, GetHashKey(x), true) then
                DisplayHelpText("Press ~INPUT_PICKUP~ to pick-up item ~b~")
                break
            end
        end
    end
end)

RegisterNetEvent("dropItem")
AddEventHandler("dropItem", function(hash,index)

    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 0.8, 0.0)
    local properZ = entityWorld.z
    local obj = GetHashKey(hash)

    RequestModel(obj)
    while not HasModelLoaded(obj) do
      Citizen.Wait(1)
    end
    
    --local _, gZ = GetGroundZFor_3dCoord(entityWorld.x, entityWorld.y, entityWorld.z)
    local tempObjOnGround = CreateObject(obj, entityWorld.x, entityWorld.y, entityWorld.z + offsetZ[hash], true, true, false)
    SetEntityRotation(tempObjOnGround, 90.0 , 0.0 , 0.0)
    SetEntityCollision(tempObjOnGround, false)
    FreezeEntityPosition(tempObjOnGround, true)
    SetObjectAsNoLongerNeeded(tempObjOnGround)

    local netId = NetworkGetNetworkIdFromEntity(tempObjOnGround)
    local objCoord = GetEntityCoords(tempObjOnGround)
    TriggerServerEvent("regisNewItem", hash,tostring(netId),{x=objCoord.x, y=objCoord.y, z=objCoord.z},index)
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 38) then --M by default
            --Citizen.Trace("Tryna pickup the object on ground")
            local pos = GetEntityCoords(GetPlayerPed(-1))
            local target = nil
            local hashTarget = nil

            for _ , x in ipairs(hashList) do
                local targetPre = GetClosestObjectOfType(pos.x,pos.y,pos.z-1.5, 0.9, GetHashKey(x), false, false, false)
                if DoesEntityExist(targetPre) and not IsEntityAttachedToAnyPed(targetPre) then
                    target = targetPre
                    hashTarget = x
                    break
                end
            end
            
            if target ~= nil and hashTarget ~= nil then
                local netId = NetworkGetNetworkIdFromEntity(target)
                local objCoord = GetEntityCoords(target)
                Citizen.Trace("Target Net Id = " .. netId)
                Citizen.Trace("Target Position = " .. objCoord.x .. " " .. objCoord.y .. " " .. objCoord.z)
                TriggerServerEvent("checkItem", tostring(netId),hashTarget,{x=objCoord.x,y=objCoord.y,z=objCoord.z})
            end
        end
    end
end)


RegisterNetEvent("onPickupItem")
AddEventHandler("onPickupItem", function(netid,hash,index)
    local objTarget = NetworkGetEntityFromNetworkId(tonumber(netid))
    if DoesEntityExist(objTarget) then
        NetworkRequestControlOfEntity(objTarget)
        TaskTurnPedToFaceEntity(PlayerPedId(), objTarget, 1000)
        Citizen.Wait(1000)
        SetEntityAsMissionEntity(objTarget , true,true)
        pickupAnim()
        DeleteObject(objTarget)
        TriggerEvent("onAddItem", index)
    end
end)


function pickupAnim()
    RequestAnimDict("anim@mp_snowball")
    while (not HasAnimDictLoaded("anim@mp_snowball")) do Citizen.Wait(0) end
    TaskPlayAnim(GetPlayerPed(-1), 'anim@mp_snowball', 'pickup_snowball', 5.0, -1, -1, 9, 0, false, false, false)   
    Citizen.Wait(2000)            
    StopAnimTask(GetPlayerPed(-1), "anim@mp_snowball","pickup_snowball", 1.0)
end