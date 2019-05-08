local showMeConfirmMenu = false
local confirmText = ""
local menuTargetCalledFunction = {
    funcName = "",
    args = nil
}

RegisterCommand("showmenuforme", function(source, args, rawCommand)
    if args[1] and args[2] and args[3] then
        showMeConfirmMenu = true
        TriggerEvent("confirmMenuCreate", args[1],args[2],args[3])
        TriggerEvent("chatMessage", "^1[^2 🔗 Tester ^1] ", {1,170,0}, "Turn menu ON")
    else
        TriggerEvent("chatMessage", "^1[^2 🔗 Tester ^1] ", {1,170,0}, "/showmenuforme [text] [function_name] [args]")
    end
end)

AddEventHandler("confirmMenuCreate", function(text,func,args)
    confirmText = text
    menuTargetCalledFunction.funcName = func
    menuTargetCalledFunction.args = args
    showMeConfirmMenu = true
end)

function onConfirmClicked()
    MenuCallFunction(menuTargetCalledFunction.funcName, menuTargetCalledFunction.args)
end


 function MenuCallFunction(fnc, arg)
	_G[fnc](arg)
end


function testFunction(arg)
    TriggerEvent("chatMessage", "^1[^2 🔗 Tester ^1] ", {1,170,0}, "Testfunc called with additional = " .. arg)
end

function DrawTextMenu(caption, xPos, yPos, scale, r, g, b, alpha, font, justify, shadow, outline)
 
 
     if not IsHudPreferenceSwitchedOn() or IsHudHidden() then
         return
     end
 
     local x = xPos
     local y = yPos
 
     SetTextFont(font);
     SetTextScale(1.0, scale);
     SetTextColour(r, g, b, alpha);
 
     if shadow then SetTextDropShadow() end
     if outline then SetTextOutline() end
 
     if justify == 1 then
         SetTextCentre(true)
     elseif justify == 2 then
         SetTextRightJustify(true)
         SetTextWrap(0, x)
     end
 
     BeginTextCommandDisplayText("STRING")
     local maxStringLength = 99
     for i = 0, #caption, maxStringLength do
         AddTextComponentSubstringPlayerName(string.sub(caption, i, #caption))
     end
     EndTextCommandDisplayText(x, y)
 end


Citizen.CreateThread(function()
     while true do
        if showMeConfirmMenu then
            --isCursor = true
            ShowCursorThisFrame()
            local x,y = GetCursorPosition()

            -- showing phase right now 
            DrawRect(0.50, 0.50, 0.33, 0.33, 0, 0, 0, 120) -- background main
            DrawRect(0.50, 0.37, 0.33, 0.08, 255, 0, 0, 120) -- background title
            DrawTextMenu("Confirmation Menu", 0.37, 0.34, 1.0, 255, 255, 255, 255, 7, 0, false, true, 0, 0, 0)
            if x >= 0.409 and x <= 0.489 and y >= 0.585 and y <= 0.664 then
                DrawRect(0.45, 0.625, 0.08, 0.08, 0, 255, 0, 90) -- ok hover
            else
                DrawRect(0.45, 0.625, 0.08, 0.08, 0, 0, 0, 90) -- ok hover
            end
            DrawTextMenu("CONFIRM", 0.412, 0.59, 1.0, 255, 255, 255, 180, 4, 0, false, false, 0, 0, 0)
            if x >= 0.499 and x <= 0.578 and y >= 0.585 and y <= 0.664 then
                DrawRect(0.54, 0.625, 0.08, 0.08, 0, 255, 0, 90) -- cancel hover
            else
                DrawRect(0.54, 0.625, 0.08, 0.08, 0, 0, 0, 90) -- cancel hover
            end
            DrawTextMenu("CANCEL", 0.51, 0.59, 1.0, 255, 255, 255, 180, 4, 0, false, false, 0, 0, 0)

            DrawTextMenu(confirmText, 0.495, 0.49, 0.55, 255, 255, 255, 195, 4, 1, false, false, 0, 0, 0) -- text mid
            ------------------------

			DisableControlAction(0, 1, true)		-- Mouse Look, Left/Right
			DisableControlAction(0, 2, true)		-- Mouse Look, Up/Down
            DisableControlAction(0, 24, true)	-- Right Click

        else
            --None
        end

        if IsDisabledControlJustPressed(1, 24) then
            if showMeConfirmMenu then
                local x,y = GetCursorPosition()
                TriggerEvent("chatMessage", "^1[^2 🔗 Tester ^1] ", {1,170,0}, "X : " .. x .. "Y : " .. y)
                if x >= 0.409 and x <= 0.489 and y >= 0.585 and y <= 0.664 then
                    onConfirmClicked()
                    showMeConfirmMenu = false
                elseif x >= 0.499 and x <= 0.578 and y >= 0.585 and y <= 0.664 then
                    showMeConfirmMenu = false
                end
            end
        end

        Wait(0)
     end
 end)
 