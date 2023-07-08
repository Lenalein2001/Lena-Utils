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
-- Globals / Tables
-------------------------------------

scriptname = "Lena-Utilities"
log = util.log 
notify = util.toast
wait = util.yield
wait_once = util.yield_once
trigger_commands = menu.trigger_commands
trigger_command = menu.trigger_command
sendse = util.trigger_script_event
joaat = util.joaat
all_objects = {}
spawned_cages = {}
spawned_attackers = {}
object_uses = 0
handle_ptr = memory.alloc(13*8)
natives_version = "natives-2944a.uno"
local flare_veh = {788747387, -82626025, 1181327175, -1281684762}
local anti_explo_sniper = {"Remove Weapon", "Remove Component", "Notify", "Kill", "Kick"}
local interior_stuff = {0, 233985, 169473, 169729, 169985, 170241, 177665, 177409, 185089, 184833, 184577, 163585, 167425, 167169}
local launch_vehicle = {"Launch Up", "Launch Forward", "Launch Backwards", "Launch Down", "Slingshot"}
local better_heli_offsets = {0x18, 0x20, 0x24, 0x30, 0x48, 0x4C, 0x58, 0x3C}
local better_planes = {
    {0x00B0, 10},
    {0x0050, 0.3},
    {0x0054, 1}
}

-------------------------------------
-- Natives
-------------------------------------

util.require_natives(natives_version)

-------------------------------------
-- Tabs
-------------------------------------

local self = menu.list(menu.my_root(), "Self", {"lenaself"}, "Self Options")
local vehicle = menu.list(menu.my_root(), "Vehicle", {"lenavehicle"}, "Vehicle Options")
local online = menu.list(menu.my_root(), "Online", {"lenaonline"}, "Online Options")
local tunables = menu.list(menu.my_root(), "Tunables", {"lenatunables"}, "Tunables")
local misc = menu.list(menu.my_root(), "Misc", {"lenamisc"}, "")
local ai_made = menu.list(menu.my_root(), "AI Made", {"lenaai"}, "The following options have been generated using ChatGPT, a cutting-edge AI language model.\nI had to make some adjustments, but overall they work great.")

-------------------------------------
-- Sub Tabs
-------------------------------------

-- Self
local anims = menu.list(self, "Animations", {""}, "Some Animations.")
local fast_stuff = menu.list(self, "Fast Stuff", {""}, "Skips certain Animations.")
local weap = menu.list(self, "Weapons", {""}, "Weapon Options.")
local lrf = menu.list(weap, "Legit Rapid Fire", {""}, "Basically a macro for Rocket Spam.")
-- Vehicle
local better_vehicles = menu.list(vehicle, "Better Vehicles", {""}, "")
local doorcontrol = menu.list(vehicle, "Doors", {""}, "")
local engine_control = menu.list(vehicle, "Engine Control", {""}, "")
-- Online
local mpsession = menu.list(online, "Session", {""}, "Features for the current Session.")
local hosttools = menu.list(mpsession, "Host Tools", {""}, "Tools that can only be used as the Session Host or to force Session Host.")
local detects_protex = menu.list(online, "Detections&Protections", {""}, "")
local detections = menu.list(detects_protex, "Detections", {""}, "")
local protex = menu.list(detects_protex, "Protections", {""}, "")
local anti_orb = menu.list(protex, "Anti Orb", {""}, "Protections against the Orbital Cannon.")
friend_lists = menu.list(online, "Friend List", {""}, "")
local reactions = menu.list(online, "Reactions", {""}, "")
local join_reactions = menu.list(reactions, "Join Reactions", {""}, "")
local leave_reactions = menu.list(reactions, "Leave Reactions", {""}, "")
local weapon_reactions = menu.list(reactions, "Weapon Reactions", {""}, "")
local spoofing_opt = menu.list(online, "Spoofing", {""}, "")
-- Tunables
local sell_stuff = menu.list(tunables, "Selling", {""}, "Shit's broken")
local missions_tunables = menu.list(tunables, "Missions", {""}, "")
-- Misc
local shortcuts = menu.list(misc, "Shortcuts", {""}, "")
local clear_area_locally = menu.list(misc, "Clear Area", {""}, "")
local teleport = menu.list(misc, "Teleport", {""}, "")

-------------------------------------
-- Auto Updater
-------------------------------------

local status, auto_updater = pcall(require, "auto-updater")
if not status then
    local auto_update_complete = nil notify("Installing auto-updater...")
    async_http.init("raw.githubusercontent.com", "/hexarobi/stand-lua-auto-updater/main/auto-updater.lua",
        function(result, headers, status_code)
            local function parse_auto_update_result(result, headers, status_code)
                local error_prefix = "Error downloading auto-updater: "
                if status_code != 200 then notify(error_prefix..status_code) return false end
                if not result or result == "" then notify(error_prefix.."Found empty file.") return false end
                filesystem.mkdir(filesystem.scripts_dir().."lib")
                local file = io.open(filesystem.scripts_dir().."lib\\auto-updater.lua", "wb")
                if file == nil then notify(error_prefix.."Could not open file for writing.") return false end
                file:write(result) file:close() notify("Successfully installed auto-updater lib") return true
            end
            auto_update_complete = parse_auto_update_result(result, headers, status_code)
        end, function() notify("Error downloading auto-updater lib. Update failed to download.") end)
    async_http.dispatch() local i = 1 while (auto_update_complete == nil and i < 40) do wait(250) i = i + 1 end
    if auto_update_complete == nil then error("Error downloading auto-updater lib. HTTP Request timeout") end
    auto_updater = require("auto-updater")
end
if auto_updater == true then error("Invalid auto-updater lib. Please delete your Stand/Lua Scripts/lib/auto-updater.lua and try again") end

local default_check_interval = 604800
local auto_update_config = {
    source_url="https://raw.githubusercontent.com/Lenalein2001/Lena-Utils/main/Lena-Utilities.lua",
    script_relpath=SCRIPT_RELPATH,
    switch_to_branch=selected_branch,
    verify_file_begins_with="--",
    check_interval=86400,
    silent_updates=false,
    dependencies={
        {
            name="Funcs",
            source_url="https://raw.githubusercontent.com/Lenalein2001/Lena-Utils/main/lib/lena/funcs.lua",
            script_relpath="/lib/lena/funcs.lua",
            check_interval=default_check_interval,
        },
        {
            name="Natives",
            source_url="https://raw.githubusercontent.com/Lenalein2001/Lena-Utils/main/lib/natives-2944a/uno.lua",
            script_relpath="/lib/natives-2944a/uno.lua",
            check_interval=default_check_interval,
        },
        {
            name="Json",
            source_url="https://raw.githubusercontent.com/Lenalein2001/Lena-Utils/main/lib/pretty/json.lua",
            script_relpath="/lib/pretty/json.lua",
            check_interval=default_check_interval,
        },
        {
            name="Constant",
            source_url="https://raw.githubusercontent.com/Lenalein2001/Lena-Utils/main/lib/pretty/json/constant.lua",
            script_relpath="/lib/pretty/json/constant.lua",
            check_interval=default_check_interval,
        },
        {
            name="Parser",
            source_url="https://raw.githubusercontent.com/Lenalein2001/Lena-Utils/main/lib/pretty/json/parser.lua",
            script_relpath="/lib/pretty/json/parser.lua",
            check_interval=default_check_interval,
        },
        {
            name="Serializer",
            source_url="https://raw.githubusercontent.com/Lenalein2001/Lena-Utils/main/lib/pretty/json/serializer.lua",
            script_relpath="/lib/pretty/json/serializer.lua",
            check_interval=default_check_interval,
        },
        {
            name="ScaleformLib",
            source_url="https://raw.githubusercontent.com/Lenalein2001/Lena-Utils/main/lib/ScaleformLib.lua",
            script_relpath="/lib/ScaleformLib.lua",
            check_interval=default_check_interval,
        },
        {
            name="Labels",
            source_url="https://raw.githubusercontent.com/Lenalein2001/Lena-Utils/main/lib/all_labels.lua",
            script_relpath="/lib/all_labels.lua",
            check_interval=default_check_interval,
        },
    }
}

if PED == nil then
    local msg1 = "It looks like the required natives file was not loaded properly. This file should be downloaded along with my script and all other dependencies. Natives file required: "
    local msg2 = "Please download the file and everything else again from my Github."
    util.show_corner_help(msg1..""..natives_version.."\n"..msg2)
    util.stop_script()
end
if lang.get_current() != "en" then
    notify("This Lua is made using the english translation of Stand. If things break it's most likely because you are using a different language.\nTry to use: Stand>Settings>Language>English (UK).")
end
if not SCRIPT_SILENT_START then
    notify("Hi, "..SOCIALCLUB.SC_ACCOUNT_INFO_GET_NICKNAME().." <3.")
end 

-------------------------------------
-- Required Files
-------------------------------------

local scaleForm = require("ScaleformLib")
local funcs = require("lena.funcs")
local scriptdir = filesystem.scripts_dir()
local lenaDir = scriptdir.."Lena\\"
local lyrics_dir = lenaDir.."lyrics\\"

if not filesystem.exists(lenaDir) then
	filesystem.mkdir(lenaDir)
end
if not filesystem.exists(lenaDir.."lyrics") then
	filesystem.mkdir(lenaDir.."lyrics")
end
if not filesystem.exists(lenaDir.."Session") then
	filesystem.mkdir(lenaDir.."Session")
end
if not filesystem.exists(lenaDir.."Players") then
	filesystem.mkdir(lenaDir.."Players")
end
if not is_developer() then
    auto_updater.run_auto_update(auto_update_config)
end

-----------------------------------
-- Tables
-----------------------------------

local veh_things = {
    "brickade2",
    "hauler",
    "hauler2",
    "manchez3",
    "terbyte",
    "minitank",
    "rcbandito",
    "volatus",
    "supervolito",
    "supervolito2"
}

local numpadControls = {
    -- Plane & Heli
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
    {"Strip Club DJ Booth", {x=121.398254, y=-1281.0024, z=29.480522}},
    {"Single Garage", {x=-144.11609, y=-576.5855, z=31.845743}},
    {"FIB Destroyed Floor", {x=158.44386, y=-738.07367, z=246.15218}},
    {"Pharma Lab", {x=496.86224, y=-2560.0608, z=-58.921993}},
    {"Nightclub Safe", {x=-1615.6887, y=-3015.7354, z=-75.205086}}
}

objects_thread = util.create_thread(function(thr)
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

        menu.action(anims, "Stop all Animations", {""}, "", function()
            TASK.CLEAR_PED_TASKS(players.user_ped())
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
        menu.action(anims, "Car blowjob", {""}, "", function()
            play_anim("mini@prostitutes@sexlow_veh", "low_car_bj_loop_female", -1)
        end)
        menu.action(anims, "Execute", {""}, "", function()
            play_anim("guard_reactions", "1hand_aiming_cycle", -1)
        end)
        menu.action(anims, "Sit Sad", {""}, "", function()
            play_anim("anim@amb@business@bgen@bgen_no_work@", "sit_phone_phoneputdown_sleeping-noworkfemale", -1)
        end)
        menu.action(anims, "Wait", {""}, "", function()
            play_anim("amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", -1)
        end)
        menu.action(anims, "Dance", {""}, "", function()
            play_anim("anim@amb@casino@mini@dance@dance_solo@female@var_b@", "high_center", -1)
        end)
        menu.action(anims, "Sniper", {""}, "", function()
            play_anim("missfbi3_sniping", "prone_michael", -1)
        end)

    -------------------------------------
    -- Fast Stuff
    -------------------------------------

        -------------------------------------
        -- Fast Vehicle Enter/Exit
        -------------------------------------

        menu.toggle_loop(fast_stuff, "Fast Vehicle Enter/Exit", {""}, "Enter vehicles faster.\nLock Outfit seems to break it.", function()
            if (TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 160) or TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 167) or TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 165)) and not TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 195) then
                PED.FORCE_PED_AI_AND_ANIMATION_UPDATE(players.user_ped())
            end
        end)

        -------------------------------------
        -- Fast Weapon swap
        -------------------------------------

        menu.toggle_loop(fast_stuff, "Fast Weapon Switch", {""}, "Swaps your weapons faster.\nLock Outfit seems to break it.", function()
            if TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 56) then
                PED.FORCE_PED_AI_AND_ANIMATION_UPDATE(players.user_ped())
            end
        end)

        -------------------------------------
        -- Fast Reload
        -------------------------------------

        menu.toggle_loop(fast_stuff, "Fast Reload", {""}, "Reloads your Weapon Faster.\nLock Outfit seems to break it.", function()
            if TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 298) then
                PED.FORCE_PED_AI_AND_ANIMATION_UPDATE(players.user_ped())
            end
        end)

        -------------------------------------
        -- Fast Mount
        -------------------------------------

        menu.toggle_loop(fast_stuff, "Fast Mount", {""}, "Mount over stuff faster.\nLock Outfit seems to break it.", function()
            if TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 50) or TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 51) then
                PED.FORCE_PED_AI_AND_ANIMATION_UPDATE(players.user_ped())
            end
        end)


    -------------------------------------
    -- Friendly AI
    -------------------------------------

    menu.toggle_loop(self, "Friendly NPCs", {""}, "The NPCs will ignore you.", function()
        PED.SET_PED_RESET_FLAG(players.user_ped(), 124, true)
    end)

    -------------------------------------
    -- Change CEO/MC Type
    -------------------------------------

    menu.action(self, "Change CEO/MC Type", {""}, "Changes your CEO/MC type to the opposite.", function()
        trigger_commands("ceotomc")
    end)

    -------------------------------------
    -- Godmode
    -------------------------------------

    menu.toggle(self, "Godmode", {"gm"}, "Toggles a few options to make you truly Invincible.", function(toggled)
        trigger_commands($"godmode {toggled}; vehgodmode {toggled}; grace {toggled}; mint {toggled}")
    end)
    
    -------------------------------------
    -- Auto Heal
    -------------------------------------

    menu.toggle_loop(self, "Auto Heal", {""}, "Heals you on low health.", function()
        local ped = players.user_ped()
        local health = ENTITY.GET_ENTITY_HEALTH(ped)
        if health <= 140 and not PED.IS_PED_DEAD_OR_DYING(ped) then
            trigger_commands("refillhealth; refillarmour")
        end
    end)

    -------------------------------------
    -- Heal
    -------------------------------------

    menu.action(self, "Heal", {"heal"}, "Refills your Health and Armour.", function()
        trigger_commands("refillhealth; refillarmour")
    end)

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
    menu.toggle(lrf, "Legit Rapid Fire", {""}, "Switches to a grenade and back to your Main Weapon.", function(toggled)
        local ped = players.user_ped()
        if toggled then
            LegitRapidFire = true
            util.create_thread(function()
                while LegitRapidFire do
                    if PED.IS_PED_SHOOTING(ped) then
                        local currentWpMem = memory.alloc()
                        local junk = WEAPON.GET_CURRENT_PED_WEAPON(ped, currentWpMem, 1)
                        local currentWP = memory.read_int(currentWpMem)
                        memory.free(currentWpMem)
                        WEAPON.SET_CURRENT_PED_WEAPON(ped, 2481070269, true)
                        wait(LegitRapidMS)
                        WEAPON.SET_CURRENT_PED_WEAPON(ped, currentWP, true)
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
        if ammoSpeed != modifiedSpeed then
            modifiedSpeed:reset()
            modifiedSpeed = ammoSpeed
        end
        local newValue = modifiedSpeed.defaultValue * multiplier
        if modifiedSpeed:getValue() != newValue then
            modifiedSpeed:setValue(newValue)
        end
    end)

    -------------------------------------
    -- Max Lockon Range
    -------------------------------------    

    -- menu.toggle_loop(weap, "Max Lockon Range", {""}, "Sets your players lockon range with homing missles and auto aim to the max.", function()
    -- end)

    -------------------------------------
    -- Unfair Triggerbot
    -------------------------------------  

    menu.toggle_loop(weap, "Triggerbot", {"triggerbotall"}, "Slightly worse than Stand's triggerbot.", function()
        local wpn = WEAPON.GET_SELECTED_PED_WEAPON(players.user_ped())
        local dmg = SYSTEM.ROUND(WEAPON.GET_WEAPON_DAMAGE(wpn, 0))
        local delay = WEAPON.GET_WEAPON_TIME_BETWEEN_SHOTS(wpn)
        local wpnEnt = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(PLAYER.PLAYER_PED_ID(), false)
        local wpnCoords = ENTITY.GET_ENTITY_BONE_POSTION(wpnEnt, ENTITY.GET_ENTITY_BONE_INDEX_BY_NAME(wpnEnt, "gun_muzzle"))
        for players.list(false, true, true, true, false) as pid do
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local pos = PED.GET_PED_BONE_COORDS(ped, 31086, 0.0, 0.0, 0.0)
            if PLAYER.IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), ped) and not PED.IS_PED_RELOADING(players.user_ped()) then
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(wpnCoords, pos, dmg, true, wpn, players.user_ped(), true, false, 10000)
                PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, 24, 1.0)
                wait(delay * 1000)
            end
        end
    end)

    -------------------------------------
    -- Rocket Aimbot
    ------------------------------------- 

    menu.toggle_loop(weap, "Rocket Aimbot", {""}, "", function()
        for players.list(false, false, true, true, false) as pid do
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local user = players.user_ped()
            local ped_dist = v3.distance(players.get_position(user), players.get_position(pid))
            local control = (PAD.IS_CONTROL_PRESSED(0, 69) or PAD.IS_CONTROL_PRESSED(0, 70) or PAD.IS_CONTROL_PRESSED(0, 76))
            if not PED.IS_PED_DEAD_OR_DYING(ped) and control and ped_dist < 500.0 and ENTITY.HAS_ENTITY_CLEAR_LOS_TO_ENTITY(user, ped, 17) then
                VEHICLE.SET_VEHICLE_SHOOT_AT_TARGET(user, ped, players.get_position(pid))
            end
        end
    end)

    -------------------------------------
    -- Thermal Scope
    -------------------------------------  

    menu.toggle_loop(weap, "Thermal Scope", {""}, "Press E while aiming to activate.", function()
        local thermal_command = menu.ref_by_path("Game>Rendering>Thermal Vision")
        local aiming = PLAYER.IS_PLAYER_FREE_AIMING(players.user())
        if PLAYER.IS_PLAYER_FREE_AIMING(players.user()) then
            if util.is_key_down(0x45) then
                if menu.get_value(thermal_command) or not aiming then
                    trigger_command(thermal_command, "off")
                else
                    trigger_command(thermal_command, "on")
                    GRAPHICS.SEETHROUGH_SET_MAX_THICKNESS(GRAPHICS.SEETHROUGH_GET_MAX_THICKNESS())
                    GRAPHICS.SEETHROUGH_SET_NOISE_MIN(0.0)
                    GRAPHICS.SEETHROUGH_SET_NOISE_MAX(0.0)
                    GRAPHICS.SEETHROUGH_SET_FADE_STARTDISTANCE(0.0)
                    GRAPHICS.SEETHROUGH_SET_FADE_ENDDISTANCE((1 << 31) - 1 + 0.0)
                    GRAPHICS.SEETHROUGH_SET_HIGHLIGHT_NOISE(0.0)
                end
            end
        else
            trigger_command(thermal_command, "off")
        end
    
        wait(100)
    end,
    function()
        local thermal_command = menu.ref_by_path("Game>Rendering>Thermal Vision")
        trigger_command(thermal_command, "off")
        GRAPHICS.SEETHROUGH_RESET()
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
        menu.slider_float(better_vehicles, "Thrust", {"helithrust"}, "Set the Heli thrust.", 0, 1000, 220, 10, function(value)
            if PED.IS_PED_IN_ANY_HELI(players.user_ped()) then
                local CHandlingData = entities.vehicle_get_handling(entities.get_user_vehicle_as_pointer())
                local CflyingHandling = entities.handling_get_subhandling(CHandlingData, 1)
                if CflyingHandling then
                    memory.write_float(CflyingHandling + 0x8, value * 0.01)
                end
            end
        end)

        menu.action(better_vehicles, "Better Heli Mode", {"betterheli"}, "Disabables Heli auto stablization.", function()
            if PED.IS_PED_IN_ANY_HELI(players.user_ped()) then
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

        menu.divider(better_vehicles, "Better Lazer")
        menu.action(better_vehicles, "Better Lazer", {"betterlazer"}, "", function()
            local CHandlingData = entities.vehicle_get_handling(entities.get_user_vehicle_as_pointer())
            local CflyingHandling = entities.handling_get_subhandling(CHandlingData, 1)
            for better_planes as offsets do
                local handling = offsets[1]
                local value = offsets[2]
                if CflyingHandling then
                    memory.write_float(CflyingHandling + handling, value)
                end
            end
            notify("Better Lazer has been enabled.")
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
            PHYSICS.SET_IN_ARENA_MODE(toggled)
        end)

        -------------------------------------
        -- Better B11 Minigun
        -------------------------------------  

        menu.toggle_loop(better_vehicles, "Better Jet Minigun", {""}, "Higher Damage Output.", function()
            local ammo = menu.ref_by_path("Self>Weapons>Explosion Type>Grenade")
            local toggle_ammo = menu.ref_by_path("Self>Weapons>Explosive Hits")
            local veh = 239897677 or 1692272545 or -1281684762 -- raiju, strikeforce, lazer
            local hash = players.get_vehicle_model(players.user())
            if hash == veh and toggle_ammo.value == false then
                ammo:trigger()
                toggle_ammo.value = true
            elseif hash != veh and toggle_ammo.value == true then
                toggle_ammo.value = false
            end
        end)

    -------------------------------------
    -- Door Control
    -------------------------------------

        -------------------------------------
        -- Lock doors
        -------------------------------------

        menu.toggle(doorcontrol, "Lock doors", {"lock"}, "Locks your current Vehicle so randoms can't enter it.", function(toggled)
            VEHICLE.SET_VEHICLE_RESPECTS_LOCKS_WHEN_HAS_DRIVER(player_cur_car, toggled)
            VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS(player_cur_car, toggled)
        end)

        menu.toggle(doorcontrol, "Lock Doors for Randoms", {"lockrandoms"}, "Locks your current Vehicle so only friends can enter it.", function(toggled)
            for players.list(false, false, true, true, false) as pid do
                VEHICLE.SET_VEHICLE_RESPECTS_LOCKS_WHEN_HAS_DRIVER(player_cur_car, toggled)
                VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_PLAYER(player_cur_car, pid, toggled)
            end
        end)

        -------------------------------------
        -- Unbreakable Doors
        -------------------------------------

        menu.toggle(doorcontrol, "Unbreakable Doors", {""}, "", function(toggled)
            local vehicleDoorCount = VEHICLE.GET_NUMBER_OF_VEHICLE_DOORS(player_cur_car)
            if toggled then
                for i = -1, vehicleDoorCount do
                    VEHICLE.SET_DOOR_ALLOWED_TO_BE_BROKEN_OFF(player_cur_car, i, false)
                end
            else
                for i = -1, vehicleDoorCount do
                    VEHICLE.SET_DOOR_ALLOWED_TO_BE_BROKEN_OFF(player_cur_car, i, true)
                end
            end
        end)

        menu.toggle_loop(doorcontrol, "Tase Players trying to Enter", {""}, "", function()
            if util.is_session_transition_active() then return end
            if player_cur_car == nil then return end
            for players.list_except() as pid do
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local pos = players.get_position(pid)
                if VEHICLE.GET_PED_IN_VEHICLE_SEAT(player_cur_car, -1, true) == players.user_ped() and PED.GET_VEHICLE_PED_IS_TRYING_TO_ENTER(ped) == player_cur_car then
                    local bone1 = PED.GET_PED_BONE_COORDS(handle, 36029, 0.0, 0.0, 0.0) 
                    FIRE.ADD_EXPLOSION(bone1.x, bone1.y, bone1.z, 8, 0.5, false, true, 0.0, true)
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
            VEHICLE.SET_VEHICLE_ENGINE_ON(player_cur_car, not toggled, toggled, toggled)
        end)        

        menu.action(engine_control, "Toggle Engine On", {"Engineoon", "Eon"}, "Starts the Engine of the current Vehicle.", function()
            VEHICLE.SET_VEHICLE_ENGINE_ON(player_cur_car, true, true, true)
        end)
        menu.action(engine_control, "Toggle Engine Off", {"Engineoff", "Eoff"}, "Stops The Engine of the current Vehicle.", function()
            VEHICLE.SET_VEHICLE_ENGINE_ON(player_cur_car, false, true, true)
        end)

        -------------------------------------
        -- Disable Engine Fires
        -------------------------------------

        local previous_car = nil
        menu.toggle_loop(engine_control, "Disable Engine Fires", {""}, "", function()
            if player_cur_car != previous_car then
                VEHICLE.SET_DISABLE_VEHICLE_ENGINE_FIRES(player_cur_car, true)
                previous_car = player_car
            end
        end)

    -------------------------------------
    -- Enter Nearest Vehicle
    -------------------------------------        
    
    menu.action(vehicle, "Enter Nearest Vehicle", {""}, "Enters the nearest Vehicle that can be found.", function()
        if not PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
            local player_pos = players.get_position(players.user())
            local veh = closestveh(player_pos)
            local ped = VEHICLE.GET_PED_IN_VEHICLE_SEAT(veh, -1, true)
            PED.SET_PED_INTO_VEHICLE(players.user_ped(), veh, -1)
            wait(100)
            local vehmodel = players.get_vehicle_model(players.user())
            local vehname = util.get_label_text(vehmodel)
            notify($"Set Ped into the nearest Vehicle.\nVehicle: {vehname}.")
        end
    end)

    -------------------------------------
    -- Clean vehicle
    -------------------------------------

    menu.action(vehicle, "Clean Vehicle", {"clv"}, "Cleans the current Vehicle.", function()
        VEHICLE.SET_VEHICLE_DIRT_LEVEL(player_cur_car, 0.0)
    end)

    -------------------------------------
    -- Disable Crash Damage
    -------------------------------------

    menu.toggle(vehicle, "Disable Crash Damage", {""}, "Vehicle will not take crash damage, but is still susceptible to damage from bullets and explosives.", function(toggled)
        VEHICLE.SET_VEHICLE_STRONG(toggled)
    end)

    -------------------------------------
    -- Disable Visible Damage
    -------------------------------------

    menu.toggle(vehicle, "Disable Visible Damage", {""}, "Vehicle will not take any visible damage.", function(toggled)
        VEHICLE.SET_VEHICLE_CAN_BE_VISIBLY_DAMAGED(toggled)
    end)
        
    -------------------------------------
    -- Unbreakable Lights
    -------------------------------------   

    menu.toggle(vehicle, "Unbreakable Lights", {""}, "Makes the Lights unbreakable on your current Vehicle.", function(toggled)
        VEHICLE.SET_VEHICLE_HAS_UNBREAKABLE_LIGHTS(player_cur_car, toggled)
    end)

    -------------------------------------
    -- Vehicle Drift
    -------------------------------------

    menu.toggle_loop(vehicle, "Drift Mode", {"driftmode"}, "Hold shift to drift.", function()
        if PAD.IS_CONTROL_PRESSED(0, 21) then
            VEHICLE.SET_VEHICLE_REDUCE_GRIP(player_cur_car, true)
        else
            VEHICLE.SET_VEHICLE_REDUCE_GRIP(player_cur_car, false)
        end
    end)

    -------------------------------------
    -- Force flares
    -------------------------------------

    menu.toggle(vehicle, "Force flares", {"forceflares"}, "Forces flares on some Vehicles.", function()
        local count = menu.ref_by_path("Vehicle>Countermeasures>Count")
        local how = menu.ref_by_path("Vehicle>Countermeasures>Pattern>Horizontal")
        local deploy = menu.ref_by_path("Vehicle>Countermeasures>Deploy Flares")
        trigger_command(count, "2"); trigger_command(how)
        util.create_thread(function()
            while PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) do
                if util.is_key_down("E") and not chat.is_open() and not menu.command_box_is_open() and not menu.is_open() then
                    trigger_command(deploy)
                    wait(3000)
                end
                wait()
            end
            util.stop_thread()
        end)
    end)

    -------------------------------------
    -- VPC
    -------------------------------------

    menu.action(vehicle, "Control Passenger Weapons", {"controlweapons", "conwep"}, "You can control all weapons of the current vehicle.", function()
        local CHandlingData = entities.vehicle_get_handling(entities.get_user_vehicle_as_pointer())
        local CVehicleWeaponHandlingDataAddress = entities.handling_get_subhandling(CHandlingData, 9)
        local WeaponSeats = CVehicleWeaponHandlingDataAddress + 0x0020
        local success, seat = get_seat_ped_is_in(PLAYER.PLAYER_PED_ID())
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

    menu.toggle_loop(vehicle, "Bypass Anti-Lockon", {""}, "Bypass No Lock-on features. Works great on Kiddions Users.", function()
        for players.list(false, true, true, true, false) as pid do
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local veh = PED.GET_VEHICLE_PED_IS_USING(ped)
            if not PED.IS_PED_IN_ANY_VEHICLE(ped) then 
                continue 
            end
            if memory.read_byte(entities.handle_to_pointer(veh) + 0x0A9E) == 0 then
                VEHICLE.SET_VEHICLE_ALLOW_HOMING_MISSLE_LOCKON(veh, true)
            end
        end
    end)

    -------------------------------------
    -- Auto-Performance Tuning
    -------------------------------------

    menu.toggle_loop(vehicle, "Auto-Perf", {""}, "Will Check every 5 seconds if your vehicle could use a upgrade.", function()
        if PED.IS_PED_SITTING_IN_ANY_VEHICLE(players.user_ped()) then
            local veh = players.get_vehicle_model(players.user())
            if VEHICLE.IS_THIS_MODEL_A_CAR(veh) or VEHICLE.IS_THIS_MODEL_A_BIKE(veh) then
                trigger_commands("turbo on; armour 4; brakes 2; engine 3; transmission 3; bulletprooftyres on")
            end
        end
        wait(5000)
    end)

    -------------------------------------
    -- Shot Flames
    -------------------------------------

    menu.toggle_loop(vehicle, "Limit RPM", {""}, "", function()
        if players.get_vehicle_model(players.user()) != 0 then
            entities.set_rpm(entities.get_user_vehicle_as_pointer(), 1.2)
            wait(100)
        end
    end)

    menu.toggle_loop(vehicle, "Keep Vehicle Clean", {""}, "", function()
        if VEHICLE.GET_VEHICLE_DIRT_LEVEL(player_cur_car) >= 1 and entities.get_owner(player_cur_car) == players.user() then
            VEHICLE.SET_VEHICLE_DIRT_LEVEL(player_cur_car, 0)
            notify("Vehicle Cleaned")
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

        menu.toggle_loop(mpsession, "Session Host Migration", {""}, "Notifies you if the Host has changed.", function()
            local sh -- Session Host
            local sh_name -- Session Host Name
            if util.is_session_started() then
                if players.get_host() != -1 and players.get_host() != nil then
                    sh = players.get_host()
                    sh_name = players.get_name(sh)
                    wait(2000)
                    if sh != -1 and sh != nil then
                        local new_sh = players.get_host()
                        if sh != new_sh and new_sh != -1 and new_sh != nil then
                            if players.exists(new_sh) then
                                notify($"Session Host migrated from {sh_name} to "..players.get_name(new_sh))
                                log($"[Lena | Host Migration] Session Host migrated from {sh_name} to "..players.get_name(new_sh))
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
                    wait(2000)
                    if sh != -1 and sh != nil then
                        local new_sh = players.get_script_host()
                        if sh != new_sh and new_sh != -1 and new_sh != nil then
                            if players.exists(new_sh) then
                                notify($"Script Host migrated from {sh_name} to "..players.get_name(new_sh))
                                log($"[Lena | Script Host Migration] Script Host migrated from {sh_name} to "..players.get_name(new_sh))
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
            if players.get_host() == players.user() then
                NETWORK.NETWORK_SESSION_SET_MATCHMAKING_GROUP_MAX(0, value)
                notify($"Free Slots: {NETWORK.NETWORK_SESSION_GET_MATCHMAKING_GROUP_FREE(0)}")
            else
                notify("You are not the Host.")
            end
        end)
        menu.click_slider(hosttools, "Max Spectators", {"maxspectators"}, "Set the max Spectators for the lobby\nOnly works as the Host.", 0, 2, 0, 1, function (value)
            if players.get_host() == players.user() then
                NETWORK.NETWORK_SESSION_SET_MATCHMAKING_GROUP_MAX(4, value)
                notify($"Free Slots: {NETWORK.NETWORK_SESSION_GET_MATCHMAKING_GROUP_FREE(4)}")
            else
                notify("You are not the Host.")
            end
        end)

        -------------------------------------
        -- Force Host
        -------------------------------------

        menu.action(hosttools, "Force Host", {"forcehost"}, "Forces you to become the Session Host.", function()
            local curPos = players.get_host_queue_position(players.user())
            if curPos == 0 then
                notify("You are Session Host already.")
                return
            end
            local friendsHostQueue = players.get_host_queue(false, true, false)
            if #friendsHostQueue > 0 then
                for friendsHostQueue as pid do
                    if players.get_host_queue_position(pid) < curPos then
                        notify("Failed, one of the players in the queue is your friend. Forcing Session Host is impossible until your friend re-joins the Session with a higher Host queue index.")
                        return
                    end
                end
            end
            local HostQueue = players.get_host_queue(false, false, true)
            for idx, pid in HostQueue do
                if idx <= curPos then
                    trigger_commands("kick"..players.get_name(pid))
                    wait(100)
                end
            end
            util.create_tick_handler(function()
                if players.get_host() == players.user() then
                    notify("Success, you are now the Session Host.")
                    return false
                end
                wait(500)
            end)
        end)

        -------------------------------------
        -- Block SH Migration
        -------------------------------------

        menu.toggle(hosttools, "Block SH Migration", {""}, "Only works when you are the Host. Doesn't work against Modders.", function(on)
            if util.is_session_started() and players.get_host() == players.user() then
                NETWORK.NETWORK_PREVENT_SCRIPT_HOST_MIGRATION()
            end
        end)

        menu.divider(hosttools, "Session Info")
        local host_name = menu.readonly(hosttools, "N/A")
        local script_host_name = menu.readonly(hosttools, "N/A")
        local players_amount = menu.readonly(hosttools, "N/A")
        local modder_amount = menu.readonly(hosttools, "N/A")

        util.create_tick_handler(function()
            menu.set_menu_name(host_name, "Host: "..players.get_name(players.get_host()))
            menu.set_menu_name(script_host_name, "Script Host: "..players.get_name(players.get_script_host()))
            menu.set_menu_name(players_amount, "Players: "..#players.list())
            menu.set_menu_name(modder_amount, "Modders: " .. tostring(get_modder_int()))
        end)

        -------------------------------------
        -- Show Talking Players
        -------------------------------------

        menu.toggle_loop(mpsession, "Show Talking Players", {""}, "Draws a debug text of players current talking.", function()
            if util.is_session_started() and not util.is_session_transition_active() then
                for players.list(true, true, true, true, true) as pid do
                    if NETWORK.NETWORK_IS_PLAYER_TALKING(pid) then
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
        menu.toggle(detections, "Detect Rockets", {""}, "Detects incomming Rockets and Mines.", function(on)
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
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local vehicle = PED.GET_VEHICLE_PED_IS_USING(ped)
                local veh_speed = (ENTITY.GET_ENTITY_SPEED(vehicle)* 3.6)
                local class = VEHICLE.GET_VEHICLE_CLASS(vehicle)
                if class != 15 and class != 16 and veh_speed >= 320 and (players.get_vehicle_model(pid) != joaat("oppressor") or players.get_vehicle_model(pid) != joaat("oppressor2")) then
                    local driver = NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1))
                    if not IsDetectionPresent(pid, "Super Drive") then
                        players.add_detection(pid, "Super Drive", 7, 50)
                    end
                    break
                end
            end
        end)

        -------------------------------------
        -- Spectate
        -------------------------------------

        menu.toggle_loop(detections, "Spectate", {""}, "Detects if someone is spectating you.", function()
            for players.list(false, true, true, true, true) as pid do
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local cam_dist = v3.distance(players.get_position(players.user()), players.get_cam_pos(pid))
                local ped_dist = v3.distance(players.get_position(players.user()), players.get_position(pid))
                if cam_dist < 20.0 and ped_dist > 75.0 and not PED.IS_PED_DEAD_OR_DYING(ped) and not NETWORK.NETWORK_IS_PLAYER_FADING(pid) then
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
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                if not NETWORK.NETWORK_IS_PLAYER_FADING(pid) and ENTITY.IS_ENTITY_VISIBLE(ped) and not PED.IS_PED_DEAD_OR_DYING(ped) then
                    local oldpos = players.get_position(pid)
                    wait(1000)
                    local currentpos = players.get_position(pid)
                    if GET_SPAWN_STATE(pid) != 0 then
                        for i, interior in interior_stuff do
                            if v3.distance(oldpos, currentpos) > 500 and oldpos.x != currentpos.x and oldpos.y != currentpos.y and oldpos.z != currentpos.z then
                                wait(500)
                                if GET_INTERIOR_FROM_PLAYER(pid) == interior and PLAYER.IS_PLAYER_PLAYING(pid) and players.exists(pid) then
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
                local rank = players.get_rank(pid)
                local money = players.get_money(pid)
                local kills = players.get_kills(pid)
                local deaths = players.get_deaths(pid)
                local kdratio = players.get_kd(pid)
                if players.are_stats_ready(pid) then
                    if kdratio < 0 or kdratio > 100 or kills < 0 or kills > 50000 or deaths < 0 or deaths > 50000 then
                        if not IsDetectionPresent(pid, "Unlegit Stats (K/D)") then
                            players.add_detection(pid, "Unlegit Stats (K/D)", 7, 50)
                        end
                    end
                    if rank > 1500 then
                        if not IsDetectionPresent(pid, "Unlegit Stats (Rank)") then
                            players.add_detection(pid, "Unlegit Stats (Rank)", 7, 75)
                        end
                    end
                    if money > 1500000000 then
                        if not IsDetectionPresent(pid, "Unlegit Stats (Money)") then
                            players.add_detection(pid, "Unlegit Stats (Money)", 7, 50)
                        end
                    end
                    wait(1000)
                end
            end
        end)

        -------------------------------------
        -- Spawned Vehicle
        -------------------------------------
        -- Full credits go to Prism, I just wanted this feature without having to load more luas.
        -- Small changes will be made. Mainly changed to Natives with Namespaces
        menu.toggle_loop(detections, "Spawned Vehicle", {""}, "Detects if someone is using a spawned Vehicle. Can also detect Menus.", function()
            for players.list() as pid do
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local vehicle = PED.GET_VEHICLE_PED_IS_USING(ped)
                local hash = players.get_vehicle_model(pid)
                local plate_text = VEHICLE.GET_VEHICLE_NUMBER_PLATE_TEXT(vehicle)
                local bitset = DECORATOR.DECOR_GET_INT(vehicle, "MPBitset")
                local plyveh = DECORATOR.DECOR_GET_INT(vehicle, "Player_Vehicle")
                local pegasusveh = DECORATOR.DECOR_GET_BOOL(vehicle, "CreatedByPegasus")
                for veh_things as veh do
                    if hash == joaat(veh) and DECORATOR.DECOR_GET_INT(vehicle, "MPBitset") == 8 then
                        return 
                    end
                end
                if players.get_vehicle_model(pid) != 0 and not TASK.GET_IS_TASK_ACTIVE(ped, 160) and GET_SPAWN_STATE(players.user()) != 0 then
                    local driver = NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1))
                    if players.get_name(driver) != "InvalidPlayer" and not pegasusveh and pid == driver and not players.is_in_interior(pid) then
                        if bitset == 1024 then
                            util.draw_debug_text(players.get_name(driver).." Is a 2Take1 User")
                            if not IsDetectionPresent(pid, "2Take1 User") then
                                players.add_detection(pid, "2Take1 User", 7)
                                break
                            end
                        elseif plate_text == " TERROR " then
                            util.draw_debug_text(players.get_name(driver).." Is a Terror User")
                            if not IsDetectionPresent(pid, "Terror User") then
                                players.add_detection(pid, "Terror User", 7)
                                break
                            end
                        elseif plate_text == " MXMENU " then
                            util.draw_debug_text(players.get_name(driver).." Is a MXMenu User")
                            if not IsDetectionPresent(pid, "MXMenu User") then
                                players.add_detection(pid, "MXMenu User", 7)
                                break
                            end
                        elseif plate_text == "  FATE  " then
                            util.draw_debug_text(players.get_name(driver).." Is a Fate User")
                            if not IsDetectionPresent(pid, "Fate User") then
                                players.add_detection(pid, "Fate User", 7)
                                break
                            end
                        elseif bitset == 8 or plate_text == "46EEK572" then
                            local used_vehicle = lang.get_localised(util.get_label_text(players.get_vehicle_model(pid)))
                            util.draw_debug_text(players.get_name(driver).." is using a spawned vehicle ".."("..used_vehicle..")")
                            if not IsDetectionPresent(pid, "Spawned Vehicle") then
                                players.add_detection(pid, "Spawned Vehicle", 7, 50)
                                break
                            end
                        end
                    end
                end
            end
        end)

        -------------------------------------
        -- Thunder Join
        -------------------------------------

        menu.toggle_loop(detections, "Thunder Join", {""}, "Detects if someone is using thunder join.", function()
            for players.list_except(true) as pid do
                if util.is_session_transition_active() then return end
                local old_sh = players.get_script_host()
                util.yield(100)
                local new_sh = players.get_script_host()
                if old_sh != new_sh then
                    if GET_SPAWN_STATE(pid) == 0 and players.get_script_host() == pid then
                        if not IsDetectionPresent(pid, "Thunder Join") then
                            players.add_detection(pid, "Thunder Join", TOAST_DEFAULT, 100)
                            notify(players.get_name(pid) .. " just broke the session. :/")
                            break
                        end
                    end
                end
            end
        end)

        -------------------------------------
        -- Vehicle Godmode
        -------------------------------------

        menu.toggle_loop(detections, "Vehicle Godmode", {""}, "Detects if someone is using a vehicle that is in godmode.", function()
            for players.list() as pid do
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local vehicle = PED.GET_VEHICLE_PED_IS_USING(ped)
                if PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
                    local driver = NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1))
                    if not ENTITY.GET_ENTITY_CAN_BE_DAMAGED(vehicle) and not NETWORK.NETWORK_IS_PLAYER_FADING(pid) and ENTITY.IS_ENTITY_VISIBLE(ped) 
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
    -- Protections
    -------------------------------------

        -------------------------------------
        -- Anti Crash
        -------------------------------------

        menu.toggle(protex, "Render GTA uncrashable", {"panic"}, "Will render GTA:O uncrashable, but the Gameplay will become unplayable.", function(toggled)
            local BlockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Enabled")
            local UnblockNetEvents = menu.ref_by_path("Online>Protections>Events>Raw Network Events>Any Event>Block>Disabled")
            local BlockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Enabled")
            local UnblockIncSyncs = menu.ref_by_path("Online>Protections>Syncs>Incoming>Any Incoming Sync>Block>Disabled")
            if toggled then
                trigger_commands("desyncall on; anticrashcamera on")
                trigger_command(BlockIncSyncs)
                trigger_command(BlockNetEvents)
            else
                trigger_commands("desyncall off; anticrashcamera off")
                trigger_command(UnblockIncSyncs)
                trigger_command(UnblockNetEvents)
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
                for players.list(false, true, true, true, false) as pid do
                    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                    local cam_pos = players.get_cam_pos(pid)
                    if IS_PLAYER_USING_ORBITAL_CANNON(pid) and TASK.GET_IS_TASK_ACTIVE(ped, 135)
                    and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), cam_pos) < 400
                    and v3.distance(ENTITY.GET_ENTITY_COORDS(players.user_ped(), false), cam_pos) > 340 then
                        notify(players.get_name(pid).." Is targeting you with the Orbital Cannon.")
                    end
                    if players.is_in_interior(pid) then
                        if IS_PLAYER_USING_ORBITAL_CANNON(pid) then
                            NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, true)
                        else
                            NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, false)
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
            local md1 = joaat("xm_prop_cannon_room_door")
            local md2 = joaat("xm_prop_cannon_room_door")
            request_model(md1)
            if orb_obj == nil or not ENTITY.DOES_ENTITY_EXIST(orb_obj) then
                orb_obj = entities.create_object(md1, v3(336.56, 4833.00, -60.0))
                entities.set_can_migrate(entities.handle_to_pointer(orb_obj), false)
                ENTITY.SET_ENTITY_HEADING(orb_obj, 125.0)
                ENTITY.FREEZE_ENTITY_POSITION(orb_obj, true)
                ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(players.user_ped(), orb_obj, false)
            end
            request_model(md2)
            if orb_obj2 == nil or not ENTITY.DOES_ENTITY_EXIST(orb_obj2) then
                orb_obj2 = entities.create_object(md2, v3(335.155, 4835.0, -60.0))
                entities.set_can_migrate(entities.handle_to_pointer(orb_obj2), false)
                ENTITY.SET_ENTITY_HEADING(orb_obj2, -55.0)
                ENTITY.FREEZE_ENTITY_POSITION(orb_obj2, true)
                ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(players.user_ped(), orb_obj2, false)
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
                for players.list(false, true, true, true, false) as pid do
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

        menu.toggle_loop(anti_orb, "Send to Team chat", {""}, "Notifies Players in your CEO/MC.", function()
            announce_orb = true
            end, function()
            announce_orb = false
        end)

        -------------------------------------
        -- Orb Postition
        -------------------------------------

        local orbital_blips = {}
        local draw_orbital_blips = false
        menu.toggle(anti_orb, "Show Orbital Cannon", {"showorb"}, "Shows you where the Player is aiming at.", function(on)
            if not util.is_session_transition_active() then
                draw_orbital_blips = on
                while true do
                    if not draw_orbital_blips then 
                        for pid, blip in orbital_blips do 
                            util.remove_blip(blip)
                            orbital_blips[pid] = nil
                        end
                        break 
                    end
                    for players.list(false, true, true, true, true) as pid do
                        local cam_rot = players.get_cam_rot(pid)
                        local cam_pos = players.get_cam_pos(pid)
                        if players.is_in_interior(pid) then
                            if IS_PLAYER_USING_ORBITAL_CANNON(pid) then 
                                util.draw_debug_text(players.get_name(pid).." is Using the Orbital Cannon!")
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
    -- Friend List
    -------------------------------------
    
    menu.divider(friend_lists, "frens:)")
    for i = 0, NETWORK.NETWORK_GET_FRIEND_COUNT() do
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
            for players.list() as pid do
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                if WEAPON.IS_PED_ARMED(ped, 4 | 2) then
                    if WEAPON.HAS_PED_GOT_WEAPON(ped, 177293209) and WEAPON.HAS_PED_GOT_WEAPON_COMPONENT(ped, 177293209, -1981031769) then
                        if explo_reactions == 1 then
                            WEAPON.REMOVE_WEAPON_FROM_PED(ped, 177293209)
                            notify("Removed Weapon From Explo Sniper User\n"..players.get_name(pid).." / "..players.get_rockstar_id(pid))
                            wait(5000)
                        elseif explo_reactions == 2 then
                            WEAPON.REMOVE_WEAPON_COMPONENT_FROM_PED(ped, 177293209, -1981031769)
                            notify("Removed Attachment From Explo Sniper User\n"..players.get_name(pid).." / "..players.get_rockstar_id(pid))
                            wait(5000)
                        elseif explo_reactions == 3 then
                            util.draw_debug_text(players.get_name(pid).." is using the Explo Sniper.")
                        elseif explo_reactions == 4 then
                            trigger_commands("explode"..players.get_name(pid))
                            notify("Killed Explo Sniper User\n"..players.get_name(pid).." / "..players.get_rockstar_id(pid))
                            wait(5000)
                        elseif explo_reactions == 5 then
                            notify("Kicked Explo Sniper User\n"..players.get_name(pid).." / "..players.get_rockstar_id(pid))
                            trigger_commands("kick"..players.get_name(pid))
                            wait(5000)
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

        menu.toggle(spoofing_opt, "Lena's Matchmaking", {""}, "Spoof Session Assets so you'll only be able to play with me.", function(toggled)
            trigger_commands($"extratoggle {toggled}; resetassetchecksum; extravalue 20010224")
        end)

        -------------------------------------
        -- Spoof Session
        -------------------------------------

        menu.toggle(spoofing_opt, "Spoof Session", {"enablespoofing"}, "Enable Session Spoofing. No one will be able to Join, Track or Spectate you.", function(toggled)
            local spoof_ses = menu.ref_by_path("Online>Spoofing>Session Spoofing>Hide Session>Story Mode")
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
    -- Kick High-Ping
    -------------------------------------

    menu.toggle_loop(online, "Kick High-Ping Players", {""}, "Kicks Everyone with a high ping (180)\nNote that the average ping is quite high in most Sessions.", function()
        if util.is_session_started() and not util.is_session_transition_active() then
            for players.list(false, false, true, true, false) as pid do
                local ping = NETWORK.NETWORK_GET_AVERAGE_LATENCY(pid)
                local pname = players.get_name(pid)
                if ping >= 180 then 
                    notify($"{pname} has a high ping!\nPing: "..ping)
                    log($"[Lena | Kick High-Ping] Player {pname} has a high ping! | Ping: {ping}")
                    trigger_commands($"kick {pname}")
                end
                wait(5000)
            end
        end
    end)

    -------------------------------------
    -- Kick Attackers
    -------------------------------------

    menu.toggle_loop(online, "Kick Attackers", {""}, "", function()
        if util.is_session_started() and not util.is_session_transition_active() then
            for players.list(false, false, true, true, false) as pid do
                if players.is_marked_as_attacker(pid) then
                    local pname = players.get_name(pid)
                    local rid = players.get_rockstar_id(pid)
                    local hex = decimalToHex2s(rid, 32)
                    trigger_commands($"savep {pname}")
                    notify($"{pname} has been Kicked for attacking you.")
                    if is_developer() then
                        log($"[Lena | Kick Attackers] {pname} ({rid} / {hex}) has attacked you and got Kicked.")
                    end
                    trigger_commands($"kick {pname}")
                    wait(30000)
                end
            end
        end
    end)

    -------------------------------------
    -- Ghost Session
    -------------------------------------

    menu.toggle(online, "Ghost Session", {"ghostsession"}, "Creates a session within your session where you will not recieve other players syncs, and they will not recieve yours.", function(toggled)
        if toggled then
            NETWORK.NETWORK_START_SOLO_TUTORIAL_SESSION()
        else
            NETWORK.NETWORK_END_TUTORIAL_SESSION()
        end
    end)

    -------------------------------------
    -- Save Players Information on Kick
    -------------------------------------

    menu.toggle(online, "Save Players Information on Kick", {""}, "", function(toggled)
        savekicked = toggled
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

        menu.toggle_loop(sell_stuff, "Easy MC sell", {"easymc"}, "[Broken]", function()
            SET_INT_LOCAL("gb_biker_contraband_sell", 698 + 17, 0)
        end)

        -------------------------------------
        -- Remove Tony's Cut
        -------------------------------------

        -- https://www.unknowncheats.me/forum/3347568-post13086.html
        menu.toggle_loop(sell_stuff, "Tony's Cut of Nightclub be gone", {""}, "[Broken]", function()
            SET_FLOAT_GLOBAL(262145 + 24496, 0) -- -1002770353
        end, function()
            SET_FLOAT_GLOBAL(262145 + 24496, 0.1)
        end)

        -------------------------------------
        -- Instant Finish Bunker
        -------------------------------------

        -- https://www.unknowncheats.me/forum/3521137-post39.html
        menu.action(sell_stuff, "Instant Bunker Sell", {"bunker"}, "Selling Only. [Broken]", function() 
            SET_INT_LOCAL("gb_gunrunning", 1205 + 774, 0)
        end)

        -------------------------------------
        -- Instant Air Cargo
        -------------------------------------

        -- https://www.unknowncheats.me/forum/3513482-post37.html
        menu.action(sell_stuff, "Instant Air Cargo", {"aircargo"}, "Selling Only. [Broken]", function() 
            SET_INT_LOCAL("gb_smuggler", 1928 + 1035, GET_INT_LOCAL("gb_smuggler", 1928 + 1078))
        end)

    -------------------------------------
    -- Missions
    -------------------------------------        

        -------------------------------------
        -- Mission friendly
        -------------------------------------

        menu.toggle(missions_tunables, "Mission Friendly Mode", {"missionfriendly", "mfr"}, "Enables or disables Settings that might interfere with missions.", function(toggled)
            if toggled then
                trigger_commands("lockoutfit off; svmreimpl off; debugnatives off; seamless off")
            end
        end)

        -------------------------------------
        -- Headhunter
        -------------------------------------

        menu.action(missions_tunables, "Headhunter", {"hh"}, "Starts the CEO mission 'Headhunter'.", function()
            if players.get_boss(players.user()) == -1 then
                trigger_commands("ceostart")
                notify("Starting CEO... Please wait for a few seconds.")
                wait(8000)
            end
            if players.get_boss(players.user()) == -1 then
                return
            end
            IA_MENU_OPEN_OR_CLOSE()
            IA_MENU_ENTER(1)
            IA_MENU_DOWN(2)
            IA_MENU_ENTER(1)
            IA_MENU_DOWN(8)
            IA_MENU_ENTER(1)
            IA_MENU_ENTER(1)
            local Blip = HUD.GET_FIRST_BLIP_INFO_ID(432) -- https://docs.fivem.net/docs/game-references/blips/
            while HUD.DOES_BLIP_EXIST(Blip) do
                local Ped = HUD.GET_BLIP_INFO_ID_ENTITY_INDEX(Blip)
                local addr = entities.handle_to_pointer(Ped)
                entities.set_can_migrate(addr, false)
                entities.give_control_by_pointer(addr, players.user())
                Blip = HUD.GET_NEXT_BLIP_INFO_ID(432)
                wait(2000)
            end
        end, nil, nil, COMMANDPERM_FRIENDLY)

        -------------------------------------
        -- Finish Headhunter
        -------------------------------------

        menu.action(missions_tunables, "Finish Headhunter", {""}, "Tries to finish the Mission.", function()
            local Blip = HUD.GET_FIRST_BLIP_INFO_ID(432) -- https://docs.fivem.net/docs/game-references/blips/
            while HUD.DOES_BLIP_EXIST(Blip) do
                request_control(Blip, false)
                local Ped = HUD.GET_BLIP_INFO_ID_ENTITY_INDEX(Blip)
                ENTITY.SET_ENTITY_HEALTH(Ped, 0)
                Blip = HUD.GET_NEXT_BLIP_INFO_ID(432)
                wait(1000)
            end
            wait(1000)
        end)

        -------------------------------------
        -- Take over LSIA
        -------------------------------------

        menu.action(missions_tunables, "Take over LSIA", {"lsia"}, "Starts the CEO Mission 'Hostile Takeover'.", function()
            if players.get_boss(players.user()) == -1 then
                trigger_commands("ceostart")
                notify("Starting CEO. Please wait for a few seconds.")
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
            for entities.get_all_pickups_as_handles() as pickup do
                ENTITY.SET_ENTITY_COORDS(pickup, pos, false, false, false, false)
                counter += 1
                wait(100)
            end
            if counter == 0 then
                notify("No Pickups Found. :/")
            else
                notify("Teleported "..tostring(counter).." Pickups to you.")
            end
        end)

        -------------------------------------
        -- Kill All Peds
        -------------------------------------

        menu.action(missions_tunables, "Kill All Peds", {"killpeds"}, "Kills all Mission Peds.", function()
            local counter = 0
            for entities.get_all_peds_as_handles() as ped do
                if HUD.GET_BLIP_COLOUR(HUD.GET_BLIP_FROM_ENTITY(ped)) == 1 or TASK.GET_IS_TASK_ACTIVE(ped, 352) then
                    ENTITY.SET_ENTITY_HEALTH(ped, 0)
                    counter += 1
                    wait(100)
                end
            end
            if counter == 0 then
                notify("No Peds Found. :/")
            else
                notify("Killed "..tostring(counter).." Mission Peds.")
            end
        end)

    -------------------------------------
    -- Skip Casino Hacking Process
    -------------------------------------

    menu.toggle_loop(missions_tunables, "Skip Casino Hacking Process", {""}, "Works on Fingerprint and Keypad.", function()
        if GET_INT_LOCAL("fm_mission_controller", 52964) ~= 1 then -- func_13586(&Local_52962, &(Local_52897[bParam1 /*2*/]), 0, joaat("heist"), Global_786547.f_1);
            SET_INT_LOCAL("fm_mission_controller", 52964, 5)
        end
        if GET_INT_LOCAL("fm_mission_controller", 54026) ~= 1 then -- func_13588(&Local_54024, &(Local_53959[bParam1 /*2*/]), 0, joaat("heist"), Global_786547.f_1);
            SET_INT_LOCAL("fm_mission_controller", 54026, 5)
        end
    end)

    -------------------------------------
    -- Refill Snacks and Armor
    -------------------------------------

    menu.action(tunables, "Refill Snacks & Armours", {"refillsnacks"}, "Refills all Snacks and Armour.", function()
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
        trigger_commands("admindlc "..toggled)
    end)

    -------------------------------------
    -- Start a BB
    -------------------------------------

    local start_a_bb = menu.ref_by_path("Online>Session>Session Scripts>Run Script>Freemode Activities>Business Battle 1")
    menu.action(tunables, "Start a Business Battle", {"bb"}, "Starts a 2 Crate Business Battle.", function()
        if menu.get_edition() >= 3 then 
            trigger_command(start_a_bb)
        else
            notify("You need Ultimate to Start a Business Battle. Request denied.")
        end
    end, nil, nil, COMMANDPERM_FRIENDLY)

    -------------------------------------
    -- Nightclub Popularity
    -------------------------------------    

    menu.toggle_loop(tunables, "Nightclub Popularity", {""}, "Keeps the Nightclub Popularity at 90%.", function()
        if util.is_session_started() then
            local ncpop = math.floor(STAT_GET_INT("CLUB_POPULARITY") / 10)
            if ncpop < 90 then
                notify("NC Popularity Maxed.")
                log("[Lena | NC Popularity] NC Popularity Maxed.")
                trigger_commands("clubpopularity 100")
                wait(250)
            end
        end
    end)
    menu.action(tunables, "Max NC Popularity", {"maxnc"}, "Sets the Club Popularity to 100%.", function()
        trigger_commands("clubpopularity 100")
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
            menu.action(teleport, location_name, {"tpl"..location_name}, "", function()
                trigger_commands("doors on; nodeathbarriers on")
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
        -- Clear Vehicles
        -------------------------------------

        menu.list_action(clear_area_locally, "Clear All", {""}, "", {"Vehicles", "Peds", "Objects"}, function(index, name)
            notify("Clearing "..name:lower().."...")
            local clean_amount = 0
            switch index do
                case 1:
                    for entities.get_all_vehicles_as_pointers() as vehicle do
                        if vehicle != entities.get_user_vehicle_as_pointer(true) and entities.get_owner(vehicle) == players.user() then
                            entities.delete(vehicle)
                            clean_amount += 1
                            wait(50)
                        end
                    end
                    break
                case 2:
                    for entities.get_all_peds_as_pointers() as ped do
                        if not (NETWORK.NETWORK_IS_ACTIVITY_SESSION() and ENTITY.IS_ENTITY_A_MISSION_ENTITY(ped)) and entities.get_owner(ped) == players.user() then
                            entities.delete(ped)
                            clean_amount += 1
                            wait(50)
                        end
                    end
                break
                case 3:
                    for entities.get_all_objects_as_handles() as object do
                        if entities.get_owner(object) == players.user() then
                            entities.delete(object)
                            clean_amount += 1
                            wait(50)
                        end
                    end
                break
            end
            notify("Cleared "..tostring(clean_amount).." "..name:lower()..".")
        end)

        -------------------------------------
        -- Clear Area All
        -------------------------------------

        menu.action(clear_area_locally, "Clear Area", {"ca"}, "Clears the Area around you without sending Freeze events.", function()
            local clear_ropes = menu.ref_by_path("World>Inhabitants>Delete All Ropes")
            local count = 0
            for entities.get_all_peds_as_pointers() as ped do
                if ped != players.user_ped() and entities.get_owner(ped) == players.user() and not NETWORK.NETWORK_IS_ACTIVITY_SESSION() then
                    entities.delete_by_pointer(ped)
                    count += 1
                    wait(10)
                end
            end
            notify("Deleted "..count.." Peds!")
            count = 0
            wait(100)
            for entities.get_all_vehicles_as_pointers() as vehicle do
                if vehicle != entities.get_user_vehicle_as_pointer(true) and entities.get_owner(vehicle) == players.user() then
                    entities.delete_by_pointer(vehicle)
                    count += 1
                    wait(10)
                end
            end
            notify("Deleted ".. count .." Vehicles!")
            count = 0
            wait(100)
            for entities.get_all_objects_as_handles() as object do
                if entities.get_owner(object) == players.user() then
                    entities.delete(object)
                    count += 1
                    wait(10)
                end
            end
            notify("Deleted "..count.." Objects!")
            count = 0
            wait(100)
            for entities.get_all_pickups_as_pointers() as pickup do
                if entities.get_owner(pickup) == players.user() then
                    entities.delete_by_pointer(pickup)
                    count += 1
                    wait(10)
                end
            end
            notify("Deleted "..count.." Pickups!")
            wait(100)
            trigger_command(clear_ropes)
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
            trigger_commands("givesh"..players.get_name(players.user()))
        end)

        -------------------------------------
        -- Easy Way Out
        -------------------------------------

        menu.action(shortcuts, "Really easy Way out", {"kms"}, "Kill yourself.", function()
            local pos = players.get_position(players.user())
            FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), pos.x, pos.y, pos.z - 1.0, 5, 1.0, false, false, 1.0)
        end)

        -------------------------------------
        -- Stop all Sounds
        -------------------------------------

        menu.action(shortcuts, "Stop all sound events", {"stopsounds"}, "Stops all current Sounds from playing. Does not stop Scripted Music.", function()
            for i = 1, 99 do
                AUDIO.STOP_SOUND(i)
                AUDIO.RELEASE_SOUND_ID(i)
                AUDIO.STOP_PED_RINGTONE(players.user_ped())
            end
        end)

        -------------------------------------
        -- Start a CEO
        ------------------------------------- 

        if is_developer() then
            menu.action(shortcuts, "Start a CEO", {"ceo"}, "Starts a CEO.", function()
                if players.get_boss(players.user()) == -1 then
                    trigger_commands("ceostart")
                    wait(3000)
                    trigger_commands("ceoname ¦ Monarch")
                elseif players.get_boss(players.user()) == players.user() then
                    notify("You are already your own Boss.")
                    trigger_commands("ceoname ¦ Monarch")
                else
                    notify("You are already working for someone else!")
                end
                wait(10000)
                if players.get_boss(players.user()) == -1 then
                    trigger_commands("ceo")
                    notify("CEO couldn't be started, trying again...")
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
            if players.get_boss(players.user()) == -1 then
                trigger_commands("ceostart")
                notify("Starting CEO... Please wait for a few secs.")
                wait(5000)
            end
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
        -- Race Mode
        -------------------------------------

        menu.action(vehicle, "Race Mode", {"racemode"}, "Changes some settings that makes races more fair.", function()
            trigger_commands("perf; gravitymult 1; enginepowermult 1")
        end)

    -------------------------------------
    -- Disable Numpad
    -------------------------------------

    menu.toggle_loop(misc, "Disable Numpad", {"dn"}, "Disables the Numpad while Stand is open.", function()
        if not menu.is_open() then return end
        for numpadControls as control do
            PAD.DISABLE_CONTROL_ACTION(2, control, true)
        end
    end)

    -------------------------------------
    -- Toggle Thunder Weather
    -------------------------------------

    menu.toggle(misc, "Toggle Thunder Weather", {"thunder"}, "Requests Thunder Session-wide.", function(on_toggle) 
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
    -- Auto Accept Joining Games
    -------------------------------------

    menu.toggle_loop(misc, "Auto Accept Joining Games", {""}, "Will auto accept join screens.", function()
        local message_hash = HUD.GET_WARNING_SCREEN_MESSAGE_HASH()
        local hashes = {99184332, 15890625, -398982408, -587688989, 15890625}
        for hashes as hash do
            if message_hash == hash then
                PAD.SET_CONTROL_VALUE_NEXT_FRAME(2, 201, 1.0)
                wait(50)
            end
        end
    end)

    -------------------------------------
    -- Skip Warning Messages
    -------------------------------------    

    menu.toggle_loop(misc, "Skip Warning Messages", {""}, "Skips annoying Warning Messages.", function()
        local message_hash = HUD.GET_WARNING_SCREEN_MESSAGE_HASH()
        local hashes = {1990323196, 1748022689, -396931869, -896436592, 583244483}
        for hashes as hash do
            if message_hash == hash then
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
            chat.ensure_open_with_empty_draft(false)
            chat.add_to_draft("¦ | ")
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
    
    menu.toggle(misc, "No Traffic", {""}, "Deletes all Traffic from the Map. Works Session-Wide.", function(on)
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
    -- Enable/Disable ESP
    -------------------------------------

    menu.toggle(misc, "Enable/Disable ESP", {""}, "", function(toggled)
        local bone_esp_on = menu.ref_by_path("World>Inhabitants>Player ESP>Bone ESP>Low Latency Rendering")
        local bone_esp_off = menu.ref_by_path("World>Inhabitants>Player ESP>Bone ESP>Disabled")
        local name_esp_on = menu.ref_by_path("World>Inhabitants>Player ESP>Name ESP>Name ESP>Low Latency Rendering")
        local name_esp_off = menu.ref_by_path("World>Inhabitants>Player ESP>Name ESP>Name ESP>Disabled")
        if toggled then
            trigger_command(bone_esp_off); trigger_command(name_esp_off)
        else
            trigger_command(bone_esp_on); trigger_command(name_esp_on)
        end
    end)

    -------------------------------------
    -- Enable/Disable ESP
    -------------------------------------

    menu.toggle_loop(misc, "Show OS Date", {""}, "Shows the current Day, Month and Time.", function()
        trigger_commands("infotime off")
        util.draw_debug_text(os.date("%a, %d. %B %X"))
    end)

    -------------------------------------
    -- Enable/Disable ESP
    -------------------------------------

    menu.toggle_loop(misc, "Disable Phone", {""}, "Disables the Phone when certain conditions are met.", function()
        local phone = menu.ref_by_path("Game>Disables>Straight To Voicemail")
        if chat.is_open() or PLAYER.IS_PLAYER_FREE_AIMING(players.user()) or util.is_interaction_menu_open() or menu.is_open() then
            if phone.value == false then
                phone.value = true
            end
        elseif phone.value == true then
            phone.value = false
        end
    end)



    -------------------------------------
    -- Russian Roulette
    -------------------------------------

    menu.action(misc, "Russian Roulette", {""}, "Feeling Lucky?", function()
        local is_bullet_in_my_head = math.random(6)
        if is_bullet_in_my_head == 1 then
            notify("You have lost the Game.")
            log(os.date("On %A the %x at %X your game suffered a critical error and died. It will be remembered."))
            wait(1000)
            PED.GET_CLOSEST_PED(players.user_ped(), false, false)
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

    menu.action(ai_made, "Countdown", {"countdown"}, "Start the countdown.", function()
        for i = 3, 1, -1 do
            chat.send_message(i.."...", false, true, true)
            wait(1000)
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
        local user = players.user()
        local has_bounty = players.get_bounty(user)
        if has_bounty and players.is_in_interior(user) then
        elseif has_bounty and not (util.is_session_transition_active() and players.is_in_interior(user)) then
            repeat
                trigger_commands("removebounty")
                wait(5000)
                bounty = players.get_bounty(players.user())
            until bounty == nil
            notify("Bounty has been Claimed.")
        end
        wait(20000)
    end)

    -------------------------------------
    -- Auto Skip Cutscenes
    -------------------------------------      

    menu.toggle_loop(ai_made, "Auto Skip Cutscenes", {"auto_skip_cutscenes"}, "Automatically skips cutscenes.", function()
        if CUTSCENE.IS_CUTSCENE_PLAYING() then
            repeat
                CUTSCENE.STOP_CUTSCENE_IMMEDIATELY()
            until not CUTSCENE.IS_CUTSCENE_PLAYING()
            notify("Cutscene skipped!")
        end
    end)
    
    -------------------------------------
    -- Auto Skip Conversations
    -------------------------------------

    menu.toggle_loop(ai_made, "Auto Skip Conversations", {"auto_skip_conversations"}, "Automatically skips conversations.", function()
        if AUDIO.IS_SCRIPTED_CONVERSATION_ONGOING() then
            repeat
                AUDIO.STOP_SCRIPTED_CONVERSATION(false)
            until not AUDIO.IS_SCRIPTED_CONVERSATION_ONGOING()
            notify("Conversation skipped!")
        end
    end)
    
-------------------------------------
-------------------------------------
-- [Debug]
-------------------------------------
-------------------------------------

if is_developer() then
    local sdebug = menu.list(menu.my_root(), "[Debug]", {"lenadebug"}, "")
    local nativec = menu.list(sdebug, "Native Feedback", {""}, "")
    local json = require("json")

    menu.toggle(sdebug, "Math Bot", {"mathbot"}, "Enables the math bot to evaluate math expressions. Usage: @vel <expression>.", function(enabled)
        math_reply = enabled
    end)
    chat.on_message(on_math_message)

    --[[menu.toggle(sdebug, "Chat Relay", {"chatrelay"}, "Enable Discord Webhook", function(enabled)
        webhook_enabled = enabled
        -- Check if the webhook URL is valid
        if webhook_url == "" or nil then
            notify("Webhook URL is not set.")
            util.open_folder(lenaDir)
            trigger_commands("chatrelay off")
        else
            if webhook_enabled then
                notify("Discord Webhook enabled.")
            else
                notify("Discord Webhook disabled.")
            end
        end
    end)
    chat.on_message(send_to_discord_webhook)]]

    -------------------------------------
    -- Restart Session Scripts
    -------------------------------------

    rss = menu.action(sdebug, "Restart Session Scripts", {"rss"}, "Restarts the freemode.c script.\nThis will remove your weapons for some reason. Kill yourself and you will get them back.", function(click_type)
        trigger_commands("skiprepeatwar off; commandsskip off")
        wait(1000)
        if not util.is_session_transition_active() then
            if players.get_script_host() == nil and players.get_host() != players.user() then
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
            elseif players.get_script_host() != nil and players.get_host() != players.user() then
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
            elseif players.get_script_host() != nil then
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

    local modified_vehicle = menu.readonly(sdebug, "Modified Vehicle: ", "N/A")
    menu.toggle_loop(sdebug, "Better Vehicles", {"bv"}, "", function()
        local vmodel = players.get_vehicle_model(players.user())
        local vname = util.get_label_text(vmodel)
        local CHandlingData = entities.vehicle_get_handling(entities.get_user_vehicle_as_pointer())
        local CflyingHandling = entities.handling_get_subhandling(CHandlingData, 1)
        if entities.get_user_vehicle_as_pointer(false) != 0 then
            if menu.get_value(modified_vehicle, vname) != vname then
                if VEHICLE.IS_THIS_MODEL_A_PLANE(vmodel) then
                    if vmodel == -1700874274 then
                        trigger_commands("vhengineoffglidemulti 10; vhgeardownliftmult 1")
                    else
                        for better_planes as offsets do
                            local handling = offsets[1]
                            local value = offsets[2]
                            memory.write_float(CflyingHandling + handling, value)
                        end
                    end
                    notify("Better Planes have been enabled for: "..vname)
                    trigger_commands("fovfpinveh 90; gravitymult 2")
                elseif VEHICLE.IS_THIS_MODEL_A_HELI(vmodel) then
                    for better_heli_offsets as offset do
                        memory.write_float(CflyingHandling + offset, 0)
                    end
                    trigger_commands("gravitymult 1; helithrust 2.3")
                    notify("Better Helis have been enabled for: "..vname)
                elseif util.is_this_model_a_blimp(vmodel) then
                    notify("Better Blimps have been enabled for: "..vname)
                    trigger_commands("gravitymult 1; helithrust 2.3; betterheli")
                else
                    trigger_commands("gravitymult 2; fovfpinveh -5")
                end
                menu.set_value(modified_vehicle, vname)
            end
        end
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
            maxAddress   = addr_from_pointer_chain(PedPointer, {0x10B8, pointer, 0x28C}),
            rangeAddress = addr_from_pointer_chain(PedPointer, {0x10B8, pointer, 0x288}),
        }
            
        modifiedRange[weaponHash].originalMin   = memory.read_float(modifiedRange[weaponHash].minAddress)
        modifiedRange[weaponHash].originalMax   = memory.read_float(modifiedRange[weaponHash].maxAddress)
        modifiedRange[weaponHash].originalRange = memory.read_float(modifiedRange[weaponHash].rangeAddress)
    
        memory.write_float(modifiedRange[weaponHash].minAddress,   10000)
        memory.write_float(modifiedRange[weaponHash].maxAddress,   10000)
        memory.write_float(modifiedRange[weaponHash].rangeAddress, 10000)
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
            log($"[Lena | Debug] Warning Screen hash: {hash}")
        end)

        -------------------------------------
        -- VEHICLE
        -------------------------------------

        menu.action(nativevehicle, "Get Vehicle", {""}, "Gets The current Model and Name.", function()
            local user = players.user()
            local vname = lang.get_localised(util.get_label_text(players.get_vehicle_model(user)))
            local vmodel = players.get_vehicle_model(user)
            local modelname = util.reverse_joaat(vmodel)
            local vehicle = PED.GET_VEHICLE_PED_IS_USING(players.user_ped())
            local plate_text = VEHICLE.GET_VEHICLE_NUMBER_PLATE_TEXT(vehicle)
            local bitset = DECORATOR.DECOR_GET_INT(vehicle, "MPBitset")
            notify("Hash: {vmodel}\nName: {vname}\nJoaat: {modelname}\nBitset: {bitset}")
            log("[Lena | Debug] Hash: {vmodel} | Name: {vname} | Joaat: {modelname} | Bitset: {bitset} | Plate:{plate_text}|")
        end)
        
        menu.action(nativevehicle, "Set Number Plate", {""}, "Sets the Current Number Plate to a random Text.", function()
            local plate_texts = {"VEROSA", "LOVE", "LOVE YOU", "TOCUTE4U", "TOFAST4U", "LENA", "LENALEIN", "HENTAI", "FNIX", "SEXY", "CUWUTE", " ", "2TAKE1", "FATE", "WHORE"}
            VEHICLE.SET_VEHICLE_NUMBER_PLATE_TEXT(entities.get_user_vehicle_as_handle(), plate_texts[math.random(#plate_texts)])
        end)

        -------------------------------------
        -- ENTITY
        -------------------------------------

        menu.action(nativeentity, "Clone Player", {""}, "Clones the Player Ped.", function()
            local whore = PED.CLONE_PED(players.user_ped(), true, true, true)
            local cords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), -5.0, 0.0, 0.0)
            ENTITY.SET_ENTITY_COORDS(whore, cords.x, cords.y, cords.z)
            ENTITY.FREEZE_ENTITY_POSITION(whore, true)
            -- TASK.TASK_START_SCENARIO_IN_PLACE(whore, "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS", 0, false) -- Shrugs
        end)
    --end
end

--------------------------------------------------------------------------------
------------------------------- PLAYER FEATURES --------------------------------
--------------------------------------------------------------------------------

local function player(pid)
    local idiots = {
        0x0C6A8CD9, 0x0CAFF827, 0x04DCD691, 0x07E862F8, 0x096E22A3, 0x0967E1C2, 0x0ACF5EAB, 0x0BE13BA9,
        0x0B0236FA, 0x01585AB7, 0x09038DD9, 0x01394640, 0x0CB7CFF2, 0x0C666371, 0x04A5C95B, 0x0C76C9E2, 0x0B7EC980, 0x0C121CAD, 0x0919B57F, 0x0C682AB5, 0x03280B78, 0x0479C7D8,
        0x0BB6BAE6, 0x05EB0C06, 0x0C0EFC07, 0x0A9FD9CD, 0x0A1FA84B, 0x0101D84E, 0x0CA6E931, 0x0691AC07, 0x0AA87C21, 0x0988DB36, 0x06AE10E2, 0x071D0AF9, 0x0B93038B, 0x0D029C4A,
        0x0CCC3A82, 0x02314B16, 0x0C2590C9, 0x0D193EEE, 0x0BE0E3BE, 0x09D7781F, 0x0BCA5D8C, 0x0AFA420F, 0x07E06196, 0x0CDC6337, 0x0B8B307C, 0x0C0DEC0E, 0x04999905, 0x028C8ADD,
        0x0B57C870, 0x005A41F0, 0x0C7EC044, 0x0CBDDE32, 0x0860F534, 0x0B848C99, 0x07508CFB, 0x0A07EB9E, 0x06F51B2F, 0x03097926, 0x0D04F24C, 0x0AE5DA82, 0x0A7D2684, 0x0BF272C9,
        0x0B38BC94, 0x0083EAD9, 0x0CFC75F7, 0x004D2E05, 0x5AB5E2F2, 0x0A739990, 0x01904EBA, 0x01480A39, 0x09A5E63E, 0x075A591F, 0x0C50A172, 0x00D344E0, 0x0C6C9C9E, 0x098105F0,
        0x0B316B93, 0x0D3C0DD1, 0x05059BDC, 0x097D765F, 0x0BEE6E37, 0x061EADCF, 0x0984EECF, 0x0C7290DE, 0x0BE2A63A, 0x041B4798, 0x0C7D65E8, 0x09667B59, 0x06298EFC, 0x04BB8D72,
        0x0B2E000F, 0x0C0ADFC5, 0x0B23A552, 0x0CEBEA08, 0x0CB2AB74, 0x0AEBC1AF, 0x05BCAAD9, 0x0B0F32F8, 0x0BE93141, 0x09F72C49, 0x086B5F3F, 0x0BAD4E5C, 0x0C9B1FA5, 0x0AF83D87,
        0x09F6C328, 0x07DC40B4, 0x058DCDAD, 0x0C46C36E, 0x0A22088E, 0x0CBAAEB3, 0x0BE7C35E, 0x0D5021BD, 0x0D44E8AF, 0x0963AC38, 0x0D1788D8, 0x083121AB, 0x070C1D13, 0x0C025C35,
        0x04504CCB, 0x0C15670E, 0x09DC648E, 0x0046658F, 0x00456136, 0x05D5715F, 0x0D1E3C6E, 0x07B6FB71, 0x0C98B465, 0x0C4EC8C9, 0x071A5EE2, 0x0AC7DADC, 0x0270B92D, 0x0BD93DCF,
        0x0CFF2596, 0x0C9CE642, 0x0C4FBEC1, 0x0BB7CBB2, 0x0AD078FA, 0x0ACD50CE, 0x0BEBF7A0, 0x080A4E57, 0x04CB6ACE, 0x093EA186, 0x0BF770F5, 0x0C732D5C, 0x0C732D5C, 0x0CC8C37C,
        0x0A507921, 0x04BE7D5E, 0x0C42877C, 0x09025232, 0x0962404A, 0x07B42014, 0x0B1800ED, 0x0D2D6965, 0x06B87017, 0x0D67118D, 0x0AE5341D, 0x05207167, 0x0CC31372, 0x0D66E920,
        0x0C06B41B, 0x09A04033, 0x0A418EC7, 0x02BBC305, 0x0D7A14FA, 0x08BB6007, 0x0C16EF5D, 0x0D82134A, 0x0B2CB11C, 0x0B87DDD3, 0x0D4724F0, 0x0D8EBBE0, 0x0988D182, 0x0D034B04,
        0x0BB99133, 0x09F8E801, 0x0D30AB72, 0x061C76CC, 0x09F3C018, 0x07055ED0, 0x0A1A9845, 0x0D711697, 0x0D75C336, 0x0888E5C8, 0x0BA85E95, 0x0B658239, 0x03506E1C, 0x0D887E44,
        0x0483D6DB, 0x0ACA2C3C, 0x0CD4F051, 0x0CF5ADDF, 0x08D927AC, 0x0D61E548, 0x0D860841, 0x0D9F98D8, 0x07798523, 0x0743AB21, 0x0D0A812F, 0x08096A21, 0x08BF9765, 0x0240CB5D,
        0x0B473EB5, 0x0BD6DB64, 0x0BE008C1, 0x0BCEFDB0, 0x0B5832AD, 0x0BFEE41B, 0x0C5FA5FC, 0x05C0A3AB, 0x018E3066, 0x089275E0, 0x0D9FAB7B, 0x0C4B31D6, 0x0A50EC88, 0x0675D817,
        0x0C080BB7, 0x02946AEA, 0x009DC11A, 0x0D539ECC, 0x0652306A, 0x03EF8419, 0x01C71674, 0x084EBAB3, 0x0BFDD257, 0x02F82A67, 0x0D4B35D2, 0x0D2F87B9, 0x09549E51, 0x0D629E9C,
        -- Retard/Sexual Abuser
        0x0CE7F2D8, 0x0CDF893D, 0x0C50A424, 0x0C68262A, 0x0CEA2329, 0x0D040837, 0x0A0A1032, 0x0D069832, 0x0B7CF320
    }

    for idiots as rid do
        if players.get_rockstar_id(pid) == rid and players.are_stats_ready(pid) and not util.is_session_transition_active() then
            if NETWORK.NETWORK_IS_HOST() then
                trigger_commands("historyblock"..players.get_name(pid).." on")
                wait(100)
                trigger_commands("kick "..players.get_name(pid))
            else
                trigger_commands("historyblock"..players.get_name(pid).." on")
                trigger_commands("loveletter"..players.get_name(pid))
            end
        end
    end

    menu.divider(menu.player_root(pid), "Lena Utilities")
    local lena = menu.list(menu.player_root(pid), "Lena Utilities", {"lenau"}, "")

    menu.action(lena, "Mark As Modder", {"manual"}, "", function()
        if not IsDetectionPresent(pid, "Manual") then
            players.add_detection(pid, "Manual", 7, 100)
        end
    end)

    local friendly = menu.list(lena, "Friendly", {""}, "")

    local mpvehicle = menu.list(lena, "Vehicle", {""}, "")

    local trolling = menu.list(lena, "Trolling", {""}, "")
    local customExplosion = menu.list(trolling, "Custom Explosion", {""}, "")
    local mpcage = menu.list(trolling, "Cage", {""}, "")
    local vehattack = menu.list(trolling, "Attackers", {""}, "")
    local tp_player = menu.list(trolling, "Teleport Player", {""}, "")
    local clubhouse = menu.list(tp_player, "Clubhouse", {""}, "")
    local facility = menu.list(tp_player, "Facility", {""}, "")
    local arcade = menu.list(tp_player, "Arcade", {""}, "")
    local warehouse = menu.list(tp_player, "Warehouse", {""}, "")
    local large = menu.list(warehouse, "Large Warehouse", {""}, "")
    local cayop = menu.list(tp_player, "Cayo Perico", {""}, "")

    local player_removals = menu.list(lena, "Player Removals", {""}, "")
    local kicks = menu.list(player_removals, "Kicks", {""}, "")
    local crashes = menu.list(player_removals, "Crashes", {""}, "")

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
        -- Check Stats
        -------------------------------------

        menu.action(friendly, "Check Stats", {"checkstats"}, "Checks the stats of the Player.", function()
            local rank = players.get_rank(pid)
            local money = players.get_money(pid)
            local kills = players.get_kills(pid)
            local deaths = players.get_deaths(pid)
            local kdratio = players.get_kd(pid)
            local language = language_string(players.get_language(pid))
            notify("Name : "..players.get_name(pid).."\nLanguage: "..language.. "\nRank: "..rank.."\nMoney: "..string.format("%.2f", money/1000000).."M$".."\nKills/Deaths: "..kills.."/"..deaths.."\nRatio: "..string.format("%.2f", kdratio))
        end)

        -------------------------------------
        -- Summon
        -------------------------------------        

        menu.action(friendly, "TP to Me", {"tptome"}, "Improved \"summon\" Command", function()
            trigger_commands("givesh"..players.get_name(pid)); wait(100); trigger_commands("summon"..players.get_name(pid))
        end, nil, nil, COMMANDPERM_RUDE)

        -------------------------------------
        -- Invite to CEO/MC
        -------------------------------------

        menu.action(friendly, "Invite to CEO/MC", {"ceoinv"}, "Invites the Player to your CEO/MC.", function()
            sendse(1 << pid, {
                -245642440,
                players.user(),
                4,
                10000, -- wage?
                0, 0, 0, 0,
                memory.read_int(memory.script_global(1924276 + 9)), -- .f_8
                memory.read_int(memory.script_global(1924276 + 10)), -- .f_9
            })
        end, nil, nil, COMMANDPERM_FRIENDLY)

        -------------------------------------
        -- Fix Blackscreen
        -------------------------------------         

        menu.action(friendly, "Fix Blackscreen", {"fixblackscreen"}, "Tries to fix a stuck Blackscreen for the selected Player.", function()
            local player = players.get_name(pid)
            trigger_commands($"givesh {player}; aptme {player}")
        end, nil, nil, COMMANDPERM_FRIENDLY)

        -------------------------------------
        -- Set Waypoint
        -------------------------------------

        menu.action(friendly, "Set Waypoint", {"setwp"}, "", function()
            HUD.SET_NEW_WAYPOINT(players.get_position(pid))
        end)

        -------------------------------------
        -- Stealth Messages
        -------------------------------------

        menu.action(friendly, "Stealth msg", {"pm"}, "Sends a Stealth Message.", function(click_type)
            menu.show_command_box("pm"..players.get_name(pid).." ")
            end, function(on_command)
                if #on_command > 140 then
                    notify("The message is to long.")
                else
                    chat.send_targeted_message(pid, players.user(), on_command, false)
                    log(players.get_name(players.user()).." [All] ".. on_command)
                end
        end)

        -------------------------------------
        -- Spectate
        -------------------------------------

        local spec = menu.ref_by_rel_path(menu.player_root(pid), "Spectate")
        brv_six = menu.toggle(spec, "Bravo Six Method", {"bravo"}, "Bravo six, going dark. Blocks Outgoing Syncs with the Player.", function(toggled)
            local outgoingSyncs = menu.ref_by_rel_path(menu.player_root(pid), "Outgoing Syncs>Block")
            local nuts = menu.ref_by_rel_path(menu.player_root(pid), "Spectate>Nuts Method")
            if pid == players.user() then 
                notify(lang.get_localised(-1974706693)) 
                brv_six.value = false
                util.stop_thread()
            end
            trigger_command(outgoingSyncs, toggled)
            wait(100)
            trigger_command(nuts, toggled)
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
            local vehicle = get_vehicle_player_is_in(pid)
            if ENTITY.DOES_ENTITY_EXIST(vehicle) and request_control(vehicle) then
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
                VEHICLE.SET_VEHICLE_CAN_BE_VISIBLY_DAMAGED(vehicle, off)
                VEHICLE.SET_VEHICLE_CAN_BREAK(vehicle, off)
                VEHICLE.SET_VEHICLE_ENGINE_CAN_DEGRADE(vehicle, off)
                VEHICLE.SET_VEHICLE_EXPLODES_ON_HIGH_EXPLOSION_DAMAGE(vehicle, off)
                VEHICLE.SET_VEHICLE_TYRES_CAN_BURST(vehicle, off)
                VEHICLE.SET_VEHICLE_WHEELS_CAN_BREAK(vehicle, off)
            end
        end, nil, nil, COMMANDPERM_FRIENDLY)

        -------------------------------------
        -- Repair Vehicle
        -------------------------------------

        menu.action(mpvehicle, "Repair Vehicle", {"rpv"}, "Repais the current Vehicle.", function()
            local vehicle = get_vehicle_player_is_in(pid)
            if ENTITY.DOES_ENTITY_EXIST(vehicle) and request_control(vehicle) then
                VEHICLE.SET_VEHICLE_FIXED(vehicle)
                VEHICLE.SET_VEHICLE_DEFORMATION_FIXED(vehicle)
                VEHICLE.SET_VEHICLE_DIRT_LEVEL(vehicle, 0.0)
            end
        end, nil, nil, COMMANDPERM_FRIENDLY)

        -------------------------------------
        -- Clean Vehicle
        -------------------------------------

        menu.action(mpvehicle, "Clean Vehicle", {"cleanv"}, "Cleans the current Vehicle.", function()
            local vehicle = get_vehicle_player_is_in(pid)
            if ENTITY.DOES_ENTITY_EXIST(vehicle) and request_control(vehicle) then
                VEHICLE.SET_VEHICLE_DIRT_LEVEL(vehicle, 0.0)
            end
        end, nil, nil, COMMANDPERM_FRIENDLY)

        -------------------------------------
        -- Launch Player Vehicle
        -------------------------------------

        menu.action_slider(mpvehicle, "Launch Player Vehicle", {"launch"}, "Launches the Player's Vehicle in the Selected direction.", launch_vehicle, function(index, value)
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
            if not PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
                notify("Player isn't in a vehicle. :/")
                return
            end
            request_control(veh)
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
        end, nil, nil, COMMANDPERM_FRIENDLY)

        -------------------------------------
        -- Hurricane
        -------------------------------------

        menu.toggle(mpvehicle, "Hurricane", {""}, "", function(toggled)
            local ram = menu.ref_by_rel_path(menu.player_root(pid), "Trolling>Ram>Ram")
            local speed = menu.ref_by_rel_path(menu.player_root(pid), "Trolling>Ram>Speed")
            local veh = menu.ref_by_rel_path(menu.player_root(pid), "Trolling>Ram>Vehicle>Commercial>Terrorbyte")
            trigger_command(veh); speed.value = 200
            usinghurricane = toggled
            while usinghurricane and not PLAYER.IS_PLAYER_DEAD(pid) do
                trigger_command(ram)
                wait(100)
            end
        end, nil, nil, COMMANDPERM_RUDE)

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
            auto_cage = menu.toggle_loop(mpcage, "Automatic Cage", {"autocage"}, "Automatically Cages the Player.", function()
                if not players.exists(pid) then
                    util.stop_thread()
                    auto_cage.value = false
                    return
                end
                local targetPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local playerPos = ENTITY.GET_ENTITY_COORDS(targetPed, false)
                if not cagePos or cagePos:distance(playerPos) >= 4.0 then
                    TASK.CLEAR_PED_TASKS_IMMEDIATELY(targetPed)
                    if PED.IS_PED_IN_ANY_VEHICLE(targetPed, false) then return end
                    cagePos = playerPos
                    trapcage(pid, "prop_gold_cont_01", true)
                    local name = players.get_name(pid)
                    if name != "**Invalid**" then
                        notify($"{name} was out of the cage!")
                        trapcage(pid, "prop_gold_cont_01", true)
                    end
                end
            end, nil, nil, COMMANDPERM_RUDE)

            -------------------------------------
            -- Small Cage
            -------------------------------------

            menu.action(mpcage, "Small Cage", {""}, "", function()
                TASK.CLEAR_PED_TASKS_IMMEDIATELY(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
                wait(250)
                trapcage(pid, "prop_gold_cont_01", true)
            end)

            -------------------------------------
            -- Small Invisible Cage
            -------------------------------------

            menu.action(mpcage, "Small Invisible Cage", {""}, "", function()
                TASK.CLEAR_PED_TASKS_IMMEDIATELY(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
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
                    TASK.CLEAR_PED_TASKS_IMMEDIATELY(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
                    wait(250)
                    local spawnped = "u_m_m_jesus_01"
                    local spawn1 = "prop_test_elevator"
                    local spawn2 = "prop_test_elevator"
                    elevatorPOS = players.get_position(pid)
                    local temp_ped = spawn_ped(spawnped, players.get_position(pid), true)

                    if ENTITY.IS_ENTITY_A_PED(temp_ped) then
                        ENTITY.SET_ENTITY_VISIBLE(temp_ped, false)
                        PED.SET_PED_CONFIG_FLAG(temp_ped, 62, 1)
                        ENTITY.FREEZE_ENTITY_POSITION(temp_ped, true)
                        local cage1 = spawn_obj(spawn1, players.get_position(pid))
                        local cage2 = spawn_obj(spawn2, players.get_position(pid))
                        ENTITY.SET_ENTITY_VISIBLE(temp_ped, true)
                        ENTITY.ATTACH_ENTITY_TO_ENTITY(cage1, temp_ped, 0, 0,0,0, 0,0,0, false, true, true, 0, true)
                        ENTITY.PROCESS_ENTITY_ATTACHMENTS(temp_ped)
                        ENTITY.ATTACH_ENTITY_TO_ENTITY(cage2, temp_ped, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -90.0, 0,  false, true, true, 0, true)
                        ENTITY.PROCESS_ENTITY_ATTACHMENTS(temp_ped)
                        ENTITY.SET_ENTITY_VISIBLE(temp_ped, false)
                        spawned_cages[#spawned_cages + 1] = cage1
                        spawned_cages[#spawned_cages + 1] = cage2
                    else
                        entities.delete_by_handle(temp_ped)
                    end
                    local name = players.get_name(pid)
                    if name != "**Invalid**" then
                        notify(name.." was out of the cage!")
                    end
                end
                wait(1000)
            end, nil, nil, COMMANDPERM_RUDE)

            -------------------------------------
            -- Delete all Cages
            -------------------------------------
                            
            menu.action(mpcage, "Delete all Cages", {""}, "", function()
                local entitycount = 0
                for i, object in spawned_cages do
                    ENTITY.SET_ENTITY_AS_MISSION_ENTITY(object, false, false)
                    entities.delete_by_handle(object)
                    spawned_cages[i] = nil
                    entitycount = entitycount + 1
                end
                notify("Cleared "..entitycount.." Spawned Cage Objects")
                spawned_cages = {}
            end)

        -------------------------------------
        -- Attackers
        -------------------------------------

        menu.toggle(vehattack, "Enable Godmode", {""}, "", function(toggled)
            gm_on = toggled
        end)

            -------------------------------------
            -- Tank
            -------------------------------------

            local gm_on = false
            menu.action(vehattack, "Send Tank", {""}, "", function()
                local player_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local spawn_pos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(player_ped, 30.0, -30.0, 0.0)
                local ped = spawn_ped("s_m_y_blackops_01", spawn_pos, gm_on)  -- Assign the returned ped to a variable
                local vehicle = spawn_vehicle("rhino", spawn_pos, gm_on)
                NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(NETWORK.VEH_TO_NET(vehicle), true)
                PED.SET_PED_INTO_VEHICLE(ped, vehicle, -1)
                PED.SET_PED_COMBAT_ATTRIBUTES(ped, 3, false)
                PED.SET_PED_COMBAT_ATTRIBUTES(ped, 5, true)
                PED.SET_PED_COMBAT_ATTRIBUTES(ped, 46, true)
                TASK.TASK_COMBAT_PED(ped, player_ped, 0, 16)
                TASK.TASK_VEHICLE_CHASE(ped, player_ped)
                AUDIO.STOP_PED_SPEAKING(ped, true)
                PED.SET_PED_ACCURACY(ped, 100.0)
                PED.SET_PED_SHOOT_RATE(ped, 1000)
                VEHICLE.SET_VEHICLE_DOORS_LOCKED(vehicle, 2)
                local blip = HUD.ADD_BLIP_FOR_ENTITY(vehicle)
                HUD.SET_BLIP_SPRITE(blip, 421)
                HUD.SET_BLIP_COLOUR(blip, 2)
                local ptr = entities.handle_to_pointer(vehicle)
                entities.set_can_migrate(ptr, false)
                spawned_attackers[#spawned_attackers + 1] = ped
                spawned_attackers[#spawned_attackers + 1] = vehicle
            end)

        menu.action(vehattack, "Delete all Attackers", {""}, "", function()
            local entitycount = 0
            for i, object in spawned_attackers do
                ENTITY.SET_ENTITY_AS_MISSION_ENTITY(object, false, false)
                entities.delete_by_handle(object)
                spawned_attackers[i] = nil
                entitycount = entitycount + 1
            end
            notify("Cleared "..entitycount.." Attackers")
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
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local wpn = WEAPON.GET_SELECTED_PED_WEAPON(players.user_ped())
            local dmg = SYSTEM.ROUND(WEAPON.GET_WEAPON_DAMAGE(wpn, 0))
            local delay = WEAPON.GET_WEAPON_TIME_BETWEEN_SHOTS(wpn)
            local wpnEnt = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(PLAYER.PLAYER_PED_ID(), false)
            local wpnCoords = ENTITY.GET_ENTITY_BONE_POSTION(wpnEnt, ENTITY.GET_ENTITY_BONE_INDEX_BY_NAME(wpnEnt, "gun_muzzle"))
            if ENTITY.GET_ENTITY_ALPHA(ped) < 255 then return end
            if PLAYER.IS_PLAYER_FREE_AIMING_AT_ENTITY(players.user(), ped) and not PED.IS_PED_RELOADING(players.user_ped()) then
                local t1 = PED.GET_PED_BONE_COORDS(ped, 31086, 0, -0.1, 0)
                local t2 = PED.GET_PED_BONE_COORDS(ped, 31086, 0, 0.1, 0)
                local pveh = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
                MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(t1.x, t1.y, t1.z, t2.x, t2.y, t2.z, dmg, true, wpn, players.user_ped(), false, true, 10000, pveh)
                PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, 24, 1.0)
                wait(delay * 1000)
            end
        end)

        -------------------------------------
        -- Rocket Aimbot
        -------------------------------------

        menu.toggle_loop(trolling, "Rocket Aimbot", {"rocketaimbot"}, "", function()
            if not players.exists(pid) then paimbor.value = false; util.stop_thread() end
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local user = players.user_ped()
            local pos = players.get_position(pid)
            local control = PAD.IS_CONTROL_PRESSED(0, 69) or PAD.IS_CONTROL_PRESSED(0, 70) or PAD.IS_CONTROL_PRESSED(0, 76)
            if not PED.IS_PED_DEAD_OR_DYING(ped) and control and ENTITY.HAS_ENTITY_CLEAR_LOS_TO_ENTITY(user, ped, 17) then
                VEHICLE.SET_VEHICLE_SHOOT_AT_TARGET(user, ped, pos.x, pos.y, pos.z)
            end
        end)

        -------------------------------------
        -- HOSTILE TRAFFIC
        -------------------------------------

        menu.toggle_loop(trolling, "Hostile Traffic", {""}, "Traffic will become Hostile to the Player.", function()
            if not players.exists(pid) then return end
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            for get_vehicles_in_player_range(pid, 70.0) as vehicle do
                if TASK.GET_ACTIVE_VEHICLE_MISSION_TYPE(vehicle) != 6 then
                    local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
                    if ENTITY.DOES_ENTITY_EXIST(driver) and not PED.IS_PED_A_PLAYER(driver) then
                        request_control(driver)
                        PED.SET_PED_MAX_HEALTH(driver, 300)
                        ENTITY.SET_ENTITY_HEALTH(driver, 300, 0)
                        PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(driver, true)
                        TASK.TASK_VEHICLE_MISSION_PED_TARGET(driver, vehicle, ped, 6, 100.0, 0, 0.0, 0.0, true)
                    end
                end
            end
        end)
            
        -------------------------------------
        -- Kill Player Inside Interior
        -------------------------------------

        menu.action(trolling, "Force Player Outside of Interior", {""}, "", function()
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local pos = players.get_position(pid)
            glitch_hash = RequestModel("prop_windmill_01")
            mdl = RequestModel("brickade2")
            for interior_stuff as id do
                if GET_INTERIOR_FROM_PLAYER(pid) == id then
                    notify(players.get_name(pid) .. " isn't in an interior. :/")
                return end
            end
            for i = 0, 3 do
                local obj = entities.create_object(glitch_hash, pos)
                local veh = entities.create_vehicle(mdl, pos, 0)
                ENTITY.SET_ENTITY_VISIBLE(obj, false)
                ENTITY.SET_ENTITY_VISIBLE(veh, false)
                ENTITY.SET_ENTITY_INVINCIBLE(veh, true)
                ENTITY.SET_ENTITY_COLLISION(obj, true, true)
                ENTITY.APPLY_FORCE_TO_ENTITY(veh, 1, 0.0, 10.0, 10.0, 0.0, 0.0, 0.0, 0, 1, 1, 1, 0, 1)
                wait(250)
                entities.delete(obj)
                entities.delete(veh)
                wait(250)     
            end
        end)

        -------------------------------------
        -- Bounty Loop
        -------------------------------------

        bloop = menu.toggle_loop(trolling, "Bounty Loop", {"bountyloop", "bloop"}, "Will set the Players bounty always to 9000.", function(on)
            if not players.exists(pid) then bloop.value = false; util.stop_thread() end
            local bounty = players.get_bounty(pid)
            local player = players.get_name(pid)
            local interior = players.is_in_interior(pid)
            if not (bounty and interior) then
                trigger_commands($"bounty {player} 9000")
                notify($"Bounty set on: {player}.")
                wait(10000)
            end
        end)

        -------------------------------------
        -- EXPLOSIONS
        -------------------------------------

        menu.action(customExplosion, "Explode", {""}, "", function()
            FIRE.ADD_EXPLOSION(players.get_position(pid), 1, 1.0, false, true, 0.0, false)
        end)

        menu.action(customExplosion, "Owned Explode", {""}, "", function()
            FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), players.get_position(pid), 1, 1.0, false, true, 0.0)
        end)

        -------------------------------------
        -- Spawn Orbital Cannon Explosion
        -------------------------------------

        menu.action(customExplosion, "Orbital Cannon Explode", {"nuke"}, "Spawns the explosion on the selected Player.", function()
            local becomeorb = menu.ref_by_path("Online>Become The Orbital Cannon")
            becomeorb.value = true
                wait(200)
                local player_ped = players.user_ped()
                while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED("scr_xm_orbital") do
                    STREAMING.REQUEST_NAMED_PTFX_ASSET("scr_xm_orbital")
                    wait(0)
                end
                GRAPHICS.USE_PARTICLE_FX_ASSET("scr_xm_orbital")
                GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD("scr_xm_orbital_blast", players.get_position(pid), 0, 180, 0, 1.0, true, true, true)
                for i = 1, 4 do
                    AUDIO.PLAY_SOUND_FROM_ENTITY(-1, "DLC_XM_Explosions_Orbital_Cannon", player_ped, 0, true, false)
                end
                FIRE.ADD_OWNED_EXPLOSION(player_ped, players.get_position(pid), 59, 1.0, true, false, 0.0)
                wait(5000)
            becomeorb.value = false
        end)

        local usingExplosionLoop = false
        menu.slider(customExplosion, "Loop Speed", {"expspeed"}, "", 50, 10000, 1000, 10, function(value)
            local delay = value 
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

        -------------------------------------
        -- Blame Random Player
        -------------------------------------

        menu.action(customExplosion, "Blame Random Player", {""}, "Mister//ModzZ requested it, so I made it.", function()
            local pids = players.list(false, false, true, false, false)
            local player = pids[math.random(#pids)]
            local killer = PLAYER.GET_PLAYER_PED(player)
            local victim = players.get_position(pid)
            FIRE.ADD_OWNED_EXPLOSION(killer, victim, 1, 1.0, false, true, 0.0)
            notify("Player "..players.get_name(player).." was blamed for killing "..players.get_name(pid).."!")
        end)

        -------------------------------------
        -- Disable Passive
        -------------------------------------

        menu.action(trolling, "Disable Passive Mode", {"pussive"}, "Disables passive mode for the selected player.", function()
            trigger_commands("givesh "..players.get_name(players.user()))
            wait(500)
            trigger_commands("bounty "..players.get_name(pid).." 1000")
            wait(1000)
            trigger_commands("mission"..players.get_name(pid))
            wait(3000)
            notify("Passive mode should be dissabled now.")
        end, nil, nil, COMMANDPERM_RUDE)

        -------------------------------------
        -- Ghost to User
        -------------------------------------

        menu.toggle(trolling, "Ghost Player", {"ghost", "g"}, "Makes you ghosted to that player.", function(toggled)
            NETWORK.SET_REMOTE_PLAYER_AS_GHOST(pid, toggled)
        end)

    -------------------------------------
    -------------------------------------
    -- Kicks & Crashes
    -------------------------------------
    -------------------------------------

        --[[local kick_root = menu.ref_by_rel_path(menu.player_root(pid), "Kick")
        menu.action(kick_root, "Rape", {"rape"}, "A Unblockable kick that won't tell the target or non-hosts who did it.", function()
            if savekicked then
                trigger_commands("savep"..players.get_name(pid))
                wait(500)
            end
            trigger_commands("breakup"..players.get_name(pid))
        end, nil, nil, COMMANDPERM_RUDE)]]

        -------------------------------------
        -- Block Join Kick
        -------------------------------------

        local rids = players.get_rockstar_id(pid)
        menu.action(kicks, "Block Kick", {"emp", "block"}, "Will kick and block the player from joining you ever again.", function()
            if players.get_name(pid) == players.get_name(players.user()) then
                notify(lang.get_localised(-1974706693))
            else
                hex = decimalToHex2s(rids, 32)
                if savekicked then
                    trigger_commands("savep"..players.get_name(pid))
                end
                wait(100)
                trigger_commands("historyblock"..players.get_name(pid).." on")
                if not is_developer() then
                    log("[Lena | Block Kick] Player "..players.get_name(pid).." ("..rids..") has been Kicked and Blocked.")
                else
                    log("[Lena | Block Kick] Player "..players.get_name(pid).." ("..rids.." / "..hex..") has been Kicked and Blocked.")
                end
                trigger_commands("kick"..players.get_name(pid))
            end
        end, nil, nil, COMMANDPERM_RUDE)

        menu.action(kicks, "Rape", {"rape"}, "A Unblockable kick that won't tell the target or non-hosts who did it.", function()
            if players.get_name(pid) == players.get_name(players.user()) then
                notify(lang.get_localised(-1974706693))
            else
                hex = decimalToHex2s(rids, 32)
                if savekicked then
                    trigger_commands("savep"..players.get_name(pid))
                end
                trigger_commands("kick"..players.get_name(pid))
                if not is_developer() then
                    log("[Lena | Rape] Player "..players.get_name(pid).." ("..rids..") has been Kicked.")
                else
                    log("[Lena | Rape] Player "..players.get_name(pid).." ("..rids.." / "..hex..") has been Kicked")
                end
            end
        end, nil, nil, COMMANDPERM_RUDE)

        menu.action(kicks, "Host Kick", {"hostkick", "hokick", "stealth"}, "Works on legits and free menus. ", function()
            if players.get_name(pid) == players.get_name(players.user()) then
                notify(lang.get_localised(-1974706693))
            else
                trigger_commands("kick"..players.get_name(pid))
                log("[Lena | Host Kick] Player "..players.get_name(pid).." ("..rids..") has been Kicked.")
            end
        end)

        -------------------------------------
        -- Cwashes | No Idea Why I did this
        -------------------------------------

        menu.action(crashes, "Block Join Crash", {"gtfo", "netcrash"}, "Crashes the Player and Blocks them from joining you again.", function()
            if players.get_name(pid) == players.get_name(players.user()) then
                notify(lang.get_localised(-1974706693))
            else
                hex = decimalToHex2s(rids, 32)
                if savekicked then
                    trigger_commands("savep"..players.get_name(pid))
                    wait(50)
                end
                local player = players.get_name(pid)
                trigger_commands("ngcrash"..players.get_name(pid))
                wait(500)
                trigger_commands("crash"..players.get_name(pid))
                wait(500)
                if not is_developer() then
                    log("[Lena | Block Join Crash] Player "..players.get_name(pid).." ("..rids..") has been Crashed and Blocked.")
                else
                    log("[Lena | Block Join Crash] Player "..players.get_name(pid).." ("..rids.." / "..hex..") has been Crashed and Blocked.")
                end
                trigger_commands("historyblock" ..players.get_name(pid).." on")
                wait(10000)
                if players.get_name(pid) == player then
                    log("[Lena | Crash Backup] Player "..players.get_name(pid) .." ("..rids..") has not crashed, kicking the player instead.")
                    wait(50)
                    trigger_commands("kick"..players.get_name(pid))
                end
            end
        end, nil, nil, COMMANDPERM_AGGRESSIVE)

        local nature = menu.list(crashes, "Parachute Crash", {}, "")
        menu.action(nature, "Version 1", {"V1"}, "", function()
            if players.get_name(pid) == players.get_name(players.user()) then
                notify(lang.get_localised(-1974706693))
            else
                if savekicked then
                    trigger_commands("savep"..players.get_name(pid))
                    wait(50)
                end
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
                if savekicked then
                    trigger_commands("savep"..players.get_name(pid))
                    wait(50)
                end
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
                if savekicked then
                    trigger_commands("savep"..players.get_name(pid))
                    wait(50)
                end
                BlockSyncs(pid, function()
                    local object = entities.create_object(joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
                    OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
                    wait(5000)
                    entities.delete_by_handle(object)
                end)
            end
        end)

        menu.action(crashes, "Object Crash", {"objcrash"}, "", function()
            if players.get_name(pid) == players.get_name(players.user()) then
                notify(lang.get_localised(-1974706693))
            else
                if savekicked then
                    trigger_commands("savep"..players.get_name(pid))
                    wait(50)
                end
                BlockSyncs(pid, function()
                    local object = entities.create_object(joaat("h4_prop_tree_palm_trvlr_03"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
                    OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
                    wait(5000)
                    entities.delete_by_handle(object)
                end)
            end
        end)

        menu.action(crashes, "MK2 Griefer", {"grief"}, "Should work one some menus, idk. Don't crash players.", function()
            if players.get_name(pid) == players.get_name(players.user()) then
                notify(lang.get_localised(-1974706693))
            else
                if savekicked then
                    trigger_commands("savep"..players.get_name(pid))
                    wait(50)
                end
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

        menu.action(crashes, "Invalid Heli Task", {"task2"}, "Works on most menus. <3", function()
            local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local pos = players.get_position(pid)
            BlockSyncs(pid, function()
                for i = 1, 10 do
                    if not players.exists(pid) then
                        return
                    end
                    local veh = spawn_vehicle("zentorno", pos, true)
                    local jesus = spawn_ped("mp_m_freemode_01", pos, true)
                    PED.SET_PED_INTO_VEHICLE(jesus, veh, -1)
                    wait(100)
                    TASK.TASK_VEHICLE_HELI_PROTECT(jesus, veh, ped, 10.0, 0, 10, 0, 0)     
                    wait(1000)
                    entities.delete(jesus)
                    entities.delete(veh)
                end
            end)
        end)

        menu.action(crashes, "Invalid Animation", {"squish"}, "Blocked by some popular menus.", function()
            if players.get_name(pid) == players.get_name(players.user()) then
                notify(lang.get_localised(-1974706693))
            else
                if savekicked then
                    trigger_commands("savep"..players.get_name(pid))
                    wait(50)
                end
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

        menu.action(crashes, "Bozo Crash", {""}, "", function()
            if players.get_name(pid) == players.get_name(players.user()) then
                notify(lang.get_localised(-1974706693))
            else
                if savekicked then
                    trigger_commands("savep"..players.get_name(pid))
                    wait(50)
                end
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local coords = ENTITY.GET_ENTITY_COORDS(ped, true)
                coords.x = coords['x']
                coords.y = coords['y']
                coords.z = coords['z']
                local hash = 3613262246
                local hash2 = 3613262246
                util.request_model(hash2)
                util.request_model(hash)
                local crash2 = OBJECT.CREATE_OBJECT_NO_OFFSET(hash2, coords['x'], coords['y'], coords['z'], true, false, false)
                local crash1 = OBJECT.CREATE_OBJECT_NO_OFFSET(hash, coords['x'], coords['y'], coords['z'], true, false, false)
                ENTITY.SET_ENTITY_ROTATION(crash1, 0.0, -90.0, 0.0, 1, true)
            end
        end)

        local objcrasheslist = menu.list(crashes, "Object Crashes", {""}, "")
        local crash_models = {
            {"Positive", "prop_fragtest_cnst_04"},
            {"Positive 2", "h4_prop_bush_buddleia_low_01"},
            {"Positive 3", "h4_prop_bush_ear_ab"},
            {"Positive 4", "h4_prop_bush_ear_aa"},
            {"Positive 5", "h4_prop_bush_fern_low_01"},
            {"1", "h4_prop_grass_med_01"}
        }
        for index, data in crash_models do
            local name = data[1]
            local spobject = data[2]
            menu.action(objcrasheslist, name, {"objcrash"..name}, "", function()
                BlockSyncs(pid, function()
                    local coords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
                    local object = entities.create_object(joaat(spobject), coords)
                    OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
                    wait(5000)
                    entities.delete_by_handle(object)
                end)
            end)
        end
--  end
end

local Jointimes = {}
local names = {}
local rids = {}
local hostq = {}
local allplayers = {}
local ips = {}
players.on_join(function(pid)
    names[pid] = players.get_name(pid)
    rids[pid] = players.get_rockstar_id(pid)
    hostq[pid] = players.get_host_queue_position(pid)
    allplayers[pid] = NETWORK.NETWORK_GET_NUM_CONNECTED_PLAYERS()
    ips[pid] = player_ip(pid)
    Jointimes[pid] = os.clock()

    if showJoinInfomsg then
        notify(names[pid].." has joined.\nSlot: "..pid.."\nRID/SCID: "..rids[pid].."\nIPv4: "..ips[pid])
    end
    if showJoinInfolog then
        log("[Lena | Join Reactions] "..names[pid].." (Slot: "..pid.." | Host Queue: #"..hostq[pid].." | Count: "..allplayers[pid].." | RID/SCID: "..rids[pid].." | IPv4: "..ips[pid]..") is joining.")
    end
    if showJoinInfoteam then
        chat.send_message("> "..names[pid].." (Slot: "..pid.." | Host Queue: #"..hostq[pid].." | Count: "..allplayers[pid].." | RID/SCID: "..rids[pid].." | IPv4: "..ips[pid]..") is joining.", true, true, true)
    end
    if showJoinInfoall then
        chat.send_message("> "..names[pid].." (Slot: "..pid.." | Host Queue: #"..hostq[pid].." | Count: "..allplayers[pid].." | RID/SCID: "..rids[pid].." | IPv4: "..ips[pid]..") is joining.", false, true, true)
    end
end)

players.on_leave(function(pid)
    if showleaveInfomsg then
        if names[pid] != nil then
            notify(names[pid].." left.")
        end
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

menu.action(menu.my_root(), "Check for Updates", {""}, "", function()
    auto_update_config.check_interval = 0
    if auto_updater.run_auto_update(auto_update_config) then
        notify("No updates have been found.")
    end
end)

if not is_developer() then
    log_failsafe()
end

-------------------------------------
-------------------------------------
-- On-Stop
-------------------------------------
-------------------------------------

util.create_tick_handler(function()
    local carCheck = entities.get_user_vehicle_as_handle()
    if player_cur_car != carCheck then
        player_cur_car = carCheck
    end
end)

util.on_stop(function()
    for pid, blip in orbital_blips do 
        util.remove_blip(blip)
    end
    if modifiedSpeed then modifiedSpeed:reset() end
end)

players.on_join(player)
players.dispatch_on_join()

util.keep_running()