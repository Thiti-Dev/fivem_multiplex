RegisterServerEvent("syncVehicle")
AddEventHandler("syncVehicle", function(plate,netid)
    if not vehicleSync[plate] then
        vehicleSync[plate] = {}
        vehicleSync[plate].NETID = netid
    else
        vehicleSync[plate].NETID = netid
    end
    print("Net id put into vehicleSync NETID : " .. netid .. " Plate : " .. plate)
    --print("length of vehicleSync : " .. #vehicleSync)
end)

RegisterServerEvent("reqVehicle")
AddEventHandler("reqVehicle", function(model,plate,colors,mods,neons,bw)
    if vehicleSync[plate] then
        TriggerClientEvent("recieveSuccess", source, vehicleSync[plate].NETID,model,plate,colors,mods,neons,bw)
    else
        TriggerClientEvent("recieveSuccessWithoutCheck", source,model,plate,colors,mods,neons,bw)
    end
end)

RegisterServerEvent("saveModToServer")
AddEventHandler("saveModToServer", function(plate,color,mod,neons,bw)
    local Source = source 
    TriggerEvent('updateAdvanceVehicle', plate, {colors=color,mods=mod,neon=neons,bvw=bw})
end)