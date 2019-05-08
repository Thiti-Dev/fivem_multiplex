AddEventHandler('updateAdvance', function(identifier, new, callback)
   -- print("inside working here 2")
    Citizen.CreateThread(function()
        --print("inside working here")
		local updateString = ''
		local params = {identifier = identifier}

		local length = tLength(new)
		local cLength = 1
		for k,v in pairs(new) do
			if (type(k) == 'string') then
				updateString = updateString .. '`' .. k .. '`=@' .. k
				params[k] = v
				if cLength < length then
					updateString = updateString .. ', '
				end
			end
			cLength = cLength + 1
		end

		MySQL.Async.execute('UPDATE users SET ' .. updateString .. ' WHERE `character_name`=@identifier', params, function(rowsChanged)
			if callback then
				callback(true)
			end
		end)
	end)
end)

AddEventHandler('updateAdvanceVehicle', function(identifier, new, callback)
   -- print("inside working here 2")
    Citizen.CreateThread(function()
        --print("inside working here")
		local updateString = ''
		local params = {identifier = identifier}

		local length = tLength(new)
		local cLength = 1
		for k,v in pairs(new) do
			if (type(k) == 'string') then
				updateString = updateString .. '`' .. k .. '`=@' .. k
				params[k] = v
				if cLength < length then
					updateString = updateString .. ', '
				end
			end
			cLength = cLength + 1
		end

		MySQL.Async.execute('UPDATE playervehicles SET ' .. updateString .. ' WHERE `plate`=@identifier', params, function(rowsChanged)
			if callback then
				callback(true)
			end
		end)
	end)
end)

function tLength(t)
	local l = 0
	for k,v in pairs(t)do
		l = l + 1
	end
	return l
end