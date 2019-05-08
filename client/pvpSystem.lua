--local isPlayingPvp = false
local pvpWith = nil

pvpLoc = {
    {x=-3126.1403808594,y=193.19599914551,z=3.9782049655914,heading=204.98210144043}, -- random-1
    {x=-3135.6218261719,y=184.60066223145,z=3.9782047271729,heading=296.01486206055}, -- random-2
    {x=-3128.5983886719,y=177.25086975098,z=3.9782044887543,heading=115.49186706543}, -- random-3
    {x=-3138.4621582031,y=168.48596191406,z=3.9782047271729,heading=27.299240112305}, -- random-4
}


local allWeapons = {"WEAPON_KNIFE","WEAPON_KNUCKLE","WEAPON_NIGHTSTICK","WEAPON_HAMMER","WEAPON_BAT","WEAPON_GOLFCLUB","WEAPON_CROWBAR","WEAPON_BOTTLE","WEAPON_DAGGER","WEAPON_HATCHET","WEAPON_MACHETE","WEAPON_FLASHLIGHT","WEAPON_SWITCHBLADE","WEAPON_PISTOL","WEAPON_PISTOL_MK2","WEAPON_COMBATPISTOL","WEAPON_APPISTOL","WEAPON_PISTOL50","WEAPON_SNSPISTOL","WEAPON_HEAVYPISTOL","WEAPON_VINTAGEPISTOL","WEAPON_STUNGUN","WEAPON_FLAREGUN","WEAPON_MARKSMANPISTOL","WEAPON_REVOLVER","WEAPON_MICROSMG","WEAPON_SMG","WEAPON_SMG_MK2","WEAPON_ASSAULTSMG","WEAPON_MG","WEAPON_COMBATMG","WEAPON_COMBATMG_MK2","WEAPON_COMBATPDW","WEAPON_GUSENBERG","WEAPON_MACHINEPISTOL","WEAPON_ASSAULTRIFLE","WEAPON_ASSAULTRIFLE_MK2","WEAPON_CARBINERIFLE","WEAPON_CARBINERIFLE_MK2","WEAPON_ADVANCEDRIFLE","WEAPON_SPECIALCARBINE","WEAPON_BULLPUPRIFLE","WEAPON_COMPACTRIFLE","WEAPON_PUMPSHOTGUN","WEAPON_SAWNOFFSHOTGUN","WEAPON_BULLPUPSHOTGUN","WEAPON_ASSAULTSHOTGUN","WEAPON_MUSKET","WEAPON_HEAVYSHOTGUN","WEAPON_DBSHOTGUN","WEAPON_SNIPERRIFLE","WEAPON_HEAVYSNIPER","WEAPON_HEAVYSNIPER_MK2","WEAPON_MARKSMANRIFLE","WEAPON_GRENADELAUNCHER","WEAPON_GRENADELAUNCHER_SMOKE","WEAPON_RPG","WEAPON_STINGER","WEAPON_MINIGUN","WEAPON_FIREWORK","WEAPON_RAILGUN","WEAPON_HOMINGLAUNCHER","WEAPON_GRENADE","WEAPON_STICKYBOMB","WEAPON_PROXMINE","WEAPON_BZGAS","WEAPON_SMOKEGRENADE","WEAPON_MOLOTOV","WEAPON_FIREEXTINGUISHER","WEAPON_PETROLCAN","WEAPON_SNOWBALL","WEAPON_FLARE","WEAPON_BALL"}

-- Equip/Remove weapon.
function toggleWeaponEquipped(weaponName)
    local weapon = GetHashKey(weaponName)
	playerPed = GetPlayerPed(-1)
    if(HasPedGotWeapon(playerPed, weapon, 0))then
        RemoveWeaponFromPed(playerPed, weapon)
        --drawNotification("Weapon Removed")
    else
        local ammoType = GetPedAmmoType(playerPed, weapon)
        local ammoAmmount = GetPedAmmoByType(playerPed, ammoType)

        local addClip = GetMaxAmmoInClip(playerPed, weapon, 1)
        if(ammoAmmount == 0) then
            GiveWeaponToPed(playerPed, weapon, addClip, true, true)
            --drawNotification("Weapon Added")
            return
        elseif(ammoAmmount < addClip) then
            SetPedAmmoByType(playerPed, ammoType, addClip)
        end
        GiveWeaponToPed(playerPed, weapon, 9999, true, true)
        --drawNotification("Weapon Added")
    end
end


-- Ensure they have the weapon.
function forceHasWeapon(weaponName)
	playerPed = GetPlayerPed(-1)
    if(HasPedGotWeapon(playerPed, GetHashKey(weaponName)) == false)then
        toggleWeaponEquipped(weaponName)
    end

end

-- Add All Weapons
function addAllWeapons()
    for i,v in ipairs(allWeapons) do
        forceHasWeapon(v)
    end 
end

RegisterNetEvent("stopPvp")
AddEventHandler("stopPvp", function()
    pvpWith = nil
    isPlayingPvp = false
    SetPedCanSwitchWeapon(PlayerPedId(), false)
    RemoveAllPedWeapons(PlayerId(),true)
end)

RegisterNetEvent("pvpInvite")
AddEventHandler("pvpInvite", function(name,requesterid)
    --pvpWith = requesterid
    TriggerEvent("confirmMenuCreate", name .. " want to pvp duel with you!","acceptPvp",requesterid)
end)

RegisterNetEvent("inviteSuccess")
AddEventHandler("inviteSuccess", function(acceptid)
    pvpWith = acceptid
    isPlayingPvp = true
    SetPedCanSwitchWeapon(PlayerPedId(), true)
    TriggerEvent("addAllWeapons")
    math.randomseed(GetGameTimer())
    math.random(); math.random(); math.random()
    local randomSelect = math.random(1,#pvpLoc)
    SetEntityCoords(GetPlayerPed(-1), pvpLoc[randomSelect].x, pvpLoc[randomSelect].y, pvpLoc[randomSelect].z, 1, 0, 0, 1)
    Citizen.Wait(1000)  
    SetEntityHeading(GetPlayerPed(-1), pvpLoc[randomSelect].heading) 
end)

AddEventHandler('addAllWeapons', function()
	RemoveAllPedWeapons(PlayerId(),true)
	addAllWeapons()
	TriggerEvent("chatMessage", "^0[^2 🔫 Weapon PVP ^0] ", {1,170,0}, "You've recieved weapons for pvp")
end)

function acceptPvp(id)
    pvpWith = id
    TriggerServerEvent("regisPlayerToPvp", id)
    isPlayingPvp = true
    SetPedCanSwitchWeapon(PlayerPedId(), true)
    TriggerEvent("addAllWeapons")
    math.randomseed(GetGameTimer())
    math.random(); math.random(); math.random()
    local randomSelect = math.random(1,#pvpLoc)
    SetEntityCoords(GetPlayerPed(-1), pvpLoc[randomSelect].x, pvpLoc[randomSelect].y, pvpLoc[randomSelect].z, 1, 0, 0, 1)
    Citizen.Wait(1000)  
    SetEntityHeading(GetPlayerPed(-1), pvpLoc[randomSelect].heading) 
end

-- killer finder
Citizen.CreateThread(function()
	local Killer

	while true do
		Citizen.Wait(0)
		if IsEntityDead(PlayerPedId()) and pvpWith ~= -1 then
			Citizen.Wait(500)
			TriggerServerEvent('pvpScoreUpdate', pvpWith)
			--startrespawnnow()
		end
		while IsEntityDead(PlayerPedId()) do
			Citizen.Wait(0)
		end
	end
end)