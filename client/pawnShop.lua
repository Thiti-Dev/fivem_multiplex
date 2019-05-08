pawnLocation = {
    {x=-1215.8590087891,y=-1498.9047851563,z=4.3344511985779}
}

Citizen.CreateThread(function()
	while true do
        local pos = GetEntityCoords(GetPlayerPed(-1), true)
        
        for _, x in ipairs(pawnLocation) do
            if(Vdist(pos.x, pos.y, pos.z, x.x, x.y, x.z) < 8.0) then
                DrawText3Ds(x.x, x.y, x.z, "Use ~g~ITEM HERE~w~ to sell your item to ~r~ [PAWN SHOP]")
            end
        end
		for _, pawnLoc in ipairs(pawnLocation) do
			if(Vdist(pos.x, pos.y, pos.z, pawnLoc.x, pawnLoc.y, pawnLoc.z) < 8.0) then
				DrawMarker(1, pawnLoc.x, pawnLoc.y, pawnLoc.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5, 1555, 0, 0,200, 0, 0, 0,0)
				--displayTextInfo(pos.x,pos.y,pos.z,pawnLoc.x, pawnLoc.y, pawnLoc.z)
			end			
		end
        Citizen.Wait(0)
    end
end)

AddEventHandler("sellToPawn", function(itemname,amount)
    if string.find(itemname, "-FISH") then
        if removeItem(itemname, amount) then
            local amountArray = stringsplit(itemname, ":")
            local realAmount = tonumber(amountArray[2])
            local price = realAmount * 2
            moneyPay(price*amount)
        else
            ShowNotification("Wrong amount")
        end
    else
        ShowNotification("Pawn-shop don't want this item")
    end

end)