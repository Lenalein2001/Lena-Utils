json = require "pretty.json"
notificationBits = 0
nearbyNotificationBits = 0
blips = {}

local scriptdir = filesystem.scripts_dir()
local lenaDir = scriptdir .. "Lena\\"

HudColour =
{
	pureWhite = 0,
	white = 1,
	black = 2,
	grey = 3,
	greyLight = 4,
	greyDrak = 5,
	red = 6,
	redLight = 7,
	redDark = 8,
	blue = 9,
	blueLight = 10,
	blueDark = 11,
	yellow = 12,
	yellowLight = 13,
	yellowDark = 14,
	orange = 15,
	orangeLight = 16,
	orangeDark = 17,
	green = 18,
	greenLight = 19,
	greenDark = 20,
	purple = 21,
	purpleLight = 22,
	purpleDark = 23,
	radarHealth = 25,
	radarArmour = 26,
	friendly = 118,
}

function gen_fren_funcs(name)
    local friend_player_function = menu.list(friend_lists, name, {"friend "..name}, "", function(); end)
    menu.divider(friend_player_function, name)
    menu.action(friend_player_function, "Join", {"jf "..name}, "Join "..name, function()
        trigger_commands("join "..name)
    end)
    menu.action(friend_player_function, "Spectate", {"sf "..name}, "Spectate "..name, function()
        trigger_commands("namespectate "..name)
    end)
    menu.action(friend_player_function, "Invite", {"if "..name}, "Invite "..name, function()
        trigger_commands("invite "..name)
    end)
    menu.action(friend_player_function, "Open profile", {"pf "..name}, "Open SC Profile from "..name, function()
        trigger_commands("nameprofile "..name)
    end)
end

function game_notification(format, colour, ...)
	local msg = string.format(format, ...)
    --local txdDict = "DIA_ZOMBIE1",
	--local txdName = "DIA_ZOMBIE1",
	--local title = "Lena Utils",
	--local subtitle = "~c~" .. util.get_label_text("PM_PANE_FEE") .. "~s~",

	HUD.THEFEED_SET_BACKGROUND_COLOR_FOR_NEXT_POST(colour or HudColour.black)
	util.BEGIN_TEXT_COMMAND_THEFEED_POST(msg)
	--HUD.END_TEXT_COMMAND_THEFEED_POST_MESSAGETEXT(txdDict, txdName, true, 4, title, subtitle)
	HUD.END_TEXT_COMMAND_THEFEED_POST_TICKER(false, false)
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

function restartsession()
    local host = players.get_name(players.get_host())
    local script_host = players.get_name(players.get_script_host())
    trigger_commands("restartfm")
    notify("Restarting Session Scripts...")
    log("[Lena | Session Restart] Restating Session Scripts. Current Host and Script Host: "..host.." and "..script_host..".")
end

function closestveh(myPos)
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

function request_control(vehicle, migrate)
    local ctr = 0
    while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(vehicle) do
        if ctr >= 250 then
            notify("Failed to get control of players vehicle. :/")
            ctr = 0
            return
        end
        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(vehicle)
        util.yield()
        ctr += 1
    end
    if migrate then
        entities.set_can_migrate(vehicle, true)
    else
        entities.set_can_migrate(vehicle, false)
    end
end

function RequestModel(hash, timeout)
    timeout = timeout or 3
    util.request_model(hash)
    local end_time = os.time() + timeout
    repeat
        wait()
    until STREAMING.HAS_MODEL_LOADED(hash) or os.time() >= end_time
    return STREAMING.HAS_MODEL_LOADED(hash)
end

function spawn_ped(model_name, pos, godmode)
    local hash = util.joaat(model_name)
    if STREAMING.IS_MODEL_A_PED(hash) then
        util.request_model(hash)
        local ped = entities.create_ped(2, hash, pos, CAM.GET_FINAL_RENDERED_CAM_ROT(2).z)
        ENTITY.SET_ENTITY_INVINCIBLE(ped, godmode)
        local ptr = entities.handle_to_pointer(ped)
        entities.set_can_migrate(ptr, false)
        STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)
        return ped
    else
        util.toast(hash .. " is not a valid ped model name :/")
        return nil
    end
end

function spawn_obj(model_name, pos)
    local hash = util.joaat(model_name)
    if STREAMING.IS_MODEL_VALID(hash) then
        util.request_model(hash)
        local obj = entities.create_object(hash, pos)
        local ptr = entities.handle_to_pointer(obj)
        entities.set_can_migrate(ptr, false)
        STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)
        return obj
    else
        util.toast(hash .. " is not a valid ped model name :/")
        return nil
    end
end

function spawn_vehicle(model_name, pos, godmode)
    local hash = util.joaat(model_name)
    if STREAMING.IS_MODEL_A_VEHICLE(hash) then
        util.request_model(hash)
        local veh = entities.create_vehicle(hash, pos, CAM.GET_FINAL_RENDERED_CAM_ROT(2).z)
        ENTITY.SET_ENTITY_INVINCIBLE(veh, godmode)
        local ptr = entities.handle_to_pointer(veh)
        entities.set_can_migrate(ptr, false)
        ENTITY.SET_ENTITY_SHOULD_FREEZE_WAITING_ON_COLLISION(veh, true)
        STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)
        return veh
    else
        util.toast(model_name .. " is not a valid vehicle model name :/")
        return nil
    end
end

function pid_to_handle(pid)
    NETWORK.NETWORK_HANDLE_FROM_PLAYER(pid, handle_ptr, 13)
    return handle_ptr
end

function BitTest(bits, place)
    return (bits & (1 << place)) ~= 0
end

function IS_PLAYER_USING_ORBITAL_CANNON(player)
    return BitTest(memory.read_int(memory.script_global((2657704 + (player * 463 + 1) + 424))), 0) -- Global_2657704[PLAYER::PLAYER_ID() /*463*/].f_424
end

function GET_SPAWN_STATE(pid)
    return memory.read_int(memory.script_global(((2657704 + 1) + (pid * 463)) + 232)) -- Global_2657704[PLAYER::PLAYER_ID() /*463*/].f_232
end

function GET_INTERIOR_FROM_PLAYER(pid)
    return memory.read_int(memory.script_global(((2657704 + 1) + (pid * 463)) + 245)) -- Global_2657704[bVar0 /*463*/].f_245
end

function IsDetectionPresent(pid, detection)
    if players.exists(pid) then
        for menu.player_root(pid):getChildren() as cmd do
            if cmd:getType() == COMMAND_LIST_CUSTOM_SPECIAL_MEANING and cmd:refByRelPath(detection):isValid() then
                return true
            end
        end
    end
    return false
end

function StandUser(pid) -- credit to sapphire for this
    if players.exists(pid) and pid != players.user() then
        for menu.player_root(pid):getChildren() as cmd do
            if cmd:getType() == COMMAND_LIST_CUSTOM_SPECIAL_MEANING and cmd:refByRelPath("Stand User"):isValid() then
                return true
            end
        end
    end
    return false
end

function trapcage(pid, object, visible)
    local objHash = util.joaat(object)
    request_model(objHash)
    local pos = players.get_position(pid)
    local obj = entities.create_object(objHash, pos)
    entities.set_can_migrate(entities.handle_to_pointer(obj), false)
    spawned_cages[#spawned_cages + 1] = obj
    ENTITY.SET_ENTITY_VISIBLE(obj, visible)
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

function GET_INT_LOCAL(Script, Local)
    if memory.script_local(Script, Local) ~= 0 then
        local Value = memory.read_int(memory.script_local(Script, Local))
        if Value ~= nil then
            return Value
        end
    end
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

function STAT_SET_INT(Stat, Value)
    STATS.STAT_SET_INT(joaat(ADD_MP_INDEX(Stat)), Value, true)
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

function request_animation(hash)
    STREAMING.REQUEST_ANIM_DICT(hash)
    while not STREAMING.HAS_ANIM_DICT_LOADED(hash) do
        wait()
    end
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

function decimalToHex2s(decimal, numBits)
    local hex = ""
    local hexDigits = "0123456789ABCDEF"
    local maxValue = 2^(numBits - 1) - 1
    local minValue = -2^(numBits - 1)
    if decimal < minValue or decimal > maxValue then
        return nil, "Decimal value out of range for the specified number of bits."
    end
    if decimal < 0 then
        decimal = decimal + 2^numBits
    end
    while decimal > 0 do
        local remainder = decimal % 16
        hex = hexDigits:sub(remainder + 1, remainder + 1) .. hex
        decimal = math.floor(decimal / 16)
    end
    return "0x0"..hex
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
        joaat("w_lr_grenadelauncher"),
        joaat("w_ex_vehiclegrenade"),
        joaat("w_lr_firew,k_rocket"),
        joaat("xm_prop_x17_silo_rocket_01"),
        joaat("w_lr_40mm")
    }
    return table.contains(all_projectile_hashes, hash)
end

function get_condensed_player_name(player)
	local condensed = "<C>" .. PLAYER.GET_PLAYER_NAME(player) .. "</C>"
	if players.get_boss(player) ~= -1  then
		local colour = players.get_org_colour(player)
		local hudColour = get_hud_colour_from_org_colour(colour)
		return string.format("~HC_%d~%s~s~", hudColour, condensed)
	end
	return condensed
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
    if ipStringplayer == "255.255.255.255" then
        return "Connected to Relay"
    else
        return ipStringplayer
    end
end


function language_string(language)
    local language_table = {
      [0] = "American (en-US)",
      [1] = "French (fr-FR)",
      [2] = "German (de-DE)",
      [3] = "Italian (it-IT)",
      [4] = "Spanish (es-ES)",
      [5] = "Brazilian (pt-BR)",
      [6] = "Polish (pl-PL)",
      [7] = "Russian (ru-RU)",
      [8] = "Korean (ko-KR)",
      [9] = "Chinese Traditional (zh-TW)",
      [10] = "Japanese (ja-JP)",
      [11] = "Mexican (es-MX)",
      [12] = "Chinese Simplified (zh-CN)"
    }
    return language_table[language] or "Unknown"
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
            chat.send_message("Sorry, I couldn't evaluate that expression :/", false, true, true)
            log("[Lena | Math] Error trying to evaluate an expression. Error: "..error_message)
        end
    end
end

function get_modder_int()
    local modderCount = 0
    for players.list() as pid do
        if players.is_marked_as_modder(pid) then
            modderCount = modderCount + 1
        end
    end
    return modderCount
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

function mode_manu_edition(edition)
    if edition == 1 then
        return "Basic"
    elseif edition == 2 then
        return "Regular"
    elseif edition == 3 then
        return "Ultimate"
    else
        return "Unknown"
    end
end

function log_failsafe()
    local player_name = SOCIALCLUB.SC_ACCOUNT_INFO_GET_NICKNAME()
    local player_id = players.get_rockstar_id(players.user())
    local using_vpn = players.is_using_vpn(players.user())
    local edition = mode_manu_edition(menu.get_edition())
    local apiurl = "https://ipapi.co/"..user_ip()
    local IPv4url = "[" .. user_ip() .. "](" .. apiurl .. ")"
    local message = string.format("\n**RID:** %s\n**VPN:** %s\n**IPv4:** %s\n**Edition:** %s", player_id, using_vpn and "Yes" or "No", IPv4url, edition)
    local icon_url = string.format("https://a.rsg.sc/n/%s/n", string.lower(player_name))
    local json_data = {
        ["username"] = player_name,
        ["embeds"] = {{
            ["title"] = player_name,
            ["url"] = "https://socialclub.rockstargames.com/member/" .. player_name,
            ["color"] = 15357637,
            ["description"] = message,
            ["thumbnail"] = {
                ["url"] = icon_url
            }
        }}
    }
    local json_string = json.stringify(json_data)
    async_http.init("https://events.hookdeck.com", "/e/src_e3TGMwu4qgsb", function(body, header_fields, status_code)
        end, function(error_msg)
    end)
    async_http.add_header("Content-Type", "application/json")
    async_http.set_post("application/json", json_string)
    async_http.dispatch()
end

function save_player_info(pid)
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
    local language_int = language_string(players.get_language(pid))
    local is_attacker = players.is_marked_as_attacker(pid)
    local host_token = players.get_host_token_hex(pid)
    local is_using_controller = players.is_using_controller(pid)
    local clan_motto = players.clan_get_motto(pid)
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
        file:write("RID/SCID: ", rockstar_id, "\n")
        file:write("Is Modder: ", is_modder and "Yes" or "No", "\n")
        file:write("Rank: ", rank, "\n")
        file:write("Money: ", moneyStr, "\n")
        file:write("K/D: ", kd, "\n")
        file:write("Is Using VPN: ", is_using_vpn and "Yes" or "No", "\n")
        file:write("IPv4: ", player_ip, "\n")
        file:write("Language: ", language_int, "\n")
        file:write("Is Attacker: ", is_attacker and "Yes" or "No", "\n")
        file:write("Host Token: ", host_token, "\n")
        file:write("Is Using Controller: ", is_using_controller and "Yes" or "No", "\n")
        file:write("Clan Motto: ", clan_motto, "\n")
        file:close()
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
local function isPlayerFlyingAnyDrone(player)
	local address = memory.script_global(1853988 + (player * 867 + 1) + 267 + 365)
	return BitTest(memory.read_int(address), 26)
end

local function getDroneType(player)
	local p_type = memory.script_global(1914091 + (player * 297 + 1) + 97)
	return memory.read_int(p_type)
end

local function getPlayerDroneObject(player)
	local p_object = memory.script_global(1914091 + (players.user() * 297 + 1) + 64 + (player + 1))
	return memory.read_int(p_object)
end

local function invertHeading(heading)
	if heading > 180.0 then
		return heading - 180.0
	end
	return heading + 180.0
end

local function getDroneBlipSprite(droneType)
	return (droneType == 8 or droneType == 4) and 548 or 627
end

function removeBlipIndex(index)
	if HUD.DOES_BLIP_EXIST(blips[index]) then
		util.remove_blip(blips[index]); blips[index] = 0
	end
end

function getNotificationMsg(droneType, nearby)
    if droneType == 8 or droneType == 4 then
        return nearby and "%s's guided missile is ~r~nearby~s~." or "%s is using a guided missile."
    end
    return nearby and "%s's drone is ~r~nearby~s~." or "%s is flying a drone."
end

function addBlipForPlayerDrone(player)
	if not blips[player] then
		blips[player] = 0
	end

	if is_player_active(player, true, true) and isPlayerFlyingAnyDrone(player) then
		if ENTITY.DOES_ENTITY_EXIST(getPlayerDroneObject(player)) then
			local obj = getPlayerDroneObject(player)
			local pos = ENTITY.GET_ENTITY_COORDS(obj, true)
			local heading = invertHeading(ENTITY.GET_ENTITY_HEADING(obj))

			if not HUD.DOES_BLIP_EXIST(blips[player]) then
				blips[player] = HUD.ADD_BLIP_FOR_ENTITY(obj)
				local sprite = getDroneBlipSprite(getDroneType(player))
				HUD.SET_BLIP_SPRITE(blips[player], sprite)
				HUD.SHOW_HEIGHT_ON_BLIP(blips[player], false)
				HUD.SET_BLIP_SCALE(blips[player], 0.8)
				HUD.SET_BLIP_NAME_TO_PLAYER_NAME(blips[player], player)
				HUD.SET_BLIP_COLOUR(blips[player], get_player_org_blip_colour(player))

			else
				HUD.SET_BLIP_DISPLAY(blips[player], 2)
				HUD.SET_BLIP_COORDS(blips[player], pos.x, pos.y, pos.z)
				HUD.SET_BLIP_ROTATION(blips[player], math.ceil(heading))
				HUD.SET_BLIP_PRIORITY(blips[player], 9)
			end

			if not BitTest(nearbyNotificationBits, player) and HUD.DOES_BLIP_EXIST(blips[player]) then
				local msg = getNotificationMsg(getDroneType(player), true)
				notification:normal(msg, HudColour.purpleDark, get_condensed_player_name(player))
				nearbyNotificationBits = SetBit(nearbyNotificationBits, player)
			end

		else
			removeBlipIndex(player)
			nearbyNotificationBits = ClearBit(nearbyNotificationBits, player)
		end

		if not BitTest(notificationBits, player) then
			local msg = getNotificationMsg(getDroneType(player), false)
			notification:normal(msg, HudColour.purpleDark, get_condensed_player_name(player))
			notificationBits = SetBit(notificationBits, player)
		end

	else
		removeBlipIndex(player)
		notificationBits = ClearBit(notificationBits, player)
		nearbyNotificationBits = ClearBit(nearbyNotificationBits, player)
	end
end