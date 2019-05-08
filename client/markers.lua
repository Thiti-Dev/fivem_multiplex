--local incircle = false

Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1), true)

		--local pos2 = v.position

	
		if not playerData.LOGGEDIN then
			if(Vdist(pos.x, pos.y, pos.z, 11.936089515686, -1108.482421875, 29.797029495239) < 8.0) then
				local prex,prey,prez = 11.936089515686, -1108.482421875, 29.797029495239
				DrawMarker(1, prex, prey, prez - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5, 1555, 0, 0,200, 0, 0, 0,0)
				
				displayTextInfo(pos.x,pos.y,pos.z,prex,prey,prez)
			end
			if(Vdist(pos.x, pos.y, pos.z, 13.727068901062, -1107.1080322266, 29.797029495239) < 8.0) then
				local prex,prey,prez = 13.727068901062, -1107.1080322266, 29.797029495239
				DrawMarker(1, prex, prey, prez - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5, 1555, 0, 0,200, 0, 0, 0,0)
				
				displayTextInfo(pos.x,pos.y,pos.z,prex,prey,prez)
			end
		end

		for _, gunLoc in ipairs(gunLocation) do
			if(Vdist(pos.x, pos.y, pos.z, gunLoc.x, gunLoc.y, gunLoc.z) < 8.0) then
				DrawMarker(1, gunLoc.x, gunLoc.y, gunLoc.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5, 1555, 0, 0,200, 0, 0, 0,0)
				displayTextInfo(pos.x,pos.y,pos.z,gunLoc.x, gunLoc.y, gunLoc.z)
			end			
		end

		for _, foodLoc in ipairs(foodLocation) do
			if(Vdist(pos.x, pos.y, pos.z, foodLoc.x, foodLoc.y, foodLoc.z) < 8.0) then
				DrawMarker(1, foodLoc.x, foodLoc.y, foodLoc.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5, 1555, 0, 0,200, 0, 0, 0,0)
				displayTextInfo(pos.x,pos.y,pos.z,foodLoc.x, foodLoc.y, foodLoc.z)
			end			
		end

		for _, vehicleLoc in ipairs(vehicleLocation) do
			if(Vdist(pos.x, pos.y, pos.z, vehicleLoc.x, vehicleLoc.y, vehicleLoc.z) < 8.0) then
				DrawMarker(1, vehicleLoc.x, vehicleLoc.y, vehicleLoc.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5, 1555, 0, 0,200, 0, 0, 0,0)
				displayTextInfo(pos.x,pos.y,pos.z,vehicleLoc.x, vehicleLoc.y, vehicleLoc.z)
			end			
		end

		for _, recieveLoc in ipairs(recieveLocation) do
			if(Vdist(pos.x, pos.y, pos.z, recieveLoc.x, recieveLoc.y, recieveLoc.z) < 8.0) then
				DrawMarker(1, recieveLoc.x, recieveLoc.y, recieveLoc.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5, 1555, 0, 0,200, 0, 0, 0,0)
				displayTextInfo(pos.x,pos.y,pos.z,recieveLoc.x, recieveLoc.y, recieveLoc.z)
			end			
		end

		for _, jobLoc in ipairs(jobLocation) do
			if(Vdist(pos.x, pos.y, pos.z, jobLoc.x, jobLoc.y, jobLoc.z) < 8.0) then
				DrawMarker(1, jobLoc.x, jobLoc.y, jobLoc.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5, 1555, 0, 0,200, 0, 0, 0,0)
				displayTextInfo(pos.x,pos.y,pos.z,jobLoc.x, jobLoc.y, jobLoc.z)
			end			
		end
		
		for _, woodLoc in ipairs(woodLocation) do
			if(Vdist(pos.x, pos.y, pos.z, woodLoc.x, woodLoc.y, woodLoc.z) < 8.0) then
				DrawMarker(1, woodLoc.x, woodLoc.y, woodLoc.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5, 1555, 0, 0,200, 0, 0, 0,0)
				displayTextInfo(pos.x,pos.y,pos.z,woodLoc.x, woodLoc.y, woodLoc.z)
			end			
		end

		for _, doctorLoc in ipairs(doctorLocation) do
			if(Vdist(pos.x, pos.y, pos.z, doctorLoc.x, doctorLoc.y, doctorLoc.z) < 8.0) then
				DrawMarker(1, doctorLoc.x, doctorLoc.y, doctorLoc.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5, 1555, 0, 0,200, 0, 0, 0,0)
				displayTextInfo(pos.x,pos.y,pos.z,doctorLoc.x, doctorLoc.y, doctorLoc.z)
			end			
		end

		for _, shopLoc in ipairs(shopLocation) do
			if(Vdist(pos.x, pos.y, pos.z, shopLoc.x, shopLoc.y, shopLoc.z) < 8.0) then
				DrawMarker(1, shopLoc.x, shopLoc.y, shopLoc.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5, 1555, 0, 0,200, 0, 0, 0,0)
				displayTextInfo(pos.x,pos.y,pos.z,shopLoc.x, shopLoc.y, shopLoc.z)
			end			
		end

		for _, repairLoc in ipairs(repairLocation) do
			if(Vdist(pos.x, pos.y, pos.z, repairLoc.x, repairLoc.y, repairLoc.z) < 8.0) then
				DrawMarker(1, repairLoc.x, repairLoc.y, repairLoc.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5, 1555, 0, 0,200, 0, 0, 0,0)
				displayTextInfo(pos.x,pos.y,pos.z,repairLoc.x, repairLoc.y, repairLoc.z)
			end			
		end

		for _, taxiLoc in ipairs(taxiLocation) do
			if(Vdist(pos.x, pos.y, pos.z, taxiLoc.x, taxiLoc.y, taxiLoc.z) < 8.0) then
				DrawMarker(1, taxiLoc.x, taxiLoc.y, taxiLoc.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5, 1555, 0, 0,200, 0, 0, 0,0)
				displayTextInfo(pos.x,pos.y,pos.z,taxiLoc.x, taxiLoc.y, taxiLoc.z)
			end			
		end

		for _, postalLoc in ipairs(postalLocation) do
			if(Vdist(pos.x, pos.y, pos.z, postalLoc.x, postalLoc.y, postalLoc.z) < 8.0) then
				DrawMarker(1, postalLoc.x, postalLoc.y, postalLoc.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5, 1555, 0, 0,200, 0, 0, 0,0)
				displayTextInfo(pos.x,pos.y,pos.z,postalLoc.x, postalLoc.y, postalLoc.z)
			end			
		end

		for _, truckerLoc in ipairs(truckerLocation) do
			if(Vdist(pos.x, pos.y, pos.z, truckerLoc.x, truckerLoc.y, truckerLoc.z) < 8.0) then
				DrawMarker(1, truckerLoc.x, truckerLoc.y, truckerLoc.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5, 1555, 0, 0,200, 0, 0, 0,0)
				displayTextInfo(pos.x,pos.y,pos.z,truckerLoc.x, truckerLoc.y, truckerLoc.z)
			end			
		end

		for _, fishLoc in ipairs(fishLocation) do
			if(Vdist(pos.x, pos.y, pos.z, fishLoc.x, fishLoc.y, fishLoc.z) < 8.0) then
				DrawMarker(1, fishLoc.x, fishLoc.y, fishLoc.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5, 1555, 0, 0,200, 0, 0, 0,0)
				displayTextInfo(pos.x,pos.y,pos.z,fishLoc.x, fishLoc.y, fishLoc.z)
			end			
		end

        for _, clothLoc in ipairs(clothLocation) do
			if(Vdist(pos.x, pos.y, pos.z, clothLoc.x, clothLoc.y, clothLoc.z) < 8.0) then
				DrawMarker(1, clothLoc.x, clothLoc.y, clothLoc.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5, 1555, 0, 0,200, 0, 0, 0,0)
				displayTextInfo(pos.x,pos.y,pos.z,clothLoc.x, clothLoc.y, clothLoc.z)
			end			
		end

        for _, policeLoc in ipairs(policeLocation) do
			if(Vdist(pos.x, pos.y, pos.z, policeLoc.x, policeLoc.y, policeLoc.z) < 8.0) then
				DrawMarker(1, policeLoc.x, policeLoc.y, policeLoc.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5, 1555, 0, 0,200, 0, 0, 0,0)
				displayTextInfo(pos.x,pos.y,pos.z,policeLoc.x, policeLoc.y, policeLoc.z)
			end			
		end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    Holograms()
end)

function displayTextInfo(x,y,z,dx,dy,dz)

    if(Vdist(x, y, z, dx, dy, dz) < 1.0) then
		--if (incircle == false) then
			if WarMenu.CurrentMenu() == nil then
				DisplayHelpText("Press ~INPUT_PICKUP~ to Interact ~b~")
				--incircle = true
			end
        --end
    else
        --incircle = false
    end

end

function Holograms()
		while true do
			Citizen.Wait(0)			
				-- Hologram No. 1

			if not playerData.LOGGEDIN then
				if GetDistanceBetweenCoords( 11.936089515686, -1108.482421875, 29.797029495239, GetEntityCoords(GetPlayerPed(-1))) < 8.0 then
					Draw3DText( 11.936089515686, -1108.482421875, 29.797029495239  -1.400, "Register Here", 4, 0.1, 0.1)
					Draw3DText( 11.936089515686, -1108.482421875, 29.797029495239  -1.600, "Press E", 4, 0.1, 0.1)
					--Draw3DText( 11.936089515686, -1108.482421875, 29.797029495239  -1.800, "here", 4, 0.1, 0.1)		
				end	
				if GetDistanceBetweenCoords( 13.727068901062, -1107.1080322266, 29.797029495239, GetEntityCoords(GetPlayerPed(-1))) < 8.0 then
					Draw3DText( 13.727068901062, -1107.1080322266, 29.797029495239  -1.400, "Login Here", 4, 0.1, 0.1)
					Draw3DText(13.727068901062, -1107.1080322266, 29.797029495239  -1.600, "Press E", 4, 0.1, 0.1)
					--Draw3DText( 11.936089515686, -1108.482421875, 29.797029495239  -1.800, "here", 4, 0.1, 0.1)		
				end		
			end
	end
end