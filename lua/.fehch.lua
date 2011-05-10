#!/usr/bin/env lua
-- fehch.lua - Change wallpapers with feh using a list of wallpapers
-- Copyright Stæld Lakorv, 2010-2011 <staeld@staeld.co.cc>
-- Released under the GPLv3
-- Uses .wplist for file list

-- {{{ Init
function setbg(f)
    if not io.open(f,"r") then
        print("Unable to open " .. f)
    else
        os.execute("feh --bg-fill " .. f)
    end
end
list = { file = os.getenv("HOME") .. "/.wplist" }
wp = {
    dir = os.getenv("HOME") .. "/media/bilder/wp/",
    set = false
}
function list.read()
    io.input(list.file)
    t = io.read("*a")
    io.input():close()
    local j = 0
    for n, f in string.gmatch(t, "(%S+)%s+(%S+)") do
        j = j + 1
        wp[j] = {
            name = n,
            file = wp.dir .. f
        }
    end
end
function list.names() -- Collect and concatenate wallpaper names
    local j = 0
    repeat
        j = j + 1
        if not wp.names then
            wp.names = wp[j].name
        else
            wp.names = wp.names.." "..wp[j].name
        end
   until ( j == #wp )
end
function list.write() -- Create verbose list of entries
    prev = 1
    for k = 1, #wp do
        for i, v in pairs(wp[k]) do
            if ( prev == k - 1 ) then
                prev = k
                print("\n" .. i, v)
            else
                print(i, v)
            end
        end
    end
end
function list.add(n, f)
    local lf = io.open(list.file,"a+")
    local s = string.rep(" ", 8 - string.len(n))
    lf:write(n .. s .. f .. "\n")
    lf:close()
end
list.read()
list.names() -- Must define wp.names before using it

msg = {
    noarg = "Invalid arguments, see --help for more info.",
    nopic = "File is not a valid picture.",
    help  = [[
Usage: ]]..arg[0]..[[ [NAME|--list|--help]

Names: ]] .. wp.names .. "\n" ..
[[Commands:   --list                verbose list of available names, with filenames
            --add [NAME FILEPATH] add FILEPATH to the list, as NAME
            --help                this help message]]
}
-- }}}

-- {{{ Run
cmd = arg[1]
if not cmd then
    print(msg.noarg)
elseif ( cmd == "--help" ) then
    print(msg.help)
elseif ( cmd == "--list" ) then
    list.write()
elseif ( cmd == "--add" ) then
    if ( not arg[2] or not arg[3] ) or arg[4] then
        print(msg.noarg)
    elseif not ( string.match(arg[3], "%.jpg$") or string.match(arg[3], "%.png") ) then
        print(msg.nopic)
    else
        list.add(arg[2], arg[3])
    end
else
    i = 0
    repeat
        i = i + 1
        if ( cmd == wp[i].name ) then
            setbg(wp[i].file)
            wp.set = true
        end
    until ( i == #wp or wp.set == true )
    if ( wp.set == false ) then
        print("Invalid name.")
    end
end
-- }}}
-- EOF
