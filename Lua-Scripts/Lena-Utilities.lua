-- Lua made by Lena. Have fun <3

-------------------------------------
-- Globals
-------------------------------------

local scriptname = "Lena-Utilities"
local log = util.log 
local notify = util.toast
local wait = util.yield
local wait_once = util.yield_once
local trigger_commands = menu.trigger_commands
local trigger_command = menu.trigger_command
local sendse = util.trigger_script_event
local joaat = util.joaat
local friends_in_this_session = {}
local modders_in_this_session = {}
local all_objects = {}
local object_uses = 0
local handle_ptr = memory.alloc(13*8)
local natives_version = "1663599444-uno"
--!!!
dev_vers = false -- Lena, for the love of god, change this before release.
--!!!

-------------------------------------
-- Natives
-------------------------------------

util.require_natives("1663599444-uno")

-------------------------------------
-- Tabs
-------------------------------------

local self = menu.list(menu.my_root(), "Self", {"lenaself"}, "")
local vehicle = menu.list(menu.my_root(), "Vehicle", {"lenaveh"}, "")
local online = menu.list(menu.my_root(), "Online", {"lenaonline"}, "")
local tunables = menu.list(menu.my_root(), "Tunables", {"lenatun"}, "")
local misc = menu.list(menu.my_root(), "Misc", {"lenamisc"}, "")
local ai_made = menu.list(menu.my_root(), "AI Made", {"ai_made"}, "The following options have been generated using ChatGPT, a cutting-edge AI language model.\nI had to make some adjustments, but overall they work great.")

-------------------------------------
-- Sub Tabs
-------------------------------------

-- Self
local anims = menu.list(self, "Animations", {""}, "")
local fast_stuff = menu.list(self, "Fast Stuff", {""}, "")
local weap = menu.list(self, "Weapons", {""}, "")
local lrf = menu.list(weap, "Legit Rapid Fire", {""}, "")
-- Vehicle
local better_vehicles = menu.list(vehicle, "Better Vehicles", {""}, "")
local doorcontrol = menu.list(vehicle, "Doors", {""}, "")
local engine_control = menu.list(vehicle, "Engine Control", {""}, "")
-- Online
local mpsession = menu.list(online, "Session", {""}, "Features for the current Session.")
local hosttools = menu.list(mpsession, "Host Tools", {""}, "Tools that can only be used as the Session Host or to force Session Host.")
local friends_in_session_list = menu.list_action(mpsession, "Friends", {""}, "Friends in this Session", friends_in_this_session, function(pid, name) trigger_commands("p" .. players.get_name(pid)) end)
local modders_in_session_list = menu.list_action(mpsession, "Modders", {""}, "Modders in this Session", modders_in_this_session, function(pid, name) trigger_commands("p" .. players.get_name(pid)) end)
local detects_protex = menu.list(online, "Detections&Protections", {""}, "")
local detections = menu.list(detects_protex, "Detections", {""}, "")
local protex = menu.list(detects_protex, "Protections", {""}, "")
local anti_orb = menu.list(protex, "Anti Orb", {""}, "Protections against the Orbital Cannon.")
local friend_lists = menu.list(online, "Friend List", {""}, "")
local reactions = menu.list(online, "Reactions", {""}, "")
local join_reactions = menu.list(reactions, "Join Reactions", {""}, "")
local leave_reactions = menu.list(reactions, "Leave Reactions", {""}, "")
-- Tunables
local multipliers = menu.list(tunables, "Multipliers", {""}, "")
local sell_stuff = menu.list(tunables, "Selling", {""}, "")
local business_shit = menu.list(tunables, "Business Stuff", {""}, "")
local missions_tunables = menu.list(tunables, "Missions", {""}, "")
-- Misc
local shortcuts = menu.list(misc, "Shortcuts", {""}, "")
local clear_area_locally = menu.list(misc, "Clear Area", {""}, "")
local teleport = menu.list(misc, "Teleport", {""}, "")

-------------------------------------
-- Auto Update
-------------------------------------

local response = false
local script_version = 3.8
async_http.init('raw.githubusercontent.com','/Lenalein2001/Lena-Utils/main/Lua-Scripts/LenaUtilitiesVersion.txt', function (output)
    local remoteVersion = tonumber(output)
    response = true
    if script_version ~= remoteVersion then
        wait(5000)
        notify(scriptname .. " is outdated, and requires an update.")
        menu.action(menu.my_root(), "Update Lua", {}, "", function()
            async_http.init('raw.githubusercontent.com', '/Lenalein2001/Lena-Utils/main/Lua-Scripts/Lena-Utilities.lua', function (a)
                local catchError = select(2, load(a))
                if catchError then
                    notify("Download failed :/. Restart the script, if that does not work, contact the owner of the script")
                    wait(3000)
                return end
                local file = io.open(filesystem.scripts_dir() .. SCRIPT_RELPATH, "w+b")
                file:write(a)
                file:close()
                notify(scriptname.." has been updated successfully to version "..remoteVersion.."\nScript will be restarted automatically")
                wait(3000)
                util.restart_script()
            end)
            async_http.dispatch()
        end)
    end
end, function () response = true end)
    async_http.dispatch()
repeat
    wait()
until response

if PED == nil then
    local msg1 = "It looks like the required natives file was not loaded properly. This file should be downloaded along with my script and all other dependencies. Natives file required: "
    local msg2 = "Please download the file and everything else again from my Github."
    util.show_corner_help(msg1.."natives-"..natives_version .. ".lua\n"..msg2)
    util.stop_script()
end

if lang.get_current() ~= "en" then
    notify("This Lua is made using the english translation of Stand. If things break it's most likely because you are using a different language.\nTry to use: Stand>Settings>Language>English (UK).")
end

notify("Hi, " .. SOCIALCLUB.SC_ACCOUNT_INFO_GET_NICKNAME() .. " <3.")

-------------------------------------
-- Required Files
-------------------------------------

local required <const> = {
    "lib/natives-1663599444-uno.lua",
	"lib/lena/functions.lua",
	"lib/lena/guided_missile.lua",
	"lib/pretty/json.lua",
	"lib/pretty/json/constant.lua",
	"lib/pretty/json/parser.lua",
	"lib/pretty/json/serializer.lua",
	"lib/lena/homing_missiles.lua",
	"lib/lena/orbital_cannon.lua"
}

local Functions = require "lena.functions"
local GuidedMissile = require "lena.guided_missile"
local OrbitalCannon = require "lena.orbital_cannon"
local scaleForm = require("ScaleformLib")

local scriptdir <const> = filesystem.scripts_dir()
for _, file in required do
	assert(filesystem.exists(scriptdir .. file), "required file not found: " .. file)
end

if filesystem.exists(filesystem.resources_dir() .. "lena.ytd") then
	util.register_file(filesystem.resources_dir() .. "lena.ytd")
	notification.txdDict = "lena"
	notification.txdName = "logo"
	request_streamed_texture_dict("lena")
else
end

local lenaDir <const> = scriptdir .. "Lena\\"

if not filesystem.exists(lenaDir) then
	filesystem.mkdir(lenaDir)
end

if not filesystem.exists(lenaDir .. "Players") then
	filesystem.mkdir(lenaDir .. "Players")
end

-----------------------------------
-- Keybinds
-----------------------------------

--local NULL <const> = 0
local numpadControls = {
    -- Plane
    107,
    108,
    109,
    110,
    111,
    112,
    117,
    118,
    -- Submarine
    123,
    124,
    125,
    126,
    127,
    128,
}

-----------------------------------
-- Proprety TP's
-----------------------------------	

local All_business_properties = {
    -- Clubhouses
    "1334 Roy Lowenstein Blvd",
    "7 Del Perro Beach",
    "75 Elgin Avenue",
    "101 Route 68",
    "1 Paleto Blvd",
    "47 Algonquin Blvd",
    "137 Capital Blvd",
    "2214 Clinton Avenue",
    "1778 Hawick Avenue",
    "2111 East Joshua Road",
    "68 Paleto Blvd",
    "4 Goma Street",
    -- Facilities
    "Grand Senora Desert",
    "Route 68",
    "Sandy Shores",
    "Mount Gordo",
    "Paleto Bay",
    "Lago Zancudo",
    "Zancudo River",
    "Ron Alternates Wind Farm",
    "Land Act Reservoir",
    -- Arcades
    "Pixel Pete's - Paleto Bay",
    "Wonderama - Grapeseed",
    "Warehouse - Davis",
    "Eight-Bit - Vinewood",
    "Insert Coin - Rockford Hills",
    "Videogeddon - La Mesa",
}

local large_warehouses = {
    [6] = "Xero Gas Factory",  
    [8] = "Bilgeco Warehouse", 
    [16] = "Logistics Depot", 
    [17] = "Darnell Bros Warehouse", 
    [18] = "Wholesale Furniture", 
    [19] = "Cypress Warehouses", 
    [20] = "West Vinewood Backlot", 
    [22] = "Walker & Sons Warehouse"
}

local interiors = {
    {"AFK Room", {x=-158.71494, y=-982.75885, z=149.13135}},
    {"Torture Room", {x=147.170, y=-2201.804, z=4.688}},
    {"Mining Tunnels", {x=-595.48505, y=2086.4502, z=131.38136}},
    {"Omegas Garage", {x=2330.2573, y=2572.3005, z=46.679367}},
    {"50 Car Garage", {x=520.0, y=-2625.0, z=-50.0}},
    {"Server Farm", {x=2474.0847, y=-332.58887, z=92.9927}},
    {"Character Creation", {x=402.91586, y=-998.5701, z=-99.004074}},
    {"Life Invader Building", {x=-1082.8595, y=-254.774, z=37.763317}},
    {"Mission End Garage", {x=405.9228, y=-954.1149, z=-99.6627}},
    {"Destroyed Hospital", {x=304.03894, y=-590.3037, z=43.291893}},
    {"Stadium", {x=-256.92334, y=-2024.9717, z=30.145584}},
    {"Comedy Club", {x=-430.00974, y=261.3437, z=83.00648}},
    {"Record A Studios", {x=-1010.6883, y=-49.127754, z=-99.40313}},
    {"Bahama Mamas Nightclub", {x=-1394.8816, y=-599.7526, z=30.319544}},
    {"Janitors House", {x=-110.20285, y=-8.6156025, z=70.51957}},
    {"Therapists House", {x=-1913.8342, y=-574.5799, z=11.435149}},
    {"Martin Madrazos House", {x=1395.2512, y=1141.6833, z=114.63437}},
    {"Floyds Apartment", {x=-1156.5099, y=-1519.0894, z=10.632717}},
    {"Michaels House", {x=-813.8814, y=179.07889, z=72.15914}},
    {"Franklins House (Strawberry)", {x=-14.239959, y=-1439.6913, z=31.101551}},
    {"Franklins House (Vinewood Hills)", {x=7.3125067, y=537.3615, z=176.02803}},
    {"Trevors House", {x=1974.1617, y=3819.032, z=33.436287}},
    {"Lesters House", {x=1273.898, y=-1719.304, z=54.771}},
    {"Lesters Warehouse", {x=713.5684, y=-963.64795, z=30.39534}},
    {"Lesters Office", {x=707.2138, y=-965.5549, z=30.412853}},
    {"Meth Lab", {x=1391.773, y=3608.716, z=38.942}},
    {"Acid Lab", {x=484.69, y=-2625.36, z=-49.0}},
    {"Morgue Lab", {x=495.0, y=-2560.0, z=-50.0}},
    {"Humane Labs", {x=3625.743, y=3743.653, z=28.69009}},
    {"Motel Room", {x=152.2605, y=-1004.471, z=-99.024}},
    {"Police Station", {x=443.4068, y=-983.256, z=30.689589}},
    {"Bank Vault", {x=263.39627, y=214.39891, z=101.68336}},
    {"Blaine County Bank", {x=-109.77874, y=6464.8945, z=31.626724}},
    {"Tequi-La-La Bar", {x=-564.4645, y=275.5777, z=83.074585}},
    {"Scrapyard Body Shop", {x=485.46396, y=-1315.0614, z=29.2141}},
    {"The Lost MC Clubhouse", {x=980.8098, y=-101.96038, z=74.84504}},
    {"Vangelico Jewlery Store", {x=-629.9367, y=-236.41296, z=38.057056}},
    {"Airport Lounge", {x=-913.8656, y=-2527.106, z=36.331566}},
    {"Morgue", {x=240.94368, y=-1379.0645, z=33.74177}},
    {"Union Depository", {x=1.298771, y=-700.96967, z=16.131021}},
    {"Fort Zancudo Tower", {x=-2357.9187, y=3249.689, z=101.45073}},
    {"Agency Interior", {x=-1118.0181, y=-77.93254, z=-98.99977}},
    {"Agency Garage", {x=-1071.0494, y=-71.898506, z=-94.59982}},
    {"Terrobyte Interior", {x=-1421.015, y=-3012.587, z=-80.000}},
    {"Bunker Interior", {x=899.5518,y=-3246.038, z=-98.04907}},
    {"IAA Office", {x=128.20, y=-617.39, z=206.04}},
    {"FIB Top Floor", {x=135.94359, y=-749.4102, z=258.152}},
    {"FIB Floor 47", {x=134.5835, y=-766.486, z=234.152}},
    {"FIB Floor 49", {x=134.635, y=-765.831, z=242.152}},
    {"Big Fat White Cock", {x=-31.007448, y=6317.047, z=40.04039}},
    {"Strip Club DJ Booth", {x=121.398254, y=-1281.0024, z=29.480522}},
    {"Single Garage", {x=-144.11609, y=-576.5855, z=31.845743}},
    {"FIB Destroyed Floor", {x=158.44386, y=-738.07367, z=246.15218}},
    {"Pharma Lab", {x=496.86224, y=-2560.0608, z=-58.921993}}
    {"Nightclub Safe", {x=-1615.6887, y=-3015.7354, z=-75.205086}}
}

-------------------------------------
-- Lena's Functions
-------------------------------------

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
    local host = players.get_host()
    local script_host = players.get_script_host()
    trigger_commands("restartfm")
    notify("Restarting Session Scripts...")
    log("[Lena | Session Restart] Restating Session Scripts. Current Host and Script Host: "..host.." & "..script_host..".")
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

local function pid_to_handle(pid)
    NETWORK.NETWORK_HANDLE_FROM_PLAYER(pid, handle_ptr, 13)
    return handle_ptr
end

local function BitTest(bits, place)
    return (bits & (1 << place)) ~= 0
end

local function get_transition_state(pid)
    return memory.read_int(memory.script_global(((0x2908D3 + 1) + (pid * 0x1C5)) + 230))
end

local function IsPlayerUsingOrbitalCannon(player)
    return BitTest(memory.read_int(memory.script_global((2657589 + (player * 466 + 1) + 427))), 0) -- Global_2657589[PLAYER::PLAYER_ID() /*466*/].f_427), 0
end

local function get_spawn_state(pid)
    return memory.read_int(memory.script_global(((2657589 + 1) + (pid * 466)) + 232)) -- Global_2657589[PLAYER::PLAYER_ID() /*466*/].f_232
end

local function get_interior_player_is_in(pid)
    return memory.read_int(memory.script_global(((2657589 + 1) + (pid * 466)) + 245)) -- Global_2657589[bVar0 /*466*/].f_245
end

function DoesPlayerOwnMinitank(player)
    if player ~= -1 then
        local address = memory.script_global(1853910 + (player * 862 + 1) + 267 + 428 + 2)
        return BitTest(memory.read_int(address), 15)
    end
    return false
end

local function trapcage(pid)
    local objHash <const> = util.joaat("prop_gold_cont_01")
    request_model(objHash)
    local pos = players.get_position(pid)
    local obj = entities.create_object(objHash, pos)
    ENTITY.FREEZE_ENTITY_POSITION(obj, true)
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(objHash)
end

local function mod_uses(type, incr)
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

local function SetLocalInt(script_str, script_local, value)
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

local function GetLocalInt(script_str, script_local)
    local addr = memory.script_local(script_str, script_local)
    return addr ~= 0 and memory.read_int(addr) or nil
end

local Int_PTR = memory.alloc_int()
local function getMPX()
    return 'MP'.. util.get_char_slot() ..'_'
end

local function STAT_GET_INT(Stat)
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

    if veh == 0 then return false end

    local hash = ENTITY.GET_ENTITY_MODEL(veh)
    local seats = VEHICLE.GET_VEHICLE_MODEL_NUMBER_OF_SEATS(hash)

    for i = -1, seats - 2, 1 do
        if VEHICLE.GET_PED_IN_VEHICLE_SEAT(veh, i, false) == ped then return true, i end
    end
    return false
end

function first_to_upper(str)
    return (str:gsub("^%l", string.upper))
end

local function request_animation(hash)
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

local function BlockSyncs(pid, callback)
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

local interior_stuff = {0, 233985, 169473, 169729, 169985, 170241, 177665, 177409, 185089, 184833, 184577, 163585, 167425, 167169}
local launch_vehicle = {"Launch Up", "Launch Forward", "Launch Backwards", "Launch Down", "Slingshot"}
local bones = {12844, 24816, 24817, 24818, 35731, 31086}

local function is_entity_a_projectile(hash)
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

objects_thread = util.create_thread(function (thr)
    local projectile_blips = {}
    while true do
        for k,b in projectile_blips do
            if HUD.GET_BLIP_INFO_ID_ENTITY_INDEX(b) == 0 then 
                util.remove_blip(b) 
                projectile_blips[k] = nil
            end
        end
        if object_uses > 0 then
            all_objects = entities.get_all_objects_as_pointers()
            for k, obj_ptr in all_objects do
                --- PROJECTILE SHIT
                local obj_model = entities.get_model_hash(obj_ptr)
                if is_entity_a_projectile(obj_model) then
                    if blip_projectiles then
                        local obj_hdl = entities.pointer_to_handle(obj_ptr)
                        if HUD.GET_BLIP_FROM_ENTITY(obj_hdl) == 0 then
                            local proj_blip = HUD.ADD_BLIP_FOR_ENTITY(obj_hdl)
                            HUD.SET_BLIP_SPRITE(proj_blip, 443)
                            HUD.SET_BLIP_COLOUR(proj_blip, 75)
                            projectile_blips[#projectile_blips + 1] = proj_blip 
                        end
                    end
                end
                --------------
                if l_e_o_on then
                    local size = get_model_size(obj_model)
                    if size.x > l_e_max_x or size.y > l_e_max_y or size.z > l_e_max_y then
                        entities.delete_by_pointer(obj_ptr)
                    end
                end
            end    
        end
        wait()
    end
end)

-------------------------------------
-- Better Heli Offsets
-------------------------------------

get_vtable_entry_pointer = function(address, index)
    return memory.read_long(memory.read_long(address) + (8 * index))
end
get_sub_handling_types = function(vehicle, type)
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
    if type then return nil else return types end
end
local thrust_offset = 0x8
local better_heli_handling_offsets = {
    ["fYawMult"] = 0x18, -- dont remember
    ["fYawStabilise"] = 0x20, --minor stabalization
    ["fSideSlipMult"] = 0x24, --minor stabalizaztion
    ["fRollStabilise"] = 0x30, --minor stabalization
    ["fAttackLiftMult"] = 0x48, --disables most of it
    ["fAttackDiveMult"] = 0x4C, --disables most of the other axis
    ["fWindMult"] = 0x58, --helps with removing some jitter
    ["fPitchStabilise"] = 0x3C --idk what it does but it seems to help
}

-------------------------------------
-------------------------------------
-- Self
-------------------------------------
-------------------------------------

        -------------------------------------
        -- Animations
        -------------------------------------

        menu.action(anims, "Stop all Animations", {""}, "", function()
            local user_anim_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
            TASK.CLEAR_PED_TASKS(user_anim_ped)
        end)

        menu.divider(anims, "Animations", {""}, "")

        menu.action(anims, "Sit on the Ground", {""}, "", function()
            trigger_commands("scensitonground")
        end)

        menu.action(anims, "Sunbathe Back", {""}, "", function()
            trigger_commands("scensunbatheback")
        end)

        menu.action(anims, "Sunbathe", {""}, "", function()
            trigger_commands("scensunbathe")
        end)

        menu.action(anims, "Faint", {""}, "", function()
            trigger_commands("animfaint")
        end)

        menu.action(anims, "Flirt", {""}, "", function()
            trigger_commands("animflirtylean")
        end)

        menu.action(anims, "Twerk", {""}, "", function()
            trigger_commands("animtwerk")
        end)

        menu.action(anims, "Kisses", {""}, "", function()
            trigger_commands("animblowkiss")
        end)

        menu.action(anims, "Wait", {""}, "", function()
            trigger_commands("animwait")
        end)

        menu.action(anims, "Prone", {""}, "", function()
            trigger_commands("animprone")
        end)

        menu.action(anims, "Look at the clouds", {""}, "", function()
            trigger_commands("animcloudgazer")
        end)

        menu.action(anims, "Chill", {""}, "", function()
            trigger_commands("animchill")
        end)

        menu.action(anims, "Sleep", {""}, "", function()
            trigger_commands("scensleep")
        end)

        menu.action(anims, "Bow", {""}, "", function()
            trigger_commands("animbow")
        end)    

        menu.action(anims, "Car blowjob", {""}, "", function(on_click)
            play_anim("mini@prostitutes@sexlow_veh", "low_car_bj_loop_female", -1)
        end)

        menu.action(anims, "Execute", {""}, "", function(on_click)
            play_anim("guard_reactions", "1hand_aiming_cycle", -1)
        end)

        menu.action(anims, "Sit Sad", {""}, "", function(on_click)
            play_anim("anim@amb@business@bgen@bgen_no_work@", "sit_phone_phoneputdown_sleeping-noworkfemale", -1)
        end)

        menu.action(anims, "Wait", {""}, "", function(on_click)
            play_anim("amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", -1)
        end)

        menu.action(anims, "Dance", {""}, "", function(on_click)
            play_anim("anim@amb@casino@mini@dance@dance_solo@female@var_b@", "high_center", -1)
        end)

    -------------------------------------
    -- Fast Stuff
    -------------------------------------

        -------------------------------------
        -- Fast Respawn
        -------------------------------------

        menu.toggle_loop(fast_stuff, "Fast Respawn", {""}, "", function()
            local gwobaw = memory.script_global(2672505 + 1684 + 756) -- Global_2672505.f_1684.f_756
            if PED.IS_PED_DEAD_OR_DYING(players.user_ped()) then
                GRAPHICS.ANIMPOSTFX_STOP_ALL()
                memory.write_int(gwobaw, memory.read_int(gwobaw) | 1 << 1)
            end
        end,
            function()
            local gwobaw = memory.script_global(2672505 + 1684 + 756)
            memory.write_int(gwobaw, memory.read_int(gwobaw) &~ (1 << 1)) 
        end)

        -------------------------------------
        -- Fast Vehicle Enter/Exit
        -------------------------------------

        menu.toggle_loop(fast_stuff, "Fast Vehicle Enter/Exit", {""}, "Enter vehicles faster.\n'Lock Outfit' seems to break it.", function()
            if (TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 160) or TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 167) or TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 165)) and not TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 195) then
                PED.FORCE_PED_AI_AND_ANIMATION_UPDATE(players.user_ped())
            end
        end)

        -------------------------------------
        -- Fast Weapon swap
        -------------------------------------

        menu.toggle_loop(fast_stuff, "Fast Hands", {""}, "Swaps your weapons faster.", function()
            if TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 56) then
                PED.FORCE_PED_AI_AND_ANIMATION_UPDATE(players.user_ped())
            end
        end)

        -------------------------------------
        -- Fast Mount
        -------------------------------------

        menu.toggle_loop(fast_stuff, "Fast Mount", {""}, "Mount over stuff faster.", function()
            if TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 50) or TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 51) then
                PED.FORCE_PED_AI_AND_ANIMATION_UPDATE(players.user_ped())
            end
        end)


    -------------------------------------
    -- Friendly AI
    -------------------------------------

    menu.toggle_loop(self, "Friendly AI", {""}, "The AI will ignore you.", function()
        PED.SET_PED_RESET_FLAG(players.user_ped(), 124, true)
    end)

    -------------------------------------
    -- Change CEO/MC Type
    -------------------------------------

    menu.action(self, "Change CEO/MC Type", {""}, "Changes your CEO/MC type to the opposite.", function()
        trigger_commands("ceotomc")
    end)

    -------------------------------------
    -- Auto Heal
    -------------------------------------

    menu.toggle_loop(self, "Auto Heal", {""}, "Heals you on low health", function()
        local pped = players.user_ped()
        local phealth = ENTITY.GET_ENTITY_HEALTH(pped)
        if phealth <= 140 then
            trigger_commands("refillhealth; refillarmour")
            notify("Health set to max!")
        end
    end)

    -------------------------------------
    -- Godmode
    -------------------------------------

    menu.toggle(self, "Godmode", {"gm"}, "Toggles a few options to make you truly Invincible.", function(on_toggle)
        if on_toggle then 
            trigger_commands("godmode on")
            trigger_commands("vehgodmode on")
            trigger_commands("grace on")
            trigger_commands("mint on")
        else
            trigger_commands("godmode off")
            trigger_commands("vehgodmode off")
            trigger_commands("grace off")
            trigger_commands("mint off") 
        end
    end)

    -------------------------------------
    -- Heal
    -------------------------------------

    menu.action(self, "Heal", {"heal"}, "Heals You", function()
        trigger_commands("refillhealth; refillarmour")
    end)

    -------------------------------------
    --[[ Script Host Addict
    -------------------------------------

    menu.toggle_loop(self, "Script Host", {""}, "Breaks Sessions badly.", function()
        if players.get_script_host() ~= players.user() and get_transition_state(players.user()) ~= 0 then
            trigger_command(menu.ref_by_path("Players>"..players.get_name_with_tags(players.user())..">Friendly>Give Script Host"))
        end
    end)]]

-------------------------------------
-------------------------------------
-- Weapons
-------------------------------------
-------------------------------------

        -------------------------------------
        -- Legit rapid Fire
        -------------------------------------

        LegitRapidFire = false
        LegitRapidMS = 100

        menu.toggle(lrf, "Legit Rapid Fire", {""}, "Switches to a grenade and back to your Main Weapon.", function(on)
            local localped = PLAYER.PLAYER_PED_ID()
            if on then
                LegitRapidFire = true
                util.create_thread(function ()
                    while LegitRapidFire do
                        if PED.IS_PED_SHOOTING(localped) then
                            local currentWpMem = memory.alloc()
                            local junk = WEAPON.GET_CURRENT_PED_WEAPON(localped, currentWpMem, 1)
                            local currentWP = memory.read_int(currentWpMem)
                            memory.free(currentWpMem)
                            WEAPON.SET_CURRENT_PED_WEAPON(localped, 2481070269, true) --2481070269 is grenade
                            wait(LegitRapidMS)
                            WEAPON.SET_CURRENT_PED_WEAPON(localped, currentWP, true)
                        end
                        wait()
                    end
                    util.stop_thread()
                end)
            else
                LegitRapidFire = false
            end
        end)

        menu.slider(lrf, "Delay", {"lrfdelay"}, "The delay that it takes to switch to grenade and back to the weapon.", 1, 1000, 100, 50, function (value)
            LegitRapidMS = value
        end)

    -------------------------------------
    -- BULLET SPEED MULT
    -------------------------------------

    local AmmoSpeed = {address = 0, defaultValue = 0}
    AmmoSpeed.__index = AmmoSpeed

    function AmmoSpeed.new(address)
        assert(address ~= 0, "got a nullpointer")
        local instance = setmetatable({}, AmmoSpeed)
        instance.address = address
        instance.defaultValue = memory.read_float(address)
        return instance
    end

    AmmoSpeed.__eq = function (a, b)
        return a.address == b.address
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

    local multiplier
    local modifiedSpeed
    menu.slider_float(weap, "Bullet Speed Mult", {""}, "Changes the Speed of all weapons that are not Hitscan. Mainly Rockets.", 10, 100000, 100, 10, function(value)
        multiplier = value / 100
    end)

    util.create_tick_handler(function()
        local CPed = entities.handle_to_pointer(players.user_ped())
        if CPed == 0 or not multiplier then return end
        local ammoSpeedAddress = addr_from_pointer_chain(CPed, {0x10B8, 0x20, 0x60, 0x58})
        if ammoSpeedAddress == 0 then
            if entities.get_user_vehicle_as_pointer() == 0 then return end
            ammoSpeedAddress = addr_from_pointer_chain(CPed, {0x10B8, 0x70, 0x60, 0x58})
            if ammoSpeedAddress == 0 then return end
        end
        local ammoSpeed = AmmoSpeed.new(ammoSpeedAddress)
        modifiedSpeed = modifiedSpeed or ammoSpeed
        if ammoSpeed ~= modifiedSpeed then
            modifiedSpeed:reset()
            modifiedSpeed = ammoSpeed
        end
        local newValue = modifiedSpeed.defaultValue * multiplier
        if modifiedSpeed:getValue() ~= newValue then
            modifiedSpeed:setValue(newValue)
        end
    end)

    -------------------------------------
    -- Max Lockon Range
    -------------------------------------    

    menu.toggle_loop(weap, "Max Lockon Range", {""}, "Sets your players lockon range with homing missles and auto aim to the max.", function()
        PLAYER.SET_PLAYER_LOCKON_RANGE_OVERRIDE(players.user(), 99999999.0)
    end)

    -------------------------------------
    -- Unfair Triggerbot
    -------------------------------------  

    menu.toggle_loop(weap, "Triggerbot", {"triggerbotall"}, "A Challenge for myself.", function()
        local wpn = WEAPON.GET_SELECTED_PED_WEAPON(players.user_ped())
        local dmg = SYSTEM.ROUND(WEAPON.GET_WEAPON_DAMAGE(wpn, 0))
        local delay = WEAPON.GET_WEAPON_TIME_BETWEEN_SHOTS(wpn)
        local wpnEnt = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(PLAYER.PLAYER_PED_ID(), false)
        local wpnCoords = ENTITY.GET_ENTITY_BONE_POSTION(wpnEnt, ENTITY.GET_ENTITY_BONE_INDEX_BY_NAME(wpnEnt, "gun_muzzle"))
        for _, pid in players.list(false, true, true) do
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            if ENTITY.GET_ENTITY_ALPHA(ped) < 255 then return end
            boneIndex = bones[math.random(#bones)]
            local pos = PED.GET_PED_BONE_COORDS(ped, boneIndex, 0.0, 0.0, 0.0)
            if PLAYER.IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), ped) and not PED.IS_PED_RELOADING(players.user_ped()) then
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(wpnCoords, pos, dmg, true, wpn, players.user_ped(), true, false)
                PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, 24, 1.0) -- shooting manually after so it has the effect of you shooting to seem more legit despite there being nothing legit about this
                util.yield(delay * 1000)
            end
        end
    end)

    -------------------------------------
    -- Thermal Scope
    -------------------------------------  

    menu.toggle_loop(weap, "Thermal Scope", {""}, "Press E while aiming to activate.", function()
        local thermal_command = menu.ref_by_path("Game>Rendering>Thermal Vision")
        local aiming = PLAYER.IS_PLAYER_FREE_AIMING(players.user())
        if GRAPHICS.GET_USINGSEETHROUGH() and not aiming then
            menu.trigger_command(thermal_command, "off")
            GRAPHICS.SEETHROUGH_SET_MAX_THICKNESS(1)
        elseif PAD.IS_CONTROL_JUST_PRESSED(38,38) then
            if menu.get_value(thermal_command) or not aiming then
                menu.trigger_command(thermal_command, "off")
                GRAPHICS.SEETHROUGH_SET_MAX_THICKNESS(1)
            else
                menu.trigger_command(thermal_command, "on")
                GRAPHICS.SEETHROUGH_SET_MAX_THICKNESS(100)
            end
        end
    end)
    
-------------------------------------
-------------------------------------
-- Vehicles
-------------------------------------
-------------------------------------

    -------------------------------------
    -- Better Vehicles
    -------------------------------------

        -------------------------------------
        -- Realistic Heli
        -------------------------------------

        menu.divider(better_vehicles, "Better Heli")

        menu.slider_float(better_vehicles, "Thrust", {"helithrust"}, "Set the Heli thrust.", 0, 1000, 220, 10, function (value)
            local CflyingHandling = get_sub_handling_types(entities.get_user_vehicle_as_handle(), 2) or get_sub_handling_types(entities.get_user_vehicle_as_handle(), 1)
            if CflyingHandling then
                memory.write_float(CflyingHandling + thrust_offset, value * 0.01)
            else
                notify("Failed\nget in a heli first")
            end
        end)

        menu.action(better_vehicles, "Better heli mode", {"betterheli"}, "Disabables Heli auto stablization.", function ()
            local CflyingHandling = get_sub_handling_types(entities.get_user_vehicle_as_handle(), 2) or get_sub_handling_types(entities.get_user_vehicle_as_handle(), 1)
            if CflyingHandling then
                for _, offset in better_heli_handling_offsets do
                    memory.write_float(CflyingHandling + offset, 0)
                end
                wait(500)
                trigger_commands("gravitymult 1")
                wait(500)
                trigger_commands("helithrust 2.3")
                trigger_commands("fovfpinveh 90")
                --notify("Better Heli has been enabled.")
            else
                --notify("This ain't a heli dummy :p")
            end
        end)

        -------------------------------------
        -- Better Lazer
        -------------------------------------

        menu.divider(better_vehicles, "Better Lazer")
        menu.action(better_vehicles, "Better Lazer", {"betterlazer"}, "", function()
            trigger_commands("vhengineoffglidemulti 10")
            trigger_commands("vhgeardownliftmult 1")
            trigger_commands("gravitymult 2")
            trigger_commands("vhgeardowndragv 0.3")
            trigger_commands("fovfpinveh 90")
            notify("Better Lazer has been enabled.")
        end)

        -------------------------------------
        -- Reset better Vehicles
        -------------------------------------  

        menu.action(better_vehicles, "Reset better Vehicles", {"rbv"}, "", function ()
            wait(500)
            trigger_commands("gravitymult 2; fovfpinveh -5")
            notify("Better Vehicles have been disabled.")
        end)

    -------------------------------------
    -- Door Control
    -------------------------------------

        -------------------------------------
        -- Lock doors
        -------------------------------------

        menu.toggle(doorcontrol, "Lock doors", {"lock"}, "Locks your current Vehicle so randoms can't enter it.", function(on_toggle)
            local player_cur_car = entities.get_user_vehicle_as_handle()
            if on_toggle then 
                VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS(player_cur_car, true)
            else
                VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS(player_cur_car, false)
            end
        end)

        menu.toggle(doorcontrol, "Lock Doors for Randoms", {"lock"}, "Locks your current Vehicle so only friends can enter it.", function(on_toggle)
            local player_cur_car = entities.get_user_vehicle_as_handle()
            for _, players in players.list(false, false, true) do
                if on_toggle then 
                    VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_PLAYER(player_cur_car, players, true)
                else
                    VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_PLAYER(player_cur_car, players, false)
                end
            end
        end)

        -------------------------------------
        -- Unbreakable Doors
        -------------------------------------

        menu.toggle(doorcontrol, "Unbreakable Doors", {""}, "", function(on_toggle)
            local player_cur_car = entities.get_user_vehicle_as_handle()
            local vehicleDoorCount = VEHICLE.GET_NUMBER_OF_VEHICLE_DOORS(player_cur_car)
            if on_toggle then
                for i = -1, vehicleDoorCount do
                    VEHICLE.SET_DOOR_ALLOWED_TO_BE_BROKEN_OFF(player_cur_car, i, false)
                end
            else
                for i = -1, vehicleDoorCount do
                    VEHICLE.SET_DOOR_ALLOWED_TO_BE_BROKEN_OFF(player_cur_car, i, true)
                end
            end
        end)

    -------------------------------------
    -- Engine Control
    -------------------------------------

        -------------------------------------
        -- Start/Stop Engine
        -------------------------------------

        menu.toggle(engine_control, "Start/Stop Engine", {""},"Disables and enables the engine on toggle.", function(toggled)
            local vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
            if toggled then
                VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle, false, true, true)
            else
                VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle, true, true, false)
            end
        end)

        menu.action(engine_control, "Toggle Engine On", {""}, "Starts the Engine of the current Vehicle.", function()
            local vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
            VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle, true, true, true)
        end)

        menu.action(engine_control, "Toggle Engine Off", {""}, "Stops The Engine of the current Vehicle.", function()
            local vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
            VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle, false, true, true)
        end)

    -------------------------------------
    -- Enter Nearest Vehicle
    -------------------------------------        
    
    menu.action(vehicle, "Enter Nearest Vehicle", {""}, "Enters the nearest Vehicle that can be found.", function()
        if not PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
            local player_pos = players.get_position(players.user())
            local veh = getClosestVehicle(player_pos)
            local ped = VEHICLE.GET_PED_IN_VEHICLE_SEAT(veh, -1, true)
            PED.SET_PED_INTO_VEHICLE(players.user_ped(), veh, -1)
            wait(100)
            local vehmodel = players.get_vehicle_model(players.user())
            local vehname = util.get_label_text(vehmodel)
            notify("Set Ped into the nearest vehicle\nName: "..vehname)
        end
    end)

    -------------------------------------
    -- Clean vehicle
    -------------------------------------

    menu.action(vehicle, "Clean Vehicle", {"clv"}, "Cleans the current Vehicle.", function()
    local PVehicle = entities.get_user_vehicle_as_handle(players.user())  
        VEHICLE.SET_VEHICLE_DIRT_LEVEL(PVehicle, 0.0)
    end)

    -------------------------------------
    -- Move To Seat
    -------------------------------------

    local seat_id = -1
    local moved_seat = menu.click_slider(vehicle, "Move To Seat", {""}, "Switch seats by using the Slider. -1 is the Driver.", 1, 1, 1, 1, function(seat_id)
        TASK.TASK_WARP_PED_INTO_VEHICLE(players.user_ped(), entities.get_user_vehicle_as_handle(), seat_id - 2)
    end)

    menu.on_tick_in_viewport(moved_seat, function()
        if not PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
            moved_seat.max_value = 0
        return end

        if not PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
            moved_seat.max_value = 0
        return end

        moved_seat.max_value = VEHICLE.GET_VEHICLE_MODEL_NUMBER_OF_SEATS(ENTITY.GET_ENTITY_MODEL(entities.get_user_vehicle_as_handle()))
    end)

    -------------------------------------
    -- Vehicle Drift
    -------------------------------------

    menu.toggle_loop(vehicle, "Drift Mode", {""}, "Hold shift to drift.", function(on)
        local player_cur_car = entities.get_user_vehicle_as_handle()
        if PAD.IS_CONTROL_PRESSED(1, 21) then
            VEHICLE.SET_VEHICLE_REDUCE_GRIP(player_cur_car, true)
            -- VEHICLE.SET_VEHICLE_REDUCE_GRIP_LEVEL(player_cur_car, 0.0) Causes Crash. And i have no idea why. Maybe because it's looped?
        else
            VEHICLE.SET_VEHICLE_REDUCE_GRIP(player_cur_car, false)
        end
    end)

    -------------------------------------
    -- Unbreakable Lights
    -------------------------------------   

    menu.toggle(vehicle, "Unbreakable Lights", {""}, "Makes the Lights unbreakable on your Vehicle.", function(on_toggle)
        local player_cur_car = entities.get_user_vehicle_as_handle()
        if on_toggle then
            VEHICLE.SET_VEHICLE_HAS_UNBREAKABLE_LIGHTS(player_cur_car, true)
        else
            VEHICLE.SET_VEHICLE_HAS_UNBREAKABLE_LIGHTS(player_cur_car, false)
        end
    end)

    -------------------------------------
    -- Force flares
    -------------------------------------

    menu.toggle_loop(vehicle, "Force flares", {"forceflares"}, "Forces flares out of your current Vehicle.", function(on)
        if PAD.IS_CONTROL_PRESSED(46, 46) then
            local target = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), math.random(-5, 5), -30.0, math.random(-5, 5))
        --  MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(target['x'], target['y'], target['z'], target['x'], target['y'], target['z'], 300.0, true, -1355376991, players.user_ped(), true, false, 100.0)
            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(target['x'], target['y'], target['z'], target['x'], target['y'], target['z'], 100.0, true, 1198879012, players.user_ped(), true, false, 100.0)
        end
    end)

    -------------------------------------
    -- VPC
    -------------------------------------

    menu.action(vehicle, "Control Passenger Weapons", {""}, "You can controll all Weapons on the current Vehicle.", function ()
        local CVehicleWeaponHandlingDataAddress = get_sub_handling_types(entities.get_user_vehicle_as_handle(), 9)

        if CVehicleWeaponHandlingDataAddress == 0 then 
            notify("This Vehicle does not have any Weapons.") 
        return end

        local WeaponSeats = CVehicleWeaponHandlingDataAddress + 0x0020
        local success, seat = get_seat_ped_is_in(PLAYER.PLAYER_PED_ID())

        if success then
            for i = 0, 4, 1 do
                memory.write_int(WeaponSeats + i * 4, seat + 1)
            end
            trigger_commands("repair")
        end
    end)

    -------------------------------------
    -- Bypass Anti-Lockon
    -------------------------------------

    menu.toggle_loop(vehicle, "Bypass Anti-Lockon", {""}, "Bypass No Lock-on features. Works great on Kiddions Users.", function()
        for _, pid in players.list(false, true, true) do
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local veh = PED.GET_VEHICLE_PED_IS_USING(ped)
            if PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
                VEHICLE.SET_VEHICLE_ALLOW_HOMING_MISSLE_LOCKON_SYNCED(veh, true)
            end
        end
    end)

    -------------------------------------
    -- Auto-Performance Tuning
    -------------------------------------

    menu.toggle_loop(vehicle, "Auto-Perf", {""}, "Will Check every 10 seconds if your vehicle could use a upgrade.", function()
        local turbo = menu.ref_by_path("Vehicle>Los Santos Customs>Performance>Turbo")
        local armour = menu.ref_by_path("Vehicle>Los Santos Customs>Performance>Armour")
        local engine = menu.ref_by_path("Vehicle>Los Santos Customs>Performance>Engine")
        if PED.IS_PED_SITTING_IN_ANY_VEHICLE(players.user_ped())then
            trigger_commands("turbo on; armour 4; brakes 2; engine 3; transmission 3; bulletprooftyres on")
        end
        wait(10000)
    end)

-------------------------------------
-------------------------------------
-- Online
-------------------------------------
-------------------------------------

    menu.toggle(online, "Spoof Assets", {"spoofassets", "spoofass"}, "Spoof Session Assets.", function(toggled)
        if toggled then 
            trigger_commands("extratoggle on")
        else
            trigger_commands("extratoggle off")
        end
    end)

    -------------------------------------
    -- Session
    -------------------------------------

    menu.toggle_loop(mpsession, "Session Host Migration", {""}, "Notifies you if the Host has changed.", function()
        local sh -- Session Host
        local sh_name -- Session Host Name
        if util.is_session_started() then
            if players.get_host() ~= -1 and players.get_host() ~= nil then
                sh = players.get_host()
                sh_name = players.get_name(sh)
                util.yield(2000)
                if sh ~= -1 and sh ~= nil then
                    local new_sh = players.get_host()
                    if sh ~= new_sh and new_sh ~= -1 and new_sh ~= nil then
                        if players.exists(new_sh) then
                            notify("Session Host migrated from " .. sh_name .. " to " .. players.get_name(new_sh))
                            log("[Lena | Host Migration] Session Host migrated from " .. sh_name .. " to " .. players.get_name(new_sh))
                        end
                    end
                end
            end
        end
    end)
    
    menu.toggle_loop(mpsession, "Script Host Migration", {""}, "Notifies you if the Script Host has changed.", function()
        local sh -- Script Host
        local sh_name -- Script Host Name
        if util.is_session_started() then
            if players.get_script_host() ~= -1 and players.get_script_host() ~= nil then
                sh = players.get_script_host()
                sh_name = players.get_name(sh)
                util.yield(2000)
                if sh ~= -1 and sh ~= nil then
                    local new_sh = players.get_script_host()
                    if sh ~= new_sh and new_sh ~= -1 and new_sh ~= nil then
                        if players.exists(new_sh) then
                            notify("Script Host migrated from " .. sh_name .. " to " .. players.get_name(new_sh))
                            log("[Lena | Script Host Migration] Script Host migrated from " .. sh_name .. " to " .. players.get_name(new_sh))
                        end
                    end
                end
            end
        end
    end)

        ------------------------------------
        -- Max Players
        -------------------------------------

        menu.divider(hosttools, "Max Players")
        menu.click_slider(hosttools, "Max Players", {"maxplayers"}, "Set the max Players for the lobby\nOnly works as the Host.", 1, 32, 32, 1, function (value)
            NETWORK.NETWORK_SESSION_SET_MATCHMAKING_GROUP_MAX(0, value)
            notify("Free Slots: ".. NETWORK.NETWORK_SESSION_GET_MATCHMAKING_GROUP_FREE(0))
        end)
        menu.click_slider(hosttools, "max spectators", {"maxspectators"}, "Set the max Spectators for the lobby\nOnly works as the Host.", 0, 2, 0, 1, function (value)
            NETWORK.NETWORK_SESSION_SET_MATCHMAKING_GROUP_MAX(4, value)
            notify("Free Slots: ".. NETWORK.NETWORK_SESSION_GET_MATCHMAKING_GROUP_FREE(4))
        end)

        -------------------------------------
        -- Force Host
        -------------------------------------

        menu.action(hosttools, "Force Host", {"forcehost"}, "Forces you to become the Session Host.", function()
            local curPos = players.get_host_queue_position(players.user())
            if curPos == 0 then
                notify("You are session host already.")
                return
            end
            local friendsHostQueue = players.get_host_queue(false, true, false)
            if #friendsHostQueue > 0 then
                for _, pid in friendsHostQueue do
                    if players.get_host_queue_position(pid) < curPos then
                        notify("Failed, one of the players in the queue is your friend. Forcing session host is impossible until your friend re-joins the session with a higher host queue index.")
                        return
                    end
                end
            end
            local hostQueue = players.get_host_queue(false, false, true)
            for idx, pid in hostQueue do
                if idx <= curPos then
                    trigger_commands("kick " .. players.get_name(pid))
                    wait(100)
                end
            end
            util.create_tick_handler(function()
                if players.get_host_queue_position(players.user()) == 0 then
                    notify("Success, you are now the session host.")
                    return false
                end
                wait(500)
            end)
        end)

        menu.toggle(hosttools, "Block SH Migration", {""}, "Only works when you are the host.", function(on)
            if util.is_session_started() and NETWORK.NETWORK_IS_HOST() then
                NETWORK.NETWORK_PREVENT_SCRIPT_HOST_MIGRATION()
            end
        end)

        -------------------------------------
        -- Modders&Friends in Session
        -------------------------------------

        util.create_tick_handler(function()
            for _, pid in players.list(true, true, true) do 
                local hdl = pid_to_handle(pid)
                if NETWORK.NETWORK_IS_FRIEND(hdl) or players.user() == pid then 
                    if friends_in_this_session[pid] == nil then
                        friends_in_this_session[pid] = players.get_name(pid) .. ' [' .. players.get_tags_string(pid) .. ']'
                        menu.set_list_action_options(friends_in_session_list, friends_in_this_session)
                    end
                end
                if players.is_marked_as_modder(pid) then 
                    if modders_in_this_session[pid] == nil then
                        modders_in_this_session[pid] = players.get_name(pid) .. ' [' .. players.get_tags_string(pid) .. ']'
                        menu.set_list_action_options(modders_in_session_list, modders_in_this_session)
                    end
                end
            end
        end)

    -------------------------------------
    -- Detections
    -------------------------------------

        -------------------------------------
        -- Detect Rockets
        -------------------------------------

        blip_projectiles = false
        menu.toggle(detections, "Detect Rockets", {""}, "Detects incomming Rockets and Mines.", function(on)
            blip_projectiles = on
            mod_uses("object", if on then 1 else -1)
        end)

        -------------------------------------
        -- SUID
        -------------------------------------

        local stand_UID = menu.ref_by_path("Online>Protections>Detections>Stand User Identification.")
        menu.toggle(detections, "Stand User ID", {"suid"}, "Detects Stand Users", function(on)
            if on then
                trigger_command(stand_UID, "on")
            else
                trigger_command(stand_UID, "off")
            end
        end, true)

        -------------------------------------
        -- Super Drive
        -------------------------------------

        menu.toggle_loop(detections, "Super Drive", {""}, "Detects Players using Super Drive.", function()
            for _, pid in players.list(false, true, true) do
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local vehicle = PED.GET_VEHICLE_PED_IS_USING(ped)
                local veh_speed = (ENTITY.GET_ENTITY_SPEED(vehicle)* 2.236936)
                local class = VEHICLE.GET_VEHICLE_CLASS(vehicle)
                if class ~= 15 and class ~= 16 and veh_speed >= 200 and (players.get_vehicle_model(pid) ~= joaat("oppressor") or players.get_vehicle_model(pid) ~= joaat("oppressor2")) then
                    local PedID = NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1))
                    notify(players.get_name(PedID) .. " Is Using Super Drive!")
                    break
                end
            end
        end)

        -------------------------------------
        -- Spectate
        -------------------------------------

        menu.toggle_loop(detections, "Spectate", {""}, "Detects if someone is spectating you.", function()
            for _, pid in players.list(false, true, true) do
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                if not PED.IS_PED_DEAD_OR_DYING(ped) then
                    if v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_cam_pos(pid)) < 15.0 and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(pid)) > 20.0 then
                        notify(players.get_name(pid) .. " Is Watching You!")
                        break
                    end
                end
            end
        end)

        -------------------------------------
        -- No-clip
        -------------------------------------

        menu.toggle_loop(detections, "Noclip", {""}, "Detects if the player is using noclip a.k.a levitation.", function()
            for _, pid in players.list(false, true, true) do
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local ped_ptr = entities.handle_to_pointer(ped)
                local vehicle = PED.GET_VEHICLE_PED_IS_USING(ped)
                local oldpos = players.get_position(pid)
                wait()
                local currentpos = players.get_position(pid)
                local vel = ENTITY.GET_ENTITY_VELOCITY(ped)
                if not util.is_session_transition_active() and players.exists(pid)
                and get_interior_player_is_in(pid) == 0 and get_spawn_state(pid) ~= 0
                and not PED.IS_PED_IN_ANY_VEHICLE(ped, false) -- too many false positives occured when players where driving. so fuck them. lol.
                and not NETWORK.NETWORK_IS_PLAYER_FADING(pid) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_DEAD_OR_DYING(ped)
                and not PED.IS_PED_CLIMBING(ped) and not PED.IS_PED_VAULTING(ped) and not PED.IS_PED_USING_SCENARIO(ped)
                and not TASK.GET_IS_TASK_ACTIVE(ped, 160) and not TASK.GET_IS_TASK_ACTIVE(ped, 2)
                and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(pid)) <= 395.0 -- 400 was causing false positives
                and ENTITY.GET_ENTITY_HEIGHT_ABOVE_GROUND(ped) > 5.0 and not ENTITY.IS_ENTITY_IN_AIR(ped) and entities.player_info_get_game_state(ped_ptr) == 0
                and oldpos.x ~= currentpos.x and oldpos.y ~= currentpos.y and oldpos.z ~= currentpos.z 
                and vel.x == 0.0 and vel.y == 0.0 and vel.z == 0.0 then
                    notify(players.get_name(pid) .. " Is Noclipping!")
                    break
                end
            end
        end)

        -------------------------------------
        -- Teleport
        -------------------------------------

        menu.toggle_loop(detections, "Teleport", {""}, "Detects if the player has teleported.", function()
            for _, pid in players.list(false, true, true) do
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                if not NETWORK.NETWORK_IS_PLAYER_FADING(pid) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_DEAD_OR_DYING(ped) then
                    local oldpos = players.get_position(pid)
                    wait(1000)
                    local currentpos = players.get_position(pid)
                    if get_transition_state(pid) ~= 0 then
                        for i, interior in interior_stuff do
                            if v3.distance(oldpos, currentpos) > 500 and oldpos.x ~= currentpos.x and oldpos.y ~= currentpos.y and oldpos.z ~= currentpos.z then
                                wait(500)
                                if get_interior_player_is_in(pid) == interior and PLAYER.IS_PLAYER_PLAYING(pid) and players.exists(pid) then
                                    notify(players.get_name(pid) .. " Just teleported!")
                                end
                            end
                        end
                    end
                end
            end
        end)

        -------------------------------------
        -- Drones & Missiles
        -------------------------------------

        local notificationBits = 0
        local nearbyNotificationBits = 0
        local blips = {}

        local function isPlayerFlyingAnyDrone(player)
            local address = memory.script_global(1853910 + (player * 862 + 1) + 267 + 365)
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

        local function getNotificationMsg(droneType, nearby)
            if droneType == 8 or droneType == 4 then
                return nearby and "%s's guided missile is ~r~nearby~s~" or "%s is using a guided missile"
            end
            return nearby and "%s's drone is ~r~nearby~s~" or "%s is flying a drone"
        end

        local function removeBlipIndex(index)
            if HUD.DOES_BLIP_EXIST(blips[index]) then
                util.remove_blip(blips[index]); blips[index] = 0
            end
        end

        function addBlipForPlayerDrone(player)
            if not blips[player] then
                blips[player] = 0
            end

            if is_player_active(player, true, true) and players.user() ~= player and isPlayerFlyingAnyDrone(player) then
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

        menu.toggle_loop(detections, "Missile and Drone Detection", {""}, "Drone/Missile Detection.", function()
            if NETWORK.NETWORK_IS_SESSION_ACTIVE() then
                for player = 0, 32 do addBlipForPlayerDrone(player) end
            end
        end, function()
            for i in blips do removeBlipIndex(i) end
            notificationBits = 0
            nearbyNotificationBits = 0
        end)

        -------------------------------------
        -- Stat Detection
        -------------------------------------

        local isLegit = {}
        local mightNotBeLegit = {}
        menu.toggle_loop(detections, "Detect Unlegit Stats", {""}, "Detects Modded Stats.", function ()
            for pid in players.list(false, false, true) do
                local rank = players.get_rank(pid)
                local money = players.get_money(pid)
                local kills = players.get_kills(pid)
                local kdratio = players.get_kd(pid)
                if kdratio < 0 or kdratio > 21  or kills > 100000 or rank > 1500 or money > 1500000000 then
                    if isLegit[pid] and not mightNotBeLegit[pid] then
                        notify("" .. players.get_name(pid) .. " might not be legit.\nRank: " .. rank .. "\nMoney: " .. string.format("%.2f", money/1000000) .. "M$\nKills: " .. kills .. "\nKD: " .. string.format("%.2f", kdratio))
                        log("[Lena | Unlegit Stats]" .. players.get_name(pid) .. " might not be legit.\nRank: " .. rank .. "\nMoney: " .. string.format("%.2f", money/1000000) .. "M$\nKills: " .. kills .. "\nKD: " .. string.format("%.2f", kdratio))
                    end
                    isLegit[pid] = false
                    mightNotBeLegit[pid] = true
                else
                    isLegit[pid] = true
                    mightNotBeLegit[pid] = false
                end
                wait(5000)
            end
        end)

        -------------------------------------
        -- Thunder Join
        -------------------------------------

        menu.toggle_loop(detections, "Thunder Join", {""}, "Detects if someone is using thunder join.", function()
            for _, pid in players.list(false, true, true) do
                if get_spawn_state(players.user()) == 0 then return end
                local old_sh = players.get_script_host()
                wait(100)
                local new_sh = players.get_script_host()
                if old_sh ~= new_sh then
                    if get_spawn_state(pid) == 0 and players.get_script_host() == pid then
                        notify(players.get_name(pid) .. " triggered a detection (Thunder Join) and is now classified as a Modder")
                        log(players.get_name(pid) .. " triggered a detection (Thunder Join) and is now classified as a Modder")
                    end
                end
            end
        end)

    -------------------------------------
    -- Protections
    -------------------------------------

        -------------------------------------
        -- Anti Crash
        -------------------------------------

        menu.toggle(protex, "Render GTA uncrashable", {"panic"}, "Will render GTA:O uncrashable.", function(on_toggle)
            local BlockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Enabled")
            local UnblockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Disabled")
            local BlockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Enabled")
            local UnblockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Disabled")
            if on_toggle then
                notify("Anti Crash On")
                trigger_commands("desyncall on")
                trigger_command(BlockIncSyncs)
                trigger_command(BlockNetEvents)
                trigger_commands("anticrashcamera on")
            else
                notify("Anti Crash Off")
                trigger_commands("desyncall off")
                trigger_command(UnblockIncSyncs)
                trigger_command(UnblockNetEvents)
                trigger_commands("anticrashcamera off")
            end
        end)

        -------------------------------------
        -- Lessen Breakup
        -------------------------------------

        menu.toggle_loop(protex, "Activate Lessen Host when Host", {"bandaid"}, "Autimatically enable Lessen if you're Session Host.", function ()
            local lessen = menu.ref_by_path("Online>Protections>Lessen Breakup Kicks As Host")
            if not util.is_session_transition_active() then
                if players.get_host() == players.user() then
                    trigger_command(lessen, "on")
                elseif players.get_host() ~= players.user() then
                    trigger_command(lessen, "off")
                end
            end
        end)

        -------------------------------------
        -- Auto Kick Specific Crash Events
        -------------------------------------

        --[[local crash_events = { "S0", "S1", "S2", "S3", "S4", "TB", "T1", "T2", "T3", "T7", "T8"}
        local cwash = menu.list(protex, "Auto Kick Specific Crash Events")
        for _, event in crash_events do
            menu.toggle_loop(cwash, event, {""}, "Needs Testing", function()
                for _, pid in players.list(false, true, true) do
                    for _, cmd in menu.player_root(pid):getChildren() do
                        if cmd:getType() == COMMAND_LIST_CUSTOM_SPECIAL_MEANING and (cmd:refByRelPath("Crash Event (" .. event .. ")"):isValid()) then
                            trigger_commands("kick" .. players.get_name(pid))
                            log("[Lena] Crash event "..event.." recieved from: "..players.get_name(pid))
                        end
                    end
                end
            end)
        end]]

    -------------------------------------
    -- Orb Detections
    -------------------------------------

        -------------------------------------
        -- Ghost Orbital Players
        -------------------------------------

        menu.toggle_loop(anti_orb, "Ghost", {""}, "Automatically ghost players that are using the orbital cannon.", function()
            for _, pid in players.list(false, true, true) do
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local cam_pos = players.get_cam_pos(pid)
                if IsPlayerUsingOrbitalCannon(pid) and TASK.GET_IS_TASK_ACTIVE(ped, 135)
                and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), cam_pos) < 400
                and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), cam_pos) > 340 then
                    util.toast(players.get_name(pid) .. " Is targeting you with the orbital cannon")
                end
                if players.is_in_interior(pid) then
                    if IsPlayerUsingOrbitalCannon(pid) then
                        NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, true)
                    else
                        NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, false)
                    end
                else
                end
            end
        end)

        menu.toggle_loop(anti_orb,  "Block Orbital Cannon", {"blockorb"}, "Spawns a prop that blocks the orbital cannon room.", function()
            local mdl = util.joaat("xm_prop_cannon_room_door")
            request_model(mdl)
            if orb_obj == nil or not ENTITY.DOES_ENTITY_EXIST(orb_obj) then
                orb_obj = entities.create_object(mdl, v3(336.56, 4833.00, -60.0))
                entities.set_can_migrate(entities.handle_to_pointer(orb_obj), false)
                ENTITY.SET_ENTITY_HEADING(orb_obj, 125.0)
                ENTITY.FREEZE_ENTITY_POSITION(orb_obj, true)
                ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(players.user_ped(), orb_obj, false)
            end
            local mdl2 = util.joaat("xm_prop_cannon_room_door")
            request_model(mdl2)
            if orb_obj2 == nil or not ENTITY.DOES_ENTITY_EXIST(orb_obj2) then
                orb_obj2 = entities.create_object(mdl2, v3(335.155, 4835.0, -60.0))
                entities.set_can_migrate(entities.handle_to_pointer(orb_obj2), false)
                ENTITY.SET_ENTITY_HEADING(orb_obj2, -55.0)
                ENTITY.FREEZE_ENTITY_POSITION(orb_obj2, true)
                ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(players.user_ped(), orb_obj2, false)
            end
            util.yield(50)
        end, function()
            if orb_obj ~= nil or orb_obj2 ~= nil then
                entities.delete_by_handle(orb_obj)
                entities.delete_by_handle(orb_obj2)
            end
        end)

        -------------------------------------
        -- Orb Detection
        -------------------------------------

        local IsInOrbRoom = {}
        local IsOutOfOrbRoom = {}
        local IsAtOrbTable = {}
        local IsNotAtOrbTable = {}
        announce_orb = false
        menu.toggle(anti_orb, "Notify on orb usage", {""}, "Notifies you if a Player has entered the Orbital Cannon Room.", function()
            util.create_tick_handler(function()  
                for pid = 0,31 do
                    if players.get_position(pid).x > 323 and players.get_position(pid).y < 4834 and players.get_position(pid).y > 4822 and players.get_position(pid).z <= -59.36 then
                        if IsOutOfOrbRoom[pid] and not IsInOrbRoom[pid] then
                            notify(players.get_name(pid) .." has entered the orbital cannon room.")
                            if announce_orb == true then
                                chat.send_message("> ".. players.get_name(pid) .." entered the orbital cannon room.", true, true, true)
                            end
                        end
                        if players.get_position(pid).x < 331 and players.get_position(pid).x > 330.40 and players.get_position(pid).y > 4830 and players.get_position(pid).y < 4830.40 and players.get_position(pid).z <= -59.36 then
                            if IsNotAtOrbTable[pid] and not IsAtOrbTable[pid] then
                                notify(players.get_name(pid) .." might be about to call an orbital strike.")
                                if announce_orb == true then
                                    chat.send_message("> ".. players.get_name(pid) .." might be about to call an orbital strike.", true, true, true)
                                end
                            end
                            IsAtOrbTable[pid] = true
                            IsNotAtOrbTable[pid] = false
                        end
                        IsInOrbRoom[pid] = true
                        IsOutOfOrbRoom[pid] = false
                    else
                        if IsInOrbRoom[pid] and not IsOutOfOrbRoom[pid] then
                            notify(players.get_name(pid) .." has left the orbital cannon room.")
                            if announce_orb == true then
                                chat.send_message("> ".. players.get_name(pid) .." left the orbital cannon room.", true, true, true)
                            end
                        end
                        IsAtOrbTable[pid] = false
                        IsInOrbRoom[pid] = false
                        IsOutOfOrbRoom[pid] = true
                        IsNotAtOrbTable[pid] = true
                    end
                end
            end)
        end)

        menu.toggle_loop(anti_orb, "Send to Team chat", {""}, "Notifies Players in your CEO/MC.", function ()
            announce_orb = true
            end, function ()
            announce_orb = false
        end)

        -------------------------------------
        -- Orb Postition
        -------------------------------------

        local orbital_blips = {}
        local draw_orbital_blips = false
        menu.toggle(anti_orb, "Show Orbital Cannon", {""}, "Shows you where the Player is aiming at.", function(on)
            draw_orbital_blips = on
            while true do
                if not draw_orbital_blips then 
                    for pid, blip in pairs(orbital_blips) do 
                        util.remove_blip(blip)
                        orbital_blips[pid] = nil
                    end
                    break 
                end
                for _, pid in players.list(true, true, true) do
                    local cam_rot = players.get_cam_rot(pid)
                    local cam_pos = players.get_cam_pos(pid)
                    if players.is_in_interior(pid) then 
                        if IsPlayerUsingOrbitalCannon(pid) then
                            util.draw_debug_text(players.get_name(pid).. " is Using the Orbital Cannon!")
                            if orbital_blips[pid] == nil then 
                                local blip = HUD.ADD_BLIP_FOR_COORD(cam_pos.x, cam_pos.y, cam_pos.z)
                                HUD.SET_BLIP_SPRITE(blip, 588)
                                HUD.SET_BLIP_COLOUR(blip, 59)
                                HUD.SET_BLIP_NAME_TO_PLAYER_NAME(blip, pid)
                                orbital_blips[pid] = blip
                            else
                                HUD.SET_BLIP_COORDS(orbital_blips[pid], cam_pos.x, cam_pos.y, cam_pos.z)
                            end
                        end
                    else
                        if orbital_blips[pid] ~= nil then 
                            util.remove_blip(orbital_blips[pid])
                            orbital_blips[pid] = nil
                        end
                    end
                end
                util.yield()
            end
        end)

    -------------------------------------
    -- Friend List
    -------------------------------------

    local function gen_fren_funcs(name)
        local friend_player_function = menu.list(friend_lists, name, {"friend "..name}, "", function(); end)
        menu.divider(friend_player_function, name)
        menu.action(friend_player_function, "Join", {"jf "..name}, "", function()
            trigger_commands("join "..name)
        end)
        menu.action(friend_player_function, "Spectate", {"sf "..name}, "", function()
            trigger_commands("namespectate "..name)
        end)
        menu.action(friend_player_function, "Invite", {"if "..name}, "", function()
            trigger_commands("invite "..name)
        end)
        menu.action(friend_player_function, "Open profile", {"pf "..name}, "", function()
            trigger_commands("nameprofile "..name)
        end)
    end
    
    menu.divider(friend_lists, "frens:)")
    for i = 0 , NETWORK.NETWORK_GET_FRIEND_COUNT() do
        local name = NETWORK.NETWORK_GET_FRIEND_DISPLAY_NAME(i)
        if name == "*****" then goto yes end
        gen_fren_funcs(name)
        ::yes::
    end

    -------------------------------------
    -- Show Join Info
    -------------------------------------
    
    menu.divider(join_reactions, "Join Reactions")
    menu.toggle(join_reactions, "Notification", {""}, "", function(toggle)
        showJoinInfomsg = toggle
    end)
    menu.toggle(join_reactions, "Write To Log File", {""}, "", function(toggle)
        showJoinInfolog = toggle
    end)
    menu.toggle(join_reactions, "Announce In Chat", {""}, "", function(toggle)
        showJoinInfoall = toggle
    end)
    menu.toggle(join_reactions, "Announce In Team Chat", {""}, "", function(toggle)
        showJoinInfoteam = toggle
    end)

    -------------------------------------
    -- Show Leave Info
    -------------------------------------

    menu.divider(leave_reactions, "Leave Reactions")
    menu.toggle(leave_reactions, "Notification", {""}, "", function(toggle)
        showleaveInfomsg = toggle
    end)
    menu.toggle(leave_reactions, "Write To Log File", {""}, "", function(toggle)
        showleaveInfolog = toggle
    end)
    menu.toggle(leave_reactions, "Announce In Chat", {""}, "", function(toggle)
        showleaveInfoall = toggle
    end)
    menu.toggle(leave_reactions, "Announce In Team Chat", {""}, "", function(toggle)
        showleaveInfoteam = toggle
    end)



    menu.toggle(online, "Spoof Session", {"enablespoofing"}, "Enable Session Spoofing.", function(toggle)
        local spoof_ses = menu.ref_by_path("Online>Spoofing>Session Spoofing>Hide Session>Story Mode")
        local unspoof_ses = menu.ref_by_path("Online>Spoofing>Session Spoofing>Hide Session>Disabled")
        if menu.get_edition() == 3 then
            if toggle then
                trigger_command(spoof_ses)
                notify("Spoofing Enabled!")
            else
                trigger_command(unspoof_ses)
                notify("Spoofing disabled!")
            end
        else
            notify("You need Ultimate in order to do that!")
        end
    end, nil, nil, COMMANDPERM_FRIENDLY)

    menu.toggle(online, "Whitelist Session", {"whitelist", "wl"}, "Blocks Joins from non-Whitelisted players.", function(toggle)
        local whitelist = menu.ref_by_path("Online>Session>Block Joins>From Non-Whitelisted")
        if toggle then
            trigger_command(whitelist, "on")
            notify("Session is now whitelisted!")
        else
            trigger_command(whitelist, "off")
            notify("Session is not whitelisted anymore!")
        end
    end)

    menu.toggle(online, "Speed Up Joining", {""}, "Slightly Speed up Joining New Sessions.", function(toggle)
        if toggle then
            trigger_commands("skipbroadcast on")
            trigger_commands("speedupfmmc on")
            trigger_commands("speedupspawn on")
        else
            trigger_commands("skipbroadcast off")
            trigger_commands("speedupfmmc off")
            trigger_commands("speedupspawn off")
        end
    end)

    menu.toggle_loop(online, "Kick High-Ping", {""}, "Kicks Everyone with a high ping (180)\nNote that the average ping is in most Sessions quite high. Expect false positives.", function(toggle)
        if util.is_session_started() and not util.is_session_transition_active() then
            for _, pid in players.list(false, false, true) do
                local ping = NETWORK.NETWORK_GET_AVERAGE_LATENCY(pid)
                if ping >= 180 then 
                    notify("Player "..players.get_name(pid).." has a high ping!\nPing: "..ping)
                    log("[Lena | Kick High-Ping] Player "..players.get_name(pid).." has a high ping! | Ping: "..ping)
                    trigger_commands("kick"..players.get_name(pid))
                end
                wait(5000)
            end
        end
    end)

-------------------------------------
-------------------------------------
-- Tuneables
-------------------------------------
-------------------------------------

    -------------------------------------
    -- Selling
    -------------------------------------

        -------------------------------------
        -- Easy MC Sell
        -------------------------------------

        local locals = {
            MCSellScriptString = "gb_biker_contraband_sell",
            MCEZMissionStarted = 698+122, -- == 3 && (Local
            MCEZMission = 698+17, -- ^ function below
        
            MCLaptopString = "appbikerbusiness",
            MCLaptopCurrentProperty = 521,
        }

        menu.toggle_loop(sell_stuff, "Easy MC sell", {"easymc"}, "", function()
            local value = GetLocalInt(locals.MCSellScriptString, locals.MCEZMission)
            if value and value ~= 0 then
                SetLocalInt(locals.MCSellScriptString, locals.MCEZMission, 0)
            end
        end)

        -------------------------------------
        -- Remove Tony's Cut
        -------------------------------------

        -- https://www.unknowncheats.me/forum/3347568-post13086.html

        menu.toggle_loop(sell_stuff, "Tony's Cut of Nightclub be gone", {""}, "", function()
            SET_FLOAT_GLOBAL(262145 + 24496, 0) -- -1002770353
        end, function()
            SET_FLOAT_GLOBAL(262145 + 24496, 0.1)
        end)

        -------------------------------------
        -- Instant Finish Bunker
        -------------------------------------

        -- https://www.unknowncheats.me/forum/3521137-post39.html
        menu.action(sell_stuff, "Instant Bunker Sell", {"bunker"}, "Selling Only", function() 
            SET_INT_LOCAL("gb_gunrunning", 1205 + 774, 0)
        end)

        -------------------------------------
        -- Instant Air Cargo
        -------------------------------------

        -- https://www.unknowncheats.me/forum/3513482-post37.html
        menu.action(sell_stuff, "Instant Air Cargo", {"aircargo"}, "Selling Only", function() 
            SET_INT_LOCAL("gb_smuggler", 1928 + 1035, GET_INT_LOCAL("gb_smuggler", 1928 + 1078))
        end)

    -------------------------------------
    -- Business Stuff
    -------------------------------------       

        -------------------------------------
        -- Apply MB Stats
        -------------------------------------   

        local announce_transition_end = false
        local function on_transition_exit()
            if announce_transition_end then
                wait(5000)
                trigger_commands("resupplybunker on")
                wait(500)
                trigger_commands("monitorbunker on")
                wait(500)
                trigger_commands("setcapbunker 150")
                wait(500)
                trigger_commands("resupplycocaine on")
                wait(500)
                trigger_commands("setcapcocaine 30")
                wait(500)
                trigger_commands("resupplycash on")
                wait(500)
                trigger_commands("setcapcash 110")
                wait(500)
                trigger_commands("resupplymeth on")
                wait(500)
                trigger_commands("setcapmeth 80")
                wait(1000)
                notify("MB Stats applied.")
                log("[Lena | Apply MB Stats] MB Stats applied.")
            end
        end

        menu.toggle(business_shit, "Apply MB Stats", {""}, "", function(state)
            announce_transition_end = state
        end)

        -------------------------------------
        -- Apply MB Stats Trigger
        ------------------------------------- 

        menu.action(business_shit, "Apply MB Stats", {""}, "", function()
            wait(500)
            trigger_commands("resupplybunker on")
            wait(500)
            trigger_commands("setcapbunker 150")
            wait(500)
            trigger_commands("resupplycocaine on")
            wait(500)
            trigger_commands("setcapcocaine 30")
            wait(500)
            trigger_commands("resupplycash on")
            wait(500)
            trigger_commands("setcapcash 130")
            wait(500)
            trigger_commands("resupplymeth on")
            wait(500)
            trigger_commands("setcapmeth 60")
            wait(1000)
            notify("MB Stats applied")
            log("[Lena | Apply MB Stats] MB Stats applied!")
        end)

        -------------------------------------
        -- Monitor Businesses
        -------------------------------------

        menu.toggle(business_shit, "Monitor Business", {""}, "", function(on_toggle)
            if on_toggle then
                wait(500)
                trigger_commands("monitorbunker on")
                wait(500)
                trigger_commands("monitorcocaine on")
                wait(500)
                trigger_commands("monitorcash on")
                wait(500)
                trigger_commands("monitormeth on")
                wait(1000)
                notify("Monitoring Businesses")
            else 
                wait(500)
                trigger_commands("monitorcocaine off")
                wait(500)
                trigger_commands("monitorcash off")
                wait(500)
                trigger_commands("monitormeth off")
            end
        end)

    -------------------------------------
    -- Missions
    -------------------------------------        

        -------------------------------------
        -- Mission friendly
        -------------------------------------

        menu.toggle(missions_tunables, "Mission friendly", {"missionfriendly", "mfr"}, "Enables or disables Settings that might interfere with missions.", function(on_toggle)
            if on_toggle then
                trigger_commands("nolessen")
                trigger_commands("hosttoken off")
                trigger_commands("lockoutfit off")
                trigger_commands("svmreimpl off")
                wait(5000)
                notify("Mission friendly mode has been activated!")
            else
                trigger_commands("hosttoken on")
                trigger_commands("lockoutfit on")
                trigger_commands("bandaid")
                trigger_commands("svmreimpl on")
                notify("Mission friendly mode has been deactivated!")
            end
        end)

        -------------------------------------
        -- Headhunter
        -------------------------------------

        menu.action(missions_tunables, "Headhunter", {"hh"}, "Starts the CEO mission 'Headhunter'.", function()
            if players.get_boss(players.user()) == -1 then
                trigger_commands("ceostart")
                notify("Starting CEO... Please wait for a few secs.")
                wait(6000)
            end
            wait(500)
            IA_MENU_OPEN_OR_CLOSE()
            IA_MENU_ENTER(1)
            IA_MENU_DOWN(2)
            IA_MENU_ENTER(1)
            IA_MENU_DOWN(8)
            IA_MENU_ENTER(1)
            IA_MENU_ENTER(1)
        end, nil, nil, COMMANDPERM_FRIENDLY)

        -------------------------------------
        -- Finish Headhunter
        -------------------------------------

        menu.action(missions_tunables, "Finish Headhunter", {""}, "Tries to finish the Mission.", function()
            local Blip = HUD.GET_FIRST_BLIP_INFO_ID(432) -- https://docs.fivem.net/docs/game-references/blips/
            while HUD.DOES_BLIP_EXIST(Blip) do
                local Ped = HUD.GET_BLIP_INFO_ID_ENTITY_INDEX(Blip)
                ENTITY.SET_ENTITY_HEALTH(Ped, 0)
                Blip = HUD.GET_NEXT_BLIP_INFO_ID(432)
                wait_once()
            end
            wait(2000)
        end)

        -------------------------------------
        -- Take over LSIA
        -------------------------------------

        menu.action(missions_tunables, "Take over LSIA", {"lsia"}, "Starts the CEO Mission 'Hostile Takeover'.", function()
            if players.get_boss(players.user()) == -1 then
                trigger_commands("ceostart")
                notify("Starting CEO... Please wait for a few secs.")
                wait(5000)
            end
            wait(500)
            IA_MENU_OPEN_OR_CLOSE()
            IA_MENU_ENTER(1)
            IA_MENU_DOWN(2)
            IA_MENU_ENTER(1)
            IA_MENU_UP(6)
            wait(100)
            IA_MENU_ENTER()
            wait(100)
            IA_MENU_LEFT(2)
            wait(100)
            IA_MENU_DOWN(1)
            wait(100)
            IA_MENU_ENTER()
        end, nil, nil, COMMANDPERM_FRIENDLY)
        
        -------------------------------------
        -- Teleport Pickups To Me
        -------------------------------------

        menu.action(missions_tunables, "Teleport Pickups To Me", {"tppu"}, "Teleports all pickups to you.", function()
            local counter = 0
            local pos = players.get_position(players.user())
            for _, pickup in entities.get_all_pickups_as_handles() do
                ENTITY.SET_ENTITY_COORDS(pickup, pos, false, false, false, false)
                counter += 1
                wait()
            end
            if counter == 0 then
                notify("No Pickups Found. :/")
            else
                notify("Teleported ".. tostring(counter) .." Pickups.")
            end
        end)

    -------------------------------------
    -- Remove Costs
    -------------------------------------

    menu.toggle_loop(tunables, "CEO Abilities", {""}, "Makes all CEO Abilities Free.", function()
        SET_PACKED_INT_GLOBAL(12842, 12851, 0) -- GB_CALL_LIMO_COST, GB_BRIBE_AUTHORITIES_COST
        SET_PACKED_INT_GLOBAL(15968, 15973, 0) -- EXEC_VIP2_VOLATUS_RENTAL, EXEC_VIP2_HAVOK_RENTAL
        SET_INT_GLOBAL(262145 + 15890, 0) -- EXEC1_REQUEST_HELICOPTER
        SET_INT_GLOBAL(262145 + 19302, 0) -- IMPEXP_VIP_SUPERDIAMOND_COST
        SET_INT_GLOBAL(262145 + 19304, 0) -- IMPEXP_VIP_SUPERVOLITO_COST
    end, function()
        SET_PACKED_INT_GLOBAL(12843, 12845, 5000) -- GB_CALL_ARMORED_COGNOSCENTI_COST, GB_CALL_ARMORED_BALLER_COST
        SET_PACKED_INT_GLOBAL(15971, 15973, 5000) -- EXEC_VIP2_DINGHY_RENTAL, EXEC_VIP2_HAVOK_RENTAL
        SET_INT_GLOBAL(262145 + 12842, 20000) -- GB_CALL_LIMO_COST
        SET_INT_GLOBAL(262145 + 12846, 25000) -- GB_CALL_BUZZARD_COST
        SET_INT_GLOBAL(262145 + 12847, 1000) -- GB_DROP_AMMO_COST
        SET_INT_GLOBAL(262145 + 12848, 1500) -- GB_DROP_ARMOR_COST
        SET_INT_GLOBAL(262145 + 12849, 1000) -- GB_DROP_BULLSHARK_COST
        SET_INT_GLOBAL(262145 + 12850, 12000) -- GB_GHOST_ORG_COST
        SET_INT_GLOBAL(262145 + 12851, 15000) -- GB_BRIBE_AUTHORITIES_COST
        SET_INT_GLOBAL(262145 + 15890, 5000) -- EXEC1_REQUEST_HELICOPTER
        SET_INT_GLOBAL(262145 + 15968, 10000) -- EXEC_VIP2_VOLATUS_RENTAL
        SET_INT_GLOBAL(262145 + 15969, 7000) -- EXEC_VIP2_RUMPO_RENTAL
        SET_INT_GLOBAL(262145 + 15970, 9000) -- EXEC_VIP2_BRICKADE_RENTAL
        SET_INT_GLOBAL(262145 + 19302, 5000) -- IMPEXP_VIP_SUPERDIAMOND_COST
        SET_INT_GLOBAL(262145 + 19304, 10000) -- IMPEXP_VIP_SUPERVOLITO_COST
    end)

    -------------------------------------
    -- Refill Snacks and Armor
    -------------------------------------

    menu.action(tunables, "Refill Snacks & Armours", {""}, "Refills all Snacks and Armour.", function()
        STAT_SET_INT("NO_BOUGHT_YUM_SNACKS", 30)
        STAT_SET_INT("NO_BOUGHT_HEALTH_SNACKS", 15)
        STAT_SET_INT("NO_BOUGHT_EPIC_SNACKS", 15)
        STAT_SET_INT("NUMBER_OF_ORANGE_BOUGHT", 10)
        STAT_SET_INT("NUMBER_OF_BOURGE_BOUGHT", 10)
        STAT_SET_INT("CIGARETTES_BOUGHT", 10)
        STAT_SET_INT("MP_CHAR_ARMOUR_1_COUNT", 10)
        STAT_SET_INT("MP_CHAR_ARMOUR_2_COUNT", 10)
        STAT_SET_INT("MP_CHAR_ARMOUR_3_COUNT", 10)
        STAT_SET_INT("MP_CHAR_ARMOUR_4_COUNT", 10)
        STAT_SET_INT("MP_CHAR_ARMOUR_5_COUNT", 10)
        notify("Snacks and Armor refilled!")
    end)

    -------------------------------------
    -- Max Club Popularity
    -------------------------------------

    menu.action(tunables, "Max NC Popularity", {"maxnc"}, "Sets the Club Popularity to 100%.", function()
        trigger_commands("clubpo 100")
    end)

    -------------------------------------
    -- Multipliers
    -------------------------------------

    MUT_INPUT = menu.slider_float(multipliers, "Multipliers by 'x'.", {""}, "", 0, 500000, 100, 100, function(); end)

    menu.toggle_loop(multipliers, "RP", {""}, "", function()
        SET_FLOAT_GLOBAL(262145 + 1, menu.get_value(MUT_INPUT) / 100) -- XP_MULTIPLIER
    end, function()
        SET_FLOAT_GLOBAL(262145 + 1, menu.get_default_state(MUT_INPUT))
    end)

    menu.toggle_loop(multipliers, "Street Race", {""}, "", function()
        SET_FLOAT_GLOBAL(262145 + 31648, menu.get_value(MUT_INPUT) / 100) -- TUNER_STREET_RACE_PLACE_XP_MULTIPLIER
    end, function()
        SET_FLOAT_GLOBAL(262145 + 31648, menu.get_default_state(MUT_INPUT))
    end)
    
    menu.toggle_loop(multipliers, "Pursuit Race", {""}, "", function()
        SET_FLOAT_GLOBAL(262145 + 31649, menu.get_value(MUT_INPUT) / 100) -- TUNER_PURSUIT_RACE_PLACE_XP_MULTIPLIER
    end, function()
        SET_FLOAT_GLOBAL(262145 + 31649, menu.get_default_state(MUT_INPUT))
    end)

    menu.toggle_loop(multipliers, "LS Car Meet", {""}, "", function()
        SET_FLOAT_GLOBAL(262145 + 31652, menu.get_value(MUT_INPUT) / 100) -- TUNER_CARCLUB_VISITS_STREAK_XP_MULTIPLIER
    end, function()
        SET_FLOAT_GLOBAL(262145 + 31652, menu.get_default_state(MUT_INPUT))
    end)

    menu.toggle_loop(multipliers, "LS Car Meet Track", {""}, "", function()
        SET_FLOAT_GLOBAL(262145 + 31653, menu.get_value(MUT_INPUT) / 100) -- TUNER_CARCLUB_TIME_XP_MULTIPLIER
    end, function()
        SET_FLOAT_GLOBAL(262145 + 31653, menu.get_default_state(MUT_INPUT))
    end)

    menu.toggle(tunables, "Unlock R* Clothes", {""}, "Unlocks some Rockstar Clothes.", function(on_toggle)
        if on_toggle then
            trigger_commands("admindlc on")
        else
            trigger_commands("admindlc off")
        end
    end)

    -------------------------------------
    -- Start a BB
    -------------------------------------

    local start_a_bb = menu.ref_by_path("Online>Session>Session Scripts>Run Script>Freemode Activities>Business Battle 1")
    menu.action(tunables, "Start a Business Battle", {"bb"}, "Starts a 2 Crate Business Battle.", function()
        if menu.get_edition() >= 3 then 
            trigger_command(start_a_bb)
        else
            notify("You need Ultimate to Start a Business Battle, request denied.")
        end
    end, nil, nil, COMMANDPERM_FRIENDLY)

    -------------------------------------
    -- Start a BB
    -------------------------------------    

    menu.toggle_loop(tunables, "Nightclub Popularity", {""}, "Keeps the Nightclub Popularity at 90%.", function()
        if util.is_session_started() then
            local ncpop = math.floor(STAT_GET_INT('CLUB_POPULARITY') / 10)
            if ncpop < 90 then
                notify("NC Popularity Maxed")
                log("[Lena | NC Popularity] NC Popularity Maxed!")
                menu.trigger_commands('clubpopularity 100')
                util.yield(250)
            end
        end
    end)

-------------------------------------
-------------------------------------
-- Misc
-------------------------------------
-------------------------------------

    -------------------------------------
    -- Teleports
    -------------------------------------  
    
        -------------------------------------
        -- Interiors TP's
        -------------------------------------

        for index, data in interiors do
            local location_name = data[1]
            local location_coords = data[2]
            menu.action(teleport, location_name, {"tplo"..location_name}, "", function()
                menu.trigger_commands("doors on")
                menu.trigger_commands("nodeathbarriers on")
                if not PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then 
                    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), location_coords.x, location_coords.y, location_coords.z, false, false, false)
                else
                    PED.SET_PED_COORDS_KEEP_VEHICLE(players.user_ped(), location_coords.x, location_coords.y, location_coords.z)
                end
            end)
        end

    -------------------------------------
    -- Clear Area
    -------------------------------------

        -------------------------------------
        -- Clear Area All
        -------------------------------------

        menu.action(clear_area_locally, "Clear Area", {"ca"}, "Clears the Area around you without sending Freeze events.", function()
            local cleanse_entitycount = 0
            for _, ped in entities.get_all_peds_as_handles() do
                if ped ~= players.user_ped() and not PED.IS_PED_A_PLAYER(ped) and NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(ped) and (not NETWORK.NETWORK_IS_ACTIVITY_SESSION() or NETWORK.NETWORK_IS_ACTIVITY_SESSION() and not ENTITY.IS_ENTITY_A_MISSION_ENTITY(ped)) then
                    entities.delete_by_handle(ped)
                    cleanse_entitycount += 1
                    wait()
                end
            end
            notify("Cleared " .. cleanse_entitycount .. " Peds")

            cleanse_entitycount = 0
            for _, vehicle in entities.get_all_vehicles_as_handles() do
                if vehicle ~= PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false) and DECORATOR.DECOR_GET_INT(vehicle, "Player_Vehicle") == 0 and NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(vehicle) then
                    entities.delete_by_handle(vehicle)
                    cleanse_entitycount += 1
                    wait()
                end
            end
            notify("Cleared ".. cleanse_entitycount .." Vehicles")

            cleanse_entitycount = 0
            for _, object in entities.get_all_objects_as_handles() do
                entities.delete_by_handle(object)
                cleanse_entitycount += 1
                wait()
            end
            notify("Cleared " .. cleanse_entitycount .. " Objects")

            cleanse_entitycount = 0
            for _, pickup in entities.get_all_pickups_as_handles() do
                entities.delete_by_handle(pickup)
                cleanse_entitycount += 1
                wait()
            end
            notify("Cleared " .. cleanse_entitycount .. " Pickups")

            local temp = memory.alloc(4)
            for i = 0, 100 do
                memory.write_int(temp, i)
                PHYSICS.DELETE_ROPE(temp)
            end
        end)

    -------------------------------------
    -- Shortcuts
    -------------------------------------

        -------------------------------------
        -- Delete Vehicle
        -------------------------------------

        menu.action(shortcuts, "Delete Vehicle", {"dv"}, "Deletes your current vehicle.", function()
            trigger_commands("deletevehicle")
        end)

        -------------------------------------
        -- Grab Scrip Host
        -------------------------------------

        menu.action(shortcuts, "Grab Script Host", {"sh"}, "Grabs Script Host in a less destructive way.", function()
            trigger_command(menu.ref_by_path("Players>"..players.get_name_with_tags(players.user())..">Friendly>Give Script Host"))
        end)

        -------------------------------------
        -- Easy Way Out
        -------------------------------------

        menu.action(shortcuts, "Really easy Way out", {"kms"}, "Kill yourself.", function()
            local pos = ENTITY.GET_ENTITY_COORDS(players.user_ped(), false)
            pos.z = pos.z - 1.0
            FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, 5, 1.0, false, false, 1.0)
        end)

        -------------------------------------
        -- Stop all Sounds
        -------------------------------------

        menu.action(shortcuts, "Force Stop all sound events", {"stopsounds"}, "Stops all current Sounds from playing. Does not stop Scripted Music.", function()
            for i=1,99 do
                AUDIO.STOP_SOUND(i)
                AUDIO.RELEASE_SOUND_ID(i)
            end
        end)

        -------------------------------------
        -- Start a CEO
        ------------------------------------- 

        if dev_vers then
            menu.action(shortcuts, "Start a CEO", {"ceo"}, "Starts a CEO.", function()
                if players.get_boss(players.user()) == -1 then
                    trigger_commands("ceostart")
                    notify("Starting CEO... Please wait for a few secs.")
                    wait(3000)
                    trigger_commands("ceoname ¦ Monarch")
                elseif players.get_boss(players.user()) == players.user() then
                    notify("You are already your own Boss!")
                    trigger_commands("ceoname ¦ Monarch")
                else
                    notify("You are already working for someone else!")
                end
            end)
        else
            menu.action(shortcuts, "Start CEO", {"ceo"}, "Starts a CEO.", function()
                if players.get_boss(players.user()) == -1 then
                    trigger_commands("ceostart")
                    notify("Starting CEO... Please wait for a few secs.")
                elseif players.get_boss(players.user()) == players.user() then
                    notify("You are already your own Boss!")
                else
                    notify("You are already working for someone else!")
                end
            end)
        end

        -------------------------------------
        -- Yeet
        -------------------------------------

        menu.action(shortcuts, "Unload", {"bye", "ul"}, "Blocks all Cwashes.", function()
            trigger_commands("bandaid off")
            wait(2000)
            trigger_commands("breakupbandaid off")
            wait(2000)
            notify("Lessen has been disabled. Unloading in 3 seconds.")
            log("[Lena | Unload] Lessen has been disabled. The Menu will unload in 3 seconds.")
            wait(3000)
            trigger_commands("unload")
        end)

        -------------------------------------
        -- No lessen
        -------------------------------------

        menu.action(shortcuts, "No lessen", {"nolessen", "nl"}, "Disabled Lessen Breakups so you don't break Missions.", function()
            trigger_commands("bandaid off")
            wait(2000)
            trigger_commands("breakupbandaid off")
            wait(2000)
            notify("Lessen has been disabled.")
        end)

        -------------------------------------
        -- Buy Ammo
        -------------------------------------    

        menu.action(shortcuts, "Buy Ammo", {"buyammo"}, "Buys ammo the legit way.", function()
            wait(500)
            if players.get_boss(players.user()) == -1 then
                notify("Not in a CEO... changing config")
                IA_MENU_OPEN_OR_CLOSE()
                IA_MENU_DOWN(2)
                IA_MENU_ENTER(1)
                IA_MENU_DOWN(6)
                IA_MENU_ENTER(1)
                IA_MENU_LEFT(1)
                IA_MENU_DOWN(1)
                IA_MENU_ENTER(1)
                IA_MENU_OPEN_OR_CLOSE()
            else
                notify("In a CEO... changing config")
                IA_MENU_OPEN_OR_CLOSE()
                IA_MENU_DOWN(3)
                IA_MENU_ENTER(1)
                IA_MENU_DOWN(6)
                IA_MENU_ENTER(1)
                IA_MENU_LEFT(1)
                IA_MENU_DOWN(1)
                IA_MENU_ENTER(1)
                IA_MENU_OPEN_OR_CLOSE()
            end
        end)

        -------------------------------------
        -- Spawn Buzzard
        -------------------------------------

        menu.action(shortcuts, "Spawn Buzzard", {"b1"}, "Spawns a CEO Buzzard.", function()
            if players.get_boss(players.user()) == -1 then
                trigger_commands("ceostart")
                notify("Starting CEO... Please wait for a few secs.")
                wait(5000)
            end
            if players.get_boss(players.user()) ~= -1 then
                if players.get_boss(players.user()) == players.user() then
                    wait(500)
                    IA_MENU_OPEN_OR_CLOSE()
                    IA_MENU_ENTER(1)
                    IA_MENU_UP(2)
                    IA_MENU_ENTER(1)
                    IA_MENU_DOWN(4)
                    IA_MENU_ENTER(1)
                else
                    wait(500)
                    IA_MENU_OPEN_OR_CLOSE()
                    IA_MENU_ENTER(1)
                    IA_MENU_ENTER(1)
                    IA_MENU_DOWN(2)
                    IA_MENU_ENTER(1)
                end
            else
                wait(3000)
                trigger_commands("b1")
            end
        end)

        -------------------------------------
        -- INSTANT RC TANK
        -------------------------------------

        menu.action(shortcuts, "Instant RC Tank", {""}, "Spawns a RC Tank.", function ()
            write_global.int(2793044 + 6875, 1)
            if not DoesPlayerOwnMinitank(players.user()) then
                local address = memory.script_global(1853910 + (players.user() * 862 + 1) + 267 + 428 + 2)
                memory.write_int(address, SetBit(memory.read_int(address), 15))
            end
        end)

        -------------------------------------
        -- Race Mode
        -------------------------------------

        menu.action(vehicle, "Race Mode", {"racemode"}, "Changes some settings that makes races more fair.", function()
            trigger_commands("perf; gravitymult 1")
            notify("Race mode has been enabled!")
        end)

    -------------------------------------
    -- Disable Numpad
    -------------------------------------

    menu.toggle_loop(misc, "Disable Numpad", {"dn"}, "Disables the Numpad while Stand is open.", function()
        if not menu.is_open()--[[or lkey.is_key_down('VK_LBUTTON') or lkey.is_key_down('VK_RBUTTON')]] then return end
        for _, control in numpadControls do
            PAD.DISABLE_CONTROL_ACTION(2, control, true)
        end
    end)

    -------------------------------------
    -- Toggle Thunder
    -------------------------------------

    menu.toggle(misc, "Weather Toggle", {"thunder"}, "Requests Thunder Session-wide.", function(on_toggle) 
        local thunder_on = menu.ref_by_path("Online>Session>Thunder Weather>Enable Request")
        local thunder_off = menu.ref_by_path("Online>Session>Thunder Weather>Disable Request")
        if on_toggle then
            trigger_commands("weather normal")
            wait(1000)
            trigger_command(thunder_on)
            wait(10000)
            notify("Weather Set to Thunder") 
        else
            trigger_command(thunder_off)
            wait(10000)
            trigger_commands("weather extrasunny")
            notify("Weather Set back to Normal") 
        end
    end)

    -------------------------------------
    -- Auto Join 
    -------------------------------------

    menu.toggle_loop(misc, "Auto Accept Joining Games", {""}, "Will auto accept join screens.", function()
        local message_hash = HUD.GET_WARNING_SCREEN_MESSAGE_HASH()
        local hashes = {99184332, 15890625, -398982408, -587688989}
        for _, hash in hashes do
            if message_hash == hash --[[15890625 or message_hash == -398982408 or message_hash == -587688989]] then
                PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 201, 1.0)
                wait(50)
            end
        end
    end)
    
    -------------------------------------
    -- Rockstar Verified All
    -------------------------------------     

    menu.toggle_loop(misc, "Rockstar Verified All", {""}, "You will always be Rockstar Verified with this.", function()
        if PAD.IS_CONTROL_JUST_PRESSED(1, 245) then
            local icon = "¦"
            chat.ensure_open_with_empty_draft(false)
            chat.add_to_draft(icon.." ")
        end
    end)

    -------------------------------------
    -- No Traffic
    -------------------------------------    

    local config = {
        disable_traffic = true,
        disable_peds = true,
    }
    local pop_multiplier_id
    
    menu.toggle(misc, "No Traffic", {""}, "Deletes all Traffic from map. Works Session-Wide.", function(on)
        if on then
            local ped_sphere, traffic_sphere
            if config.disable_peds then ped_sphere = 0.0 else ped_sphere = 1.0 end
            if config.disable_traffic then traffic_sphere = 0.0 else traffic_sphere = 1.0 end
            pop_multiplier_id = MISC.ADD_POP_MULTIPLIER_SPHERE(1.1, 1.1, 1.1, 15000.0, ped_sphere, traffic_sphere, false, true)
            MISC.CLEAR_AREA(1.1, 1.1, 1.1, 19999.9, true, false, false, true)
        else
            MISC.REMOVE_POP_MULTIPLIER_SPHERE(pop_multiplier_id, false);
        end
    end)

-------------------------------------
-------------------------------------
-- AI Made Actions
-------------------------------------
-------------------------------------

    -------------------------------------
    -- Countdown
    -------------------------------------  

    menu.action(ai_made, "Countdown", {"countdown"}, "Start the countdown.", function()
        for i = 3, 1, -1 do
            chat.send_message(i, false, true, true)
            util.yield(1000)
        end
        chat.send_message("GO!!!", false, true, true)
    end, nil, nil, COMMANDPERM_FRIENDLY)

    -------------------------------------
    -- Roulette Earnings
    -------------------------------------  

    menu.action(ai_made, "Roulette Earnings", {"roulette_earnings"}, "Displays earnings information for roulette.", function()
        local win_amount = 330000 - 55000
        local message = string.format("To maximize your earnings in roulette, you can bet MAX on both 7 and 1st 12. If you pay 55000 and win 330000, you will earn %d per game.", win_amount)
        chat.send_message(message, false, true, true)
    end)

    -------------------------------------   
    -- Money Drops Warning  
    -------------------------------------   

    menu.action(ai_made, "Money Drops Warning", {"money_drops_warning"}, "Warns players about the risks of money drops.", function()
        local message = "Money drops are a waste of time and risky. They offer little reward and often result in lost progress. Even if I were to participate in money drops, I wouldn't because they are simply a waste of time. Stick to safer and more profitable options."
        chat.send_message(message, false, true, true)
    end)

    -------------------------------------
    -- Remove Bounty
    -------------------------------------      

    menu.toggle_loop(ai_made, "Remove Bounty", {"remove_bounty"}, "Automatically remove bounties.", function()
        local player = players.user()
        local has_bounty = players.get_bounty(player)
        if has_bounty and players.is_in_interior(players.user()) then
            notify("You have a bounty on you. But i can't remove it if you're in a interior.")
            wait(30000)
        elseif has_bounty and not util.is_session_transition_active() and not players.is_in_interior(players.user()) then
            util.yield(10000)
            menu.trigger_commands("removebounty")
            util.toast("Bounty removed.\nAmount: "..has_bounty)
            util.log("[Lena | Auto-remove Bounty] Bounty removed. Amount: "..has_bounty)
            util.yield(20000)
        end
    end)

    -------------------------------------
    -- Take a Break Reminder
    -------------------------------------      

    menu.toggle_loop(ai_made, "Take a Break Reminder", {"break_reminder"}, "Reminds you to take a break every hour.", function()
        local break_interval = 3600 * 1000 -- 1 hour in milliseconds
        local num_breaks = 0
        num_breaks = num_breaks + 1
        if num_breaks % (break_interval / 1000) == 0 then
        util.toast("Time to take a break! "..num_breaks)
        util.log("[Lena | Break reminder] Time to take a break! "..num_breaks)
        end
        util.yield(1000)
    end)

    -------------------------------------
    -- Auto Skip Cutscenes
    -------------------------------------      

    menu.toggle_loop(ai_made, "Auto Skip Cutscenes", {"auto_skip_cutscenes"}, "Automatically skips cutscenes.", function()
        if CUTSCENE.IS_CUTSCENE_PLAYING() then
            CUTSCENE.STOP_CUTSCENE_IMMEDIATELY()
            util.toast("Cutscene skipped!")
        end
        util.yield(3000)
    end)
    
    -------------------------------------
    -- Auto Skip Conversations
    -------------------------------------

    menu.toggle_loop(ai_made, "Auto Skip Conversations", {"auto_skip_conversations"}, "Automatically skips conversations.", function()
        if AUDIO.IS_SCRIPTED_CONVERSATION_ONGOING() then
            AUDIO.STOP_SCRIPTED_CONVERSATION(false)
            util.toast("Conversation skipped!")
        end
        util.yield(3000)
    end)
    
-------------------------------------
-------------------------------------
-- [Debug]
-------------------------------------
-------------------------------------

if dev_vers then
    local sdebug = menu.list(menu.my_root(), "[Debug]", {"lenadebug"}, "")
    local nativec = menu.list(sdebug, "Native Feedback", {""}, "")

    -------------------------------------
    -- Get Vehicle
    -------------------------------------

    menu.action(sdebug, "Get Vehicle", {""}, "Gets The current Model and Name.", function()
        local pped = players.user()
        local vname = check(util.get_label_text(players.get_vehicle_model(pped)))
        local vmodel = players.get_vehicle_model(pped)
        notify("Vehicle Model: "..vmodel.."\nName: ".. vname)
        log("[Lena | Get Vehicle] Vehicle Model: "..vmodel.." | Name: ".. vname)
    end)

    -------------------------------------
    -- Restart Session Scripts
    -------------------------------------

    rss = menu.action(sdebug, "Restart Session Scripts", {"rss"}, "Restarts the freemode.c script.\nThis will remove your weapons for some reason. Kill yourself and you will get them back.", function(click_type)
        trigger_commands("skiprepeatwar off; commandsskip off")
        wait(1000)
        if not util.is_session_transition_active() then
            if players.get_script_host() == nil and players.get_host() ~= players.user() then
                notify("Session seems to be in a broken State but you are not the Host.")
                menu.show_warning(rss, click_type, "Do you want to restart the session? This can fix the session, but also cancel deliveries or current missions for other players.", function()
                    menu.show_warning(rss, click_type, "Are you Sure? Doing this as a Non-Host might make it even worse.", function()
                        restartsession()
                    end, function()
                        notify("Aborted.")
                    end, true)
                end, function()
                    notify("Aborted.")
                end, true)
            elseif players.get_script_host() == nil then
                notify("Session seems to be in a broken State")
                menu.show_warning(rss, click_type, "Do you want to restart the session? This can fix the session, but also cancel deliveries or current missions for other players.", function()
                    restartsession()
                end, function()
                    notify("Aborted.")
                end, true)
            elseif players.get_script_host() ~= nil and players.get_host() ~= players.user() then
                notify("Session seems to be in a working State but you are not the Host.")
                menu.show_warning(rss, click_type, "Do you want to restart the session? This can fix the session, but also cancel deliveries or current missions for other players.", function()
                    menu.show_warning(rss, click_type, "Are you Sure? Doing this as a Non-Host might make it even worse.", function()
                        restartsession()
                    end, function()
                        notify("Aborted.")
                    end, true)
                end, function()
                    notify("Aborted.")
                end, true)
            elseif players.get_script_host() ~= nil then
                notify("Session seems to be in a working State")
                menu.show_warning(rss, click_type, "The Session seems to be in a fixed state, do you still want to restart it? This can fix the session, but also cancel deliveries or ongoing missions for other players.", function()
                    restartsession()
                end, function()
                    notify("Aborted.")
                end, true)
            end
        else
            notify("Aborting. You first need to join a Session.")
        end
    end)

    -------------------------------------
    -- Easier Better Vehicles
    -------------------------------------

    menu.action(sdebug, "Easier Better Vehicles", {"bv"}, "", function()
        local pped = players.user()
        local vmodel = players.get_vehicle_model(pped)
        local vname = util.get_label_text(vmodel)
        local is_plane = VEHICLE.IS_THIS_MODEL_A_PLANE(vmodel)
        local is_heli = VEHICLE.IS_THIS_MODEL_A_HELI(vmodel)
        local is_car = VEHICLE.IS_THIS_MODEL_A_CAR(vmodel)
        if is_plane then
            if vmodel == -1700874274 then
                trigger_commands("vhengineoffglidemulti 10")
                trigger_commands("vhgeardownliftmult 1")
                trigger_commands("gravitymult 2")
                trigger_commands("fovfpinveh 90")
                notify("Due to the Starling being a little fucker, I had to change my Code.\nBetter Planes have been enabled for: "..vname)
            else
                trigger_commands("vhengineoffglidemulti 10")
                trigger_commands("vhgeardownliftmult 1")
                trigger_commands("gravitymult 2")
                trigger_commands("vhgeardowndragv 0.3")
                trigger_commands("fovfpinveh 90")
                notify("Better Planes have been enabled for: "..vname)
            end
        elseif is_heli then
            trigger_commands("betterheli")
            trigger_commands("gravitymult 1")
            trigger_commands("helithrust 2.3")
            trigger_commands("fovfpinveh 90")
            notify("Better Helis have been enabled for: "..vname)
        elseif util.is_this_model_a_blimp(vmodel) then
            notify("Better Blimps have been enabled for: "..vname)
            trigger_commands("gravitymult 1")
            trigger_commands("betterheli")
            trigger_commands("helithrust 2.3")
        else
            notify("Not a Vehicle suitable for the Better Vehicle Settings :/\nCurrent Vehicle: "..vname)
            trigger_commands("gravitymult 2")
            trigger_commands("fovfpinveh -5")
            trigger_commands("forceflares off")
        end
    end)

    -------------------------------------
    -- Natives
    ------------------------------------- 

        local nativehud = menu.list(nativec, "HUD", {""}, "")
        local nativevehicle = menu.list(nativec, "VEHICLE", {""}, "")
        local nativeentity = menu.list(nativec, "ENTITY", {""}, "")

        -------------------------------------
        -- HUD
        ------------------------------------- 

        menu.action(nativehud, "Get Warning Screen hash.", {""}, "", function()
            local hash = HUD.GET_WARNING_SCREEN_MESSAGE_HASH()
            log("[Lena | Warning Screen Hash] Warning Screen hash: "..hash)
            notify("Warning Screen hash: "..hash)
        end) 

        -------------------------------------
        -- VEHICLE
        ------------------------------------- 

        menu.action(nativevehicle, "Get Plate Text", {""}, "Gets the Current Number Plate Text.", function()
            notify(VEHICLE.GET_VEHICLE_NUMBER_PLATE_TEXT(entities.get_user_vehicle_as_handle()))
            log("[Lena | Plate Text]"..VEHICLE.GET_VEHICLE_NUMBER_PLATE_TEXT(entities.get_user_vehicle_as_handle()))
        end)
        menu.action(nativevehicle, "Set Number Plate", {""}, "Sets the Current Number Plate to a random Text.", function()
            local plate_texts = {"VEROSA", "LOVE", "LOVE YOU", "TOCUTE4U", "TOFAST4U", "LENA", "LENALEIN", "HENTAI", "FNIX", "SEXY", "CUWUTE", " ", "0Bitches", "Get Good"}
            VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(entities.get_user_vehicle_as_handle(), first_to_upper(string.lower(plate_texts[math.random(#plate_texts)])))
        end)
        menu.toggle_loop(nativevehicle, "Get Countermeasures", {""}, "", function()
            if PAD.IS_CONTROL_JUST_PRESSED(2, 356) then
                wait(500)
                local vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
                local cm = VEHICLE.GET_VEHICLE_COUNTERMEASURE_AMMO(vehicle)
                notify(cm)
            end
        end)

        -------------------------------------
        -- ENTITY
        -------------------------------------         

        menu.action(nativeentity, "Get Ped health", {""}, "Gets your current Health.", function()
            local pped = players.user_ped()
            local phealth = ENTITY.GET_ENTITY_HEALTH(pped)
            notify("Ped Health: "..phealth)
        end)
        menu.action(nativeentity, "Get Vehicle health", {""}, "Gets the Health of the Vehicle you are using.", function()
            local pveh = entities.get_user_vehicle_as_handle()
            local vhealth = ENTITY.GET_ENTITY_HEALTH(pveh)
            notify("Vehicle Health: "..vhealth)
        end)
        menu.action(nativeentity, "Clone Player", {""}, "Clones the Player Ped.", function()
            local whore = PED.CLONE_PED(players.user_ped(), true, true, true)
            local cords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), -5.0, 0.0, 0.0)
            ENTITY.SET_ENTITY_COORDS(whore, cords.x, cords.y, cords.z)
            TASK.TASK_START_SCENARIO_IN_PLACE(whore, "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS", 0, false)
        end)
  --end
end

--------------------------------------------------------------------------------
------------------------------- PLAYER FEATURES --------------------------------
--------------------------------------------------------------------------------

    -------------------------------------
    -- Save Information
    -------------------------------------    

        Crew =
        {
            icon = 0,
            tag = "",
            name = "",
            motto = "",
            alt_badge = "Off",
            rank = "",
        }
        Crew.__index = Crew
        function Crew.new(o)
            o = o or {}
            local self = setmetatable(o, Crew)
            return self
        end
        function Crew.get_player_crew(player)
            local self = setmetatable({}, Crew)
            local networkHandle = memory.alloc(104)
            local clanDesc = memory.alloc(280)
            NETWORK.NETWORK_HANDLE_FROM_PLAYER(player, networkHandle, 13)
            if NETWORK.NETWORK_IS_HANDLE_VALID(networkHandle, 13) and
            NETWORK.NETWORK_CLAN_PLAYER_GET_DESC(clanDesc, 35, networkHandle) then
                self.icon = memory.read_int(clanDesc)
                self.name = memory.read_string(clanDesc + 0x08)
                self.tag = memory.read_string(clanDesc + 0x88)
                self.rank = memory.read_string(clanDesc + 0xB0)
                self.motto = players.clan_get_motto(player)
                self.alt_badge = memory.read_byte(clanDesc + 0xA0) ~= 0 and "On" or "Off"
            end
            return self
        end
        Crew.__eq = function (a, b)
            return a.icon == b.icon and a.tag == b.tag and a.name == b.name
        end
        Crew.__pairs = function(tbl)
            local k <const> = {"icon", "name", "tag", "motto", "alt_badge", "rank"}
            local i = 0
            local iter = function()
                i = i + 1
                if tbl[k[i]] == nil then return nil end
                return k[i], tbl[k[i]]
            end
            return iter, tbl, nil
        end
        Profile = {}
        Profile.__index = Profile
        function Profile.new(o)
            o = o or {}
            local self = setmetatable(o, Profile)
            self.crew = Crew.new(self.crew)
            return self
        end
        function Profile.get_profile_from_player(player)
            local self = setmetatable({}, Profile)
            self.name = PLAYER.GET_PLAYER_NAME(player)
            self.rid = players.get_rockstar_id(player)
            self.money = players.get_money(player)
            self.rank = players.get_rank(player)
            self.modder = players.is_marked_as_modder(player)
            self.crew = Crew.get_player_crew(player)
            self.ip = get_external_ip(player)
            return self
        end
        Profile.__eq = function (a, b)
            return a.name == b.name and a.rid == b.rid and a.money == b.money and a.rank == b.rank and a.modder == b.modder and
            a.crew == b.crew and a.ip == b.ip
        end
        Profile.__pairs = function(tbl)
            local k <const> = {"name", "rid", "money", "rank", "modder", "crew", "ip"}
            local i = 0
            local iter = function()
                i = i + 1
                if tbl[k[i]] == nil then return nil end
                return k[i], tbl[k[i]]
            end
            return iter, tbl, nil
        end
        ProfileManager =
        {
            reference = 0,
            profiles = {},
            menuLists = {},
            dir = lenaDir .. "Players\\",
        }
        ProfileManager.__index = ProfileManager
        function ProfileManager.new(parent)
            local self = setmetatable({}, ProfileManager)
            self.profiles = {}
            return self
        end
        function ProfileManager:includes(profile)
            return table.find(self.profiles, profile) ~= nil
        end
        function ProfileManager:add(menuName, profile)
            self.profiles[menuName] = profile; self.menuLists[menuName] = root
        end
        function ProfileManager:save(profile, add)
            local fileName = profile.name
            if self.profiles[fileName] then
                local i = 2
                repeat
                    fileName = string.format("%s (%d)", profile.name, i)
                    i = i + 1
                until not self.profiles[fileName]
            end
            local file <close> = assert(io.open(self.dir .. fileName .. ".json", "w"))
            local content = json.stringify(profile, nil, 4)
            file:write(content)
            if add then self:add(fileName, profile) end
        end
    local profilesList <const> = ProfileManager.new(menu.my_root())

local function player(pid)

    -- Dev Detection
    if pid ~= players.user() and players.get_rockstar_id(pid) == 0x0C59991D or players.get_rockstar_id(pid) == 0x0CE211ED or players.get_rockstar_id(pid) == 140725798 then
        notify(lang.get_string(0xD251C4AA, lang.get_current()):gsub("{(.-)}", {player = players.get_name(pid), reason = "Lena-Utilities Developer"}), TOAST_DEFAULT)
        log(lang.get_string(0xD251C4AA, lang.get_current()):gsub("{(.-)}", {player = players.get_name(pid), reason = "Lena-Utilities Developer"}))
    end

    -- Player recognition
    local idiots = {
    -- L
    0x0C6A8CD9, 0x0CAFF827, 0x04DCD691, 0x07E862F8, 0x096E22A3, 0x0967E1C2,
    -- Other Idiots
    0x0B0236FA, 0x01585AB7, 0x09038DD9, 0x01394640, 0x0CB7CFF2, 0x0C666371, 0x04A5C95B, 0x0C76C9E2, 0x0B7EC980, 0x0C121CAD, 0x0919B57F, 0x0C682AB5, 0x03280B78, 0x0479C7D8,
    0x0BB6BAE6, 0x05EB0C06, 0x0C0EFC07, 0x0A9FD9CD, 0x0A1FA84B, 0x0101D84E, 0x0CA6E931, 0x0691AC07, 0x0AA87C21, 0x0988DB36, 0x06AE10E2, 0x071D0AF9, 0x0B93038B, 0x0D029C4A,
    0x0CCC3A82, 0x02314B16, 0x0C2590C9, 0x0D193EEE, 0x0BE0E3BE, 0x09D7781F, 0x0BCA5D8C, 0x0AFA420F, 0x07E06196, 0x0CDC6337, 0x0B8B307C, 0x0C0DEC0E, 0x04999905, 0x028C8ADD,
    0x0B57C870, 0x005A41F0, 0x0C7EC044, 0x0CBDDE32, 0x0860F534, 0x0B848C99, 0x07508CFB, 0x0A07EB9E, 0x06F51B2F, 0x03097926, 0x0D04F24C, 0x0AE5DA82, 0x0A7D2684, 0x0BF272C9,
    0x0B38BC94, 0x0083EAD9, 0x0CFC75F7, 0x004D2E05, 0x5AB5E2F2, 0x0A739990, 0x01904EBA, 0x01480A39, 0x09A5E63E, 0x075A591F, 0x0C50A172, 0x00D344E0, 0x0C6C9C9E, 0x098105F0,
    0x0B316B93, 0x0D3C0DD1, 0x05059BDC, 0x097D765F, 0x0BEE6E37, 0x061EADCF, 0x0984EECF, 0x0C7290DE, 0x0BE2A63A, 0x041B4798, 0x0C7D65E8, 0x09667B59, 0x06298EFC, 0x04BB8D72,
    0x0B2E000F, 0x0C0ADFC5, 0x0B23A552, 0x0CEBEA08, 0x0CB2AB74, 0x0AEBC1AF, 0x05BCAAD9, 0x0B0F32F8, 0x0BE93141, 0x09F72C49, 0x086B5F3F, 0x0BAD4E5C, 0x0C9B1FA5, 0x0AF83D87,
    0x09F6C328, 0x07DC40B4, 0x058DCDAD, 0x0C46C36E, 0x0A22088E, 0x0CBAAEB3, 0x0BE7C35E, 0x0D5021BD, 0x0D44E8AF, 0x0963AC38, 0x0D1788D8, 0x083121AB, 0x070C1D13, 0x0C025C35,
    0x04504CCB, 0x0C15670E, 0x09DC648E, 0x0046658F, 0x00456136, 0x05D5715F, 0x0D1E3C6E, 0x07B6FB71, 0x0C98B465,
    -- Retard
    0x0CE7F2D8, 0x0CDF893D, 0x206611492, 0x208152106, 0x0CEA2329, 0x0D040837, 0x0A0A1032, 0x0D069832, 0x0B7CF320
    }

    for _, rid in idiots do
        if players.get_rockstar_id(pid) == rid and get_spawn_state(pid) ~= 0 then 
            trigger_commands("historyblock" .. players.get_name(pid) .. " on")
            wait(500)
            trigger_commands("kick " .. players.get_name(pid))
        end
    end

    menu.divider(menu.player_root(pid), "Lena Utilities")
    local lena = menu.list(menu.player_root(pid), "Lena Utilities", {"lenau"}, "")
    local friendly = menu.list(lena, "Friendly", {""}, "")
    local mpvehicle = menu.list(lena, "Vehicle", {""}, "")
    local trolling = menu.list(lena, "Trolling", {""}, "")
    local player_removals = menu.list(lena, "Remove Player", {""}, "")
    local kicks = menu.list(player_removals, "Kicks", {""}, "")
    local crashes = menu.list(player_removals, "Crashes", {""}, "")
    local tp_player = menu.list(trolling, "Teleport Player", {""}, "")
    local clubhouse = menu.list(tp_player, "Clubhouse", {""}, "")
    local facility = menu.list(tp_player, "Facility", {""}, "")
    local arcade = menu.list(tp_player, "Arcade", {""}, "")
    local warehouse = menu.list(tp_player, "Warehouse", {""}, "")
    local cayop = menu.list(tp_player, "Cayo Perico", {""}, "")
    local large = menu.list(warehouse, "Large Warehouse", {""}, "")
    local customExplosion = menu.list(trolling, "Custom Explosion", {""}, "")
    local mpcage = menu.list(trolling, "Cage", {""}, "")

	-------------------------------------
	-- Save Player Info
	-------------------------------------

	menu.action(lena, "Save Info", {"save"}, "Save some Information about this Player.", function ()
		local profile = Profile.get_profile_from_player(pid)
		if profilesList:includes(profile) then
			return notification:help("Profile already exists :/", HudColour.red)
		end
		profilesList:save(profile, true)
		notification:normal("Spoofing Profile saved :D")
	end)

    -------------------------------------
    -------------------------------------
    -- Friendly
    -------------------------------------
    -------------------------------------

        -------------------------------------
        -- Check Stats
        -------------------------------------

        menu.action(friendly, "Check Stats", {"checkstats"}, "Checks the stats of the Player.", function()
            local rank = players.get_rank(pid)
            local money = players.get_money(pid)
            local kills = players.get_kills(pid)
            local deaths = players.get_deaths(pid)
            local kdratio = players.get_kd(pid)
            local language = ({'English','French','German','Italian','Spanish','Brazilian','Polish','Russian','Korean','Chinese (T)','Japanese','Mexican','Chinese (S)'})[players.get_language(pid) + 1]
            notify("Name : " .. players.get_name(pid).."\nLanguage: "..language.. "\nRank: " .. rank .. "\nMoney: " .. string.format("%.2f", money/1000000) .. "M$" .. "\nKills/Deaths: " .. kills .. "/" .. deaths .. "\nRatio: " .. string.format("%.2f", kdratio))
        end)

        -------------------------------------
        -- Summon
        -------------------------------------        

        menu.action(friendly, "Summon", {"sum"}, "Teleports the Player to you.", function()
            trigger_commands("givesh"..players.get_name(pid))
            wait(100)
            trigger_commands("summon"..players.get_name(pid))
        end, nil, nil, COMMANDPERM_RUDE)

        -------------------------------------
        -- Invite to CEO/MC
        -------------------------------------

        menu.action(friendly, "Invite to CEO/MC", {"ceoinv"}, "Invites the Player to your CEO.", function()
            sendse(1 << pid, {
                -1367443755,
                players.user(),
                4,
                10000, -- wage?
                0,
                0,
                0,
                0,
                memory.read_int(memory.script_global(1923597 + 9)), -- f_8
                memory.read_int(memory.script_global(1923597 + 10)), -- f_9
            })
        end, nil, nil, COMMANDPERM_FRIENDLY)

        -------------------------------------
        -- Fix Blackscreen
        -------------------------------------         

        menu.action(friendly, "Fix Blackscreen", {""}, "Tries to fix a stuck Blackscreen for the selected Player.", function()
            local player = players.get_name(pid)
            menu.trigger_commands("givesh" .. player)
            menu.trigger_commands("aptme" .. player)
        end, nil, nil, COMMANDPERM_FRIENDLY)

        -------------------------------------
        -- Spectate
        -------------------------------------

        local spec = menu.ref_by_rel_path(menu.player_root(pid), "Spectate")
        stealth = menu.toggle(spec, "Bravo Six Method", {"bravo"}, "Bravo six, going dark.", function(toggled)
            if pid == players.user() then 
                util.toast(lang.get_localised(-1974706693)) 
                stealth.value = false
                util.stop_thread() 
            end
            if toggled then
                outgoingSyncs = menu.ref_by_rel_path(menu.player_root(pid), "Outgoing Syncs>Block")
                nuts = menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Nuts Method")
    
                outgoingSyncs.value = true
                util.yield(100)
                nuts.value = true
            else
                nuts.value = false
                outgoingSyncs.value = false
            end
        end)

        -------------------------------------
        -- GOD MODE
        -------------------------------------

        menu.toggle(mpvehicle, "God Mode", {"vgm"}, "Toggles Vehicle Godmode.", function(on)
            local vehicle = get_vehicle_player_is_in(pid)
            if ENTITY.DOES_ENTITY_EXIST(vehicle) and request_control(vehicle, 1000) then
                if on then
                    VEHICLE.SET_VEHICLE_ENVEFF_SCALE(vehicle, 0.0)
                    VEHICLE.SET_VEHICLE_BODY_HEALTH(vehicle, 1000.0)
                    VEHICLE.SET_VEHICLE_ENGINE_HEALTH(vehicle, 1000.0)
                    VEHICLE.SET_VEHICLE_FIXED(vehicle)
                    VEHICLE.SET_VEHICLE_DEFORMATION_FIXED(vehicle)
                    VEHICLE.SET_VEHICLE_PETROL_TANK_HEALTH(vehicle, 1000.0)
                    VEHICLE.SET_VEHICLE_DIRT_LEVEL(vehicle, 0.0)
                    for i = 0, 10 do 
                        VEHICLE.SET_VEHICLE_TYRE_FIXED(vehicle, i)
                    end
                end
                ENTITY.SET_ENTITY_INVINCIBLE(vehicle, on)
                ENTITY.SET_ENTITY_PROOFS(vehicle, on, on, on, on, on, on, true, on)
                VEHICLE.SET_DISABLE_VEHICLE_PETROL_TANK_DAMAGE(vehicle, on)
                VEHICLE.SET_DISABLE_VEHICLE_PETROL_TANK_FIRES(vehicle, on)
                VEHICLE.SET_VEHICLE_CAN_BE_VISIBLY_DAMAGED(vehicle, not on)
                VEHICLE.SET_VEHICLE_CAN_BREAK(vehicle, not on)
                VEHICLE.SET_VEHICLE_ENGINE_CAN_DEGRADE(vehicle, not on)
                VEHICLE.SET_VEHICLE_EXPLODES_ON_HIGH_EXPLOSION_DAMAGE(vehicle, not on)
                VEHICLE.SET_VEHICLE_TYRES_CAN_BURST(vehicle, not on)
                VEHICLE.SET_VEHICLE_WHEELS_CAN_BREAK(vehicle, not on)
            end
        end, nil, nil, COMMANDPERM_FRIENDLY)

        -------------------------------------
        -- Repair Vehicle
        -------------------------------------

        menu.action(mpvehicle, "Repair", {"rpv"}, "Repais the current Vehicle.", function()
            local vehicle = get_vehicle_player_is_in(pid)
            if ENTITY.DOES_ENTITY_EXIST(vehicle) and request_control(vehicle, 1000) then
                VEHICLE.SET_VEHICLE_FIXED(vehicle)
                VEHICLE.SET_VEHICLE_DEFORMATION_FIXED(vehicle)
                VEHICLE.SET_VEHICLE_DIRT_LEVEL(vehicle, 0.0)
            end
        end, nil, nil, COMMANDPERM_FRIENDLY)

        -------------------------------------
        -- Clean Vehicle
        -------------------------------------

        menu.action(mpvehicle, "Clean", {"cleanv"}, "Cleans the current Vehicle.", function()
            local vehicle = get_vehicle_player_is_in(pid)
            if ENTITY.DOES_ENTITY_EXIST(vehicle) and request_control(vehicle, 1000) then
                VEHICLE.SET_VEHICLE_DIRT_LEVEL(vehicle, 0.0)
            end
        end, nil, nil, COMMANDPERM_FRIENDLY)

        -------------------------------------
        -- Launch Player Vehicle
        -------------------------------------

        menu.action_slider(mpvehicle, "Launch Player Vehicle", {""}, "Launches the Player's Vehicle in the Selected direction.", launch_vehicle, function(index, value)
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
            if not PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
                notify("Player isn't in a vehicle. :/")
                return
            end
            while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(veh) do
                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh)
                wait()
            end
            if not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(veh) then
                notify("Failed to get control of the vehicle. :/")
                return
            end
            pluto_switch value do
                case "Launch Up":
                    ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 0.0, 100000.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                    break
                case "Launch Forward":
                    ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 100000.0, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                    break
                case "Launch Backwards":
                    ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, -100000.0, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                    break
                case "Launch Down":
                    ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 0.0, -100000.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                    break
                case "Slingshot":
                    ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 0.0, 100000.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                    ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 100000.0, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                    break
                end
        end)

    -------------------------------------
    -------------------------------------
    -- Trolling
    -------------------------------------
    -------------------------------------

        -------------------------------------
        -- Stealth Messages
        -------------------------------------

        menu.action(trolling, "Stealth msg", {"pm"}, "Sends a Stealth Message.", function(click_type)
            menu.show_command_box("pm" .. players.get_name(pid) .. " ")
            end, function(on_command)
                if #on_command > 140 then
                    notify("The message is to long.")
                else
                    chat.send_targeted_message(pid, players.user(), on_command, false)
                    chat.send_message(on_command, false, true, false)
                    log(players.get_name(players.user()).." [All] ".. on_command)
                    notify("Message has been send.")
                end
        end)

        menu.action(trolling, "Send To Online Intro", {"intro"}, "Sends player to the GTA Online intro.", function()
            local int = memory.read_int(memory.script_global(1894573 + 1 + (pid * 608) + 510))
            sendse(1 << pid, {-95341040, players.user(), 20, 0, 0, 48, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, int})
            sendse(1 << pid, {1742713914, players.user(), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
        end)
    
        menu.action(trolling, "Send To Golf", {"golf"}, "Sends player to go play golf.", function()
            local int = memory.read_int(memory.script_global(1894573 + 1 + (pid * 608) + 510))
            sendse(1 << pid, {-95341040, players.user(), 116, 0, 0, 48, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, int})
            sendse(1 << pid, {1742713914, players.user(), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
        end)
        
        menu.action(trolling, "Force 1v1", {"1v1"}, "Forces them into a 1v1.", function()
            local int = memory.read_int(memory.script_global(1894573 + 1 + (pid * 608) + 510))
            sendse(1 << pid, {-95341040, players.user(), 197, 0, 0, 48, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, int})
            sendse(1 << pid, {1742713914, players.user(), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
        end)

       menu.toggle_loop(trolling, "Clear Ped Tasks", {"pedfreeze"}, "Basic freeze method. Blocked by most menus.", function()
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
        end)

        -------------------------------------
        -- HOSTILE TRAFFIC
        -------------------------------------

        menu.toggle_loop(trolling, "Hostile Traffic", {""}, "Traffic will become Hostile to the Player.", function()
            if not is_player_active(pid, false, true) then
                return util.stop_thread()
            end
            local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            for _, vehicle in get_vehicles_in_player_range(pid, 70.0) do
                if TASK.GET_ACTIVE_VEHICLE_MISSION_TYPE(vehicle) ~= 6 then
                    local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
                    if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
                        request_control_once(driver)
                        PED.SET_PED_MAX_HEALTH(driver, 300)
                        ENTITY.SET_ENTITY_HEALTH(driver, 300, 0)
                        PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(driver, true)
                        TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, vehicle, targetPed, 6, 100.0, 0, 0.0, 0.0, true)
                    end
                end
            end
        end)

        -------------------------------------
        -- AUTOMATIC
        -------------------------------------

        local cagePos
        local timer <const> = newTimer()
        menu.toggle_loop(mpcage, "Automatic", {"autocage"}, "Automatically Cages the Player.", function()
            if not is_player_active(pid, false, true) then
                util.stop_thread()
            elseif not timer.isEnabled() or timer.elapsed() > 1000 then
                local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local playerPos = ENTITY.GET_ENTITY_COORDS(targetPed, false)
                if not cagePos or cagePos:distance(playerPos) >= 4.0 then
                    TASK.CLEAR_PED_TASKS_IMMEDIATELY(targetPed)
                    if PED.IS_PED_IN_ANY_VEHICLE(targetPed, false) then return end
                    cagePos = playerPos
                    trapcage(pid)
                    local playerName = get_condensed_player_name(pid)
                    if playerName ~= "**Invalid**" then
                        notification:normal("%s was out of the cage", HudColour.black, playerName)
                    end
                end
                timer.reset()
            end
        end)

        -------------------------------------
        -- Kill Player Inside Interior
        -------------------------------------

        menu.action(trolling, "Kill Player Inside Interior", {""}, "Works in casino and nightclubs.", function()
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local pos = ENTITY.GET_ENTITY_COORDS(ped)
            for _, id in interior_stuff do
                if get_interior_player_is_in(pid) == id then
                    util.toast("Player is not in any interior. :/")
                return end
                if get_interior_player_is_in(pid) ~= id then
                    sendse(1 << pid, {113023613, pid, 1771544554, math.random(0, 9999)})
                    util.yield(100)
                    MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, 1000, true, util.joaat("weapon_stungun"), players.user_ped(), false, true, 1.0)
                end
            end
        end)

        -------------------------------------
        -- Bounty Loop
        -------------------------------------

        menu.toggle_loop(trolling, "Bounty Loop", {"bloop"}, "Will set the players bounty always to 9000.", function(on)
            local bounty = players.get_bounty(pid)
            local player = players.get_name(pid)
            local interior = players.is_in_interior(pid)
            if not bounty and interior then
                trigger_commands("bounty "..player.." 9000")
                notify("Bounty set on: "..player)
                wait(10000)
            end
        end)

        -------------------------------------
        -- Remote TP's
        -------------------------------------

        for id, name in All_business_properties do
            if id <= 12 then
                menu.action(clubhouse, name, {"clubhouse"..name}, "", function()
                    sendse(1 << pid, {0xDEE5ED91, pid, id, 0x20, NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE(pid), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, math.random(1, 10)})
                end)
            elseif id > 12 and id <= 21 then
                menu.action(facility, name, {"facility"..name}, "", function()
                    sendse(1 << pid, {0xDEE5ED91, pid, id, 0x20, NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE(pid), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
                end)
            elseif id > 21 then
                menu.action(arcade, name, {"arcade"..name}, "", function() 
                    sendse(1 << pid, {0xDEE5ED91, pid, id, 0x20, NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE(pid), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1})
                end)
            end
        end

        for id, name in large_warehouses do
            menu.action(large, name, {"whtp"..name}, "Teleports the Player to the Warehouse.", function()
                sendse(1 << pid, {0x7EFC3716, pid, 0, 1, id})
            end)
        end

        menu.action(tp_player, "Heist Passed Apartment Teleport", {""}, "", function()
            sendse(1 << pid, {0xAD1762A7, players.user(), pid, -1, 1, 1, 0, 1, 0}) 
        end) 

        menu.action(cayop, "Cayo Perico (Cutscene)", {""}, "Sends the Player to Cayo Perico.", function()
            sendse(1 << pid, {0x4868BC31, pid, 0, 0, 0x3, 1})
        end)

        menu.action(cayop, "Cayo Perico (No Cutscene)", {"cayo"}, "Sends the Player to Cayo Perico without the cutscene.", function()
            sendse(1 << pid, {0x4868BC31, pid, 0, 0, 0x4, 1})
        end)

        menu.action(cayop, "Leaving Cayo Perico", {"cayoleave"}, "Player Must Be At Cayo Perico To Trigger This Event.", function()
            sendse(1 << pid, {0x4868BC31, pid, 0, 0, 0x3})
        end)

        menu.action(cayop, "Kicked From Cayo Perico", {"cayokick"}, "Sends them to the Beach.", function()
            sendse(1 << pid, {0x4868BC31, pid, 0, 0, 0x4, 0})
        end)

        -------------------------------------
        -- EXPLOSIONS
        -------------------------------------

        local usingExplosionLoop = false

        menu.action(customExplosion, "Explode", {""}, "", function()
            FIRE.ADD_EXPLOSION(players.get_position(pid), 1, 1.0, false, true, 0.0, false)
        end)

        menu.action(customExplosion, "Owned Explode", {""}, "", function()
            FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), players.get_position(pid), 1, 1.0, false, true, 0.0)
        end)

        menu.action(customExplosion, "Orbital Cannon", {"nuke"}, "", function()
            local becomeorb = menu.ref_by_path("Online>Become The Orbital Cannon")
            trigger_command(becomeorb, "on")
            wait(50)
            FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), players.get_position(pid), 59, 1.0, true, false, 0.0)
            wait(100)
            trigger_command(becomeorb, "off")
        end)
  
        menu.slider(customExplosion, "Loop Speed", {"expspeed"}, "", 50, 10000, 1000, 10, function(value)
            delay = value 
        end)

        menu.toggle(customExplosion, "Owned Explosion Loop", {""}, "", function(on)
            usingExplosionLoop = on
            while usingExplosionLoop and is_player_active(pid, false, true) and not util.is_session_transition_active() do
                FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), players.get_position(pid), 1, 1.0, false, true, 0.0)
                wait(delay)
            end
        end)

        menu.toggle(customExplosion, "Explosion Loop", {""}, "", function(on)
            usingExplosionLoop = on
            while usingExplosionLoop and is_player_active(pid, false, true) and not util.is_session_transition_active() do
                FIRE.ADD_EXPLOSION(players.get_position(pid), 1, 1.0, true, false, 0.0, false)
                wait(delay)
            end
        end)

        menu.action(customExplosion, "Blame Random Player", {""}, "Mister//ModzZ requested it, so I made it.", function()
            local pids = players.list(false, false, true) -- Gets every player in the lobby that isn't our friend
            local player = pids[math.random(#pids)] -- Selects a random player
            local killer = PLAYER.GET_PLAYER_PED(player) -- Gets the ped
            local victim = players.get_position(pid) -- Gets the Position of the Victim
            FIRE.ADD_OWNED_EXPLOSION(killer, victim, 1, 1.0, false, true, 0.0) -- Spawns Blamed Explosion
            notify("Player "..players.get_name(player).." was blamed for killing "..players.get_name(pid).."!") -- Notifies you of who killed who
        end)

        -------------------------------------
        -- KILL AS THE ORBITAL CANNON
        -------------------------------------

        menu.action(trolling, "Kill With Orbital Cannon", {"orb"}, "Kills the selected player with the Orbital Cannon.", function()
            if is_player_in_any_interior(pid) then
                notification:help("The player is in interior", HudColour.red)
            elseif is_player_passive(pid) then
                notification:help("The player is in passive mode", HudColour.red)
            elseif not OrbitalCannon.exists() and PLAYER.IS_PLAYER_PLAYING(pid) then
                OrbitalCannon.create(pid)
            end
        end)

        -------------------------------------
        -- Disable Passive
        -------------------------------------

        menu.action(trolling, "Disable Passive Mode", {"pussive"}, "Disables passive mode for the selected player.", function()
            wait(500)
            trigger_commands("bounty "..players.get_name(pid).." 1000")
            trigger_commands("givesh "..players.get_name(pid))
            wait(1000)
            trigger_commands("mission"..players.get_name(pid))
            wait(200)
            trigger_commands("givesh "..players.get_name(players.user()))
            wait(2000)
            notify("Passive mode should be dissabled now.")
            wait(15000)
        end, nil, nil, COMMANDPERM_RUDE)

        -------------------------------------
        -- Ghost to User
        -------------------------------------

        menu.toggle(trolling, "Ghost Player", {"ghost", "g"}, "Makes you ghosted to that player.", function(on)
            if on then
                NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, true)
            else
                NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, false)
            end
        end)

    -------------------------------------
    -------------------------------------
    -- Kicks & Crashes
    -------------------------------------
    -------------------------------------

        kick_root = menu.ref_by_rel_path(menu.player_root(pid), "Kick")
        menu.action(kick_root, "Rape", {"rape"}, "A Unblockable kick that won't tell the target or non-hosts who did it.", function()
            trigger_commands("breakup" .. players.get_name(pid))
        end, nil, nil, COMMANDPERM_RUDE)

        -------------------------------------
        -- Block Join Kick
        -------------------------------------

        local rids = players.get_rockstar_id(pid)
        menu.action(kicks, "Ban Block", {"EMP", "k"}, "Will kick and block the player from joining you ever again.", function()
            if players.get_name(pid) == players.get_name(players.user()) then
                notify(lang.get_localised(-1974706693))
            else
                wait(100)
                trigger_commands("historyblock" .. players.get_name(pid) .. " on")
                log("[Lena | Ban Block] Player "..players.get_name(pid).." ("..rids..") has been Kicked and Blocked.")
                if menu.get_edition() <= 2 then
                    --log(players.get_name(pid).." was detected cheating and has been removed from the session.")
                    wait(100)
                    trigger_commands("ban"..players.get_name(pid))
                else
                    trigger_commands("kick"..players.get_name(pid))
                end
            end
        end, nil, nil, COMMANDPERM_RUDE)

        menu.action(kicks, "Block Join", {"block"}, "Will kick and block the player from joining you ever again.", function()

            if players.get_name(pid) == players.get_name(players.user()) then
                notify(lang.get_localised(-1974706693))
            else
                wait(100)
                trigger_commands("historyblock" .. players.get_name(pid) .. " on")
                log("[Lena | Block Join] Player "..players.get_name(pid).." ("..rids..") has been Kicked and Blocked.")
                wait(100)
                if menu.get_edition() <= 2 then
                    trigger_commands("breakup"..players.get_name(pid))
                else
                    trigger_commands("kick"..players.get_name(pid))
                end
            end
        end, nil, nil, COMMANDPERM_RUDE)

        menu.action(kicks, "Blacklist", {"blacklist"}, "Will kick and block the player from joining you ever again.", function()
            if players.get_name(pid) == players.get_name(players.user()) then
                notify(lang.get_localised(-1974706693))
            else
                wait(100)
                trigger_commands("historyblock" .. players.get_name(pid) .. " on")
                log("[Lena | Blacklist] Player "..players.get_name(pid).." ("..rids..") has been Kicked and Blocked.")
                wait(100)
                trigger_commands("kick"..players.get_name(pid))
            end
        end, nil, nil, COMMANDPERM_RUDE)

        menu.action(kicks, "Rape", {"rape"}, "A Unblockable kick that won't tell the target or non-hosts who did it.", function()
            if players.get_name(pid) == players.get_name(players.user()) then
                notify(lang.get_localised(-1974706693))
            else
                if menu.get_edition() <= 2 then 
                    trigger_commands("breakup" .. players.get_name(pid))
                else
                    trigger_commands("kick"..players.get_name(pid))
                end
                log("[Lena | Rape] Player "..players.get_name(pid).." ("..rids..") has been Kicked.")
            end
        end, nil, nil, COMMANDPERM_RUDE)

        menu.action(kicks, "Stealth Host", {"stealth"}, "Works on legits and free menus.", function()
            if players.get_name(pid) == players.get_name(players.user()) then
                notify(lang.get_localised(-1974706693))
            else
                if menu.get_edition() <= 2 then
                    trigger_commands("buttplug" .. players.get_name(pid))
                else
                    trigger_commands("kick"..players.get_name(pid))
                end
                log("[Lena | Stealth Host] Player "..players.get_name(pid).." ("..rids..") has been Kicked.")
            end
        end)

        -------------------------------------
        -- Crashes
        -------------------------------------

        local rids = players.get_rockstar_id(pid)
        menu.action(crashes, "Block Join Crash", {"gtfo"}, "", function()
            if players.get_name(pid) == players.get_name(players.user()) then
                notify(lang.get_localised(-1974706693))
            else
                wait(500)
                trigger_commands("choke " .. players.get_name(pid))
                wait(500)
                trigger_commands("crash " .. players.get_name(pid))
                wait(500)
                log("[Lena | Crash] Player ".. players.get_name(pid) .." ("..rids..") has been Crashed and Blocked.")
                trigger_commands("historyblock" .. players.get_name(pid) .. " on")
            end
        end, nil, nil, COMMANDPERM_AGGRESSIVE)

        local nature = menu.list(crashes, "Parachute Crash", {}, "")
        menu.action(nature, "Version 1", {"V1"}, "", function()
            if players.get_name(pid) == players.get_name(players.user()) then
                notify(lang.get_localised(-1974706693))
            else
                local user = players.user()
                local user_ped = players.user_ped()
                local pos = players.get_position(user)
                BlockSyncs(pid, function() 
                    wait(100)
                    trigger_commands("invisibility on")
                    for i = 0, 110 do
                        PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(user, 0xFBF7D21F)
                        PED.SET_PED_COMPONENT_VARIATION(user_ped, 5, i, 0, 0)
                        wait(50)
                        PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(user)
                    end
                    wait(250)
                    for i = 1, 5 do
                        util.spoof_script("freemode", SYSTEM.wait) 
                    end
                    ENTITY.SET_ENTITY_HEALTH(user_ped, 0) 
                    NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(pos, 0, false, false, 0)
                    PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(user)
                    trigger_commands("invisibility off")
                end)
            end
        end)

        menu.action(nature, "Version 2", {"V2"}, "", function()
            if players.get_name(pid) == players.get_name(players.user()) then
                notify(lang.get_localised(-1974706693))
            else
                local user = players.user()
                local user_ped = players.user_ped()
                local pos = players.get_position(user)
                BlockSyncs(pid, function()
                    wait(100)
                    PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user(), 0xFBF7D21F)
                    WEAPON.GIVE_DELAYED_WEAPON_TO_PED(user_ped, 0xFBAB5776, 100, false)
                    TASK.TASK_PARACHUTE_TO_TARGET(user_ped, pos.x, pos.y, pos.z)
                    wait()
                    TASK.CLEAR_PED_TASKS_IMMEDIATELY(user_ped)
                    wait(250)
                    WEAPON.GIVE_DELAYED_WEAPON_TO_PED(user_ped, 0xFBAB5776, 100, false)
                    PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(user)
                    wait(1000)
                    for i = 1, 5 do
                        util.spoof_script("freemode", SYSTEM.wait)
                    end
                    ENTITY.SET_ENTITY_HEALTH(user_ped, 0)
                    NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(pos, 0, false, false, 0)
                end)
            end
        end, nil, nil, COMMANDPERM_RUDE)

        menu.action(crashes, "Fragment Crash", {""}, "2Shit1 Crash. Victim needs to look at it.", function()
            if players.get_name(pid) == players.get_name(players.user()) then
                notify(lang.get_localised(-1974706693))
            else
                BlockSyncs(pid, function()
                    local object = entities.create_object(joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
                    OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
                    wait(1000)
                    entities.delete_by_handle(object)
                end)
            end
        end)

        menu.action(crashes, "MK2 Griefer", {"grief"}, "Should work one some menus, idk. Don't crash players.", function()
            if players.get_name(pid) == players.get_name(players.user()) then
                notify(lang.get_localised(-1974706693))
            else
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local pos = players.get_position(pid)
                local mdl = joaat("u_m_m_jesus_01")
                local veh_mdl = joaat("oppressor")
                util.request_model(veh_mdl)
                util.request_model(mdl)
                    for i = 1, 10 do
                        if not players.exists(pid) then
                            return
                        end
                        local veh = entities.create_vehicle(veh_mdl, pos, 0)
                        local jesus = entities.create_ped(2, mdl, pos, 0)
                        PED.SET_PED_INTO_VEHICLE(jesus, veh, -1)
                        wait(100)
                        TASK.TASK_VEHICLE_HELI_PROTECT(jesus, veh, ped, 10.0, 0, 10, 0, 0)
                        wait(1000)
                        entities.delete_by_handle(jesus)
                        entities.delete_by_handle(veh)
                    end
                STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(mdl)
                STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(veh_mdl)
            end
        end)

        menu.action(crashes, "Invalid Animation", {"squish"}, "Blocked by some popular menus.", function()
            if players.get_name(pid) == players.get_name(players.user()) then
                notify(lang.get_localised(-1974706693))
            else
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local user = PLAYER.GET_PLAYER_PED(players.user())
                local pos = ENTITY.GET_ENTITY_COORDS(ped)
                local my_pos = ENTITY.GET_ENTITY_COORDS(user)
                local anim_dict = ("anim@mp_player_intupperstinker")
                request_animation(anim_dict)
                BlockSyncs(pid, function()
                    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(user, pos, false, false, false)
                    wait(100)
                    TASK.TASK_SWEEP_AIM_POSITION(user, anim_dict, "I", "Love", "You", -1, 0.0, 0.0, 0.0, 0.0, 0.0)
                    wait(100)
                end)
                TASK.CLEAR_PED_TASKS_IMMEDIATELY(user)
                ENTITY.SET_ENTITY_COORDS_NO_OFFSET(user, my_pos, false, false, false)
            end
        end)
--  end
end

local Jointimes = {}
local names = {}
local rids = {}
local rids2 = {}
local hostq = {}
local language = {}
local allplayers = {}
players.on_join(function(pid)
    names[pid] = players.get_name(pid)
    rids[pid] = players.get_rockstar_id(pid)
    hostq[pid] = players.get_host_queue_position(pid)
    allplayers[pid] = NETWORK.NETWORK_GET_NUM_CONNECTED_PLAYERS()
    language[pid] = ({'English','French','German','Italian','Spanish','Brazilian','Polish','Russian','Korean','Chinese (T)','Japanese','Mexican','Chinese (S)'})[players.get_language(pid) + 1]
    Jointimes[pid] = os.clock()

    if showJoinInfomsg then
        notify(names[pid].." has joined.\nSlot: "..pid.."\nRID/SCID: "..rids[pid])
    end
    if showJoinInfolog then
        log("[Lena | Join Reactions] "..names[pid].." (Slot: "..pid.." | Host Queue: #"..hostq[pid].." | Count: "..allplayers[pid].." | RID/SCID: "..rids[pid]..") is joining.")
    end
    if showJoinInfoteam then
        chat.send_message("> "..names[pid].." (Slot: "..pid.." | Host Queue: #"..hostq[pid].." | Count: "..allplayers[pid].." | RID/SCID: "..rids[pid]..") is joining.", true, true, true)
    end
    if showJoinInfoall then
        chat.send_message("> "..names[pid].." (Slot: "..pid.." | Host Queue: #"..hostq[pid].." | Count: "..allplayers[pid].." | RID/SCID: "..rids[pid]..") is joining.", false, true, true)
    end
end)

players.on_leave(function(pid)
    if showleaveInfomsg then
        notify(names[pid].." left.")
    end
    if showleaveInfolog then
        log("[Lena | Leave Reactions] "..names[pid].." left. (RID: "..rids[pid].." | Slot: "..allplayers[pid].." | Time in Session: "..math.floor(os.clock()-Jointimes[pid]+0.5).."s = "..math.floor((os.clock()-Jointimes[pid])/60).."m)")
    end
    if showleaveInfoteam then
        chat.send_message("> "..names[pid].." left. (RID: "..rids[pid].." | Slot: "..allplayers[pid].." | Time in Session: "..math.floor(os.clock()-Jointimes[pid]+0.5).."s = "..math.floor((os.clock()-Jointimes[pid])/60).."m)", true, true, true)
    end
    if showleaveInfoall then
        chat.send_message("> "..names[pid].." left. (RID: "..rids[pid].." | Slot: "..allplayers[pid].." | Time in Session: "..math.floor(os.clock()-Jointimes[pid]+0.5).."s = "..math.floor((os.clock()-Jointimes[pid])/60).."m)", false, true, true)
    end
    wait(10)
    Jointimes[pid] = nil
    names[pid] = nil
    rids[pid] = nil
    allplayers[pid] = nil
end)

function UnregisterNetworkObject(object, reason, force1, force2)
	local netObj = get_net_obj(object)
	if netObj == NULL then
		return false
	end
	local net_object_mgr = memory.read_long(CNetworkObjectMgr)
	if net_object_mgr == NULL then
		return false
	end
	util.call_foreign_function(UnregisterNetworkObject_addr, net_object_mgr, netObj, reason, force1, force2)
	return true
end

util.create_tick_handler(function()
    if was_in_transition and not util.is_session_transition_active() then
        on_transition_exit()
    end
    was_in_transition = util.is_session_transition_active()
end)

-------------------------------------
-------------------------------------
-- On-Stop
-------------------------------------
-------------------------------------

util.on_stop(function()
	set_streamed_texture_dict_as_no_longer_needed("lena")
    for pid, blip in orbital_blips do 
        util.remove_blip(blip)
    end
    if modifiedSpeed then modifiedSpeed:reset() end
end)

-------------------------------------
-- Functions
-------------------------------------

function memoryScan(name, pattern, callback)
	local address = memory.scan(pattern)
	assert(address ~= NULL, "memory scan failed: " .. name)
	callback(address)
end

memory_scan("GNGP", "48 83 EC ? 33 C0 38 05 ? ? ? ? 74 ? 83 F9", function(address)
	GetNetGamePlayer_addr = address
end)

memory_scan("NOM", "48 8B 0D ? ? ? ? 45 33 C0 E8 ? ? ? ? 33 FF 4C 8B F0", function(address)
	CNetworkObjectMgr = memory.rip(address + 3)
end)

function GetNetGamePlayer(player)
	return util.call_foreign_function(GetNetGamePlayer_addr, player)
end

function read_net_address(addr)
	local fields = {}
	for i = 3, 0, -1 do table.insert(fields, memory.read_ubyte(addr + i)) end
	return table.concat(fields, ".")
end

function get_external_ip(player)
	local netPlayer = GetNetGamePlayer(player)
	if netPlayer == NULL then
		return nil
	end
	local CPlayerInfo = memory.read_long(netPlayer + 0xA0)
	if CPlayerInfo == NULL then
		return nil
	end
	local netPlayerData = CPlayerInfo + 0x20
	local netAddress = read_net_address(netPlayerData + 0x4C)
	return netAddress
end

players.on_join(player)
players.dispatch_on_join()

while true do
    OrbitalCannon.mainLoop()
    wait_once()
end

util.keep_running()