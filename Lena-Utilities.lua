--[[
          Lua made by Lena. Have fun. <3

    ⠄⠄⠄⣰⣿⠄⠄⠄⠄⠄⢠⠄⠄⢀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄
    ⠄⠄⢰⣿⠿⠄⡀⠄⠄⠄⠘⣷⡀⠄⠢⣄⠄⠄⠄⠄⠄⠄⠄⣠⠖⠁⠄⠄⠄⠄
    ⠄⣤⢸⣿⣿⣆⠣⠄⠄⠄⠄⠸⣿⣦⡀⠙⢶⣦⣄⡀⠄⡠⠞⠁⢀⡴⠄⠄⠄⠄
    ⢰⣿⣎⣿⣿⣿⣦⣀⠄⠄⠄⠄⠹⣿⣿⣦⢄⡙⠻⠿⠷⠶⠤⢐⣋⣀⠄⠄⠄⠄
    ⢸⣿⠛⠛⠻⠿⢿⣿⣧⢤⣤⣄⣠⡘⣿⣿⣿⡟⠿⠛⠂⠈⠉⠛⢿⣿⠄⠄⠄⠄
    ⠄⡇⢰⣿⣇⡀⠄⠄⣝⣿⣿⣿⣿⣿⣿⣿⣿⣶⣿⡄⠄⠈⠄⣷⢠⡆⠄⠄⠄⠄
    ⢹⣿⣼⣿⣯⢁⣤⣄⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⣴⠶⣲⣵⠟⠄⠄⠄⠄.
    ⠄⢿⣿⣿⣿⣷⣮⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣾⣟⣡⡴⠄⠄⠄⠄⠁
    ⠄⠰⣭⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⡀⠄⠄⠄⠄
    ⠄⠄⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣭⣶⡞⠄⠄⠄⠄⠄
    ⠄⠄⠐⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠄⠄⠄⠄⠄⠄
    ⠄⠄⠄⠈⠻⣿⣿⣿⣿⣿⣿⣯⣿⣯⣿⣾⣿⣿⣿⣿⣿⡿⠋⠄⠄⠄⠄⠄⠄⠄
    ⠄⠄⠄⠄⠄⠄⠙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣵⠄⠄⠄⠄⠄⠄⠄⠄⠄
    ⠄⠄⠄⠄⠄⠄⠄⢀⣿⣯⣟⣿⣿⣿⡿⣟⣯⣷⣿⣿⡏⣤⠄⠄⠄⠄⠄⠄⠄⠄
    ⠄⠄⠄⠄⠄⠄⠄⣞⢸⣿⣿⣿⣾⣷⣿⣿⣿⣿⣿⣿⣇⣿⡆⠄⠄⠄⠄⠄⠄⠄

]]

-------------------------------------
-- Globals & Locals
-------------------------------------

scriptname = "Lena-Utilities"
log = util.log
notify = util.toast
--wait = util.yield
trigger_commands = menu.trigger_commands
trigger_command = menu.trigger_command
sendse = util.trigger_script_event
joaat = util.joaat
all_objects = {}
spawned_cages = {}
spawned_attackers = {}
object_uses = 0
handle_ptr = memory.alloc(13*8)
previous_car = nil
copy_from = nil
data_e, data_g, Blacklist = {}, {}, {} -- Blacklist
native_invoker.accept_bools_as_ints(true)
thunder_on = menu.ref_by_path("Online>Session>Thunder Weather>Enable Request")
thunder_off = menu.ref_by_path("Online>Session>Thunder Weather>Disable Request")
clearRopes = menu.ref_by_path("World>Inhabitants>Delete All Ropes")

util.require_natives("3095a", "g")

-------------------------------------
-- Tabs
-------------------------------------

local self = menu.list(menu.my_root(), "Self", {"lenaself"}, "Self Options")
vehicle_root = menu.list(menu.my_root(), "Vehicle", {"lenavehicle"}, "Vehicle Options")
local online = menu.list(menu.my_root(), "Online", {"lenaonline"}, "Online Options")
local tunables = menu.list(menu.my_root(), "Tunables", {"lenatunables"}, "Tunables")
local misc = menu.list(menu.my_root(), "Misc", {"lenamisc"}, "")
local ai_made = menu.list(menu.my_root(), "AI Made", {"lenaai"}, "The following options have been generated using ChatGPT, a cutting-edge AI language model.\nI had to make some adjustments, but overall they work great.")
local modules = menu.list(menu.my_root(), "Modules", {"lenamodules"}, "Here you'll be able to download Modules for this script to further enhance it's useability.")

-------------------------------------
-- Sub Tabs
-------------------------------------

-- Self
local anims = menu.list(self, "Animations", {""}, "Some Animations.")
anim_idle = menu.list(anims, "Idle", {""}, "")
anim_sit = menu.list(anims, "Sitting", {""}, "")
anim_romantic = menu.list(anims, "Romantic", {""}, "")
anim_sexy = menu.list(anims, "Sexy", {""}, "")
anim_misc = menu.list(anims, "Misc", {""}, "")

local fast_stuff = menu.list(self, "Skip Animations", {""}, "Skips certain Animations. Lock Outfit breaks it.")
local weap = menu.list(self, "Weapons", {""}, "Weapon Options.")
local lrf = menu.list(weap, "Legit Rapid Fire", {""}, "A macro for Rocket Spam.")
local vehicle_gun_list = menu.list(weap, "Vehicle Gun", {"lenavehgun"}, "Spawn a Vehicle at Impact Coords.")
-- Vehicle
local better_vehicles = menu.list(vehicle_root, "Better Vehicles", {""}, "")
local doorcontrol = menu.list(vehicle_root, "Doors", {""}, "")
local engine_control = menu.list(vehicle_root, "Engine Control", {""}, "")
local vehicle_flares = menu.list(vehicle_root, "Countermeasures", {"lenacountermeasures"}, "War Thunder-like Countermeasues.") -- Yes yes, I know, War Thunder ebic

local veh_weapons = menu.list(vehicle_root, "Vehicle Weapons", {""}, "")
local plane_wep_manager = menu.list(veh_weapons, "Cannon Manager", {""}, "Modify a Plane's on-board Cannons.")
-- Online
local mpsession = menu.list(online, "Session", {""}, "Features for the current Session.")
local hosttools = menu.list(mpsession, "Host Tools", {""}, "Tools that can only be used as the Session Host or to force Session Host.")
local session_veh = menu.list(mpsession, "Session Vehicles", {"sessionvehicles"}, "Will spawn some Vehicles on Set spots for everyone to use them regardless of Level.")

local detects_protex = menu.list(online, "Protections", {""}, "")
local protex = menu.list(detects_protex, "Events", {""}, "")
local anti_orb = menu.list(protex, "Anti Orb", {""}, "Protections against the Orbital Cannon.")
local detections = menu.list(detects_protex, "Detections", {""}, "")

local reactions = menu.list(online, "Reactions", {""}, "")
local join_reactions = menu.list(reactions, "Join Reactions", {""}, "")
local leave_reactions = menu.list(reactions, "Leave Reactions", {""}, "")
local weapon_reactions = menu.list(reactions, "Weapon Reactions", {""}, "")

local spoofing_opt = menu.list(online, "Spoofing", {""}, "")
local host_kick = menu.list(spoofing_opt, "Host Token Options", {""}, "")
-- Tunables
local missions_tunables = menu.list(tunables, "Missions", {""}, "")
local tune_screens = menu.list(tunables, "Open Screens", {""}, "")
local bm_list = menu.list(tunables, "Safe Monitor", {""}, "")
local stat_editing =  menu.list(tunables, "Stat Editing", {""}, "")
-- Misc
local enhanced_chat = menu.list(misc, "Enhanced Chat", {""}, "")
local shortcuts = menu.list(misc, "Shortcuts", {""}, "")
local clear_area = menu.list(misc, "Clear Area", {""}, "")
local teleport = menu.list(misc, "Teleport", {"lenatp"}, "")

-------------------------------------
-- Auto Updater
-------------------------------------

-- Auto Updater from https://github.com/hexarobi/stand-lua-auto-updater
local status, auto_updater = pcall(require, "auto-updater")
if not status then
    local auto_update_complete = nil util.toast("Installing auto-updater...", TOAST_ALL)
    async_http.init("raw.githubusercontent.com", "/hexarobi/stand-lua-auto-updater/main/auto-updater.lua",
        function(result, headers, status_code)
            local function parse_auto_update_result(result, headers, status_code)
                local error_prefix = "Error downloading auto-updater: "
                if status_code != 200 then util.toast(error_prefix..status_code, TOAST_ALL) return false end
                if not result or result == "" then util.toast(error_prefix.."Found empty file.", TOAST_ALL) return false end
                filesystem.mkdir(filesystem.scripts_dir() .. "lib")
                local file = io.open(filesystem.scripts_dir() .. "lib\\auto-updater.lua", "wb")
                if file == nil then util.toast(error_prefix.."Could not open file for writing.", TOAST_ALL) return false end
                file:write(result) file:close() util.toast("Successfully installed auto-updater lib", TOAST_ALL) return true
            end
            auto_update_complete = parse_auto_update_result(result, headers, status_code)
        end, function() util.toast("Error downloading auto-updater lib. Update failed to download.", TOAST_ALL) end)
    async_http.dispatch() local i = 1 while (auto_update_complete == nil and i < 40) do util.yield(250) i = i + 1 end
    if auto_update_complete == nil then error("Error downloading auto-updater lib. HTTP Request timeout") end
    auto_updater = require("auto-updater")
end
if auto_updater == true then error("Invalid auto-updater lib. Please delete your Stand/Lua Scripts/lib/auto-updater.lua and try again") end

local default_check_interval = 86400
auto_update_config = {
    source_url="https://raw.githubusercontent.com/Lenalein2001/Lena-Utils/senpai/Lena-Utilities.lua",
    script_relpath=SCRIPT_RELPATH,
    switch_to_branch=selected_branch,
    verify_file_begins_with="--",
    check_interval=3600,
    silent_updates=false,
    dependencies={
        {
            name="Funcs",
            source_url="https://raw.githubusercontent.com/Lenalein2001/Lena-Utils/senpai/lib/lena/funcs.lua",
            script_relpath="/lib/lena/funcs.lua",
            check_interval=default_check_interval,
            silent_updates=true,
        },
        {
            name="Natives",
            source_url="https://raw.githubusercontent.com/Lenalein2001/Lena-Utils/senpai/lib/natives-2944b/init.lua",
            script_relpath="/lib/natives-2944b/init.lua",
            check_interval=default_check_interval,
            silent_updates=true,
        },
        {
            name="Json",
            source_url="https://raw.githubusercontent.com/Lenalein2001/Lena-Utils/senpai/lib/pretty/json.lua",
            script_relpath="/lib/pretty/json.lua",
            check_interval=default_check_interval,
            silent_updates=true,
        },
        {
            name="Constant",
            source_url="https://raw.githubusercontent.com/Lenalein2001/Lena-Utils/senpai/lib/pretty/json/constant.lua",
            script_relpath="/lib/pretty/json/constant.lua",
            check_interval=default_check_interval,
            silent_updates=true,
        },
        {
            name="Parser",
            source_url="https://raw.githubusercontent.com/Lenalein2001/Lena-Utils/senpai/lib/pretty/json/parser.lua",
            script_relpath="/lib/pretty/json/parser.lua",
            check_interval=default_check_interval,
            silent_updates=true,
        },
        {
            name="Serializer",
            source_url="https://raw.githubusercontent.com/Lenalein2001/Lena-Utils/senpai/lib/pretty/json/serializer.lua",
            script_relpath="/lib/pretty/json/serializer.lua",
            check_interval=default_check_interval,
            silent_updates=true,
        },
        {
            name="ScaleformLib",
            source_url="https://raw.githubusercontent.com/Lenalein2001/Lena-Utils/senpai/lib/ScaleformLib.lua",
            script_relpath="/lib/ScaleformLib.lua",
            check_interval=default_check_interval,
            silent_updates=true,
        },
        {
            name="Tables",
            source_url="https://raw.githubusercontent.com/Lenalein2001/Lena-Utils/senpai/lib/lena/tables.lua",
            script_relpath="/lib/lena/tables.lua",
            check_interval=default_check_interval,
            silent_updates=true,
        },
        {
            name="Handling",
            source_url="https://raw.githubusercontent.com/Lenalein2001/Lena-Utils/senpai/lib/lena/downforce_data.json",
            script_relpath="/lib/lena/downforce_data.json",
            check_interval=default_check_interval,
            silent_updates=true,
        },
        {
            name="Blacklist",
            source_url="https://raw.githubusercontent.com/Lenalein2001/Lena-Utils/senpai/lib/lena/Export_Blacklist.json",
            script_relpath="/lib/lena/Export_Blacklist.json",
            check_interval=default_check_interval,
            silent_updates=true,
        }
    }
}

-------------------------------------
-- Required Files
-------------------------------------

lenaDir = filesystem.scripts_dir().."Lena\\"
libDir = filesystem.scripts_dir().."lib\\lena\\"
lenaModules = filesystem.scripts_dir().."lib\\lena\\modules\\"
local scaleForm = require("ScaleformLib")
local funcs = util.require_no_lag("lena.funcs")
local tables = util.require_no_lag("lena.tables")
json = require("json")
pjson = require("pretty.json")

if not filesystem.exists(lenaDir) then
	filesystem.mkdir(lenaDir)
end
if not filesystem.exists(lenaModules) then
	filesystem.mkdir(lenaModules)
end
if not filesystem.exists(lenaDir.."Players") then
	filesystem.mkdir(lenaDir.."Players")
end
if not filesystem.exists(lenaDir.."Saved Players Webhook.txt") then
    local file = io.open(lenaDir.."Saved Players Webhook.txt", "w")
    file:close()
end
if not filesystem.exists(lenaDir .. "Export_Blacklist.json") then
    local file = io.open(lenaDir .. "Export_Blacklist.json", "w")
    file:close()
end

if async_http.have_access() then
    if not is_developer() then
        auto_updater.run_auto_update(auto_update_config)
    end
else
    notify("This Script needs Internet Access for the Auto Updater to work!")
end

if not SCRIPT_SILENT_START then
    notify($"Hi, {SC_ACCOUNT_INFO_GET_NICKNAME()}. <3")
end

util.create_thread(function()
    local projectile_blips = {}
    while true do
        for k,b in projectile_blips do
            if GET_BLIP_INFO_ID_ENTITY_INDEX(b) == 0 then
                util.remove_blip(b)
                projectile_blips[k] = nil
            end
        end
        if object_uses > 0 then
            all_objects = entities.get_all_objects_as_pointers()
            for k, obj_ptr in all_objects do
                local obj_model = entities.get_model_hash(obj_ptr)
                if is_entity_a_projectile(obj_model) then
                    if blip_projectiles then
                        local obj_hdl = entities.pointer_to_handle(obj_ptr)
                        if GET_BLIP_FROM_ENTITY(obj_hdl) == 0 then
                            local proj_blip = ADD_BLIP_FOR_ENTITY(obj_hdl)
                            SET_BLIP_SPRITE(proj_blip, 443)
                            SET_BLIP_COLOUR(proj_blip, 75)
                            projectile_blips[#projectile_blips + 1] = proj_blip 
                        end
                    end
                end
            end
        end
        wait()
    end
end)

-------------------------------------
-------------------------------------
-- Self
-------------------------------------
-------------------------------------

        -------------------------------------
        -- Animations
        -------------------------------------

        local stopallanim = menu.action(menu.shadow_root(), "Stop all Animations", {""}, "", function()
            CLEAR_PED_TASKS(players.user_ped())
        end)
        menu.attach_before(anim_idle, stopallanim)
        for index, data in animation_table do
            local ref, label, dict, name, duration = data[1], data[2], data[3], data[4], data[5]
            menu.action(ref, label, {$"anim{label}"}, "", function()
                play_anim(dict, name, duration)
            end)
        end

        menu.action(anims, "Faint", {""}, "", function()
            trigger_commands("animfaint")
        end)
        menu.action(anims, "Flirt", {""}, "", function()
            trigger_commands("animflirtylean")
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
        menu.action(anims, "Dance", {""}, "", function()
            play_anim("anim@amb@casino@mini@dance@dance_solo@female@var_b@", "high_center", -1)
        end)

    -------------------------------------
    -- Fast Stuff
    -------------------------------------

        -------------------------------------
        -- Fast Vehicle Enter/Exit
        -------------------------------------

        menu.toggle_loop(fast_stuff, "Fast Vehicle Enter/Exit", {""}, "Enter vehicles faster.", function()
            if (GET_IS_TASK_ACTIVE(players.user_ped(), 160) or GET_IS_TASK_ACTIVE(players.user_ped(), 167) or GET_IS_TASK_ACTIVE(players.user_ped(), 165)) and not GET_IS_TASK_ACTIVE(players.user_ped(), 195) then
                FORCE_PED_AI_AND_ANIMATION_UPDATE(players.user_ped())
            end
        end)

        -------------------------------------
        -- Fast Weapon Switch
        -------------------------------------

        menu.toggle_loop(fast_stuff, "Fast Weapon Switch", {""}, "Swaps your weapons faster.", function()
            if GET_IS_TASK_ACTIVE(players.user_ped(), 56) then
                FORCE_PED_AI_AND_ANIMATION_UPDATE(players.user_ped())
            end
        end)

        -------------------------------------
        -- Fast Reload
        -------------------------------------

        menu.toggle_loop(fast_stuff, "Fast Reload", {""}, "Reloads your Weapon Faster.", function()
            if GET_IS_TASK_ACTIVE(players.user_ped(), 298) then
                FORCE_PED_AI_AND_ANIMATION_UPDATE(players.user_ped())
            end
        end)

        -------------------------------------
        -- Fast Mount
        -------------------------------------

        menu.toggle_loop(fast_stuff, "Fast Mount", {""}, "Mount over stuff faster.", function()
            if GET_IS_TASK_ACTIVE(players.user_ped(), 50) or GET_IS_TASK_ACTIVE(players.user_ped(), 51) then
                FORCE_PED_AI_AND_ANIMATION_UPDATE(players.user_ped())
            end
        end)

    -------------------------------------
    -- Friendly AI
    -------------------------------------

    menu.toggle_loop(self, "Friendly NPCs", {""}, "The NPCs will ignore you.", function(toggled)
        SET_PED_RESET_FLAG(players.user_ped(), 124, true)
        SET_EVERYONE_IGNORE_PLAYER(players.user(), toggled)
    end)

    -------------------------------------
    -- Godmode
    -------------------------------------

    menu.toggle(self, "Godmode", {"gm"}, "Toggles a few options to make you truly Invincible.", function(t)
        trigger_commands($"godmode {t}; vehgodmode {t}; grace {t}; mint {t}")
    end)

    -------------------------------------
    -- Auto Heal
    -------------------------------------

    menu.toggle_loop(self, "Auto Heal", {""}, "Heals you if the Ped has low health.", function()
        local ped = players.user_ped()
        local health = GET_ENTITY_HEALTH(ped)
        if health <= 140 and not IS_PED_DEAD_OR_DYING(ped) then
            trigger_commands("refillhealth; refillarmour")
        end
    end)

    -------------------------------------
    -- Heal
    -------------------------------------

    menu.action(self, "Heal", {"heal"}, "Refills your Health and Armour.", function()
        trigger_commands("refillhealth; refillarmour")
    end)

    menu.toggle_loop(self, "Regenerative Killing", {""}, "Will regenerate health of your Ped and Vehicle if you get a kill.", function()
        local temp = memory.alloc()
        local heal_factor = 1.10 -- aka 10%

        for pid in players.list_except(true) do
            if NETWORK_IS_PLAYER_ACTIVE(pid) and players.user() == NETWORK_GET_KILLER_OF_PLAYER(pid, temp) then
                user_vehicle = user_vehicle or entities.get_user_vehicle_as_pointer(false)

                if user_vehicle then
                    local current_vehicle_health = GET_ENTITY_HEALTH(user_vehicle)
                    local new_vehicle_health = math.floor(current_vehicle_health * heal_factor)
                    if new_vehicle_health > 1000 then new_vehicle_health = 1000 end
                    SET_ENTITY_HEALTH(user_vehicle, new_vehicle_health, 0, 0)
                    SET_VEHICLE_ENGINE_HEALTH(user_vehicle, new_vehicle_health)
                end

                local user_ped = players.user_ped()
                local current_ped_health = GET_ENTITY_HEALTH(user_ped)
                local new_ped_health = math.floor(current_ped_health * heal_factor)
                if new_ped_health > 1000 then new_ped_health = 1000 end
                SET_ENTITY_HEALTH(user_ped, new_ped_health, 0, 0)
            end
        end
    end)

    -------------------------------------
    -- Auto Become CEO/MC
    -------------------------------------

    menu.toggle_loop(self, "Automatically Become a CEO/MC", {""}, "Will start a CEO/MC if you need to be in one.", function()
        if not util.is_session_started() then return end
        for CEOLabels as label do
            if IS_HELP_MSG_DISPLAYED(label) then
                if players.get_boss(players.user()) == -1 then trigger_commands("ceostart") end
                if players.get_org_type(players.user()) == 1 then trigger_commands("ceotomc") end
                wait(100)
            end
        end
        for MCLabels as label do
            if IS_HELP_MSG_DISPLAYED(label) then
                if players.get_boss(players.user()) == -1 then trigger_commands("mcstart") end
                if players.get_org_type(players.user()) == 0 then trigger_commands("ceotomc") end
                wait(100)
            end
        end
    end)

-------------------------------------
-------------------------------------
-- Weapons
-------------------------------------
-------------------------------------

    -------------------------------------
    -- Legit rapid Fire
    -------------------------------------

    local LegitRapidMS = menu.slider(lrf, "Delay", {"lrfdelay"}, "The delay that it takes to switch to the grenade and back to the ", 1, 1000, 100, 50, function (value); end)
    local LegitRapidFire = false
    menu.toggle(lrf, "Legit Rapid Fire", {""}, "Switches to a grenade and back to your Main ", function(toggled)
        local ped = players.user_ped()
        if toggled then
            LegitRapidFire = true
            util.create_thread(function()
                while LegitRapidFire do
                    if IS_PED_SHOOTING(ped) then
                        local currentWpMem = memory.alloc()
                        local junk = GET_CURRENT_PED_WEAPON(ped, currentWpMem, 1)
                        local currentWP = memory.read_int(currentWpMem)
                        SET_CURRENT_PED_WEAPON(ped, 2481070269, true)
                        wait(menu.get_value(LegitRapidMS))
                        SET_CURRENT_PED_WEAPON(ped, currentWP, true)
                    end
                    wait()
                end
                util.stop_thread()
            end)
        else
            LegitRapidFire = false
        end
    end)

    -------------------------------------
    -- Unfair Triggerbot
    -------------------------------------  

    menu.toggle_loop(weap, "Triggerbot", {"triggerbotall"}, "Slightly worse than Stand's triggerbot. Not including the Magic Bullets.", function()
        local wpn = GET_SELECTED_PED_WEAPON(players.user_ped())
        local dmg = ROUND(GET_WEAPON_DAMAGE(wpn, 0))
        local delay = GET_WEAPON_TIME_BETWEEN_SHOTS(wpn)
        local wpnEnt = GET_CURRENT_PED_WEAPON_ENTITY_INDEX(PLAYER_PED_ID(), -1)
        local wpnCoords = GET_ENTITY_BONE_POSTION(wpnEnt, GET_ENTITY_BONE_INDEX_BY_NAME(wpnEnt, "gun_muzzle"))
        for players.list(false, true, true) as pid do
            local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local pos = GET_PED_BONE_COORDS(ped, 31086, 0.0, 0.0, 0.0)
            if IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), ped) and not IS_PED_RELOADING(players.user_ped()) then
                SHOOT_SINGLE_BULLET_BETWEEN_COORDS(wpnCoords, pos, dmg, true, wpn, players.user_ped(), true, false, 10000)
                print(wpn)
                --SET_CONTROL_VALUE_NEXT_FRAME(0, 24, 1.0)
                wait(delay * 1000)
            end
        end
    end)

    -------------------------------------
    -- Rocket Aimbot
    ------------------------------------- 

    menu.toggle_loop(weap, "Rocket Aimbot", {""}, "Distance is limited to 500 Meters.", function()
        for players.list(false, false, true) as pid do
            local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local user = players.user_ped()
            local ped_dist = v3.distance(players.get_position(user), players.get_position(pid))
            local control = (IS_CONTROL_PRESSED(0, 69) or IS_CONTROL_PRESSED(0, 70) or IS_CONTROL_PRESSED(0, 76))
            if IS_PLAYER_PLAYING(ped) and control and ped_dist <= 500.0 and HAS_ENTITY_CLEAR_LOS_TO_ENTITY(user, ped, 17) then
                SET_VEHICLE_SHOOT_AT_TARGET(user, ped, players.get_position(pid))
            end
        end
    end)

    -------------------------------------
    -- Thermal Scope
    -------------------------------------  

    local thermal_command = menu.ref_by_path("Game>Rendering>Thermal Vision")
    menu.toggle_loop(weap, "Thermal Scope", {""}, "Press E while aiming to activate.", function()
        local aiming = IS_PLAYER_FREE_AIMING(players.user())
        if IS_PLAYER_FREE_AIMING(players.user()) then
            if util.is_key_down(0x45) then
                if thermal_command.value or not aiming then
                    thermal_command.value = false
                else
                    thermal_command.value = true
                    SEETHROUGH_SET_MAX_THICKNESS(SEETHROUGH_GET_MAX_THICKNESS())
                    SEETHROUGH_SET_NOISE_MIN(0.0)
                    SEETHROUGH_SET_NOISE_MAX(0.0)
                    SEETHROUGH_SET_FADE_STARTDISTANCE(0.0)
                    SEETHROUGH_SET_FADE_ENDDISTANCE((1 << 31) - 1 + 0.0)
                    SEETHROUGH_SET_HIGHLIGHT_NOISE(0.0)
                end
            end
        else
            thermal_command.value = false
        end
        wait(100)
    end, function()
        thermal_command.value = false
        SEETHROUGH_RESET()
    end)

    -------------------------------------
    -- Spawn vehicle at Bullet Impact
    -------------------------------------  

    local vehicle_gun_ent  = menu.text_input(vehicle_gun_list, "Vehicle", {"shoveh"}, "Vehicle to Spawn. Needs to be ", function(on_change); end, "zentorno")
    local vehicle_gun_gm   = menu.toggle(vehicle_gun_list, "Godmode", {""}, "", function(); end)
    local vehicle_gun_perf = menu.toggle(vehicle_gun_list, "Tune Performance", {""}, "", function(); end)

    local impactCords = v3()
    menu.toggle_loop(vehicle_gun_list, "Spawn Vehicle at Bullet Impact", {""}, "", function()
        if GET_PED_LAST_WEAPON_IMPACT_COORD(players.user_ped(), memory.addrof(impactCords)) then
            local model, gm = menu.get_value(vehicle_gun_ent), menu.get_value(vehicle_gun_gm)
            v = spawn_vehicle(model, impactCords, gm)
            if menu.get_value(vehicle_gun_perf) then tune_vehicle(v, true, false) end
        end
    end)

    --local moneyimpactCords = v3() -- hehe
    --menu.toggle_loop(menu.my_root(), "Spawn Money at Bullet Impact", {""}, "", function()
    --    if GET_PED_LAST_WEAPON_IMPACT_COORD(players.user_ped(), memory.addrof(moneyimpactCords)) then
    --        local cash = joaat("prop_cash_pile_01")
    --        REQUEST_MODEL(cash)
    --        util.request_model(cash, 50)
    --        CREATE_AMBIENT_PICKUP(1704231442, moneyimpactCords.x, moneyimpactCords.y, moneyimpactCords.z+ 1, 0, 1000, cash, false, true)
    --    end
    --end)

-------------------------------------
-------------------------------------
-- Vehicles
-------------------------------------
-------------------------------------

    -------------------------------------
    -- Better Vehicles
    -------------------------------------

        -------------------------------------
        -- Heli Thrust
        -------------------------------------

        menu.divider(better_vehicles, "Better Heli")
        menu.slider_float(better_vehicles, "Thrust", {"helithrust"}, "Set the Heli thrust.", 0, 1000, 220, 10, function(value)
            util.create_tick_handler(function()
                if IS_PED_IN_ANY_HELI(players.user_ped()) then
                    local CHandlingData = entities.vehicle_get_handling(entities.get_user_vehicle_as_pointer())
                    local CflyingHandling = entities.handling_get_subhandling(CHandlingData, 1)
                    if CflyingHandling then
                        memory.write_float(CflyingHandling + 0x8, value * 0.01)
                    end
                end
            end)
        end)

        -------------------------------------
        -- Better Heli
        -------------------------------------

        menu.action(better_vehicles, "Better Heli Mode", {"betterheli"}, "Disabables Heli auto stablization.", function()
            if IS_PED_IN_ANY_HELI(players.user_ped()) then
                local CHandlingData = entities.vehicle_get_handling(entities.get_user_vehicle_as_pointer())
                local CflyingHandling = entities.handling_get_subhandling(CHandlingData, 1)
                for better_heli_offsets as offsets do
                    if CflyingHandling then
                        memory.write_float(CflyingHandling + offsets, 0)
                    end
                end
            end
        end)

        -------------------------------------
        -- Better Lazer
        -------------------------------------

        menu.divider(better_vehicles, "Better Planes")
        menu.action(better_vehicles, "Better Planes", {"betterplanes"}, "", function()
            if IS_PED_IN_ANY_PLANE(players.user_ped()) then
                local CHandlingData = entities.vehicle_get_handling(entities.get_user_vehicle_as_pointer())
                local CflyingHandling = entities.handling_get_subhandling(CHandlingData, 1)
                for better_planes as offsets do
                    local handling = offsets[1]
                    local value = offsets[2]
                    if CflyingHandling then
                        memory.write_float(CflyingHandling + handling, value)
                    end
                end
                notify("Better Planes has been enabled.")
            end
        end)

        -------------------------------------
        -- Reset better Vehicles
        -------------------------------------  

        menu.action(better_vehicles, "Reset Better Vehicles", {"rbv"}, "", function()
            trigger_commands("gravitymult 2; fovfpinveh -5")
        end)

        -------------------------------------
        -- Reduce Burnout
        -------------------------------------  

        menu.toggle(better_vehicles, "Reduce Burnout", {""}, "Makes it to where the vehicle does not burnout as easily.", function(toggled)
            SET_IN_ARENA_MODE(toggled)
        end)

    -------------------------------------
    -- Door Control
    -------------------------------------

        -------------------------------------
        -- Lock doors
        -------------------------------------

        menu.toggle(doorcontrol, "Lock doors", {"lock"}, "Locks your current Vehicle so randoms can't enter it.", function(toggled)
            SET_VEHICLE_RESPECTS_LOCKS_WHEN_HAS_DRIVER(user_vehicle, toggled)
            SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS(user_vehicle, toggled)
        end)

        menu.toggle(doorcontrol, "Lock Doors for Randoms", {"lockrandoms"}, "Locks your current Vehicle so only friends can enter it.", function(toggled)
            for players.list(false, false, true) as pid do
                SET_VEHICLE_RESPECTS_LOCKS_WHEN_HAS_DRIVER(user_vehicle, toggled)
                SET_VEHICLE_DOORS_LOCKED_FOR_PLAYER(user_vehicle, pid, toggled)
            end
        end)

        -------------------------------------
        -- Unbreakable Doors
        -------------------------------------

        menu.toggle(doorcontrol, "Unbreakable Doors", {""}, "", function(toggled)
            local vehicleDoorCount = GET_NUMBER_OF_VEHICLE_DOORS(user_vehicle)
            for i = -1, vehicleDoorCount do
                SET_DOOR_ALLOWED_TO_BE_BROKEN_OFF(user_vehicle, i, not toggled)
            end
        end)

        -------------------------------------
        -- Taze Players
        -------------------------------------

        menu.toggle_loop(doorcontrol, "Taze Players trying to Enter", {""}, "", function()
            if not in_session() then return end
            if user_vehicle != -1 then
                SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS(user_vehicle, true)
            else
                SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS(user_vehicle, false)
            end
            local ped_point = entities.get_all_peds_as_pointers()
            local ped_point_tab = {}
            for ped_point as point do
                local entpos = entities.get_position(point)
                local distance = v3.distance(players.get_position(players.user_ped()), entpos)
                if distance <= 500 then
                    table.insert(ped_point_tab, entities.pointer_to_handle(point))
                end
            end
            for ped_point_tab as handle do
                if IS_PED_TRYING_TO_ENTER_A_LOCKED_VEHICLE(handle) then
                    local bone1 = GET_PED_BONE_COORDS(handle, 36029, 0.0, 0.0, 0.0) 
                    START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD('ent_sht_electrical_box', bone1.x, bone1.y, bone1.z, 90, 0, 0, 1, true, true, true)
                    ADD_EXPLOSION(bone1.x, bone1.y, bone1.z, 8, 0.5, false, true, 0.0, true)
                elseif IS_PED_BEING_JACKED(players.user_ped()) then
                    SET_VEHICLE_DOOR_SHUT(user_vehicle, 0, true)
                    local jacker = GET_PEDS_JACKER(players.user_ped())
                    CLEAR_PED_TASKS_IMMEDIATELY(jacker)
                    local bone1 = GET_PED_BONE_COORDS(jacker, 36029, 0.0, 0.0, 0.0) 
                    ADD_EXPLOSION(bone1.x, bone1.y, bone1.z, 8, 0.5, false, true, 0.0, true)
                    START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD('ent_sht_electrical_box', bone1.x, bone1.y, bone1.z, 90, 0, 0, 1, true, true, true)
                    SET_PED_INTO_VEHICLE(players.user_ped(), user_vehicle, -1)
                end
            end
        end)

    -------------------------------------
    -- Engine Control
    -------------------------------------

        -------------------------------------
        -- Start/Stop Engine
        -------------------------------------

        menu.toggle(engine_control, "Stop Engine", {""}, "Disables and enables the engine on toggle.", function(toggled)
            SET_VEHICLE_ENGINE_ON(user_vehicle, not toggled, toggled, toggled)
        end)
        menu.action(engine_control, "Toggle Engine On", {"Engineoon", "Eon"}, "Starts the Engine of the current ", function()
            SET_VEHICLE_ENGINE_ON(user_vehicle, true, false, false)
        end)
        menu.action(engine_control, "Toggle Engine Off", {"Engineoff", "Eoff"}, "Stops The Engine of the current ", function()
            SET_VEHICLE_ENGINE_ON(user_vehicle, false, true, true)
        end)

        -------------------------------------
        -- Disable Engine Fires
        -------------------------------------

        menu.toggle_loop(engine_control, "Disable Engine Fires", {""}, "", function()
            if user_vehicle != previous_car then
                SET_DISABLE_VEHICLE_ENGINE_FIRES(user_vehicle, true)
                previous_car = player_car
            end
        end)

    -------------------------------------
    -- Countermeasures
    -------------------------------------

        -------------------------------------
        -- Force flares
        -------------------------------------

        local periodicforceflares
        forceflares = menu.toggle_loop(vehicle_flares, "Force Flares", {"forceflares"}, "Forces Flares on Airborn Vehicles.", function()
            if periodicforceflares.value then forceflares.value = false end
            local count = menu.ref_by_path("Vehicle>Countermeasures>Count")
            local how = menu.ref_by_path("Vehicle>Countermeasures>Pattern>Horizontal")
            local deploy = menu.ref_by_path("Vehicle>Countermeasures>Deploy Flares")
            trigger_command(count, "2"); trigger_command(how)
            if GET_VEHICLE_CLASS(user_vehicle) == 15 or GET_VEHICLE_CLASS(user_vehicle) == 16 then
                if util.is_key_down("E") and not chat.is_open() and not menu.command_box_is_open() and not menu.is_open() and not IS_PAUSE_MENU_ACTIVE() then
                    trigger_command(deploy)
                    wait(3, "s")
                end
                wait()
            end
        end)

        -------------------------------------
        -- Periodic flares release
        -------------------------------------

        flaredelay = menu.slider_float(vehicle_flares, "Flare Delay", {""}, "Delay is in Seconds. 0.5 would be half a Second.", 10, 1000, 100, 10, function(); end)
        flareamount = menu.slider(vehicle_flares, "Flare Amount", {""}, "", 1, 20, 1, 1, function(); end)

        periodicforceflares = menu.toggle_loop(vehicle_flares, "Periodic flares release", {""}, "Forces Flares on Airborne Vehicles.", function()
            if forceflares.value then periodicforceflares.value = false end
            local count = menu.ref_by_path("Vehicle>Countermeasures>Count")
            local how = menu.ref_by_path("Vehicle>Countermeasures>Pattern>Horizontal")
            local deploy = menu.ref_by_path("Vehicle>Countermeasures>Deploy Flares")
            trigger_command(count, "1"); trigger_command(how)
            if GET_VEHICLE_CLASS(user_vehicle) == 15 or GET_VEHICLE_CLASS(user_vehicle) == 16 then
                if util.is_key_down("E") and not chat.is_open() and not menu.command_box_is_open() and not menu.is_open() and not IS_PAUSE_MENU_ACTIVE() then
                    for i = 1, flareamount.value do
                        trigger_command(deploy)
                        wait(flaredelay.value * 10)
                    end
                end
                wait()
            end
        end)

    -------------------------------------
    -- Cannon Manager / Credits to err_net_array
    -------------------------------------

    local cannon_type = memory.scan("81 7B 10 29 2A 82 E2 ? ? 38 05 ? ? ? ? B8")
    menu.list_action(plane_wep_manager, "Explosion Type", {}, "", explosionTypes, function(index, value)
       memory.write_int(cannon_type + 0x10, index - 1)
    end)
    local alternate_wait_time = memory.scan("81 7B 10 29 2A 82 E2 ? ? 38 05 ? ? ? ? ? ? F3 0F 10 05 ? ? ? ? ? ? F3 0F 10 83 50")
    menu.click_slider_float(plane_wep_manager, "Alternate Wait Time", {}, "", 0, 100, 0, 1, function(value)
       local ptr_value = memory.read_int(alternate_wait_time + 0x15);
       memory.write_float(alternate_wait_time + ptr_value + 0x19, value / 100)
    end)
    local time_between_shots = memory.scan("81 7B 10 29 2A 82 E2 ? ? 38 05 ? ? ? ? ? ? F3 0F 10 05 ? ? ? ? ? ? F3 0F 10 83 3C")
    menu.click_slider_float(plane_wep_manager, "Time Between Shots", {}, "", 0, 100, 0, 1, function(value)
       local ptr_value = memory.read_int(time_between_shots + 0x15);
       memory.write_float(alternate_wait_time + ptr_value + 0x19, value / 10000)
    end)

    -------------------------------------
    -- Better Explosive Weapons
    -------------------------------------

    menu.toggle_loop(veh_weapons, "Better Explosive Weapons", {""}, "Higher Damage Output for certain Vehicle Cannons.", function()
        if not in_session() then return end

        local ammo = menu.ref_by_path("Self>Weapons>Explosion Type>Grenade")
        local toggle_ammo = menu.ref_by_path("Self>Weapons>Explosive Hits")
        local veh_hashes = {"raiju", "strikeforce", "lazer"}
        local user_vehicle_ptr = entities.get_user_vehicle_as_pointer(false)

        if user_vehicle_ptr ~= 0 then
            local hash = util.reverse_joaat(entities.get_model_hash(user_vehicle_ptr))
            if table.contains(veh_hashes, hash) and not toggle_ammo.value then
                ammo:trigger()
                toggle_ammo.value = true
            elseif not table.contains(veh_hashes, hash) and toggle_ammo.value then
                toggle_ammo.value = false
            end
        end
    end, function()
        menu.ref_by_path("Self>Weapons>Explosive Hits").value = false
    end)

    local wpn_ptrw = memory.alloc()
    local explo_mass_slider = menu.slider(veh_weapons, "Explosive Mass", {"Explosivermass"}, "", 1, 100, 10, 5, function(); end)
    menu.toggle_loop(veh_weapons, "Better Explosive AOE", {""}, "Higher Damage Output for certain Vehicle Explosives", function()
        if not in_session() then return end
        local user_vehicle_ptr = entities.get_user_vehicle_as_pointer(false)

        if user_vehicle_ptr ~= 0 then
            local success = GET_CURRENT_PED_VEHICLE_WEAPON(players.user_ped(), wpn_ptrw)
            if success then
                local selected_weapon_hash = util.reverse_joaat(memory.read_int(wpn_ptrw))
                if selected_weapon_hash == "vehicle_weapon_akula_barrage" then
                    SET_WEAPON_AOE_MODIFIER(memory.read_int(wpn_ptrw), explo_mass_slider.value / 10)
                    wait(10)
                end
            end
        end
    end, function()
        SET_WEAPON_AOE_MODIFIER(GET_SELECTED_PED_WEAPON(players.user_ped()), 1.0)
    end)

    -------------------------------------
    -- Enter Nearest Vehicle
    -------------------------------------

    menu.action(vehicle_root, "Enter Nearest Vehicle", {""}, "Enters the nearest Vehicle that can be found.", function()
        if not IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
            local player_pos = players.get_position(players.user())
            SET_PED_INTO_VEHICLE(players.user_ped(), closestveh(player_pos), -1)
            wait(100)
            local vehname = util.get_label_text(players.get_vehicle_model(players.user()))
            notify($"Set Ped into the nearest \nVehicle: {vehname}.")
        end
    end)

    -------------------------------------
    -- Clean vehicle
    -------------------------------------

    menu.action(vehicle_root, "Clean Vehicle", {"clv"}, "Cleans the current Vehicle.", function()
        SET_VEHICLE_DIRT_LEVEL(user_vehicle, 0.0)
    end)

    -------------------------------------
    -- Disable Crash Damage
    -------------------------------------

    menu.toggle(vehicle_root, "Disable Crash Damage", {""}, "Vehicle will not take crash damage, but is still susceptible to damage from bullets and explosives.", function(toggled)
        SET_VEHICLE_STRONG(toggled)
    end)

    -------------------------------------
    -- Disable Visible Damage
    -------------------------------------

    menu.toggle(vehicle_root, "Disable Visible Damage", {""}, "Vehicle will not take any visible damage.", function(toggled)
        SET_VEHICLE_CAN_BE_VISIBLY_DAMAGED(toggled)
    end)

    -------------------------------------
    -- Unbreakable Lights
    -------------------------------------

    menu.toggle(vehicle_root, "Unbreakable Lights", {""}, "Makes the Lights unbreakable on your current ", function(toggled)
        SET_VEHICLE_HAS_UNBREAKABLE_LIGHTS(user_vehicle, toggled)
    end)

    -------------------------------------
    -- Drift Mode
    -------------------------------------

    menu.toggle_loop(vehicle_root, "Drift Mode", {"driftmode"}, "Hold shift to drift.", function()
        if not in_session() then return end
        if IS_CONTROL_PRESSED(0, 21) then
            SET_VEHICLE_REDUCE_GRIP(user_vehicle, true)
        else
            SET_VEHICLE_REDUCE_GRIP(user_vehicle, false)
        end
    end)

    -------------------------------------
    -- Control Passenger Weapons
    -------------------------------------

    menu.action(vehicle_root, "Control Passenger Weapons", {"controlweapons", "conwep"}, "You can control all weapons of the current ", function()
        local CHandlingData = entities.vehicle_get_handling(entities.get_user_vehicle_as_pointer())
        local CVehicleWeaponHandlingDataAddress = entities.handling_get_subhandling(CHandlingData, 9)
        local WeaponSeats = CVehicleWeaponHandlingDataAddress + 0x0020
        local success, seat = get_seat_ped_is_in(PLAYER_PED_ID())
        if CVehicleWeaponHandlingDataAddress == 0 then
            notify("This Vehicle does not have any Weapons.")
        return end
        if success then
            for i = 0, 4, 1 do
                memory.write_int(WeaponSeats + i * 4, seat + 1)
            end
            trigger_commands("fixvehicle")
        end
    end)

    -------------------------------------
    -- Bypass Anti-Lockon
    -------------------------------------

    menu.toggle_loop(vehicle_root, "Bypass Anti-Lockon", {""}, "Bypass No Lock-on features. Works great on Kiddions Users.", function()
        if not in_session() then return end
        for players.list(false, true, true) as pid do
            local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local veh = GET_VEHICLE_PED_IS_USING(ped)
            if not IS_PED_IN_ANY_VEHICLE(ped) then
                continue
            end
            if memory.read_byte(entities.handle_to_pointer(vehicle) + 0x0A9E) == 0 then
                memory.write_byte((entities.handle_to_pointer(vehicle) + 0x0A9E), 1)
            end
        end
    end)

    -------------------------------------
    -- Auto-Performance Tuning
    -------------------------------------

    menu.toggle_loop(vehicle_root, "Auto-Perf", {""}, "Will Check every 5 seconds if your vehicle could use a upgrade.", function()
        if not in_session() then return end
        if IS_PED_SITTING_IN_ANY_VEHICLE(players.user_ped()) and GET_PED_IN_VEHICLE_SEAT(user_vehicle, -1, true) == players.user_ped() then
            local veh = players.get_vehicle_model(players.user())
            if IS_THIS_MODEL_A_CAR(veh) or IS_THIS_MODEL_A_BIKE(veh) then
                tune_vehicle(user_vehicle, true, true)
            end
        end
    end)

    -------------------------------------
    -- Shot Flames
    -------------------------------------

    menu.toggle_loop(vehicle_root, "Limit RPM", {""}, "", function()
        if not in_session() then return end
        if players.get_vehicle_model(players.user()) != 0 then
            entities.set_rpm(entities.get_user_vehicle_as_pointer(), 1.2)
            wait(100)
        end
    end)

    -------------------------------------
    -- Keep Vehicle Clean
    -------------------------------------

    menu.toggle_loop(vehicle_root, "Keep Vehicle Clean", {""}, "", function()
        if not in_session() then return end
        if IS_PED_SITTING_IN_ANY_VEHICLE(players.user_ped()) and GET_PED_IN_VEHICLE_SEAT(user_vehicle, -1, true) == players.user_ped() then
            if GET_VEHICLE_DIRT_LEVEL(user_vehicle) >= 1.0 and entities.get_owner(user_vehicle) == players.user() then
                SET_VEHICLE_DIRT_LEVEL(user_vehicle, 0.0)
            end
        end
    end)

-------------------------------------
-------------------------------------
-- Online
-------------------------------------
-------------------------------------

    -------------------------------------
    -- Session
    -------------------------------------

        -------------------------------------
        -- Session Host Migration
        -------------------------------------

        menu.toggle_loop(mpsession, "Session Host Migration", {""}, "Notifies you if the Session Host has changed.", function()
            local sh -- Session Host
            local sh_name -- Session Host Name
            if util.is_session_started() then
                if players.get_host() != -1 and players.get_host() != nil then
                    sh = players.get_host()
                    sh_name = players.get_name(sh)
                    wait(2, "s")
                    if sh != -1 and sh != nil then
                        local new_sh = players.get_host()
                        if sh != new_sh and new_sh != -1 and new_sh != nil then
                            if players.exists(new_sh) then
                                notify($"Session Host migrated from {sh_name} to {players.get_name(new_sh)}.")
                                log($"Session Host migrated from {sh_name} to {players.get_name(new_sh)}.")
                            end
                        end
                    end
                end
            end
        end)

        -------------------------------------
        -- Script Host Migration
        -------------------------------------

        menu.toggle_loop(mpsession, "Script Host Migration", {""}, "Notifies you if the Script Host has changed.", function()
            local sh -- Script Host
            local sh_name -- Script Host Name
            if util.is_session_started() then
                if players.get_script_host() != -1 and players.get_script_host() != nil then
                    sh = players.get_script_host()
                    sh_name = players.get_name(sh)
                    wait(2, "s")
                    if sh != -1 and sh != nil then
                        local new_sh = players.get_script_host()
                        if sh != new_sh and new_sh != -1 and new_sh != nil then
                            if players.exists(new_sh) then
                                notify($"Script Host migrated from {sh_name} to {players.get_name(new_sh)}.")
                                log($"Script Host migrated from {sh_name} to {players.get_name(new_sh)}.")
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
            if NETWORK_IS_HOST() then
                NETWORK_SESSION_SET_MATCHMAKING_GROUP_MAX(0, value)
                notify($"Free Slots: {NETWORK_SESSION_GET_MATCHMAKING_GROUP_FREE(0)}")
            else
                notify("You are not the Session Host.")
            end
        end)
        menu.click_slider(hosttools, "Max Spectators", {"maxspectators"}, "Set the max Spectators for the lobby\nOnly works as the Host.", 0, 2, 0, 1, function (value)
            if NETWORK_IS_HOST() then
                NETWORK_SESSION_SET_MATCHMAKING_GROUP_MAX(4, value)
                notify($"Free Slots: {NETWORK_SESSION_GET_MATCHMAKING_GROUP_FREE(4)}")
            else
                notify("You are not the Session Host.")
            end
        end)

        -------------------------------------
        -- Block SH Migration
        -------------------------------------

        menu.toggle(hosttools, "Block Script Host Migration", {""}, "Only works when you are the Host. Doesn't work against Modders.", function(on)
            if util.is_session_started() and NETWORK_IS_HOST() then
                NETWORK_PREVENT_SCRIPT_HOST_MIGRATION()
            end
        end)

        -------------------------------------
        -- Session Info
        -------------------------------------

        menu.divider(hosttools, "Session Info")
        local host_name = menu.readonly(hosttools, "Session Host", "N/A")
        local next_host_name = menu.readonly(hosttools, "Next Session Host", "N/A")
        local script_host_name = menu.readonly(hosttools, "Script Host", "N/A")
        local players_amount = menu.readonly(hosttools, "Players", "N/A")
        local modder_amount = menu.readonly(hosttools, "Modders", "N/A")

        -------------------------------------
        -- Show Talking Players
        -------------------------------------

        menu.toggle_loop(mpsession, "Show Talking Players", {""}, "Draws a debug text of players current talking.", function()
            if util.is_session_started() and not util.is_session_transition_active() then
                for players.list(true, true, true) as pid do
                    if NETWORK_IS_PLAYER_TALKING(pid) then
                        util.draw_debug_text(players.get_name(pid).." is talking", ALIGN_TOP_CENTRE)
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
        menu.toggle(detections, "Detect Rockets", {""}, "Detects incoming Rockets and Mines.", function(on)
            blip_projectiles = on
            mod_uses("object", if on then 1 else -1)
        end)

        -------------------------------------
        -- Stand User ID
        -------------------------------------

        menu.toggle(detections, "Stand User ID", {"suid"}, "Detects Stand Users.", function(toggled)
            local stand_UID = menu.ref_by_path("Online>Protections>Detections>Stand User Identification")
            trigger_command(stand_UID, toggled)
        end, true)

        -------------------------------------
        -- Super Drive
        -------------------------------------

        menu.toggle_loop(detections, "Super Drive", {""}, "Detects Players using Super Drive.", function()
            for players.list() as pid do
                local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local vehicle = GET_VEHICLE_PED_IS_USING(ped)
                local veh_speed = (GET_ENTITY_SPEED(vehicle)* 3.6)
                local veh_class = GET_VEHICLE_CLASS(vehicle)
                if veh_class != 15 and veh_class != 16 and veh_speed >= 320 and (players.get_vehicle_model(pid) != joaat("oppressor") or players.get_vehicle_model(pid) != joaat("oppressor2")) then
                    local driver = NETWORK_GET_PLAYER_INDEX_FROM_PED(GET_PED_IN_VEHICLE_SEAT(vehicle, -1))
                    if not IsDetectionPresent(driver, "Super Drive") then
                        players.add_detection(driver, "Super Drive", 7, 50)
                    end
                    break
                end
            end
        end)

        -------------------------------------
        -- Spectate
        -------------------------------------

        menu.toggle_loop(detections, "Spectate", {""}, "Detects if someone is spectating you.", function()
            for players.list(false) as pid do
                local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local cam_dist = v3.distance(players.get_position(players.user()), players.get_cam_pos(pid))
                local ped_dist = v3.distance(players.get_position(players.user()), players.get_position(pid))
                if cam_dist < 20.0 and ped_dist > 75.0 and not IS_PED_DEAD_OR_DYING(ped) and not NETWORK_IS_PLAYER_FADING(pid) then
                    notify(players.get_name(pid).." is watching you ")
                    if not IsDetectionPresent(pid, "Spectate") then
                        players.add_detection(pid, "Spectate", 7, 0)
                    end
                    break
                end
            end
        end)

        -------------------------------------
        -- Teleport
        -------------------------------------

        menu.toggle_loop(detections, "Teleport", {""}, "Detects if the player has teleported.", function()
            for players.list() as pid do
                local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
                if not NETWORK_IS_PLAYER_FADING(pid) and IS_ENTITY_VISIBLE(ped) and not IS_PED_DEAD_OR_DYING(ped) then
                    local oldpos = players.get_position(pid)
                    wait(1, "s")
                    local currentpos = players.get_position(pid)
                    if GET_SPAWN_STATE(pid) != 0 then
                        for i, interior in interior_stuff do
                            if v3.distance(oldpos, currentpos) > 500 and oldpos.x != currentpos.x and oldpos.y != currentpos.y and oldpos.z != currentpos.z then
                                wait(500)
                                if GET_INTERIOR_FROM_PLAYER(pid) == interior and IS_PLAYER_PLAYING(pid) and players.exists(pid) then
                                    if not IsDetectionPresent(pid, "Teleport") then
                                        players.add_detection(pid, "Teleport", 7, 50)
                                    end
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end)

        -------------------------------------
        -- Stat Detection
        -------------------------------------

        menu.toggle_loop(detections, "Detect Unlegit Stats", {""}, "Detects Modded Stats.", function()
            for players.list() as pid do
                if players.are_stats_ready(pid) and players.exists(pid) then
                    while not players.are_stats_ready(pid) do return end
                    wait(5, "s")
                    if not in_session() then return end
                    local rank = players.get_rank(pid)
                    local money = players.get_money(pid)
                    local kills = players.get_kills(pid)
                    local deaths = players.get_deaths(pid)
                    local kdratio = players.get_kd(pid)
                    if kdratio < 0 or kdratio > 100 or kills < 0 or kills > 100000 or deaths < 0 or deaths > 70000 then
                        if not IsDetectionPresent(pid, "Unlegit Stats (K/D)") then
                            players.add_detection(pid, "Unlegit Stats (K/D)", 7, 25)
                        end
                    end
                    if rank >= 1500 or rank <= 0 then
                        if not IsDetectionPresent(pid, "Unlegit Stats (Rank)") then
                            players.add_detection(pid, "Unlegit Stats (Rank)", 7, 25)
                        end
                    end
                    if money >= 1600000000 then
                        if not IsDetectionPresent(pid, "Unlegit Stats (Money)") then
                            players.add_detection(pid, "Unlegit Stats (Money)", 7, 25)
                        end
                    end
                    if (rank > 1000 and money <= 150000000) or (rank <= 100 and money > 150000000) then
                        if not IsDetectionPresent(pid, "Unlegit Stats (Rank/Money Mismatch)") then
                            players.add_detection(pid, "Unlegit Stats (Rank/Money Mismatch)", 7, 25)
                        end
                    end
                end
            end
        end)

        -------------------------------------
        -- Spawned Vehicle
        -------------------------------------
        -- Full credits go to Prism, I just wanted this feature without having to load more luas.
        -- Small changes will be made.
        menu.toggle_loop(detections, "Spawned Vehicle", {""}, "Detects if someone is using a spawned Vehicle. Can also detect Menus.", function()
            for players.list() as pid do
                local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local vehicle = GET_VEHICLE_PED_IS_USING(ped)
                local hash = players.get_vehicle_model(pid)
                local plate_text = GET_VEHICLE_NUMBER_PLATE_TEXT(vehicle)
                local bitset = DECOR_GET_INT(vehicle, "MPBitset")
                local pegasusveh = DECOR_GET_BOOL(vehicle, "CreatedByPegasus")

                for veh_things as veh do
                    if hash == joaat(veh) and DECOR_GET_INT(vehicle, "MPBitset") == 8 then
                        return
                    end
                end

                if players.get_vehicle_model(pid) != 0 and not GET_IS_TASK_ACTIVE(ped, 160) and GET_SPAWN_STATE(players.user()) != 0 then
                    local driver = NETWORK_GET_PLAYER_INDEX_FROM_PED(GET_PED_IN_VEHICLE_SEAT(vehicle, -1))
                    if players.get_name(driver) != "InvalidPlayer" and not pegasusveh and pid == driver and not players.is_in_interior(pid) then
                        if bitset == 1024 and players.get_weapon_damage_modifier(pid) == 1 and not players.is_godmode(pid) then
                            if not IsDetectionPresent(pid, "2Take1 User") then
                                players.add_detection(pid, "2Take1 User", 7)
                            end
                        elseif plate_text == " TERROR " then
                            if not IsDetectionPresent(pid, "Terror User") then
                                players.add_detection(pid, "Terror User", 7)
                            end
                        elseif plate_text == " MXMENU " then
                            if not IsDetectionPresent(pid, "MXMenu User") then
                                players.add_detection(pid, "MXMenu User", 7)
                            end
                        elseif plate_text == "  FATE  " then
                            if not IsDetectionPresent(pid, "Fate User") then
                                players.add_detection(pid, "Fate User", 7)
                            end
                        end

                        if bitset == 8 or plate_text == "46EEK572" then
                            if not IsDetectionPresent(pid, "Spawned Vehicle") then
                                players.add_detection(pid, "Spawned Vehicle", 7, 33)
                            end
                        end
                    end
                end
            end
        end)

        -------------------------------------
        -- Thunder Join
        -------------------------------------

        menu.toggle_loop(detections, "Modded Script Host Migration", {""}, "Detects people who give script host to another player or took script host while still in a transition.", function()
            if not isNetPlayerOk(players.user()) then return end
            local data = memory.alloc(56 * 8)
            for queue = 0, 2 do
                for index = 0, GET_NUMBER_OF_EVENTS(queue) - 1 do
                    local event = GET_EVENT_AT_INDEX(queue, index)
                    if event == 180 then
                        if not GET_EVENT_DATA(queue, index, data, 2) then
                            break
                        end
                        if memory.read_int(data) == GET_ID_OF_THIS_THREAD() and memory.read_int(data + 8) != players.user() then
                            if not IsDetectionPresent(memory.read_int(data + 8), "Modded Script Host Migration") then
                                local modded_sh = memory.read_int(data + 8)
                                wait(500)
                                local current_sh = players.get_script_host()
                                wait(500)
                                local new_new_sh = players.get_script_host()
                                if new_new_sh != current_sh and current_sh != modded_sh then continue end -- to prevent people from getting false flagged if a retard spams script host on everyone
                                if not isNetPlayerOk(current_sh) then
                                    if modded_sh != current_sh and modded_sh != -1 then
                                        if not isNetPlayerOk(modded_sh) then
                                            players.add_detection(modded_sh, "Modded Script Host Migration", 7, 100)
                                            notify($"{players.get_name(modded_sh)} just broke the session. :/")
                                            break
                                        end
                                    else
                                        players.add_detection(current_sh, "Modded Script Host Migration", 7, 100)
                                        notify($"{players.get_name(current_sh)} just broke the session. :/")
                                    end
                                else
                                    if modded_sh != current_sh then
                                        players.add_detection(modded_sh, "Modded Script Host Migration", 7, 100)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)

        -------------------------------------
        -- Vehicle Godmode
        -------------------------------------

        menu.toggle_loop(detections, "Vehicle Godmode", {""}, "Detects if someone is using a vehicle that is in godmode.", function()
            for players.list(false) as pid do
                local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local vehicle = GET_VEHICLE_PED_IS_USING(ped)
                if IS_PED_IN_ANY_VEHICLE(ped, false) then
                    local driver = NETWORK_GET_PLAYER_INDEX_FROM_PED(GET_PED_IN_VEHICLE_SEAT(vehicle, -1))
                    if not GET_ENTITY_CAN_BE_DAMAGED(vehicle) and not NETWORK_IS_PLAYER_FADING(pid) and IS_ENTITY_VISIBLE(ped) 
                    and players.are_stats_ready(pid) and not players.is_in_interior(pid) and pid == driver then
                        util.draw_debug_text(players.get_name(driver) ..  " is in vehicle godmode")
                        if not IsDetectionPresent(pid, "Vehicle Godmode") then
                            players.add_detection(pid, "Vehicle Godmode", 7)
                        end
                        break
                    end
                end
            end 
        end)

        -------------------------------------
        -- Anti-Lockon
        -------------------------------------

        local lockon = 0
        menu.toggle_loop(detections, "Anti-Lockon", {}, "Detects players using anti-lockon.", function()
            for players.list(false) as pid do
                local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local vehicle = GET_VEHICLE_PED_IS_IN(ped)
                local driver = NETWORK_GET_PLAYER_INDEX_FROM_PED(GET_PED_IN_VEHICLE_SEAT(vehicle, -1))
                local bitset = DECOR_GET_INT(vehicle, "MPBitset")
                local bitset_things = {3072, 10240, 11264, 11272, 33792} -- the game sets some vehicles not targetable that are parts of fm activities
                for bitset_things as bitsets do
                    if bitset == bitsets then
                        return
                    end
                end
                if not IS_PED_IN_ANY_VEHICLE(ped) or (not DOES_VEHICLE_HAVE_IMANI_TECH(vehicle) and GET_VEHICLE_MOD(vehicle, 44) == 1) then
                    continue
                end
                if memory.read_byte(entities.handle_to_pointer(vehicle) + 0xA9E) == 0 and not IsDetectionPresent(pid, "Anti-Lockon") and pid == driver then
                    wait(1000) -- so using chaff doesnt causes a false pos
                    lockon +=1
                    if lockon >= 5 then
                        players.add_detection(pid, "Anti-Lockon", 7, 75)
                        lockon = 0
                        break
                    end
                else
                    lockon = 0
                end
            end
        end)

        -------------------------------------
        -- Modded Vehicle Upgrade
        -------------------------------------

        menu.toggle_loop(detections, "Modded Vehicle Upgrade", {""}, "Detects players who have modded their own or someone else's vehicles outside of a shop.", function()
            for players.list() as pid do
                if not IS_PED_IN_ANY_VEHICLE(GET_PLAYER_PED_SCRIPT_INDEX(pid)) then return end
                util.create_thread(function()
                    local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
                    if not IS_PED_IN_ANY_VEHICLE(ped) then return end
                    local veh = GET_VEHICLE_PED_IS_IN(ped)
                    local veh_ptr = entities.handle_to_pointer(veh)
                    local pos = players.get_position(pid)
                    local driver = NETWORK_GET_PLAYER_INDEX_FROM_PED(GET_PED_IN_VEHICLE_SEAT(veh, -1))
                    if not IS_PED_IN_ANY_VEHICLE(ped, false) then return end
                    local prev_vehicle_mods = {}
                    local current_vehicle_mods = {}
                    for i = 0, 49 do
                        prev_vehicle_mods[i] = GET_VEHICLE_MOD(veh, i)
                    end
                    wait(100)
                    for i = 0, 49 do
                        current_vehicle_mods[i] = GET_VEHICLE_MOD(veh, i)
                    end
                    for i = 0, 49 do
                        if prev_vehicle_mods[i] != current_vehicle_mods[i] and not players.is_in_interior(pid) and IS_ENTITY_VISIBLE(veh) and pos.z > 0.0 then
                            local owner_pid = entities.get_owner(veh_ptr)
                            if owner_pid == pid and not IsDetectionPresent(pid, "Modded Vehicle Upgrade") then
                                players.add_detection(pid, "Modded Vehicle Upgrade", 7, 100)
                                break
                            elseif owner_pid != pid and not IsDetectionPresent(owner_pid, "Modded Vehicle Upgrade (Vehicle Takeover)") then
                                players.add_detection(owner_pid, "Modded Vehicle Upgrade (Vehicle Takeover)", 7, 100)
                            end
                        end
                    end
                end)
            end
            wait(100)
        end)

        -------------------------------------
        -- Vehicle Switch
        -------------------------------------

        menu.toggle_loop(detections, "Vehicle Switch", {""}, "", function()
            for players.list() as pid do
                if not IS_PED_IN_ANY_VEHICLE(GET_PLAYER_PED_SCRIPT_INDEX(pid)) then return end
                util.create_thread(function()
                    local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
                    if not IS_PED_IN_ANY_VEHICLE(ped) then return end
                    local old_veh = GET_VEHICLE_PED_IS_IN(ped)
                    wait(500)
                    local new_veh = GET_VEHICLE_PED_IS_IN(ped)
                    if not IS_PED_IN_ANY_VEHICLE(ped, false) then return end
                    if old_veh != new_veh and not (old_veh or new_veh) == (0.0 or 0 or nil) then
                        if not IsDetectionPresent(pid, "Vehicle Switch") then
                            players.add_detection(pid, "Vehicle Switch", 7, 75)
                        end
                    end
                end)
            end
            wait(100)
        end)

        -------------------------------------
        -- Anti Cheat
        -------------------------------------

        menu.toggle(detections, "Anti Cheat", {""}, "", function(on, click_type)
            if on then
                players.on_flow_event_done(function(p, name, extra)
                    name = lang.get_localised(name)
                    if extra then
                        name ..= " ("
                        name ..= extra
                        name ..= ")"
                    end
                    if string.find(name, "REPORT_MYSELF_EVENT") and not IsDetectionPresent(p, name) then
                        players.add_detection(p, name, 7, 50)
                    end
                end)
            end
        end)

        -------------------------------------
        -- Modified Vehicle Speed
        -------------------------------------

        local ignored_vehs = {}
        local speed_ctr = 0
        menu.toggle_loop(detections, "Modified Vehicle Speed", {}, "Detects people who have modified their engine power or top speed.", function()
            if NETWORK_IS_ACTIVITY_SESSION(true) or not in_session() then return end
            for players.list_except() as pid do
                local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
                if not IS_PED_IN_ANY_VEHICLE(ped) then return end

                local vehicle = GET_VEHICLE_PED_IS_IN(ped)
                local veh_model = players.get_vehicle_model(pid)
                local veh_brand = util.get_label_text(GET_MAKE_NAME_FROM_VEHICLE_MODEL(veh_model))
                local veh_mdl = util.get_label_text(GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(veh_model))
                local veh_class = GET_VEHICLE_CLASS(vehicle)
                local est_speed = GET_VEHICLE_ESTIMATED_MAX_SPEED(vehicle)
                local est_model_speed = GET_VEHICLE_MODEL_ESTIMATED_MAX_SPEED(players.get_vehicle_model(pid))
                local mdl_accel = GET_VEHICLE_MODEL_ACCELERATION(players.get_vehicle_model(pid))
                local veh_accel = GET_VEHICLE_ACCELERATION(vehicle)
                local driver = NETWORK_GET_PLAYER_INDEX_FROM_PED(GET_PED_IN_VEHICLE_SEAT(vehicle, -1))
                local veh_ptr = entities.handle_to_pointer(vehicle)
                local owner = entities.get_owner(veh_ptr)
                local ignored = ignored_vehs[vehicle]
                local classes = vehicle_classes[veh_class + 1]

                if not ignored and owner != pid and driver == pid and est_speed > (est_model_speed + 6) then
                    ignored_vehs[vehicle] = true
                    goto continue
                end

                if ignored and est_speed < (est_model_speed + 6) then
                    ignored_vehs[vehicle] = false
                    goto continue
                end

                local veh_name = veh_mdl
                if veh_brand != "" then
                    veh_name = veh_brand .. " " .. veh_name
                end
                if not IsDetectionPresent(pid, "Modified Vehicle Speed") and est_model_speed > 1.0 and not ignored and est_speed > (est_model_speed + 11) and veh_accel > (mdl_accel * 1.2) and pid == driver then
                    speed_ctr = speed_ctr + 1
                    repeat
                        wait(100)
                    until speed_ctr >= 15
                    players.add_detection(pid, "Modified Vehicle Speed", 7, 75)
                    ignored_vehs[vehicle] = true
                    speed_ctr = 0
                end
                ::continue::
            end

            wait(250)
        end)

    -------------------------------------
    -- Protections
    -------------------------------------

        -------------------------------------
        -- Anti Crash
        -------------------------------------

        menu.toggle(protex, "Render GTA uncrashable", {"panic"}, "Will render GTA:O uncrashable, but the Gameplay will become unplayable.", function(t)
            trigger_commands($"desyncall {t}; anticrashcamera {t}; norender {t}; potatomode {t}")
        end)

        -------------------------------------
        -- Hide IP if not using VPN
        -------------------------------------

        menu.toggle_loop(protex, "VPN Fallback", {""}, "Hide your IP if you're not connected to a ", function()
            local relay = menu.ref_by_path("Online>Protections>Force Relay Connections")
            if not players.is_using_vpn(players.user()) and relay.value == false then
                relay.value = true
                notify("You are not using a VPN! Using Relay Servers Instead.")
            end
        end)

        -------------------------------------
        -- Spoof Session
        -------------------------------------

        menu.toggle(protex, "Spoof Session", {"enablespoofing"}, "Enable Session Spoofing. No one will be able to Join, Track or Spectate you.", function(toggled)
            local spoof_ses = menu.ref_by_path("Online>Spoofing>Session Spoofing>Hide Session>Non-Existent Session")
            local unspoof_ses = menu.ref_by_path("Online>Spoofing>Session Spoofing>Hide Session>Disabled")
            if menu.get_edition() == 3 then
                if toggled then
                    trigger_command(spoof_ses)
                else
                    trigger_command(unspoof_ses)
                end
            else
                notify("You need Ultimate in order to do that!")
            end
        end)

        -------------------------------------
        -- Disable Halloween Weather
        -------------------------------------

        menu.toggle(protex, "Advertise Detection", {"ad_toggle"}, "Toggle advertisement detection.", function(toggled)
            if toggled then
                players.on_flow_event_done(function(p, name, extra)
                    name = lang.get_localised(name)
                    if extra then
                        name ..= " ("
                        name ..= extra
                        name ..= ")"
                    end
                    handleAdvertisement(p, name)
                end)
                wait()
            end
        end)

    -------------------------------------
    -- Orb Detections
    -------------------------------------

        -------------------------------------
        -- Ghost Orbital Players
        -------------------------------------

        menu.toggle_loop(anti_orb, "Ghost", {"ghostorb"}, "Automatically ghost Players that are using the Orbital Cannon.", function()
            if not util.is_session_transition_active() then
                for players.list(false) as pid do
                    local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
                    local cam_pos = players.get_cam_pos(pid)
                    if IS_PLAYER_USING_ORBITAL_CANNON(pid) and GET_IS_TASK_ACTIVE(ped, 135)
                    and v3.distance(GET_ENTITY_COORDS(players.user_ped(), false), cam_pos) < 400
                    and v3.distance(GET_ENTITY_COORDS(players.user_ped(), false), cam_pos) > 340 then
                        notify(players.get_name(pid).." Is targeting you with the Orbital Cannon.")
                    end
                    if players.is_in_interior(pid) then
                        if IS_PLAYER_USING_ORBITAL_CANNON(pid) then
                            SET_REMOTE_PLAYER_AS_GHOST(pid, true)
                        else
                            SET_REMOTE_PLAYER_AS_GHOST(pid, false)
                        end
                    else
                    end
                end
            end
        end)

        -------------------------------------
        -- Block Orbital Cannon
        -------------------------------------

        menu.toggle_loop(anti_orb, "Block Orbital Cannon", {"blockorb"}, "Spawns a prop that blocks the Orbital Cannon Room.", function()
            local model = joaat("xm_prop_cannon_room_door")
            util.request_model(model)
            if orb_obj == nil or not DOES_ENTITY_EXIST(orb_obj) then
                orb_obj = entities.create_object(model, v3(336.56, 4833.00, -60.0))
                entities.set_can_migrate(entities.handle_to_pointer(orb_obj), false)
                SET_ENTITY_HEADING(orb_obj, 125.0)
                FREEZE_ENTITY_POSITION(orb_obj, true)
                SET_ENTITY_NO_COLLISION_ENTITY(players.user_ped(), orb_obj, false)
            end

            if orb_obj2 == nil or not DOES_ENTITY_EXIST(orb_obj2) then
                orb_obj2 = entities.create_object(model, v3(335.155, 4835.0, -60.0))
                entities.set_can_migrate(entities.handle_to_pointer(orb_obj2), false)
                SET_ENTITY_HEADING(orb_obj2, -55.0)
                FREEZE_ENTITY_POSITION(orb_obj2, true)
                SET_ENTITY_NO_COLLISION_ENTITY(players.user_ped(), orb_obj2, false)
            end
            wait(50)
        end, function()
            if orb_obj != nil or orb_obj2 != nil then
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
        menu.toggle(anti_orb, "Notify on orb usage", {"notifyorb"}, "Notifies you if a Player has entered the Orbital Cannon Room.", function()
            util.create_tick_handler(function()
                for players.list(false, true, true) as pid do
                    if players.get_position(pid).x > 323 and players.get_position(pid).y < 4834 and players.get_position(pid).y > 4822 and players.get_position(pid).z <= -59.36 then
                        if IsOutOfOrbRoom[pid] and not IsInOrbRoom[pid] then
                            notify(players.get_name(pid).." has entered the orbital cannon room.")
                            if announce_orb then
                                chat.send_message("> "..players.get_name(pid).." has entered the orbital cannon room.", true, true, true)
                            end
                        end
                        if players.get_position(pid).x < 331 and players.get_position(pid).x > 330.40 and players.get_position(pid).y > 4830 and players.get_position(pid).y < 4830.40 and players.get_position(pid).z <= -59.36 then
                            if IsNotAtOrbTable[pid] and not IsAtOrbTable[pid] then
                                notify(players.get_name(pid).." is calling an Orbital Strike!")
                                if announce_orb then
                                    chat.send_message("> "..players.get_name(pid).." is calling an Orbital Strike!", true, true, true)
                                end
                            end
                            IsAtOrbTable[pid] = true
                            IsNotAtOrbTable[pid] = false
                        end
                        IsInOrbRoom[pid] = true
                        IsOutOfOrbRoom[pid] = false
                    else
                        if IsInOrbRoom[pid] and not IsOutOfOrbRoom[pid] then
                            notify(players.get_name(pid).." has left the orbital cannon room.")
                            if announce_orb then
                                chat.send_message("> "..players.get_name(pid).." has left the orbital cannon room.", true, true, true)
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

        menu.toggle_loop(anti_orb, "Send to Team chat", {""}, "Notifies Players in your CEO/", function(toggled)
            announce_orb = toggled
        end)

        -------------------------------------
        -- Orb Postition
        -------------------------------------

        local orbital_blips = {}
        local draw_orbital_blips = false
        menu.toggle(anti_orb, "Show Orbital Cannon", {"showorb"}, "Shows you where the Player is aiming at.", function(on)
            if in_session() then
                draw_orbital_blips = on
                while true do
                    if not draw_orbital_blips then
                        for pid, blip in orbital_blips do
                            util.remove_blip(blip)
                            orbital_blips[pid] = nil
                        end
                        break 
                    end
                    for players.list(false, true, true) as pid do
                        local cam_rot = players.get_cam_rot(pid)
                        local cam_pos = players.get_cam_pos(pid)
                        if players.is_in_interior(pid) then
                            if IS_PLAYER_USING_ORBITAL_CANNON(pid) then
                                util.draw_debug_text(players.get_name(pid).." is Using the Orbital Cannon!")
                                if orbital_blips[pid] == nil then 
                                    local blip = ADD_BLIP_FOR_COORD(cam_pos.x, cam_pos.y, cam_pos.z)
                                    SET_BLIP_SPRITE(blip, 588)
                                    SET_BLIP_COLOUR(blip, 59)
                                    SET_BLIP_NAME_TO_PLAYER_NAME(blip, pid)
                                    orbital_blips[pid] = blip
                                else
                                    SET_BLIP_COORDS(orbital_blips[pid], cam_pos.x, cam_pos.y, cam_pos.z)
                                end
                            else
                                if orbital_blips[pid] != nil then
                                    util.remove_blip(orbital_blips[pid])
                                    orbital_blips[pid] = nil
                                end
                            end
                        end
                    end
                    wait()
                end
            end
        end)

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
    menu.link(join_reactions, menu.ref_by_path("Online>Reactions>Player Join Reactions"), true)

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
    menu.link(leave_reactions, menu.ref_by_path("Online>Session>Player Leave Notifications"), true)

    -------------------------------------
    -- Weapon Reactions
    -------------------------------------

        -------------------------------------
        -- Explo Sniper Reactions
        -------------------------------------

        menu.divider(weapon_reactions, "Weapon Reactions")
        local explo_reactions = 1
        menu.list_select(weapon_reactions, "Explo Sniper Reaction", {""}, "", anti_explo_sniper, 1, function(index)
            explo_reactions = index
        end)
        menu.toggle_loop(weapon_reactions, "Anti Explo Sniper", {""}, "", function()
            if not in_session() then return end
            for players.list(false) as pid do
                local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
                if IS_PED_ARMED(ped, 4 | 2) then
                    if HAS_PED_GOT_WEAPON(ped, 177293209) and HAS_PED_GOT_WEAPON_COMPONENT(ped, 177293209, -1981031769) then
                        if explo_reactions == 1 then
                            REMOVE_WEAPON_FROM_PED(ped, 177293209)
                            notify("Removed Weapon From Explo Sniper User\n"..players.get_name(pid))
                            wait(5000)
                        elseif explo_reactions == 2 then
                            REMOVE_WEAPON_COMPONENT_FROM_PED(ped, 177293209, -1981031769)
                            notify("Removed Attachment From Explo Sniper User\n"..players.get_name(pid))
                            wait(5000)
                        elseif explo_reactions == 2 then
                            SET_PED_AMMO(ped, 177293209, 0, 0)
                            notify("Removed Ammo From Explo Sniper User\n"..players.get_name(pid))
                            wait(5000)
                        elseif explo_reactions == 4 then
                            trigger_commands("explode"..players.get_name(pid))
                            notify("Killed Explo Sniper User\n"..players.get_name(pid))
                            wait(5000)
                        elseif explo_reactions == 5 then
                            util.draw_debug_text(players.get_name(pid).." is using the Explo Sniper.")
                        end
                    end
                end
            end
        end)

    -------------------------------------
    -- Spoofing Options
    -------------------------------------

        -------------------------------------
        -- Spoof Assets
        -------------------------------------

        menu.toggle(spoofing_opt, "Spoof Assets", {"spoofassets", "spoofass"}, "Spoof Session Assets.", function(toggled)
            trigger_commands($"extratoggle {toggled}")
        end)

        -------------------------------------
        -- Group-Based Copy Session Info
        -------------------------------------

        local group_name = menu.text_input(spoofing_opt, "Group Name", {"groupname"}, "", function(); end, "Admins")
        local group_copy_ref = menu.toggle_loop(spoofing_opt, "Group-Based Copy Session Info", {"groupcopy"}, "", function()
            local players = menu.ref_by_path("Online>Player History>Noted Players>"..group_name.value)

            if not players:isValid() then
                group_copy_ref.value = false
                return print("Group not Valid!")
            end

            if copy_from != nil then
                if copy_from.menu_name:sub(-8) != "[Public]" then
                    util.toast($"{copy_from.name_for_config} is no longer in a public session, disabling Copy Session Info.")
                    clearCopySession()
                end
            else
                for players:getChildren() as link do
                    local ref = link:getPhysical()
                    --print(ref.menu_name)
                    if ref.menu_name:sub(-8) == "[Public]" then
                        util.toast($"{ref.name_for_config} is in a Public Session, copying their Session Info.")
                        ref:refByRelPath("Copy Session Info").value = true
                        copy_from = ref
                    end

                end
            end
            wait(500)
        end, clearCopySession)

    -------------------------------------
    -- Enhanced Chat
    ------------------------------------- 

        -------------------------------------
        -- Better Chat
        -------------------------------------

        local toggle_chat = menu.ref_by_path("Online>Chat>Always Open")
        menu.toggle_loop(enhanced_chat, "Better Chat", {""}, "", function()
            if IS_CONTROL_JUST_PRESSED(1, 245) then
                repeat chat.close() until not chat.is_open()
                menu.show_command_box("gmsg ")
                while menu.command_box_is_open() do
                    toggle_chat.value = true
                    wait()
                end
                toggle_chat.value = false
            elseif IS_CONTROL_JUST_PRESSED(1, 246) then
                repeat chat.close() until not chat.is_open()
                menu.show_command_box("tmsg ")
                while menu.command_box_is_open() do
                    toggle_chat.value = true
                    wait()
                end
                toggle_chat.value = false
            end
        end)

        menu.action(enhanced_chat, "Send a Global Message", {"globalmessag", "gmsg"}, "", function(click_type)
            menu.show_command_box($"gmsg "); end, function(input)
            chat.send_message(input, false, true, true)
        end)

        menu.action(enhanced_chat, "Send a Team Message", {"teammessag", "tmsg"}, "", function(click_type)
            menu.show_command_box($"tmsg "); end, function(input)
            chat.send_message(input, true, true, true)
        end)

        menu.action(enhanced_chat, "Start Typing", {"starttyping"}, "", function()
            for players.list(false) as pid do
                if players.exists(pid) then
                    send_script_event(-1760661233, pid, {players.user(), pid, 9412}) -- Not Updated
                end
            end
        end)

        menu.action(enhanced_chat, "Stop Typing", {"stoptyping"}, "", function()
            for players.list(false) as pid do
                if players.exists(pid) then
                    send_script_event(476054205, pid, {players.user(), pid, 4491}) -- Not Updated
                end
            end
        end)

    -------------------------------------
    -- Save Players Information on Kick
    -------------------------------------

    local savekicked = menu.toggle(online, "Save Players Information on Kick", {""}, "", function(); end)

    -------------------------------------
    -- Preview Players
    -------------------------------------

    local draw_players = menu.toggle(online, "Preview Players", {""}, "Draw their Ped onto the Screen if focused.", function(); end)

    -------------------------------------
    -- Whitelist Session
    -------------------------------------

    menu.toggle(online, "Whitelist Session", {"whitelist", "wl"}, "Blocks Joins from non-Whitelisted players.", function(toggled)
        local whitelist = menu.ref_by_path("Online>Session>Block Joins>From Non-Whitelisted")
        trigger_command(whitelist, toggled)
    end)

    -------------------------------------
    -- Speed Up Joining
    -------------------------------------

    menu.toggle(online, "Speed Up Joining", {"speedupjoin"}, "Slightly Speed up Joining New Sessions.", function(toggled)
        trigger_commands($"skipbroadcast {toggled};speedupfmmc {toggled};speedupspawn {toggled}")
    end)

    -------------------------------------
    -- Kick Attackers
    -------------------------------------

    menu.toggle_loop(online, "Kick Attackers", {""}, "", function()
        if in_session() then
            for players.list(false, true, true) as pid do
                if players.is_marked_as_attacker(pid) then
                    local pname = players.get_name(pid)
                    local rid = players.get_rockstar_id(pid)

                    local start_time = os.time()
                    local confirmed = false

                    while os.time() - start_time < 10 do
                        util.draw_centered_text("Add " .. pname .. " to blacklist? (y/n)")
                        if util.is_key_down("Y") then
                            confirmed = true
                            break
                        elseif util.is_key_down("N") then
                            break
                        end
                        wait()
                    end

                    -- If confirmed, add the player to the blacklist
                    if confirmed and not is_player_in_blacklist(decimalToHex(rid)) then
                        notify(pname .. " has been added to the blacklist for attacking you.")
                        add_player_to_blacklist(decimalToHex(rid))
                    end
                    trigger_commands("rape " .. pname)
                    wait(30, "s")
                end
            end
        end
    end)

    -------------------------------------
    -- Ghost Session
    -------------------------------------

    menu.toggle(online, "Ghost Session", {"ghostsession"}, "Creates a session within your session where you will not receive other player's syncs, and they will not receive yours.", function(toggled)
        if toggled then
            NETWORK_START_SOLO_TUTORIAL_SESSION()
        else
            NETWORK_END_TUTORIAL_SESSION()
        end
    end)

    isPlayerFriendToggle = menu.toggle(host_kick, "Exclude Friends", {"host_kick"}, "Toggle exception for Player Friend", function(); end)
    isStandUserToggle = menu.toggle(host_kick, "Exclude Stand Users", {"host_kick"}, "Toggle exception for Stand User", function(); end)
    isMarkedAsModderToggle = menu.toggle(host_kick, "Exclude Modders ", {"host_kick"}, "Toggle exception for Marked as Modder", function(); end)

    menu.toggle_loop(host_kick, "Kick Host", {""}, "", function()
        if not in_session() then return end
        local hostId = players.get_host()
        local index = players.get_host_queue_position(players.user())

        if hostId and index == 1 then
            if not (IS_PLAYER_FRIEND(hostId) or isStandUser(hostId) or isMarkedAsModder(hostId)) then
                trigger_commands($"kick {players.get_name(hostId)}")
                wait(1, "m")
            end
        end
    end)

-------------------------------------
-------------------------------------
-- Tuneables
-------------------------------------
-------------------------------------

    -------------------------------------
    -- Missions
    -------------------------------------

        -------------------------------------
        -- Mission friendly
        -------------------------------------

        menu.toggle(missions_tunables, "Mission Friendly Mode", {"missionfriendly", "mfr"}, "Enables or disables Settings that might interfere with missions.", function(toggled)
            if toggled then
                trigger_commands("lockoutfit off; svmreimpl off; debugnatives off; seamless off; norestrictedareas off")
            end
        end)

        -------------------------------------
        -- Headhunter
        -------------------------------------

        menu.action(missions_tunables, "Start Headhunter", {"hh", "headhunter"}, "Starts the CEO mission \"Headhunter\".", function()
            if not StartCEO() or not in_session() then return end
            wait(1000)
            IA_MENU_OPEN_OR_CLOSE()
            IA_MENU_ENTER(1)
            IA_MENU_DOWN(2)
            IA_MENU_ENTER(1)
            IA_MENU_DOWN(8)
            IA_MENU_ENTER(1)
            IA_MENU_ENTER(1)
            local Blip = GET_FIRST_BLIP_INFO_ID(432) -- https://docs.fivem.net/docs/game-references/blips/
            while DOES_BLIP_EXIST(Blip) do
                local Ped = GET_BLIP_INFO_ID_ENTITY_INDEX(Blip)
                local addr = entities.handle_to_pointer(Ped)
                entities.set_can_migrate(addr, false)
                entities.give_control_by_pointer(addr, players.user())
                Blip = GET_NEXT_BLIP_INFO_ID(432)
                wait(2000)
            end
        end)

        -------------------------------------
        -- Finish Headhunter
        -------------------------------------

        menu.action(missions_tunables, "Finish Headhunter", {"finishheadhunter", "finishhh"}, "Tries to finish the Mission.", function()
            local Blip = GET_FIRST_BLIP_INFO_ID(432) -- https://docs.fivem.net/docs/game-references/blips/
            while DOES_BLIP_EXIST(Blip) do
                local ped = GET_BLIP_INFO_ID_ENTITY_INDEX(Blip)
                local pos = entities.get_position(entities.handle_to_pointer(ped))
                FREEZE_ENTITY_POSITION(ped, true)
                ADD_OWNED_EXPLOSION(players.user_ped(), pos, 59, 1.0, false, false, 1.0)
                Blip = GET_NEXT_BLIP_INFO_ID(432)
            end
            wait(1000)
        end)

        -------------------------------------
        -- Teleport Pickups To Me
        -------------------------------------

        menu.action(missions_tunables, "Teleport Pickups To Me", {"tppu"}, "Teleports all pickups to you.", function()
            local counter = 0
            local pos = players.get_position(players.user())
            for entities.get_all_pickups_as_handles() as pickup do
                SET_ENTITY_COORDS(pickup, pos, false, false, false, false)
                counter += 1
                wait(100)
            end
            if counter == 0 then
                notify("No Pickups Found. :/")
            else
                notify($"Teleported {counter} Pickups to you.")
            end
        end)

        -------------------------------------
        -- TP Buisiness Battle Pickups to me
        -------------------------------------

        menu.action(missions_tunables, "TP Buisiness Battle Pickups to me", {""}, "", function()
            local counter = 0
            local pos = players.get_position(players.user())
            local objects = {"ba_prop_battle_bag_01a", "ba_prop_battle_drug_package_02", "ba_prop_battle_bag_01b", "ba_prop_battle_case_sm_03"}
            for entities.get_all_pickups_as_handles() as p do
                for objects as obj do
                    if GET_ENTITY_MODEL(p) == joaat(obj) and request_control(p, true) and DOES_ENTITY_EXIST(p) then
                        SET_ENTITY_COORDS(p, pos.x, pos.y, pos.z + 0.5, false)
                        counter =+ 1
                        wait()
                    end
                    if counter != 0 then
                        notify($"Teleported {counter} Entities to you.")
                    else
                        notify("No pickups found.")
                    end
                end
            end
        end)

        -------------------------------------
        -- Kill All Peds
        -------------------------------------

        menu.action(missions_tunables, "Kill All Peds", {"killpeds"}, "Kills all Mission Peds.", function()
            local counter = 0
            for entities.get_all_peds_as_handles() as ped do
                if GET_BLIP_COLOUR(GET_BLIP_FROM_ENTITY(ped)) == 1 or GET_IS_TASK_ACTIVE(ped, 352) then
                    SET_ENTITY_HEALTH(ped, 0)
                    counter += 1
                    wait(100)
                end
            end
            if counter == 0 then
                notify("No Peds Found. :/")
            else
                notify($"Killed {counter} Mission Peds.")
            end
        end)

        -------------------------------------
        -- Destroy Signal Jammers
        -------------------------------------

        menu.action(missions_tunables, "Destroy Signal Jammers", {""}, "Good for Hangar Missions.", function()
            local counter = 0
            for entities.get_all_objects_as_handles() as obj do
                local blip = GET_BLIP_FROM_ENTITY(obj)
                if GET_BLIP_SPRITE(blip) == 485 then
                    local pos = GET_ENTITY_COORDS(obj, false)
                    ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z - 1.0, 5, 1.0, false, false, 1.0)
                    counter += 1
                    wait(100)
                end
            end
            if counter == 0 then
                notify("No Jammers Found. :/")
            else
                notify($"Destroyed {counter} Signal Jammers.")
            end
        end)

    -------------------------------------
    -- Refill Snacks and Armor
    -------------------------------------

    menu.action(tunables, "Refill Snacks & Armour", {"refillsnacks"}, "Refills all Snacks and Armour.", function()
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
    -- Enable R* DLC
    -------------------------------------

    menu.toggle(tunables, "Unlock R* Clothes", {""}, "Unlocks some Rockstar Clothes.", function(toggled)
        trigger_commands($"admindlc {toggled}")
    end)

    -------------------------------------
    -- Start a BB
    -------------------------------------

    local start_a_bb = menu.ref_by_path("Online>Session>Session Scripts>Run Script>Freemode Activities>Business Battle 1")
    menu.action(tunables, "Start a Business Battle", {"bb"}, "Starts a 2 Crate Business Battle. Doesn't work when Co-loading.", function()
        if menu.get_edition() >= 3 then
            trigger_command(start_a_bb)
        else
            notify("You need Ultimate to Start a Business Battle. Request denied.")
        end
    end)

    -------------------------------------
    -- Screen Opener
    -------------------------------------

    for index, data in script_start do
        local script = data[1]
        local name = data[2]
        menu.action(tune_screens, name, {""}, "", function()
            start_fm_script(script)
        end)
    end

    -------------------------------------
    -- Monitor Safes
    -------------------------------------

    for index, data in bm_safe_table do
        local name, stat, max = data[1], data[2], data[3]
        menu.toggle_loop(bm_list, $"Monitor {name}", {$"monitor{name}"}, "", function()
            if in_session() then
                local value = SSTAT_GET_INT(stat)
                util.draw_debug_text($"{name} $: {value} | {max}")
            end
        end)
    end

    -------------------------------------
    -- Stat Editor
    -------------------------------------

    menu.divider(stat_editing, "Set Time")
    add_playtime = menu.toggle(stat_editing, "Add Additional Playtime", {""}, "", function(); end)
    local PLAYTIME_DAYS = menu.slider(stat_editing, "Days", {""}, "", 0, 50000, 0, 1, function(); end)
    local PLAYTIME_HOURS = menu.slider(stat_editing,"Hours", {""}, "", 0, 50000, 0, 1, function(); end)
    local PLAYTIME_MINS = menu.slider(stat_editing, "Minutes", {""}, "", 0, 50000, 0, 1, function(); end)
    for index, this in PlaytimeStats do
        local name = this[1]
        local stat = this[2]
        local helpText = this[3] or ""
        menu.action(stat_editing, $"Edit {name}", {$"edit{name}"}, helpText, function()
            if not menu.get_value(add_playtime) then
                SSTAT_SET_INT(stat, menu.get_value(PLAYTIME_DAYS) * 86400000 + menu.get_value(PLAYTIME_HOURS) * 3600000 + menu.get_value(PLAYTIME_MINS) * 60000)
            else
                STAT_INCREMENT(stat, menu.get_value(PLAYTIME_DAYS) * 86400000 + menu.get_value(PLAYTIME_HOURS) * 3600000 + menu.get_value(PLAYTIME_MINS) * 60000)
            end
            trigger_commands("forcecloudsave")
        end)
    end

    menu.divider(stat_editing, "Set Dates")
    local Stat_day = menu.slider(stat_editing, "Day", {""}, "", 0, 31, os.date("%d"), 1, function(); end)
    local Stat_month = menu.slider(stat_editing,"Month", {""}, "", 0, 12, os.date("%m"), 1, function(); end)
    local Stat_year = menu.slider(stat_editing, "Year", {""}, "", 2013, os.date("%Y"), os.date("%Y"), 1, function(); end)
    for index, that in playtimeDates do
        local name = that[1]
        local stat = that[2]
        local helpText = that[3] or ""
        menu.action(stat_editing, $"Edit {name}", {$"edit{name}"}, helpText, function()
            SSTAT_SET_DATE(stat, menu.get_value(Stat_year), menu.get_value(Stat_month), menu.get_value(Stat_day), 0, 59)
            trigger_commands("forcecloudsave")
        end)
    end

    -------------------------------------
    -- Remove The Drainage Pipe
    ------------------------------------- 

    menu.action(tunables, "Remove The Drainage Pipe", {""}, "", function()
        DELETE_OBJECT_BY_HASH(joaat("prop_chem_grill_bit"))
    end)

    -------------------------------------
    -- Toggle Godmode for Vehicle Cargo
    -------------------------------------

    menu.toggle_loop(tunables, "Godmode for Vehicle Cargo", {""}, "Source Only. Relies on the Vehicle's blip.", function()
        if in_session() and players.get_boss(players.user()) == players.user() then
            for entities.get_all_vehicles_as_handles() as veh do
                if GET_BLIP_SPRITE(GET_BLIP_FROM_ENTITY(veh)) == 523 and GET_ENTITY_CAN_BE_DAMAGED(veh) and NETWORK_HAS_CONTROL_OF_ENTITY(veh) then
                    SET_ENTITY_CAN_BE_DAMAGED(veh, false)
                end
            end
        end
    end)

    -------------------------------------
    -- TP Inside Vehicle Cargo
    -------------------------------------

    menu.action(tunables, "TP Inside Vehicle Cargo", {"vc"}, "Source Only. Relies on the Vehicle's blip.", function()
        if in_session() and players.get_boss(players.user()) == players.user() then
            for entities.get_all_vehicles_as_handles() as veh do
                local bitset, owner = DECOR_GET_INT(veh, "MPBitset"), DECOR_GET_INT(veh, "ContrabandDeliveryType")
                if bitset == 11264 and owner == -81613951 then
                    SET_PED_INTO_VEHICLE(players.user_ped(), veh, -1)
                end
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
            menu.action(teleport, location_name, {$"tpl{location_name}"}, "", function()
                trigger_commands("doors on; nodeathbarriers on")
                if not IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then 
                    SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), location_coords.x, location_coords.y, location_coords.z, false, false, false)
                else
                    SET_PED_COORDS_KEEP_VEHICLE(players.user_ped(), location_coords.x, location_coords.y, location_coords.z)
                end
            end)
        end

    -------------------------------------
    -- Clear Area
    -------------------------------------

        menu.list_action(clear_area, "Clear All...", {""}, "", {{1, "Vehicles"}, {2, "Peds"}, {3, "Objects"}, {4, "Ropes"}}, function(index, name)
            notify($"Clearing {name}...")

            local total = 0
            switch index do
                case 1:
                    total = deleteEntities(1, #entities.get_all_vehicles_as_pointers(), "Vehicle")
                    break
                case 2:
                    total = deleteEntities(2, #entities.get_all_peds_as_pointers(), "Ped")
                    break
                case 3:
                    total = deleteEntities(3, #entities.get_all_objects_as_pointers(), "Object")
                    break
                case 4:
                    clearRopes:trigger()
                    break
            end

            notify($"Cleared {tostring(total)} {name}.")
        end)

        -- Clear Area All
        menu.action(clear_area, "Clear Area", {"ca"}, "Clears the Area around you without sending Freeze events.", function()
            local totalVehicles = deleteEntities(1, #entities.get_all_vehicles_as_pointers(), "Vehicle")
            local totalPeds = deleteEntities(2, #entities.get_all_peds_as_pointers(), "Ped")
            local totalObjects = deleteEntities(3, #entities.get_all_objects_as_pointers(), "Object")
            local totalPickups = deleteEntities(4, #entities.get_all_pickups_as_pointers(), "Pickup")

            clearRopes:trigger()

            local totalCount = totalPeds + totalVehicles + totalObjects + totalPickups
            if totalCount > 0 then
                notify($"Deleted {totalCount} entities!")
            end
        end)

    -------------------------------------
    -- Shortcuts
    -------------------------------------

        -------------------------------------
        -- Delete Vehicle
        -------------------------------------

        menu.action(shortcuts, "Delete Vehicle", {"dv"}, "Deletes your current ", function()
            trigger_commands("deletevehicle")
        end)

        -------------------------------------
        -- Grab Scrip Host
        -------------------------------------

        menu.action(shortcuts, "Grab Script Host", {"sh"}, "Grabs Script Host less destructively.", function()
            util.request_script_host("freemode")
        end)

        -------------------------------------
        -- Easy Way Out
        -------------------------------------

        menu.action(shortcuts, "Really easy Way out", {"kms", "kys"}, "Kill yourself.", function()
            local pos = players.get_position(players.user())
            ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z - 1.0, 5, 1.0, false, false, 1.0)
        end)

        -------------------------------------
        -- Stop all Sounds
        -------------------------------------

        menu.action(shortcuts, "Stop all sound events", {"stopsounds"}, "Stops all current Sounds from playing. Does not stop Scripted Music.", function()
            for i = 1, 99 do
                STOP_SOUND(i)
                RELEASE_SOUND_ID(i)
                STOP_PED_RINGTONE(players.user_ped())
            end
        end)

        -------------------------------------
        -- Start a CEO
        -------------------------------------

        if is_developer() then
            menu.action(shortcuts, "Start a CEO", {"ceo"}, "Starts a CEO", function()
                if StartCEO() then
                    wait(500)
                    trigger_commands("ceoname ¦ Rockstar")
                end
            end)
        else
            menu.action(shortcuts, "Start a CEO", {"ceo"}, "Starts a CEO", function()
                StartCEO()
            end)
        end

        -------------------------------------
        -- Buy Ammo
        -------------------------------------

        menu.action(shortcuts, "Buy Ammo", {"buyammo"}, "Buys ammo the legit way.", function()
            wait(500)
            if players.get_boss(players.user()) == -1 then
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

        menu.action(shortcuts, "Spawn Buzzard", {"requestbuzzard", "reqbuzzard", "b1"}, "Requests a CEO Buzzard.", function()
            if not StartCEO() then return end
            if players.get_boss(players.user()) != -1 then
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
    -- Disable Numpad
    -------------------------------------

    menu.toggle_loop(misc, "Disable Control Keys", {"disablecontrolkeys", "dn"}, "Disables certain Keys while Stand is open.", function()
        if not menu.is_open() then return end
        for numpadControls as control do
            DISABLE_CONTROL_ACTION(2, control, true)
        end
    end)

    -------------------------------------
    -- Disable Scripted Music
    -------------------------------------

    menu.toggle_loop(misc, "Disable Scripted Music", {""}, "", function()
        if AUDIO_IS_MUSIC_PLAYING() then
            TRIGGER_MUSIC_EVENT("GLOBAL_KILL_MUSIC") -- Credits to err_net_array for the Audio Name <3
        end
    end)

    -------------------------------------
    -- Toggle Thunder Weather
    -------------------------------------

    menu.toggle(misc, "Toggle Thunder Weather", {"thunder"}, "Requests Thunder Weather Session-wide.", function(toggled)
        if toggled then
            trigger_commands("weather normal")
            wait(1000)
            trigger_command(thunder_on)
            wait(10000)
            notify("Weather Set to Thunder.")
        else
            trigger_command(thunder_off)
            wait(10000)
            trigger_commands("weather extrasunny")
            notify("Weather set back to Normal.")
        end
    end)

    -------------------------------------
    -- Auto Accept Joining Games
    -------------------------------------

    menu.toggle_loop(misc, "Auto Accept Joining Games", {""}, "Will auto accept join screens.", function()
        local message_hash = GET_WARNING_SCREEN_MESSAGE_HASH()
        local hashes = {99184332, 15890625, -398982408, -587688989, 15890625}
        for hashes as hash do
            if message_hash == hash then
                SET_CONTROL_VALUE_NEXT_FRAME(2, 201, 1.0)
                wait(50)
            end
        end
    end)

    -------------------------------------
    -- Skip Warning Messages
    -------------------------------------

    menu.toggle_loop(misc, "Skip Warning Messages", {""}, "Skips annoying Warning Messages.", function()
        local message_hash = GET_WARNING_SCREEN_MESSAGE_HASH()
        local hashes = {1990323196, 1748022689, -396931869, -896436592, 583244483}
        for hashes as hash do
            if message_hash == hash then
                SET_CONTROL_VALUE_NEXT_FRAME(2, 201, 1.0)
                wait(50)
            end
        end
    end)

    -------------------------------------
    -- Rockstar Verified All
    -------------------------------------

    menu.toggle_loop(misc, "Rockstar Verified All", {""}, "You will always be Rockstar Verified with this. :troll240p:", function()
        if IS_CONTROL_JUST_PRESSED(1, 245) then
            chat.ensure_open_with_empty_draft(false)
            chat.add_to_draft("¦ ")
        end
    end)

    -------------------------------------
    -- No Traffic
    -------------------------------------

    local config = {
        disable_traffic = true,
        disable_peds = false,
    }
    local pop_multiplier_id

    menu.toggle(misc, "No Traffic", {""}, "Deletes all Traffic from the Map. Works Session-Wide.", function(toggled) -- Hexarobi
        if toggled then
            local ped_sphere, traffic_sphere
            if config.disable_peds then ped_sphere = 0.0 else ped_sphere = 1.0 end
            if config.disable_traffic then traffic_sphere = 0.0 else traffic_sphere = 1.0 end
            pop_multiplier_id = ADD_POP_MULTIPLIER_SPHERE(1.1, 1.1, 1.1, 15000.0, ped_sphere, traffic_sphere, false, true)
            CLEAR_AREA(1.1, 1.1, 1.1, 19999.9, true, false, false, true)
        else
            REMOVE_POP_MULTIPLIER_SPHERE(pop_multiplier_id, false);
        end
    end)

    -------------------------------------
    -- Show OS Date
    -------------------------------------

    menu.toggle_loop(misc, "Show OS Date", {""}, "Shows the current Day, Month and Time.", function()
        trigger_commands("infotime off")
        util.draw_debug_text(os.date("%a, %d. %B %X"))
    end)

    -------------------------------------
    -- Disable Phone
    -------------------------------------

    menu.toggle_loop(misc, "Disable Phone calls", {""}, "Disables Phone calls when certain conditions are met.", function()
        local phone = menu.ref_by_path("Game>Disables>Straight To Voicemail")
        if chat.is_open() or IS_PLAYER_FREE_AIMING(players.user()) or util.is_interaction_menu_open() or menu.is_open() then
            if not phone.value then
                phone.value = true
            end
        elseif phone.value then
            phone.value = false
        end
    end)

    -------------------------------------
    -- Disable Phone
    -------------------------------------

    menu.toggle(misc, "User Radio Everywhere", {""}, "", function()
        for emitterList as i do
            SET_EMITTER_RADIO_STATION(i, "RADIO_19_USER", true)
            SET_STATIC_EMITTER_ENABLED(i, true)
        end
    end)

    -------------------------------------
    -- Russian Roulette
    -------------------------------------

    menu.action(misc, "Russian Roulette", {""}, "Feeling Lucky?", function()
        local is_bullet_in_my_head = math.random(6)
        trigger_commands("skiprepeatwar on; commandsskip on")
        if is_bullet_in_my_head == 1 then
            notify("You have lost the Game.")
            log(os.date("On %A the %x at %X your game suffered a critical error and died. It will be remembered."))
            wait(1, "s")
            trigger_commands("yeet")
        else
            notify("You have won the Game.")
        end
    end)

-------------------------------------
-------------------------------------
-- AI Made Actions
-- Note that this is not fully made by ChatGPT. I still had to debug shitty code.
-------------------------------------
-------------------------------------

    -------------------------------------
    -- Countdown
    -------------------------------------

    menu.action(ai_made, "Race Countdown", {"countdown"}, "Start the countdown.", function()
        chat.send_message("Race Starting in: ", true, true, true)
        wait(200)
        for i = 5, 1, -1 do
            chat.send_message($"{i} . . .", true, true, true)
            wait(1, "s")
        end
        chat.send_message("GO!!!", true, true, true)
    end)

    -------------------------------------
    -- Remove Bounty
    -------------------------------------

    menu.toggle_loop(ai_made, "Remove Bounty", {"remove_bounty"}, "Automatically remove bounties.", function()
        local user = players.user()
        local has_bounty = players.get_bounty(user)

        if has_bounty and in_session() and not players.is_in_interior(user) then
            repeat
                trigger_commands("removebounty")
                wait(5, "s")
                bounty = players.get_bounty(players.user())
            until bounty == nil
            notify("Bounty has been Claimed.")
        end
        wait(20, "s")
    end)

    -------------------------------------
    -- Auto Skip Cutscenes
    -------------------------------------      

    menu.toggle_loop(ai_made, "Auto Skip Cutscenes", {"auto_skip_cutscenes"}, "Automatically skips cutscenes.", function()
        if IS_CUTSCENE_PLAYING() then
            repeat
                STOP_CUTSCENE_IMMEDIATELY()
                wait(10)
            until not IS_CUTSCENE_PLAYING()
            notify("Cutscene skipped!")
        end
    end)

    -------------------------------------
    -- Auto Skip Conversations
    -------------------------------------

    menu.toggle_loop(ai_made, "Auto Skip Conversations", {"auto_skip_conversations"}, "Automatically skips conversations.", function()
        if IS_SCRIPTED_CONVERSATION_ONGOING() then
            repeat
                STOP_SCRIPTED_CONVERSATION(false)
                wait(10)
            until not IS_SCRIPTED_CONVERSATION_ONGOING()
            notify("Conversation skipped!")
        end
    end)

-------------------------------------
-------------------------------------
-- [Debug]
-------------------------------------
-------------------------------------

for key, value in pairs(Modulepath) do
    if not io.isfile(value.absolute_path) then
        menu.action(modules, $"Download {value.name}", {""}, "", function()
            async_http.init("raw.githubusercontent.com", value.giturl, function(body, headers, status_code)
                if status_code != 404 then
                    local file = io.open(value.absolute_path, "w+")
                    file:write(body)
                    file:close()

                    notify("Instalation successful. Please restart the Script now!")
                else
                    notify($"Download failed. Status Code {status_code}.")
                end
            end, function(status_code)
                notify($"Download failed. Status Code {status_code}.")
            end)
            async_http.dispatch()
        end)
    else
        require(value.path)
        menu.action(modules, $"Remove {value.name}", {""}, "", function()
            os.remove(value.absolute_path)
            notify($"Removed {value.name}. Please restart the Script now.")
        end)
    end
end

-------------------------------------
-------------------------------------
-- [Debug]
-------------------------------------
-------------------------------------

if is_developer() then
    local sdebug = menu.list(menu.my_root(), "[Debug]", {"lenadebug"}, "")
    local nativec = menu.list(sdebug, "Native Feedback", {""}, "")

    -------------------------------------
    -- Easier Better Vehicles
    -------------------------------------

    local modified_vehicle = menu.readonly(sdebug, "Current Vehicle: ", "N/A")
    menu.toggle_loop(sdebug, "Better Vehicles", {"bv"}, "", function()
        if entities.get_user_vehicle_as_pointer(false) != 0 then
            wait(20)
            local vmodel = players.get_vehicle_model(players.user())
            local vname = util.get_label_text(vmodel)
            local CHandlingData = entities.vehicle_get_handling(entities.get_user_vehicle_as_pointer())
            local CflyingHandling = entities.handling_get_subhandling(CHandlingData, 1)
            if IS_PLAYER_PLAYING(players.user()) and GET_PED_IN_VEHICLE_SEAT(user_vehicle, -1, true) == players.user_ped() then

                if IS_THIS_MODEL_A_PLANE(vmodel) and menu.get_value(modified_vehicle, vname) != vname then
                    if vmodel == -1700874274 then
                        trigger_commands("vhengineoffglidemulti 10; vhgeardownliftmult 1")
                    else
                        for better_planes as offsets do
                            local handling = offsets[1]
                            local value = offsets[2]
                            memory.write_float(CflyingHandling + handling, value)

                        end
                    end
                    trigger_commands("fovfpinveh 90; gravitymult 2; fovtpinveh 100")
                    notify($"Better Planes have been enabled for {vname}.")
                elseif IS_THIS_MODEL_A_HELI(vmodel) and not util.is_this_model_a_blimp(vmodel) then
                    if math.ceil(memory.read_float(CflyingHandling + 0x8) * 100) != menu.ref_by_command_name("helithrust").value then
                        for better_heli_offsets as offset do
                            memory.write_float(CflyingHandling + offset, 0)
                        end
                        trigger_commands("gravitymult 1; helithrust 2.3")
                        notify($"Better Helis have been enabled for {vname}.")
                    end
                elseif menu.get_value(modified_vehicle, vname) != vname then
                    trigger_commands("gravitymult 1; fovfpinveh -5; fovtpinveh -5")
                end
                menu.set_value(modified_vehicle, vname)
            end
        elseif menu.get_value(modified_vehicle, vname) != "N/A" then
            menu.set_value(modified_vehicle, "N/A")
        end
    end)

    -------------------------------------
    -- Enhanced Downforce
    -------------------------------------

    menu.toggle_loop(sdebug, "Enhanced Downforce", {""}, "", function()
        enhanceDownforce()
    end)

    -------------------------------------
    -- Increase Weapon Range
    -------------------------------------

    local modifiedRange = {}
    menu.toggle_loop(sdebug, "Increase Weapon Range", {""}, "", function()
        if util.is_session_transition_active() then return end
        if players.is_in_interior(players.user()) then return end
        local user = players.user_ped()
        local weaponHash, vehicleWeapon = getWeaponHash(user)
        if modifiedRange[weaponHash] then return end
        local pointer = (vehicleWeapon and 0x70 or 0x20)
        local PedPointer = entities.handle_to_pointer(user)
        modifiedRange[weaponHash] = {
            minAddress   = addr_from_pointer_chain(PedPointer, {0x10B8, pointer, 0x178}),
            maxAddress   = addr_from_pointer_chain(PedPointer, {0x10B8, pointer, 0x28C}), -- m_weapon_range
            rangeAddress = addr_from_pointer_chain(PedPointer, {0x10B8, pointer, 0x288}), -- m_lock_on_range
        }

        if modifiedRange[weaponHash].rangeAddress != 0 then
            modifiedRange[weaponHash].originalMax   = memory.read_float(modifiedRange[weaponHash].maxAddress)
            modifiedRange[weaponHash].originalRange = memory.read_float(modifiedRange[weaponHash].rangeAddress)
            memory.write_float(modifiedRange[weaponHash].maxAddress,   10000)
            memory.write_float(modifiedRange[weaponHash].rangeAddress, 10000)
        end
    end)

    debug_hk = menu.action(sdebug, "Kick Host", {"hk"}, $"Kick {players.get_name(players.get_host())}", function()
        if not NETWORK_IS_HOST() then
            trigger_commands($"kick{players.get_name(players.get_host())}")
        end
    end)

    initial_money = get_current_money()
    menu.toggle_loop(sdebug, "Transaction Log", {}, "", function(toggled)
        if not util.is_session_started() and util.is_session_transition_active() or util.is_interaction_menu_open() then return end
        if get_current_money() != initial_money then
            check_and_write_money_change()
        end
        wait(1, "s")
    end)

    menu.action(sdebug, "Set Webhook Url", {"setwebhookurl"}, "", function()
        menu.show_command_box("setwebhookurl "); end, function(webhook_url)
        if string.startswith(webhook_url, "https://discord.com/api/webhooks") or string.startswith(webhook_url, "https://canary.discord.com/api/webhooks") then
            webhook_url = string.sub(webhook_url, string.find(webhook_url, "/api"))
            write_data_to_file(lenaDir.."Saved Players Webhook.txt", webhook_url)
        else
            util.toast("Invalid URL make sure it starts with: \"https://discord.com/api/webhooks\" or \"https://canary.discord.com/api/webhooks\".")
        end
    end)
    local web_file = io.open(lenaDir.."Saved Players Webhook.txt", "r")
    local webhook_url = web_file:read("a")
    web_file:close()

    local music_vol_memory_address = memory.scan("") + 0x1FE5E38 -- Credits to err_net_array
    radio_volume_ref = menu.click_slider_float(sdebug, "Radio Volume", {"modifyradiovolume"}, "This might earrape you... have fun!", 0, 100000, memory.read_byte(music_vol_memory_address) * 100, 100, function()
        local value = (menu.get_value(radio_volume_ref) / 100)
        original_music_volume = value
        memory.write_byte(music_vol_memory_address, value)
    end)

    menu.action(sdebug, "Save User Vehicle", {"saveuservehicle", "suv", "saveuserveh", "saveveh"}, "", function(click_type)
        menu.show_command_box("saveveh "); end, function(input)
        local name = string.lstrip(input, "saveveh ")
        local baseName = name
        local vehicleIndex = 0
        local function generateVehicleName()
            return vehicleIndex == 0 and baseName or baseName .. " " .. vehicleIndex
        end

        local vehicleName = generateVehicleName()
        while io.isfile(filesystem.stand_dir().."Vehicles/"..vehicleName..".txt") do
            vehicleIndex = vehicleIndex + 1
            vehicleName = generateVehicleName()
        end

        trigger_commands("savevehicle "..vehicleName)
        notify("Saved as: " .. vehicleName)
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

        menu.action(nativehud, "Get Warning Screen hash", {""}, "", function()
            local hash = GET_WARNING_SCREEN_MESSAGE_HASH()
            if hash then
                log($"[Lena | Debug] Warning Screen hash: {hash}.")
            end
        end)

        -------------------------------------
        -- VEHICLE
        -------------------------------------

        menu.action(nativevehicle, "Get Vehicle", {""}, "Gets The current Model and Name.", function()
            local user = players.user()
            local vname = lang.get_localised(util.get_label_text(players.get_vehicle_model(user)))
            local vmodel = players.get_vehicle_model(user)
            local modelname = util.reverse_joaat(vmodel)
            local plate_text = GET_VEHICLE_NUMBER_PLATE_TEXT(user_vehicle)
            local bitset = DECOR_GET_INT(user_vehicle, "MPBitset")
            local blip = GET_BLIP_SPRITE(GET_BLIP_FROM_ENTITY(vmodel))
            notify($"Hash: {vmodel}\nName: {vname}\nJoaat: {modelname}\nBitset: {bitset}")
            log($"[Lena | Debug] Hash: {vmodel} | Name: {vname} | Joaat: {modelname} | Bitset: {bitset} | Blip: {blip} | Plate:{plate_text}.")
        end)
        menu.action(nativevehicle, "Get Decorators", {""}, "Get set decorators from ", function()
            local ints = {
                "FMDeliverableID", 
                "Not_Allow_As_Saved_Veh",
                "MPBitset",
                "Player_Vehicle",
                "Player_Hacker_Truck",
                "CreatedByPegasus",
                "PYV_Owner",
                "MC_EntityID",
                "MatchId",
                "MissionType",
                "RespawnVeh",
                "Player_Owned_Veh",
                "GBMissionFire",
                "Veh_Modded_By_Player",
                "bombdec",
                "bombowner",
                "Previous_Owner",
                "ExportVehicle",
                "ContrabandOwner",
                "ContrabandDeliveryType",
                "VehicleList"
            }
            local bools = {
                "UsingForTimeTrial"
            }
            local v = user_vehicle
            for ints as i do
                print($"int {i} = {DECOR_GET_INT(v, i)}")
                wait(50)
            end
            for bools as i do
                print($"bool {i} = {DECOR_GET_BOOL(v, i)}")
                wait(50)
            end
        end)
        menu.action(nativevehicle, "Set Number Plate", {"randomplate"}, "Sets the Current Number Plate to a random Text.", function()
            local plate_texts = {"VEROSA", "LOVE", "LOVE YOU", "TOCUTE4U", "TOFAST4U", "LENA", "LENALEIN", "HENTAI", "FNIX", "SEXY", "CUWUTE", " ", "2TAKE1", "WHORE"}
            SET_VEHICLE_NUMBER_PLATE_TEXT(user_vehicle, plate_texts[math.random(#plate_texts)])
        end)

        -------------------------------------
        -- ENTITY
        -------------------------------------

        menu.action(nativeentity, "Clone Player", {""}, "Clones the Player ", function()
            local whore = CLONE_PED(players.user_ped(), true, true, true)
            local cords = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), -5.0, 0.0, 0.0)
            SET_ENTITY_COORDS(whore, cords)
            -- FREEZE_ENTITY_POSITION(whore, true)
            -- TASK_START_SCENARIO_IN_PLACE(whore, "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS", 0, false) -- Shrugs
        end)
        menu.toggle_loop(nativeentity, "Get Entity", {""}, "", function()
            if IS_PLAYER_FREE_AIMING(players.user()) then
                local e = _GET_LAST_ENTITY_HIT_BY_ENTITY(players.user_ped())
                if e != (0 or nil or "") then
                    print(e)
                end
            end
        end)
--  end
end

--------------------------------------------------------------------------------
------------------------------- PLAYER FEATURES --------------------------------
--------------------------------------------------------------------------------

players.add_command_hook(function(pid, cmd)
    local pname = players.get_name(pid)
    local rids = players.get_rockstar_id(pid)
    local hex = decimalToHex(rids, 32)

    if is_player_in_blacklist(decimalToHex(rids)) then
        trigger_commands($"historyblock{pname} on")
        trigger_commands($"loveletter{pname}")
        wait(1, "s")
    end

    menu.divider(cmd, "Lena Utilities")
    local lena = menu.list(cmd, "Lena Utilities", {"lenau"}, "")

    local friendly = menu.list(lena, "Friendly", {""}, "")

    local mpvehicle = menu.list(lena, "Vehicle", {""}, "")

    local trolling = menu.list(lena, "Trolling", {""}, "")
    local customExplosion = menu.list(trolling, "Custom Explosion", {""}, "")
    local mpcage = menu.list(trolling, "Cage", {""}, "")
    local vehattack = menu.list(trolling, "Attackers", {""}, "")

    local player_removals = menu.list(lena, "Player Removals", {""}, "")
    local kicks = menu.list(player_removals, "Kicks", {""}, "")
    local crashes = menu.list(player_removals, "Crashes", {""}, "")

    menu.action(lena, "Mark As Modder", {"manual"}, $"Mark {pname} manually as a Modder.", function()
        if not IsDetectionPresent(pid, "Manual") then
            players.add_detection(pid, "Manual", 7, 100)
        end
    end)
    menu.action(lena, "Add to Blacklist", {""}, "", function()
        if not is_player_in_blacklist(decimalToHex(rids)) then
            add_player_to_blacklist(decimalToHex(rids))
        end
    end)

    -------------------------------------
    -------------------------------------
    -- Friendly
    -------------------------------------
    -------------------------------------

        -------------------------------------
        -- Save Player Info
        -------------------------------------

        menu.action(friendly, "Save Player Info", {"saveplayer", "savep"}, "Save a player's information to a file.", function()
            save_player_info(pid)
        end)

        -------------------------------------
        -- Summon
        -------------------------------------        

        menu.action(friendly, "TP to Me", {"tptome"}, "Improved \"summon\" Command", function()
            trigger_commands($"givesh{pname}")
            wait(100)
            trigger_commands($"summon{pname}")
        end)

        -------------------------------------
        -- Invite to CEO/MC
        -------------------------------------

        menu.action(friendly, "Invite to CEO/MC", {"ceoinv"}, "Invites the Player to your CEO/", function()
            sendse(1 << pid, {
                -245642440, -- am_pi_menu.c
                players.user(),
                4,
                10000,
                0, 0, 0, 0,
                memory.read_int(memory.script_global(1916087 + 9)), -- *uParam0 = Global_1916087.f_9;
                memory.read_int(memory.script_global(1916087 + 10)), -- *uParam1 = Global_1916087.f_10;
            })
        end)

        -------------------------------------
        -- Fix Blackscreen
        -------------------------------------         

        menu.action(friendly, "Fix Blackscreen", {"fixblackscreen"}, $"Tries to fix a stuck Blackscreen for {pname}", function()
            trigger_commands($"givesh {pname}; aptme {pname}")
        end)

        -------------------------------------
        -- Set Waypoint
        -------------------------------------

        menu.action(friendly, "Set Waypoint", {"setwp"}, "", function()
            local pos = players.get_position(pid)
            SET_NEW_WAYPOINT(pos.x, pos.y)
        end)

        -------------------------------------
        -- Stealth Messages
        -------------------------------------

        menu.action(friendly, "Stealth msg", {"pm"}, "Sends a Stealth Message.", function(click_type)
            menu.show_command_box($"pm{pname} "); end, function(on_command)
            if #on_command > 140 then
                notify("The message is to long.")
            else
                chat.send_targeted_message(pid, players.user(), on_command, false)
                chat.send_message(on_command, false, true, false)
            end
        end)

        menu.toggle_loop(friendly, "Stealth Messages", {""}, "Works the same as 'Stealth msg' but you won't need to press it everytime. It uses the normal Chat.", function()
            if IS_CONTROL_JUST_PRESSED(1, 245) then
                repeat chat.close() until not chat.is_open()
                menu.show_command_box($"pm{pname:lower()} ")
            end
        end)

        -------------------------------------
        -- Teleport to Player
        -------------------------------------

        menu.action(friendly, "Teleport to Player", {""}, $"Teleport to {pname}.", function()
            local player = GET_PLAYER_PED_SCRIPT_INDEX(pid)
            SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(player, 0.0, 2, 0), false, false, false)
        end)

        -------------------------------------
        -- Save Outfit
        -------------------------------------

        menu.action(friendly, "Save Player Outfit", {"saveplayeroutfit", "spo"}, $"Save {pname}'s Outfit.", function(click_type)
            menu.show_command_box($"saveplayeroutfit{pname} "); end, function(name)
                local n = string.lstrip(name, $"saveplayeroutfit{pname} ")
                save_player_outfit(pid, n)
        end)

    -------------------------------------
    -------------------------------------
    -- Vehicle
    -------------------------------------
    -------------------------------------

        -------------------------------------
        -- GOD MODE
        -------------------------------------

        menu.toggle(mpvehicle, "God Mode", {"vgm"}, "Toggles Vehicle Godmode.", function(on)
            local veh = get_vehicle_ped_is_in(pid)
            if veh and request_control(veh, true) then
                SET_VEHICLE_ENVEFF_SCALE(veh, 0.0)
                SET_VEHICLE_BODY_HEALTH(veh, 1000.0)
                SET_VEHICLE_ENGINE_HEALTH(veh, 1000.0)
                SET_VEHICLE_FIXED(veh)
                SET_VEHICLE_DEFORMATION_FIXED(veh)
                SET_VEHICLE_PETROL_TANK_HEALTH(veh, 1000.0)
                SET_VEHICLE_DIRT_LEVEL(veh, 0.0)
                for i = 0, 10 do
                    SET_VEHICLE_TYRE_FIXED(veh, i)
                end
                SET_ENTITY_INVINCIBLE(veh, on)
                SET_ENTITY_PROOFS(veh, on, on, on, on, on, on, true, on)
                SET_DISABLE_VEHICLE_PETROL_TANK_DAMAGE(veh, on)
                SET_DISABLE_VEHICLE_PETROL_TANK_FIRES(veh, on)
                SET_VEHICLE_CAN_BE_VISIBLY_DAMAGED(veh, not on)
                SET_VEHICLE_CAN_BREAK(veh, not on)
                SET_VEHICLE_ENGINE_CAN_DEGRADE(veh, not on)
                SET_VEHICLE_EXPLODES_ON_HIGH_EXPLOSION_DAMAGE(veh, not on)
                SET_VEHICLE_TYRES_CAN_BURST(veh, not on)
                SET_VEHICLE_WHEELS_CAN_BREAK(veh, not on)
            end
        end)

        -------------------------------------
        -- Repair Vehicle
        -------------------------------------

        menu.action(mpvehicle, "Repair Vehicle", {"rpv"}, "Repais the current ", function()
            local veh = get_vehicle_ped_is_in(pid)
            if veh and request_control(veh, true) then
                SET_VEHICLE_FIXED(veh)
                SET_VEHICLE_DEFORMATION_FIXED(veh)
                SET_VEHICLE_DIRT_LEVEL(veh, 0.0)
            end
        end)

        -------------------------------------
        -- Clean Vehicle
        -------------------------------------

        menu.action(mpvehicle, "Clean Vehicle", {"cleanv"}, "Cleans the current ", function()
            local veh = get_vehicle_ped_is_in(pid)
            if veh and request_control(veh, true) then
                SET_VEHICLE_DIRT_LEVEL(veh, 0.0)
            end
        end)

        -------------------------------------
        -- Launch Player Vehicle
        -------------------------------------

        menu.textslider_stateful(mpvehicle, "Launch Player Vehicle", {"launch"}, "Launches the Player's Vehicle in the Selected direction.", launch_vehicle, function(index, value)
            local veh = get_vehicle_ped_is_in(pid)
            request_control(veh)
            switch value do
                case "Launch Up":
                    APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 0.0, 100000.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                    break
                case "Launch Forward":
                    APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 100000.0, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                    break
                case "Launch Backwards":
                    APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, -100000.0, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                    break
                case "Launch Down":
                    APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 0.0, -100000.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                    break
                case "Slingshot":
                    APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 0.0, 100000.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                    APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 100000.0, 0.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                    break
                end
        end)

        -------------------------------------
        -- Hurricane
        -------------------------------------

        menu.toggle(mpvehicle, "Hurricane", {""}, "", function(toggled)
            local ram = menu.ref_by_rel_path(menu.player_root(pid), "Trolling>Ram>Ram")
            local speed = menu.ref_by_rel_path(menu.player_root(pid), "Trolling>Ram>Speed")
            local veh = menu.ref_by_rel_path(menu.player_root(pid), "Trolling>Ram>Vehicle>Military>TM-02 Khanjali")
            trigger_command(veh); speed.value = 200
            usinghurricane = toggled
            while usinghurricane and not IS_PLAYER_DEAD(pid) do
                trigger_command(ram)
                wait(100)
            end
        end)

    -------------------------------------
    -------------------------------------
    -- Trolling
    -------------------------------------
    -------------------------------------

        -------------------------------------
        -- Cage
        -------------------------------------

            -------------------------------------
            -- AUTOMATIC
            -------------------------------------

            local cagePos
            auto_cage = menu.toggle_loop(mpcage, "Automatic Cage", {"autocage"}, "Automatically Cages the ", function()
                if not players.exists(pid) then
                    util.stop_thread()
                    auto_cage.value = false
                    return
                end
                local targetPed = GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local playerPos = GET_ENTITY_COORDS(targetPed, false)
                if not cagePos or cagePos:distance(playerPos) >= 4.0 then
                    CLEAR_PED_TASKS_IMMEDIATELY(targetPed)
                    if IS_PED_IN_ANY_VEHICLE(targetPed, false) then return end
                    cagePos = playerPos
                    if pname != "**Invalid**" then
                        notify($"{pname} was out of the cage!")
                        trapcage(pid, "prop_gold_cont_01", true)
                    end
                end
            end)

            -------------------------------------
            -- Small Cage
            -------------------------------------

            menu.action(mpcage, "Small Cage", {""}, "", function()
                CLEAR_PED_TASKS_IMMEDIATELY(GET_PLAYER_PED_SCRIPT_INDEX(pid))
                wait(250)
                trapcage(pid, "prop_gold_cont_01", true)
            end)

            -------------------------------------
            -- Small Invisible Cage
            -------------------------------------

            menu.action(mpcage, "Small Invisible Cage", {""}, "", function()
                CLEAR_PED_TASKS_IMMEDIATELY(GET_PLAYER_PED_SCRIPT_INDEX(pid))
                wait(250)
                trapcage(pid, "prop_gold_cont_01", false)
            end)

            -------------------------------------
            -- Invisible Cage
            -------------------------------------

            local elevatorPOS
            elevator_cage = menu.toggle_loop(mpcage, "Invisible Cage", {""}, "", function()
                if not players.exists(pid) then
                    util.stop_thread()
                    elevator_cage.value = false
                    return
                end
                if not elevatorPOS or elevatorPOS:distance(players.get_position(pid)) >= 6.0 then
                    CLEAR_PED_TASKS_IMMEDIATELY(GET_PLAYER_PED_SCRIPT_INDEX(pid))
                    wait(250)
                    local spawnped, spawncage = "u_m_m_jesus_01", "prop_test_elevator"
                    elevatorPOS = players.get_position(pid)
                    local temp_ped = spawn_ped(spawnped, players.get_position(pid), true)
                    if IS_ENTITY_A_PED(temp_ped) then
                        SET_ENTITY_VISIBLE(temp_ped, false)
                        SET_PED_CONFIG_FLAG(temp_ped, 62, 1)
                        FREEZE_ENTITY_POSITION(temp_ped, true)
                        local cage1, cage2 = spawn_obj(spawncage, players.get_position(pid)), spawn_obj(spawncage, players.get_position(pid))
                        SET_ENTITY_VISIBLE(temp_ped, true)
                        ATTACH_ENTITY_TO_ENTITY(cage1, temp_ped, 0, 0,0,0, 0,0,180, true, true, true, false, 0, true, 0)
                        PROCESS_ENTITY_ATTACHMENTS(temp_ped)
                        ATTACH_ENTITY_TO_ENTITY(cage2, temp_ped, 0, 0,0,0, 0,0,-90, true, true, true, false, 0, true, 0)
                        PROCESS_ENTITY_ATTACHMENTS(temp_ped)
                        SET_ENTITY_VISIBLE(temp_ped, false)
                        spawned_cages[#spawned_cages + 1] = cage1; spawned_cages[#spawned_cages + 1] = cage2
                    else
                        entities.delete_by_handle(temp_ped)
                    end
                    if pname != "**Invalid**" then
                        notify($"{pname} was out of the cage!")
                    end
                end
                wait(1000)
            end)

            -------------------------------------
            -- Delete all Cages
            -------------------------------------

            menu.action(mpcage, "Delete all Cages", {""}, "", function()
                local entitycount = 0
                for i, object in spawned_cages do
                    SET_ENTITY_AS_MISSION_ENTITY(object, false, false)
                    entities.delete_by_handle(object)
                    spawned_cages[i] = nil
                    entitycount = entitycount + 1
                end
                notify($"Cleared {entitycount} Spawned Cages")
                spawned_cages = {}
            end)

        -------------------------------------
        -- Attackers
        -------------------------------------

        attack_ent_gm = menu.toggle(vehattack, "Enable Godmode", {""}, "", function(); end)

        -------------------------------------
        -- Tank
        -------------------------------------

        menu.action(vehattack, "Send Tank", {""}, "", function()
            local gm = menu.get_value(attack_ent_gm)
            local player_ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local spawn_pos = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(player_ped, 30.0, -30.0, 0.0)
            local ped, vehicle = spawn_ped("s_m_y_blackops_01", spawn_pos, gm), spawn_vehicle("rhino", spawn_pos, gm)
            SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(VEH_TO_NET(vehicle), true)
            SET_PED_INTO_VEHICLE(ped, vehicle, -1)
            SET_PED_COMBAT_ATTRIBUTES(ped, 3, false)
            SET_PED_COMBAT_ATTRIBUTES(ped, 5, true)
            SET_PED_COMBAT_ATTRIBUTES(ped, 46, true)
            TASK_COMBAT_PED(ped, player_ped, 0, 16)
            TASK_VEHICLE_CHASE(ped, player_ped)
            STOP_PED_SPEAKING(ped, true)
            SET_PED_ACCURACY(ped, 100.0)
            SET_PED_SHOOT_RATE(ped, 1000)
            SET_VEHICLE_DOORS_LOCKED(vehicle, 2)
            local blip = ADD_BLIP_FOR_ENTITY(vehicle)
            SET_BLIP_SPRITE(blip, 421)
            SET_BLIP_COLOUR(blip, 2)
            entities.set_can_migrate(entities.handle_to_pointer(vehicle), false)
            spawned_attackers[#spawned_attackers + 1] = ped; spawned_attackers[#spawned_attackers + 1] = vehicle
        end)

        -------------------------------------
        -- Delete all Attackers
        -------------------------------------

        menu.action(vehattack, "Delete all Attackers", {""}, "", function()
            local entitycount = 0
            for i, object in spawned_attackers do
                SET_ENTITY_AS_MISSION_ENTITY(object, false, false)
                entities.delete_by_handle(object)
                spawned_attackers[i] = nil
                entitycount = entitycount + 1
            end
            notify($"Cleared {entitycount} Attackers")
            spawned_attackers = {}
        end)

        -------------------------------------
        -- Send To Online Intro
        -------------------------------------        

        menu.action(trolling, "Send To Online Intro", {"intro"}, "Sends player to the GTA Online intro.", function()
            local int = memory.read_int(memory.script_global(1895156 + 1 + (pid * 609) + 511)) --Global_1895156[PLAYER::PLAYER_ID() /*609*/].f_511;
            sendse(1 << pid, {-366707054, players.user(), 20, 0, 0, 48, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, int})
            sendse(1 << pid, {1757622014, players.user(), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
        end)

        -------------------------------------
        -- Force 1v1
        -------------------------------------   
        
        menu.action(trolling, "Force 1v1", {"1v1"}, "Forces them into a 1v1.", function()
            local int = memory.read_int(memory.script_global(1895156 + 1 + (pid * 609) + 511))
            sendse(1 << pid, {-366707054, players.user(), 197, 0, 0, 48, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, int})
            sendse(1 << pid, {1757622014, players.user(), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
        end)

        -------------------------------------
        -- Unfair Triggerbot
        -------------------------------------

        paimbor = menu.toggle_loop(trolling, "Unfair Triggerbot", {"triggerbot"}, "It tries to Aim for the head, but chances are low if they are moving.", function()
            if not players.exists(pid) then paimbor.value = false; util.stop_thread() end
            if pid == players.user() then
                notify(lang.get_localised(-1974706693))
                paimbor.value = false
                util.stop_thread()
            end
            local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local wpn = GET_SELECTED_PED_WEAPON(players.user_ped())
            local dmg = ROUND(GET_WEAPON_DAMAGE(wpn, 0))
            local delay = GET_WEAPON_TIME_BETWEEN_SHOTS(wpn)
            local wpnEnt = GET_CURRENT_PED_WEAPON_ENTITY_INDEX(PLAYER_PED_ID(), -1)
            local wpnCoords = GET_ENTITY_BONE_POSTION(wpnEnt, GET_ENTITY_BONE_INDEX_BY_NAME(wpnEnt, "gun_muzzle"))
            if GET_ENTITY_ALPHA(ped) < 255 then return end
            if IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), ped) and not IS_PED_RELOADING(players.user_ped()) then
                local t1 = GET_PED_BONE_COORDS(ped, 31086, 0, -0.1, 0)
                local t2 = GET_PED_BONE_COORDS(ped, 31086, 0, 0.1, 0)
                local pveh = GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
                SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(t1.x, t1.y, t1.z, t2.x, t2.y, t2.z, dmg, true, wpn, players.user_ped(), false, true, 10000, pveh)
                SET_CONTROL_VALUE_NEXT_FRAME(0, 24, 1.0)
                wait(delay * 1000)
            end
        end)

        -------------------------------------
        -- Rocket Aimbot
        -------------------------------------

        menu.toggle_loop(trolling, "Rocket Aimbot", {"rocketaimbot"}, "Distance is limited to 500 Meters.", function()
            if not players.exists(pid) then util.stop_thread() end
            local ped, user = GET_PLAYER_PED_SCRIPT_INDEX(pid), players.user_ped()
            local pos = players.get_position(pid)
            local ped_dist = v3.distance(players.get_position(user), players.get_position(pid))
            local control = IS_CONTROL_PRESSED(0, 69) or IS_CONTROL_PRESSED(0, 70) or IS_CONTROL_PRESSED(0, 76)
            if not IS_PLAYER_PLAYING(ped) and control and ped_dist <= 500.0 and HAS_ENTITY_CLEAR_LOS_TO_ENTITY(user, ped, 17) then
                SET_VEHICLE_SHOOT_AT_TARGET(user, ped, pos.x, pos.y, pos.z+1)
            end
        end)

        -------------------------------------
        -- HOSTILE TRAFFIC
        -------------------------------------

        menu.toggle_loop(trolling, "Hostile Traffic", {""}, "Traffic will become Hostile to the ", function()
            if not players.exists(pid) then return end
            local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
            for get_vehicles_in_player_range(pid, 70.0) as vehicle do
                if GET_ACTIVE_VEHICLE_MISSION_TYPE(vehicle) != 6 then
                    local driver = GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
                    if DOES_ENTITY_EXIST(driver) and not IS_PED_A_PLAYER(driver) then
                        request_control(driver)
                        SET_PED_MAX_HEALTH(driver, 300)
                        SET_ENTITY_HEALTH(driver, 300, 0)
                        SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(driver, true)
                        TASK_VEHICLE_MISSION_PED_TARGET(driver, vehicle, ped, 6, 100.0, 0, 0.0, 0.0, true)
                    end
                end
            end
        end)
            
        -------------------------------------
        -- Kill Player Inside Interior
        -------------------------------------

        menu.action(trolling, "Force Player Outside of Interior", {""}, "", function()
            local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local pos = players.get_position(pid)
            local glitch_hash, mdl = util.request_model("prop_windmill_01"), util.request_model("brickade2")
            for interior_stuff as id do
                if GET_INTERIOR_FROM_PLAYER(pid) == id then
                    notify($"{pname} isn't in an Interior. :/")
                return end
            end
            for i = 0, 3 do
                local obj = entities.create_object(glitch_hash, pos)
                local veh = entities.create_vehicle(mdl, pos, 0)
                SET_ENTITY_VISIBLE(obj, false)
                SET_ENTITY_VISIBLE(veh, false)
                SET_ENTITY_INVINCIBLE(veh, true)
                SET_ENTITY_COLLISION(obj, true, true)
                APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 10.0, 10.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                wait(250)
                entities.delete(obj); entities.delete(veh)
                wait(250)
            end
        end)

        -------------------------------------
        -- Bounty Loop
        -------------------------------------

        bounty_loop = menu.toggle_loop(trolling, "Bounty Loop", {"bountyloop", "bloop"}, "Will set the Players bounty always to 9000.", function(on)
            if not players.exists(pid) then bounty_loop.value = false; util.stop_thread() end
            local bounty, interior = players.get_bounty(pid), players.is_in_interior(pid)
            if not (bounty and interior) then
                trigger_commands($"bounty {pname} 9000")
                notify($"Bounty set on: {pname}.")
                wait(10000)
            end
        end)

        -------------------------------------
        -- EXPLOSIONS
        -------------------------------------

        menu.action(customExplosion, "Explode", {""}, "", function()
            ADD_EXPLOSION(players.get_position(pid), 1, 1.0, false, true, 0.0, false)
        end)
        menu.action(customExplosion, "Owned Explode", {""}, "", function()
            ADD_OWNED_EXPLOSION(players.user_ped(), players.get_position(pid), 1, 1.0, false, true, 0.0)
        end)

        -------------------------------------
        -- Orbital Cannon
        -------------------------------------

        menu.action(customExplosion, "Orbital Cannon", {"nuke"}, "Spawns the explosion on the selected ", function()
            local becomeorb = menu.ref_by_path("Online>Become The Orbital Cannon")
            becomeorb.value = true
                wait(200)
                while not HAS_NAMED_PTFX_ASSET_LOADED("scr_xm_orbital") do
                    REQUEST_NAMED_PTFX_ASSET("scr_xm_orbital")
                    wait(0)
                end
                USE_PARTICLE_FX_ASSET("scr_xm_orbital")
                START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD("scr_xm_orbital_blast", players.get_position(pid), 0, 180, 0, 1.0, true, true, true)
                for i = 1, 4 do
                    PLAY_SOUND_FROM_ENTITY(-1, "DLC_XM_Explosions_Orbital_Cannon", GET_PLAYER_PED_SCRIPT_INDEX(pid), 0, true, 1)
                end
                ADD_OWNED_EXPLOSION(players.user_ped(), players.get_position(pid), 59, 1.0, true, false, 0.0)
                wait(5000)
            becomeorb.value = false
        end)
  
        -------------------------------------
        -- Explosion Loop
        -------------------------------------

        local usingExplosionLoop = false
        menu.slider(customExplosion, "Loop Speed", {"expspeed"}, "", 50, 10000, 1000, 10, function(value)
            local delay = value 
        end)
        menu.toggle(customExplosion, "Owned Explosion Loop", {""}, "", function(on)
            usingExplosionLoop = on
            while usingExplosionLoop and is_player_active(pid, false, true) and not util.is_session_transition_active() do
                ADD_OWNED_EXPLOSION(players.user_ped(), players.get_position(pid), 1, 1.0, false, true, 0.0)
                wait(delay)
            end
        end)
        menu.toggle(customExplosion, "Explosion Loop", {""}, "", function(on)
            usingExplosionLoop = on
            while usingExplosionLoop and is_player_active(pid, false, true) and not util.is_session_transition_active() do
                ADD_EXPLOSION(players.get_position(pid), 1, 1.0, true, false, 0.0, false)
                wait(delay)
            end
        end)

        -------------------------------------
        -- Disable Passive
        -------------------------------------

        menu.action(trolling, "Disable Passive Mode", {"pussive"}, "Disables passive mode for the selected  May not always work.", function()
            trigger_commands($"givesh "..players.get_name(players.user()))
            wait(500)
            trigger_commands($"bounty {pname} 1000")
            wait(1000)
            trigger_commands($"mission {pname}")
            wait(3000)
            notify("Passive mode should be dissabled now.")
        end)

        -------------------------------------
        -- Ghost to User
        -------------------------------------

        menu.toggle(trolling, "Ghost Player", {"ghost", "g"}, "Makes you ghosted to that ", function(toggled)
            if pid == players.user() then notify(lang.get_localised(-1974706693)); trigger_commands($"ghost{pname} off") end
            SET_REMOTE_PLAYER_AS_GHOST(pid, toggled)
        end)

        -------------------------------------
        -- Clone Player
        -------------------------------------

        menu.action(trolling, "Clone Player", {""}, "", function()
            local player = GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local clone = CLONE_PED(player, false, true)
            local cords = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(player, -5.0, 0.0, 0.0)
            SET_ENTITY_COORDS(clone, cords)
            entities.set_can_migrate(clone, false)
        end)

    -------------------------------------
    -------------------------------------
    -- Kicks & Crashes
    -------------------------------------
    -------------------------------------

        -------------------------------------
        -- Block Join Kick
        -------------------------------------

        menu.action(kicks, "Block Kick", {"emp", "block"}, $"Will kick and block {pname} from joining you ever again.", function()
            if pid == players.user() then notify(lang.get_localised(-1974706693)) return end
            if menu.get_value(savekicked) then trigger_commands($"savep {pname}") end
            add_player_to_blacklist(rids)

            wait(500)
            trigger_commands($"historyblock{pname} on")
            if not is_developer() then
                log($"{pname} ({rids}) has been Kicked and Blocked.")
            else
                log($"{pname} ({rids} / {hex}) has been Kicked and Blocked.")
            end
            trigger_commands($"kick{pname}")
        end)

        menu.action(kicks, "Rape", {"rape"}, "A Unblockable kick that won't tell the target or non-hosts who did it.", function()
            if pid == players.user() then notify(lang.get_localised(-1974706693)) return end
            if menu.get_value(savekicked) then trigger_commands($"savep {pname}") end

            wait(500)
            trigger_commands($"loveletter{pname}")
            if not is_developer() then
                log($"{pname} ({rids}) has been Kicked.")
            else
                log($"{pname} ({rids} / {hex}) has been Kicked.")
            end
        end)

        menu.action(kicks, "Host Kick", {"hostkick", "hokick"}, "Only works as Host.", function()
            if pid == players.user() then notify(lang.get_localised(-1974706693)) return end
            if menu.get_value(savekicked) then trigger_commands($"savep {pname}") end

            wait(500)
            if NETWORK_IS_HOST() then
                NETWORK_SESSION_KICK_PLAYER(pid)
            end
        end)

        -------------------------------------
        -- Cwashes | No Idea Why I did this
        -------------------------------------

        menu.action(crashes, "Block Join Crash", {"gtfo", "netcrash"}, $"Crashes and Blocks {pname} from joining you again.", function()
            if pid == players.user() then notify(lang.get_localised(-1974706693)) return end
            if menu.get_value(savekicked) then trigger_commands($"savep {pname}") end
            add_player_to_blacklist(rids)

            trigger_commands($"crash{pname}")
            wait(500)
            if not is_developer() then
                log($"{pname} ({rids}) has been Crashed and Blocked.")
            else
                log($"{pname} ({rids} / {hex}) has been Crashed and Blocked.")
            end
            trigger_commands($"historyblock{pname} on")
            wait(10000)
            if players.get_name(pid) == names then
                log($"{pname} ({rids}) has not crashed, kicking the player instead.")
                wait(50)
                trigger_commands($"kick{pname}")
            end
        end, nil, nil, COMMANDPERM_AGGRESSIVE)

        menu.action(crashes, "Fragment Crash", {""}, "2Shit1 Crash. Victim needs to look at it.", function()
            if pid == players.user() then notify(lang.get_localised(-1974706693)) return end
            if menu.get_value(savekicked) then trigger_commands($"savep {pname}") end

            local object = entities.create_object(joaat("prop_fragtest_cnst_04"), GET_ENTITY_COORDS(GET_PLAYER_PED_SCRIPT_INDEX(pid)))
            BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
            wait(5000)
            entities.delete(object)
        end)

        menu.action(crashes, "MK2 Griefer", {"grief"}, "Should work one some menus, idk. Don't crash players.", function()
            if pid == players.user() then return notify(lang.get_localised(-1974706693)) end
            if menu.get_value(savekicked) then trigger_commands($"savep {pname}") end

            local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
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
                SET_PED_INTO_VEHICLE(jesus, veh, -1)
                wait(100)
                TASK_VEHICLE_HELI_PROTECT(jesus, veh, ped, 10.0, 0, 10, 0, 0)
                wait(1000)
                entities.delete_by_handle(jesus)
                entities.delete_by_handle(veh)
            end
        end)

        menu.action(crashes, "Invalid Heli Task", {"task2"}, "Works on most menus. <3", function()
            if pid == players.user() then return notify(lang.get_localised(-1974706693)) end
            if menu.get_value(savekicked) then trigger_commands($"savep {pname}") end

            local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local pos = players.get_position(pid)
            BlockSyncs(pid, function()
                for i = 1, 10 do
                    if not players.exists(pid) then
                        return
                    end
                    local veh = spawn_vehicle("zentorno", pos, true)
                    local jesus = spawn_ped("mp_m_freemode_01", pos, true)
                    SET_PED_INTO_VEHICLE(jesus, veh, -1)
                    wait(100)
                    TASK_VEHICLE_HELI_PROTECT(jesus, veh, ped, 10.0, 0, 10, 0, 0)
                    wait(1000)
                    entities.delete(jesus)
                    entities.delete(veh)
                end
            end)
        end)

        menu.action(crashes, "Invalid Animation", {"squish"}, "Blocked by some popular menus.", function()
            if pid == players.user() then return notify(lang.get_localised(-1974706693)) end
            if menu.get_value(savekicked) then trigger_commands($"savep {pname}") end

            local ped = GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local user = GET_PLAYER_PED(players.user())
            local pos = GET_ENTITY_COORDS(ped)
            local my_pos = GET_ENTITY_COORDS(user)
            local anim_dict = ("anim@mp_player_intupperstinker")
            request_animation(anim_dict)
            BlockSyncs(pid, function()
                SET_ENTITY_COORDS_NO_OFFSET(user, pos, false, false, false)
                wait(100)
                TASK_SWEEP_AIM_POSITION(user, anim_dict, "I", "Love", "You", -1, 0.0, 0.0, 0.0, 0.0, 0.0)
                wait(100)
            end)
            CLEAR_PED_TASKS_IMMEDIATELY(user)
            SET_ENTITY_COORDS_NO_OFFSET(user, my_pos, false, false, false)
        end)

        menu.action(crashes, "Draki Crash", {""}, "", function()
            if pid == players.user() then return notify(lang.get_localised(-1974706693)) end
            if menu.get_value(savekicked) then trigger_commands($"savep {pname}") end

            local player = GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local hash = util.joaat("cs_taostranslator2")
            while not HAS_MODEL_LOADED(hash) do
                REQUEST_MODEL(hash)
                util.yield(5)
            end
            local ped = {}
            for i = 0, 10 do
                local coord = GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(player, 0.0, 5.0, 0.0)
                ped[i] = entities.create_ped(0, hash, coord, 0)
                local pedcoord = GET_ENTITY_COORDS(ped[i], false)
                GIVE_DELAYED_WEAPON_TO_PED(ped[i], 0xB1CA77B1, 0, true)
                SET_PED_GADGET(ped[i], 0xB1CA77B1, true)
                menu.trigger_commands("as ".. GET_PLAYER_NAME(pid) .. " explode " .. GET_PLAYER_NAME(pid) .. " ")
                SET_ENTITY_VISIBLE(ped[i], false)
                util.yield(25)
            end
            util.yield(2500)
            for i = 0, 10 do
                entities.delete_by_handle(ped[i])
                util.yield(10)
            end
        end)
--  end
end)

Jointimes, names, rids, hostq, allplayers, ips = {}, {}, {}, {}, {}, {}
players.add_command_hook(function(pid, c)
    names[pid] = players.get_name(pid)
    rids[pid] = players.get_rockstar_id(pid)
    hostq[pid] = players.get_host_queue_position(pid)
    allplayers[pid] = NETWORK_GET_NUM_CONNECTED_PLAYERS()
    ips[pid] = player_ip(pid)
    Jointimes[pid] = os.clock()

    if showJoinInfomsg then
        if not in_session() then return end
        notify(names[pid].." has joined.\nSlot: "..pid.."\nRID/SCID: "..rids[pid].."\nIPv4: "..ips[pid])
    end
    if showJoinInfolog then
        log(names[pid].." (Slot: "..pid.." | Host Queue: #"..hostq[pid].." | Count: "..allplayers[pid].." | RID/SCID: "..rids[pid].." | IPv4: "..ips[pid]..") is joining.")
    end
    if showJoinInfoteam then
        chat.send_message("> "..names[pid].." (Slot: "..pid.." | Host Queue: #"..hostq[pid].." | Count: "..allplayers[pid].." | RID/SCID: "..rids[pid].." | IPv4: "..ips[pid]..") is joining.", true, true, true)
    end
    if showJoinInfoall then
        chat.send_message("> "..names[pid].." (Slot: "..pid.." | Host Queue: #"..hostq[pid].." | Count: "..allplayers[pid].." | RID/SCID: "..rids[pid].." | IPv4: "..ips[pid]..") is joining.", false, true, true)
    end
end)

players.on_leave(function(pid)
    local name = names[pid] or "Unknown Player"

    if showleaveInfomsg then
        notify(name.." left.")
    end

    if showleaveInfolog then
        log(name.." (RID: "..rids[pid].." | Time in Session: "..formatTime(math.floor(os.clock() - Jointimes[pid] + 0.5))..") left.")
    end

    if showleaveInfoteam then
        chat.send_message("> "..name.." (RID: "..rids[pid].." | Time in Session: "..formatTime(math.floor(os.clock() - Jointimes[pid] + 0.5))..") left.", true, true, true)
    end

    if showleaveInfoall then
        chat.send_message("> "..name.." (RID: "..rids[pid].." | Time in Session: "..formatTime(math.floor(os.clock() - Jointimes[pid] + 0.5))..") left.", false, true, true)
    end

    wait(100)
    Jointimes[pid] = nil
    names[pid] = nil
    rids[pid] = nil
    allplayers[pid] = nil
end)

if async_http.have_access() then
    menu.action(menu.my_root(), "Check for Updates", {""}, "", function()
        auto_update_config.check_interval = 0

        if auto_updater.run_auto_update(auto_update_config) then
            notify("No updates have been found.")
        end
    end)
end



util.create_tick_handler(function()
    local carCheck = entities.get_user_vehicle_as_handle(true)
    local focused = players.get_focused()[1]

    if user_vehicle != carCheck then
        user_vehicle = carCheck
    end

    if is_developer() then
        update_help_text(debug_hk, $"Kick {players.get_name(players.get_host())}")
    end

    update_value(host_name, players.get_host(), true)
    update_value(next_host_name, players.get_host_queue()[2], true)
    update_value(script_host_name, players.get_script_host(), true)
    update_value(players_amount, #players.list())
    update_value(modder_amount, tostring(get_modder_int()))

    if focused != nil and menu.is_open() and menu.get_value(draw_players) then
        local ped = GET_PLAYER_PED_SCRIPT_INDEX(focused)

        if UI3DSCENE_IS_AVAILABLE() then

            if UI3DSCENE_PUSH_PRESET("CELEBRATION_WINNER") then
                UI3DSCENE_ASSIGN_PED_TO_SLOT("CELEBRATION_WINNER", ped, 0, 0.0, 0.0, 0.0)
            end

        end

    end
end)

util.on_stop(function()
    for pid, blip in orbital_blips do
        util.remove_blip(blip)
    end
end)

util.keep_running()