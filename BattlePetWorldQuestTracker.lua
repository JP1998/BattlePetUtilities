
local app = select(2, ...);
local L = app.L;

--[[
 --
 -- General Utility stuff
 --
--]]

app.print = function(self, ...)
    print("[", L["TITLE"], "]: ", ...);
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
        return string.escape(t);
    elseif type(t) == "function" then
        return "<function>";
    elseif type(t) == "nil" then
        return "nil";
    end
end
app.createItemLink = function(quality, id, name)
    return ITEM_QUALITY_COLORS[quality].hex .. "|Hitem:" .. id .. ":::::::::::::::|h[" .. name .. "]|h|r";
end
string.escape = function(s)
    return string.gsub(string.format("%q", s), "\n", "n");
end
string.trim = function(str)
    return (string.gsub(str, "^%s*(.-)%s*$", "%1"));
end

SLASH_BattlePetWorldQuestTracker1 = "/battlepetworldquesttracker";
SLASH_BattlePetWorldQuestTracker2 = "/battlepetwqtracker";
SLASH_BattlePetWorldQuestTracker3 = "/bpwqt";
SlashCmdList["BattlePetWorldQuestTracker"] = function(cmd)
    app:print("You typed '/bpwqt' or something similar.");
    if cmd then
        cmd = string.lower(cmd);
        if cmd == "" or cmd == "main" then
            app.WorldQuestTracker:GetWindow("WorldQuestTracker"):Toggle();
        elseif cmd == "op" or cmd == "option" or cmd == "options" then
            app.Settings:Open();
        elseif cmd == "help" then
            -- TODO: Print help
        elseif cmd == "dump" then
            app:print(string.format(L["MESSAGE_GENERAL_DUMP"], app.stringify(app)));
        else
            app.print(string.format(L["ERROR_UNKNOWN_COMMAND"], cmd));
        end
    else
        app.WorldQuestTracker:GetWindow("WorldQuestTracker"):Toggle();
    end
end

app:RegisterEvent("VARIABLES_LOADED");
app.events.VARIABLES_LOADED = function()
    app.Version = GetAddOnMetadata("Battle Pet World Quest Tracker", "Version");
    app.Settings:Initialize();
end

--[[
 --
 -- Mailer Feature Stuff
 --
--]]

local MAX_NUM_MAIL_ITEMS = 12;
local MIN_CHARACTER_NAME_LENGTH = 3;

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

    if GetMoney() >= GetSendMailPrice() then
        SendMail(app.Settings:Get("MailerOptions", "Character"), L["MAILER_SUBJECT"], L["MAILER_BODY"]);

        if last then
            app:print(string.format(L["MAILER_SENT"], self.SentMailCount + 1,  self.SentMailCount + 1));
            self.SentMailCount = 0;
        else
            self.SentMailCount = self.SentMailCount + 1;
            app:print(string.format(L["MAILER_SENT"], self.SentMailCount, "?"));
        end
    else

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
        app:print(L["MAILER_ABORT"]);
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

app:RegisterEvent("MAIL_SHOW");
app:RegisterEvent("SEND_MAIL_SUCCESS");
app:RegisterEvent("SEND_MAIL_FAILED");

app.events.MAIL_SHOW = function(...)
    app:print("You opened your mail."); -- TODO: Remove or add DEBUG condition

    if app.Mailer:Enabled() then
        app.Mailer:ScanBags();
    end
end
app.events.SEND_MAIL_SUCCESS = function(...)
    app:print("You successfully sent mail."); -- TODO: Remove or add DEBUG condition

    if app.Mailer:Enabled() and app.Mailer.Continuation then
        app.Mailer:ScanBags();
    end
end
app.events.SEND_MAIL_FAILED = function(...)
    app:print("You tried to send mail, which failed."); -- TODO: Remove or add DEBUG condition

    if app.Mailer:Enabled() then
        app.Mailer:ResetScanner();
    end
end

--[[
 --
 -- World Quest Tracker Stuff
 --
--]]

app.WorldQuestTracker = {};
app.WorldQuestTracker.Windows = {};

--[[
    Most of the following code was taken (and adopted) from the AllTheThings-Addon.
    Credit goes to Dylan Fortune (IGN: Crieve-Sargeras) and his team.
]]

-- common window functions
local function SetVisible(self, show)
    if show then
        self:Show();
        self:Update();
    else
        self:Hide();
    end
end
local function ToggleWindow(self)
    --
    return SetVisible(self, not self:IsVisible());
end
local function OnCloseButtonPressed(self)
    --
    self:GetParent():Hide();
end

-- common resizable window functions
local function StopMovingOrSizing(self)
    self:StopMovingOrSizing();
    self.isMoving = nil;
end
local function StartMovingOrSizing(self, fromChild)
    if not self:IsMovable() and not self:IsResizable() or self.isLocked then
        return
    end
    if self.isMoving then
        StopMovingOrSizing(self);
    else
        self.isMoving = true;
        if ((select(2, GetCursorPosition()) / self:GetEffectiveScale()) < math.max(self:GetTop() - 40, self:GetBottom() + 10)) then
            self:StartSizing();
            Push(self, "StartMovingOrSizing (Sizing)", function()
                if self.isMoving then
                    -- keeps the rows within the window fitting to the window as it resizes
                    self:Refresh();
                    return true;
                end
            end);
        elseif self:IsMovable() then
            self:StartMoving();
        end
    end
end
-- common scrollbar functions
local function OnScrollBarMouseWheel(self, delta)
    --
    self.ScrollBar:SetValue(self.ScrollBar.CurrentValue - delta);
end
local function OnScrollBarValueChanged(self, value)
    if self.CurrentValue ~= value then
        self.CurrentValue = value;
        self:GetParent():Refresh();
    end
end

--[[
    Functions for the world quest tracker window
]]
local function RefreshWorldQuestTrackerFrame(self)
    -- TODO: Create elements for the data and fill said data into the elements
end
local function UpdateWorldQuestTrackerFrame(self)
    self.data = app.WorldQuestTracker:CreateWorldQuestData();
    self:Refresh();
end
local function CreateWorldQuestTrackerFrame(suffix, parent)
    local window = CreateFrame("Frame", app:GetName() .. "-Frame-" .. suffix, parent, BackdropTemplateMixin and "BackdropTemplate");
    self.Windows[suffix] = window;
    window.Suffix = suffix;

    window.Refresh = RefreshWorldQuestTrackerFrame;
    window.BaseUpdate = UpdateWorldQuestTrackerFrame;
    window.Toggle = ToggleWindow;
    window.SetVisible = SetVisible;

    window:SetScript("OnMouseWheel", OnScrollBarMouseWheel);
    window:SetScript("OnMouseDown", StartMovingOrSizing);
    window:SetScript("OnMouseUp", StopMovingOrSizing);
    window:SetScript("OnHide", StopMovingOrSizing);
    window:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = {
            left = 4,
            right = 4,
            top = 4,
            bottom = 4
        }
    });
    window:SetBackdropBorderColor(1, 1, 1, 1);
    window:SetBackdropColor(0, 0, 0, 1);
    window:SetClampedToScreen(true);
    window:SetToplevel(true);
    window:EnableMouse(true);
    window:SetMovable(true);
    window:SetResizable(true);
    window:SetPoint("CENTER");
    window:SetMinResize(96, 32);
    window:SetSize(300, 300);

    window:SetUserPlaced(true);
    window.data = {
        ["title"] = L["TITLE"],
        ["subtitle"] = nil,
        ["icon"] = "Interface\\Icons\\PetJournalPortrait",
        ["visible"] = true,
        ["expanded"] = true,
        ["children"] = {}
    };

    window:Hide();

    -- The Close Button. It's assigned as a local variable so you can change how it behaves.
    window.CloseButton = CreateFrame("Button", nil, window, "UIPanelCloseButton");
    window.CloseButton:SetPoint("TOPRIGHT", window, "TOPRIGHT", 4, 3);
    window.CloseButton:SetScript("OnClick", OnCloseButtonPressed);

    -- The Scroll Bar.
    local scrollbar = CreateFrame("Slider", nil, window, "UIPanelScrollBarTemplate");
    scrollbar:SetPoint("TOP", window.CloseButton, "BOTTOM", 0, -10);
    scrollbar:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", -4, 36);
    scrollbar:SetScript("OnValueChanged", OnScrollBarValueChanged);
    scrollbar.back = scrollbar:CreateTexture(nil, "BACKGROUND");
    scrollbar.back:SetColorTexture(0,0,0,0.4)
    scrollbar.back:SetAllPoints(scrollbar);
    scrollbar:SetMinMaxValues(1, 1);
    scrollbar:SetValueStep(1);
    scrollbar:SetObeyStepOnDrag(true);
    scrollbar.CurrentValue = 1;
    scrollbar:SetWidth(16);
    scrollbar:EnableMouseWheel(true);
    window:EnableMouseWheel(true);
    window.ScrollBar = scrollbar;

    -- The Corner Grip. (this isn't actually used, but it helps indicate to players that they can do something)
    local grip = window:CreateTexture(nil, "ARTWORK");
    grip:SetTexture("Interface\\AddOns\\AllTheThings\\assets\\grip"); -- TODO: Copy and rename!
    grip:SetSize(16, 16);
    grip:SetTexCoord(0,1,0,1);
    grip:SetPoint("BOTTOMRIGHT", -5, 5);
    window.Grip = grip;

    -- The Row Container. This contains all of the row frames.
    local container = CreateFrame("FRAME", nil, window);
    container:SetPoint("TOPLEFT", window, "TOPLEFT", 0, -6);
    container:SetPoint("RIGHT", scrollbar, "LEFT", 0, 0);
    container:SetPoint("BOTTOM", window, "BOTTOM", 0, 6);
    window.Container = container;
    container.rows = {};
    scrollbar:SetValue(1);
    container:Show();

    window.Update = UpdateWorldQuestTrackerFrame;
    window:Update();

    return window;
end

--[[
    General world quest tracker functions
]]
local app.WorldQuestTracker.QuestIds = {
    ["shadowlands"] = {
        61784, 61787, 61783, 61791, -- Bastion
        61866, 61867, 61868, 61870, -- Maldraxxus
        61879, 61883, 61885, 61886, -- Revendreth
        61946, 61947, 61948, 61949, -- Ardenweald
    },
    ["battleforazeroth"] = {
        56382, 56386, 56391, 56392, 56389, 56388, 56385, 56381, 56387, 56384, 56383, 56390, -- Nazjatar
        56397, 56396, 56393, 56395, 56399, 56400, 56398, 56394, -- Mechagon
        58746, 58747, 58748, 58749, -- Vale of Eternal Blossoms
        58742, 58744, 58743, 58745, -- Uldum
        52471, 52751, 52430, 52455, -- Tiragarde Sound
        52325, 52316, 52165, 52126, -- Stormsong Valley
        52297, 52278, 52218, 52009, -- Drustvar
        52923, 52938, 52937, 52892, -- Zuldazar
        52779, 52754, 52803, 52799, -- Nazmir
        52850, 52878, 52864, 52856, -- Vol'dun
    },
    ["legion"] = {
        46111, 46112, 46113, -- The Broken Shore
        42442, 40299, 41881, 40298, 41886, 42062, 40277, -- Dalaran
        42063, 42146, 42159, 42148, 42154, -- Azsuna
        40279, 41862, 41861, 41855, 41860, -- Val'sharah
        40280, 40282, 41766, 42064, 41687, 41624, -- Highmountain
        42067, 41944, 41958, 40278, 41948, 41935, -- Stormheim
        41895, 41914, 41990, 40337, 42015, 41931, -- Suramar
        49044, 49043, 49045, 49042, 49046, 49041, -- Krokuun
        49052, 49047, 49048, 49049, 49050, 49051, -- Mac'Aree
        49057, 49056, 49054, 49058, 49053, 49055, -- Antoran Wastes
    },
};

app.WorldQuestTracker.AssembleExpansionData = function(self, expansion)
    return {
        ["title"] = L["WORLDQUESTTRACKER_" .. string.upper(expansion) .. "_TITLE"],
        ["subtitle"] = nil,
        ["icon"] = L["WORLDQUESTTRACKER_" .. string.upper(expansion) .. "_ICON"], -- "Interface\\Icons\\PetJournalPortrait",
        ["visible"] = true,
        ["expanded"] = true,
        ["children"] = {}
    };
end
app.WorldQuestTracker.AssembleQuestData = function(self, questName, zoneName, rewardItemIcon, rewardItemQuality, rewardItemId, rewardItemName, rewardItemAmount)
    local data = {
        ["title"] = string.format("%s (%s)", name, zoneName),
        ["visible"] = true,
        ["expanded"] = true,
        ["children"] = nil
    };

    if rewardItemId then
        data["subtitle"] = string.format("%sx%s", app.createItemLink(rewardItemQuality, rewardItemId, rewardItemName), rewardItemAmount);
        data["icon"] = rewardIcon;
    else
        data["subtitle"] = nil;
        data["icon"] = L["WORLDQUESTTRACKER_DEFAULT_ICON"];
    end

    return data;
end
app.WorldQuestTracker.CreateWorldQuestData = function(self)
    local data = {
        ["title"] = L["TITLE"],
        ["subtitle"] = nil,
        ["icon"] = L["WORLDQUESTTRACKER_ROOT_ICON"],
        ["visible"] = true,
        ["expanded"] = true,
        ["children"] = {}
    };


    for i,xpac in pairs(app.WorldQuestTracker.QuestIds) do
        local expansionData = app.WorldQuestTracker:AssembleExpansionData(xpac);
        table.insert(data.children, expansionData);

        for j,questId in pairs(app.WorldQuestTracker.QuestIds[xpac]) do
            if C_TaskQuest.IsActive(questId) then
                local zoneName = C_Map.GetMapInfo(C_TaskQuest.GetQuestZoneID(quest).name);
                local name, _ = C_TaskQuest.GetQuestInfoByQuestID(questId);

                local rewardName, rewardIcon, rewardAmount, rewardQuality, _, rewardItemId, _
                    = GetQuestLogRewardInfo(1, questId);

                if app.WorldQuestTracker.ShowReward(rewardItemId) then
                    local questData = app.WorldQuestTracker:AssembleQuestData(
                        name, zoneName, rewardIcon, rewardQuality, rewardItemId, rewardName, rewardAmount);
                    table.insert(expansionData.children, questData);
                end
            end
        end
    end

    return data;
end
app.WorldQuestTracker.ShowReward = function(self, itemId)
    local conf = app.Settings:Get("WorldQuestTrackerOptions");

    if itemId == nil then
        return conf.ShowNoItem;
    elseif conf.Items[itemId] == nil then
        app.WorldQuestTracker.UnknownItemsPrinted = app.WorldQuestTracker.UnknownItemsPrinted or {};

        if conf.PrintUnknownItem and not app.WorldQuestTracker.UnknownItemsPrinted[key] then
            app.print(string.format(
                L["WORLDQUESTTRACKER_UNKNOWNITEM"],
                app.createItemLink(C_Item.GetItemQualityByID(itemId), itemId, C_Item.GetItemNameByID(itemId))
            ));
            app.WorldQuestTracker.UnknownItemsPrinted[key] = true;
        end

        return conf.ShowUnknownItem;
    else
        return conf.Items[itemId];
    end
end
app.WorldQuestTracker.UpdateWorldQuestDisplay = function(self)
    app.print("Updated your world quest display :)"); -- TODO: Remove or add DEBUG condition
    app.WorldQuestTracker.GetWindow("WorldQuestTracker"):Update();
end
app.WorldQuestTracker.CreateWindow = function(self, suffix, parent)
    local WindowCreator = {
        ["WorldQuestTracker"] = CreateWorldQuestTrackerFrame;
    };

    if WindowCreator[suffix] then
        return WindowCreator[suffix](suffix, parent or UIParent);
    else
        return nil;
    end
end
app.WorldQuestTracker.GetWindow = function(self, suffix, parent)
    local window = self.Windows[suffix];

    if not window then
        window = self:CreateWindow(suffix, parent);
    end

    return window;
end

app:RegisterEvent("QUEST_LOG_UPDATE");
app.events.QUEST_LOG_UPDATE = function(...)
    app:print("Quest log has updated."); -- TODO: Remove or add DEBUG condition
    app.WorldQuestTracker:UpdateWorldQuestDisplay();
end
