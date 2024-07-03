local QBCore = exports['qb-core']:GetCoreObject()
local InvType = Config.CoreSettings.Inventory.Type

--Useable Yoga Mat
QBCore.Functions.CreateUseableItem("yogamat", function(source, item)
    TriggerClientEvent("lusty94_yoga:client:PlaceYogaMat", source)
end)

--Yoga Mat Callback
QBCore.Functions.CreateCallback('lusty94_yoga:get:YogaMat', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local mat = Player.Functions.GetItemByName("yogamat")
    if mat then
        cb(true)
    else
        cb(false)
    end
end)

--smoking shop
function yogaShop()
    exports.ox_inventory:RegisterShop('yogaShop', {
        name = 'Yoga Shop',
        inventory = {
            { name = 'yogamat', price = 50 },
            { name = 'water_bottle', price = 10 },
        },
    })
end


-- dont touch this is for ox stashes and shops
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        if InvType == 'ox' then
            if Config.CoreSettings.Shop.Enabled then
                print('^5--<^3!^5>-- ^7| Lusty94_Yoga |^5 ^5--<^3!^5>--^7')
                print('^5--<^3!^5>-- ^7| Inventory Type is set to ox |^5 ^5--<^3!^5>--^7')
                print('^5--<^3!^5>-- ^7| Registering shops automatically |^5 ^5--<^3!^5>--^7')
                yogaShop()
                print('^5--<^3!^5>-- ^7| Shops registered successfully |^5 ^5--<^3!^5>--^7')
            end
        end
    end
end)

local function CheckVersion()
	PerformHttpRequest('https://raw.githubusercontent.com/Lusty94/UpdatedVersions/main/Yoga/version.txt', function(err, newestVersion, headers)
		local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')
		if not newestVersion then print("Currently unable to run a version check.") return end
		local advice = "^1You are currently running an outdated version^7, ^1please update^7"
		if newestVersion:gsub("%s+", "") == currentVersion:gsub("%s+", "") then advice = '^6You are running the latest version.^7'
		else print("^3Version Check^7: ^2Current^7: "..currentVersion.." ^2Latest^7: "..newestVersion..advice) end
	end)
end
CheckVersion()