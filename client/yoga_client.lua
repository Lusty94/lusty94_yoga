local QBCore = exports['qb-core']:GetCoreObject()
local TargetType = Config.CoreSettings.Target.Type
local InvType = Config.CoreSettings.Inventory.Type
local NotifyType = Config.CoreSettings.Notify.Type
local busy, matSpawned, hasPerformed = false, false, false
local yogaprop = nil


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
            v.blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
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




--target settings
CreateThread(function()
    if Config.CoreSettings.Shop.Enabled then
        for k,v in pairs(Config.InteractionLocations) do
            if TargetType == 'qb' then
                exports['qb-target']:AddBoxZone(v.Name, v.Coords, v.Width, v.Height, 
                { 
                    name = v.Name, 
                    heading = v.Heading, 
                    debugPoly = Config.DebugPoly, 
                    minZ = v.MinZ, 
                    maxZ = v.MaxZ, 
                }, 
                { 
                    options = { 
                        { 
                            type = "client", 
                            action = function()
                                if not busy then
                                    openYogaStore()
                                else
                                    SendNotify(Config.Language.Notifications.Busy, 'error', 5000)
                                end
                            end,
                            icon = v.Icon, 
                            label = v.Label,
                        } 
                    }, 
                    distance = v.Distance,
                })
            elseif TargetType =='ox' then
                exports.ox_target:addBoxZone(
                    {
                        coords = v.Coords,
                        size = v.Size,
                        rotation = v.Heading,
                        debug = Config.DebugPoly,
                        options = {
                            { 
                                id = v.Name, 
                                onSelect = function()
                                    if not busy then
                                        openYogaStore()
                                    else
                                        SendNotify(Config.Language.Notifications.Busy, 'error', 5000)
                                    end
                                end,
                                label = v.Label, 
                                icon = v.Icon, 
                                distance = v.Distance, 
                            }
                        },
                    })
            elseif TargetType == 'custom' then
                --insert your own custom target code here
            end
        end
    end
end)



--use yoga mat
RegisterNetEvent('lusty94_yoga:client:PlaceYogaMat', function()
    QBCore.Functions.TriggerCallback('lusty94_yoga:get:YogaMat', function(HasItems)  
        if HasItems then
            if busy then
                SendNotify(Config.Language.Notifications.Busy, 'error', 5000)
            else
                if matSpawned then
                    SendNotify(Config.Language.Notifications.RemoveMat, 'error', 5000)
                    return
                end
                busy = true
                if lib.progressCircle({ 
                    duration = Config.CoreSettings.Timers.PlaceMat, 
                    label = Config.Language.ProgressBar.PlaceMat, 
                    position = 'bottom', 
                    useWhileDead = false, 
                    canCancel = true, 
                    disable = { car = true, move = true, combat = true, mouse  = false, }, 
                    anim = { 
                        dict = Config.Animations.PlaceYogaMat.dict, 
                        clip = Config.Animations.PlaceYogaMat.anim, 
                        flag = Config.Animations.PlaceYogaMat.flag,
                    }, 
                }) then
                    local playerPed = PlayerPedId()
                    local coords    = GetEntityCoords(playerPed)
                    local x, y, z   = table.unpack(coords)        
                    local mat = `prop_yoga_mat_03`
                    lib.requestModel(mat, 5000)
                    yogaprop = CreateObject(mat, x, y, z, true, false, true)
                    PlaceObjectOnGroundProperly(yogaprop)
                    SetEntityAsMissionEntity(yogaprop)
                    local heading   = GetEntityHeading(yogaprop)
                    SetEntityHeading(playerPed, GetEntityHeading(playerPed))
                    if TargetType == 'qb' then
                        exports['qb-target']:AddTargetEntity(yogaprop, { 
                            options = { 
                                { 
                                    type = "client", 
                                    action = function()
                                        if not busy then
                                            performYoga()
                                        else
                                            SendNotify(Config.Language.Notifications.Busy, 'error', 5000)
                                        end
                                    end,
                                    icon = 'fa-solid fa-hand-point-up', 
                                    label = 'Perform Yoga', 
                                }, 
                                { 
                                    type = "client", 
                                    action = function()
                                        if not busy then
                                            removeYogaMat()
                                        else
                                            SendNotify(Config.Language.Notifications.Busy, 'error', 5000)
                                        end
                                    end,
                                    icon = 'fa-solid fa-hand-point-up', 
                                    label = 'Remove Yoga Mat', 
                                },
                            }, 
                            distance = 1.75,
                        })
                    elseif TargetType == 'ox' then
                        exports.ox_target:addLocalEntity(yogaprop, { 
                            { 
                                name = 'yogaprop', 
                                icon = 'fa-solid fa-hand-point-up', 
                                label = 'Perform Yoga', 
                                onSelect = function()
                                    if not busy then
                                        performYoga()
                                    else
                                        SendNotify(Config.Language.Notifications.Busy, 'error', 5000)
                                    end
                                end,
                                distance = 1.75,
                            }, 
                            { 
                                name = 'yogaprop', 
                                icon = 'fa-solid fa-hand-point-up', 
                                label = 'Remove Yoga Mat', 
                                onSelect = function()
                                    if not busy then
                                        removeYogaMat()
                                    else
                                        SendNotify(Config.Language.Notifications.Busy, 'error', 5000)
                                    end
                                end,
                                distance = 1.75,
                            },
                        })
                    end
                    matSpawned = true
                    busy = false
                else 
                    busy = false
                    SendNotify(Config.Language.Notifications.Cancelled, 'error', 5000)
                end
            end
        else
            SendNotify(Config.Language.Notifications.MissingMat, 'error', 5000)
        end
    end)     
end)

--cooldown function to prevent abuse
function yogaCooldown()
    local timer =  20 * 1000 -- 20 seconds
    if hasPerformed then
        return
    end
    hasPerformed = true
    SetTimeout(timer, function()
        hasPerformed = false
    end)
end

function yogaEffect()
    if Config.CoreSettings.Effects.AddHealth then
        SetEntityHealth(playerPed, GetEntityHealth(playerPed) + Config.CoreSettings.Effects.HealthAmount)
    end
    if Config.CoreSettings.Effects.AddArmour then
        AddArmourToPed(playerPed, Config.CoreSettings.Effects.ArmourAmount)
    end
    if Config.CoreSettings.Effects.RemoveStress then
        TriggerServerEvent(Config.CoreSettings.EventNames.HudStatus, Config.CoreSettings.Effects.RemoveStressAmount)
    end
end

--perform yoga
function performYoga()
    local playerPed = PlayerPedId()
    if hasPerformed then
        SendNotify(Config.Language.Notifications.Wait, 'error', 5000)
        return
    else
        if busy then
            SendNotify(Config.Language.Notifications.Busy, 'error', 5000)
        else
            QBCore.Functions.TriggerCallback('lusty94_yoga:get:YogaMat', function(HasItems)  
                if HasItems then
                    local success = lib.skillCheck({'easy', 'easy', 'easy', 'easy', 'easy'}, {'e'}) -- change skillcheck settings here
                    if success then
                        busy = true
                        local matcoords    = GetEntityCoords(yogaprop)
                        local heading   = GetEntityHeading(yogaprop)
                        SetEntityCoords(playerPed, matcoords.x, matcoords.y, matcoords.z, true, true, true, false)
                        SetEntityHeading(playerPed, heading + 90)
                        if lib.progressCircle({ 
                            duration = Config.CoreSettings.Timers.PerformYoga, 
                            label = Config.Language.ProgressBar.PerformYoga, 
                            position = 'bottom', 
                            useWhileDead = false, 
                            canCancel = true, 
                            disable = { car = true, move = true, combat = true, mouse  = false, }, 
                            anim = { dict = Config.Animations.PerformYoga.dict, clip = Config.Animations.PerformYoga.anim, flag = Config.Animations.PerformYoga.flag, }, 
                        }) then
                            yogaEffect()
                            yogaCooldown()
                            busy = false
                        else 
                            busy = false
                            SendNotify(Config.Language.Notifications.Cancelled, 'error', 5000)
                        end
                    else
                        SendNotify(Config.Language.Notifications.Failed, 'error', 5000)
                    end
                else
                    SendNotify(Config.Language.Notifications.MissingMat, 'error', 5000)
                end
            end)     
        end
    end
end


-- delete yoga mat
function removeYogaMat()
    if yogaprop then
        if TargetType == 'qb' then 
            exports['qb-target']:RemoveTargetEntity(yogaprop, 'yogaprop') 
        elseif TargetType == 'ox' then 
            exports.ox_target:removeLocalEntity(yogaprop, 'yogaprop') 
        end
        if DoesEntityExist(yogaprop) then
            DeleteEntity(yogaprop)
        end
        yogaprop = nil
        matSpawned = false
    end
end


--Yoga Mat Store
function openYogaStore()
    if Config.CoreSettings.Shop.Enabled then
        if InvType == 'qb'then
            TriggerServerEvent('lusty94_yoga:server:openYogaStore')
        elseif InvType == 'ox' then
            exports.ox_inventory:openInventory('shop', { type = 'YogaShop' })
        end
    end
end


--dont touch
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        busy = false
        if DoesEntityExist(yogaprop) then
            DeleteEntity(yogaprop)
        end
        if Config.CoreSettings.Shop.Enabled then for k, v in pairs(Config.InteractionLocations) do if TargetType == 'qb' then exports['qb-target']:RemoveZone(v.Name) elseif TargetType == 'ox' then exports.ox_target:removeZone(v.Name) end end end
        if TargetType == 'qb' then 
            exports['qb-target']:RemoveTargetEntity(yogaprop, 'yogaprop') 
        elseif TargetType == 'ox' then 
            exports.ox_target:removeLocalEntity(yogaprop, 'yogaprop') 
        end
        print('^5--<^3!^5>-- ^7| Lusty94 |^5 ^5--<^3!^5>--^7 Yoga V2.1.0 Stopped Successfully ^5--<^3!^5>--^7')
	end
end)