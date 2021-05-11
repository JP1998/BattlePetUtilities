
local app = select(2, ...);
local L = app.L;

app.print = function(self, ...)
    print("[", L["TITLE"], "]: ", ...);
end

function app:UpdateWorldQuestDisplay()
    app.print("Updated your world quest display :)");
end

SLASH_BattlePetWorldQuestTracker1 = "/battlepetworldquesttracker";
SLASH_BattlePetWorldQuestTracker2 = "/battlepetwqtracker";
SLASH_BattlePetWorldQuestTracker3 = "/bpwqt";
SlashCmdList["BattlePetWorldQuestTracker"] = function(cmd)
    app.print("You typed '/bpwqt' or something similar.");
    if cmd then
        cmd = string.lower(cmd);
        if cmd == "" or cmd == "main" then
            -- TODO: Open the WQ tracker frame (NYI)
        elseif cmd == "op" or cmd == "option" or cmd == "options" then
            app.Settings:Open();
        elseif cmd == "help" then
            -- TODO: Print help
        else
            app.print(string.format(L["ERROR_UNKNOWN_COMMAND"], cmd));
        end
    else
        -- TODO: Open the WQ tracker frame (NYI)
    end
end

app:RegisterEvent("QUEST_LOG_UPDATE");
app:RegisterEvent("MAIL_SHOW");
app:RegisterEvent("SEND_MAIL_SUCCESS");
app:RegisterEvent("SEND_MAIL_FAILED");
app:RegisterEvent("VARIABLES_LOADED");

app.events.QUEST_LOG_UPDATE = function(...)
    app.print("Quest log has updated.");
end
app.events.MAIL_SHOW = function(...)
    app.print("You opened your mail.");
end
app.events.SEND_MAIL_SUCCESS = function(...)
    app.print("You successfully sent mail.");
end
app.events.SEND_MAIL_FAILED = function(...)
    app.print("You tried to send mail, which failed.");
end
app.events.VARIABLES_LOADED = function()
    app.Version = GetAddOnMetadata("Battle Pet World Quest Tracker", "Version");
    app.Settings:Initialize();
end
