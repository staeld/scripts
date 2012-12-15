#!/usr/bin/env lua
jul  = { day = 24, month = 12 }
idag = os.date("*t")
diff = {
    month  = jul.month - idag.month,
    day    = jul.day   - idag.day,
    etter  = idag.day  - jul.day
}

if idag.month == jul.month and idag.day == jul.day then
    print("Det er jul i dag!")
elseif idag.month <= jul.month then
    if idag.day > jul.day then
        dag = diff.etter
    else
        dag = diff.day
    end
    local mnd = "%d månad%s og "
    if diff.month == 0 then
        mnd = ""
    elseif diff.month == 1 then
        mnd = mnd:format(1, "")
    else
        mnd = mnd:format(diff.month, "ar")
    end
    local dag = "%d dag%s"
    if diff.day == 1 then
        dag = dag:format(1, "")
    else
        dag = dag:format(diff.day, "ar")
    end
    print("Det er " .. mnd .. dag .. " til jul.")
elseif idag.month == jul.month and ( idag.day >  jul.day ) then
    print("Det var jul for " .. diff.etter .. " dagar sia.")
else
    error("Tom for ost!")
end
-- EOF
