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
    if mat and mat.amount >= 1 then
        cb(true)
    else
        cb(false)
    end
end)


--qb-inventory yoga shop
RegisterNetEvent('lusty94_yoga:server:openYogaStore', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local YogaShop = {
        { name = "yogamat",         price = 50, amount = 100, info = {}, type = "item", slot = 1,}, 
        { name = "water_bottle",    price = 10, amount = 100, info = {}, type = "item", slot = 2,},
    }
    exports['qb-inventory']:CreateShop({
        name = 'YogaShop',
        label = 'Yoga Shop',
        slots = 2,
        items = YogaShop
    })
    if Player then
        exports['qb-inventory']:OpenShop(source, 'YogaShop')
    end
end)

--shop for ox_inventory
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        if InvType == 'ox' then
            if Config.CoreSettings.Shop.Enabled then
                exports.ox_inventory:RegisterShop('YogaShop', {
                    name = 'Yoga Shop',
                    inventory = {
                        { name = 'yogamat', price = 50 },
                        { name = 'water_bottle', price = 10 },
                    },
                })
            end
        end
    end
end)

--------------< VERSION CHECK >-------------

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/Lusty94/UpdatedVersions/main/Yoga/version.txt', function(err, newestVersion, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')
        if not newestVersion then
            print('^1[Lusty94_Yoga]^7: Unable to fetch the latest version.')
            return
        end

        newestVersion = newestVersion:gsub('%s+', '')
        currentVersion = currentVersion and currentVersion:gsub('%s+', '') or 'Unknown'

        if newestVersion == currentVersion then
            print(string.format('^2[Lusty94_Yoga]^7: ^6You are running the latest version.^7 (^2v%s^7)', currentVersion))
        else
            print(string.format('^2[Lusty94_Yoga]^7: ^3Your version: ^1v%s^7 | ^2Latest version: ^2v%s^7\n^1Please update to the latest version | Changelogs can be found in the support discord.^7', currentVersion, newestVersion))
        end
    end)
end

CheckVersion()