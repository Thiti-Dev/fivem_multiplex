clientInstance = {}
local currentEntrance = {X=nil,Y=nil,Z=nil,HEADING=nil}
local currentInside = {X=nil,Y=nil,Z=nil,HEADING=nil}
local justSet = false
RegisterNetEvent("onLoadInstance")
AddEventHandler("onLoadInstance", function()
    TriggerServerEvent("recieveInstance")
end)

RegisterNetEvent("instance:recieve")
AddEventHandler("instance:recieve", function(tablehere)
    clientInstance = tablehere
    TriggerEvent("chatMessage", "Debug ", {105,7,73}, #clientInstance .. " instances loaded into client-side")
end)

RegisterNetEvent("instance:recieveAll")
AddEventHandler("instance:recieveAll", function(tablehere)
    if not justSet then
        clientInstance = tablehere
        TriggerEvent("chatMessage", "Debug ", {105,7,73}, #clientInstance .. " instances re-loaded into client-side [ NEW UPDATE! ]")
    else
        Citizen.Trace("You're the one who've set this , skipped...")
        justSet = false
    end
end)

RegisterNetEvent("onSetInstance")
AddEventHandler("onSetInstance", function(task)
    if task == "entrance" then
        local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
        local heading = GetEntityHeading(PlayerPedId())
        currentEntrance.X = x
        currentEntrance.Y = y
        currentEntrance.Z = z
        currentEntrance.HEADING = heading
        TriggerEvent("chatMessage", "Debug ", {105,7,73}, " you've set the inside of the instance")
    elseif task == "inside" then
        local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
        local heading = GetEntityHeading(PlayerPedId())
        currentInside.X = x
        currentInside.Y = y
        currentInside.Z = z
        currentInside.HEADING = heading
        TriggerEvent("chatMessage", "Debug ", {105,7,73}, " you've set the entrance of the instance")    
    else
        if currentEntrance.X ~= nil and currentEntrance.Y ~= nil and currentEntrance.Z ~= nil and currentInside.X ~= nil and currentInside.Y ~= nil and currentInside.Z ~= nil then
            local entranceString = tostring(currentEntrance.X) .. ":" .. tostring(currentEntrance.Y) .. ":" .. tostring(currentEntrance.Z) .. ":" .. tostring(currentEntrance.HEADING)
            local insideString = tostring(currentInside.X) .. ":" .. tostring(currentInside.Y) .. ":" .. tostring(currentInside.Z) .. ":" .. tostring(currentInside.HEADING)
            table.insert(clientInstance, {ENTRANCE={X=currentEntrance.X,Y=currentEntrance.Y,Z=currentEntrance.Z,HEADING=currentEntrance.HEADING},INSIDE={X=currentInside.X,Y=currentInside.Y,Z=currentInside.Z,HEADING=currentInside.HEADING}})
            justSet = true
            TriggerServerEvent("doneInstance", entranceString, insideString, clientInstance)
            clearVariable()
            TriggerEvent("chatMessage", "Debug ", {105,7,73}, " total number of the instance : [" .. #clientInstance .. "]")    
        else
            TriggerEvent("chatMessage", "Debug ", {105,7,73}, " please set both entrace/inside")    
        end
    end
end)

RegisterNetEvent("removeThisInstance")
AddEventHandler("removeThisInstance", function()
    local holdIndex = nil
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    for index, instanceLoc in ipairs(clientInstance) do
        if Vdist(pos.x, pos.y, pos.z, instanceLoc.ENTRANCE.X, instanceLoc.ENTRANCE.Y, instanceLoc.ENTRANCE.Z) < 2.0 or Vdist(pos.x, pos.y, pos.z, instanceLoc.INSIDE.X, instanceLoc.INSIDE.Y, instanceLoc.INSIDE.Z) < 2.0 then
            holdIndex = index
            break
        end
    end

    if holdIndex then
        local entranceString = tostring(clientInstance[holdIndex].ENTRANCE.X) .. ":" .. tostring(clientInstance[holdIndex].ENTRANCE.Y) .. ":" .. tostring(clientInstance[holdIndex].ENTRANCE.Z) .. ":" .. tostring(clientInstance[holdIndex].ENTRANCE.HEADING)
        table.remove(clientInstance, holdIndex)
        justSet = true
        TriggerEvent("chatMessage", "Debug ", {105,7,73}, " total number of the instance : [" .. #clientInstance .. "]")  
        TriggerServerEvent("deleteInstance", entranceString, clientInstance)
    else
        TriggerEvent("chatMessage", "Debug ", {105,7,73}, "Please stand at the spot of the marker")   
    end
end)

-- custom marker phase starting here

local incircle = false

Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
        for _, instanceLoc in ipairs(clientInstance) do
            --Markers
			if(Vdist(pos.x, pos.y, pos.z, instanceLoc.ENTRANCE.X, instanceLoc.ENTRANCE.Y, instanceLoc.ENTRANCE.Z) < 8.0) then
				DrawMarker(1, instanceLoc.ENTRANCE.X, instanceLoc.ENTRANCE.Y, instanceLoc.ENTRANCE.Z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5, 255, 128, 0,150, 0, 0, 0,0)
				displayTextInfo2(pos.x,pos.y,pos.z,instanceLoc.ENTRANCE.X, instanceLoc.ENTRANCE.Y, instanceLoc.ENTRANCE.Z)
            end		
            if(Vdist(pos.x, pos.y, pos.z, instanceLoc.INSIDE.X, instanceLoc.INSIDE.Y, instanceLoc.INSIDE.Z) < 8.0) then
				DrawMarker(1, instanceLoc.INSIDE.X, instanceLoc.INSIDE.Y, instanceLoc.INSIDE.Z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5, 255, 128, 0,150, 0, 0, 0,0)
				displayTextInfo2(pos.x,pos.y,pos.z,instanceLoc.INSIDE.X, instanceLoc.INSIDE.Y, instanceLoc.INSIDE.Z)
			end			
        end

        if IsControlJustReleased(0, 191) then --M by default
            for _, instanceLoc in ipairs(clientInstance) do
                if GetDistanceBetweenCoords( instanceLoc.ENTRANCE.X, instanceLoc.ENTRANCE.Y, instanceLoc.ENTRANCE.Z, GetEntityCoords(GetPlayerPed(-1))) < 2.0 then
                    --WarMenu.OpenMenu('jobcenter')
                    DoScreenFadeOut(500)
                    Citizen.Wait(600)
                    TriggerEvent("freezeAdjust")
                    SetEntityCoords(GetPlayerPed(-1), instanceLoc.INSIDE.X, instanceLoc.INSIDE.Y, instanceLoc.INSIDE.Z - 0.95, 1, 0, 0, 1)
                    SetEntityHeading(GetPlayerPed(-1), instanceLoc.INSIDE.HEADING)
                    Citizen.Wait(2000)
                    DoScreenFadeIn(1000)   
                elseif GetDistanceBetweenCoords( instanceLoc.INSIDE.X, instanceLoc.INSIDE.Y, instanceLoc.INSIDE.Z, GetEntityCoords(GetPlayerPed(-1))) < 2.0 then
                    --WarMenu.OpenMenu('jobcenter')
                    DoScreenFadeOut(500)
                    Citizen.Wait(600)
                    TriggerEvent("freezeAdjust")
                    SetEntityCoords(GetPlayerPed(-1), instanceLoc.ENTRANCE.X, instanceLoc.ENTRANCE.Y, instanceLoc.ENTRANCE.Z - 0.95, 1, 0, 0, 1)
                    SetEntityHeading(GetPlayerPed(-1), instanceLoc.ENTRANCE.HEADING)
                    Citizen.Wait(2000)
                    DoScreenFadeIn(1000)   
                end
            end
        end
		Citizen.Wait(0)
	end
end)
function displayTextInfo2(x,y,z,dx,dy,dz)

    if(Vdist(x, y, z, dx, dy, dz) < 2.5) then
		--if (incircle == false) then
			--if WarMenu.CurrentMenu() == nil then
				--DisplayHelpText("Press ~INPUT_PICKUP~ to enter ~b~")
				--incircle = true
			--end
        --end
        DrawText3Ds(dx, dy, dz, "Press ~g~ENTER~w~ to enter")
    else
        --incircle = false
    end
end


function clearVariable()
    currentEntrance.X = nil
    currentEntrance.Y = nil
    currentEntrance.Z = nil
    currentInside.X = nil
    currentInside.Y = nil
    currentInside.Z = nil    

end