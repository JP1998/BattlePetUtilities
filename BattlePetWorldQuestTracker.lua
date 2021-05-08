
local app = select(2, ...);
local L = app.L;

SLASH_BattlePetWorldQuestTracker1 = "/battlepetworldquesttracker";
SLASH_BattlePetWorldQuestTracker2 = "/battlepetwqtracker";
SLASH_BattlePetWorldQuestTracker3 = "/bpwqt";
SlashCmdList["BattlePetWorldQuestTracker"] = function(cmd)
    print("You typed '/bpwqt' or something similar.");
end

app:RegisterEvent("QUEST_LOG_UPDATE");
app:RegisterEvent("MAIL_SHOW");
app:RegisterEvent("SEND_MAIL_SUCCESS");
app:RegisterEvent("SEND_MAIL_FAILED");

app.events.QUEST_LOG_UPDATE = function(...)
    print("Quest log has updated.");
end
app.events.MAIL_SHOW = function(...)
    print("You opened your mail.");
end
app.events.SEND_MAIL_SUCCESS = function(...)
    print("You successfully sent mail.");
end
app.events.SEND_MAIL_FAILED = function(...)
    print("You tried to send mail, which failed.");
end
