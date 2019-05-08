local finalAmmo = nil
local cam = -1
local posMark = nil
local rotMarkZ = 0.0
local rotMarkX = 0.0

--/////txtdraw debug
local textdrawdebug = false
local tdx = 0.515
local tdy = 1.22
local tdbugname = "HELLO"
local isInstanced = false
--/

local playerBlip = nil
local randomNpc = nil

local testObject = nil
local objOnGround = nil
local lastHash = "nil"

local isRangeFlag = false
local isRangePos = nil
local rangeRadius = 0

RegisterNetEvent("onCarTest")
AddEventHandler("onCarTest", function()
    local x = VehicleInFront()
    if DoesEntityExist(x) then
        local plate = GetVehicleNumberPlateText(x)
        plate = tostring(plate)
        TriggerEvent("chatMessage", "[Data Check]", {255, 0, 0}, "Closet car plate : " .. plate)
    else
        TriggerEvent("chatMessage", "[Data Check]", {255, 0, 0}, "No car in direction")
    end
end)

RegisterNetEvent("onCarCheck")
AddEventHandler("onCarCheck", function()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    --local x = getVehicleAtCertainRange(pos.x,pos.y,pos.z , 5.0)
    local x = IsAnyVehicleNearPoint(pos.x,pos.y,pos.z,2.0)
    if x then
        --local plate = GetVehicleNumberPlateText(x)
        --plate = tostring(plate)
        TriggerEvent("chatMessage", "[Data Check]", {255, 0, 0}, "There's a car")
    else
        TriggerEvent("chatMessage", "[Data Check]", {255, 0, 0}, "No car in given position")
    end
end)

RegisterNetEvent("onReloadTest")
AddEventHandler("onReloadTest", function()
    MakePedReload(PlayerPedId())
end)

RegisterNetEvent("onReloadTest2")
AddEventHandler("onReloadTest2", function()
    --MakePedReload(PlayerPedId())
    TaskReloadWeapon(PlayerPedId())
end)

RegisterNetEvent("onWeaponGive")
AddEventHandler("onWeaponGive", function()
    local weapon = GetHashKey("WEAPON_PISTOL")
    SetPedAmmo(PlayerPedId(), weapon , 0)
    RemoveAllPedWeapons(PlayerPedId())
    GiveWeaponToPed(PlayerPedId(), weapon, 24, false, true)
    --Citizen.Wait(1500)
    --SetAmmoInClip(PlayerPedId(), weapon , 0)
    --[[while GetSelectedPedWeapon(PlayerPedId()) ~= weapon do
        Citizen.Wait(1)
        TriggerEvent("chatMessage", "[Gun Check]", {255, 0, 0}, "Still not hold")
    end
    Citizen.Wait(500)
    SetAmmoInClip(PlayerPedId(), weapon , 0)]]
end)

RegisterNetEvent("onWeaponGiveWithMag")
AddEventHandler("onWeaponGiveWithMag", function(ammo)
    local weapon = GetHashKey("WEAPON_PISTOL")
    SetPedAmmo(PlayerPedId(), weapon , 0)
    RemoveAllPedWeapons(PlayerPedId())
    GiveWeaponToPed(PlayerPedId(), weapon, 24, false, true)
    finalAmmo = tonumber(ammo)
    --Citizen.Wait(1500)
    --SetAmmoInClip(PlayerPedId(), weapon , 0)
    --[[while GetSelectedPedWeapon(PlayerPedId()) ~= weapon do
        Citizen.Wait(1)
        TriggerEvent("chatMessage", "[Gun Check]", {255, 0, 0}, "Still not hold")
    end
    Citizen.Wait(500)
    SetAmmoInClip(PlayerPedId(), weapon , 0)]]
end)

RegisterNetEvent("onWeaponCheck")
AddEventHandler("onWeaponCheck", function()
    local weapon = GetHashKey("WEAPON_PISTOL")
    if GetSelectedPedWeapon(PlayerPedId()) ~= weapon then
        TriggerEvent("chatMessage", "[Gun Check]", {255, 0, 0}, "Hold else")
    else
        TriggerEvent("chatMessage", "[Gun Check]", {255, 0, 0}, "Holding pistol")
    end
end)

RegisterNetEvent("onWeaponSetAmmo")
AddEventHandler("onWeaponSetAmmo", function()
    local weapon = GetHashKey("WEAPON_PISTOL")
    SetPedAmmo(PlayerPedId(), weapon , 0)
end)

RegisterNetEvent("onAntiSwitch")
AddEventHandler("onAntiSwitch", function()
    --local weapon = GetHashKey("WEAPON_PISTOL")
    --SetPedAmmo(PlayerPedId(), weapon , 0)
    SetPedCanSwitchWeapon(PlayerPedId(), false)
end)

RegisterNetEvent("onWeaponSetAmmo2")
AddEventHandler("onWeaponSetAmmo2", function()
    local weapon = GetHashKey("WEAPON_PISTOL")
    SetAmmoInClip(PlayerPedId(), weapon , 0)
end)

RegisterNetEvent("onAmmoCheck")
AddEventHandler("onAmmoCheck", function()
    local weapon = GetSelectedPedWeapon(PlayerPedId())
    local x = GetAmmoInPedWeapon(PlayerPedId(), weapon)
    TriggerEvent("chatMessage", "[Gun Check]", {255, 0, 0}, "Ammo = " .. x)
end)

RegisterNetEvent("onAmmoCheck2")
AddEventHandler("onAmmoCheck2", function()
    local selectedWeapon = GetSelectedPedWeapon(GetPlayerPed(PlayerId()))
    --print("Selected Weapon: " .. selectedWeapon)

    local bool, ammo = GetAmmoInClip(GetPlayerPed(PlayerId()), selectedWeapon)

    TriggerEvent("chatMessage", "[Gun Check]", {255, 0, 0}, "Ammo = " .. ammo)
end)

RegisterNetEvent("onSetSkin")
AddEventHandler("onSetSkin", function(str)

	local playerPed = GetPlayerPed(-1)
	local whatskin = ""
	if str == "male" or str == "MALE" then
		whatskin = "mp_m_freemode_01"
	elseif str == "female" or str == "FEMALE" then
		whatskin = "mp_f_freemode_01"
	end


	local modelhashed = GetHashKey(whatskin)
	RequestModel(modelhashed)
	while not HasModelLoaded(modelhashed) do 
	    RequestModel(modelhashed)
	    Citizen.Wait(0)
	end
	SetPlayerModel(PlayerId(), modelhashed)
	
	SetPedDefaultComponentVariation(GetPlayerPed(-1))
	--SET_PED_COMPONENT_VARIATION(Ped ped, int componentId, int drawableId, int textureId, int paletteId)
	--SetPedComponentVariation(playerPed, 0, 0, 0, 2) --Face
	--SetPedComponentVariation(playerPed, 2, 11, 4, 2) --Hair 
	--SetPedComponentVariation(playerPed, 4, 1, 5, 2) -- Pantalon
	--SetPedComponentVariation(playerPed, 6, 1, 0, 2) -- Shoes
	--SetPedComponentVariation(playerPed, 11, 7, 2, 2) -- Jacket
	--SetModelAsNoLongerNeeded(modelhashed)
	--SetPedDefaultComponentVariation(GetPlayerPed(-1))
	-- 3 1 0 2 shirt proper hide arm
	-- 8 25 25 2 hide blue inner
end)

RegisterNetEvent("onSetClothes")
AddEventHandler("onSetClothes", function(compo,drawa,textured)
	local playerPed = GetPlayerPed(-1)
	SetPedComponentVariation(playerPed, tonumber(compo), tonumber(drawa), tonumber(textured), 2) --setter
	
	
	TriggerEvent("chatMessage", "[Ped Cuztomizeable]", {255, 0, 0}, "ได้เปลี่ยนเป็น component = " .. compo .. " drawable id == " .. drawa .. " texture id == " .. textured)
end)


RegisterNetEvent("onSetShirt")
AddEventHandler("onSetShirt", function(str)

    local playerPed = GetPlayerPed(-1)
    local shirt = tostring(str)
    if clothesIndex.MALE.SHIRTS[shirt] ~= nil then
        SetPedComponentVariation(playerPed, clothesIndex.MALE.SHIRTS[shirt].INDEX[1], clothesIndex.MALE.SHIRTS[shirt].INDEX[2], clothesIndex.MALE.SHIRTS[shirt].INDEX[3], 2)
        
        SetPedComponentVariation(playerPed, clothesIndex.MALE.SHIRTS[shirt].ACS[1], clothesIndex.MALE.SHIRTS[shirt].ACS[2], clothesIndex.MALE.SHIRTS[shirt].ACS[3], 2)
        
        SetPedComponentVariation(playerPed, clothesIndex.MALE.SHIRTS[shirt].ARM[1], clothesIndex.MALE.SHIRTS[shirt].ARM[2], clothesIndex.MALE.SHIRTS[shirt].ARM[3], 2)
        
        TriggerEvent("chatMessage", "[Clothes Test]", {255, 0, 0}, "You're wearing " .. shirt )
    else
        TriggerEvent("chatMessage", "[Clothes Test]", {255, 0, 0}, "Not found any information of your clothes index")
    end
end)

RegisterNetEvent("onSetPant")
AddEventHandler("onSetPant", function(str)

    local playerPed = GetPlayerPed(-1)
    local pant = tostring(str)
    if clothesIndex.MALE.PANTS[pant] ~= nil then
        SetPedComponentVariation(playerPed, clothesIndex.MALE.PANTS[pant].INDEX[1], clothesIndex.MALE.PANTS[pant].INDEX[2], clothesIndex.MALE.PANTS[pant].INDEX[3], 2)
        TriggerEvent("chatMessage", "[Clothes Test]", {255, 0, 0}, "You're wearing " .. pant )
    else
        TriggerEvent("chatMessage", "[Clothes Test]", {255, 0, 0}, "Not found any information of your clothes index")
    end
end)

RegisterNetEvent("onSetShoes")
AddEventHandler("onSetShoes", function(str)

    local playerPed = GetPlayerPed(-1)
    local shoes = tostring(str)
    if clothesIndex.MALE.SHOES[shoes] ~= nil then
        SetPedComponentVariation(playerPed, clothesIndex.MALE.SHOES[shoes].INDEX[1], clothesIndex.MALE.SHOES[shoes].INDEX[2], clothesIndex.MALE.SHOES[shoes].INDEX[3], 2)
        TriggerEvent("chatMessage", "[Clothes Test]", {255, 0, 0}, "You're wearing " .. shoes )
    else
        TriggerEvent("chatMessage", "[Clothes Test]", {255, 0, 0}, "Not found any information of your clothes index")
    end
end)


RegisterNetEvent("onTeleport")
AddEventHandler("onTeleport", function(x,y,z)
    TriggerEvent("chatMessage", "[Teleport Test]", {255, 0, 0}, "You've been teleported")
    TriggerEvent("freezeAdjust")
    SetEntityCoords(GetPlayerPed(-1), tonumber(x), tonumber(y), tonumber(z), 1, 0, 0, 1)
end)


RegisterNetEvent("onMarkCamera")
AddEventHandler("onMarkCamera", function()
    posMark = GetEntityCoords(GetPlayerPed(-1))
    TriggerEvent("chatMessage", "[Camera Test]", {255, 0, 0}, "Marked at X = " .. posMark.x .. " Y = " .. posMark.y .. " Z = " .. posMark.z)
end)

RegisterNetEvent("onRotZCamera")
AddEventHandler("onRotZCamera", function()
    --SetCamRot(cam, 0.0, 0.0, tonumber(rot))
    rotMarkZ = GetEntityHeading(PlayerPedId())
    TriggerEvent("chatMessage", "[Camera Test]", {255, 0, 0}, "Rot z = " .. rotMarkZ)
end)

RegisterNetEvent("onRotXCamera")
AddEventHandler("onRotXCamera", function(rot)
    --SetCamRot(cam, 0.0, 0.0, tonumber(rot))
    rotMarkX = tonumber(rot)
    TriggerEvent("chatMessage", "[Camera Test]", {255, 0, 0}, "Rot x = " .. rotMarkX)
end)

RegisterNetEvent("onTestCamera")
AddEventHandler("onTestCamera", function(zplus)
    local lastZ = tonumber(zplus)
    --local pos = GetEntityCoords(GetPlayerPed(-1))
    if(DoesCamExist(cam)) then
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(cam, false)
    else
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

		SetCamCoord(cam, posMark.x,posMark.y,posMark.z + zplus)
		SetCamRot(cam, rotMarkX, 0.0, rotMarkZ)
		SetCamActive(cam,  true)
        RenderScriptCams(true,  false,  0,  true,  true)    
        
        SetCamCoord(cam, posMark.x,posMark.y,posMark.z + zplus)
    end
end)

RegisterNetEvent("tdDebug")
AddEventHandler("tdDebug", function()
	textdrawdebug = not textdrawdebug
end)

RegisterNetEvent("tdSet")
AddEventHandler("tdSet", function(strings)
    local last = tostring(strings)
	tdbugname = strings
end)

RegisterNetEvent("onMenuTest")
AddEventHandler("onMenuTest", function()
    --WarMenu.CreateMenu('Gun-Shop', 'Weapon Shop')
    --WarMenu.CreateSubMenu('closeMenu', 'Gun-Shop', 'Are you sure?')
    TriggerEvent("chatMessage", "[GOOD]", {255, 0, 0}, "WORKING")
    --WarMenu.OpenMenu('Gun-Shop')
end)

RegisterNetEvent("onGetNetId")
AddEventHandler("onGetNetId", function()
    local car = GetVehiclePedIsIn(PlayerPedId(), false)  
    if DoesEntityExist(car) then
        local netId = NetworkGetNetworkIdFromEntity(car)
        TriggerEvent("chatMessage", "[GOOD]", {255, 0, 0}, "WORKING NETID = " .. tostring(netId))
    else
        TriggerEvent("chatMessage", "[BAD]", {255, 0, 0}, "You need to be on a vehicle")
    end
    --WarMenu.OpenMenu('Gun-Shop')
end)

RegisterNetEvent("onVehiclePersist")
AddEventHandler("onVehiclePersist", function()
    local car = GetVehiclePedIsIn(PlayerPedId(), false)  
    if DoesEntityExist(car) then
        --local netId = NetworkGetNetworkIdFromEntity(car)
        if IsEntityAMissionEntity(car) then
            SetEntityAsMissionEntity(car , false,false)
            SetVehicleAsNoLongerNeeded(car)
            TriggerEvent("chatMessage", "[GOOD]", {255, 0, 0}, "You've just De-persist this vehicle")
        else
            SetEntityAsMissionEntity(car , true,true)
            TriggerEvent("chatMessage", "[GOOD]", {255, 0, 0}, "You've just persist this vehicle")
        end

    else
        TriggerEvent("chatMessage", "[BAD]", {255, 0, 0}, "You need to be on a vehicle")
    end
    --WarMenu.OpenMenu('Gun-Shop')
end)

RegisterNetEvent("onSpawnCar")
AddEventHandler("onSpawnCar", function(strn)
	local myPed = GetPlayerPed(-1)
	local player = PlayerId()
	local vehicle = GetHashKey(strn)
	RequestModel(vehicle)
	while not HasModelLoaded(vehicle) do
	Wait(1)
	end
	local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 5.0, 0)
	local spawned_car = CreateVehicle(vehicle, coords, GetEntityHeading(myPed), true, false)
	SetVehicleOnGroundProperly(spawned_car)
	SetModelAsNoLongerNeeded(vehicle)
	--Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(spawned_car))
	
	TriggerEvent("chatMessage", "[Car Test]", {255, 0, 0}, "You just spawn" .. strn)
end)

RegisterNetEvent("onSetMenuX")
AddEventHandler("onSetMenuX", function(lastX)
    local realX = tonumber(lastX)
    WarMenu.SetMenuX('gunshop', realX)
end)

RegisterNetEvent("onSetMenuY")
AddEventHandler("onSetMenuY", function(lastY)
    local realY = tonumber(lastY)
    WarMenu.SetMenuY('gunshop', realY)
end)

RegisterNetEvent("onGetCurrentMenu")
AddEventHandler("onGetCurrentMenu", function()
    local target = tostring(WarMenu.CurrentMenu())
    TriggerEvent("chatMessage", "[Menu leak]", {255, 0, 0}, "Current menu : " .. target)
end)


RegisterNetEvent("onSetMoney")
AddEventHandler("onSetMoney", function(money)
    TriggerEvent("chatMessage", "[Money - Payment]", {255, 0, 0}, "start here money == " .. money)
    local targetMoney = tonumber(money)
    moneyPay(targetMoney)
    --[[local targetMoney = tonumber(money)
    if moneyPay(targetMoney) then
        TriggerEvent("chatMessage", "[Money - Payment]", {255, 0, 0}, "You just recieve $: ", .. tostring(targetMoney))
    else
        TriggerEvent("chatMessage", "[Money - Payment]", {255, 0, 0}, "Something went wrong , ask thiti")
    end]]
    --[[if moneyPay(tonumber(money)) then
        TriggerEvent("chatMessage", "[Money - Payment]", {255, 0, 0}, "You just recieve $: ", .. tonumber(money))
    else
        TriggerEvent("chatMessage", "[Money - Payment]", {255, 0, 0}, "Something went wrong , ask thiti")
    end]]
end)

RegisterNetEvent("onSetVoiceChannel")
AddEventHandler("onSetVoiceChannel", function(targetChannel)
    --local finalChannel = tonumber(targetChannel)
    local finalChannel = tostring(targetChannel)
    NetworkSetVoiceChannel(finalChannel)
    TriggerEvent("chatMessage", "[Voice channel]", {255, 0, 0}, "You've set the voice channel to " .. tostring(finalChannel))
end)

RegisterNetEvent("onClearVoiceChannel")
AddEventHandler("onClearVoiceChannel", function()
    TriggerEvent("chatMessage", "[Voice channel]", {255, 0, 0}, "You've clear the voice channel to the default one")
    NetworkClearVoiceChannel()
end)

RegisterNetEvent("onInstanceSelf")
AddEventHandler("onInstanceSelf", function()
    if not isInstanced then
        TriggerEvent("chatMessage", "[ instance-debug ]", {255, 0, 0}, "You've instance your self")
        isInstanced = true
    else
        TriggerEvent("chatMessage", "[ instance-debug ]", {255, 0, 0}, "You've stop instance your self")
        isInstanced = false
    end
end)

RegisterNetEvent("onDeadFuck")
AddEventHandler("onDeadFuck", function()
    RequestAnimDict("dead")
    while not HasAnimDictLoaded("dead") do
        Citizen.Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), "dead", "dead_e", 1.0, 0.0, -1, 9, 9, 1, 1, 1)
    --GivePlayerRagdollControl(PlayerId(), false)
end)

RegisterNetEvent("onClearAnim")
AddEventHandler("onClearAnim", function()
    ClearPedTasksImmediately(PlayerPedId())
end)

RegisterNetEvent("onPlaySpecificAnim")
AddEventHandler("onPlaySpecificAnim", function(lib,target,flag,time)
    local lastFlag = tonumber(flag)
    local lastTime = tonumber(time)
    RequestAnimDict(lib)
    while not HasAnimDictLoaded(lib) do
        Citizen.Wait(100)
    end
    TaskPlayAnim(GetPlayerPed(-1), lib, target, 5.0, -1, lastTime, lastFlag, 0, false, false, false)
    --TaskPlayAnim(PlayerPedId(), lib, target, 5.0, -1, -1, 50, 0, 1, 1, 1)
    --GivePlayerRagdollControl(PlayerId(), false)
end)

RegisterNetEvent("onPlaySpecificAnim2")
AddEventHandler("onPlaySpecificAnim2", function(lib,target,flag,time)
    local lastFlag = tonumber(flag)
    local lastTime = tonumber(time)
    RequestAnimDict(lib)
    while not HasAnimDictLoaded(lib) do
        Citizen.Wait(100)
    end
    TaskPlayAnim(GetPlayerPed(-1), lib, target, 5.0, -1, lastTime, lastFlag, 0, true, true, true)
    --TaskPlayAnim(PlayerPedId(), lib, target, 5.0, -1, -1, 50, 0, 1, 1, 1)
    --GivePlayerRagdollControl(PlayerId(), false)
end)


RegisterNetEvent("onSetBlip")
AddEventHandler("onSetBlip", function()
    if DoesBlipExist(playerBlip) then
        RemoveBlip(playerBlip)
    end
    playerBlip = AddBlipForEntity(randomNpc) 
    SetBlipSprite(playerBlip, 1)
    SetBlipDisplay(playerBlip, 4)
    SetBlipScale(playerBlip, 1.0)
    SetBlipColour(playerBlip, 45)
    SetBlipAsShortRange(playerBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Target blip")
    EndTextCommandSetBlipName(playerBlip)
    TriggerEvent("chatMessage", "[ blip-debug ]", {255, 0, 0}, "You've add yourself blip")
end)

RegisterNetEvent("onRemoveBlip")
AddEventHandler("onRemoveBlip", function()
    if DoesBlipExist(playerBlip) then
        RemoveBlip(playerBlip)
        playerBlip = nil
        TriggerEvent("chatMessage", "[ blip-debug ]", {255, 0, 0}, "You've remove yourself blip")
    end
end)

RegisterNetEvent("onGetNearbyPed")
AddEventHandler("onGetNearbyPed", function(radius)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local pedArray = GetNearbyPeds(pos.x,pos.y,pos.z, tonumber(radius))
    local npcArray = getNpcFromPedArray(pedArray)
    TriggerEvent("chatMessage", "[ Nearby-debug ]", {255, 0, 0}, "Total ped in range " .. radius .. " = " .. #pedArray)
    TriggerEvent("chatMessage", "[ Nearby-debug ]", {255, 0, 0}, "Total NPC[ HUMAN ] in range " .. radius .. " = " .. #npcArray)
    if #npcArray > 0 then
        randomNpc = npcArray[1]
        TriggerEvent("getPedToPrepare", randomNpc) -- send to the otherplayer interaction test
        TriggerEvent("chatMessage", "[ Nearby-get ]", {255, 0, 0}, "Get the npc in your slight")
    end
end)

RegisterNetEvent("onGetNearbyPedWithVehicle")
AddEventHandler("onGetNearbyPedWithVehicle", function(radius)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local pedArray = GetNearbyPeds(pos.x,pos.y,pos.z, tonumber(radius))
    local npcArray = getDriverNpcFromPedArray(pedArray)
    --TriggerEvent("chatMessage", "[ Nearby-debug ]", {255, 0, 0}, "Total ped in range " .. radius .. " = " .. #pedArray)
    TriggerEvent("chatMessage", "[ Nearby-debug ]", {255, 0, 0}, "Total NPC[ HUMAN ] with car in range " .. radius .. " = " .. #npcArray)
    if #npcArray > 0 then
        randomNpc = npcArray[1]
        TriggerEvent("chatMessage", "[ Nearby-get ]", {255, 0, 0}, "Get the npc in your slight")
    end
end)

RegisterNetEvent("driveToPoint")
AddEventHandler("driveToPoint", function()
    local NpcCar = GetVehiclePedIsIn(randomNpc, false)
    TaskVehicleDriveToCoord(randomNpc, NpcCar, 533.25952148438, -178.73878479004, 54.415306091309, 26.0, 0, GetEntityModel(NpcCar), 411, 2.0)
    SetPedKeepTask(randomNpc , true)
    TriggerEvent("chatMessage", "[ Npc-Drive ]", {255, 0, 0}, "Driving to your point ;D")
end)


RegisterNetEvent("getFrontVehDirection")
AddEventHandler("getFrontVehDirection", function()
    local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
	local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 5.0, 0.0)
    local targetVehicle = getVehicleInDirection(coordA, coordB)
    if DoesEntityExist(targetVehicle) then
        local plateOfVeh = GetVehicleNumberPlateText(targetVehicle)
        TriggerEvent("chatMessage", "[ Veh-Detect ]", {255, 0, 0}, "The vehicle plate : " .. plateOfVeh)
    else
        TriggerEvent("chatMessage", "[ Error ]", {255, 0, 0}, "No vehicle found")
    end
end)

RegisterNetEvent("leaveCarPlease")
AddEventHandler("leaveCarPlease", function()
    local NpcCar = GetVehiclePedIsIn(randomNpc, false)
    TaskLeaveVehicle(randomNpc, NpcCar, 0)
    TriggerEvent("chatMessage", "[ Npc-Drive ]", {255, 0, 0}, "left the car")
end)

RegisterNetEvent("isItFlee")
AddEventHandler("isItFlee", function()
    if IsPedFleeing(randomNpc) then
        TriggerEvent("chatMessage", "[ Ped ]", {255, 0, 0}, "Ped is running away from you")
    else
        TriggerEvent("chatMessage", "[ Ped ]", {255, 0, 0}, "Nope ;D")
    end
end)

RegisterNetEvent("isItAngry")
AddEventHandler("isItAngry", function()
    if IsPedStrafing(randomNpc) then
        TriggerEvent("chatMessage", "[ Ped ]", {255, 0, 0}, "Ped is angry you")
    else
        TriggerEvent("chatMessage", "[ Ped ]", {255, 0, 0}, "Nope ;D")
    end
end)


RegisterNetEvent("onRemovePed")
AddEventHandler("onRemovePed", function()
    if DoesEntityExist(randomNpc) then
        Citizen.InvokeNative( 0x9614299DCB53E54B, Citizen.PointerValueIntInitialized( randomNpc ) )
        TriggerEvent("chatMessage", "[ Ped ]", {255, 0, 0}, "You've remove the specific ped")
    else
        TriggerEvent("chatMessage", "[ Ped ]", {255, 0, 0}, "You don't even had the ped")
    end
end)

RegisterNetEvent("walkshop")
AddEventHandler("walkshop", function()
    ClearPedTasksImmediately(randomNpc)
    --TaskGoStraightToCoord(randomNpc, -707.59069824219, -913.80804443359, 19.215589523315, 1.0, -1, 88.617, 0.0)
    TaskGoToCoordAnyMeans(randomNpc, -707.59069824219, -913.80804443359, 19.215589523315, 5.0, 0, 0, 1, 10.0)
end)

RegisterNetEvent("standstill")
AddEventHandler("standstill", function(mili)
    local secReal = tonumber(mili)
    TaskStandStill(randomNpc, secReal)
end)

RegisterNetEvent("onTurnMe")
AddEventHandler("onTurnMe", function()
    TaskTurnPedToFaceEntity(PlayerPedId(), randomNpc, 1500)
    TriggerEvent("chatMessage", "[ turn-test ]", {255, 0, 0}, "you've turn to your target npc")
end)    

RegisterNetEvent("onCheckDeath")
AddEventHandler("onCheckDeath", function()

    RequestAnimDict("mini@cpr@char_b@cpr_str")
    while not HasAnimDictLoaded("mini@cpr@char_b@cpr_str") do
        Citizen.Wait(100)
    end
    
    if IsEntityPlayingAnim(PlayerPedId(), "mini@cpr@char_b@cpr_str", "cpr_fail", 3) then
        TriggerEvent("chatMessage", "[ Death-anim ]", {255, 0, 0}, "you're dead")
    else
        TriggerEvent("chatMessage", "[ Death-anim ]", {255, 0, 0}, "you're not dead")
    end
end)

RegisterNetEvent("onSaveMod")
AddEventHandler("onSaveMod", function()
    TriggerEvent("chatMessage", "[ Mod save test ]", {255, 0, 0}, "you're try to save mod")
    local veh = GetVehiclePedIsUsing(PlayerPedId())
    local stringMod = ""
    if GetPedInVehicleSeat( veh, -1 ) == PlayerPedId()  then 
        for i = 0,24 do
            --mods[i] = GetVehicleMod(veh,i)
            if i ~= 24 then
                stringMod = stringMod .. tostring(GetVehicleMod(veh,i)) .. ":"
            else
                stringMod = stringMod .. tostring(GetVehicleMod(veh,i))
            end
        end
        TriggerEvent("chatMessage", "[ Result ]", {255, 0, 0}, stringMod)
    else
        TriggerEvent("chatMessage", "[ Mod save test ]", {255, 0, 0}, "You need to be a driver")
    end
end)

RegisterNetEvent("onSaveMod2")
AddEventHandler("onSaveMod2", function()
    --TriggerEvent("chatMessage", "[ Mod save test ]", {255, 0, 0}, "you're try to save mod")
    local veh = GetVehiclePedIsUsing(PlayerPedId())
    if GetPedInVehicleSeat( veh, -1 ) == PlayerPedId()  then 
        local translateIndex = {}
        translateIndex['false'] = '0'
        translateIndex['true'] = '1'
        translateIndex['0'] = '0'
        translateIndex['1'] = '1'
        local colours = table.pack(GetVehicleColours(veh))
        local extra_colors = table.pack(GetVehicleExtraColours(veh))
        local neon = table.pack(GetVehicleNeonLightsColour(veh))
        local tyresmoke = table.pack(GetVehicleTyreSmokeColor(veh))
        local stringColors = colours[1] .. ":" .. colours[2] .. ":" .. extra_colors[1] .. ":" .. extra_colors[2]
        local stringNeons = translateIndex[tostring(IsVehicleNeonLightEnabled(veh,0))] .. ":" .. translateIndex[tostring(IsVehicleNeonLightEnabled(veh,1))] .. ":" .. translateIndex[tostring(IsVehicleNeonLightEnabled(veh,2))] .. ":" .. translateIndex[tostring(IsVehicleNeonLightEnabled(veh,3))] .. ":" .. neon[1] .. ":" .. neon[2] .. ":" .. neon[3]   
        local mods = {}
        for i=0,49 do
            mods[i] = GetVehicleMod(veh, i)
        end      
        mods[46] = GetVehicleWindowTint(veh) -- Tinted Windows
        mods[18] = translateIndex[tostring(IsToggleModOn(veh,18))]
        mods[20] = translateIndex[tostring(IsToggleModOn(veh,20))]
        mods[22] = translateIndex[tostring(IsToggleModOn(veh,22))]
        local stringMods = ""
        for i=0,49 do
            stringMods = stringMods .. tostring(mods[i])
            if i ~= 49 then
                stringMods = stringMods .. ":"
            end
        end 
        local bw = translateIndex[tostring(GetVehicleTyresCanBurst(veh))] .. ":" .. tostring(GetVehicleWheelType(veh)) .. ":" .. tostring(tyresmoke[1]) .. ":" .. tostring(tyresmoke[2]) .. ":" .. tostring(tyresmoke[3])


        --[[TriggerEvent("chatMessage", "[ color ]", {255, 0, 0}, stringColors)
        TriggerEvent("chatMessage", "[ neons ]", {255, 0, 0}, stringNeons)
        TriggerEvent("chatMessage", "[ bw ]", {255, 0, 0}, bw)
        TriggerEvent("chatMessage", "[ mods ]", {255, 0, 0}, stringMods)]]
        local plate = GetVehicleNumberPlateText(veh)
        TriggerServerEvent("saveModToServer", plate,stringColors,stringMods,stringNeons,bw)
    else
        TriggerEvent("chatMessage", "[ Mod save test ]", {255, 0, 0}, "You need to be a driver")
    end
end)

RegisterNetEvent("onSetLevel")
AddEventHandler("onSetLevel", function(target)
    TriggerEvent("chatMessage", "[ LEVEL ]", {255, 0, 0}, "You've set your level to " .. target)
    playerData.LEVEL = tonumber(target)
end)

RegisterNetEvent("onSetExp")
AddEventHandler("onSetExp", function(target)
    TriggerEvent("chatMessage", "[ LEVEL-EXP ]", {255, 0, 0}, "You've set your exp to " .. target)
    playerData.EXP = tonumber(target)
end)

RegisterNetEvent("holdObjectTest")
AddEventHandler("holdObjectTest", function(strn,rotx,roty,rotz)
	x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
	
	
	nstrn = GetHashKey(strn)
	
	RequestModel(nstrn)
	while not HasModelLoaded(nstrn) do
	   Wait(1)
	end
	
	if holdObjectTest ~= nil then
		DeleteObject(holdObjectTest)
		holdObjectTest = nil
		TriggerEvent("chatMessage", "[Object Test]", {255, 0, 0}, "Delete the previous one and set it to nil  :P")
	end

	holdObjectTest = CreateObject(nstrn, x, y, z, true, true, false)
	PlaceObjectOnGroundProperly(holdObjectTest) -- This function doesn't seem to work.
	AttachEntityToEntity(holdObjectTest, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 57005), 0.1, 0, -0.025, tonumber(rotx), tonumber(roty), tonumber(rotz), true, true, false, true, 1, true)
	--DisplayHelpText("~w~Press ~INPUT_ATTACK~ ~g~Use ~w~ OR ~INPUT_LOOK_BEHIND~ ~b~Keep ~w~OR ~INPUT_VEH_DUCK~ TO ~r~DROP")

end)

RegisterNetEvent("onSpawnObject")
AddEventHandler("onSpawnObject", function(strn,zgive)
    --local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 1.5, 0.0)
    --local properZ = entityWorld.z
    local obj = GetHashKey(strn)
    lastHash = strn

    RequestModel(obj)
    while not HasModelLoaded(obj) do
      Citizen.Wait(1)
    end

	if objOnGround ~= nil then
		DeleteObject(objOnGround)
		objOnGround = nil
		TriggerEvent("chatMessage", "[Object Test]", {255, 0, 0}, "Delete the previous one and set it to nil  :P")
    end
    
    objOnGround = CreateObject(obj, entityWorld.x, entityWorld.y, entityWorld.z + tonumber(zgive), true, true, false)
    SetEntityRotation(objOnGround, 90.0 , 0.0 , 0.0)
    SetEntityCollision(objOnGround, false)
    --PlaceObjectOnGroundProperly(objOnGround)
    FreezeEntityPosition(objOnGround, true)
    SetObjectAsNoLongerNeeded(objOnGround)
	TriggerEvent("chatMessage", "[object Test]", {255, 0, 0}, "You just spawn" .. strn)
end)

RegisterNetEvent("onDeleteObject")
AddEventHandler("onDeleteObject", function()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local target = GetClosestObjectOfType(pos.x,pos.y,pos.z-1.5, 0.9, GetHashKey(lastHash), false, false, false)
    if DoesEntityExist(target) then
        TriggerEvent("chatMessage", "[object Test]", {255, 0, 0}, "You just delete" .. lastHash)
        SetEntityAsMissionEntity(target , true,true)
		DeleteObject(target)
		objOnGround = nil
    else
        TriggerEvent("chatMessage", "[object Test]", {255, 0, 0}, "No obj found")
    end
end)

RegisterNetEvent("onGetNetIdDrop")
AddEventHandler("onGetNetIdDrop", function()
    if DoesEntityExist(objOnGround) then
        local netId = NetworkGetNetworkIdFromEntity(objOnGround)
        TriggerEvent("chatMessage", "[GOOD]", {255, 0, 0}, "WORKING NETID = " .. tostring(netId))
    else
        TriggerEvent("chatMessage", "[BAD]", {255, 0, 0}, "You don't have any object")
    end
    --WarMenu.OpenMenu('Gun-Shop')
end)

RegisterNetEvent("onSetRot")
AddEventHandler("onSetRot", function(rotx,roty,rotz)
    local rotX , rotY , rotZ = tonumber(rotx) , tonumber(roty) , tonumber(rotz)
    SetEntityRotation(objOnGround, rotX , rotY , rotZ) -- set the entity rotation
    TriggerEvent("chatMessage", "[object Test]", {255, 0, 0}, "You've just set the rotation of the object")
end)

RegisterNetEvent("onPvp")
AddEventHandler("onPvp", function()
    if isPvp then
        isPvp = false
        TriggerEvent("chatMessage", "[Mode]", {255, 0, 0}, "คุณได้ปิดโหมดยิงกระหน่ำล่าไม่ยั้ง")
    else
        isPvp = true
        TriggerEvent("chatMessage", "[Mode]", {255, 0, 0}, "คุณได้เปิดโหมดยิงกระหน่ำล่าไม่ยั้ง พร้อมทั้งเสกอาวุธได้ตามสบาย")
    end
end)

RegisterNetEvent("checkIfAmStill")
AddEventHandler("checkIfAmStill", function()
    if IsPedStill(PlayerPedId()) then
        TriggerEvent("chatMessage", "[GOOD]", {255, 0, 0}, "You are still")
    else
        TriggerEvent("chatMessage", "[BAD]", {255, 0, 0}, "You aren't still")
    end
end)

RegisterNetEvent("onRangeFlag")
AddEventHandler("onRangeFlag", function(radius)
    if not isRangeFlag then
        isRangeFlag = true
        rangeRadius = tonumber(radius)
        isRangePos = GetEntityCoords(GetPlayerPed(-1), true)
        TriggerEvent("chatMessage", "[GOOD]", {255, 0, 0}, "You've set the radius of this point to " .. radius)
    else
        isRangeFlag = false
        rangeRadius = 0
        isRangePos = nil
        TriggerEvent("chatMessage", "[BAD]", {255, 0, 0}, "You have stop flag chack")
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if isRangeFlag and isRangePos and rangeRadius > 0 then
            if GetDistanceBetweenCoords( isRangePos.x, isRangePos.y, isRangePos.z, GetEntityCoords(GetPlayerPed(-1))) > rangeRadius then  
                Citizen.Trace("You're our of radius of " .. rangeRadius) 
            end
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		--if not isintask then
			if textdrawdebug then
				if IsControlJustPressed(1, 27) then
					tdx = tdx+ 0.002
				end
				if IsControlJustPressed(1, 173) then
					tdx = tdx- 0.002
				end
				if IsControlJustPressed(1, 174) then
					tdy = tdy+ 0.002
				end
				if IsControlJustPressed(1, 175) then
					tdy = tdy- 0.002
				end
            end
            if textdrawdebug then
			    drawTxt(tdx, tdy, 1.0,1.0,0.3, "~y~" .. tdbugname, 255, 255, 255, 255)
			    drawTxt(0.66, 1.44, 1.0,1.0,0.4, "~w~Tdx : ~r~" .. tdx .. "~w~ Tdy : ~r~" .. tdy, 255, 255, 255, 255)
		    end
		--end
    end
end)