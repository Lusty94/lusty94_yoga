local QBCore = exports['qb-core']:GetCoreObject()
local TargetType = Config.CoreSettings.Target.Type
local ShopType = Config.CoreSettings.Shop.Type

if Config.CoreSettings.Shop.Enabled then
    if TargetType == 'qb' then
            
            exports['qb-target']:AddBoxZone("StoreZone", Config.InteractionLocations.Store.Location.Location, Config.InteractionLocations.Store.Location.Height, Config.InteractionLocations.Store.Location.Width, {
                name = "StoreZone",
                heading = Config.InteractionLocations.Store.Location.Heading,
                debugPoly = Config.DebugPoly,
                minZ = Config.InteractionLocations.Store.Location.MinZ,
                maxZ = Config.InteractionLocations.Store.Location.MaxZ,
            }, {
                options = {
                    {
                        
                        event = "lusty94_yoga:client:openYogaStore",
                        label = Config.InteractionLocations.Store.Location.Label,
                        icon = Config.InteractionLocations.Store.Location.Icon,
                    }
                },
                distance = 1.5,
            })
    elseif TargetType == 'ox' then
            if ShopType == 'ox' then
                print('ox target disabled for yoga shop boxzone - is now handled via ox_inventory - make sure you have added the required snippet from the readme file!')
            else
                exports.ox_target:addBoxZone({
                    coords = Config.InteractionLocations.Store.Location.Location,
                    size = Config.InteractionLocations.Store.Location.Size,
                    rotation = Config.InteractionLocations.Store.Location.Heading,
                    debug = Config.DebugPoly,
                    options = {
                        {
                            id = 1,
                            event = 'lusty94_yoga:client:openYogaStore',
                            label = Config.InteractionLocations.Store.Location.Label,
                            icon = Config.InteractionLocations.Store.Location.Icon,
                        }
                    }
                })
            end
    elseif Config.CoreSettings.Target.Type == 'custom' then
        --insert your custom target code here
    end
end