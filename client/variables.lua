playerData = {
    CHARACTER_NAME="NONE",GENDER="NONE",MONEY=0,LOGGEDIN=false,LOADINV=false,HOLDING="NONE",
    JOB="NONE",LEVEL=1,EXP=1,X=0,Y=0,Z=0,HEADING=0,INVENTORY={},NOMOREINV={},
    APPEARANCE={HAIR="NONE",FACE="NONE",SHIRT="NONE",PANT="NONE",SHOE="None"},
    listCriminal={},jailTime=0
}


playerTempData = {
    DEADNOW=false,FIRSTSPAWN=true,CURRENTMENU=nil,HOLDINGOBJECT=nil,UNIFORM="NONE",INSIDE="NONE",
    DRAG=false,DRAGGER=nil,STILLDRAG=false,handCuffed=false
}
playerVehicles = {}
playerApartments = {}
playerApartmentsItemRemoveTask = {}


--Pvp system
isPlayingPvp = false
-----------



RegisterNetEvent("getVehicleData")
AddEventHandler("getVehicleData", function(target,cb)
    for _ , x in ipairs(playerVehicles) do
        if x.PLATE == target then
            cb(true)
            return true
        end
    end
    cb(false)
    return false
end)