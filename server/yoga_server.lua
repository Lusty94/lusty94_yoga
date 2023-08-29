local QBCore = exports['qb-core']:GetCoreObject()


--Useable Yoga Mat
QBCore.Functions.CreateUseableItem("yogamat", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("lusty94_yoga:client:UseYogaMat", source)
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



AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
        print('^5--<^3!^5>-- ^7Lusty94 ^5| ^5--<^3!^5>-- ^7Yoga V1.0.0 Started Successfully ^5--<^3!^5>--^7')
end)



local function CheckVersion()
	PerformHttpRequest('https://raw.githubusercontent.com/Lusty94/UpdatedVersions/main/Yoga/version.txt', function(err, newestVersion, headers)
		local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')
		if not newestVersion then print("Currently unable to run a version check.") return end
		local advice = "^1You are currently running an outdated version^7, ^1please update^7"
		if newestVersion:gsub("%s+", "") == currentVersion:gsub("%s+", "") then advice = '^6You are running the latest version.^7'
		else print("^3Version Check^7: ^2Current^7: "..currentVersion.." ^2Latest^7: "..newestVersion..advice) end
		--print(advice)
	end)
end
CheckVersion()