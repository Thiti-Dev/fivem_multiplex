local loginAs = nil
local alreadyIn = false
local currentUsername = nil
local currentPassword = nil
local currentCharacterName = nil
local currentStep = 1
local currentStepLogin = 1
local attemptLogin = false
local cam = -1
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if loginAs ~= nil then
            --TriggerEvent("chatMessage", "[Username-check]", {255, 0, 0}, tostring(loginAs))
			TriggerServerEvent("onRegisterCheckExist", tostring(loginAs))
			currentUsername = tostring(loginAs)
			loginAs = nil
			--alreadyIn = false
		elseif currentPassword ~= nil and currentCharacterName == nil and currentStep == 2 then
			currentStep = 3
			currentCharacterName = KeyboardInput("Enter your Character Name", "", 20)
		elseif currentPassword ~= nil and currentCharacterName ~= nil and currentStep == 3 then
			TriggerServerEvent("onRegisterAppend", tostring(currentUsername), tostring(currentPassword), tostring(currentCharacterName))
			currentUsername = nil
			currentPassword = nil
			currentCharacterName = nil
			currentStep = 1
			--registerDone doing check
		end

		if attemptLogin then
			if currentUsername ~= nil and currentStepLogin == 2 then
				currentStepLogin = 3
				currentPassword = KeyboardInput("Enter password", "", 20)
			elseif currentUsername ~= nil and currentPassword ~= nil and currentStepLogin == 3 then	
				TriggerServerEvent("onLoginAppend", tostring(currentUsername), tostring(currentPassword))
				currentStepLogin = 1
				attemptLogin = false
				currentUsername = nil
				currentPassword = nil
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if not playerData.LOGGEDIN then
			if IsControlJustPressed(1, 38) then
				if GetDistanceBetweenCoords( 11.936089515686, -1108.482421875, 29.797029495239, GetEntityCoords(GetPlayerPed(-1))) < 1.0 then
					setDef()
					loginAs = KeyboardInput("Enter username you want to use", "", 20)
					--alreadyIn = true
				elseif GetDistanceBetweenCoords( 13.727068901062, -1107.1080322266, 29.797029495239, GetEntityCoords(GetPlayerPed(-1))) < 1.0 then
					setDef()
					currentUsername = KeyboardInput("Enter username", "", 20)
					attemptLogin = true
					currentStepLogin = 2
					--alreadyIn = true				
				end
			end
		end
	end
end)



RegisterNetEvent("onRegister")
AddEventHandler("onRegister", function()
    --TriggerEvent("chatMessage", "[Data Check]", {255, 0, 0}, "Finally Work")
    loginAs = KeyboardInput("Enter your username", "", 20)
end)

RegisterNetEvent("onRegisterLast")
AddEventHandler("onRegisterLast", function(username)
	TriggerEvent("chatMessage", "^0[^a 🔗 System ^0] ", {1,170,0}, "You can use " .. username .. " for the username ;D")
	currentStep = 2
	currentPassword = KeyboardInput("Enter your password", "", 20)
end)

RegisterNetEvent("onLoginSuccess")
AddEventHandler("onLoginSuccess", function(tablepref)
	DoScreenFadeOut(500)



	-- Adjust variable
	playerData.CHARACTER_NAME = tablepref.character_name
	TriggerServerEvent("onLoadInventory", playerData.CHARACTER_NAME)
	TriggerServerEvent("onLoadVehicle", playerData.CHARACTER_NAME)
	TriggerServerEvent("onLoadApartment", playerData.CHARACTER_NAME)
	TriggerEvent("onLoadInstance")
	--playerData.LOGGEDIN = true

	local pos = stringsplit(tablepref.position, ":")
	playerData.X = tonumber(pos[1])
	playerData.Y = tonumber(pos[2])
	playerData.Z = tonumber(pos[3])
	playerData.HEADING = tonumber(pos[4])

	playerData.APPEARANCE.FACE = tablepref.face
	playerData.APPEARANCE.HAIR = tablepref.hair
	playerData.APPEARANCE.SHIRT = tablepref.shirt
	playerData.APPEARANCE.PANT = tablepref.pant
	playerData.APPEARANCE.SHOE = tablepref.shoe
	playerData.GENDER = tablepref.gender
	playerData.MONEY = tonumber(tablepref.money)
	playerData.JOB = tablepref.job
	playerTempData.INSIDE = tablepref.inside

	local lvl = stringsplit(tablepref.level, ":")

	playerData.LEVEL = tonumber(lvl[1])
	playerData.EXP = tonumber(lvl[2])

	TriggerEvent("genarateCriminalIntoArray", tablepref.criminal)

	playerData.jailTime = tablepref.jailtime

	TriggerEvent("chatMessage", "Debug ", {105,7,73}, "LEVEL : " .. lvl[1] .. " EXP :  " .. lvl[2])

	Citizen.Trace("playerData = " .. json.encode(tablepref))
	playerData.LOGGEDIN = true


	-- Adjust how player looks --
	if playerData.GENDER ~= "NONE" then
		TriggerEvent("chatMessage", "Data-Load ", {45,209,171}, "Loading how you look ;D")
		adjustLooks()
		if tablepref.isdead == 0 then
			TriggerEvent("freezeAdjust")
			Citizen.Wait(1000)
			SetEntityCoords(GetPlayerPed(-1), playerData.X, playerData.Y, playerData.Z, 1, 0, 0, 1)
			Citizen.Wait(1500)
			--TriggerEvent("safeStartCheck")
			DoScreenFadeIn(4000)   
		else
			TriggerEvent("freezeAdjustExpert")
			Citizen.Wait(1000)
			SetEntityCoords(GetPlayerPed(-1), playerData.X, playerData.Y, playerData.Z + 2.0, 1, 0, 0, 1)
			Citizen.Wait(1500)
			--TriggerEvent("safeStartCheck")
		end
		SetEntityHeading(GetPlayerPed(-1), playerData.HEADING)
		--disable from switching
		SetPedCanSwitchWeapon(PlayerPedId(), false)
		TriggerEvent("safeStartCheck")
		TriggerEvent("safeJailCheck")
		TriggerEvent("startPayday")
	else
		TriggerEvent("chatMessage", "^0[^a 🔗 System ^0] ", {1,170,0}, "You're new , feel free to try the dress")
		TriggerEvent("onSetCustomization")
		FreezeEntityPosition(GetPlayerPed(-1), true)
		Citizen.Wait(1000)
		SetEntityCoords(GetPlayerPed(-1), 149.33555603027, -996.50286865234, -60.690540313721 - 0.95, 1, 0, 0, 1)
		Citizen.Wait(1500)
		DoScreenFadeIn(4000)   
		SetEntityHeading(GetPlayerPed(-1), 337.81301879883)
		startCam()
		TriggerEvent("safeStartCheck")
		TriggerEvent("safeJailCheck")
		TriggerEvent("startPayday")
	end

end)

RegisterNetEvent("removeCam")
AddEventHandler("removeCam", function()
	if(DoesCamExist(cam)) then
		RenderScriptCams(false, false, 0, 1, 0)
		DestroyCam(cam, false)
	end
end)

RegisterNetEvent("onLoadInvSuccess")
AddEventHandler("onLoadInvSuccess", function(tablepref)
	TriggerEvent("chatMessage", "Debug ", {105,7,73}, #tablepref .. " items loaded into inventory")

	if #tablepref > 0 then
		for _,x in ipairs(tablepref) do
			table.insert(playerData.INVENTORY, {Name=x.item_name,Amount=x.amount})
		end
	end

	playerData.LOADINV = true
end)

RegisterNetEvent("onLoadCarSuccess")
AddEventHandler("onLoadCarSuccess", function(tablepref)
	TriggerEvent("chatMessage", "Debug ", {105,7,73}, #tablepref .. " vehicles loaded [ YOUR PRESONALCAR ]")

	if #tablepref > 0 then
		for _,x in ipairs(tablepref) do
			table.insert(playerVehicles, {PLATE=x.plate,MODEL=x.model,COLORS=x.colors,MODS=x.mods,NEONS=x.neon,BW=x.bvw})
		end
	end
end)


RegisterNetEvent("onLoadApsSuccess")
AddEventHandler("onLoadApsSuccess", function(tablepref)
	TriggerEvent("chatMessage", "Debug ", {105,7,73}, #tablepref .. " apartments loaded [ YOUR APARTMENT ]")

	if #tablepref > 0 then
		for _,x in ipairs(tablepref) do
			playerApartments[x.place] = {EXPIRED=x.expired,INVENTORY={}}
			--table.insert(playerApartments, {PLACE=x.place,INVENTORY={},EXPIRED=x.expired})
		end
	end

	for _ , x in pairs(playerApartments) do
		TriggerServerEvent("onLoadApartmentInv", playerData.CHARACTER_NAME, _)
	end
end)

RegisterNetEvent("onLoadApsInvSuccess")
AddEventHandler("onLoadApsInvSuccess", function(tablepref)
	Citizen.Trace("LOAD INV SUCCESS")
	local currentPlace = nil
	for _, x in ipairs(tablepref) do
		if currentPlace == nil then
			currentPlace = x.place
		end
		table.insert(playerApartments[x.place].INVENTORY, {Name=x.item_name,Amount=x.amount})
	end

	if #tablepref > 0 then
		TriggerEvent("chatMessage", "Debug ", {105,7,73}, #tablepref .. " item loaded [ " .. currentPlace .. " ]")
		Citizen.Trace(json.encode(playerApartments[currentPlace].INVENTORY))
	else
		TriggerEvent("chatMessage", "Debug ", {105,7,73}, "No item load [ Apartment Store ]")
	end
end)


function startCam()
	if not DoesCamExist(cam) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

		SetCamCoord(cam, 150.52537536621,-995.12145996094,-60.702690124512 + 0.8)
		SetCamRot(cam, -20.5, 0.0, 135.77674865723)
		SetCamActive(cam,  true)
        RenderScriptCams(true,  false,  0,  true,  true)    
        
        SetCamCoord(cam, 150.52537536621,-995.12145996094,-60.702690124512 + 0.8)
    end
end

function adjustLooks()

	if playerData.GENDER == "MALE" then
		local modelhashed = GetHashKey("mp_m_freemode_01")
		RequestModel(modelhashed)
		while not HasModelLoaded(modelhashed) do 
			RequestModel(modelhashed)
			Citizen.Wait(0)
		end
		SetPlayerModel(PlayerId(), modelhashed)
	else
		local modelhashed = GetHashKey("mp_f_freemode_01")
		RequestModel(modelhashed)
		while not HasModelLoaded(modelhashed) do 
			RequestModel(modelhashed)
			Citizen.Wait(0)
		end
		SetPlayerModel(PlayerId(), modelhashed)   
	end

	local faceTemp = stringsplit(playerData.APPEARANCE.FACE, ":")
	local hairTemp = stringsplit(playerData.APPEARANCE.HAIR, ":")

	--//////////////////////////---

	SetPedComponentVariation(GetPlayerPed(-1), tonumber(faceTemp[1]),tonumber(faceTemp[2]),tonumber(faceTemp[3]), 2)
	SetPedComponentVariation(GetPlayerPed(-1), tonumber(hairTemp[1]),tonumber(hairTemp[2]),tonumber(hairTemp[3]), 2)
			-- Look --
			---*Shity*---
	SetPedComponentVariation(GetPlayerPed(-1), clothesIndex[playerData.GENDER].SHIRTS[playerData.APPEARANCE.SHIRT].INDEX[1], clothesIndex[playerData.GENDER].SHIRTS[playerData.APPEARANCE.SHIRT].INDEX[2], clothesIndex[playerData.GENDER].SHIRTS[playerData.APPEARANCE.SHIRT].INDEX[3], 2)
	SetPedComponentVariation(GetPlayerPed(-1), clothesIndex[playerData.GENDER].SHIRTS[playerData.APPEARANCE.SHIRT].ACS[1], clothesIndex[playerData.GENDER].SHIRTS[playerData.APPEARANCE.SHIRT].ACS[2], clothesIndex[playerData.GENDER].SHIRTS[playerData.APPEARANCE.SHIRT].ACS[3], 2)
	SetPedComponentVariation(GetPlayerPed(-1), clothesIndex[playerData.GENDER].SHIRTS[playerData.APPEARANCE.SHIRT].ARM[1], clothesIndex[playerData.GENDER].SHIRTS[playerData.APPEARANCE.SHIRT].ARM[2], clothesIndex[playerData.GENDER].SHIRTS[playerData.APPEARANCE.SHIRT].ARM[3], 2)
			--*Pant*--
	SetPedComponentVariation(GetPlayerPed(-1), clothesIndex[playerData.GENDER].PANTS[playerData.APPEARANCE.PANT].INDEX[1], clothesIndex[playerData.GENDER].PANTS[playerData.APPEARANCE.PANT].INDEX[2], clothesIndex[playerData.GENDER].PANTS[playerData.APPEARANCE.PANT].INDEX[3], 2)
			--*Shoe*--
	SetPedComponentVariation(GetPlayerPed(-1), clothesIndex[playerData.GENDER].SHOES[playerData.APPEARANCE.SHOE].INDEX[1], clothesIndex[playerData.GENDER].SHOES[playerData.APPEARANCE.SHOE].INDEX[2], clothesIndex[playerData.GENDER].SHOES[playerData.APPEARANCE.SHOE].INDEX[3], 2)

end


function setDef()
	loginAs = nil
	alreadyIn = false
	currentUsername = nil
	currentPassword = nil
	currentCharacterName = nil
	currentStep = 1
	currentStepLogin = 1
	attemptLogin = false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if playerData.GENDER == "NONE" then
			for i=0, 32, 1 do
                local otherPlayerPed = GetPlayerPed(i)
                if otherPlayerPed ~= PlayerPedId() then
                    SetEntityLocallyInvisible(otherPlayerPed)
                    SetEntityNoCollisionEntity(PlayerPedId(), otherPlayerPed, true)
                end
            end
            --NetworkSetVoiceChannel(playerTempData.INSIDE .. ":" .. playerData.CHARACTER_NAME)
        else
            --NetworkClearVoiceChannel()
        end
    end
end)



function startNewbieCheck()
	Citizen.Trace("--------------Start newbie position fixed check------------")
	Citizen.CreateThread(function()
		while not playerData.LOGGEDIN do
			Citizen.Wait(1000)
			if not playerData.LOGGEDIN then
				if GetDistanceBetweenCoords( 12.805219650269, -1110.0535888672, 29.797018051147, GetEntityCoords(GetPlayerPed(-1))) > 5.0 then  
					Citizen.Trace("You're out of radius of the login point") 
					TriggerEvent("freezeAdjust")
					DoScreenFadeOut(200)
					SetEntityCoords(GetPlayerPed(-1), 13.432950019836, -1112.5704345703, 29.797008514404, 1, 0, 0, 1)
					Citizen.Wait(2500)
					DoScreenFadeIn(1000)   
					SetEntityHeading(GetPlayerPed(-1), 340.65362548828)
				end
			end
		end
	end)
end