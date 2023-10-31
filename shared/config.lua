Config = {}

--
--██╗░░░░░██╗░░░██╗░██████╗████████╗██╗░░░██╗░█████╗░░░██╗██╗
--██║░░░░░██║░░░██║██╔════╝╚══██╔══╝╚██╗░██╔╝██╔══██╗░██╔╝██║
--██║░░░░░██║░░░██║╚█████╗░░░░██║░░░░╚████╔╝░╚██████║██╔╝░██║
--██║░░░░░██║░░░██║░╚═══██╗░░░██║░░░░░╚██╔╝░░░╚═══██║███████║
--███████╗╚██████╔╝██████╔╝░░░██║░░░░░░██║░░░░█████╔╝╚════██║
--╚══════╝░╚═════╝░╚═════╝░░░░╚═╝░░░░░░╚═╝░░░░╚════╝░░░░░░╚═╝


-- Thank you for downloading this script!

-- Below you can change multiple options to suit your server needs.

Config.DebugPoly = false

Config.Blips = {
    {title = 'Yoga Store', colour = 5, id = 409, coords = vector3(-1167.63, -1586.75, 3.96), scale = 0.7, useblip = true}, -- BLIP FOR YOGA STORE
}


Config.CoreSettings = {
    Notify = {
        Type = 'qb', -- support for qb-core notify, okokNotify, mythic_notify, boii_ui notify and ox_lib notify
        --use 'qb' for default qb-core notify
        --use 'okok' for okokNotify
        --use 'mythic' for mythic_notify
        --use 'boii' for boii_ui notify
        --use 'ox' for ox_lib notify
        UseSound = true, -- uses sound for okokNotify
        SuccessLength = 2500, -- success notification length
        ErrorLength = 2500, -- error notification length
    },
    Target = {
        Type = 'qb' -- support for qb-target and ox_target
        --use 'qb' for qb-target
        --use 'ox' for ox_target
    },
    Shop = {
        Enabled = true, -- set to true to use the inbuilt shop system [QB INVENTORY ONLY] [DONT FORGET TO EDIT CONFIG.INTERACTIONLOCATIONS.STORE] - set to false if you are using your own methods to obtain the item
        Type = 'qb', -- support for qb-inventory shops, jim-shops and ox_inventory shops - IF USING OX INVENTORY YOU MUST CREATE YOUR OWN SHOP INSIDE OX_INVENTORY TO ACCESS THE SUPPLIES STORE USING THE SNIPPET PROVIDED IN THE README FILE
        --use 'qb' for qb-shops
        --use 'jim' for jim-shops
        --use 'ox' for ox_inventory shops
    },
    Inventory = { --support for qb-inventory and ox_inventory
        Type = 'qb',
        --use 'qb' for qb-inventory
        --use 'ox' for ox_inventory
    },
    ProgressBar = {
        PerformYoga = 15000, -- time it takes in MS to perform yoga, defualt is set to 15 seconds [15000 ms]  to prevent abuse and exploits
    },
    EventNames = {
        HudStatus = 'hud:server:RelieveStress', -- NAME OF HUD EVENT TO RELIEVE STRESS - DEFAULT EVENT NAME IS 'hud:server:RelieveStress'
    },    
    Effects = {
        AddHealth = true, -- set to true to add health to a player when using a yoga mat
        HealthAmount = math.random(10,20), -- if set to true then how much health does the player gain?

        AddArmour = true, -- set to true to add armour to a player when using a yoga mat
        ArmourAmount = math.random(10,20), -- if set to true then how much armour does the player gain?

        RemoveStress = true, -- set to true to remove stress when using a yoga mat
        RemoveStressAmount = math.random(10,20), -- if set to true then how much stress relief does the player get?
        
    },
}


Config.InteractionLocations = { -- this section is only relevant if Config.CoreSettings.Shop.Enabled is set to true otherwise you can ignore this as it just creates a box zone to purchase a yoga mat from
    Store = {
        Location = {
            Location = vector3(-1162.7, -1585.86, 4), -- location of boxzone
            Width = 1.5, --width of boxzone
            Height = 0.5, -- height of boxzone
            Heading = 287.44, -- heading of boxzone
            MinZ = 3.25, -- minz of boxzone
            MaxZ = 4.5, -- maxz of boxzone
            Icon = 'fa-solid fa-cash-register', -- icon for target
            Label = 'Open Yoga Store', -- label for target
            Size = vec3(1.5,0.5,1), -- ONLY USED FOR OX_TARGET
        },
        Items = {
            label = "Yoga Store",
            slots = 2,
            items = {
                [1] = { name = "yogamat", price = 50, amount = 100, info = {}, type = "item", slot = 1,},
                [2] = { name = "water_bottle", price = 10, amount = 100, info = {}, type = "item", slot = 2,},
            },
        },
    },
}


Config.Animations = {

    YogaMat = {
        AnimDict = "amb@world_human_yoga@male@base",
        Anim = "base_b",
        Flags = 42,
    },

}


Config.Language = {
    Notifications = { CancelledLabel = "Cancelled!", MissingItemsLabel = "Mising Items!", MissingItemsName = "You Can Not Perform Yoga Without A Mat, You Will Get Sore Knees!!", },
    YogaMat = { ProgressBarName = "Performing Yoga!", NotifyLabel = "Yoga Finished!", NotifyName = "You Performed Yoga And You Feel Better For It!", },
}
