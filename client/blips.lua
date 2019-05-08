--///////////blip --161 - for around signal
local blips = {
    -- Example {title="", colour=, id=, x=, y=, z=},
	 {title="Spawn Point", colour=30, id=280, x = 214.0629119873, y = -918.81604003906, z = 30.69202041626},
	 --{title="Seven Eleven 7/11", colour=2, id=93, x = 26.432, y = -1347.334, z = 29.496},
	 {title="Admin House", colour=2, id=305, x = 397.37, y = -1240.2, z = 31.7365475},
	 {title="Job Center", colour=45, id=407, x=-268.61962890625,y=-957.13537597656,z=31.223134994507},
	 {title="Hospital", colour=45, id=51, x=-498.34057617188,y=-335.83627319336,z=34.501762390137},
	 {title="@_ APARTMENT : [ NEW SYSTEMS ] !", colour=45, id=350, x=269.25915527344,y=-640.60705566406,z=42.025890350342},

	 -- job --
	 {title="_JOB : WOOD CUTTER - work place", colour=45, id=457, x =-577.19604492188, y = 5334.51953125, z = 70.214492797852},
	 {title="_JOB : WOOD CUTTER - vehicle & hatchet [ BUY & RENT ]", colour=45, id=460, x=1200.5936279297,y=-1276.2464599609,z=35.224723815918},

	 {title="_JOB : PRO FISHING - MENU-INTERACT", colour=45, id=68, x=-1667.9873046875,y=-995.13903808594,z=8.1624460220337},
	{title="@_ Police Department", colour=45, id=60, x=441.03414916992,y=-981.56689453125,z=30.68959236145},
  }

Citizen.CreateThread(function()

	for _, info in pairs(blips) do
	  info.blip = AddBlipForCoord(info.x, info.y, info.z)
	  SetBlipSprite(info.blip, info.id)
	  SetBlipDisplay(info.blip, 4)
	  SetBlipScale(info.blip, 1.0)
	  SetBlipColour(info.blip, info.colour)
	  SetBlipAsShortRange(info.blip, true)
	  BeginTextCommandSetBlipName("STRING")
	  AddTextComponentString(info.title)
	  EndTextCommandSetBlipName(info.blip)
	end

	for _, gunLoc in pairs(gunLocation) do
			gunLoc.blip = AddBlipForCoord(gunLoc.x, gunLoc.y, gunLoc.z)
			SetBlipSprite(gunLoc.blip, 156)
			SetBlipDisplay(gunLoc.blip, 4)
			SetBlipScale(gunLoc.blip, 1.0)
			SetBlipColour(gunLoc.blip, 45)
			SetBlipAsShortRange(gunLoc.blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Weapon Shop")
			EndTextCommandSetBlipName(gunLoc.blip)
	end

	for _, foodLoc in pairs(foodLocation) do
		foodLoc.blip = AddBlipForCoord(foodLoc.x, foodLoc.y, foodLoc.z)
		SetBlipSprite(foodLoc.blip, 93)
		SetBlipDisplay(foodLoc.blip, 4)
		SetBlipScale(foodLoc.blip, 1.0)
		SetBlipColour(foodLoc.blip, 45)
		SetBlipAsShortRange(foodLoc.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("24/7 Foods&Drinks")
		EndTextCommandSetBlipName(foodLoc.blip)
	end

	for _, vehicleLoc in pairs(vehicleLocation) do
		vehicleLoc.blip = AddBlipForCoord(vehicleLoc.x, vehicleLoc.y, vehicleLoc.z)
		SetBlipSprite(vehicleLoc.blip, 326)
		SetBlipDisplay(vehicleLoc.blip, 4)
		SetBlipScale(vehicleLoc.blip, 1.0)
		SetBlipColour(vehicleLoc.blip, 45)
		SetBlipAsShortRange(vehicleLoc.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Vehicle shop")
		EndTextCommandSetBlipName(vehicleLoc.blip)
	end

	for _, recieveLoc in pairs(recieveLocation) do
		recieveLoc.blip = AddBlipForCoord(recieveLoc.x, recieveLoc.y, recieveLoc.z)
		SetBlipSprite(recieveLoc.blip, 50)
		SetBlipDisplay(recieveLoc.blip, 4)
		SetBlipScale(recieveLoc.blip, 1.0)
		SetBlipColour(recieveLoc.blip, 45)
		SetBlipAsShortRange(recieveLoc.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Vehicle Park Point")
		EndTextCommandSetBlipName(recieveLoc.blip)
	end

	for _, chopLoc in pairs(chopLocation) do
		chopLoc.blip = AddBlipForCoord(chopLoc.x, chopLoc.y, chopLoc.z)
		SetBlipSprite(chopLoc.blip, 274)
		SetBlipDisplay(chopLoc.blip, 4)
		SetBlipScale(chopLoc.blip, 1.0)
		SetBlipColour(chopLoc.blip, 9)
		SetBlipAsShortRange(chopLoc.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("_JOB : WOOD CUTTER - cut spot")
		EndTextCommandSetBlipName(chopLoc.blip)
	end

	for _, shopLoc in pairs(shopLocation) do
		shopLoc.blip = AddBlipForCoord(shopLoc.x, shopLoc.y, shopLoc.z)
		SetBlipSprite(shopLoc.blip, 120)
		SetBlipDisplay(shopLoc.blip, 4)
		SetBlipScale(shopLoc.blip, 1.0)
		SetBlipColour(shopLoc.blip, 45)
		SetBlipAsShortRange(shopLoc.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("_JOB : SHOP KEEPER - work@place")
		EndTextCommandSetBlipName(shopLoc.blip)
	end

	for _, repairLoc in pairs(repairLocation) do
		repairLoc.blip = AddBlipForCoord(repairLoc.x, repairLoc.y, repairLoc.z)
		SetBlipSprite(repairLoc.blip, 147)
		SetBlipDisplay(repairLoc.blip, 4)
		SetBlipScale(repairLoc.blip, 1.0)
		SetBlipColour(repairLoc.blip, 45)
		SetBlipAsShortRange(repairLoc.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("_JOB : REPAIR MAN - work@place")
		EndTextCommandSetBlipName(repairLoc.blip)
	end

	for _, taxiLoc in pairs(taxiLocation) do
		taxiLoc.blip = AddBlipForCoord(taxiLoc.x, taxiLoc.y, taxiLoc.z)
		SetBlipSprite(taxiLoc.blip, 198)
		SetBlipDisplay(taxiLoc.blip, 4)
		SetBlipScale(taxiLoc.blip, 1.0)
		SetBlipColour(taxiLoc.blip, 45)
		SetBlipAsShortRange(taxiLoc.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("_JOB : TAXI DRIVER - work@place")
		EndTextCommandSetBlipName(taxiLoc.blip)
	end

	for _, postalLoc in pairs(postalLocation) do
		postalLoc.blip = AddBlipForCoord(postalLoc.x, postalLoc.y, postalLoc.z)
		SetBlipSprite(postalLoc.blip, 85)
		SetBlipDisplay(postalLoc.blip, 4)
		SetBlipScale(postalLoc.blip, 1.0)
		SetBlipColour(postalLoc.blip, 45)
		SetBlipAsShortRange(postalLoc.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("_JOB : Postal Delivery - work@place")
		EndTextCommandSetBlipName(postalLoc.blip)
	end

	for _, truckLoc in pairs(truckerLocation) do
		truckLoc.blip = AddBlipForCoord(truckLoc.x, truckLoc.y, truckLoc.z)
		SetBlipSprite(truckLoc.blip, 85)
		SetBlipDisplay(truckLoc.blip, 4)
		SetBlipScale(truckLoc.blip, 1.0)
		SetBlipColour(truckLoc.blip, 45)
		SetBlipAsShortRange(truckLoc.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("_JOB : Trucker Man - work@place")
		EndTextCommandSetBlipName(truckLoc.blip)
	end

	for _, pawnLoc in pairs(pawnLocation) do
		pawnLoc.blip = AddBlipForCoord(pawnLoc.x, pawnLoc.y, pawnLoc.z)
		SetBlipSprite(pawnLoc.blip, 434)
		SetBlipDisplay(pawnLoc.blip, 4)
		SetBlipScale(pawnLoc.blip, 1.0)
		SetBlipColour(pawnLoc.blip, 45)
		SetBlipAsShortRange(pawnLoc.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("@_PAWN-SHOP : [SELL UN-USEABLE ITEM]")
		EndTextCommandSetBlipName(pawnLoc.blip)
	end

	for _, clothLoc in pairs(clothLocation) do
		clothLoc.blip = AddBlipForCoord(clothLoc.x, clothLoc.y, clothLoc.z)
		SetBlipSprite(clothLoc.blip, 73)
		SetBlipDisplay(clothLoc.blip, 4)
		SetBlipScale(clothLoc.blip, 1.0)
		SetBlipColour(clothLoc.blip, 45)
		SetBlipAsShortRange(clothLoc.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("@_CLOTHES-SHOP : [ BUY CLOTHES WHENEVER YOU WANT ]")
		EndTextCommandSetBlipName(clothLoc.blip)
	end
end)


--[[function createblipnow(x,y,z,str,sp)
	pos = pos.entering
	local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
	SetBlipSprite(blip,357)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(str)
	EndTextCommandSetBlipName(blip)
	SetBlipAsShortRange(blip,false)
end]]