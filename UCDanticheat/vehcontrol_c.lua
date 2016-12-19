local vehicleControls = {
	"vehicle_fire",
	"vehicle_secondary_fire",
	"vehicle_left",
	"vehicle_right",
	"steer_forward",
	"steer_back",
	"accelerate",
	"brake_reverse",
	"radio_next",
	"radio_previous",
	"radio_user_track_skip",
	"horn",
	"sub_mission",
	"handbrake",
	"vehicle_look_left",
	"vehicle_look_right",
	"vehicle_look_behind",
	"vehicle_mouse_look",
	"special_control_left",
	"special_control_right",
	"special_control_down",
	"special_control_up",
}

function toggleVehicleControls(disable)
	removeEventHandler("onClientKey", root, stopControls)
	if (disable) then
		addEventHandler("onClientKey", root, stopControls)
		return
	end
end
addEvent("onToggleVehicleControls", true)
addEventHandler("onToggleVehicleControls", resourceRoot, toggleVehicleControls)

function stopControls(key, state)
	for _, v in ipairs(vehicleControls) do
		if (getBoundKeys(v)[key]) then
			if (state) then
				toggleControl(v, false)
			elseif (not state and not isControlEnabled(v)) then -- not to enable when controls is disabled(abuse)
				toggleControl(v, true)
			end
		end
	end
end