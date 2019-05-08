
local readyForAdjust = false


function hasdecimal(amount)
if amount ~= math.floor(amount) then
   return true
else
   return false
end
end

function SecondsToClock(seconds)
  local seconds = tonumber(seconds)

  if seconds <= 0 then
    return "00", "00", "00"
  else
    local hours = string.format("%02.f", math.floor(seconds/3600));
    local mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    local secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
    --return hours..":"..mins..":"..secs
	return hours,mins,secs
  end
end




RegisterNetEvent('RPD:allowRespawn')
RegisterNetEvent('RPD:allowRevive') 
RegisterNetEvent('RPD:toggleDeath')

local curm = 0
local curs = 0
local timeleft = 0

--local reviveWaitPeriod = 300 -- How many seconds to wait before allowing player to revive themselves
local RPDeathEnabled = true  -- Is RPDeath enabled by default? (/toggleDeath changes this value.)



-- Turn off automatic respawn here instead of updating FiveM file.
AddEventHandler('onClientMapStart', function()
	Citizen.Trace("RPDeath: Disabling autospawn...")
	exports.spawnmanager:spawnPlayer() -- Ensure player spawns into server.
	Citizen.Wait(2500)
	exports.spawnmanager:setAutoSpawn(false)
	Citizen.Trace("RPDeath: Autospawn disabled!")
	--TriggerEvent('playerSpawned', 13.432950019836, -1112.5704345703, 29.797008514404, 340.65362548828)
end)


local allowRespawn = false
--local allowRevive = false
--local diedTime = nil


AddEventHandler('RPD:allowRespawnPvp', function()
	allowRespawn = true
	Wait(2000)
	DoScreenFadeIn(800)
end)


AddEventHandler('RPD:allowRespawn', function(from)
	TriggerEvent('chatMessage', "System ", {1,170,0}, "You've been respawn")
	allowRespawn = true
end)


--[[AddEventHandler('RPD:allowRevive', function(from)
	if(not IsEntityDead(GetPlayerPed(-1)))then
		-- You are alive, do nothing.
		return
	end

	-- Trying to revive themselves?
	if(GetPlayerServerId(PlayerId()) == from and diedTime ~= nil)then
		local waitPeriod = diedTime + (reviveWaitPeriod * 1000)
		if(GetGameTimer() < waitPeriod)then
			local seconds = math.ceil((waitPeriod - GetGameTimer()) / 1000)
			local message = ""
			if(seconds > 60)then
				local minutes = math.floor((seconds / 60))
				seconds = math.ceil(seconds-(minutes*60))
				message = minutes.." minutes "
			end
			message = message..seconds.." seconds"
			TriggerEvent('chatMessage', "RPDeath", {200,0,0}, "You must wait before reviving yourself, you have ^5"..message.."^0 remaining.")
			return		
		end
	end

	-- Revive the player.
	TriggerEvent('chatMessage', "RPDeath", {200,0,0}, "Revived")
	allowRevive = true
end)]]

--[[AddEventHandler('RPD:toggleDeath', function(from)
	RPDeathEnabled = not RPDeathEnabled
	if (RPDeathEnabled) then
		TriggerEvent('chatMessage', "RPDeath", {200,0,0}, "RPDeath enabled.")
	else
		TriggerEvent('chatMessage', "RPDeath", {200,0,0}, "RPDeath disabled.")
	end
end)]]



--[[function revivePed(ped)
	local playerPos = GetEntityCoords(ped, true)

	NetworkResurrectLocalPlayer(playerPos, true, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)
end]]


function respawnPed(ped,coords)
	DoScreenFadeOut(500)
	Citizen.Wait(600)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, true, false) 
	SetPlayerInvincible(ped, false) 
	TriggerEvent("freezeAdjust")
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z, coords.heading)
	ClearPedBloodDamage(ped)
	Citizen.Wait(2000)
	DoScreenFadeIn(1000)   
end


Citizen.CreateThread(function()
	local respawnCount = 0
	local spawnPoints = {}
	local playerIndex = NetworkGetPlayerIndex(-1) or 0


	math.randomseed(playerIndex)

	function createSpawnPoint(x1,x2,y1,y2,z,heading)
		local xValue = math.random(x1,x2) + 0.0001
		local yValue = math.random(y1,y2) + 0.0001

		local newObject = {
			x = xValue,
			y = yValue,
			z = z + 0.0001,
			heading = heading + 0.0001
		}
		table.insert(spawnPoints,newObject)
	end

	createSpawnPoint(-448, -448, -340, -329, 35.5, 0) -- Mount Zonah
	createSpawnPoint(372, 375, -596, -594, 30.0, 0)   -- Pillbox Hill
	createSpawnPoint(335, 340, -1400, -1390, 34.0, 0) -- Central Los Santos
	createSpawnPoint(1850, 1854, 3700, 3704, 35.0, 0) -- Sandy Shores
	createSpawnPoint(-247, -245, 6328, 6332, 33.5, 0) -- Paleto
	--createSpawnPoint(1152, 1156, -1525, -1521, 34.9, 0) -- St. Fiacre

	while true do
		Wait(0)
		local ped = GetPlayerPed(-1)
		local plyPos = GetEntityCoords(ped,  true)
		if (RPDeathEnabled) then

			if (IsEntityDead(ped)) or playerTempData.DEADNOW then
				if not isPlayingPvp then
					if timeleft == 0 and playerTempData.DEADNOW == false then
						timeleft = 80
						playerTempData.DEADNOW = true
						TriggerServerEvent("updateDead", 1)
						Citizen.Wait(1500)
						NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
						Citizen.Wait(3000)
						NetworkResurrectLocalPlayer(plyPos, 0.0, true, false)
						ClearPedTasks(ped)
						Citizen.Wait(500)
						TriggerEvent('deadan')
						NetworkFadeInEntity(GetPlayerPed(-1), 0)
						readyForAdjust = true
					end
					
					if (allowRespawn) then 
						--local coords = spawnPoints[math.random(1,#spawnPoints)]
						TriggerServerEvent("updateDead", 0)
						local coords = {x=329.26327514648,y=-1434.6412353516,z=14.494749069214,heading=139.11828613281} 
						respawnPed(ped, coords)

						allowRespawn = false
						playerTempData.DEADNOW = false
						readyForAdjust = false
						timeleft = 0
						if DoesEntityExist(playerTempData.HOLDINGOBJECT) then
							DeleteObject(playerTempData.HOLDINGOBJECT) -- clear playerobject
						end
						playerData.HOLDING = "NONE" --// clearplayerholdingdata
						RemoveAllPedWeapons(PlayerId(),true) -- removeplayerweapon
						ClearPedTasksImmediately(ped) -- clear animation
						SetEntityHealth(ped,GetEntityMaxHealth(ped)) --// set entity to the max health
						--diedTime = nil
						respawnCount = respawnCount + 1
						math.randomseed( playerIndex * respawnCount )
						SetPedCanSwitchWeapon(PlayerPedId(), false) -- fix
					end
				else
					TriggerEvent("chatMessage", "^0[^2 🔫 PVP HELPER ^0] ", {1,170,0}, "wait for 4 second to be respawn")
					Citizen.Wait(1500)
					NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
					Citizen.Wait(3000)
					math.randomseed(GetGameTimer())
					math.random(); math.random(); math.random()
					local randomSelect = math.random(1,#pvpLoc)
					NetworkResurrectLocalPlayer(pvpLoc[randomSelect].x,pvpLoc[randomSelect].y,pvpLoc[randomSelect].z, pvpLoc[randomSelect].heading, true, false)
					ClearPedTasks(ped)
					Citizen.Wait(500)
					--TriggerEvent('deadan')
					NetworkFadeInEntity(GetPlayerPed(-1), 0)
					if isPlayingPvp then
						TriggerEvent("addAllWeapons")
					else
						SetPedCanSwitchWeapon(PlayerPedId(), false)
						RemoveAllPedWeapons(PlayerId(),true) -- removeplayerweapon
					end
				end
			end
		end
	end
end)

RegisterNetEvent("deadLoad")
AddEventHandler("deadLoad", function()
	timeleft = 80
	playerTempData.DEADNOW = true
	TriggerServerEvent("updateDead", 1)
	Citizen.Wait(1500)
	--NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
	--Citizen.Wait(3000)
	--NetworkResurrectLocalPlayer(plyPos, 0.0, true, false)
	ClearPedTasks(ped)
	Citizen.Wait(500)
	TriggerEvent('deadan')
	--NetworkFadeInEntity(GetPlayerPed(-1), 0)
	readyForAdjust = true
end)

RegisterNetEvent("deadan")
AddEventHandler("deadan", function()
	
	local playerPed = GetPlayerPed(-1)
	if DoesEntityExist(playerPed) then
		Citizen.CreateThread(function()
			RequestAnimDict("mini@cpr@char_b@cpr_str")
			while not HasAnimDictLoaded("mini@cpr@char_b@cpr_str") do
				Citizen.Wait(100)
			end
			
			if IsEntityPlayingAnim(playerPed, "mini@cpr@char_b@cpr_str", "cpr_fail", 3) then
				ClearPedSecondaryTask(playerPed)
				Citizen.Trace("INHERE WHERE I AM LOOKIN AT")
			else
				--TaskPlayAnim(playerPed, "dead", "dead_e", 1.0, 0.0, -1, 9, 9, 1, 1, 1)
				TaskPlayAnim(GetPlayerPed(-1), "mini@cpr@char_b@cpr_str", "cpr_fail", 5.0, -1, -1, 9, 0, false, false, false)
				GivePlayerRagdollControl(PlayerId(), false)
			end		
		end)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if playerTempData.DEADNOW then
			--local ped = GetPlayerPed(-1)
			--//fixed bug
			--//calculation
			--/////////////
			local h,m,s = SecondsToClock(timeleft)
			if timeleft < 60 then
				drawTxt(1.025, 1.274, 1.0,1.0,0.4, "~w~Please wait ~b~" .. m .. " ~w~minute and ~b~" .. s .. " ~w~seconds~n~Press ~r~[E] ~w~to respawn", 255, 255, 255, 255,true)
			else
				drawTxt(1.025, 1.274, 1.0,1.0,0.4, "~w~Please wait ~b~" .. m .. " ~w~minute and ~b~" .. s .. " ~w~seconds", 255, 255, 255, 255,true)
			end
			
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		if playerData.LOGGEDIN then
			if timeleft > 0 then
				timeleft = timeleft - 1
			end
			--//fixed bug
			if timeleft < 0 then
				timeleft = 0
			end

			--//check for animation flush event
			if playerTempData.DEADNOW and readyForAdjust then
				TriggerEvent('deadan')
			end

			--fixing the bug phase
			if IsEntityPlayingAnim(GetPlayerPed(-1), "dead", "dead_e", 3) and not playerTempData.DEADNOW then
				StopAnimTask(GetPlayerPed(-1), "dead","dead_e", 1.0) -- fixing bug
			end
			--end
		end
	end
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
		if playerData.LOGGEDIN then
			if IsControlJustPressed(1, 38) and playerTempData.DEADNOW and timeleft < 60 then
				allowRespawn = true
				--[[if DoesEntityExist(playerTempData.HOLDINGOBJECT) then
					DeleteObject(playerTempData.HOLDINGOBJECT)
				end
				playerData.HOLDING = "NONE"
				RemoveAllPedWeapons(PlayerId(),true)]]
			end
			if (IsEntityPlayingAnim(GetPlayerPed(-1), "dead", "dead_e", 3) and playerTempData.DEADNOW and readyForAdjust) or playerData.jailTime > 0 then
				SetPedCanRagdoll(GetPlayerPed(-1), false)
				GivePlayerRagdollControl(PlayerId(), false)
				SetEntityInvincible(GetPlayerPed(-1), true)
				SetPlayerInvincible(PlayerId(), true)
				SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), false)
				SetEntityCanBeDamaged(GetPlayerPed(-1), false)
				SetEntityProofs(GetPlayerPed(-1), true, true, true, true, true, true, true, true)
			else
				SetEntityInvincible(GetPlayerPed(-1), false)
				SetPlayerInvincible(PlayerId(), false)
				SetPedCanRagdoll(GetPlayerPed(-1), true)
				GivePlayerRagdollControl(PlayerId(), true)
				SetEntityProofs(GetPlayerPed(-1), false, false, false, false, false, false, false, false)
				SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), false)
				SetEntityCanBeDamaged(GetPlayerPed(-1), true)
			end
		else
			SetPedCanRagdoll(GetPlayerPed(-1), false)
			GivePlayerRagdollControl(PlayerId(), false)
			SetEntityInvincible(GetPlayerPed(-1), true)
			SetPlayerInvincible(PlayerId(), true)
			SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), false)
			SetEntityCanBeDamaged(GetPlayerPed(-1), false)
			SetEntityProofs(GetPlayerPed(-1), true, true, true, true, true, true, true, true)			
		end
    end
end)


RegisterNetEvent("onCpr")
AddEventHandler("onCpr", function(healerID)
	allowRespawn = false
	playerTempData.DEADNOW = false
	readyForAdjust = false
	timeleft = 0
	ClearPedTasksImmediately(PlayerPedId()) -- clear animation
	SetEntityHealth(PlayerPedId(),GetEntityMaxHealth(PlayerPedId())) --// set entity to the max health	
	TriggerServerEvent("callbackHealSuccess" , healerID)
	SetPedCanSwitchWeapon(PlayerPedId(), false) -- fix
	TriggerServerEvent("updateDead", 0)
end)