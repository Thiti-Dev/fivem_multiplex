RegisterServerEvent("onApartmentRent")
AddEventHandler("onApartmentRent", function(owner,place,invstring)
    print("On Aps rent")
    MySQL.Async.execute(
    'INSERT INTO apartments (owner , place, inventory, expired) VALUES (@owner , @places, @inventorys, @expireds)',
    {
        ['@owner']       = owner,
        ['@places']   =  place,
        ['@inventorys']   =  invstring,
        ['@expireds']   =  "NEVER",
    })
end)