globalObject = {}


RegisterServerEvent("regisNewItem")
AddEventHandler("regisNewItem", function(hash,netid,pos,index)
    if not globalObject[netid] then
        print("registered new object")
        globalObject[netid] = {HASH=hash,POSITION={X=pos.x,Y=pos.y,Z=pos.z},INDEX=index}
        print(json.encode(globalObject[netid]))
    else
        print("replace with new object")
        globalObject[netid] = {HASH=hash,POSITION={X=tostring(pos.x),Y=tostring(pos.y),Z=tostring(pos.z)},INDEX=index}
        print(json.encode(globalObject[netid]))
    end
end)


RegisterServerEvent("checkItem")
AddEventHandler("checkItem", function(netid,hash,pos)
    if globalObject[netid] then
        print("Item found , check if this is the same obj")
        if math.floor(pos.x) == math.floor(globalObject[netid].POSITION.X) and math.floor(pos.y) == math.floor(globalObject[netid].POSITION.Y) and math.floor(pos.z) == math.floor(globalObject[netid].POSITION.Z) and hash == globalObject[netid].HASH then
            print("Detailed are the same")
            TriggerClientEvent("onPickupItem" , source, netid, hash, globalObject[netid].INDEX)
            globalObject[netid] = nil
        else
            print("Detailed are not valid")
        end
    else
        print("Object not found in the server-side")
    end
    --print("Position recieve : " .. pos.x .. " " .. pos.y .. " " .. pos.z)
end)