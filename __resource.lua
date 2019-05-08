--ui_page "hud/status.html"
--resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_script {						-- Server Scripts
	'@mysql-async/lib/MySQL.lua',
	'server/emoji.lua',
	'server/globalVariable.lua',
	'server/sqlUseful.lua',
	'server/function.lua',
 	'server/outsideAPI.lua',
	'server/commands.lua',
	'server/joinNquit.lua',
	'server/syncChat.lua',
	'server/register.lua',
	'server/rpdeath.lua',
	'server/dataSave.lua',
	'server/inventory.lua',
	'server/vehicleShop.lua',
	'server/vehicleRecieve.lua',
	'server/inventoryEvents.lua',
	'server/levelSystem.lua',
	'server/instanceSystem.lua',
	'server/jobAnnounce.lua',
	'server/dropObject.lua',
	'server/apartmentSystem.lua',
	'server/timerGlobal.lua',
	'server/otherPlayerInteraction.lua',
	'server/pvpSystem.lua'
}

client_script "@warmenu/warmenu.lua"

client_script {						-- Client Scripts
	'client/variables.lua',
	'client/clothesInfo.lua',
	'client/entityAPI.lua',
	'client/function.lua',
	'client/usefulEvent.lua',
	'client/blips.lua',
	'client/markers.lua',
	'client/stamina.lua',
	'client/nowanted.lua',
	'client/moneyAPI.lua',
	'client/register.lua',
	'client/rpdeath.lua',
	'client/spawn.lua',
	'client/dataSave.lua',
	'client/playerActions.lua',
	'client/clothesActions.lua',
	'client/inventory.lua',
	'client/inventoryEvents.lua',
	'client/appearanceCustomization.lua',
	'client/tester.lua',
	'client/gunShop.lua',
	'client/foodShop.lua',
	'client/vehicleShop.lua',
	'client/vehicleRecieve.lua',
	'client/removeWeaponsDrop.lua',
	'client/jobCenter.lua',
	'client/woodJob.lua',
	'client/doctorJob.lua',
	'client/shopJob.lua',
	'client/repairJob.lua',
	'client/taxiJob.lua',
	'client/taxiJob2.lua',
	'client/deliverJob.lua',
	'client/deliverJob2.lua',
	'client/truckerJob2.lua',
	'client/levelSystem.lua',
	'client/instanceSystem.lua',
	'client/dropObject.lua',
	'client/fishSystem.lua',
	'client/fishingJob.lua',
	'client/apartmentSystem.lua',
	'client/apartmentStoreSystem.lua',
	'client/otherPlayerInteraction.lua',
	'client/pawnShop.lua',
	'client/clothesShop.lua',
	'client/policeJob.lua',
	'client/criminalSystem.lua',


	--'client/uiHud.lua',
	'client/confirmMenu.lua',



	'client/paydaySystem.lua',

	'client/pvpSystem.lua'
}

files {
    "hud/status.html"
}