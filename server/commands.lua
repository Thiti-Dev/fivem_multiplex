AddEventHandler("chatMessage", function(source, color, msg)
    if msg:sub(1, 1) == "/" then
        fullcmd = stringsplit(msg, " ")
        cmd = fullcmd[1]
        
        if cmd == "/test3d" then
            TriggerClientEvent("chatMessage",source, "[CHECKING]", {255, 0, 0}, "Starting 3dtest")
            TriggerClientEvent("onTest3d", source)
            CancelEvent()
        elseif cmd == "/testcar" then
            TriggerClientEvent("chatMessage",source, "[CHECKING]", {255, 0, 0}, "Starting testcar")
            TriggerClientEvent("onCarTest", source)
            CancelEvent()	
        elseif cmd == "/checkcar" then
            TriggerClientEvent("chatMessage",source, "[CHECKING]", {255, 0, 0}, "Starting checkcar")
            TriggerClientEvent("onCarCheck", source)
            CancelEvent()	
        elseif cmd == "/closeveh" then
            TriggerClientEvent("chatMessage",source, "[CHECKING]", {255, 0, 0}, "Starting getvehindirection")
            TriggerClientEvent("getFrontVehDirection", source)
            CancelEvent()	
        elseif cmd == "/testreload" then
            TriggerClientEvent("chatMessage",source, "[CHECKING]", {255, 0, 0}, "Starting reload")
            TriggerClientEvent("onReloadTest", source)
            CancelEvent()	
        elseif cmd == "/testreload2" then
            TriggerClientEvent("chatMessage",source, "[CHECKING]", {255, 0, 0}, "Starting reload2")
            TriggerClientEvent("onReloadTest", source)
            CancelEvent()	
        elseif cmd == "/givetestpistol" then
            TriggerClientEvent("chatMessage",source, "[CHECKING]", {255, 0, 0}, "Starting give")
            TriggerClientEvent("onWeaponGive", source)
            CancelEvent()	
        elseif cmd == "/reloadmag" then
            if fullcmd[2] ~= nil then
                TriggerClientEvent("onWeaponGiveWithMag", source, tostring(fullcmd[2]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/reloadmag [ ammoinmag ]")
            end
            CancelEvent()
        elseif cmd == "/setskin" then
            if fullcmd[2] ~= nil then
                TriggerClientEvent("onSetSkin", source, tostring(fullcmd[2]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/setskin [ male / female ]")
            end
            CancelEvent()
        elseif cmd == "/setshirt" then
            if fullcmd[2] ~= nil then
                TriggerClientEvent("onSetShirt", source, tostring(fullcmd[2]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/setshirt [ shirtname ]")
            end
            CancelEvent()
        elseif cmd == "/setpant" then
            if fullcmd[2] ~= nil then
                TriggerClientEvent("onSetPant", source, tostring(fullcmd[2]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/setpant [ pantname ]")
            end
            CancelEvent()
        elseif cmd == "/setshoes" then
            if fullcmd[2] ~= nil then
                TriggerClientEvent("onSetShoes", source, tostring(fullcmd[2]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/setshoe [ shoename ]")
            end
            CancelEvent()
        elseif cmd == "/setcomponent" then
            if fullcmd[2] ~= nil and fullcmd[3] ~= nil and fullcmd[4] ~= nil then
                TriggerClientEvent("onSetClothes", source, tonumber(fullcmd[2]),tonumber(fullcmd[3]),tonumber(fullcmd[4]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/setcomponent [ compo ] [ drawable ] [ txtureid ]")
            end
            CancelEvent()
        elseif cmd == "/testantiswitch" then
            TriggerClientEvent("chatMessage",source, "[CHECKING]", {255, 0, 0}, "Starting anti switch")
            TriggerClientEvent("onAntiSwitch", source)
            CancelEvent()	
        elseif cmd == "/testsetammo" then
            TriggerClientEvent("chatMessage",source, "[CHECKING]", {255, 0, 0}, "Starting set")
            TriggerClientEvent("onWeaponSetAmmo", source)
            CancelEvent()	
        elseif cmd == "/testsetammo2" then
            TriggerClientEvent("chatMessage",source, "[CHECKING]", {255, 0, 0}, "Starting set2")
            TriggerClientEvent("onWeaponSetAmmo2", source)
            CancelEvent()
        elseif cmd == "/ispistolhold" then
            TriggerClientEvent("chatMessage",source, "[CHECKING]", {255, 0, 0}, "Starting check")
            TriggerClientEvent("onWeaponCheck", source)
            CancelEvent()
       elseif cmd == "/checkammo" then
            TriggerClientEvent("chatMessage",source, "[CHECKING]", {255, 0, 0}, "Starting check")
            TriggerClientEvent("onAmmoCheck", source)
            CancelEvent()		
       elseif cmd == "/checkammo2" then
            TriggerClientEvent("chatMessage",source, "[CHECKING]", {255, 0, 0}, "Starting check2")
            TriggerClientEvent("onAmmoCheck2", source)
            CancelEvent()		
        elseif cmd == "/additem" then
            if fullcmd[2] ~= nil then
                TriggerClientEvent("onAddItem", source, tostring(fullcmd[2]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/additem [ itemname ]")
            end
            CancelEvent()
        elseif cmd == "/checkitem" then
            if fullcmd[2] ~= nil then
                TriggerClientEvent("onCheckItem", source, tostring(fullcmd[2]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/checkitem [ itemname ]")
            end
            CancelEvent()
        elseif cmd == "/removeallitem" then
            if fullcmd[2] ~= nil then
                TriggerClientEvent("onRemoveAllItem", source, tostring(fullcmd[2]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/removeallitem [ itemname ]")
            end
            CancelEvent()
        elseif cmd == "/removeitem" then
            if fullcmd[2] ~= nil and fullcmd[3] ~= nil then
                TriggerClientEvent("onRemoveItem", source, tostring(fullcmd[2]), tonumber(fullcmd[3]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/removeitem [ itemname ] [ amount ]")
            end
            CancelEvent()
        elseif cmd == "/setcustomization" then
            TriggerClientEvent("onSetCustomization", source)
            CancelEvent()
        elseif cmd == "/testcamera" then
            if fullcmd[2] ~= nil then
                TriggerClientEvent("onTestCamera", source, tostring(fullcmd[2]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/testcamera [ additional z ]")
            end
            CancelEvent()
        elseif cmd == "/testrotzcamera" then
            TriggerClientEvent("onRotZCamera", source)
            CancelEvent()
        elseif cmd == "/testrotxcamera" then
            if fullcmd[2] ~= nil then
                TriggerClientEvent("onRotXCamera", source, tostring(fullcmd[2]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/testrotxcamera [ additional x ]")
            end
            CancelEvent()
        elseif cmd == "/markcamera" then
            TriggerClientEvent("onMarkCamera", source)
            CancelEvent()
        elseif cmd == "/tpto" then
            if fullcmd[2] ~= nil and fullcmd[3] ~= nil and fullcmd[4] ~= nil then
                TriggerClientEvent("onTeleport", source, tostring(fullcmd[2]),tostring(fullcmd[3]),tostring(fullcmd[4]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/tpto [ x ] [ y ] [ z ]")
            end
            CancelEvent()
        elseif cmd == "/testtextdraw" then
            TriggerClientEvent("tdDebug", source)
            CancelEvent()
        elseif cmd == "/settextdraw" then
            if fullcmd[2] ~= nil then
                TriggerClientEvent("tdSet", source, tostring(fullcmd[2]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/settextdraw [text ]")
            end
            CancelEvent()
        elseif cmd == "/openmenu" then
            TriggerClientEvent("onMenuTest", source)
            CancelEvent()
        elseif cmd == "/netid" then
            TriggerClientEvent("onGetNetId", source)
            CancelEvent()
        elseif cmd == "/spawncar" then
            if fullcmd[2] ~= nil then
                TriggerClientEvent("onSpawnCar", source, tostring(fullcmd[2]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/spawncar [car name ]")
            end
            CancelEvent()
        elseif cmd == "/persistthiscar" then
            TriggerClientEvent("onVehiclePersist", source)
            CancelEvent()
        elseif cmd == "/getcurrentmenu" then
            TriggerClientEvent("onGetCurrentMenu", source)
            CancelEvent()
        elseif cmd == "/setmenux" then
            if fullcmd[2] ~= nil then
                TriggerClientEvent("onSetMenuX", source, tostring(fullcmd[2]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/setmenux [ float ]")
            end
            CancelEvent()
        elseif cmd == "/setmenuy" then
            if fullcmd[2] ~= nil then
                TriggerClientEvent("onSetMenuY", source, tostring(fullcmd[2]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/setmenuy [ float ]")
            end
            CancelEvent()
        elseif cmd == "/thitigivemoney" then
            if fullcmd[2] ~= nil then
                TriggerClientEvent("onSetMoney", source, tostring(fullcmd[2]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/setmoney [ money ]")
            end
            CancelEvent()
        elseif cmd == "/setvoicechannel" then
            if fullcmd[2] ~= nil then
                TriggerClientEvent("onSetVoiceChannel", source, tostring(fullcmd[2]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/setvoicechannel [ int channel ]")
            end
            CancelEvent()
        elseif cmd == "/clearvoicechannel" then
            TriggerClientEvent("onClearVoiceChannel", source)
            CancelEvent()
        elseif cmd == "/instanceme" then
            TriggerClientEvent("onInstanceSelf", source)
            CancelEvent()
        elseif cmd == "/deadnow" then
            TriggerClientEvent("onDeadFuck", source)
            CancelEvent()
        elseif cmd == "/clearanim" then
            TriggerClientEvent("onClearAnim", source)
            CancelEvent()
        elseif cmd == "/playthisanim" then
            if fullcmd[2] ~= nil and fullcmd[3] ~= nil and fullcmd[4] ~= nil and fullcmd[5] ~= nil then
                TriggerClientEvent("onPlaySpecificAnim", source, tostring(fullcmd[2]), tostring(fullcmd[3]), tostring(fullcmd[4]), tostring(fullcmd[5]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/playthisanim [ dict ] [ anim-name] [ flag ] [ time /ms]")
            end
            CancelEvent()
        elseif cmd == "/playthisanim2" then
            if fullcmd[2] ~= nil and fullcmd[3] ~= nil and fullcmd[4] ~= nil and fullcmd[5] ~= nil then
                TriggerClientEvent("onPlaySpecificAnim2", source, tostring(fullcmd[2]), tostring(fullcmd[3]), tostring(fullcmd[4]), tostring(fullcmd[5]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/playthisanim2 [ dict ] [ anim-name] [ flag ] [ time /ms]")
            end
            CancelEvent()
        elseif cmd == "/setmeblip" then
            TriggerClientEvent("onSetBlip", source)
            CancelEvent()
        elseif cmd == "/removemeblip" then
            TriggerClientEvent("onRemoveBlip", source)
            CancelEvent()
        elseif cmd == "/getnearbyped" then
            if fullcmd[2] ~= nil then
                TriggerClientEvent("onGetNearbyPed", source, tostring(fullcmd[2]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/getnearbyped [ radius ]")
            end
            CancelEvent()
        elseif cmd == "/getnearbypedwithcar" then
            if fullcmd[2] ~= nil then
                TriggerClientEvent("onGetNearbyPedWithVehicle", source, tostring(fullcmd[2]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/getnearbypedwithcar [ radius ]")
            end
            CancelEvent()
        elseif cmd == "/drivehere" then
            TriggerClientEvent("driveToPoint", source)
            CancelEvent()
        elseif cmd == "/leavecar" then
            TriggerClientEvent("leaveCarPlease", source)
            CancelEvent()
        elseif cmd == "/isflee" then
            TriggerClientEvent("isItFlee", source)
            CancelEvent()
        elseif cmd == "/isangry" then
            TriggerClientEvent("isItAngry", source)
            CancelEvent()
        elseif cmd == "/walktoshop" then
            TriggerClientEvent("walkshop", source)
            CancelEvent()
        elseif cmd == "/removeped" then
            TriggerClientEvent("onRemovePed", source)
            CancelEvent()
        elseif cmd == "/standstill" then
            if fullcmd[2] ~= nil then
                TriggerClientEvent("standstill", source, tostring(fullcmd[2]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/standstill [ ms ]")
            end
            CancelEvent()
        elseif cmd == "/turnme" then
            TriggerClientEvent("onTurnMe", source)
            CancelEvent()
        elseif cmd == "/checkdeath" then
            TriggerClientEvent("onCheckDeath", source)
            CancelEvent()
        elseif cmd == "/savemod" then
            TriggerClientEvent("onSaveMod2", source)
            CancelEvent()
        elseif cmd == "/setlevel" then
            if fullcmd[2] ~= nil then
                TriggerClientEvent("onSetLevel", source, tostring(fullcmd[2]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/setlevel [ lvl ]")
            end
            CancelEvent()
        elseif cmd == "/setexp" then
            if fullcmd[2] ~= nil then
                TriggerClientEvent("onSetExp", source, tostring(fullcmd[2]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/setexp [ exp ]")
            end
            CancelEvent()
        elseif cmd == "/setinstance" then
            if fullcmd[2] ~= nil then
                TriggerClientEvent("onSetInstance", source, tostring(fullcmd[2]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/setinstance [ entrance/inside/done ]")
            end
            CancelEvent()
        elseif cmd == "/deleteinstance" then
            TriggerClientEvent("removeThisInstance", source)
            CancelEvent()
        elseif cmd == "/holdtest" then
            if fullcmd[2] ~= nil and fullcmd[3] ~= nil and fullcmd[4] ~= nil and fullcmd[5] ~= nil then
                TriggerClientEvent("holdObjectTest", source, tostring(fullcmd[2]),tostring(fullcmd[3]),tostring(fullcmd[4]),tostring(fullcmd[5]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/holdtest [ prop_name ] [ rotx ] [ roty ] [ rot z ]")
            end
            CancelEvent()
        elseif cmd == "/wantpvp" then
            TriggerClientEvent("onPvp", source)
            CancelEvent()
        elseif cmd == "/spawnobject" then
            if fullcmd[2] ~= nil and fullcmd[3] ~= nil then
                TriggerClientEvent("onSpawnObject", source, tostring(fullcmd[2]), tostring(fullcmd[3]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/spawnobject [ name ] [ z addition ] ")
            end
            CancelEvent()
        elseif cmd == "/deleteobject" then
            TriggerClientEvent("onDeleteObject", source)
            CancelEvent()
        elseif cmd == "/getnetid" then
            TriggerClientEvent("onGetNetIdDrop", source)
            CancelEvent()
        elseif cmd == "/rotateobject" then
            if fullcmd[2] ~= nil and fullcmd[3] ~= nil and fullcmd[4] ~= nil then
                TriggerClientEvent("onSetRot", source, tostring(fullcmd[2]),tostring(fullcmd[3]),tostring(fullcmd[4]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/rotateobject [ x ] [ y ] [ z ]")
            end
            CancelEvent()
        elseif cmd == "/canifish" then
            TriggerClientEvent("checkIfCanFish", source)
            CancelEvent()
        elseif cmd == "/amistill" then
            TriggerClientEvent("checkIfAmStill", source)
            CancelEvent()
        elseif cmd == "/rangecheck" then
            if fullcmd[2] ~= nil then
                TriggerClientEvent("onRangeFlag", source, tostring(fullcmd[2]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/rangecheck [ radius ]")
            end
            CancelEvent()
        elseif cmd == "/sume" then
            if fullcmd[2] ~= nil and fullcmd[3] ~= nil then
                TriggerClientEvent("onSuspectCriminal", source, tostring(fullcmd[2]), tostring(fullcmd[3]))
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/sume [ reason Id ] [Escaped time]")
            end
            CancelEvent()
        elseif cmd == "/suwho" then
            if fullcmd[2] ~= nil and fullcmd[3] ~= nil and fullcmd[4] ~= nil then
                local targetId = tonumber(fullcmd[2])
                if userData[targetId] ~= nil then
                    TriggerClientEvent("onSuspectCriminal", targetId, tostring(fullcmd[3]), tostring(fullcmd[4]))
                else
                     TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "That player doesn't exist")
                end
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/suwho [id of target ] [ reason Id ] [Escaped time]")
            end
            CancelEvent()
        elseif cmd == "/pvp" then
            if fullcmd[2] ~= nil then
                local targetId = tonumber(fullcmd[2])
                if userData[targetId] ~= nil then
                    TriggerClientEvent("pvpInvite", targetId, userData[source].NAME, source)
                else
                     TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "That player doesn't exist")
                end
            else
                TriggerClientEvent("chatMessage",source, "[ERROR]", {255, 0, 0}, "/pvp [ id ]")
            end
            CancelEvent()
		end
    end
end)