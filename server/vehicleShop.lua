RegisterServerEvent("onCarPurchase")
AddEventHandler("onCarPurchase", function(owner,model,plate,color,mod,neons,bw,netid)
    print("On car bought")
    --vehicleSync[plate] = netid
    if not vehicleSync[plate] then
        vehicleSync[plate] = {}
        vehicleSync[plate].NETID = netid
    else
        vehicleSync[plate].NETID = netid
    end
    print("Net id put into vehicleSync NETID : " .. netid)
    MySQL.Async.execute(
    'INSERT INTO playervehicles (plate, owner , model, colors, mods , neon, bvw) VALUES (@plate, @owner , @model, @colors, @mods, @neons , @bw)',
    {
        ['@plate'] = plate,
        ['@owner']       = owner,
        ['@model']   =  model,
        ['@colors']   =  color,
        ['@mods']   =  mod,
        ['@neons']   =  neons,
        ['@bw']   =  bw,
    })


end)