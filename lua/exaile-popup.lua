#!/usr/bin/env lua
local e = os.execute
local function r(p)
    local proc = io.popen(p)
    local result = {}
    for i, stat in ipairs({ "title", "album", "length" }) do
        result[stat] = proc:read("*l")
    end
    return result
end
function q()
    local tab = r("exaile --get-title --get-album --get-length")
    tab.artist = io.popen("exaile --get-artist"):read()
    if not tab.title then
        notify("Spiller ikke", nil, mode)
        os.exit()
    end
    return tab
end
local function notify(h, b, mode)
    if not b then b = " " end
    if mode == "verbose" then i = "-i exaile" else i = "" end
    e('notify-send -t 10000 -u normal ' .. i .. ' -c audio,music,multimedia "' .. h .. '" "' .. b .. '"')
end

-- Run
vals = q()
for i, j in pairs(vals) do print(i,j) end
if arg[1] and ( arg[1]:match("^-q") or arg[1]:match("quiet") or arg[1]:match("sil") or arg[1]:match("^-s") ) then mode = "quiet"
else
    mode = "verbose"
end
if mode == "quiet" then
    notify(vals.title, "av " .. vals.artist .. "\nfra " .. vals.album, mode)
else
    vals.l = {}
    if vals.length ~= "n/a" then
        vals.l.mins = math.floor(vals.length / 60)
        vals.l.secs = math.floor(vals.length) - ( vals.l.mins * 60 )
    else
        vals.l.mins, val.l.secs = "xx", "xx"
    end
    vals.cur = io.popen("exaile --current-position"):read()
    if ( not vals.cur ) or ( vals.cur:lower() == "none" ) or ( vals.cur == "" ) then
        vals.cur = "n/a"
    end
    notify("Spiller nå",
        "«" .. vals.title .. "» av " .. vals.artist .. "\n" ..
        "fra " .. vals.album .. "\n" ..
        vals.cur .. " / " .. vals.l.mins .. ":" .. vals.l.secs, mode)
end
