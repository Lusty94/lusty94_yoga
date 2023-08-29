local QBCore = exports['qb-core']:GetCoreObject()


--Blip
CreateThread(function()
    for k, v in pairs(Config.Blips) do
        if v.useblip then
            v.blip = AddBlipForCoord(v['coords'].x, v['coords'].y, v['coords'].z)
            SetBlipSprite(v.blip, v.id)
            SetBlipDisplay(v.blip, 4)
            SetBlipScale(v.blip, v.scale)
            SetBlipColour(v.blip, v.colour)
            SetBlipAsShortRange(v.blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(v.title)
            EndTextCommandSetBlipName(v.blip)
        end
    end
end)


--Yoga Mat Store
RegisterNetEvent("lusty94_yoga:client:openYogaStore", function()
    if Config.CoreSettings.Shop.Enabled then
        if Config.CoreSettings.Shop.Type == 'qb' then
            TriggerServerEvent("inventory:server:OpenInventory", "shop", "Yoga", Config.InteractionLocations.Store.Items)
        elseif Config.CoreSettings.Shop.Type == 'jim' then
            TriggerServerEvent("jim-shops:ShopOpen", "shop", "Yoga", Config.InteractionLocations.Store.Items)
        end
    end
end)


--
RegisterNetEvent('lusty94_yoga:client:UseYogaMat', function()
    local player = PlayerPedId()
    local coords    = GetEntityCoords(player)
    local x, y, z   = table.unpack(coords)        
    local prop = `prop_yoga_mat_03` 

    RequestModel(prop)
    while (not HasModelLoaded(prop)) do
        Wait(1)
    end

    local prop = CreateObject(prop, x, y, z, true, false, true)
    local heading   = GetEntityHeading(prop)
    PlaceObjectOnGroundProperly(prop)
    SetEntityAsMissionEntity(prop)
    SetEntityHeading(PlayerPedId(), heading + 90)
    
    QBCore.Functions.TriggerCallback('lusty94_yoga:get:YogaMat', function(HasItems)  
        if HasItems then
            QBCore.Functions.Progressbar("YogaMat", Config.Language.YogaMat.ProgressBarName, Config.CoreSettings.ProgressBar.PerformYoga, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = Config.Animations.YogaMat.AnimDict,
                anim = Config.Animations.YogaMat.Anim,
                flags = Config.Animations.YogaMat.Flags,
            }, {}, {}, function()
                if Config.CoreSettings.Effects.AddHealth then
                    SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + Config.CoreSettings.Effects.HealthAmount)
                end
                if Config.CoreSettings.Effects.AddArmour then
                    AddArmourToPed(PlayerPedId(), Config.CoreSettings.Effects.ArmourAmount)
                end
                if Config.CoreSettings.Effects.RemoveStress then
                    TriggerServerEvent(Config.CoreSettings.EventNames.HudStatus, Config.CoreSettings.Effects.RemoveStressAmount)
                end
                if Config.CoreSettings.Notify.Type == 'qb' then
                    QBCore.Functions.Notify(Config.Language.YogaMat.NotifyName, "success", Config.CoreSettings.Notify.SuccessLength)
                elseif Config.CoreSettings.Notify.Type == 'okok' then
                    exports['okokNotify']:Alert(Config.Language.YogaMat.NotifyLabel, Config.Language.YogaMat.NotifyName, Config.CoreSettings.Notify.SuccessLength, 'success', Config.CoreSettings.Notify.UseSound)
                elseif Config.CoreSettings.Notify.Type == 'mythic' then
                    exports['mythic_notify']:DoHudText('success', Config.Language.YogaMat.NotifyName)
                elseif Config.CoreSettings.Notify.Type == 'boii' then
                    exports['boii_ui']:notify(Config.Language.YogaMat.NotifyLabel, Config.Language.YogaMat.NotifyName, 'success', Config.CoreSettings.Notify.SuccessLength)
                elseif Config.CoreSettings.Notify.Type == 'ox' then
                    lib.notify({ title = Config.Language.YogaMat.NotifyLabel, description = Config.Language.YogaMat.NotifyName, type = 'success', duration = Config.CoreSettings.Notify.SuccessLength})
                end
                Wait(1000)
                ClearPedTasks(PlayerPedId())
                DeleteEntity(prop)
            end, function()
                ClearPedTasks(PlayerPedId())
                DeleteEntity(prop)
                if Config.CoreSettings.Notify.Type == 'qb' then
                    QBCore.Functions.Notify(Config.Language.Notifications.CancelledLabel, "error", Config.CoreSettings.Notify.ErrorLength)
                elseif Config.CoreSettings.Notify.Type == 'okok' then
                    exports['okokNotify']:Alert(Config.Language.Notifications.CancelledLabel, Config.Language.Notifications.CancelledLabel, Config.CoreSettings.Notify.ErrorLength, 'error', Config.CoreSettings.Notify.UseSound)
                elseif Config.CoreSettings.Notify.Type == 'mythic' then
                    exports['mythic_notify']:DoHudText('error', Config.Language.Notifications.CancelledLabel)
                elseif Config.CoreSettings.Notify.Type == 'boii' then
                    exports['boii_ui']:notify(Config.Language.Notifications.CancelledLabel, Config.Language.Notifications.CancelledLabel, 'error', Config.CoreSettings.Notify.ErrorLength)
                elseif Config.CoreSettings.Notify.Type == 'ox' then
                    lib.notify({ title = Config.Language.Notifications.CancelledLabel, description = Config.Language.Notifications.CancelledLabel, type = 'error', duration = Config.CoreSettings.Notify.ErrorLength})
                end
            end) 
        else
            if Config.CoreSettings.Notify.Type == 'qb' then
                QBCore.Functions.Notify(Config.Language.Notifications.MissingItemsName, "error", Config.CoreSettings.Notify.ErrorLength)
            elseif Config.CoreSettings.Notify.Type == 'okok' then
                exports['okokNotify']:Alert(Config.Language.Notifications.MissingItemsLabel,Config.Language.Notifications.MissingItemsName, Config.CoreSettings.Notify.ErrorLength, 'error', Config.CoreSettings.Notify.UseSound)
            elseif Config.CoreSettings.Notify.Type == 'mythic' then
                exports['mythic_notify']:DoHudText('error', Config.Language.Notifications.MissingItemsName) 
            elseif Config.CoreSettings.Notify.Type == 'boii' then
                exports['boii_ui']:notify(Config.Language.Notifications.MissingItemsLabel, Config.Language.Notifications.MissingItemsName, 'error', Config.CoreSettings.Notify.ErrorLength)
            elseif Config.CoreSettings.Notify.Type == 'ox' then
                lib.notify({ title = Config.Language.Notifications.MissingItemsLabel, description = Config.Language.Notifications.MissingItemsName, type = 'error', duration = Config.CoreSettings.Notify.ErrorLength})
            end
        end
    end)       
end)




AddEventHandler('onResourceStop', function(resourceName) if resourceName ~= GetCurrentResourceName() then return end
    if (GetCurrentResourceName() ~= resourceName) then        
        return
    end
        print('^5--<^3!^5>-- ^7Lusty94 ^5| ^5--<^3!^5>--^Yoga V1.1.0 Stopped Successfully^5--<^3!^5>--^7')

        if Config.CoreSettings.Target.Type == 'qb' then
        exports['qb-target']:RemoveZone("StoreZone")
        elseif Config.CoreSettings.Type == 'ox' then
            exports.ox_target:removeZone(1)
        elseif Config.CoreSettings.Target.Type == 'custom' then
            -- insetrt custom code for removing shop zone
        end
end)