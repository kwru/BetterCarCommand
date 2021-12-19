function AC()
	SetNotificationTextEntry("STRING")
	AddTextComponentSubstringPlayerName("~r~Could not load the vehicle model in time, a crash was prevented.")
	DrawNotification(false, false)
end

RegisterCommand("car", function(source, args, rawCommand)
	AddEventHandler("playerSpawned", function()
		TriggerEvent("chat:addSuggestion", "/car", "Spawn any vehicle!", { name = "vehicle", help = "Vehicle Name" })
	end)
	local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId()))
	local veh = args[1]
	if veh == nil then
		veh = "adder"
	end
	vehiclehash = GetHashKey(veh)
	RequestModel(vehiclehash)
	Citizen.CreateThread(function()
		local waiting = 0
		while not HasModelLoaded(vehiclehash) do
			waiting = waiting + 100
			Citizen.Wait(100)
			if waiting > 20000 then
				AC()
				break
			end
		end
		local cv = GetVehiclePedIsIn(PlayerPedId(), false)
		if IsPedInAnyVehicle(PlayerPedId(), true) == 1 then
			if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
				DeleteEntity(cv, false)
				Wait(1)
			end
		end
		CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(PlayerPedId()), 1, 0)
		local nv = GetClosestVehicle(x, y, z, 1.000, 0, 70)
		TaskEnterVehicle(PlayerPedId(), nv, 5, -1, 0, 0, 0)
	end)
end)