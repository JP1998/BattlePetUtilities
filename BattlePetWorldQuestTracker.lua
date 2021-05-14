
local app = select(2, ...);
local L = app.L;

app.print = function(self, ...)
    print("[", L["TITLE"], "]: ", ...);
end

string.trim = function(str)
    return (string.gsub(str, "^%s*(.-)%s*$", "%1"));
end

local MAX_NUM_MAIL_ITEMS = 12;
local MIN_CHARACTER_NAME_LENGTH = 3;

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

function app.UpdateWorldQuestDisplay(self)
    app.print("Updated your world quest display :)");
end

app.Mailer = {}
app.Mailer.IsItemToBeMailed = function(self, itemId)
    if itemId == nil then
        return false;
    end

    local itemTable = app.Settings:Get("MailerOptions", "Items");

    return itemTable[itemId] ~= nil and itemTable[itemId];
end
app.Mailer.SendMail = function(self, last)
    self.SentMailCount = self.SentMailCount or 0;

    -- TODO: Check if a character is defined
    -- TODO: Actually send the mail
    if last then
        app:print(string.format("We sent your items away. %d/%d", self.SentMailCount + 1,  self.SentMailCount + 1));
        self.SentMailCount = 0;
    else
        self.SentMailCount = self.SentMailCount + 1;
        app:print(string.format("We sent your items away. %d/?", self.SentMailCount));
    end
end
app.Mailer.ScanBags = function(self)
    local startBag = 0;
    local startSlot = 1;

    if self.Continuation ~= nil then
        startBag = self.Continuation.StartBag;
        startSlot = self.Continuation.StartSlot;
    else

    local items = 0;

    for bag = startBag, NUM_BAG_SLOTS do
        for slot = startSlot, GetContainerNumSlots(bag) do
            local itemId = GetContainerItemID(bag, slot);

            if itemId ~= nil and self:IsItemToBeMailed(itemId) then
                items = items + 1;

                if items > MAX_NUM_MAIL_ITEMS then
                    self:SendMail(false);
                    self.Continuation = {
                        ["StartBag"] = bag,
                        ["StartSlot"] = slot
                    };
                else
                    PickupContainerItem(bag, slot);
                    ClickSendMailItemButton(items);
                end
            end
        end

        startSlot = 1;
    end

    if items ~= 0 then
        self:SendMail(true);
    end

    self.Continuation = nil;
end
app.Mailer.ResetScanner = function(self)
    if self.Continuation then
        app:print("We had to abort sending your items.");
    end

    self.Continuation = nil;
    self.SentMailCount = 0;
end
app.Mailer.ChechCharacterStatus = function(self, character)
    character = string.trim(character);

    if character == nil or character == "" then
        return false;
    end

    if string.len(character) < MIN_CHARACTER_NAME_LENGTH then
        return false;
    end

    return true;
end
app.Mailer.Enabled = function(self)
    local settings = app.Settings:Get("MailerOptions");
    local character = app.Settings:Get("MailerOptions", "Character");

    return settings.Enabled and self.ChechCharacterStatus(character);
end

app:RegisterEvent("QUEST_LOG_UPDATE");
app:RegisterEvent("MAIL_SHOW");
app:RegisterEvent("SEND_MAIL_SUCCESS");
app:RegisterEvent("SEND_MAIL_FAILED");
app:RegisterEvent("VARIABLES_LOADED");

app.events.QUEST_LOG_UPDATE = function(...)
    app:print("Quest log has updated.");
end
app.events.MAIL_SHOW = function(...)
    app:print("You opened your mail.");

    if app.Mailer:Enabled() then
        app.Mailer:ScanBags();
    end
end
app.events.SEND_MAIL_SUCCESS = function(...)
    app:print("You successfully sent mail.");

    if app.Mailer:Enabled() and app.Mailer.Continuation then
        app.Mailer:ScanBags();
    end
end
app.events.SEND_MAIL_FAILED = function(...)
    app:print("You tried to send mail, which failed.");

    if app.Mailer:Enabled() then
        app.Mailer:ResetScanner();
    end
end
app.events.VARIABLES_LOADED = function()
    app.Version = GetAddOnMetadata("Battle Pet World Quest Tracker", "Version");
    app.Settings:Initialize();
end
