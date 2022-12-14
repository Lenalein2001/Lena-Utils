--if the lib should generate a template.lua in your LANG_DIR for translation templates on startup, this will log all the menu options, and after the main script had loaded the lib will check your STRING_FILES for unregistered strings
local GENERATE_TEMPLATE = false

--the dir lang files are stored in
local LANG_DIR = filesystem.store_dir() .. 'JerryScript\\Language\\'

--files to search for llang.toast and llang.str_trans in when generating a template
local STRING_FILES = {
    filesystem.scripts_dir() ..'JerryScript.lua',
}

--if you have a template file and a translated file with just plaintext of your translation, this will help you merge those files into translations
local FILE_MERGE = false

--require translations
if not filesystem.is_dir(LANG_DIR) then
    filesystem.mkdirs(LANG_DIR)
end

local function getPathPart(fullPath, remove)
    local path = string.sub(fullPath, #remove + 1)
    return string.gsub(path, '.lua', '')
end
util.create_thread(function()

    --wait for all lang labels to get registered when loading the script to avoid errors when registering translations for those labels
    while LOADING_SCRIPT do
        util.yield_once()
    end

    local lang_load = util.current_time_millis()

    for _, profilePath in pairs(filesystem.list_files(LANG_DIR)) do
        if string.find(profilePath, 'template') == nil and string.find(profilePath, 'translated') == nil and string.find(profilePath, 'result') == nil then
            util.require_no_lag(getPathPart(profilePath, filesystem.scripts_dir()))
        end
    end

end)

--add lang functions
local llang = {}

function llang.trans(txt)
    if txt == nil or #txt < 1 then return '' end

    local label = lang.find(txt)
    if label == 0 then
        label = lang.register(txt)
    end
    return label
end

local function readAll(file)
    local f = assert(io.open(file, 'rb'))
    local content = f:read('*all')
    f:close()
    return content
end

if GENERATE_TEMPLATE then

    if not filesystem.exists(LANG_DIR .. 'template.lua') then
        local f = assert(io.open(LANG_DIR .. 'template.lua', 'a'))
        f:write('lang.set_translate(\'\') --insert lang code here e.x. fr en or de\n\nlocal f = lang.find\nlocal t = lang.translate\n\n')
        f:close()
    end

    function llang.trans(txt)
        if txt == nil or #txt < 1 then return '' end

        local label = lang.find(txt, 'en')
        if label == 0 then
            local f = assert(io.open(LANG_DIR .. 'template.lua', 'a'))
            local fileTxt = string.gsub(txt, '\'', '\\\'')
            fileTxt = string.gsub(fileTxt, '\n', '\\n')
            fileTxt = string.gsub(fileTxt, '\\\\', '\\')
            f:write('t(f(\''.. fileTxt ..'\'), \'\')' ..'\n')
            f:close()

            label = lang.register(txt)
        end
        return label
    end
end

if FILE_MERGE then
    local mergeTable = {}
    menu.action(menu.my_root(), 'merge template', {}, '', function()
        local res = assert(io.open(LANG_DIR .. 'result.lua', 'a'))

        local i = 1
        for line in io.lines(LANG_DIR .."template.lua") do
            mergeTable[i][1] = line
            i += 1
        end
        local j = 1
        for line in io.lines(LANG_DIR .."translated.lua") do
            mergeTable[i][2] = line
            j += 1
        end
        for i = 1, #mergeTable do
            local fileTxt = string.gsub(mergeTable[i][2], '\'', '\\\'')
            fileTxt = string.gsub(fileTxt, '\\\\', '\\')
            res:write(string.gsub(mergeTable[i][1], "''", "'"..fileTxt .."'") .. "\n")
        end

        res:close()
    end)
end

-- register strings that aren't in menu options
local registeredStrings = {}
for _, filePath in pairs(STRING_FILES) do
    local script_file = readAll(filePath)


    for text in string.gmatch(script_file, 'llang.toast%(\'.-\'%)') do
        text = string.gsub(text, 'llang.toast%(\'', '')
        text = string.gsub(text, '\'%)', '')
        text = string.gsub(text, '\\\'', '\'')
        text = string.gsub(text, '\\\n', '\n')
        if registeredStrings[text] == nil then
            registeredStrings[text] = true
            llang.trans(text)
        end
    end

    for text in string.gmatch(script_file, 'llang.str_trans%(\'.-\'%)') do
        text = string.gsub(text, 'llang.str_trans%(\'', '')
        text = string.gsub(text, '\'%)', '')
        text = string.gsub(text, '\\\'', '\'')
        text = string.gsub(text, '\\\n', '\n')
        if registeredStrings[text] == nil then
            registeredStrings[text] = true
            llang.trans(text)
        end
    end

end

function llang.str_trans(string)
    return lang.get_string(llang.trans(string), lang.get_current())
end

function llang.toast(string)
    util.toast(llang.str_trans(string))
end

function llang.list(root, name, tableCommands, description, ...)
    return menu.list(root, llang.trans(name), if tableCommands then tableCommands else {}, llang.trans(description), ...)
end

function llang.action(root, name, tableCommands, description, ...)
    return menu.action(root, llang.trans(name), tableCommands, llang.trans(description), ...)
end

function llang.toggle(root, name, tableCommands, description, ...)
    return menu.toggle(root, llang.trans(name), tableCommands, llang.trans(description), ...)
end

function llang.toggle_loop(root, name, tableCommands, description, ...)
    return menu.toggle_loop(root, llang.trans(name), tableCommands, llang.trans(description), ...)
end

function llang.slider(root, name, tableCommands, description, ...)
    return menu.slider(root, llang.trans(name), tableCommands, llang.trans(description), ...)
end

function llang.slider_float(root, name, tableCommands, description, ...)
    return menu.slider_float(root, llang.trans(name), tableCommands, llang.trans(description), ...)
end

function llang.click_slider(root, name, tableCommands, description, ...)
    return menu.click_slider(root, llang.trans(name), tableCommands, llang.trans(description), ...)
end

function llang.click_slider_float(root, name, tableCommands, description, ...)
    return menu.click_slider_float(root, llang.trans(name), tableCommands, llang.trans(description), ...)
end

function llang.list_select(root, name, tableCommands, description, ...)
    return menu.list_select(root, llang.trans(name), tableCommands, llang.trans(description), ...)
end

function llang.list_action(root, name, tableCommands, description, ...)
    return menu.list_action(root, llang.trans(name), tableCommands, llang.trans(description), ...)
end

function llang.text_input(root, name, tableCommands, description, ...)
    return menu.text_input(root, llang.trans(name), tableCommands, llang.trans(description), ...)
end

function llang.colour(root, name, tableCommands, description, ...)
    return menu.colour(root, llang.trans(name), tableCommands, llang.trans(description), ...)
end

-- menu.rainbow(int colour_command)

function llang.divider(root, name)
    return menu.divider(root, llang.trans(name))
end

function llang.hyperlink(root, name, link, description)
    return menu.hyperlink(root, llang.trans(name), link, llang.trans(description))
end

function llang.action_slider(root, name, link, description, ...)
    return menu.action_slider(root, llang.trans(name), link, llang.trans(description), ...)
end

function llang.slider_text(root, name, tableCommands, description, ...)
    return menu.slider_text(root, llang.trans(name), tableCommands, llang.trans(description), ...)
end

return llang
