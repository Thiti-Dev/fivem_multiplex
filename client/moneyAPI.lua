function moneyPay(amount)
    if playerData.MONEY + amount >= 0 then
        playerData.MONEY = playerData.MONEY + amount
        TriggerServerEvent("updateMoney", playerData.MONEY)
        if amount < 0 then
            ShowNotification("You've pay $: ~r~ " .. tostring(amount))
        else
            ShowNotification("You've recieve $: ~g~ " .. tostring(amount))
        end
        return true
    else
        return false
    end
end

RegisterNetEvent("moneyPay")
AddEventHandler("moneyPay", function(amount,cb)
    amount = -1 * amount
    if playerData.MONEY + amount >= 0 then
        playerData.MONEY = playerData.MONEY + amount
        TriggerServerEvent("updateMoney", playerData.MONEY)
        if amount < 0 then
            ShowNotification("You've pay $: ~r~ " .. tostring(amount))
        else
            ShowNotification("You've recieve $: ~g~ " .. tostring(amount))
        end
        cb(true)
        return true
    else
        ShowNotification("You don't have enough money")
        cb(false)
        return false
    end
end)

function earnExp(amount)
    playerData.EXP =  playerData.EXP + amount
end