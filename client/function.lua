RegisterNetEvent('showNotification')
AddEventHandler('showNotification', function(text)
	ShowNotification(text)
end)
function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(0,1)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function GetCursorPosition()
    local cursorX, cursorY = GetControlNormal(0, 239), GetControlNormal(0, 240)
    return cursorX, cursorY
end



function drawTxt(x,y ,width,height,scale, text, r,g,b,a ,extra)
    SetTextFont(0)
    SetTextProportional(0)
	if extra then
		SetTextCentre(1)
	end
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY,notCenter)
         local px,py,pz=table.unpack(GetGameplayCamCoords())
         local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
         local scale = (1/dist)*20
         local fov = (1/GetGameplayCamFov())*100
         local scale = scale*fov   
         SetTextScale(scaleX*scale, scaleY*scale)
         SetTextFont(fontId)
         SetTextProportional(1)
         SetTextColour(250, 250, 250, 255)		-- You can change the text color here
         SetTextDropshadow(1, 1, 1, 1, 255)
         SetTextEdge(2, 0, 0, 0, 150)
         SetTextDropShadow()
         SetTextOutline()
         SetTextEntry("STRING")
         if notCenter == nil then
            SetTextCentre(1)
         end
         AddTextComponentString(textInput)
         SetDrawOrigin(x,y,z+2, 0)
         DrawText(0.0, 0.0)
         ClearDrawOrigin()
end

function createMarkerWithText(x,y,z,label,color)
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    if(Vdist(pos.x, pos.y, pos.z, x, y, z) < 8.0) then
        DrawMarker(1, x, y, z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5, color.r, color.g, color.b,color.a, 0, 0, 0,0)
        if(Vdist(pos.x, pos.y, pos.z, x, y, z) < 3.0) then
            DrawText3Ds(x, y, z, label)
        end
    end		
end

function DrawMissionText(m_text, showtime)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

function round(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function loadAnimDict(dict)
	while(not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(1)
	end
end


function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)

	-- TextEntry		-->	The Text above the typing field in the black square
	-- ExampleText		-->	An Example Text, what it should say in the typing field
	-- MaxStringLenght	-->	Maximum String Lenght

	AddTextEntry('FMMC_KEY_TIP1', TextEntry) --Sets the Text above the typing field in the black square
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght) --Actually calls the Keyboard Input
	blockinput = true --Blocks new input while typing if **blockinput** is used

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do --While typing is not aborted and not finished, this loop waits
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult() --Gets the result of the typing
		Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		blockinput = false --This unblocks new Input when typing is done
		return result --Returns the result
	else
		Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		blockinput = false --This unblocks new Input when typing is done
		return nil --Returns nil if the typing got aborted
	end
end

function DisplayInput()
    DisplayOnscreenKeyboard(1, "FMMC_MPM_TYP8", "", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(1)
    end
    if (GetOnscreenKeyboardResult()) then
        return tonumber(GetOnscreenKeyboardResult())
    end
end






-- useful for real





function GetPlayers()
  local players = {}
  	for i = 0, 31 do
      if NetworkIsPlayerActive(i) then
				table.insert(players, i)
			end
		end
	return players
end

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance
end

function getNearPlayer()
    local players = getPlayers()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local pos2
    local distance
    local minDistance = 3
    local playerNear
    for _, player in pairs(players) do
        pos2 = GetEntityCoords(GetPlayerPed(player))
        distance = GetDistanceBetweenCoords(pos["x"], pos["y"], pos["z"], pos2["x"], pos2["y"], pos2["z"], true)
        if (pos ~= pos2 and distance < minDistance) then
            playerNear = player
            minDistance = distance
        end
    end
    if (minDistance < 3) then
        return playerNear
    end
end



function VehicleInFront()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 4.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
    return result
end

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

function getVehicleAtCertainRange(x,y,z,radius)
    for i = 1,  71 do
        local angle = (i * 5) * math.pi / 180

        local sx = (50.0 * math.cos(angle)) + x
        local sy = (50.0 * math.sin(angle)) + y

        local ex = x - (sx - x)
        local ey = y - (sy - y)

        local rayHandle = StartShapeTestCapsule(sx, sy, z, ex, ey, z, radius, 10, PlayerPedId(), 1000)

        local ent = GetShapeTestResult(rayHandle, false)[4]

        return ent
    end
end

function GetNearbyPeds(X, Y, Z, Radius)
	local NearbyPeds = {}
	if tonumber(X) and tonumber(Y) and tonumber(Z) then
		if tonumber(Radius) then
			for Ped in EnumeratePeds() do
				if DoesEntityExist(Ped) then
					local PedPosition = GetEntityCoords(Ped, false)
					if Vdist(X, Y, Z, PedPosition.x, PedPosition.y, PedPosition.z) <= Radius then
						table.insert(NearbyPeds, Ped)
					end
				end
			end
		else
			Log.Warn("GetNearbyPeds was given an invalid radius!")
		end
	else
		Log.Warn("GetNearbyPeds was given invalid coordinates!")
	end
	return NearbyPeds
end

function getNpcFromPedArray(tble)
    local arrayPreUse = tble
    local newArray = {}
    for i = 1 , #arrayPreUse do
        local pedType = GetPedType(arrayPreUse[i])
        if pedType == 28 or IsPedAPlayer(arrayPreUse[i]) then
            arrayPreUse[i] = nil
        end
    end
    --//Clean clear player and animal generator 
    local npcArray = {}
    for i = 1, # arrayPreUse do
        if arrayPreUse[i] ~= nil then
            table.insert(newArray, arrayPreUse[i])
        end
    end
    return newArray
end

function getDriverNpcFromPedArray(tble)
    local arrayPreUse = tble
    local newArray = {}
    for i = 1 , #arrayPreUse do
        local pedType = GetPedType(arrayPreUse[i])
        local NpcCar = GetVehiclePedIsIn(arrayPreUse[i], false)
        if pedType == 28 or IsPedAPlayer(arrayPreUse[i]) or GetPedInVehicleSeat( NpcCar, -1 ) ~= arrayPreUse[i] then
            arrayPreUse[i] = nil
        end
    end
    --//Clean clear player and animal generator 
    local npcArray = {}
    for i = 1, # arrayPreUse do
        if arrayPreUse[i] ~= nil then
            table.insert(newArray, arrayPreUse[i])
        end
    end
    return newArray
end


function updatePedLook(isUniform)
    if not isUniform then
                -- Look --
                ---*Shity*---
        SetPedComponentVariation(GetPlayerPed(-1), clothesIndex[playerData.GENDER].SHIRTS[playerData.APPEARANCE.SHIRT].INDEX[1], clothesIndex[playerData.GENDER].SHIRTS[playerData.APPEARANCE.SHIRT].INDEX[2], clothesIndex[playerData.GENDER].SHIRTS[playerData.APPEARANCE.SHIRT].INDEX[3], 2)
        SetPedComponentVariation(GetPlayerPed(-1), clothesIndex[playerData.GENDER].SHIRTS[playerData.APPEARANCE.SHIRT].ACS[1], clothesIndex[playerData.GENDER].SHIRTS[playerData.APPEARANCE.SHIRT].ACS[2], clothesIndex[playerData.GENDER].SHIRTS[playerData.APPEARANCE.SHIRT].ACS[3], 2)
        SetPedComponentVariation(GetPlayerPed(-1), clothesIndex[playerData.GENDER].SHIRTS[playerData.APPEARANCE.SHIRT].ARM[1], clothesIndex[playerData.GENDER].SHIRTS[playerData.APPEARANCE.SHIRT].ARM[2], clothesIndex[playerData.GENDER].SHIRTS[playerData.APPEARANCE.SHIRT].ARM[3], 2)
                --*Pant*--
        SetPedComponentVariation(GetPlayerPed(-1), clothesIndex[playerData.GENDER].PANTS[playerData.APPEARANCE.PANT].INDEX[1], clothesIndex[playerData.GENDER].PANTS[playerData.APPEARANCE.PANT].INDEX[2], clothesIndex[playerData.GENDER].PANTS[playerData.APPEARANCE.PANT].INDEX[3], 2)
                --*Shoe*--
        SetPedComponentVariation(GetPlayerPed(-1), clothesIndex[playerData.GENDER].SHOES[playerData.APPEARANCE.SHOE].INDEX[1], clothesIndex[playerData.GENDER].SHOES[playerData.APPEARANCE.SHOE].INDEX[2], clothesIndex[playerData.GENDER].SHOES[playerData.APPEARANCE.SHOE].INDEX[3], 2)
    else
        if playerData.UNIFORM ~= "NONE" then
            SetPedComponentVariation(GetPlayerPed(-1), uniformIndex[playerData.GENDER][playerTempData.UNIFORM].SHIRT.INDEX[1], uniformIndex[playerData.GENDER][playerTempData.UNIFORM].SHIRT.INDEX[2], uniformIndex[playerData.GENDER][playerTempData.UNIFORM].SHIRT.INDEX[3], 2)
            SetPedComponentVariation(GetPlayerPed(-1), uniformIndex[playerData.GENDER][playerTempData.UNIFORM].SHIRT.ACS[1], uniformIndex[playerData.GENDER][playerTempData.UNIFORM].SHIRT.ACS[2], uniformIndex[playerData.GENDER][playerTempData.UNIFORM].SHIRT.ACS[3], 2)
            SetPedComponentVariation(GetPlayerPed(-1), uniformIndex[playerData.GENDER][playerTempData.UNIFORM].SHIRT.ARM[1], uniformIndex[playerData.GENDER][playerTempData.UNIFORM].SHIRT.ARM[2], uniformIndex[playerData.GENDER][playerTempData.UNIFORM].SHIRT.ARM[3], 2)  

            SetPedComponentVariation(GetPlayerPed(-1),  uniformIndex[playerData.GENDER][playerTempData.UNIFORM].PANT.INDEX[1],  uniformIndex[playerData.GENDER][playerTempData.UNIFORM].PANT.INDEX[2],  uniformIndex[playerData.GENDER][playerTempData.UNIFORM].PANT.INDEX[3], 2)

            SetPedComponentVariation(GetPlayerPed(-1),  uniformIndex[playerData.GENDER][playerTempData.UNIFORM].SHOE.INDEX[1],  uniformIndex[playerData.GENDER][playerTempData.UNIFORM].SHOE.INDEX[2],  uniformIndex[playerData.GENDER][playerTempData.UNIFORM].SHOE.INDEX[3], 2)
        end      
    end

end

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end