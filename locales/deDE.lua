
if GetLocale() ~= "deDE" then
    return;
end

local _, app = ...;
local L = app.L;

for key,value in pairs({
    -- Enter translated strings here
})
do L[key] = value; end
