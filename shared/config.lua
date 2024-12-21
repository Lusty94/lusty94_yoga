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

Config.DebugPoly = true

Config.Blips = {
    {
        useblip = true,
        title = 'Yoga Store', 
        colour = 5, 
        id = 409, 
        coords = vector3(-1167.63, -1586.75, 3.96),
        scale = 0.7, 
    },
}


Config.CoreSettings = {
    EventNames = {
        HudStatus = 'hud:server:RelieveStress', -- NAME OF HUD EVENT TO RELIEVE STRESS - DEFAULT EVENT NAME IS 'hud:server:RelieveStress'
    }, 
    Notify = {
        Type = 'qb', -- support for qb-core notify, okokNotify, mythic_notify and ox_lib notify
        --use 'qb' for default qb-core notify
        --use 'okok' for okokNotify
        --use 'mythic' for mythic_notify
        --use 'ox' for ox_lib notify
    },
    Target = {
        Type = 'qb' -- support for qb-target and ox_target
        --use 'qb' for qb-target
        --use 'ox' for ox_target
    },
    Shop = {
        Enabled = true, --use the inbuilt target shop system set to false if you have your own methods of obtaining a yoga mat
    },
    Inventory = { --support for qb-inventory and ox_inventory
        Type = 'qb',
        --use 'qb' for qb-inventory
        --use 'ox' for ox_inventory
    },
    Timers = {
        PlaceMat = 1000, -- time it takes in MS to place yoga mat
        PerformYoga = 20000, -- time it takes in MS to perform yoga, defualt is set to 15 seconds [15000 ms]  to prevent abuse and exploits
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


Config.InteractionLocations = { --name must be unique, coords is location, size is for ox target only, width is width of zone, height is height of zone, heading is direction, minZ is minZ of zone, maxZ is maxZ of zone, icon is target icon, label is target label, item is required item to target zone, job is required job to target zone leave as nil if not needed, distance is target distance
    { 
        Name = 'yogashop1',
        Coords = vector3(-1165.15, -1584.65, 4.0),
        Size = vec3(1.5,1.0,2.0),
        Width = 1.5,
        Height = 1.0,
        Heading = 301.39,
        MinZ = 3.75,
        MaxZ = 5.0,
        Icon = 'fa-solid fa-cash-register',
        Label = 'Open Yoga Store',
        Distance = 2.0,
    },
}


Config.Animations = {
    PlaceYogaMat = {
        dict = "random@domestic",
        anim = "pickup_low",
        flag = 42,
    },
    PerformYoga = {
        dict = "amb@world_human_yoga@male@base",
        anim = "base_b",
        flag = 42,
    },
}



Config.Language = {
    ProgressBar = {
        PlaceMat = 'Placing yoga mat',
        PerformYoga = 'Performing Yoga',
    },
    Notifications = {
        Busy = 'You are already doing something!',
        Cancelled = 'Action cancelled!',
        CantCarry = 'You cant carry anymore!',
        Failed = 'Action failed!',
        MissingMat = 'You are missing a yoga mat!',
        RemoveMat = 'You must remove your yoga mat before trying to place another!',
        Wait = 'You must wait a short while before doing that again!',
    },
}