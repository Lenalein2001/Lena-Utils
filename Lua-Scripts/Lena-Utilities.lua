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
local player_cur_car = entities.get_user_vehicle_as_handle()

-------------------------------------
-- Natives
-------------------------------------

util.require_natives("1663599444-uno")

-------------------------------------
-- Tabs
-------------------------------------

local self = menu.list(menu.my_root(), "Self", {""}, "")
local wep = menu.list(menu.my_root(), "Weapons", {""}, "")
local vehicle = menu.list(menu.my_root(), "Vehicle", {""}, "")
local online = menu.list(menu.my_root(), "Online", {""}, "")
local tunables = menu.list(menu.my_root(), "Tunables", {""}, "")
local misc = menu.list(menu.my_root(), "Misc", {""}, "")
--local script_settings = menu.list(menu.my_root(), "Settings", {""}, "")
local debug_features = menu.list(menu.my_root(), "[Debug]", {""}, "")

-------------------------------------
-- Sub Tabs
-------------------------------------

local anims = menu.list(self, "Animations", {""}, "")
local fast_stuff = menu.list(self, "Fast Stuff", {""}, "")
local lrf = menu.list(wep, "Legit Rapid Fire", {""}, "")
local better_vehicles = menu.list(vehicle, "Better Vehicles", {""}, "")
local detects_protex = menu.list(online, "Detections&Protections", {""}, "")
local detections = menu.list(detects_protex, "Detections", {""}, "")
local protex = menu.list(detects_protex, "Protections", {""}, "")
local anti_orb = menu.list(protex, "Anti Orb", {""}, "")
local menu_spoofer = menu.list(online, "Menu Spoofer", {""}, "SE's found by me. \nOnly assholes steal these.")
local friend_lists = menu.list(online, "Friend List", {""}, "You need to Restart the lua for it to update.")
local all_menu_users = menu.list(online, "Modders", {""}, "")
local shortcuts = menu.list(misc, "Shortcuts", {""}, "")
local clear_area_locally = menu.list(misc, "Clear Area", {""}, "")
local buzzard_spawn =menu.list(shortcuts, "Spawn Buzzard", {""}, "")
local multipliers = menu.list(tunables, "Multipliers", {""}, "")
local sell_stuff = menu.list(tunables, "Selling", {""}, "")
local business_shit = menu.list(tunables, "Business Stuff", {""}, "")
local missions_tunables = menu.list(tunables, "Missions", {""}, "")

-------------------------------------
-- Auto Update
-------------------------------------

local response = false
local script_version = 3.1
async_http.init('raw.githubusercontent.com','/Lenalein2001/Lena-Utils/main/Lua-Scripts/LenaUtilitiesVersion.txt', function (output)
    local remoteVersion = tonumber(output)
    response = true
    if script_version ~= remoteVersion then
        wait(50000)
        notify(scriptname .. " is outdated, and requires an update ... update will start itself in 3 seconds")
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
                notify(" " .. scriptname .. " has been updated successfully to version " .. remoteVersion .. 
                "\nScript will be restarted automatically")
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

local Functions = require "lena.functions" -- It is used extention, fuck of
local GuidedMissile = require "lena.guided_missile"
local HomingMissiles = require "lena.homing_missiles"
local OrbitalCannon = require "lena.orbital_cannon"
local llang = require 'lena/llang'
local lkey = require 'lena/lkey'
local scaleForm = require("ScaleformLib")
util.ensure_package_is_installed("ScaleformLib")
util.ensure_package_is_installed("pretty.json")
--require("SFuncs")

local scriptdir <const> = filesystem.scripts_dir()
for _, file in ipairs(required) do
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
local languageDir <const> = lenaDir .. "language\\"
local lconfigFile <const> = lenaDir .. "lconfig.ini"

if not filesystem.exists(lenaDir) then
	filesystem.mkdir(lenaDir)
end

if not filesystem.exists(languageDir) then
	filesystem.mkdir(languageDir)
end

if not filesystem.exists(lenaDir .. "profiles") then
	filesystem.mkdir(lenaDir .. "profiles")
end

if not filesystem.exists(lenaDir .. "handling") then
	filesystem.mkdir(lenaDir .. "handling")
end

if filesystem.exists(lconfigFile) then
	for s, tbl in pairs(Ini.load(lconfigFile)) do
		for k, v in pairs(tbl) do
			Config[s] = Config[s] or {}
			Config[s][k] = v
		end
	end
end

-----------------------------------
-- Keybinds
-----------------------------------

-- name = {"keybind; controller", index}
local Imputs <const> =
{
	INPUT_JUMP = {"Spacebar; X", 22},
	INPUT_VEH_ATTACK = {"Mouse L; RB", 69},
	INPUT_VEH_AIM = {"Mouse R; LB", 68},
	INPUT_VEH_DUCK = {"X; A", 73},
	INPUT_VEH_HORN = {"E; L3", 86},
	INPUT_VEH_CINEMATIC_UP_ONLY = {"Numpad +; none", 96},
	INPUT_VEH_CINEMATIC_DOWN_ONLY = {"Numpad -; none", 97}
}

local NULL <const> = 0
DecorFlag_isTrollyVehicle = 1 << 0
DecorFlag_isEnemyVehicle = 1 << 1
DecorFlag_isAttacker = 1 << 2
DecorFlag_isAngryPlane = 1 << 3

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
-- More Globals
----------------------------------- 

local gta_labels = require('all_labels')
local is_loading = true
local all_vehicles = {}
local all_objects = {}
local all_players = {}
local all_peds = {}
local all_pickups = {}
local vehicle_uses = 0
local ped_uses = 0
local pickup_uses = 0
local localplayer_uses = 0
local object_uses = 0
local robustmode = false
local spawned_objects = {}
local ladder_objects = {}

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

-----------------------------------
-- LABELS
-----------------------------------	

local customLabels <const> =
{
	EnterFileName = translate("Labels", "Enter the file name"),
	InvalidChar = translate("Labels", "Got an invalid character, try again"),
	EnterValue = translate("Labels", "Enter the value"),
	ValueMustBeNumber = translate("Labels", "The value must be a number, try again"),
	Search = translate("Labels" ,"Type the word to search"),
}

for key, text in pairs(customLabels) do
	customLabels[key] = util.register_label(text)
end

-------------------------------------
-- Lena's Functions
-------------------------------------

function IA_MENU_OPEN_OR_CLOSE()
    PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 244, 1.0)
    util.yield(150)
end
function IA_MENU_UP(Num)
    for i = 1, Num do
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 172, 1.0)
        util.yield(100)
    end
end
function IA_MENU_DOWN(Num)
    for i = 1, Num do
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 173, 1.0)
        util.yield(100)
    end
end
function IA_MENU_LEFT(Num)
    for i = 1, Num do
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 174, 1.0)
        util.yield(100)
    end
end
function IA_MENU_ENTER(Num)
    for i = 1, Num do
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 176, 1.0)
        util.yield(100)
    end
end

function GetLocalPed()
    return PLAYER.PLAYER_PED_ID()
end

function play_anim(dict, name, duration)
    ped = PLAYER.PLAYER_PED_ID()
    while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do
        STREAMING.REQUEST_ANIM_DICT(dict)
        wait()
    end
    TASK.TASK_PLAY_ANIM(ped, dict, name, 1.0, 1.0, duration, 3, 0.5, false, false, false)
    --TASK_PLAY_ANIM(Ped ped, char* animDictionary, char* animationName, float blendInSpeed, float blendOutSpeed, int duration, int flag, float playbackRate, BOOL lockX, BOOL lockY, BOOL lockZ)
end

function BitTest(bits, place)
	return (bits & (1 << place)) ~= 0
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

local function BitTest(bits, place)
    return (bits & (1 << place)) ~= 0
end

local function get_transition_state(pid)
    return memory.read_int(memory.script_global(((0x2908D3 + 1) + (pid * 0x1C5)) + 230))
end

local function IsPlayerUsingOrbitalCannon(player)
    return BitTest(memory.read_int(memory.script_global((2657589 + (player * 466 + 1) + 427))), 0) -- Global_2657589[PLAYER::PLAYER_ID() /*466*/].f_427), 0
end

local function IsPlayerFlyingAnyDrone(player)
   return BitTest(memory.read_int(memory.script_global(1853910 + (player * 862 + 1) + 267 + 365)), 26) -- Global_1853910[PLAYER::PLAYER_ID() /*862*/].f_267.f_365, 26
end

local function IsPlayerUsingGuidedMissile(player)
    return (memory.read_int(memory.script_global(2657589 + 1 + (player * 466) + 321 + 10)) ~= -1 and IsPlayerFlyingAnyDrone(player)) -- Global_2657589[PLAYER::PLAYER_ID() /*466*/].f_321.f_10 
end

local function IsPlayerInRcBandito(player)
    return BitTest(memory.read_int(memory.script_global(1853348 + (player * 834 + 1) + 267 + 348)), 29)  -- Global_1853348[PLAYER::PLAYER_ID() /*834*/].f_267.f_348, 29
end

local function IsPlayerInRcTank(player)
    return BitTest(memory.read_int(memory.script_global(1853348 + (player * 834 + 1) + 267 + 428 + 2)), 16) -- Global_1853910[PLAYER::PLAYER_ID() /*862*/].f_267.f_428.f_2
end

local function get_spawn_state(pid)
    return memory.read_int(memory.script_global(((2657589 + 1) + (pid * 466)) + 232)) -- Global_2657589[PLAYER::PLAYER_ID() /*466*/].f_232
end

local function get_interior_player_is_in(pid)
    return memory.read_int(memory.script_global(((2657589 + 1) + (pid * 466)) + 245)) -- Global_2657589[bVar0 /*466*/].f_245
end

local function is_player_in_interior(pid)
    return (memory.read_int(memory.script_global(2657589 + 1 + (pid * 466) + 245)) ~= 0)
end

local function IsPlayerInKosatka(player)
    return BitTest(memory.read_int(memory.script_global(1853910 + (player * 862 + 1 ) + 267 + 479)), 2) -- Global_1853910[PLAYER::PLAYER_ID() /*862*/].f_267.f_479, 2
end

local function IsInSession()
    return util.is_session_started() and not util.is_session_transition_active()
end

local function GetGlobalInt(address)
    return memory.read_int(memory.script_global(address))
end

local function GetGlobalFloat(address)
    return memory.read_float(memory.script_global(address))
end

local function SetGlobalInt(address, value)
    memory.write_int(memory.script_global(address), value)
end

local function SetLocalInt(script_str, script_local, value)
    local addr = memory.script_local(script_str, script_local)
    if addr ~= 0 then
        memory.write_int(addr, value)
    end
    return addr ~= 0
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

function GET_INT_LOCAL(Script, Local)
    if memory.script_local(Script, Local) ~= 0 then
        local Value = memory.read_int(memory.script_local(Script, Local))
        if Value ~= nil then
            return Value
        end
    end
end

local function getMPX()
    return 'MP'.. util.get_char_slot() ..'_'
end

local function STAT_GET_INT(Stat)
    STATS.STAT_GET_INT(util.joaat(getMPX() .. Stat), memory.alloc_int(), -1)
    return memory.read_int(memory.alloc_int())
end

local function GetLocalInt(script_str, script_local)
    local addr = memory.script_local(script_str, script_local)
    return addr ~= 0 and memory.read_int(addr) or nil
end

local function SetLocalBits(script_str, script_local, ...)
    local value = GetLocalInt(script_str, script_local)
    if value then
        return SetLocalInt(script_str, script_local, SetBits(value, ...))
    end
end

local function ClearLocalBits(script_str, script_local, ...)
    local value = GetLocalInt(script_str, script_local)
    if value then
        return SetLocalInt(script_str, script_local, ClearBits(value, ...))
    end
end

local function GetBusinessSuppliesFromStat(slot)
    return GetStatInt(prefix .. "MATTOTALFORFACTORY" .. slot)
end

local function GetBusinessProductFromStat(slot)
    return GetStatInt(prefix .. "PRODTOTALFORFACTORY" .. slot)
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

function STAT_SET_INT(Stat, Value)
    STATS.STAT_SET_INT(util.joaat(ADD_MP_INDEX(Stat)), Value, true)
end

function STAT_SET_INT(Stat, Value)
    STATS.STAT_SET_INT(util.joaat(ADD_MP_INDEX(Stat)), Value, true)
end
function STAT_SET_FLOAT(Stat, Value)
    STATS.STAT_SET_FLOAT(util.joaat(ADD_MP_INDEX(Stat)), Value, true)
end
function STAT_SET_BOOL(Stat, Value)
    STATS.STAT_SET_BOOL(util.joaat(ADD_MP_INDEX(Stat)), Value, true)
end
function STAT_SET_STRING(Stat, Value)
    STATS.STAT_SET_STRING(util.joaat(ADD_MP_INDEX(Stat)), Value, true)
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

function BitTest(bits, place)
	return (bits & (1 << place)) ~= 0
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

local function mod_uses(type, incr)
    if incr < 0 and is_loading then
        -- ignore if script is still loading
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

local function BlockSyncs(pid, callback)
    for _, i in ipairs(players.list(false, true, true)) do
        if i ~= pid then
            local outSync = menu.ref_by_rel_path(menu.player_root(i), "Outgoing Syncs>Block")
            trigger_command(outSync, "on")
        end
    end
    wait(10)
    callback()
    for _, i in ipairs(players.list(false, true, true)) do
        if i ~= pid then
            local outSync = menu.ref_by_rel_path(menu.player_root(i), "Outgoing Syncs>Block")
            trigger_command(outSync, "off")
        end
    end
end

-------------------------------------
-- Launch and Spectate 
-------------------------------------

local interior_stuff = {0, 233985, 169473, 169729, 169985, 170241, 177665, 177409, 185089, 184833, 184577, 163585, 167425, 167169}
local launch_vehicle = {"Launch Up", "Launch Forward", "Launch Backwards", "Launch Down", "Slingshot"}

local function is_entity_a_projectile(hash)
    local all_projectile_hashes = {
        util.joaat("w_ex_vehiclemissile_1"),
        util.joaat("w_ex_vehiclemissile_2"),
        util.joaat("w_ex_vehiclemissile_3"),
        util.joaat("w_ex_vehiclemissile_4"),
        util.joaat("w_ex_vehiclem,tar"),
        util.joaat("w_ex_apmine"),
        util.joaat("w_ex_arena_landmine_01b"),
        util.joaat("w_ex_birdshat"),
        util.joaat("w_ex_grenadefrag"),
        util.joaat("w_ex_grenadesmoke"),
        util.joaat("w_ex_molotov"),
        util.joaat("w_ex_pe"),
        util.joaat("w_ex_pipebomb"),
        util.joaat("w_ex_snowball"),
        util.joaat("w_lr_rpg_rocket"),
        util.joaat("w_lr_homing_rocket"),
        util.joaat("w_lr_firew,k_rocket"),
        util.joaat("xm_prop_x17_silo_rocket_01")
    }
    return table.contains(all_projectile_hashes, hash)
end

objects_thread = util.create_thread(function (thr)
    local projectile_blips = {}
    while true do
        for k,b in pairs(projectile_blips) do
            if HUD.GET_BLIP_INFO_ID_ENTITY_INDEX(b) == 0 then 
                util.remove_blip(b) 
                projectile_blips[k] = nil
            end
        end
        if object_uses > 0 then
            all_objects = entities.get_all_objects_as_pointers()
            for k, obj_ptr in pairs(all_objects) do
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
        util.yield()
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
            local ped_ptr = entities.handle_to_pointer(players.user_ped())
            local gwobaw = memory.script_global(2672505 + 1684 + 756) -- Global_2672505.f_1684.f_756
            if entities.get_health(ped_ptr) < 100 then
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

        menu.toggle_loop(fast_stuff, "Fast Vehicle Enter/Exit", {""}, "Enter vehicles faster.", function()
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
    -- Auto CEO
    -------------------------------------

    menu.toggle(self, "Auto start CEO", {""}, "", function(on)
        if players.get_boss(players.user()) == players.user() == false 
        then notify('CEO autostart is activated') trigger_commands('ceostart')  
            wait(2000) notify("Started, you are now your boss")
        elseif on and players.get_boss(players.user()) == players.user() == true 
        then wait(1000) notify("Not started, you are allready your CEO boss")
        elseif not on then notify("Auto Start deactivated")
        elseif on then notify("Auto Start activated")  
        end
    end)

    -------------------------------------
    -- Godmode
    -------------------------------------

    menu.toggle(self, "Godmode", {"gm"}, "", function(on_toggle)
        if on_toggle then 
            trigger_commands("godmode on")
            trigger_commands("vehgodmode on")
            trigger_commands("mint on")
        else
            trigger_commands("godmode off")
            trigger_commands("vehgodmode off")
            trigger_commands("mint off") 
        end
    end)

    -------------------------------------
    -- Friendly AI
    -------------------------------------

    menu.toggle_loop(self, "Friendly AI", {""}, "The AI will ignore you.", function()
        PED.SET_PED_RESET_FLAG(players.user_ped(), 124, true)
    end)

    -------------------------------------
    -- Auto Join CEO
    -------------------------------------

    local function player(pid)
        menu.toggle_loop(self, "Auto Join CEO", {""}, "", function()
            if players.get_boss(players.user()) == -1 and player.get_rockstar_id(pid) == 150742615 then 
                wait(50000)
                trigger_commands("ceojoin malwieder off")
                wait(1000)
                trigger_commands("ceojoin malwieder on")
                wait(5000)
            else
            end
        end)
    end
    -------------------------------------
    --[[ Script Host Addict
    -------------------------------------

    menu.toggle_loop(self, "Script Host", {""}, "Breaks Sessions badly.", function()
        if players.get_script_host() ~= players.user() and get_transition_state(players.user()) ~= 0 then
            menu.trigger_command(menu.ref_by_path("Players>"..players.get_name_with_tags(players.user())..">Friendly>Give Script Host"))
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

        menu.toggle(lrf, "Legit Rapid Fire", {""}, "", function(on)
            local localped = GetLocalPed()
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

        menu.slider(lrf, "Delay", {""}, "The delay that it takes to switch to grenade and back to the weapon.", 1, 1000, 100, 50, function (value)
            LegitRapidMS = value
        end)

    -------------------------------------
    -- BULLET SPEED MULT
    -------------------------------------

    ---@class AmmoSpeed
    local AmmoSpeed = {address = 0, defaultValue = 0}
    AmmoSpeed.__index = AmmoSpeed

    ---@param address integer
    ---@return AmmoSpeed
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

    ---@return number
    function AmmoSpeed:getValue()
        return memory.read_float(self.address)
    end

    ---@param value number
    function AmmoSpeed:setValue(value)
        memory.write_float(self.address, value)
    end

    function AmmoSpeed:reset()
        memory.write_float(self.address, self.defaultValue)
    end

    local multiplier
    ---@type AmmoSpeed
    local modifiedSpeed
    menu.slider_float(wep, translate("Weapon", "Bullet Speed Mult"), {""}, "Allows you to change the speed of non-instant hit bullets (rockets, fireworks, etc.)", 10, 100000, 100, 10, function(value)
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

    util.on_stop(function ()
        if modifiedSpeed then modifiedSpeed:reset() end
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

        menu.slider_float(better_vehicles, "Thrust", {"helithrust"}, "Set the heli thrust", 0, 1000, 220, 10, function (value)
            local CflyingHandling = get_sub_handling_types(entities.get_user_vehicle_as_handle(), 2) or get_sub_handling_types(entities.get_user_vehicle_as_handle(), 1)
            if CflyingHandling then
                memory.write_float(CflyingHandling + thrust_offset, value * 0.01)
            else
                notify("Failed\nget in a heli first")
            end
        end)

        menu.action(better_vehicles, "Better heli mode", {"betterheli"}, "Disabables heli auto stablization.", function ()
            local CflyingHandling = get_sub_handling_types(entities.get_user_vehicle_as_handle(), 2) or get_sub_handling_types(entities.get_user_vehicle_as_handle(), 1)
            if CflyingHandling then
                for _, offset in pairs(better_heli_handling_offsets) do
                    memory.write_float(CflyingHandling + offset, 0)
                end
                wait(500)
                trigger_commands("gravitymult 1")
                wait(500)
                trigger_commands("helithrust 2.3")
                trigger_commands("fovfpinveh 90")
                notify("Better Heli has been enabled.")
            else
                notify("This no heli dummy :p")
            end
        end)

        -------------------------------------
        -- Better Lazer
        -------------------------------------

        menu.divider(better_vehicles, "Better Lazer")
        local lazer_hash = util.joaat("lazer")
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
            trigger_commands("gravitymult 2")
            wait(500)
            trigger_commands("fovfpinveh -5")
            notify("Better Vehicles have been disabled.")
        end)

    -------------------------------------
    -- Clean vehicle
    -------------------------------------

    menu.action(vehicle, "Clean Vehicle", {"clv"}, "Cleans the current Vehicle", function()
    local PVehicle = entities.get_user_vehicle_as_handle(players.user())  
        VEHICLE.SET_VEHICLE_DIRT_LEVEL(PVehicle, 0.0)
    end)

    -------------------------------------
    -- Move To Seat
    -------------------------------------

    local seat_id = -1
    local moved_seat = menu.click_slider(vehicle, "Move To Seat", {}, "", 1, 1, 1, 1, function(seat_id)
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

    menu.toggle_loop(vehicle, "Drift Mode", {""}, "Hold shift to drift", function(on)
        if PAD.IS_CONTROL_PRESSED(1, 21) then
            VEHICLE.SET_VEHICLE_REDUCE_GRIP(player_cur_car, true)
            VEHICLE.SET_VEHICLE_REDUCE_GRIP_LEVEL(player_cur_car, 0.0)
        else
            VEHICLE.SET_VEHICLE_REDUCE_GRIP(player_cur_car, false)
        end
    end)

    -------------------------------------
    -- Spinning Tank turret ig
    -------------------------------------

    menu.toggle_loop(vehicle, "Tankcopter", {""}, "Makes you untouchable, but also unmovable.", function ()
        if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
            local veh = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
            VEHICLE.SET_VEHICLE_TANK_TURRET_POSITION(veh, math.random(-180, 180), true)
            wait(1)
        end
    end)

    -------------------------------------
    -- Force flares
    -------------------------------------

    menu.toggle_loop(vehicle, "Force flares", {""}, "", function(on)
        if PAD.IS_CONTROL_PRESSED(46, 46) then
            local target = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), math.random(-5, 5), -30.0, math.random(-5, 5))
        --  MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(target['x'], target['y'], target['z'], target['x'], target['y'], target['z'], 300.0, true, -1355376991, players.user_ped(), true, false, 100.0)
            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(target['x'], target['y'], target['z'], target['x'], target['y'], target['z'], 100.0, true, 1198879012, players.user_ped(), true, false, 100.0)
        end
    end)

    -------------------------------------
    -- VPC
    -------------------------------------

    menu.action(vehicle, "Control Passenger Weapons", {""}, "", function ()
        local CVehicleWeaponHandlingDataAddress = get_sub_handling_types(entities.get_user_vehicle_as_handle(), 9)

        if CVehicleWeaponHandlingDataAddress == 0 then util.toast("This vehicle does not have any weapons.") return end

        local WeaponSeats = CVehicleWeaponHandlingDataAddress + 0x0020
        local success, seat = get_seat_ped_is_in(PLAYER.PLAYER_PED_ID())

        if success then
            for i = 0, 4, 1 do
                memory.write_int(WeaponSeats + i * 4, seat + 1)
            end
            trigger_commands("repair")
        end
    end)



    menu.toggle_loop(vehicle, "Auto Performance", {"autoperf"}, "", function ()
        local localped = GetLocalPed()
        if PED.IS_PED_GETTING_INTO_A_VEHICLE(localped) then
            menu.trigger_commands("perf")
        end
    end)



    menu.action(vehicle, "Race Mode", {"racemode"}, "", function()
        trigger_commands("perf")
        trigger_commands("gravitymult 1")
        notify("Race mode has been enabled!")
    end)
    -------------------------------------
    -- DEBUG
    -------------------------------------

    menu.toggle_loop(debug_features, "Check if in vehicle", {""}, "", function()
        if PED.IS_PED_GETTING_INTO_A_VEHICLE(players.user_ped()) == true then
            notify("Entered a vehicle!")
        end
    end)

    local my_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
    menu.toggle(debug_features, "Vehicle name", {""}, "Doesn't work.", function()
        if PED.IS_PED_GETTING_INTO_A_VEHICLE(players.user_ped()) == true then
            Notify("" .. my_vehicle .. "is your current vehicle")
        end
    end)

        -------------------------------------
        -- VEHICLE HANDLING EDITOR
        -------------------------------------

        CHandlingData =
        {
            --{"m_model_hash", 0x0008},
            {"fMass", 0x000C},
            {"fInitialDragCoeff", 0x0010},
            {"fDownforceModifier", 0x0014},
            {"fPopUpLightRotation", 0x0018},
            {"vecCentreOfMassOffsetX", 0x0020},
            {"vecCentreOfMassOffsetY", 0x0024},
            {"vecCentreOfMassOffsetZ", 0x0028},
            {"vecInertiaMultiplierX", 0x0030},
            {"vecInertiaMultiplierY", 0x0034},
            {"vecInertiaMultiplierZ", 0x0038},
            {"fPercentSubmerged", 0x0040},
            {"fSubmergedRatio", 0x0044},
            {"fDriveBiasFront", 0x0048},
            {"fDriveBiasRear", 0x004C},
            {"fDriveInertia", 0x0054},
            {"fClutchChangeRateScaleUpShift", 0x0058},
            {"fClutchChangeRateScaleDownShift", 0x005C},
            {"fInitialDriveForce", 0x0060},
            {"fDriveMaxFlatVel", 0x0064},
            {"fInitialDriveMaxFlatVel", 0x0068},
            {"fBrakeForce", 0x006C},
            {"fBrakeBiasFront", 0x0074},
            {"fBrakeBiasRear", 0x0078},
            {"fHandBrakeForce", 0x007C},
            {"fSteeringLock", 0x0080},
            {"fSteeringLockRatio", 0x0084},
            {"fTractionCurveMax", 0x0088},
            {"fTractionCurveMaxRatio", 0x008C},
            {"fTractionCurveMin", 0x0090},
            {"fTractionCurveRatio", 0x0094},
            {"fTractionCurveLateral", 0x0098},
            {"fTractionCurveLateralRatio", 0x009C},
            {"fTractionSpringDeltaMax", 0x00A0},
            {"fTractionSpringDeltaMaxRatio", 0x00A4},
            {"fLowSpeedTractionLossMult", 0x00A8},
            {"fCamberStiffnesss", 0x00AC},
            {"fTractionBiasFront", 0x00B0},
            {"fTractionBiasRear", 0x00B4},
            {"fTractionLossMult", 0x00B8},
            {"fSuspensionForce", 0x00BC},
            {"fSuspensionCompDamp", 0x00C0},
            {"fSuspensionReboundDamp", 0x00C4},
            {"fSuspensionUpperLimit", 0x00C8},
            {"fSuspensionLowerLimit", 0x00CC},
            {"fSuspensionRaise", 0x00D0},
            {"fSuspensionBiasFront", 0x00D4},
            {"fSuspensionBiasRear", 0x00D8},
            {"fAntiRollBarForce", 0x00DC},
            {"fAntiRollBarBiasFront", 0x00E0},
            {"fAntiRollBarBiasRear", 0x00E4},
            {"fRollCentreHeightFront", 0x00E8},
            {"fRollCentreHeightRear", 0x00EC},
            {"fCollisionDamageMult", 0x00F0},
            {"fWeaponDamageMult", 0x00F4},
            {"fDeformationDamageMult", 0x00F8},
            {"fEngineDamageMult", 0x00FC},
            {"fPetrolTankVolume", 0x0100},
            {"fOilVolume", 0x0104},
            {"fSeatOffsetDistX", 0x010C},
            {"fSeatOffsetDistY", 0x0110},
            {"fSeatOffsetDistZ", 0x0114},
        }

        CFlyingHandlingData =
        {
            {"fThrust", 0x0008},
            {"fThrustFallOff", 0x000C},
            {"fThrustVectoring", 0x0010},
            {"fYawMult", 0x001C},
            {"fYawStabilise", 0x0020},
            {"fSideSlipMult", 0x0024},
            {"fRollMult", 0x002C},
            {"fRollStabilise", 0x0030},
            {"fPitchMult", 0x0038},
            {"fPitchStabilise", 0x003C},
            {"fFormLiftMult", 0x0044},
            {"fAttackLiftMult", 0x0048},
            {"fAttackDiveMult", 0x004C},
            {"fGearDownDragV", 0x0050},
            {"fGearDownLiftMult", 0x0054},
            {"fWindMult", 0x0058},
            {"fMoveRes", 0x005C},
            {"vecTurnResX", 0x0060},
            {"vecTurnResY", 0x0064},
            {"vecTurnResZ", 0x0068},
            {"vecSpeedResX", 0x0070},
            {"vecSpeedResY", 0x0074},
            {"vecSpeedResZ", 0x0078},
            {"fGearDoorFrontOpen", 0x0080},
            {"fGearDoorRearOpen", 0x0084},
            {"fGearDoorRearOpen2", 0x0088},
            {"fGearDoorRearMOpen", 0x008C},
            {"fTurbulanceMagnitudMax", 0x0090},
            {"fTurbulanceForceMulti", 0x0094},
            {"fTurbulanceRollTorqueMulti", 0x0098},
            {"fTurbulancePitchTorqueMulti", 0x009C},
            {"fBodyDamageControlEffectMult", 0x00A0},
            {"fInputSensitivityForDifficulty", 0x00A4},
            {"fOnGroundYawBoostSpeedPeak", 0x00A8},
            {"fOnGroundYawBoostSpeedCap", 0x00AC},
            {"fEngineOffGlideMult", 0x00B0},
            {"fAfterburnerEffectRadius", 0x00B4},
            {"fAfterburnerEffectDistance", 0x00B8},
            {"fAfterburnerEffectForceMulti", 0x00BC},
            {"fSubmergeLevelToPullHeliUnderWater", 0x00C0},
            {"fExtraLiftWithRoll", 0x00C4},
        }

        SubHandlingData =
        {
            CBikeHandlingData =
            {
                {"fLeanFwdCOMMult", 0x0008},
                {"fLeanFwdForceMult", 0x000C},
                {"fLeanBakCOMMult", 0x0010},
                {"fLeanBakForceMult", 0x0014},
                {"fMaxBankAngle", 0x0018},
                {"fFullAnimAngle", 0x001C},
                {"fDesLeanReturnFrac", 0x0024},
                {"fStickLeanMult", 0x0028},
                {"fBrakingStabilityMult", 0x002C},
                {"fInAirSteerMult", 0x0030},
                {"fWheelieBalancePoint", 0x0034},
                {"fStoppieBalancePoint", 0x0038},
                {"fWheelieSteerMult", 0x003C},
                {"fRearBalanceMult", 0x0040},
                {"fFrontBalanceMult", 0x0044},
                {"fBikeGroundSideFrictionMult", 0x0048},
                {"fBikeWheelGroundSideFrictionMult", 0x004C},
                {"fBikeOnStandLeanAngle", 0x0050},
                {"fBikeOnStandSteerAngle", 0x0054},
                {"fJumpForce", 0x0058},
            },
            CFlyingHandlingData = CFlyingHandlingData,
            CFlyingHandlingData2 = CFlyingHandlingData,
            CBoatHandlingData =
            {
                {"fBoxFrontMult", 0x0008},
                {"fBoxRearMult", 0x000C},
                {"fBoxSideMult", 0x0010},
                {"fSampleTop", 0x0014},
                {"fSampleBottom", 0x0018},
                {"fSampleBottomTestCorrection", 0x001C},
                {"fAquaplaneForce", 0x0020},
                {"fAquaplanePushWaterMult", 0x0024},
                {"fAquaplanePushWaterCap", 0x0028},
                {"fAquaplanePushWaterApply", 0x002C},
                {"fRudderForce", 0x0030},
                {"fRudderOffsetSubmerge", 0x0034},
                {"fRudderOffsetForce", 0x0038},
                {"fRudderOffsetForceZMult", 0x003C},
                {"fWaveAudioMult", 0x0040},
                {"vecMoveResistanceX", 0x0050},
                {"vecMoveResistanceY", 0x0054},
                {"vecMoveResistanceZ", 0x0058},
                {"vecTurnResistanceX", 0x0060},
                {"vecTurnResistanceY", 0x0064},
                {"vecTurnResistanceZ", 0x0068},
                {"fLook_L_R_CamHeight", 0x0070},
                {"fDragCoefficient", 0x0074},
                {"fKeelSphereSize", 0x0078},
                {"fPropRadius", 0x007C},
                {"fLowLodAngOffset", 0x0080},
                {"fLowLodDraughtOffset", 0x0084},
                {"fImpellerOffset", 0x0088},
                {"fImpellerForceMult", 0x008C},
                {"fDinghySphereBuoyConst", 0x0090},
                {"fProwRaiseMult", 0x0094},
                {"fDeepWaterSampleBuoyancyMult", 0x0098},
                {"fTransmissionMultiplier", 0x009C},
                {"fTractionMultiplier", 0x00A0},
            },
            CSeaPlaneHandlingData =
            {
                {"fPontoonBuoyConst", 0x0010},
                {"fPontoonSampleSizeFront", 0x0014},
                {"fPontoonSampleSizeMiddle", 0x0018},
                {"fPontoonSampleSizeRear", 0x001C},
                {"fPontoonLengthFractionForSamples", 0x0020},
                {"fPontoonDragCoefficient", 0x0024},
                {"fPontoonVerticalDampingCoefficientUp", 0x0028},
                {"fPontoonVerticalDampingCoefficientDown", 0x002C},
                {"fKeelSphereSize", 0x0030},
            },
            CSubmarineHandlingData =
            {
                {"vTurnResX", 0x0010},
                {"vTurnResY", 0x0014},
                {"vTurnResZ", 0x0018},
                {"fMoveResXY", 0x0020},
                {"fMoveResZ", 0x0024},
                {"fPitchMult", 0x0028},
                {"fPitchAngle", 0x002C},
                {"fYawMult", 0x0030},
                {"fDiveSpeed", 0x0034},
                {"fRollMult", 0x0038},
                {"fRollStab", 0x003C}
            },
            CTrainHandlingData =
            {
            },
            CTrailerHandlingData =
            {
            },
            CCarHandlingData =
            {
                {"fBackEndPopUpCarImpulseMult", 0x0008},
                {"fBackEndPopUpBuildingImpulseMult", 0x000C},
                {"fBackEndPopUpMaxDeltaSpeed", 0x0010},
                {"fToeFront", 0x0014},
                {"fToeRear", 0x0018},
                {"fCamberFront", 0x001C},
                {"fCamberRear", 0x0020},
                {"fCastor", 0x0024},
                {"fEngineResistance", 0x0028},
                {"fMaxDriveBiasTransfer", 0x002C},
                {"fJumpForceScale", 0x0030},
            },
            CVehicleWeaponHandlingData =
            {
                {"fUvAnimatiomMult", 0x0320},
                {"fMiscGadgetVar", 0x0324},
                {"fWheelImpactOffset", 0x0328}
            },
            CSpecialFlightHandlingData =
            {
                {"vecAngularDampingX", 0x0010},
                {"vecAngularDampingY", 0x0014},
                {"vecAngularDampingZ", 0x0018},
                {"vecAngularDampingMinX", 0x0020},
                {"vecAngularDampingMinY", 0x0024},
                {"vecAngularDampingMinZ", 0x0028},
                {"vecLinearDampingX", 0x0030},
                {"vecLinearDampingY", 0x0034},
                {"vecLinearDampingZ", 0x0038},
                {"vecLinearDampingMinX", 0x0040},
                {"vecLinearDampingMinY", 0x0044},
                {"vecLinearDampingMinZ", 0x0048},
                {"fLiftCoefficient", 0x0050},
                {"fMinLiftVelocity", 0x0060},
                {"fDragCoefficient", 0x006C},
                {"fRollTorqueScale", 0x0070},
                {"fYawTorqueScale", 0x007C},
                {"fMaxPitchTorque", 0x0088},
                {"fMaxSteeringRollTorque", 0x008C},
                {"fPitchTorqueScale", 0x0090},
                {"fMaxThrust", 0x0098},
                {"fTransitionDuration", 0x009C},
                {"fHoverVelocityScale", 0x00A0},
                {"fMinSpeedForThrustFalloff", 0x00A8},
                {"fBrakingThrustScale", 0x00AC},
            },
        }

        -------------------------------------
        -- HANDLING SECTION
        -------------------------------------

        local subHandlingClasses =
        {
            [0]  = "CBikeHandlingData",
            [1]  = "CFlyingHandlingData",
            [2]  = "CFlyingHandlingData2",
            [3]  = "CBoatHandlingData",
            [4]  = "CSeaPlaneHandlingData",
            [5]  = "CSubmarineHandlingData",
            [6]  = "CTrainHandlingData",
            [7]  = "CTrailerHandlingData",
            [8]  = "CCarHandlingData",
            [9]  = "CVehicleWeaponHandlingData",
            [10] = "CSpecialFlightHandlingData",
        }


        ---@param subHandling integer
        ---@return integer
        local function get_sub_handling_type(subHandling)
            local funAddress = memory.read_long(memory.read_long(subHandling) + 16)
            return util.call_foreign_function(funAddress, subHandling)
        end


        ---@param handlingData integer
        ---@return {type: integer, address: integer}[]
        local function get_sub_handling_array(handlingData)
            local subHandlingArray = memory.read_long(handlingData + 0x158)
            local numSubHandling = memory.read_ushort(handlingData + 0x160)
            local arr = {}
            local index = 0
            local t = -1

            while true do
                local subHandling = memory.read_long(subHandlingArray + index * 8)
                if subHandling == NULL then
                    goto NotFound
                end

                t = get_sub_handling_type(subHandling)
                if t >= 0 and t <= 10 then
                    table.insert(arr, {type = t, address = subHandling})
                end

            ::NotFound::
                index = index + 1
                if index >= numSubHandling then break end
            end

            return arr
        end

        local GetVehicleModelInfo = 0
        memory_scan("GVMI", "48 89 5C 24 ? 57 48 83 EC 20 8B 8A ? ? ? ? 48 8B DA", function (address)
            GetVehicleModelInfo = memory.rip(address + 0x2A)
        end)


        local GetHandlingDataFromIndex = 0
        memory_scan("GHDFI", "40 53 48 83 EC 30 48 8D 54 24 ? 0F 29 74 24 ?", function (address)
            GetHandlingDataFromIndex = memory.rip(address + 0x37)
        end)

        ---@param modelHash Hash
        ---@return integer CVehicleModelInfo*
        local function get_vehicle_model_info(modelHash)
            return util.call_foreign_function(GetVehicleModelInfo, modelHash, NULL)
        end

        ---@param modelInfo integer CVehicleModelInfo*
        ---@return integer CHandlingData*
        local function get_vehicle_model_handling_data(modelInfo)
            return util.call_foreign_function(GetHandlingDataFromIndex, memory.read_uint(modelInfo + 0x4B8))
        end

        -------------------------------------
        -- HANDLING DATA
        -------------------------------------

        ---@class HandlingData
        HandlingData =
        {
            reference = 0,
            name = "",
            address = NULL,
            visible = true,
            offsets = {},
            open = false,
        }
        HandlingData.__index = HandlingData

        ---@param parent integer
        ---@param name string
        ---@param address integer
        ---@param offsets {[1]:string, [2]:integer}[]
        ---@return HandlingData
        HandlingData.new = function (parent, name, address, offsets)
            local self = setmetatable({address = address, name = name, offsets = offsets}, HandlingData)
            self.reference = menu.list(parent, name, {}, "", function()
                self.open = true
            end, function()
                self.open = false
            end)

            menu.divider(self.reference, name)
            for _, tbl in ipairs(offsets) do self:addOption(self.reference, tbl[1], tbl[2]) end
            return self
        end

        ---@param self HandlingData
        ---@param parent integer
        ---@param name string
        ---@param offset integer
        HandlingData.addOption = function(self, parent, name, offset)
            local value = memory.read_float(self.address + offset) * 100

            menu.slider_float(parent, name, {name}, "", -1e6, 1e6, math.floor(value), 10, function(new)
                memory.write_float(self.address + offset, new / 100)
            end)
        end

        HandlingData.Remove = function(self)
            menu.delete(self.reference)
        end

        function HandlingData:get()
            local r = {}

            for _, tbl in ipairs(self.offsets) do
                local value = memory.read_float(self.address + tbl[2])
                r[tbl[1]] = round(value, 3)
            end

            return r
        end

        function HandlingData:set(values)
            local count = 0

            for _, tbl in ipairs(self.offsets) do
                local value = values[tbl[1]]

                if not value then
                    goto label_continue
                end

                memory.write_float(self.address + tbl[2], value)
                count = count + 1

            ::label_continue::
            end
        end

        -------------------------------------
        -- HANDLING EDITOR
        -------------------------------------

        ---@class VehicleList
        VehicleList = {selected = 0, root = 0, name = "", onClick = nil}
        VehicleList.__index = VehicleList

        ---@param parent integer
        ---@param name string
        ---@param onClick fun(vehicle: Hash)?
        ---@return VehicleList
        function VehicleList.new(parent, name, onClick)
            local self = setmetatable({name = name, onClick = onClick}, VehicleList)
            self.root = menu.list(parent, name, {}, "")

            local classLists = {}
            for _, vehicle in ipairs(util.get_vehicles()) do
                local nameHash = util.joaat(vehicle.name)
                local class = VEHICLE.GET_VEHICLE_CLASS_FROM_NAME(nameHash)

                if not classLists[class] then
                    classLists[class] = menu.list(self.root, util.get_label_text("VEH_CLASS_" .. class), {}, "")
                end

                local menuName = util.get_label_text(vehicle.name)
                if menuName == "NULL" then
                    goto label_coninue
                end

                menu.action(classLists[class], util.get_label_text(vehicle.name), {}, "", function()
                    self:setSelected(nameHash, vehicle.name)
                    menu.focus(self.root)
                end)
            ::label_coninue::
            end

            return self
        end

        ---@param nameHash Hash
        ---@param vehicleName string?
        function VehicleList:setSelected(nameHash, vehicleName)
            if not vehicleName then
                vehicleName = VEHICLE.GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(nameHash)
            end
            menu.set_menu_name(self.root, self.name .. ": " .. util.get_label_text(vehicleName))
            self.selected = nameHash
            if self.onClick then self.onClick(nameHash) end
        end

        -------------------------------------
        -- FILE LIST
        -------------------------------------

        ---@class FileList
        FileList = {
            dir = "",
            ext = "json",
            open = false,
            reference = 0,
            options = {},
            fileOpts = {},
            onClick = nil
        }
        FileList.__index = FileList

        ---@param parent integer
        ---@param name string
        ---@param options table
        ---@param dir string
        ---@param ext string
        ---@param onClick fun(opt: integer, fileName: string, path: string)
        ---@return FileList
        function FileList.new(parent, name, options, dir, ext, onClick)
            local self = setmetatable({dir = dir, ext = ext, options = options}, FileList)
            self.fileOpts = {}
            self.onClick = onClick

            self.reference = menu.list(parent, name, {}, "", function()
                self.open = true
                self:load()
            end, function()
                self.open = false
                self:clear()
            end)

            return self
        end

        function FileList:load()
            if not self.dir or not filesystem.exists(self.dir) then
                return
            end

            for _, path in ipairs(filesystem.list_files(self.dir)) do
                local name, ext = string.match(path, '^.+\\(.+)%.(.+)$')
                if not self.ext or self.ext == ext then self:createOpt(name, path) end
            end
        end

        ---@param fileName string
        ---@param path string
        function FileList:createOpt(fileName, path)
            local list = menu.list(self.reference, fileName, {}, "")

            for i, opt in ipairs(self.options) do
                menu.action(list, opt, {}, "", function() self.onClick(i, fileName, path) end)
            end

            self.fileOpts[#self.fileOpts+1] = list
        end

        function FileList:clear()
            if #self.fileOpts == 0 then
                return
            end

            for i, ref in ipairs(self.fileOpts) do
                menu.delete(ref); self.fileOpts[i] = nil
            end
        end

        ---@param file string #Must include file extension.
        ---@param content string
        function FileList:add(file, content)
            assert(self.dir ~= "", "tried to add a file to a null directory")
            if not filesystem.exists(self.dir) then
                filesystem.mkdir(self.dir)
            end

            local name, ext = string.match(file, '^(.+)%.(.+)$')
            local count = 1

            while filesystem.exists(self.dir .. file) do
                count = count + 1
                file = string.format("%s (%s).%s", name, count, ext)
            end

            local file <close> = assert(io.open(self.dir .. file, "w"))
            file:write(content)
        end

        function FileList:reload()
            self:clear()
            self:load()
        end

        -------------------------------------
        -- AUTOLOAD LIST
        -------------------------------------

        local handlingTrans <const> =
        {
            SetVehicle = translate("Handling Editor", "Set Vehicle"),
            CurrentVehicle = translate("Handling Editor", "Current Vehicle"),
            SaveHandling = translate("Handling Editor", "Save Handling Data"),
            SavedFiles = translate("Handling Editor", "Saved Files"),
            Load = translate("Handling Editor", "Load"),
            Delete = translate("Handling Editor", "Delete"),
            Autoload = translate("Handling Editor", "Autoload"),
            Saved = translate("Handling Editor", "Handling file saved"),
            Loaded = translate("Handling Editor", "Handling file successfully loaded"),
            WillAutoload = translate("Handling Editor", "File '%s' will be autoloaded"),
            HandlingEditor = translate("Handling Editor", "Handling Editor"),
            AutoloadedFiles = translate("Handling Editor", "Autoloaded Files"),
            ClickToDelete = translate("Handling Editor", "Click to delete"),
            SavedHelp = translate("Handling Editor", "Saved handling files for the selected vehicle model")
        }

        ---@class AutoloadList
        AutoloadList = {reference = 0, options = {}}
        AutoloadList.__index = AutoloadList

        ---@param parent integer
        ---@param name string
        ---@return AutoloadList
        function AutoloadList.new(parent, name)
            local self = setmetatable({options = {}}, AutoloadList)

            self.reference = menu.list(parent, name, {}, "")
            return self
        end

        ---@param vehLabel string
        ---@param file string
        function AutoloadList:push(vehLabel, file)
            local vehName = util.get_label_text(vehLabel)

            if self.options[vehName] then
                menu.delete(self.options[vehName])
            end

            self.options[vehName] = menu.action(self.reference, string.format("%s: %s", vehName, file), {}, handlingTrans.ClickToDelete, function()
                Config.handlingAutoload[vehLabel] = nil
                menu.delete(self.options[vehName])
            end)
        end

        -------------------------------------
        -- HANDLING EDITOR
        -------------------------------------

        ---@class HandlingData
        HandlingEditor =
        {
            references = {root = 0, meta = 0},
            handlingData = nil,
            subHandlings = {},
            currentVehicle = 0,
            open = false,
            ---@type FileList
            filesList = nil,
            ---@type AutoloadList
            autoloads = nil
        }
        HandlingEditor.__index = HandlingEditor

        ---@param parent integer
        ---@param name string
        ---@return HandlingData
        function HandlingEditor.new(parent, name)
            local self = setmetatable({subHandlings = {}, references = {}}, HandlingEditor)
            self.references.root = menu.list(parent, name, {}, "", function()
                self.open = true
            end, function() self.open = false end)

            local vehList = VehicleList.new(self.references.root, handlingTrans.SetVehicle, function (vehicle)
                self:SetCurrentVehicle(vehicle)
            end)

            menu.action(self.references.root, handlingTrans.CurrentVehicle, {}, "", function ()
                local vehicle = entities.get_user_vehicle_as_handle()
                if vehicle ~= 0 then vehList:setSelected(ENTITY.GET_ENTITY_MODEL(vehicle)) end
            end)

            self.references.meta = menu.list(self.references.root, "Meta", {}, "")

            menu.action(self.references.meta, handlingTrans.SaveHandling, {}, "", function()
                local ok, msg = self:save()
                if not ok then
                    return notification:help(capitalize(msg), HudColour.red)
                end
                notification:normal(handlingTrans.Saved, HudColour.purpleDark)
            end)

            local fileOpts <const> =
            {
                handlingTrans.Load,
                handlingTrans.Autoload,
                handlingTrans.Delete,
            }

            self.filesList = FileList.new(self.references.meta, handlingTrans.SavedFiles, fileOpts, "", "json", function (opt, fileName, path)
                if  opt == 1 then
                    local ok, msg = self:load(path)
                    if not ok then
                        return notification:help(capitalize(msg), HudColour.red)
                    end
                    self:SetCurrentVehicle(self.currentVehicle) -- reloading
                    notification:normal(handlingTrans.Loaded, HudColour.purpleDark)

                elseif opt == 3 then
                    os.remove(path)
                    self.filesList:reload()

                elseif opt == 2 then
                    local name = VEHICLE.GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(self.currentVehicle)
                    if name == "CARNOTFOUND" then
                        return
                    end
                    Config.handlingAutoload[name] = fileName
                    self.autoloads:push(name, fileName)
                    notification:normal(string.format(handlingTrans.WillAutoload, fileName), HudColour.purpleDark)
                end
            end)

            menu.set_help_text(self.filesList.reference, handlingTrans.SavedHelp)
            self.autoloads = AutoloadList.new(self.references.meta, handlingTrans.AutoloadedFiles)
            return self
        end

        ---@param hash Hash
        function HandlingEditor:SetCurrentVehicle(hash)
            if self.handlingData then self:clear() end
            self.currentVehicle = hash
            local root = self.references.root
            local modelInfo = get_vehicle_model_info(hash)
            if modelInfo == NULL then
                return
            end

            local handlingAddress = get_vehicle_model_handling_data(modelInfo)
            if handlingAddress == NULL then
                return
            end

            self.handlingData = HandlingData.new(root, "CHandlingData", handlingAddress, CHandlingData)
            local subHandlings = get_sub_handling_array(handlingAddress)

            for _, subHandling in ipairs(subHandlings) do
                if subHandling.address == NULL then
                    continue
                end
                local name = subHandlingClasses[subHandling.type]
                local offsets = SubHandlingData[name]
                if not self.subHandlings[name] then self.subHandlings[name] = HandlingData.new(root, name, subHandling.address, offsets) end
            end

            local vehicleName = memory.read_string(modelInfo + 0x298)
            self.filesList.dir = lenaDir .. "handling\\" .. string.lower(vehicleName) .. "\\"
        end

        function HandlingEditor:clear()
            self.handlingData:Remove()
            for _, h in pairs(self.subHandlings) do h:Remove() end

            self.handlingData = nil
            self.subHandlings = {}
            self.currentVehicle = 0
            self.filesList.dir = ""
        end

        ---@return boolean
        ---@return string? errmsg
        function HandlingEditor:save()
            if not self.handlingData then
                return false, "handling data not found"
            end

            local input = ""
            local label = customLabels.EnterFileName

            while true do
                input = get_input_from_screen_keyboard(label, 31, "")
                if input == "" then
                    return false, "save canceled"
                end
                if not input:find '[^%w_%.%-]' then break end
                label = customLabels.InvalidChar
                wait(200)
            end

            local data = {}
            data[self.handlingData.name] = self.handlingData:get()

            for _, subHandling in pairs(self.subHandlings) do
                data[subHandling.name] = subHandling:get()
            end

            self.filesList:add(input .. ".json", json.stringify(data, nil, 4))
            return true, nil
        end

        ---@param path string
        ---@return boolean
        ---@return string? errmsg
        function HandlingEditor:load(path)
            if not self.handlingData then
                return false, "handling data not found"
            end

            if not filesystem.exists(path) then
                return false, "file does not exist"
            end

            local ok, result = json.parse(path, false)
            if not ok then
                return false, result
            end

            self.handlingData:set(result.CHandlingData)

            for name, subHandling in pairs(self.subHandlings) do
                if result[name] then subHandling:set(result[name]) end
            end

            return true, nil
        end

        ---@return integer
        function HandlingEditor:autoload()
            local count = 0

            for vehicle, file in pairs(Config.handlingAutoload) do
                local path =  lenaDir .. "handling\\" .. string.lower(vehicle) .. "\\" .. file .. ".json"
                local modelHash = util.joaat(vehicle)

                self:SetCurrentVehicle(modelHash)
                if  self:load(path) then
                    self.autoloads:push(vehicle, file)
                    count = count + 1
                end
            end

            if self.handlingData then self:clear() end
            return count
        end

        g_handlingEditor = HandlingEditor.new(vehicle, handlingTrans.HandlingEditor)

        local numFilesLoaded = g_handlingEditor:autoload()

-------------------------------------
-------------------------------------
-- Online
-------------------------------------
-------------------------------------

    -------------------------------------
    -- Session
    -------------------------------------

        --

    -------------------------------------
    -- Detections
    -------------------------------------

        -------------------------------------
        -- Detect Rockets
        -------------------------------------

        blip_projectiles = false
        menu.toggle(detections, "Detect Rockets", {""}, "", function(on)
            blip_projectiles = on
            mod_uses("object", if on then 1 else -1)
        end)

        -------------------------------------
        -- SUID
        -------------------------------------

        local stand_UID = menu.ref_by_path("Online>Protections>Detections>Stand User Identification")

        menu.toggle(detections, "Stand User ID", {"suid"}, "", function(on)
            if on then
                trigger_command(stand_UID, "on")
            else
                trigger_command(stand_UID, "off")
            end
        end, true)

        -------------------------------------
        -- Super Drive
        -------------------------------------

        menu.toggle_loop(detections, "Super Drive", {""}, "", function()
            for _, pid in ipairs(players.list(false, true, true)) do
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local vehicle = PED.GET_VEHICLE_PED_IS_USING(ped)
                local veh_speed = (ENTITY.GET_ENTITY_SPEED(vehicle)* 2.236936)
                local class = VEHICLE.GET_VEHICLE_CLASS(vehicle)
                if class ~= 15 and class ~= 16 and veh_speed >= 180 and VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1) and players.get_vehicle_model(pid) ~= util.joaat("oppressor") then -- not checking opressor mk1 cus its stinky
                    notify(players.get_name(pid) .. " Is Using Super Drive")
                    break
                end
            end
        end)

        -------------------------------------
        -- Spectate
        -------------------------------------

        menu.toggle_loop(detections, "Spectate", {""}, "Detects if someone is spectating you.", function()
            for _, pid in ipairs(players.list(false, true, true)) do
                for i, interior in ipairs(interior_stuff) do
                    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                    if not util.is_session_transition_active() and get_transition_state(pid) ~= 0 and get_interior_player_is_in(pid) == interior
                    and not NETWORK.NETWORK_IS_PLAYER_FADING(pid) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_DEAD_OR_DYING(ped) then
                        if v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_cam_pos(pid)) < 15.0 and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), players.get_position(pid)) > 20.0 then
                            notify(players.get_name(pid) .. " Is Watching You")
                            break
                        end
                    end
                end
            end
        end)

        -------------------------------------
        -- Teleport
        -------------------------------------

        menu.toggle_loop(detections, "Teleport", {""}, "Detects if the player has teleported", function()
            for _, pid in ipairs(players.list(false, true, true)) do
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                if not NETWORK.NETWORK_IS_PLAYER_FADING(pid) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_DEAD_OR_DYING(ped) then
                    local oldpos = players.get_position(pid)
                    wait(1000)
                    local currentpos = players.get_position(pid)
                    if get_transition_state(pid) ~= 0 then
                        for i, interior in ipairs(interior_stuff) do
                            if v3.distance(oldpos, currentpos) > 500 and oldpos.x ~= currentpos.x and oldpos.y ~= currentpos.y and oldpos.z ~= currentpos.z then
                                wait(500)
                                if get_interior_player_is_in(pid) == interior and PLAYER.IS_PLAYER_PLAYING(pid) and players.exists(pid) then
                                    notify(players.get_name(pid) .. " Just teleported")
                                end
                            end
                        end
                    end
                end
            end
        end)

        -------------------------------------
        -- Modded Animation
        -------------------------------------    

        menu.toggle_loop(detections, "Modded Animation", {""}, "", function()
            for _, pid in ipairs(players.list(false, true, true)) do
                local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                if PED.IS_PED_USING_ANY_SCENARIO(player) then
                    notify(PLAYER.GET_PLAYER_NAME(pid) .. " Is In A Modded Scenario")
                end
            end 
        end)

        -------------------------------------
        -- Drones & Missiles
        -------------------------------------

        local trans =
        {
            FlyingDrone = translate("Protections", "%s is flying a drone"),
            LaunchedMissile = translate("Protections", "%s is using a guided missile"),
            NearDrone = translate("Protections", "%s's drone is ~r~nearby~s~"),
            NearMissile = translate("Protections", "%s's guided missile is ~r~nearby~s~"),
        }
        local notificationBits = 0
        local nearbyNotificationBits = 0
        local blips = {}
        local help =

        ---@param player Player
        ---@return boolean
        local function isPlayerFlyingAnyDrone(player)
            local address = memory.script_global(1853910 + (player * 862 + 1) + 267 + 365)
            return BitTest(memory.read_int(address), 26)
        end

        ---@param player Player
        ---@return integer
        local function getDroneType(player)
            local p_type = memory.script_global(1914091 + (player * 297 + 1) + 97)
            return memory.read_int(p_type)
        end

        ---@param player Player
        ---@return Object
        local function getPlayerDroneObject(player)
            local p_object = memory.script_global(1914091 + (players.user() * 297 + 1) + 64 + (player + 1))
            return memory.read_int(p_object)
        end

        ---@param heading number
        ---@return number
        local function invertHeading(heading)
            if heading > 180.0 then
                return heading - 180.0
            end
            return heading + 180.0
        end

        ---@param droneType integer
        ---@return integer
        local function getDroneBlipSprite(droneType)
            return (droneType == 8 or droneType == 4) and 548 or 627
        end

        ---@param droneType integer
        ---@return string
        local function getNotificationMsg(droneType, nearby)
            if droneType == 8 or droneType == 4 then
                return nearby and trans.NearMissile or trans.LaunchedMissile
            end
            return nearby and trans.NearDrone or trans.FlyingDrone
        end

        ---@param index integer
        local function removeBlipIndex(index)
            if HUD.DOES_BLIP_EXIST(blips[index]) then
                util.remove_blip(blips[index]); blips[index] = 0
            end
        end

        ---@param player Player
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

        menu.toggle_loop(detections, "Missile and Drone Detection", {""}, "Drone/Missile Detection", function()
            if NETWORK.NETWORK_IS_SESSION_ACTIVE() then
                for player = 0, 32 do addBlipForPlayerDrone(player) end
            end
        end, function()
            for i in pairs(blips) do removeBlipIndex(i) end
            notificationBits = 0
            nearbyNotificationBits = 0
        end)

        -------------------------------------
        -- Stat Detection
        -------------------------------------

        local isLegit = {}
        local mightNotBeLegit = {}
        menu.toggle_loop(detections, "Detect Unlegit Stats", {""}, "Permanently lets your menu scan for not legit players", function ()
            for pid = 0,31 do
                local rank = players.get_rank(pid)
                local money = players.get_money(pid)
                local kills = players.get_kills(pid)
                local kdratio = players.get_kd(pid)
                if kdratio < 0 or kdratio > 12  or kills > 1000000 or rank > 1000 or money > 2000000000 then
                    if isLegit[pid] and not mightNotBeLegit[pid] then
                        lenanotify("" .. players.get_name(pid) .. " might not be legit. Rank: " .. rank .. " Money: " .. string.format("%.2f", money/1000000) .. "M$ Kill: " .. kills .. " KD: " .. string.format("%.2f", kdratio))
                    end
                    isLegit[pid] = false
                    mightNotBeLegit[pid] = true
                else
                    isLegit[pid] = true
                    mightNotBeLegit[pid] = false
                end
                wait(1000)
            end
        end)

    -------------------------------------
    -- Protections
    -------------------------------------

        -------------------------------------
        -- Anti Crash
        -------------------------------------

        menu.toggle(protex, "Render GTA uncrashable", {"panic"}, "Will render GTAV uncrashable", function(on_toggle)
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

        menu.toggle_loop(protex, "Activate Lessen Host when Host", {"bandaid"}, "", function ()
            local lessen = menu.ref_by_path("Online>Protections>Lessen Breakup Kicks As Host")
            if not util.is_session_transition_active() then
                if players.get_host() == players.user() then
                    trigger_command(lessen, "on")
                elseif players.get_host() ~= players.user() then
                    trigger_command(lessen, "off")
                end
            else
                -- nothing
            end
        end)

    -------------------------------------
    -- Orb Detections
    -------------------------------------

        -------------------------------------
        -- Ghost Orbital Players
        -------------------------------------

        local function IsPlayerUsingOrbitalCannon(player)
            return BitTest(memory.read_int(memory.script_global((2657589 + (player * 466 + 1) + 427))), 0) -- Global_2657589[PLAYER::PLAYER_ID() /*466*/].f_427), 0
        end

        menu.toggle_loop(anti_orb, "Ghost", {""}, "Automatically ghost players that are using the orbital cannon.", function()
            for _, pid in ipairs(players.list(false, true, true)) do
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                if IsPlayerUsingOrbitalCannon(pid) and TASK.GET_IS_TASK_ACTIVE(ped, 135) 
                and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), cam_pos) > 300 
                and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), cam_pos) < 400 then
                    util.toast(players.get_name(pid) .. " Is targeting you with the orbital cannon.")
                end
               if IsPlayerUsingOrbitalCannon(pid) then
                    NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, true)
                else
                    NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, false)
                end
            end
        end, function()
            for _, pid in ipairs(players.list(false, true, true)) do
                NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, false)
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
        menu.toggle(anti_orb, "Notify on orb usage", {""}, "", function()
            util.create_tick_handler(function()  
                for pid = 0,31 do
                    if players.get_position(pid).x > 323 and players.get_position(pid).y < 4834 and players.get_position(pid).y > 4822 and players.get_position(pid).z <= -59.36 then
                        if IsOutOfOrbRoom[pid] and not IsInOrbRoom[pid] then
                            notify("" .. tostring(players.get_name(pid)) .. " has entered the orbital cannon room!")
                            if announce_orb == true then
                                chat.send_message("> " .. players.get_name(pid) .. " entered the orbital cannon room", true, true, true)
                            end
                        end
                        if players.get_position(pid).x < 331 and players.get_position(pid).x > 330.40 and players.get_position(pid).y > 4830 and players.get_position(pid).y < 4830.40 and players.get_position(pid).z <= -59.36 then
                            if IsNotAtOrbTable[pid] and not IsAtOrbTable[pid] then
                                notify("" .. tostring(players.get_name(pid)) .. " might be about to call an orbital strike ;)")
                                if announce_orb == true then
                                    chat.send_message("> " .. tostring(players.get_name(pid)) .. " might be about to call an orbital strike.", true, true, true)
                                end
                            end
                            IsAtOrbTable[pid] = true
                            IsNotAtOrbTable[pid] = false
                        end
                        IsInOrbRoom[pid] = true
                        IsOutOfOrbRoom[pid] = false
                    else
                        if IsInOrbRoom[pid] and not IsOutOfOrbRoom[pid] then
                            notify("" .. tostring(players.get_name(pid)) .. " has left the orbital cannon room!")
                            if announce_orb == true then
                                chat.send_message("> " .. players.get_name(pid) .. " left the orbital cannon room", true, true, true)
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

        menu.toggle_loop(anti_orb, "Dispatch In Org Chat", {""}, "", function ()
            announce_orb = true
            end, function ()
            announce_orb = false
        end)

        -------------------------------------
        -- Orb Postition
        -------------------------------------

        local orbital_blips = {}
        local draw_orbital_blips = false
        menu.toggle(anti_orb, "Show orb", {""}, "", function(on)
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
                    if cam_pos.z >= 390.0 and cam_pos.z <= 850.0 and cam_rot.x == 270.0 and cam_rot.y == 0.0 and cam_rot.z == 0.0 and players.is_in_interior(pid) then 
                        util.draw_debug_text(players.get_name(pid) .. "is about to orb someone")
                        if orbital_blips[pid] == nil then 
                            local blip = HUD.ADD_BLIP_FOR_COORD(cam_pos.x, cam_pos.y, cam_pos.z)
                            HUD.SET_BLIP_SPRITE(blip, 588)
                            HUD.SET_BLIP_COLOUR(blip, 59)
                            HUD.SET_BLIP_NAME_TO_PLAYER_NAME(blip, pid)
                            orbital_blips[pid] = blip
                        else
                            HUD.SET_BLIP_COORDS(orbital_blips[pid], cam_pos.x, cam_pos.y, cam_pos.z)
                        end
                    else
                        if orbital_blips[pid] ~= nil then 
                            util.remove_blip(orbital_blips[pid])
                            orbital_blips[pid] = nil
                        end
                    end
                end
                wait()
            end
        end)

    -------------------------------------
    -- Menu Spoofer
    -------------------------------------
        
    menu.action(menu_spoofer, "Vulcano VIP", {""}, "", function()
        for pids = 0, 31 do
            if pids ~= players.user() and players.exists(pids) then
                util.trigger_script_event(1 << pids, {7263263749, pids})
            end
        end
    end)
        
    menu.action(menu_spoofer, "Mister//ModzZ PC", {""}, "", function()
        for pids = 0, 31 do
            if pids ~= players.user() and players.exists(pids) then
                util.trigger_script_event(1 << pids, {72632637999, pids})
            end
        end
    end)
        
    menu.action(menu_spoofer, "Hypno / Cobra", {""}, "", function()
        for pids = 0, 31 do
            if pids ~= players.user() and players.exists(pids) then
                util.trigger_script_event(1 << pids, {74658346534, pids})
            end
        end
    end)
        
    menu.action(menu_spoofer, "X-Force", {""}, "", function()
        for pids = 0, 31 do
            if pids ~= players.user() and players.exists(pids) then
                util.trigger_script_event(1 << pids, {73858735564, pids})
            end
        end
    end)
        
    menu.action(menu_spoofer, "Position", {""}, "", function()
        for pids = 0, 31 do
            if pids ~= players.user() and players.exists(pids) then
                util.trigger_script_event(1 << pids, {7263263764, pids})
            end
        end
    end)
        
    menu.action(menu_spoofer, "Explosive", {""}, "", function()
        for pids = 0, 31 do
            if pids ~= players.user() and players.exists(pids) then
                util.trigger_script_event(1 << pids, {7263263744, pids})
            end
        end
    end)
        
    menu.action(menu_spoofer, "Menace", {""}, "", function()
        for pids = 0, 31 do
            if pids ~= players.user() and players.exists(pids) then
                util.trigger_script_event(1 << pids, {7263268573, pids})
            end
        end
    end)
        
    menu.action(menu_spoofer, "Sodium", {""}, "", function()
        for pids = 0, 31 do
            if pids ~= players.user() and players.exists(pids) then
                util.trigger_script_event(1 << pids, {7263437100, pids})
            end
        end
    end)
        
    menu.action(menu_spoofer, "Terror", {""}, "", function()
        for pids = 0, 31 do
            if pids ~= players.user() and players.exists(pids) then
                util.trigger_script_event(1 << pids, {7263438154, pids})
            end
        end
    end)
        
    menu.action(menu_spoofer, "DarkCheats", {""}, "", function()
        for pids = 0, 31 do
            if pids ~= players.user() and players.exists(pids) then
                util.trigger_script_event(1 << pids, {8364956390, pids})
            end
        end
    end)

    -------------------------------------
    -- Friend List
    -------------------------------------

    local function gen_fren_funcs(name)
        local friend_player_function = menu.list(friend_lists, name, {"friend "..name}, "", function(); end)
        menu.divider(friend_player_function, name)
        menu.action(friend_player_function, "Join", {"jf "..name}, "", function()
            menu.trigger_commands("join "..name)
        end)
        menu.action(friend_player_function, "Spectate", {"sf "..name}, "", function()
            menu.trigger_commands("namespectate "..name)
        end)
        menu.action(friend_player_function, "Invite", {"if "..name}, "", function()
            menu.trigger_commands("invite "..name)
        end)
        menu.action(friend_player_function, "Open profile", {"pf "..name}, "", function()
            menu.trigger_commands("nameprofile "..name)
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

    local showJoinInfo = false
    menu.toggle(online, "Show Join Info", {"showjoins"}, "", function(toggle)
        showJoinInfo = toggle
    end)

    local showleaveInfo = false
    menu.toggle(online, "Show Leave Info", {"showleaves"}, "", function(toggle)
        showleaveInfo = toggle
    end)

    -------------------------------------
    -- Teleport Pickups To Me
    -------------------------------------

    menu.action(online, "Teleport Pickups To Me", {}, "", function()
        local counter = 0
        local pos = players.get_position(players.user())
        for _, pickup in ipairs(entities.get_all_pickups_as_handles()) do
            ENTITY.SET_ENTITY_COORDS(pickup, pos, false, false, false, false)
            counter += 1
            util.yield()
        end
        if counter == 0 then
            util.toast("No Pickups Found. :/")
        else
            util.toast("Teleported ".. tostring(counter) .." Pickups.")
        end
    end)

-------------------------------------
-------------------------------------
-- Misc
-------------------------------------
-------------------------------------

    -------------------------------------
    -- Disable Numpad
    -------------------------------------

    menu.toggle_loop(misc, "Disable Numpad", {"dn"}, "Disables the Numpad while Stand is open", function()
        if not menu.is_open() or lkey.is_key_down('VK_LBUTTON') or lkey.is_key_down('VK_RBUTTON') then return end
        for _, control in pairs(numpadControls) do
            PAD.DISABLE_CONTROL_ACTION(2, control, true)
        end
    end)

    -------------------------------------
    -- Toggle Thunder
    -------------------------------------

    local thunder_on = menu.ref_by_path("Online>Session>Thunder Weather>Enable Request")
    local thunder_off = menu.ref_by_path("Online>Session>Thunder Weather>Disable Request")
    menu.toggle(misc, "Weather Toggle", {"thunder"}, "Requests Thunder Session-wide", function(on_toggle)
        if on_toggle then
            trigger_commands("weather normal")
            wait(1000)
            trigger_command(thunder_on)
            wait(10000)
            util.toast("Weather Set to Thunder") 
        else
            trigger_command(thunder_off)
            wait(10000)
            trigger_commands("weather extrasunny")
            util.toast("Weather Set back to Normal") 
        end
    end)

    -------------------------------------
    -- Auto Join 
    -------------------------------------

    menu.toggle_loop(misc, "Auto Accept Joining Games", {""}, "Will auto accept join screens", function()
        local message_hash = HUD.GET_WARNING_SCREEN_MESSAGE_HASH()
        if message_hash == 15890625 or message_hash == -398982408 or message_hash == -587688989 then
            PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 201, 1.0)
            util.yield(50)
        end
    end)

    -------------------------------------
    -- Clear Area
    -------------------------------------

        -------------------------------------
        -- Clear Area specific
        -------------------------------------
        menu.list_action(clear_area_locally, "Clear All...", {""}, "", {"Peds", "Vehicles", "Objects", "Pickups", "Ropes", "Projectiles", "Sounds"}, function(index, name)
            notify("Clearing "..name:lower().."...")
            local counter = 0
            pluto_switch index do
                case 1:
                    for _, ped in ipairs(entities.get_all_peds_as_handles()) do
                        if ped ~= players.user_ped() and not PED.IS_PED_A_PLAYER(ped) and NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(ped) and (not NETWORK.NETWORK_IS_ACTIVITY_SESSION() or NETWORK.NETWORK_IS_ACTIVITY_SESSION() and not ENTITY.IS_ENTITY_A_MISSION_ENTITY(ped)) then
                            entities.delete_by_handle(ped)
                            counter += 1
                            wait()
                        end
                    end
                    break
                case 2:
                    for _, vehicle in ipairs(entities.get_all_vehicles_as_handles()) do
                        if vehicle ~= PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false) and DECORATOR.DECOR_GET_INT(vehicle, "Player_Vehicle") == 0 and NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(vehicle) then
                            entities.delete_by_handle(vehicle)
                            counter += 1
                        end
                        wait()
                    end
                    break
                case 3:
                    for _, object in ipairs(entities.get_all_objects_as_handles()) do
                        entities.delete_by_handle(object)
                        counter += 1
                        wait()
                    end
                    break
                case 4:
                    for _, pickup in ipairs(entities.get_all_pickups_as_handles()) do
                        entities.delete_by_handle(pickup)
                        counter += 1
                        wait()
                    end
                    break
                case 5:
                    local temp = memory.alloc(4)
                    for i = 0, 101 do
                        memory.write_int(temp, i)
                        if PHYSICS.DOES_ROPE_EXIST(temp) then
                            PHYSICS.DELETE_ROPE(temp)
                            counter += 1
                        end
                        wait()
                    end
                    break
                case 6:
                    local coords = players.get_position(players.user())
                    MISC.CLEAR_AREA_OF_PROJECTILES(coords.x, coords.y, coords.z, 1000, 0)
                    counter = "all"
                    break
                case 4:
                    for i = 0, 99 do
                        AUDIO.STOP_SOUND(i)
                        wait()
                    end
                break
            end
            notify("Cleared "..tostring(counter).." "..name:lower()..".")
        end)

        -------------------------------------
        -- Clear Area All
        -------------------------------------

        menu.action(clear_area_locally, "Clear Area", {"ca"}, "", function()
            local cleanse_entitycount = 0
            for _, ped in pairs(entities.get_all_peds_as_handles()) do
                if ped ~= players.user_ped() and not PED.IS_PED_A_PLAYER(ped) and NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(ped) and (not NETWORK.NETWORK_IS_ACTIVITY_SESSION() or NETWORK.NETWORK_IS_ACTIVITY_SESSION() and not ENTITY.IS_ENTITY_A_MISSION_ENTITY(ped)) then
                    entities.delete_by_handle(ped)
                    cleanse_entitycount += 1
                    wait()
                end
            end

            notify("Cleared " .. cleanse_entitycount .. " Peds")
            cleanse_entitycount = 0
            for _, vehicle in ipairs(entities.get_all_vehicles_as_handles()) do
                if vehicle ~= PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false) and DECORATOR.DECOR_GET_INT(vehicle, "Player_Vehicle") == 0 and NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(vehicle) then
                    entities.delete_by_handle(vehicle)
                    cleanse_entitycount += 1
                    wait()
                end
            end

            notify("Cleared ".. cleanse_entitycount .." Vehicles")
            cleanse_entitycount = 0
            for _, object in pairs(entities.get_all_objects_as_handles()) do
                entities.delete_by_handle(object)
                cleanse_entitycount += 1
                wait()
            end

            notify("Cleared " .. cleanse_entitycount .. " Objects")
            cleanse_entitycount = 0
            for _, pickup in pairs(entities.get_all_pickups_as_handles()) do
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

        menu.action(shortcuts, "Delete Vehicle", {"dv"}, "Deletes your current vehicle", function()
            trigger_commands("deletevehicle")
        end)

        -------------------------------------
        -- Grab Scrip Host
        -------------------------------------

        menu.action(shortcuts, "Grab SH", {"sh"}, "", function()
            trigger_command(menu.ref_by_path("Players>"..players.get_name_with_tags(players.user())..">Friendly>Give Script Host"))
        end)

        -------------------------------------
        -- Easy Way Out
        -------------------------------------

        menu.action(shortcuts, "Really easy Way out", {"ewo"}, "Kill urself", function()
            local pos = ENTITY.GET_ENTITY_COORDS(players.user_ped(), false)
            pos.z = pos.z - 1.0
            FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, 0, 1.0, false, false, 1.0)
        end)

        -------------------------------------
        -- Stop all Sounds
        -------------------------------------

        menu.action(shortcuts, "Force Stop all sound events", {"stopsounds"}, "", function()
            for i=-1,100 do
                AUDIO.STOP_SOUND(i)
                AUDIO.RELEASE_SOUND_ID(i)
            end
        end)

        -------------------------------------
        -- Yeet
        -------------------------------------

        menu.action(shortcuts, "Unload", {"bye", "ul"}, "", function()
            trigger_commands("bandaid off")
            wait(2000)
            trigger_commands("breakupbandaid off")
            wait(2000)
            notify("Lessen has been disabled. Unloading in 3 seconds.")
            wait(3000)
            trigger_commands("unload")
        end)

        -------------------------------------
        -- No lessen
        -------------------------------------

        menu.action(shortcuts, "No lessen", {"nolessen", "nl"}, "", function()
            trigger_commands("bandaid off")
            wait(2000)
            trigger_commands("breakupbandaid off")
            wait(2000)
            notify("Lessen has been disabled.")
        end)

        -------------------------------------
        -- Buy Ammo
        -------------------------------------    

        menu.action(shortcuts, "Buy Ammo", {""}, "Buys ammo the legit way.", function()
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
            end
        end)

        -------------------------------------
        -- Spawn Buzzard
        -------------------------------------

        menu.divider(buzzard_spawn, "Boss Buzzard")
        menu.action(buzzard_spawn, "Spawn Buzzard", {"b1"}, "You need to be the boss", function()
            if players.get_boss(players.user()) == -1 then
                menu.trigger_commands("ceostart")
                notify("Starting CEO... Please wait for a few secs.")
                util.yield(5000)
            end
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
                notify("MB Stats applied")
                log("[Lena] MB Stats applied")
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
            trigger_commands("setcapcash 110")
            wait(500)
            trigger_commands("resupplymeth on")
            wait(500)
            trigger_commands("setcapmeth 80")
            wait(1000)
            notify("MB Stats applied")
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
        -- Headhunter
        -------------------------------------

        menu.action(missions_tunables, "Headhunter", {"hh"}, "", function()
            if players.get_boss(players.user()) == -1 then
                menu.trigger_commands("ceostart")
                NOTIFY("Starting CEO... Please wait for a few secs.")
                util.yield(5000)
            end

            if util.is_interaction_menu_open() then
                IA_MENU_OPEN_OR_CLOSE()
            end
            wait(200)
            SET_INT_GLOBAL(2766485, 29) -- Renders VIP Work screen of the Interaction Menu
            wait(100)
            IA_MENU_OPEN_OR_CLOSE()
            wait(100)
            IA_MENU_DOWN(8)
            wait(100)
            IA_MENU_ENTER(2)
        end, nil, nil, COMMANDPERM_FRIENDLY)

        -------------------------------------
        -- Take over LSIA
        -------------------------------------

        menu.action(missions_tunables, "Take over LSIA", {"lsia"}, "", function()
            if players.get_boss(players.user()) == -1 then
                menu.trigger_commands("ceostart")
                NOTIFY("Starting CEO... Please wait for a few secs.")
                util.yield(5000)
            end

            if util.is_interaction_menu_open() then
                IA_MENU_OPEN_OR_CLOSE()
            end
            wait(200)
            SET_INT_GLOBAL(2766485, 29) -- Renders VIP Work screen of the Interaction Menu
            wait(100)
            IA_MENU_OPEN_OR_CLOSE()
            wait(100)
            IA_MENU_UP(6)
            wait(100)
            IA_MENU_ENTER(1)
            wait(100)
            IA_MENU_LEFT(2)
            wait(100)
            IA_MENU_DOWN(1)
            wait(100)
            IA_MENU_ENTER(1)
        end, nil, nil, COMMANDPERM_FRIENDLY)

        -------------------------------------
        -- Mission friendly
        -------------------------------------

        menu.toggle(missions_tunables, "Mission friendly", {""}, "Enables or disables Settings that might interfere with missions", function(on_toggle)
            if on_toggle then
                trigger_commands("nolessen")
                trigger_commands("hosttoken off")
                trigger_commands("lockoutfit off")
                trigger_commands("spoofrid disabled")
                trigger_commands("spoofip disabled")
                trigger_commands("debugnatives off")
                wait(5000)
                notify("Mission friendly mode has been activated!")
            else
                trigger_commands("hosttoken on")
                trigger_commands("lockoutfit on")
                trigger_commands("bandaid")
                notify("Mission friendly mode has been deactivated!")
            end
        end)

    -------------------------------------
    -- Unlock Cristmas Clothing
    -------------------------------------

    menu.toggle_loop(tunables, "Bypass Christmas Clothing", {""}, "", function()
        SET_PACKED_INT_GLOBAL(9393, 9400, 0) -- joaat("disable_snowballs"), -1810184402
        SET_PACKED_INT_GLOBAL(9401, 9402, 7) -- joaat("max_number_of_snowballs"), joaat("pick_up_number_of_snowballs")
    end)

    -------------------------------------
    -- Remove Costs
    -------------------------------------

    menu.toggle_loop(tunables, "CEO Abilities", {""}, "", function()
        SET_PACKED_INT_GLOBAL(12842, 12851, 0) -- 51567061, -1972817298
        SET_PACKED_INT_GLOBAL(15968, 15973, 0) -- -1451871600, 1289619793
        SET_INT_GLOBAL(262145 + 15890, 0) -- -939028485
        SET_INT_GLOBAL(262145 + 19302, 0) -- 2052581897
        SET_INT_GLOBAL(262145 + 19304, 0) -- -1333531254
    end, function()
        SET_PACKED_INT_GLOBAL(12842, 12851, 5000) -- 15263926, -400440420
        SET_PACKED_INT_GLOBAL(15968, 15973, 5000) -- -679448434, 1289619793
        SET_INT_GLOBAL(262145 + 12842, 20000) -- 51567061
        SET_INT_GLOBAL(262145 + 12846, 25000) -- -1560965224
        SET_INT_GLOBAL(262145 + 12847, 1000) -- 2096833423
        SET_INT_GLOBAL(262145 + 12848, 1500) -- -688609610
        SET_INT_GLOBAL(262145 + 12849, 1000) -- 153241568
        SET_INT_GLOBAL(262145 + 12850, 12000) -- 813006152
        SET_INT_GLOBAL(262145 + 12851, 15000) -- -1972817298
        SET_INT_GLOBAL(262145 + 15890, 5000) -- -939028485
        SET_INT_GLOBAL(262145 + 15968, 10000) -- -1451871600
        SET_INT_GLOBAL(262145 + 15969, 7000) -- 650824488
        SET_INT_GLOBAL(262145 + 15970, 9000) -- 253623806
        SET_INT_GLOBAL(262145 + 19302, 5000) -- 2052581897
        SET_INT_GLOBAL(262145 + 19304, 10000) -- -1333531254
    end)

    -------------------------------------
    -- Refill Snacks and Armor
    -------------------------------------

    menu.action(tunables, "Refill Snacks & Armours", {""}, "", function()
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

    menu.action(tunables, "Max NC Popularity", {"maxnc"}, "", function()
        trigger_commands("clubpo 100")
    end)

    -------------------------------------
    -- Multipliers
    -------------------------------------

    menu.slider_float(multipliers, "Multiply by 'x'", {""}, "", 0, 10000, 100, 100, function(Value)
        MUT_Input = Value / 100
    end)

    menu.toggle_loop(multipliers, "RP", {""}, "", function()
        SET_FLOAT_GLOBAL(262145 + 1, MUT_Input) -- joaat("XP_MULTIPLIER")
    end, function()
        SET_FLOAT_GLOBAL(262145 + 1, 1)
    end)

    menu.toggle_loop(multipliers, "Street Race", {"hcmutstreet"}, "", function()
        SET_FLOAT_GLOBAL(262145 + 31649, MUT_Input) -- -1755846889
    end, function()
        SET_FLOAT_GLOBAL(262145 + 31649, 1)
    end)
    
    menu.toggle_loop(multipliers, "Pursuit Race", {"hcmutpursuit"}, "", function()
        SET_FLOAT_GLOBAL(262145 + 31650, MUT_Input) -- -1610590555
    end, function()
        SET_FLOAT_GLOBAL(262145 + 31650, 1)
    end)

    -------------------------------------
    -- Start a BB
    -------------------------------------

    local start_a_bb1 = menu.ref_by_path("Online>Session>Session Scripts>Run Script>Freemode Activities>Business Battle 1")
    local start_a_bb2 = menu.ref_by_path("Online>Session>Session Scripts>Run Script>Uncategorised>Business Battle 2")

    menu.action(tunables, "Start a BB", {"BB"}, "", function()
        if menu.get_edition() >= 3 then 
            trigger_command(start_a_bb1)
        else
            notify("You need Ultimate to Start a BB, request denied.")
        end
    end, nil, nil, COMMANDPERM_FRIENDLY)

    -------------------------------------
    -- Start a BB 2
    -------------------------------------    

    menu.action(tunables, "Start a BB 2", {"BB2"}, "", function()
        if menu.get_edition() >= 3 then 
            trigger_command(start_a_bb2)
        else
            notify("You need Ultimate to Start a BB, request denied.")
        end
    end)

--------------------------------------------------------------------------------
------------------------------- PLAYER FEATURES --------------------------------
--------------------------------------------------------------------------------

local function player(pid)
    
    if players.get_rockstar_id(pid) == 0x08FC2657 and players.get_rockstar_id_2(pid) == 0x08FC2657 then
        if players.get_rockstar_id(pid) == 0x0CE211ED or players.get_rockstar_id(pid) == 0x0C59991D then
            notify("Ur babe is here, have fun :*")
        end
    end
    
    -- Player recognision

    local friendly_players = {
    0x08FC2657, 0x0CE211ED, 0x04C88F6F, 0x07E59311, 0x03DAF57D, 0x09EF97C6, 0xCB2A48C, 0xAE8F8C2, 0x0C59991D
    }

    local idiots = {  
    -- L
    0x0C6A8CD9, 0x0CAFF827, 0x04DCD691, 0x07E862F8, 0x096E22A3, 0x0967E1C2,
    -- Other Idiots
    0x0B0236FA, 0x01585AB7, 0x09038DD9, 0x1394640, 0xCB7CFF2, 0x0C666371, 0x4A5C95B, 0xC76C9E2, 0xB7EC980, 0xC121CAD, 0x919B57F, 0xC682AB5, 0x3280B78, 0x0479C7D8, 0x04BB8D72,
    0xBB6BAE6, 0x05EB0C06, 0x0C0EFC07, 0x0A9FD9CD, 0xA1FA84B, 0x101D84E, 0xCA6E931, 0x691AC07, 0xAA87C21, 0x988DB36, 0x6AE10E2, 0x71D0AF9, 0xB93038B, 0x0D029C4A, 0x214710914,
    0x0CCC3A82, 0x02314B16, 0xC2590C9, 0x0D193EEE, 0x0BE0E3BE, 0x09D7781F, 0x0BCA5D8C, 0x0AFA420F, 0x07E06196, 0x0CDC6337, 0x0C666371, 0x0B8B307C, 0x0C0DEC0E, 0x04999905,
    0x0B57C870, 0x005A41F0, 0x0C7EC044, 0x0CBDDE32, 0x0860F534, 0x0B848C99, 0x07508CFB, 0x0479C7D8, 0x0A07EB9E, 0x06F51B2F, 0x03097926, 0x0D04F24C, 0x0AE5DA82, 0x0A7D2684,
    0x0B38BC94, 0x0083EAD9, 0x0CFC75F7, 0x004D2E05, 0x5AB5E2F2, 0x0A739990, 0x01904EBA, 0x01480A39, 0x09A5E63E, 0x075A591F, 0x0C50A172, 0x00D344E0, 0x0C6C9C9E, 0x098105F0,
    -- Kelsie
    0x0CE7F2D8, 0x0CDF893D, 0x206611492, 0x208152106, 0x0CEA2329, 0x0D040837, 0x0A0A1032, 0x0D069832
    }

    for _, rid in ipairs (idiots) do
        if players.get_rockstar_id(pid) == rid and get_spawn_state(pid) ~= 0 then 
            trigger_commands("historyblock" .. players.get_name(pid) .. " on")
            wait(500)
            notify("Idiot Detected...")
            trigger_commands("kick " .. players.get_name(pid))
        end
    end

    --[[for _, rid in ipairs (friendly_players) do
        if players.get_rockstar_id(pid) == rid then 
            notify(players.get_name(pid).." Joined :D")
        end
    end]]

    menu.divider(menu.player_root(pid), "Lena Utilities")
    local lena = menu.list(menu.player_root(pid), "Lena Utilities", {"lenau"}, "")
    local friendly = menu.list(lena, "Friendly", {""}, "")
    local mpvehicle = menu.list(lena, "Vehicle", {""}, "")
    local trolling = menu.list(lena, "Trolling", {""}, "")
    local player_removals = menu.list(lena, "Remove Player", {""}, "")
    local kicks = menu.list(player_removals, "Kicks", {""}, "")
    local crashes = menu.list(player_removals, "Crashes", {""}, "")
    local tp_player = menu.list(trolling, "Teleport Player", {}, "")
    local clubhouse = menu.list(tp_player, "Clubhouse", {}, "")
    local facility = menu.list(tp_player, "Facility", {}, "")
    local arcade = menu.list(tp_player, "Arcade", {}, "")
    local warehouse = menu.list(tp_player, "Warehouse", {}, "")
    local cayop = menu.list(tp_player, "Cayo Perico", {}, "")
    local large = menu.list(warehouse, "Large Warehouse", {}, "")

    -------------------------------------
    -------------------------------------
    -- Friendly
    -------------------------------------
    -------------------------------------

        -------------------------------------
        -- Check Stats
        -------------------------------------

        menu.action(friendly, "Check Stats", {"checkstats"}, "Checks the stats of the player", function ()
            local rank = players.get_rank(pid)
            local money = players.get_money(pid)
            local kills = players.get_kills(pid)
            local deaths = players.get_deaths(pid)
            local kdratio = players.get_kd(pid)
            notify("Name : " .. players.get_name(pid) .. "\nRank: " .. rank .. "\nMoney: " .. string.format("%.2f", money/1000000) .. "M$" .. "\nKills/Deaths: " .. kills .. "/" .. deaths .. "\nRatio: " .. string.format("%.2f", kdratio))
        end)

        -------------------------------------
        -- Invite to CEO/MC
        -------------------------------------

        menu.action(friendly, "Invite to CEO/MC", {"ceoinv"}, "[Needs testing]", function ()
            util.trigger_script_event(1 << pid, {
                -1643482755,
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
        -- GOD MODE
        -------------------------------------

        menu.toggle(mpvehicle, "God Mode", {"vgm"}, "", function(on)
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
                    for i = 0, 10 do VEHICLE.SET_VEHICLE_TYRE_FIXED(vehicle, i) end
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

        menu.action(mpvehicle, "Repair", {"rpv"}, "", function()
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

        menu.action(mpvehicle, "Clean", {"cleanv"}, "", function()
            local vehicle = get_vehicle_player_is_in(pid)
            if ENTITY.DOES_ENTITY_EXIST(vehicle) and request_control(vehicle, 1000) then
                VEHICLE.SET_VEHICLE_DIRT_LEVEL(vehicle, 0.0)
            end
        end, nil, nil, COMMANDPERM_FRIENDLY)

        -------------------------------------
        -- Launch Player Vehicle
        -------------------------------------

        menu.action_slider(mpvehicle, "Launch Player Vehicle", {}, "", launch_vehicle, function(index, value)
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

        menu.action(trolling, "Stealth msg", {"pm"}, "", function(click_type)
            menu.show_command_box("pm" .. players.get_name(pid) .. " ")
            end, function(on_command)
                if #on_command > 140 then
                    notify("The message is to long.")
                else
                    chat.send_targeted_message(pid, players.user(), on_command, false)
                    notify("Message has been send.")
                end
        end)

        -------------------------------------
        -- HOSTILE TRAFFIC
        -------------------------------------

        menu.toggle_loop(trolling, "Hostile Traffic", {}, "", function()
            if not is_player_active(pid, false, true) then
                return util.stop_thread()
            end
            local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            for _, vehicle in ipairs(get_vehicles_in_player_range(pid, 70.0)) do
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
        -- Kill Player Inside Interior
        -------------------------------------

        menu.action(trolling, "Kill Player Inside Interior", {}, "Works in casino and nightclubs.", function()
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local pos = ENTITY.GET_ENTITY_COORDS(ped)

            for i, interior in ipairs(interior_stuff) do
                if get_interior_player_is_in(pid) == interior then
                    util.toast("Player is not in any interior. :/")
                return end
                if get_interior_player_is_in(pid) ~= interior then
                    MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 1, pos.x, pos.y, pos.z, 1000, true, util.joaat("weapon_stungun"), players.user_ped(), false, true, 1.0)
                end
            end
        end)

        -------------------------------------
        -- Remote TP's
        -------------------------------------

        for id, name in pairs(All_business_properties) do
            if id <= 12 then
                menu.action(clubhouse, name, {}, "", function()
                    util.trigger_script_event(1 << pid, {0xDEE5ED91, pid, id, 0x20, NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE(pid), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, math.random(1, 10)})
                end)
            elseif id > 12 and id <= 21 then
                menu.action(facility, name, {}, "", function()
                    util.trigger_script_event(1 << pid, {0xDEE5ED91, pid, id, 0x20, NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE(pid), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
                end)
            elseif id > 21 then
                menu.action(arcade, name, {}, "", function() 
                    util.trigger_script_event(1 << pid, {0xDEE5ED91, pid, id, 0x20, NETWORK.NETWORK_HASH_FROM_PLAYER_HANDLE(pid), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1})
                end)
            end
        end

        for id, name in pairs(large_warehouses) do
            menu.action(large, name, {}, "", function()
                util.trigger_script_event(1 << pid, {0x7EFC3716, pid, 0, 1, id})
            end)
        end

        menu.action(tp_player, "Heist Passed Apartment Teleport", {}, "", function()
            util.trigger_script_event(1 << pid, {0xAD1762A7, players.user(), pid, -1, 1, 1, 0, 1, 0}) 
        end) 

        menu.action(cayop, "Cayo Perico (Cutscene)", {""}, "", function()
            util.trigger_script_event(1 << pid, {0x4868BC31, pid, 0, 0, 0x3, 1})
        end)

        menu.action(cayop, "Cayo Perico (No Cutscene)", {"cayo"}, "", function()
            util.trigger_script_event(1 << pid, {0x4868BC31, pid, 0, 0, 0x4, 1})
        end)

        menu.action(cayop, "Leaving Cayo Perico", {"cayoleave"}, "Player Must Be At Cayo Perico To Trigger This Event", function()
            util.trigger_script_event(1 << pid, {0x4868BC31, pid, 0, 0, 0x3})
        end)

        menu.action(cayop, "Kicked From Cayo Perico", {"cayokick"}, "", function()
            util.trigger_script_event(1 << pid, {0x4868BC31, pid, 0, 0, 0x4, 0})
        end)

        -------------------------------------
        -- EXPLOSIONS
        -------------------------------------

        local customExplosion <const> = menu.list(trolling, translate("Trolling", "Custom Explosion"), {}, "")
        local Explosion =
        {
            audible = true,
            delay = 900,
            owned = false,
            type = 0,
            invisible = false
        }

        ---@param pid Player
        function Explosion:explodePlayer(pid)
            local pos = players.get_position(pid)
            pos.z = pos.z - 1.0
            if self.owned then self:addOwnedExplosion(pos) else self:addExplosion(pos) end
        end

        ---@param pos v3
        function Explosion:addOwnedExplosion(pos)
            FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos, self.type, 1.0, self.audible, self.invisible, 0.0)
        end

        ---@param pos v3
        function Explosion:addExplosion(pos)
            FIRE.ADD_EXPLOSION(pos, self.type, 1.0, self.audible, self.invisible, 0.0, false)
        end

        menu.slider(customExplosion, translate("Trolling - Custom Explosion", "Explosion Type"), {}, "",
            0, 72, 0, 1, function(value) Explosion.type = value 
        end)

        menu.toggle(customExplosion, translate("Trolling - Custom Explosion", "Invisible"), {}, "",
            function(on) Explosion.invisible = on 
        end)

        menu.toggle(customExplosion, translate("Trolling - Custom Explosion", "Silent"), {}, "",
            function(on) Explosion.audible = not on 
        end)

        menu.toggle(customExplosion, translate("Trolling - Custom Explosion", "Owned Explosions"), {}, "",
            function(on) Explosion.owned = on 
        end)

        menu.slider(customExplosion, translate("Trolling - Custom Explosion", "Loop Speed"), {}, "",
            50, 1000, 900, 10, function(value) Explosion.delay = value 
        end)

        menu.action(customExplosion, translate("Trolling - Custom Explosion", "Explode"), {}, "", function ()
            Explosion:explodePlayer(pid)
        end)


        local usingExplosionLoop = false
        menu.toggle(customExplosion, translate("Trolling - Custom Explosion", "Explosion Loop"), {}, "", function(on)
            usingExplosionLoop = on
            while usingExplosionLoop and is_player_active(pid, false, true) and
            not util.is_session_transition_active() do
                Explosion:explodePlayer(pid)
                wait(Explosion.delay)
            end
        end)

        -------------------------------------
        -- KILL AS THE ORBITAL CANNON
        -------------------------------------

        menu.action(trolling, "Kill With Orbital Cannon", {"orb"}, "", function()
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

        menu.action(trolling, "Disable Passive Mode", {"pussive"}, "", function()
            wait(500)
            trigger_commands("givesh " .. players.get_name(pid))
            wait(1000)
            trigger_commands("mission" .. players.get_name(pid))
            wait(2000)
            notify("Passive mode should be dissabled now!")
            wait(15000)
        end)

        -------------------------------------
        -- Ghost to User
        -------------------------------------

        menu.toggle(trolling, "Ghost Player", {"ghost", "g"}, "", function(on)
            NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, on)
        end)

    -------------------------------------
    -------------------------------------
    -- Kicks & Crashes
    -------------------------------------
    -------------------------------------

        --[[
        kick_root = menu.ref_by_rel_path(menu.player_root(pid), "Kick")
        menu.action(kick_root, "Rape", {"rape"}, "A Unblockable kick that won't tell the target or non-hosts who did it.", function()
            trigger_commands("breakup" .. players.get_name(pid))
        end, nil, nil, COMMANDPERM_RUDE)
        ]]

        -------------------------------------
        -- Block Join Kick
        -------------------------------------

        menu.action(kicks, "Block Join Kick", {"EMP", "k"}, "Will kick and block the player from joining you ever again.", function()
            wait(400)
            trigger_commands("historyblock" .. players.get_name(pid) .. " on")
            log("[Lena] Player " .. players.get_name(pid) ..  " has been Kicked and Blocked")
            wait(300)
            trigger_commands("ban" .. players.get_name(pid))
        end, nil, nil, COMMANDPERM_RUDE)

        -------------------------------------
        -- Simple Kicks
        -------------------------------------

        menu.action(kicks, "Rape", {"rape"}, "A Unblockable kick that won't tell the target or non-hosts who did it.", function()
            trigger_commands("breakup" .. players.get_name(pid))
        end, nil, nil, COMMANDPERM_RUDE)

        menu.action(kicks, "Stealh Host", {"stealth"}, "Works on legits and free menus.", function()
            trigger_commands("aids" .. players.get_name(pid))
        end)

        menu.action(kicks, "Freemode Death", {"freemodedeath", "fd"}, "Will kill their freemode and send them back to story mode", function()
            util.trigger_script_event(1 << pid, {111242367, pid, memory.script_global(2689235 + 1 + (pid * 453) + 318 + 7)})
        end)

        --[[menu.action(kicks, "RID Kick", {"ridkick", "ridk"}, "Kicks any player via their RID", function()
            local how2getbanned = menu.ref_by_path("Online>Protections>Lessen Breakup Kicks As Host")
            trigger_commands("bandaid")
            wait(1000)
            trigger_commands("gosolop")
            wait(20000)
            trigger_command(how2getbanned, " on")
            wait(math.random(1000, 10000))
            trigger_commands("unload")
            notify("Have fun with RAC!")
        end)]]

        -------------------------------------
        -- Crashes
        -------------------------------------

        menu.action(crashes, "Block Join Crash", {"gtfo"}, "", function()
            wait(500)
            trigger_commands("choke " .. players.get_name(pid))
            wait(500)
            trigger_commands("crash " .. players.get_name(pid))
            wait(500)
            log("[Lena] Player " .. players.get_name(pid) ..  " has been Crashed and Blocked")
            trigger_commands("historyblock" .. players.get_name(pid) .. " on")
        end)

        local nature = menu.list(crashes, "Para", {}, "")
        menu.action(nature, "Version 1", {"V1"}, "", function()
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
        end)

        menu.action(nature, "Version 2", {"V2"}, "", function()
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
        end, nil, nil, COMMANDPERM_RUDE)

        menu.action(crashes, "V3", {"v3"}, "", function()
            local mdl = util.joaat('a_c_poodle')
            BlockSyncs(pid, function()
                if request_model(mdl, 2) then
                    local pos = players.get_position(pid)
                    wait(100)
                    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                    ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 3, 0), 0) 
                    local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                    WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat('WEAPON_HOMINGLAUNCHER'), 9999, true, true)
                    local obj
                    repeat
                        obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                    until obj ~= 0 or wait()
                    ENTITY.DETACH_ENTITY(obj, true, true) 
                    wait(1500)
                    FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, false)
                    entities.delete_by_handle(ped1)
                    wait(1000)
                else
                    notify("Failed to load model. :/")
                end
            end)
        end)

        menu.action(crashes, "Fragment Crash", {""}, "", function()
            BlockSyncs(pid, function()
                local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
                OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
                wait(1000)
                entities.delete_by_handle(object)
            end)
        end)

        menu.action(crashes, "Lena's Crash", {"ICBM"}, "", function()
            local int_min = -2147483647
            local int_max = 2147483647
            for i = 1, 150 do
                util.trigger_script_event(1 << pid, {2765370640, pid, 3747643341, math.random(int_min, int_max), math.random(int_min, int_max), 
                math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                math.random(int_min, int_max), pid, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
            end
            wait()
            for i = 1, 15 do
                util.trigger_script_event(1 << pid, {1348481963, pid, math.random(int_min, int_max)})
            end
            trigger_commands("givesh " .. players.get_name(pid))
            wait(100)
            util.trigger_script_event(1 << pid, {495813132, pid, 0, 0, -12988, -99097, 0})
            util.trigger_script_event(1 << pid, {495813132, pid, -4640169, 0, 0, 0, -36565476, -53105203})
            util.trigger_script_event(1 << pid, {495813132, pid,  0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 17})
        end, nil, nil, COMMANDPERM_AGGRESSIVE)

        menu.action(crashes, "MK2 Griefer", {"grief"}, "Should work one some menus, idk. Don't crash players.", function()
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local pos = players.get_position(pid)
            local mdl = util.joaat("u_m_m_jesus_01")
            local veh_mdl = util.joaat("oppressor")
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
        end)
    -- End?
end

local Jointimes = {}
local names = {}
local rids = {}
local rids2 = {}
local ranks = {}
players.on_join(function(pid)
    names[pid] = players.get_name(pid)
    rids[pid] = players.get_rockstar_id(pid)
    rids2[pid] = players.get_rockstar_id_2(pid)
    Jointimes[pid] = os.clock()

    --[[menu.action(playerRoot, "Get Join Time", {}, "", function() 
        notify(names[pid].." joined "..math.floor(os.clock()-Jointimes[pid]+0.5).."s ago")
    end)]]
    if showJoinInfo then
        notify(names[pid].." has joined.\nSlot: "..pid.."\nRID/SCID: "..rids[pid])
        wait(100)
        log("[Lena] "..names[pid].." (Slot: "..pid.." | RID/SCID: "..rids[pid].."/"..rids2[pid]..") is joining.")
    end

    if pid == players.user() then
        while memory.read_int(memory.script_global(1574988)) ~= 66 do util.yield() end
        for k,v in spairs(prop_list, function(t, a, b) return t[b][3] end) do
            if v.Use then
                addProps(v.Prop, v.PropBone, v.PropPlacement[1], v.PropPlacement[2], v.PropPlacement[3], v.PropPlacement[4], v.PropPlacement[5], v.PropPlacement[6], v.Used)
            end
        end
    end

end)

players.on_leave(function(pid)
    if showleaveInfo then
        notify(names[pid].." left. ("..rids[pid]..", "..math.floor(os.clock()-Jointimes[pid]+0.5).."s spent in session)")
        --log(names[pid].." left. (RID: "..rids[pid].." | Time in Session: "..math.floor(os.clock()-Jointimes[pid]+0.5).."s)"..math.floor(os.clock()-Jointimes[pid]+0.5/60).."m)")
    end
    util.yield(10)
    Jointimes[pid] = nil
    names[pid] = nil
    rids[pid] = nil
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

-- This function (along with some others on_stop functions) allow us to do 
-- some cleanup when the script stops
util.on_stop(function()

	--[[if OrbitalCannon.exists() then
		OrbitalCannon.destroy()
	end]]

	set_streamed_texture_dict_as_no_longer_needed("lena")
	Ini.save(lconfigFile, Config)
end)

-------------------------------------
-- Functions
-------------------------------------

---@param name string
---@param pattern string
---@param callback fun(address: integer)
function memoryScan(name, pattern, callback)
	local address = memory.scan(pattern)
	assert(address ~= NULL, "memory scan failed: " .. name)
	callback(address)
end

memoryScan("GetNetGamePlayer", "48 83 EC ? 33 C0 38 05 ? ? ? ? 74 ? 83 F9", function (address)
	GetNetGamePlayer_addr = address
end)

memoryScan("CNetworkObjectMgr", "48 8B 0D ? ? ? ? 45 33 C0 E8 ? ? ? ? 33 FF 4C 8B F0", function (address)
	CNetworkObjectMgr = memory.rip(address + 3)
end)

---@param player integer
---@return integer
function GetNetGamePlayer(player)
	return util.call_foreign_function(GetNetGamePlayer_addr, player)
end

---@param addr integer
---@return string
function read_net_address(addr)
	local fields = {}
	for i = 3, 0, -1 do table.insert(fields, memory.read_ubyte(addr + i)) end
	return table.concat(fields, ".")
end

---@param player integer
---@return string? IP
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

---@diagnostic disable-next-line: unreachable-code
util.keep_running()