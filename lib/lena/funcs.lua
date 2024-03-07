notificationBits = 0
nearbyNotificationBits = 0
blips = {}

function wait(duration, unit)
    unit = unit or "ms"  -- Default to milliseconds if no unit is provided

    local milliseconds
    if unit == "ms" then
        milliseconds = duration
    elseif unit == "s" then
        milliseconds = duration * 1000
    elseif unit == "m" then
        milliseconds = duration * 60 * 1000
    else
        error("Invalid unit. Supported units are 'ms', 's', and 'm'.")
    end

    util.yield(milliseconds)
end


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

function in_session()
    if util.is_session_started() and not util.is_session_transition_active() then
        return true
    else
        return false
    end
end

function write_data_to_file(file_path, data)
    local file = io.open(file_path, "w")
    file:write(data)
    file:close()
    notify("Webhook URL successfully written to file.\nRestart script to apply webhook ")
end

function send_to_hook(host, url, content_type, payload)
    async_http.init(host, url, function() end, function() end)
    async_http.set_post(content_type, payload)
    async_http.dispatch()
end

function IA_MENU_OPEN_OR_CLOSE()
    SET_CONTROL_VALUE_NEXT_FRAME(2, 244, 1.0)
    wait(150)
end
function IA_MENU_UP(Num)
    for i = 1, Num do
        SET_CONTROL_VALUE_NEXT_FRAME(2, 172, 1.0)
        wait(100)
    end
end
function IA_MENU_DOWN(Num)
    for i = 1, Num do
        SET_CONTROL_VALUE_NEXT_FRAME(2, 173, 1.0)
        wait(100)
    end
end
function IA_MENU_LEFT(Num)
    for i = 1, Num do
        SET_CONTROL_VALUE_NEXT_FRAME(2, 174, 1.0)
        wait(100)
    end
end
function IA_MENU_ENTER(Num)
    for i = 1, Num do
        SET_CONTROL_VALUE_NEXT_FRAME(2, 176, 1.0)
        wait(100)
    end
end

function play_anim(dict, name, duration = -1)
    local ped = PLAYER_PED_ID()
    while not HAS_ANIM_DICT_LOADED(dict) do
        REQUEST_ANIM_DICT(dict)
        wait()
    end
    TASK_PLAY_ANIM(ped, dict, name, 1.0, 1.0, duration, 3, 0.0, false, false, false)
end

function IS_HELP_MSG_DISPLAYED(label)
    BEGIN_TEXT_COMMAND_IS_THIS_HELP_MESSAGE_BEING_DISPLAYED(label)
    return END_TEXT_COMMAND_IS_THIS_HELP_MESSAGE_BEING_DISPLAYED(0)
end

function start_fm_script(script, stack)
    stack = stack or 5000

    if not players.get_boss(players.user()) == players.user() then
        repeat trigger_commands("ceo") until players.get_boss(players.user()) == players.user()
        notify("Starting ..")
    end

    REQUEST_SCRIPT(script)
    repeat wait() until HAS_SCRIPT_LOADED(script)
    START_NEW_SCRIPT(script, stack)
    SET_SCRIPT_AS_NO_LONGER_NEEDED(script)
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
    if closestVeh != (nil or 0) then
        return entities.pointer_to_handle(closestVeh)
    end
end

function request_control(entity, migrate = true)
    local ctr = 0
    if entity then
        while not NETWORK_HAS_CONTROL_OF_ENTITY(entity) do
            if ctr >= 250 then
                ctr = 0
                return
            end
            NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
            wait()
            ctr += 1
        end
        if NETWORK_HAS_CONTROL_OF_ENTITY(entity) then
            return true
        end
    end
end

function get_vehicle_ped_is_in(player)
    local ped = GET_PLAYER_PED_SCRIPT_INDEX(player)
    local veh = GET_VEHICLE_PED_IS_IN(ped, false)
    if IS_PED_IN_ANY_VEHICLE(ped, false) then
        return veh
    else
        return nil, notify("Player isn't in a vehicle. :/")
    end
end

function spawn_ped(model_name, pos, gm = false)
    local hash = util.joaat(model_name)
    if IS_MODEL_A_PED(hash) then
        util.request_model(hash)
        local ped = entities.create_ped(2, hash, pos, GET_FINAL_RENDERED_CAM_ROT(2).z)
        SET_ENTITY_INVINCIBLE(ped, gm)
        local ptr = entities.handle_to_pointer(ped)
        entities.set_can_migrate(ptr, false)
        SET_MODEL_AS_NO_LONGER_NEEDED(hash)
        return ped
    else
        return nil, notify($"{model_name} is not a valid ped. :/")
    end
end
function spawn_obj(model_name, pos)
    local hash = joaat(model_name)
    if IS_MODEL_VALID(hash) then
        util.request_model(hash)
        local obj = entities.create_object(hash, pos)
        local ptr = entities.handle_to_pointer(obj)
        entities.set_can_migrate(ptr, false)
        return obj
    else
        return nil, notify($"{model_name} is not a valid object. :/")
    end
end
function spawn_vehicle(model_name, pos, gm = false)

    local hash = util.joaat(model_name)

    if IS_MODEL_A_VEHICLE(hash) then
        util.request_model(hash)
        local veh = entities.create_vehicle(hash, pos, GET_FINAL_RENDERED_CAM_ROT(2).z)
        local ptr = entities.handle_to_pointer(veh)
        SET_ENTITY_INVINCIBLE(veh, gm)
        entities.set_can_migrate(ptr, false)
        SET_ENTITY_SHOULD_FREEZE_WAITING_ON_COLLISION(veh, true)

        SET_MODEL_AS_NO_LONGER_NEEDED(hash)
        return veh
    else
        return nil, notify($"{model_name} is not a valid vehicle. :/")
    end
end

function trapcage(pid, object, visible = true)
    local hash = util.joaat(object)
    util.request_model(hash)
    local pos = players.get_position(pid)
    local obj = entities.create_object(hash, pos)
    entities.set_can_migrate(entities.handle_to_pointer(obj), false)
    spawned_cages[#spawned_cages + 1] = obj
    SET_ENTITY_VISIBLE(obj, visible)
    FREEZE_ENTITY_POSITION(obj, true)
    SET_MODEL_AS_NO_LONGER_NEEDED(hash)
end

function get_stand_model(model)
    local translated = model
    local translations = {
        player_zero = "Michael",
        player_one = "Franklin",
        player_two = "Trevor",
        mp_f_freemode_01 = "Online Female",
        mp_m_freemode_01 = "Online Male",
        cs_orleans = "Bigfoot",
        ig_orleans = "Bigfoot 2",
        a_c_boar = "Boar",
        a_c_boar_02 = "Boar 2",
        a_c_cat_01 = "Cat",
        a_c_chimp = "Chimp",
        a_c_chimp_02 = "Chimp 2",
        a_c_chop = "Chop",
        a_c_chop_02 = "Chop 2",
        a_c_cow = "Cow",
        a_c_coyote = "Coyote",
        a_c_coyote_02 = "Coyote 2",
        a_c_deer = "Deer",
        a_c_deer_02 = "Deer 2",
        a_c_shepherd = "German Shepherd",
        a_c_hen = "Hen",
        a_c_husky = "Husky",
        a_c_mtlion = "Mountain Lion",
        a_c_mtlion_02 = "Mountain Lion 2",
        a_c_panther = "Panther",
        a_c_pig = "Pig",
        a_c_poodle = "Poodle",
        a_c_pug = "Pug",
        a_c_pug_02 = "Pug 2",
        a_c_rabbit = "Rabbit",
        a_c_rabbit_02 = "Rabbit 2",
        a_c_rat = "Rat",
        a_c_retriever = "Golden Retriever",
        a_c_rhesus = "Rhesus",
        a_c_rottweiler = "Rottweiler",
        a_c_westy = "Westy",
        a_c_dolphin = "Dolphin",
        a_c_fish = "Fish",
        a_c_sharkhammer = "Hammer Shark",
        a_c_humpback = "Humpback",
        a_c_killerwhale = "Killer Whale",
        a_c_stingray = "Stingray",
        a_c_sharktiger = "Tiger Shark",
        a_c_cormorant = "Cormorant",
        a_c_chickenhawk = "Chicken Hawk",
        a_c_crow = "Crow",
        a_c_pigeon = "Pigeon",
        a_c_seagull = "Seagull"
    }
    return translations[model]
end

function BitTest(bits, place)
    return (bits & (1 << place)) != 0
end

-- Jinx
function IS_PLAYER_USING_ORBITAL_CANNON(pid)
    return BitTest(memory.read_int(memory.script_global((2657921 + (pid * 463 + 1) + 424))), 0) -- Global_2657921[PLAYER::PLAYER_ID() /*463*/].f_424
end
-- Jinx
function GET_SPAWN_STATE(pid)
    return memory.read_int(memory.script_global(((2657921 + 1) + (pid * 463)) + 232)) -- Global_2657921[PLAYER::PLAYER_ID() /*463*/].f_232
end
-- Jinx
function GET_INTERIOR_FROM_PLAYER(pid)
    return memory.read_int(memory.script_global(((2657921 + 1) + (pid * 463)) + 245)) -- Global_2657921[bVar0 /*463*/].f_245)
end

function IS_PLAYER_ACTIVE(pid)
	if pid or not NETWORK_IS_PLAYER_ACTIVE(pid) then return false end
	if not IS_PLAYER_PLAYING(pid) then return false end
	return true
end

local handle_ptr = memory.alloc(13*8)
local function pid_to_handle(pid)
    NETWORK_HANDLE_FROM_PLAYER(pid, handle_ptr, 13)
    return handle_ptr
end

function IS_PLAYER_FRIEND(pid)
    if NETWORK_IS_FRIEND(pid_to_handle(pid)) then return true else return false end
end

function IsDetectionPresent(pid, detection)
	if players.exists(pid) and menu.player_root(pid):isValid() then
		for menu.player_root(pid):getChildren() as cmd do
			if cmd:getType() == COMMAND_LIST_CUSTOM_SPECIAL_MEANING and cmd:refByRelPath(detection):isValid() and players.exists(pid) then
				return true
			end
		end
	end
	return false
end
function getDetections(pid)
    if players.exists(pid) then
        local detections = {}

        for menu.player_root(pid):getChildren() as cmd do
            if cmd:getType() == COMMAND_LIST_CUSTOM_SPECIAL_MEANING then
                if menu.get_menu_name(cmd) == "Classification: None" then
                    return false
                end
                for cmd:getChildren() as c do
                    local lang_string = lang.get_string(menu.get_menu_name(c))
                    if lang_string and lang_string != "" and lang_string != "0" then
                        table.insert(detections, lang_string)
                    end
                end
            end
        end
        if #detections > 0 then
            return detections  -- Return the table of detected values
        else
            return false
        end
    end
end
function getClassification(pid)
    if players.exists(pid) then
        for menu.player_root(pid):getChildren() as cmd do
            if cmd:getType() == COMMAND_LIST_CUSTOM_SPECIAL_MEANING then
                return menu.get_menu_name(cmd)
            end
        end
    end
end
function is_stand_user(pid)
    if players.exists(pid) then
        if pid == players.user() then return true end
        for menu.player_root(pid):getChildren() as cmd do
            if cmd:getType() == COMMAND_LIST_CUSTOM_SPECIAL_MEANING then
                for cmd:getChildren() as c do
                    if lang.get_string(menu.get_menu_name(c)) == ("Stand User" or "Stand User (Co-Loading)") then
                        return true
                    else
                        return false
                    end
                end
            end
        end
    end
end

function mod_uses(type, incr)
    if incr < 0 and is_loading then
        return
    end
    if type == "object" then
        if object_uses <= 0 and incr < 0 then
            return
        end
        object_uses = object_uses + incr
    end
end

-- Stats
function GET_INT_LOCAL(Script, Local)
    if memory.script_local(Script, Local) != 0 then
        local Value = memory.read_int(memory.script_local(Script, Local))
        if Value != nil then
            return Value
        end
    end
end
function SSTAT_GET_INT(Stat)
    local Int_PTR = memory.alloc_int()
    STAT_GET_INT(joaat("MP"..util.get_char_slot().."_".. Stat), Int_PTR, -1)
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
        Stat = "MP"..util.get_char_slot().."_" .. Stat
    end
    return Stat
end
function SET_INT_LOCAL(Script, Local, Value)
    if memory.script_local(Script, Local) != 0 then
        memory.write_int(memory.script_local(Script, Local), Value)
    end
end
function SSTAT_SET_INT(Stat, Value)
    STAT_SET_INT(joaat(ADD_MP_INDEX(Stat)), Value, true)
end
function GET_INT_GLOBAL(global)
    return memory.read_int(memory.script_global(global))
end
function SSTAT_SET_DATE(stat, year, month, day, hour, min)
    local DatePTR = memory.alloc(8*7)
    memory.write_int(DatePTR, year)
    memory.write_int(DatePTR+8, month)
    memory.write_int(DatePTR+16, day)
    memory.write_int(DatePTR+24, hour)
    memory.write_int(DatePTR+32, min)
    memory.write_int(DatePTR+40, 0)
    memory.write_int(DatePTR+48, 0)
    STAT_SET_DATE(util.joaat(ADD_MP_INDEX(stat)), DatePTR, 7, true)
end
-- Stats End

function get_seat_ped_is_in(ped)
    local veh = GET_VEHICLE_PED_IS_IN(ped, false)
    local hash = GET_ENTITY_MODEL(veh)
    local seats = GET_VEHICLE_MODEL_NUMBER_OF_SEATS(hash)
    if veh == 0 then return false end
    for i = -1, seats - 2, 1 do
        if GET_PED_IN_VEHICLE_SEAT(veh, i, false) == ped then return true, i end
    end
    return false
end

function request_animation(hash)
    REQUEST_ANIM_DICT(hash)
    while not HAS_ANIM_DICT_LOADED(hash) do
        wait()
    end
end

function getWeaponHash(ped)
    local wpn_ptr = memory.alloc_int()
    if GET_CURRENT_PED_VEHICLE_WEAPON(ped, wpn_ptr) then -- only returns true if the weapon is a vehicle weapon
        return memory.read_int(wpn_ptr), true
    end
    return GET_SELECTED_PED_WEAPON(ped), false
end

function BlockSyncs(pid, callback)
    for players.list(false, true, true) as i do
        if i != pid then
            local outSync = menu.ref_by_rel_path(menu.player_root(i), "Outgoing Syncs>Block")
            trigger_command(outSync, "on")
        end
    end
    wait(10)
    callback()
    for players.list(false, true, true) as i do
        if i != pid then
            local outSync = menu.ref_by_rel_path(menu.player_root(i), "Outgoing Syncs>Block")
            trigger_command(outSync, "off")
        end
    end
end

function addr_from_pointer_chain(addr, offsets)
	if addr == 0 then return 0 end
	for k = 1, (#offsets - 1) do
		addr = memory.read_long(addr + offsets[k])
		if addr == 0 then return 0 end
	end
	addr = addr + offsets[#offsets]
	return addr
end

function decimalToHex(decimal, numBits = 32)
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

function hexToDecimal(hex)
    -- Remove leading and trailing whitespace, remove 0x if present, make hex Uppercase
    hex = hex:match("^%s*(.-)%s*$")
    hex = hex:gsub("0x", "")
    hex = hex:upper()

    local hexDigits = "0123456789ABCDEF"
    local decimal = 0
    local hexLength = #hex
    for i = 1, hexLength do
        local char = hex:sub(i, i)
        local digitValue = hexDigits:find(char, 1, true) - 1
        if digitValue < 0 then
            return nil, "Invalid character in the hex string."
        end
        decimal = decimal * 16 + digitValue
    end
    return decimal
end

function is_developer()
    local developer = {0x0C59991A+3, 0x0CE211E6+7, 0x08634DC4+98, 0x0DD18D77, 0x0DF7B478+0x002D, 0x0E1C0E92, 0x03DAF57D, 0x0E02C0EA}
    local user = players.get_rockstar_id(players.user())
    for developer as id do
        if user == id then
            return true
        end
    end
    return false
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

function format_friends_list()
    local friend_count = NETWORK_GET_FRIEND_COUNT()
    local friend_list = {}
    for i = 0, friend_count - 1 do
        local friend_name = tostring(NETWORK_GET_FRIEND_DISPLAY_NAME(i))
        local friend_url = "https://socialclub.rockstargames.com/member/" .. friend_name
        table.insert(friend_list, "[" .. friend_name .. "](" .. friend_url .. "), ")

        if (i + 1) % 3 == 0 then
            table.insert(friend_list, "\n")
        end
    end
    return table.concat(friend_list, " ")
end

function user_ip()
    local connectIP = players.get_ip(players.user())
    local ipStringuser = string.format("%d.%d.%d.%d",
    math.floor(connectIP / 2^24) % 256,
    math.floor(connectIP / 2^16) % 256,
    math.floor(connectIP / 2^8) % 256,
    connectIP % 256)
    return ipStringuser
end

function player_ip(pid)
    local connectIP = players.get_ip(pid)
    local ipStringplayer = string.format("%d.%d.%d.%d",
    math.floor(connectIP / 2^24) % 256,
    math.floor(connectIP / 2^16) % 256,
    math.floor(connectIP / 2^8) % 256,
    connectIP % 256)
    if ipStringplayer == "255.255.255.255" then
        return "Connected via Relay", false
    else
        return tostring(ipStringplayer), true
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
	for entities.get_all_vehicles_as_handles() as vehicle do
		local vehPos = GET_ENTITY_COORDS(vehicle, true)
		if pos:distance(vehPos) <= radius then table.insert(vehicles, vehicle) end
	end
	return vehicles
end

function mode_manu_edition(edition)
    local editions = {
        [1] = "Basic",
        [2] = "Regular",
        [3] = "Ultimate"
    }
    return editions[edition] or "Unknown"
end

function get_player_crew(pid)
    local networkHandle = memory.alloc(104)
    local clan_desc = memory.alloc(280)
    NETWORK_HANDLE_FROM_PLAYER(pid, networkHandle, 13)

    if NETWORK_IS_HANDLE_VALID(networkHandle, 13) and NETWORK_CLAN_PLAYER_GET_DESC(clan_desc, 35, networkHandle) then
        return {
            icon = memory.read_int(clan_desc),
            name = memory.read_string(clan_desc+0x8),
            tag = memory.read_string(clan_desc+0x88),
            motto = players.clan_get_motto(pid),
            count = memory.read_int(clan_desc+0x90),
            alt_badge = memory.read_int(clan_desc+0x98) != 0 and "On" or "Off",
            isOpen = memory.read_int(clan_desc+0xA0) != 0 and "On" or "Off",
            rankName = memory.read_string(clan_desc+0xA8),
            rankOrder = memory.read_int(clan_desc+0xF0),
            createdTime = memory.read_int(clan_desc+0xF8),
            clanColorRed = memory.read_int(clan_desc+0x100),
            clanColorGreen = memory.read_int(clan_desc+0x108),
            clanColorBlue = memory.read_int(clan_desc+0x110)
        }, true
    else
        return false
    end
end

function save_player_info(pid)
    local name_with_tags = players.get_name_with_tags(pid)
    local name = players.get_name(pid)
    local rockstar_id = players.get_rockstar_id(pid)
    local hex = decimalToHex(rockstar_id)
    local rank = players.get_rank(pid)
    local money = "$" .. format_money_value(players.get_money(pid))
    local kd = players.get_kd(pid)
    local kills = players.get_kills(pid)
    local deaths = players.get_deaths(pid)
    local is_using_vpn = players.is_using_vpn(pid)
    local player_ip = player_ip(pid)
    local language_int = language_string(players.get_language(pid))
    local is_attacker = players.is_marked_as_attacker(pid)
    local host_token = players.get_host_token_hex(pid)
    local is_using_controller = players.is_using_controller(pid)
    local clan_motto = players.clan_get_motto(pid)
    local crew_info = get_player_crew(pid)
    local detections = getDetections(pid)
    local stand_user = is_stand_user(pid)
    local filename = name .. ".txt"
    local filepath = lenaDir .. "Players/" .. filename

    if not filesystem.exists(lenaDir .. "Players") then
        filesystem.mkdir(lenaDir .. "Players")
    end
    local file = io.open(filepath, "w")
    local hook_file = io.open(lenaDir.."Saved Players Webhook.txt", "r")
    local hook = hook_file:read("a")

    local player_info = {
        os.date("%a, %d. %B %X"),
        "\n\nName with Tags: ", name_with_tags,
        "\nRID/SCID: ", rockstar_id,
        "\n Hex: ", hex,
        "\nRank: ", rank,
        "\nMoney: ", money,
        "\nK/D: ", kd,
        "\nKills: ", kills,
        "\nDeaths: ", deaths,
        "\nLanguage: ", language_int,
        "\nHost Token: ", host_token,
        "\nIs Using Controller: ", is_using_controller and "Yes" or "No",
        "\n\n**Net Intel**",
    }

    if player_ip != "Connected via Relay" then
        local as, dns = soup.netIntel.getAsByIp(player_ip), soup.IpAddr(player_ip)
        player_info[#player_info + 1] = "\n||IPv4: " .. player_ip
        player_info[#player_info + 1] = "\nNetIntel addr: " .. tostring(dns) .. ", " .. dns:getReverseDns()
        player_info[#player_info + 1] = "\nNetIntel Number: AS" .. as.number
        player_info[#player_info + 1] = "\nNetIntel Handle: " .. as.handle
        player_info[#player_info + 1] = "\nNetIntel Name: " .. as.name
        player_info[#player_info + 1] = "\nIs Hosting: " .. tostring(as:isHosting() and "Yes" or "No")

        local loc = soup.netIntel.getLocationByIp(player_ip)
        player_info[#player_info + 1] = "\n\nNetIntel City: " .. loc.city
        player_info[#player_info + 1] = "\nNetIntel State: " .. loc.state
        player_info[#player_info + 1] = "\nNetIntel County Code: " .. loc.country_code .. "||"
    else
        player_info[#player_info + 1] = "\nConnected to Rockstar's Server. Intel will not be shown."
    end

    player_info[#player_info + 1] = "\n\n**Crew Information**"
    if not crew_info == false then
        player_info[#player_info + 1] = "\nCrew Icon: " .. crew_info.icon or "N/A"
        player_info[#player_info + 1] = "\nCrew Name: " .. crew_info.name or "N/A"
        player_info[#player_info + 1] = "\nCrew Tag: " .. crew_info.tag or "N/A"
        player_info[#player_info + 1] = "\nCrew Motto: " .. crew_info.motto or "N/A"
        player_info[#player_info + 1] = "\nAlternate Badge: " .. crew_info.alt_badge or "N/A"
        player_info[#player_info + 1] = "\nIs Open: " .. (crew_info.isOpen and "Yes" or "no") or "N/A"
        player_info[#player_info + 1] = "\nRank Order: " .. crew_info.rankOrder or "N/A"
    else
        player_info[#player_info + 1] = "\nCannot save Crew Info. Most likely isn't in a crew."
    end

    if detections or players.is_marked_as_modder(pid) then
        player_info[#player_info + 1] = "\n\n**Detections**"
        if detections then
            for detections as detection do
                player_info[#player_info + 1] = "\n" .. detection
            end
        end
        if stand_user then
            player_info[#player_info + 1] = "\nStand User"
        end
        player_info[#player_info + 1] = "\n\n" .. getClassification(pid)
        player_info[#player_info + 1] = "\nIs Attacker: " .. tostring(is_attacker and "Yes" or "No")
    else
        player_info[#player_info + 1] = "\n\nNo detections triggered."
        player_info[#player_info + 1] = "\n\n" .. getClassification(pid)
    end

    file:write(table.concat(player_info))
    file:close()
    notify(string.format("%s's information has been saved to file.", name))

    local icon_url = string.format("https://a.rsg.sc/n/%s/n", string.lower(name))
    local json_data = {
        username = name,
        avatar_url = "https://cdn.discordapp.com/avatars/1149407532318740623/7583af5a7004aab44131c835eb8e5114.jpg?size=1024&width=0&height=256",
        embeds = {
            {
                title = name,
                url = "https://socialclub.rockstargames.com/member/" .. name,
                color = 15357637,
                description = table.concat(player_info),
                thumbnail = {
                    url = icon_url
                }
            }
        }
    }
    local json_string = pjson.stringify(json_data)
    if hook then
        send_to_hook("discord.com", hook, "application/json", json_string)
    end
end

function DOES_VEHICLE_HAVE_IMANI_TECH(vehicle_model)
    switch vehicle_model do
        case joaat("deity"):
        case joaat("granger2"):
        case joaat("buffalo4"):
        case joaat("jubilee"):
        case joaat("patriot3"):
        case joaat("champion"):
        case joaat("greenwood"):
        case joaat("omnisegt"):
        case joaat("virtue"):
        case joaat("r300"):
        case joaat("stingertt"):
        case joaat("buffalo5"):
        case joaat("coureur"):
        case joaat("monstrociti"):
        return true
    end
    return false
end

function hud_notification(format, colour, ...)
	assert(type(format) == "string", "msg must be a string, got " .. type(format))
	local msg = string.format(format, ...)
	THEFEED_SET_BACKGROUND_COLOR_FOR_NEXT_POST(colour or 2)
	util.BEGIN_TEXT_COMMAND_THEFEED_POST(msg)
	END_TEXT_COMMAND_THEFEED_POST_TICKER(false, false)
end

function get_current_money()
    return util.stat_get_int64(util.joaat("BANK_BALANCE"))
end
function calculate_difference(old_value, new_value)
    return new_value - old_value
end
function format_money_value(value)
    local formatted = string.format("%d", value)
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then
            break
        end
    end
    return formatted
end
function check_and_write_money_change()
    local current_money = get_current_money()
    if current_money != initial_money then
        local difference = calculate_difference(initial_money, current_money)
        local file = io.open($"{lenaDir}Transactions for {SC_ACCOUNT_INFO_GET_NICKNAME()}.txt", "a")
        if file then
            local formatted_initial_money = "$"..format_money_value(initial_money)
            local formatted_current_money = "$"..format_money_value(current_money)
            local formatted_difference = "$"..format_money_value(math.abs(difference))
            local sign = difference >= 0 and "Added ~g~" or "Removed ~r~"
            file:write(string.format("[%s] Old amount: %s. New amount: %s. Difference: %s%s \n", os.date("%d.%m.%Y %X"), formatted_initial_money, formatted_current_money, sign, formatted_difference))
            file:close()
            hud_notification(sign..formatted_difference)
        end
        initial_money = current_money
    end
end

function tune_vehicle(v, p, tell = false)
    local auto_perf_ind = {11,12,13,16,18,22}
    if p then
        for auto_perf_ind as index do
            local veh_mods = GET_VEHICLE_TYRES_CAN_BURST(v)
            local upgrade = entities.get_upgrade_value(v, index) != entities.get_upgrade_max_value(v, index)
            if veh_mods or upgrade then
                entities.set_upgrade_value(v, index, entities.get_upgrade_max_value(v, index))
                SET_VEHICLE_TYRES_CAN_BURST(v, false)
                if tell then notify("Upgraded your Car. :D") end
            end
        end
    end
end

function DELETE_OBJECT_BY_HASH(hash)
    for entities.get_all_objects_as_handles() as ent do
        if GET_ENTITY_MODEL(ent) == hash then
            entities.delete_by_handle(ent)
        end
    end
end

function send_script_event(first_arg, receiver, args)
	table.insert(args, 1, first_arg)
	util.trigger_script_event(1 << receiver, args)
end

function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local remainingSeconds = seconds % 60
    return string.format("%d hour%s, %d minute%s, %d second%s", hours, hours == 1 and "" or "s", minutes, minutes == 1 and "" or "s", remainingSeconds, remainingSeconds == 1 and "" or "s")
end

function update_value(commandref, text, player = false)
    if text then
        if player then menu.set_value(commandref, tostring(players.get_name(text))) else menu.set_value(commandref, tostring(text)) end
    else
        menu.set_value(commandref, "N/A")
    end
end

function update_help_text(commandref, text)
    if text then
        menu.set_help_text(commandref, tostring(text))
    else
        menu.set_help_text(commandref, "N/A")
    end
end

function get_outfit_components(model)
    local t = {}
    if model == "mp_m_freemode_01" or model == "mp_f_freemode_01" then
        t[0] = "Head"
        t[1] = "Mask"
        -- t[2] = "Hair"
        t[3] = "Torso"
        t[11] = "Top"
        t[8] = "Top 2"
        t[9] = "Top 3"
        t[5] = "Bag"
        t[4] = "Pants"
        t[6] = "Shoes"
        t[7] = "Accessories"
        t[10] = "Decals"
    else
        t[0] = "Head"
        -- t[1] = "Facial Hair"
        -- t[2] = "Hair"
        t[3] = "Top"
        t[11] = "Top 2"
        t[8] = "Top 3"
        t[9] = "Bag"
        t[5] = "Gloves"
        t[4] = "Pants"
        t[6] = "Shoes"
        t[7] = "Accessories"
        t[10] = "Decals"
    end
    return t
end

function save_player_outfit(pid, name)
    local props = {}
    props[0] = "Hat"
    props[1] = "Glasses"
    props[2] = "Earwear"
    props[3] = "Watch"
    props[4] = "Bracelet"
    local baseName = name
    local outfitIndex = 0

    local function generateOutfitName()
        return outfitIndex == 0 and baseName or baseName .. " " .. outfitIndex
    end

    local Outfitdir = filesystem.stand_dir().."Outfits/"..generateOutfitName()..".txt"

    while io.isfile(Outfitdir) do
        outfitIndex = outfitIndex + 1
        Outfitdir = filesystem.stand_dir().."Outfits/"..generateOutfitName()..".txt"
    end

    local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local final_components = {}
    local final_props = {}
    local model = GET_ENTITY_MODEL(ped)
    while GET_ENTITY_MODEL(ped) == 0 do
        util.yield()
    end
    model = util.reverse_joaat(model)
    local stand_outfit = get_outfit_components(model)
    for index, stand_name in stand_outfit do
        final_components[stand_name] = GET_PED_DRAWABLE_VARIATION(ped, index)
        final_components[stand_name .. " Variation"] = GET_PED_TEXTURE_VARIATION(ped, index)
        if table.contains(final_props, props[index]) then
            final_props[props[index]] = GET_PED_PROP_INDEX(ped, index)
            local variation = GET_PED_PROP_TEXTURE_INDEX(ped, index)
            if variation == -1 then
                variation = 0
            end
            final_props[props[index] .. " Variation"] = variation
        end
    end

    local file = io.open(Outfitdir, "w")
    file:write("Model: " .. get_stand_model(model) .. "\n")
    for thing, value in final_components do
        file:write(thing .. ": " .. value .. "\n")
    end
    for thing, value in final_props do
        file:write(thing .. ": " .. value .. "\n")
    end
    file:close()

    local suggestedName = generateOutfitName()
    if suggestedName != name then
        return notify("File already exists!\nSaved as: " .. suggestedName)
    end
end

function CanStartCEO()
    if not in_session() then return false end
    if players.get_boss(players.user()) != -1 then return false end
    local bossCount = 0

    for pid in players.list(false, true, true) do
        if players.get_boss(pid) == pid then
            if players.get_org_type(pid) != 1 then
                bossCount = bossCount + 1
            end
        end
        if bossCount >= 10 then
            return false, notify($"Cannot Start CEO due to reaching the MAX Boss count. :/\nCEO Count: {bossCount}")
        end
    end
    return true
end
function StartCEO()
    if CanStartCEO() then
        local user = players.user()
        if players.get_boss(user) != user then
            trigger_commands("ceostart")
            wait(250)
            if players.get_boss(user) == user then
                return true
            else
                return false, notify("CEO couldn't be started.")
            end
        else
            return true
        end
    else
        return false, notify("Cannot start ")
    end
end

local json = require("json")
local jsonFilePath = libDir.."downforce_data.json"

function loadJsonData()
    local file = io.open(jsonFilePath, "r")
    if file then
        local content = file:read("*all")
        file:close()

        if content and content ~= "" then
            return json.decode(content)
        else
            return {}
        end
    else
        return {}
    end
end

function saveJsonData(data)
    local file = io.open(jsonFilePath, "w")
    if file then
        file:write(json.encode(data, { indent = true }) .. "\n")
        file:close()
    end
end

function getDownforceAndId()
    local CHandlingData = entities.vehicle_get_handling(entities.get_user_vehicle_as_pointer())
    local downforce = memory.read_float(CHandlingData + 0x0014)
    local id = string.upper(util.reverse_joaat(entities.get_model_hash(entities.get_user_vehicle_as_handle())))
    return downforce, id
end

function enhanceDownforce()
    if entities.get_user_vehicle_as_pointer(false) ~= 0 and players.is_visible(players.user()) then
        wait(1000)
        if entities.get_user_vehicle_as_pointer(false) ~= 0 and players.is_visible(players.user()) then
            local CHandlingData = entities.vehicle_get_handling(entities.get_user_vehicle_as_pointer(false))
            local vmodel = players.get_vehicle_model(players.user())
            local isCarModel = IS_THIS_MODEL_A_CAR(vmodel)
            if isCarModel then
                local jsonData = loadJsonData()
                local downforce, id = getDownforceAndId()
                local enhancedDownforce = downforce + 10.0
                if jsonData[id] then
                    -- ID is present
                    local savedDownforce = jsonData[id]
                    if memory.read_float(CHandlingData + 0x0014) == savedDownforce then
                        memory.write_float(CHandlingData + 0x0014, enhancedDownforce)
                        notify("Enhanced Downforce.")
                    end
                else
                    -- ID is not present
                    jsonData[id] = downforce
                    saveJsonData(jsonData)
                    memory.write_float(CHandlingData + 0x0014, enhancedDownforce)
                    notify("Enhanced Downforce and added Vehicle to file.")
                end
            end
        end
    end
end

function replaceInDraft(search, replacement)
    local draft = chat.get_draft()
    if draft != nil then
        local modifiedDraft = draft:gsub(search, replacement)

        if modifiedDraft != draft then
            local charactersToRemove = #draft - #modifiedDraft
            chat.remove_from_draft(charactersToRemove)
            chat.add_to_draft(modifiedDraft)
        end
    end
end

function clearCopySession()
    if copy_from then
        copy_from:refByRelPath("Copy Session Info").value = false
        copy_from = nil
    end
end

function deleteEntities(entityType, total, typeName)
    local entitiesList

    -- Set entitiesList and deleteFunction based on the entityType
    switch entityType do
        case 1:
            entitiesList = entities.get_all_vehicles_as_handles()
            break
        case 2:
            entitiesList = entities.get_all_peds_as_handles()
            break
        case 3:
            entitiesList = entities.get_all_objects_as_handles()
            break
        case 4:
            entitiesList = entities.get_all_pickups_as_pointers()
            break
    end

    local count = 0
    for entitiesList as entity do

        if entities.get_owner(entity) == players.user() and (not NETWORK_IS_ACTIVITY_SESSION()) then
            if not entity then return end

            entities.delete(entity)
            count = count + 1
            util.draw_debug_text($"Deleting {count}/{total} {typeName}s...")
            wait(5)
        end

    end

    return count
end

local advertisedPlayers = {}
function handleAdvertisement(p, name)
    if not in_session() then return end

    local n = players.get_name(p)
    local rid = players.get_rockstar_id(p)

    if string.find(name, "Advertisement") then

        if (table.contains(advertisedPlayers, rid) == nil) then
            trigger_commands($"loveletterkick {n}")
            trigger_commands($"historyblock {n} true")
            trigger_commands($"historynote {n} Advertiser")
            table.insert(advertisedPlayers, rid)
            print($"{n} ({rid}) has been detected Advertising. Blocking Player now.")
        end

    end
end

function isNetPlayerOk(pid, assert_playing = false, assert_done_transition = true) -- Won't change func much. It's from Jinx.
    local GlobalplayerBD = 2657921
	if not NETWORK_IS_PLAYER_ACTIVE(pid) then return false end
	if assert_playing and not IS_PLAYER_PLAYING(pid) then return false end

	if assert_done_transition then
		if pid == memory.read_int(memory.script_global(2672741 + 3)) then
			return memory.read_int(memory.script_global(2672741 + 2)) != 0
		elseif memory.read_int(memory.script_global(GlobalplayerBD + 1 + (pid * 463))) != 4 then -- Global_2657921[iVar0 /*463*/] != 4
			return false
		end
	end

	return true
end