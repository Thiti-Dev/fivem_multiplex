function is_table_equal(t1,t2,ignore_mt)
    Citizen.Trace("Done inside once")
   local ty1 = type(t1)
   local ty2 = type(t2)
   if ty1 ~= ty2 then return false end
   -- non-table types can be directly compared
   if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
   -- as well as tables which have the metamethod __eq
   local mt = getmetatable(t1)
   if not ignore_mt and mt and mt.__eq then return t1 == t2 end
   for k1,v1 in pairs(t1) do
      local v2 = t2[k1]
      if v2 == nil or not is_table_equal(v1,v2) then return false end
   end
   for k2,v2 in pairs(t2) do
      local v1 = t1[k2]
      if v1 == nil or not is_table_equal(v1,v2) then return false end
   end
   return true
end



--////////////////////// Position //////////////////////// --
local oldPos = nil

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(1000)
        if playerData.LOGGEDIN and playerData.GENDER ~= "NONE" then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            local head = GetEntityHeading(GetPlayerPed(-1))
            if(oldPos ~= pos)then
                TriggerServerEvent('updatePosition', pos.x, pos.y, pos.z, head)
                oldPos = pos
            end
        end
	end
end)

local oldExp = nil

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5000)
        if playerData.LOGGEDIN and playerData.GENDER ~= "NONE" then
            local lvlstring = tostring(playerData.LEVEL) .. ":" .. tostring(playerData.EXP)
            if lvlstring ~= oldExp then
                TriggerServerEvent('updateExp', lvlstring)
                oldExp = lvlstring
            end
        end
	end
end)
-- ---------------------------------------------------------- ---


--////////////////////// Inventory //////////////////////////// --
--[[local prevInventory = nil

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(2000)
        if playerData.LOGGEDIN and playerData.LOADINV then
            --Citizen.Trace("Occur here")
            --if not is_table_equal(playerData.INVENTORY,prevInventory) then
                TriggerServerEvent('updateInventory', playerData.INVENTORY, playerData.NOMOREINV)
                prevInventory = playerData.INVENTORY
            --end
        end
	end
end)]]

-------------------------------------------------------------------