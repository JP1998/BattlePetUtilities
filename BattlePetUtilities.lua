
local app = select(2, ...);
local L = app.L;

--[[
 --
 -- General Utility stuff
 --
--]]

app.print = function(self, msg, ...)
    self:_print("", msg, ...);
end
app.log = function(self, msg, ...)
    if self.Settings:Get("Debug", "Enabled") then
        self:_print("DEBUG ", msg, ...);
    end
end
app._print = function(self, prefix, msg, ...)
    local lines = strsplit("\n", type(msg) == "string" and msg or tostring(msg));

    for _,line in ipairs(lines) do
        print(string.format("%s[%s]: %s", prefix, L["TITLE"], line));
    end

    if ... and #... > 0 then
        self:_print(prefix, ...);
    end
end
app.stringify = function(t)
    if type(t) == "table" then
        local text = "{ ";
        local first = true;

        for k,v in pairs(t) do
            if not first then
                text = text .. ", ";
            end

            first = false;
            text = text .. string.format("[%s] = %s", app.stringify(k), app.stringify(v));
        end

        text = text .. " }";

        return text;
    elseif type(t) == "boolean" then
        return t and "true" or "false"
    elseif type(t) == "number" then
        return "" .. t;
    elseif type(t) == "string" then
        return app.stringEscape(t);
    elseif type(t) == "function" then
        if debug then
            local info = debug.getinfo(t, "S");

            if info.what == "Lua" then
                local where, _ = info.source:gsub("(@)(.*" .. app:GetName() .. ")(.*)", "%1%3");

                return string.format("<function%s:%s>", where, info.linedefined);
            else
                return "<C function:?>";
            end
        else
            return "<function>";
        end
    elseif type(t) == "nil" then
        return "nil";
    end
end
app.createItemLink = function(quality, id, name)
    return ITEM_QUALITY_COLORS[quality].hex .. "|Hitem:" .. id .. ":::::::::::::::|h[" .. name .. "]|h|r";
end

app.Windows = {};
app.RegisterWindow = function(self, suffix, window)
    self.Windows[suffix] = window;
end
app.CreateWindow = function(self, suffix, parent)
    local WindowCreator = {
        ["WorldQuestTracker"] = app.WorldQuestTracker.CreateWorldQuestTrackerFrame;
    };

    if WindowCreator[suffix] then
        return WindowCreator[suffix](suffix, parent or UIParent);
    else
        return nil;
    end
end
app.GetWindow = function(self, suffix, parent)
    local window = self.Windows[suffix];

    if not window then
        window = self:CreateWindow(suffix, parent);
        self.Windows[suffix] = window;
    end

    return window;
end

app.stringEscape = function(str)
    return string.gsub(string.format("%q", str), "\n", "n");
end
app.stringTrim = function(str)
    return (string.gsub(str, "^%s*(.-)%s*$", "%1"));
end

local createSlashCommand = (function()
    local function eliminateEmptyStrings(list)
        local result = {};

        for i,s in ipairs(list) do
            if s ~= "" then
                table.insert(result, s);
            end
        end

        return result;
    end
    local function parseSlashCommandArgs(cmd)
        return eliminateEmptyStrings(strsplit(" ", cmd));
    end

    return function(func, id, ...)
        local slashes = { ... };
        if #slashes == 0 then
            return; -- cant create slash command without slashes
        end

        if type(id) ~= "string" or id == "" then
            return; -- need id that is a non-empty string
        end

        for i,slash in ipairs(slashes) do
            setglobal(string.format("SLASH_%s%d", id, i), slash);
        end
        _G.SlashCmdList[id] = function(cmd, msgBox)
            func(parseSlashCommandArgs(cmd), msgBox);
        end
    end
end)();

local function bpu_slashhandler(args, msgbox)
    app:log("You typed '/bpu' or something similar.");

    if #args > 0 then
        local cmd = string.lower(args[1]);

        if cmd == "" or cmd == "main" then
            app:GetWindow("WorldQuestTracker"):Toggle();
        elseif cmd == "op" or cmd == "option" or cmd == "options" then
            app.Settings:Open();
        elseif cmd == "help" then
            if #args > 1 and string.lower(args[2]) == "advanced" then
                app:print(L["HELP_ADVANCED"]);
            else
                app:print(L["HELP"]);
            end
        elseif cmd == "dump" then
            if app.Settings:Get("Debug", "Enabled") then
                app:log(string.format(L["MESSAGE_GENERAL_DUMP"], app.stringify(app)));
            else
                app:print(L["MESSAGE_DEBUG_DISABLED"]);
            end
        elseif cmd == "debug" then
            local value = not app.Settings:Get("Debug", "Enabled");

            app.Settings:Set("Debug", "Enabled", value);
            app:print(string.format(L["MESSAGE_DEBUG_TOGGLE"], value));
        else
            app:print(string.format(L["ERROR_UNKNOWN_COMMAND"], cmd));
        end
    else
        app:GetWindow("WorldQuestTracker"):Toggle();
    end
end

createSlashCommand(bpu_slashhandler, "BattlePetUtilities", "/battlepetutilities", "/battlepetutil", "/bpu");

app:RegisterEvent("ADDON_LOADED", "BattlePetUtilities", function(addon)
    if addon ~= app:GetName() then
        return;
    end

    app.Version = GetAddOnMetadata(app:GetName(), "Version");
    app.Settings:Initialize();
    app.SquirtDayHelper:Initialize();

    app:log(L["MESSAGE_DEBUG_GREETING"]);
end);
