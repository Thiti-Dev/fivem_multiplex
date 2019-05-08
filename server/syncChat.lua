  AddEventHandler('chatMessage', function(source, name, message)
    if userData[source] then
      if string.sub(message, 1, string.len("/")) ~= "/" then
          --local name = GetPlayerName(source)
          local name = userData[source].NAME
          message = Emojit(message)
		TriggerClientEvent("sendProximityMessage", -1, source, name, message)
      end
      CancelEvent()
    end
  end)