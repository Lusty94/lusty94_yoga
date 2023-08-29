local QBCore = exports['qb-core']:GetCoreObject()

if Config.CoreSettings.Shop.Enabled then
    if Config.CoreSettings.Target.Type == 'qb' then
            --Yoga Mat Store
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
    elseif Config.CoreSettings.Target.Type == 'ox' then
            --Yoga Mat Store
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
    elseif Config.CoreSettings.Target.Type == 'custom' then
        --insert your custom target code here
    end
end