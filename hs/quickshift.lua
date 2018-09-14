-- require('tools/debugging')

local quickshift_id = 'quickshift'
local get_finder_elements = [[
    tell application "Finder"
	set fileNames to {}
	set theItems to selection
	repeat with itemRef in theItems
		set end of fileNames to POSIX path of (itemRef as string)
	end repeat
    end tell
    fileNames
]]

local function get_finder()
    local result, obj, desc = hs.osascript.applescript(get_finder_elements)
    return obj
end

function reload_items()
    local items = hs.settings.get(quickshift_id)
    if items == nil then
        items = {}
    end
    items[#items + 1] = {
        text = 'Add...',
        uuid = '-add-'
    }
    return items
end

local function add_dir()
    local items = hs.settings.get(quickshift_id)
    if items == nil then
        items = {}
    end
    local dirs = get_finder()
    for k, v in ipairs(dirs) do
        if hs.fs.attributes(v)['mode'] == 'directory' then
            items[#items + 1] = {
                text = hs.fs.displayName(v),
                uuid = v
            }
        end
    end
    local message = 'Added ' .. #dirs .. ' item'
    if #dirs > 1 then
        message = message .. 's'    
    end
    hs.alert(message)
    hs.settings.set(quickshift_id, items)
end

function quickshift_move_files()
    local box = hs.chooser.new(function(dir)
        if dir == nil then
            return nil
        end
        if dir['uuid'] == '-add-' then
            add_dir()
            return nil
        end
        local finder_items = get_finder()
        if finder_items ~= nil then
            -- print(dump(finder_items))
            hs.alert('Moving ' .. #finder_items .. ' items')
            for k,v in ipairs(finder_items) do
                os.rename(v, dir['uuid'] .. '/' .. hs.fs.displayName(v))
            end
        end
    end)
    box:choices(reload_items)
    box:rightClickCallback(function(dir)
        local items = hs.settings.get(quickshift_id)
        items[dir] = nil
        hs.settings.set(quickshift_id, items)
        box:refreshChoicesCallback()
    end)
    box:bgDark(true)
    box:width(20)
    
    box:show()
end

function quickshift_watch_finder(hotkey)
    local watcher = hs.application.watcher.new(function(name, evt, app)
        if name == 'Finder' then
            -- print(dump(evt))
            if evt == hs.application.watcher.activated then
                hotkey:enable()
            elseif evt == hs.application.watcher.deactivated then
                hotkey:disable()
            end
        end
    end)
    return watcher
end




  

