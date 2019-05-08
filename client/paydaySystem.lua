AddEventHandler("startPayday", function()
    Citizen.CreateThread(function()
        Citizen.Trace("********* Start safe payday interval chacker ***********")
        while true do
            Citizen.Wait(1800000)
            local resultPaid = 0
            local resultShow = 0
            TriggerEvent("chatMessage", "", {1,170,0}, "#---------------------------------------------------#")
            TriggerEvent("chatMessage", "^1[^0 💲 Payday is Coming 💲 ^0] ", {1,170,0}, "Detailed  below")
            TriggerEvent("chatMessage", "", {255,255,255}, ">>> ✔️ ^2$^0250 for being > 🙍‍Citizen <<<")
            resultPaid = resultPaid + 250
            if playerData.JOB ~= "NONE" then

                if playerData.JOB == "Police Officer" then
                    resultPaid = resultPaid + 650
                    resultShow = 650
                elseif playerData.JOB == "Wood Cutter" then
                    resultPaid = resultPaid + 200
                    resultShow = 200
                elseif playerData.JOB == "Shopkeeper" then
                    resultPaid = resultPaid + 200
                    resultShow = 200
                elseif playerData.JOB == "Repair Man" then
                    resultPaid = resultPaid + 350
                    resultShow = 350
                elseif playerData.JOB == "Taxi Driver" then
                    resultPaid = resultPaid + 450
                    resultShow = 450
                elseif playerData.JOB == "Postal Delivery" then
                    resultPaid = resultPaid + 450
                    resultShow = 450
                elseif playerData.JOB == "Trucker Man" then
                    resultPaid = resultPaid + 450
                    resultShow = 450
                elseif playerData.JOB == "Pro Fishing" then
                    resultPaid = resultPaid + 450
                    resultShow = 450
                elseif playerData.JOB == "Doctor" then
                    resultPaid = resultPaid + 1000      
                    resultShow = 1000                                                                                                           
                end
                TriggerEvent("chatMessage", "", {255,255,255}, ">> ✔️ ^2$^0" .. resultShow .. " for being > 👨‍💼" .. playerData.JOB .. " <<")
            end
            resultShow = playerData.LEVEL * 150
            resultPaid = resultPaid + resultShow  
            TriggerEvent("chatMessage", "", {255,255,255}, "✔️ ^2$^0" .. resultShow .. " additional money for being 🔥LVL." .. playerData.LEVEL)
            --TriggerEvent("chatMessage", "", {255,255,255}, ">>>>>💰 Total income : ^2$^0" .. resultPaid .. "<<<<<")
            TriggerEvent("chatMessage", "", {1,170,0}, "#---------------------------------------------------#")
            TriggerEvent("chatMessage", "", {255,255,255}, ">>>>>💰 Total income : ^2$^0" .. resultPaid .. "<<<<<")

            moneyPay(resultPaid)
            TriggerEvent("calculationPaydayEscaped")
        end
    end)
end)