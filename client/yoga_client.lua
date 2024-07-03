local QBCore = exports['qb-core']:GetCoreObject()
local ShopType = Config.CoreSettings.Shop.Type
local TargetType = Config.CoreSettings.Target.Type
local InventoryType = Config.CoreSettings.Inventory.Type
local NotifyType = Config.CoreSettings.Notify.Type
local busy = false

--notification function
local function SendNotify(msg,type,time,title)
    if NotifyType == nil then print("Lusty94_Yoga: NotifyType Not Set in Config.CoreSettings.Notify.Type!") return end
    if not title then title = "Yoga" end
    if not time then time = 5000 end
    if not type then type = 'success' end
    if not msg then print("Notification Sent With No Message.") return end
    if NotifyType == 'qb' then
        QBCore.Functions.Notify(msg,type,time)
    elseif NotifyType == 'okok' then
        exports['okokNotify']:Alert(title, msg, time, type, true)
    elseif NotifyType == 'mythic' then
        exports['mythic_notify']:DoHudText(type, msg)
    elseif NotifyType == 'boii' then
        exports['boii_ui']:notify(title, msg, type, time)
    elseif NotifyType == 'ox' then
        lib.notify({ title = title, description = msg, type = type, duration = time})
    end
end

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
        local yogaShop = {
            label = "Yoga Store",
            slots = 2,
            items = {
                [1] = { name = "yogamat", price = 50, amount = 100, info = {}, type = "item", slot = 1,},
                [2] = { name = "water_bottle", price = 10, amount = 100, info = {}, type = "item", slot = 2,},
            },
        }
        if ShopType == 'qb'then
            TriggerServerEvent("inventory:server:OpenInventory", "shop", "Yoga", yogaShop)
        elseif ShopType == 'jim' then
            TriggerServerEvent("jim-shops:ShopOpen", "shop", "Yoga", yogaShop)
        elseif ShopType == 'ox' then
            exports.ox_inventory:openInventory('shop', { type = 'yogaShop' })
        end
    end
end)

--target settings
CreateThread(function()
    if Config.CoreSettings.Shop.Enabled then
        for k,v in pairs(Config.InteractionLocations) do
            if TargetType == 'qb' then
                exports['qb-target']:AddBoxZone(v.Name, v.Coords, v.Width, v.Height, { name = v.Name, heading = v.Heading, debugPoly = Config.DebugPoly, minZ = v.MinZ, maxZ = v.MaxZ, }, { options = { { type = "client", event = v.Event, icon = v.Icon, label = v.Label, job = v.Job, item = v.Item, } }, distance = v.Distance, })
            elseif TargetType =='ox' then
                exports.ox_target:addBoxZone({
                    coords = v.Coords, size = v.Size, rotation = v.Heading, debug = Config.DebugPoly, options = { { id = v.Name, item = v.Item, groups = v.Job, event = v.Event, label = v.Label, icon = v.Icon, distance = v.Distance, } }, })
            elseif TargetType == 'custom' then
                --insert your own custom target code here
            end
        end
    end
end)

local yogaprop = nil
local matSpawned = false
--use yoga mat
RegisterNetEvent('lusty94_yoga:client:PlaceYogaMat', function()
    QBCore.Functions.TriggerCallback('lusty94_yoga:get:YogaMat', function(HasItems)  
        if HasItems then
            if busy then
                SendNotify("You Are Already Doing Something!", 'error', 2000)
            else
                if matSpawned then
                    SendNotify("You must remove your yoga mat before placing another!", 'error', 2000)
                    return
                end
                busy = true
                if lib.progressCircle({ duration = Config.CoreSettings.Timers.PlaceMat, label = 'Placing yoga mat...', position = 'bottom', useWhileDead = false, canCancel = true, disable = { car = true, move = true, }, anim = { dict = Config.Animations.PlaceYogaMat.dict, clip = Config.Animations.PlaceYogaMat.anim, flag = Config.Animations.PlaceYogaMat.flag, }, }) then
                    local player = PlayerPedId()
                    local coords    = GetEntityCoords(player)
                    local x, y, z   = table.unpack(coords)        
                    local mat = `prop_yoga_mat_03`
                    RequestModel(mat)
                    while (not HasModelLoaded(mat)) do
                        Wait(1000)
                    end
                    yogaprop = CreateObject(mat, x, y, z, true, false, true)
                    PlaceObjectOnGroundProperly(yogaprop)
                    SetEntityAsMissionEntity(yogaprop)
                    local heading   = GetEntityHeading(yogaprop)
                    SetEntityHeading(PlayerPedId(), heading + 90)
                    if TargetType == 'qb' then
                        exports['qb-target']:AddTargetEntity(yogaprop, { options = { { type = "client", event = 'lusty94_yoga:client:performYoga', icon = 'fa-solid fa-hand-point-up', label = 'Perform Yoga', }, { type = "client", event = 'lusty94_yoga:client:removeYogaMat', icon = 'fa-solid fa-hand-point-up', label = 'Remove Yoga Mat', }, }, distance = 1.75 })
                    elseif TargetType == 'ox' then
                        exports.ox_target:addLocalEntity(yogaprop, { { name = 'yogaprop', icon = 'fa-solid fa-hand-point-up', label = 'Perform Yoga', event = 'lusty94_yoga:client:performYoga',distance = 1.75}, { name = 'yogaprop', icon = 'fa-solid fa-hand-point-up', label = 'Remove Yoga Mat', event = 'lusty94_yoga:client:removeYogaMat',distance = 1.75}, })
                    end
                    matSpawned = true
                    busy = false
                    ClearPedTasks(PlayerPedId())
                    SendNotify("Yoga mat placed!", 'success', 2000)
                else 
                    busy = false
                    ClearPedTasks(PlayerPedId())
                    SendNotify("Action cancelled!", 'success', 2000)
                end
            end
        else
            SendNotify("How can you place a yoga mat without one?!", 'error', 2500)
        end
    end)     
end)


--use yoga mat
RegisterNetEvent('lusty94_yoga:client:performYoga', function()
    QBCore.Functions.TriggerCallback('lusty94_yoga:get:YogaMat', function(HasItems)  
        if HasItems then
            if busy then
                SendNotify("You Are Already Doing Something!", 'error', 2000)
            else
                local success = lib.skillCheck({'easy', 'easy', 'easy', 'easy', 'easy'}, {'e'})
                if success then
                    busy = true
                    local matcoords    = GetEntityCoords(yogaprop)
                    local heading   = GetEntityHeading(yogaprop)
                    SetEntityCoords(PlayerPedId(), matcoords.x, matcoords.y, matcoords.z, true, true, true, false)
                    SetEntityHeading(PlayerPedId(), heading + 90)
                    if lib.progressCircle({ duration = Config.CoreSettings.Timers.PerformYoga, label = 'Performing yoga...', position = 'bottom', useWhileDead = false, canCancel = true, disable = { car = true, move = true, }, anim = { dict = Config.Animations.PerformYoga.dict, clip = Config.Animations.PerformYoga.anim, flag = Config.Animations.PerformYoga.flag, }, }) then
                        if Config.CoreSettings.Effects.AddHealth then
                            SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + Config.CoreSettings.Effects.HealthAmount)
                        end
                        if Config.CoreSettings.Effects.AddArmour then
                            AddArmourToPed(PlayerPedId(), Config.CoreSettings.Effects.ArmourAmount)
                        end
                        if Config.CoreSettings.Effects.RemoveStress then
                            TriggerServerEvent(Config.CoreSettings.EventNames.HudStatus, Config.CoreSettings.Effects.RemoveStressAmount)
                        end
                        busy = false
                        ClearPedTasks(PlayerPedId())
                        SendNotify("You performed yoga!", 'success', 2000)
                    else 
                        busy = false
                        ClearPedTasks(PlayerPedId())
                        SendNotify("Action cancelled!", 'success', 2000)
                    end
                else
                    SendNotify("Action failed.", 'error', 2000)
                end
            end
        else
            SendNotify("How can you perform yoga without a yoga mat?!", 'error', 2500)
        end
    end)     
end)


--delete yoga mat prop
local function delete_prop(model)
    if DoesEntityExist(model) then
        DeleteEntity(model)
    end
end



-- delete yoga mat
RegisterNetEvent('lusty94_yoga:client:removeYogaMat', function()
    if yogaprop then
        if TargetType == 'qb' then exports['qb-target']:RemoveTargetEntity(yogaprop, 'yogaprop') elseif TargetType == 'ox' then exports.ox_target:removeLocalEntity(yogaprop, 'yogaprop') end
        delete_prop(yogaprop)
        yogaprop = nil
        matSpawned = false
    end
end)

--dont touch
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        busy = false
        delete_prop(yogaprop)
        if Config.CoreSettings.Shop.Enabled then for k, v in pairs(Config.InteractionLocations) do if TargetType == 'qb' then exports['qb-target']:RemoveZone(v.Name) elseif TargetType == 'ox' then exports.ox_target:removeZone(v.Name) end end end
        if TargetType == 'qb' then exports['qb-target']:RemoveTargetEntity(yogaprop, 'yogaprop') elseif TargetType == 'ox' then exports.ox_target:removeLocalEntity(yogaprop, 'yogaprop') end
        print('^5--<^3!^5>-- ^7| Lusty94 |^5 ^5--<^3!^5>--^7 Yoga V2.0.0 Stopped Successfully ^5--<^3!^5>--^7')
	end
end)