RegisterServerEvent("giveItemToPlayer")
AddEventHandler("giveItemToPlayer", function(towho,itemIndex)
    TriggerClientEvent("gotSomeItemFrom", towho , source , itemIndex)
end)

RegisterServerEvent("giveMoneyToPlayer")
AddEventHandler("giveMoneyToPlayer", function(towho,amount)
    TriggerClientEvent("gotSomeMoneyFrom", towho , source , amount)
end)

RegisterServerEvent("giveSuccessRemoveHim")
AddEventHandler("giveSuccessRemoveHim", function(towho)
    TriggerClientEvent("giveSuccess", towho, userData[source].NAME)
end)

RegisterServerEvent("giveSuccessMoneyHim")
AddEventHandler("giveSuccessMoneyHim", function(towho)
    TriggerClientEvent("giveSuccessMoney", towho, userData[source].NAME)
end)

RegisterServerEvent("giveFailed")
AddEventHandler("giveFailed", function(towho)
    TriggerClientEvent("failedGive", towho)
end)

RegisterServerEvent("dragHim")
AddEventHandler("dragHim", function(towho)
    TriggerClientEvent("police:toggleDrag", towho, source)
end)

RegisterServerEvent("cuffHim")
AddEventHandler("cuffHim", function(towho)
    TriggerClientEvent("police:toggleHandCuff", towho, userData[source].NAME)
end)

RegisterServerEvent("seatHim")
AddEventHandler("seatHim", function(towho)
    TriggerClientEvent("police:toggleSeat", towho, userData[source].NAME)
end)

RegisterServerEvent("arrestHim")
AddEventHandler("arrestHim", function(towho)
    TriggerClientEvent("police:arrestNow", towho, userData[source].NAME)
end)