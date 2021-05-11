
local app = select(2, ...);
local L = app.L;

local settings = CreateFrame("FRAME", app:GetName() .. "-Settings", UIParent, BackdropTemplateMixin and "BackdropTemplate");
app.Settings = settings;
settings.name = app:GetName();
settings.MostRecentTab = nil;
settings.Tabs = {};
settings.ModifierKeys = { "None", "Shift", "Ctrl", "Alt" };
settings:SetBackdrop({
    bgFile = "Interface/RAIDFRAME/UI-RaidFrame-GroupBg",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = false, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
});
settings:SetBackdropColor(0, 0, 0, 1);
InterfaceOptions_AddCategory(settings);
settings.Open = function(self)
    -- Open the Options menu.
    if InterfaceOptionsFrame:IsVisible() then
        InterfaceOptionsFrame_Show();
    else
        InterfaceOptionsFrame_OpenToCategory(self.name);
        InterfaceOptionsFrame_OpenToCategory(self.name);
    end
end

local SettingsBase = {
    ["MailerOptions"] = {
        ["Enabled"] = false,
        ["Character"] = {},
        ["Items"] = {
            [86143]  = true, -- Battle Pet Bandage
            [163036] = true, -- Polished Pet Charms
            [116415] = true, -- Shiny Pet Charms
            [122457] = true, -- Ultimate Battle-Training Stone
            [98715]  = true, -- Marked Flawless Battle-Stone
            [127755] = true, -- Fel-Touched Battle-Training Stone
            [116429] = true, -- Flawless Battle-Training Stone
            [116374] = true, -- Beast Battle-Training Stone
            [92675]  = true, -- Flawless Beast Battle-Stone
            [116416] = true, -- Humanoid Battle-Training Stone
            [92682]  = true, -- Flawless Humanoid Battle-Stone
            [116417] = true, -- Mechanical Battle-Training Stone
            [92680]  = true, -- Flawless Mechanical Battle-Stone
            [116418] = true, -- Critter Battle-Training Stone
            [92676]  = true, -- Flawless Critter Battle-Stone
            [116419] = true, -- Dragonkin Battle-Training Stone
            [92683]  = true, -- Flawless Dragonkin Battle-Stone
            [116420] = true, -- Elemental Battle-Training Stone
            [92665]  = true, -- Flawless Elemental Battle-Stone
            [116421] = true, -- Flying Battle-Training Stone
            [92677]  = true, -- Flawless Flying Battle-Stone
            [116422] = true, -- Magic Battle-Training Stone
            [92678]  = true, -- Flawless Magic Battle-Stone
            [116423] = true, -- Undead Battle-Training Stone
            [92681]  = true, -- Flawless Undead Battle-Stone
            [116424] = true, -- Aquatic Battle-Training Stone
            [92679]  = true  -- Flawless Aquatic Battle-Stone
        }
    },
    ["WorldQuestTrackerOptions"] = {
        ["ShowNoItem"] = false,
        ["ShowUnknownItem"] = true,
        ["PrintUnknownItem"] = true,
        ["Items"] = {
            [86143]  = true, -- Battle Pet Bandage
            [163036] = true, -- Polished Pet Charms
            [116415] = true, -- Shiny Pet Charms
            [122457] = true, -- Ultimate Battle-Training Stone
            [98715]  = true, -- Marked Flawless Battle-Stone
            [127755] = true, -- Fel-Touched Battle-Training Stone
            [116429] = true, -- Flawless Battle-Training Stone
            [116374] = true, -- Beast Battle-Training Stone
            [92675]  = true, -- Flawless Beast Battle-Stone
            [116416] = true, -- Humanoid Battle-Training Stone
            [92682]  = true, -- Flawless Humanoid Battle-Stone
            [116417] = true, -- Mechanical Battle-Training Stone
            [92680]  = true, -- Flawless Mechanical Battle-Stone
            [116418] = true, -- Critter Battle-Training Stone
            [92676]  = true, -- Flawless Critter Battle-Stone
            [116419] = true, -- Dragonkin Battle-Training Stone
            [92683]  = true, -- Flawless Dragonkin Battle-Stone
            [116420] = true, -- Elemental Battle-Training Stone
            [92665]  = true, -- Flawless Elemental Battle-Stone
            [116421] = true, -- Flying Battle-Training Stone
            [92677]  = true, -- Flawless Flying Battle-Stone
            [116422] = true, -- Magic Battle-Training Stone
            [92678]  = true, -- Flawless Magic Battle-Stone
            [116423] = true, -- Undead Battle-Training Stone
            [92681]  = true, -- Flawless Undead Battle-Stone
            [116424] = true, -- Aquatic Battle-Training Stone
            [92679]  = true  -- Flawless Aquatic Battle-Stone
        }
    }
};
local function DeepCopy(t)
    if type(t) == "table" then
        local copy = {};

        for k,v in ipairs(t) do
            copy[k] = DeepCopy(v);
        end

        return copy;
    else
        return t;
    end
end
local OnClickForTab = function(self)
    local id = self:GetID();
    local parent = self:GetParent();
    PanelTemplates_SetTab(parent, id);
    -- print("CLICKED TAB", id, self:GetText());
    for i,tab in ipairs(parent.Tabs) do
        if i == id then
            for j,o in ipairs(tab.objects) do
                o:Show();
            end
        else
            for j,o in ipairs(tab.objects) do
                o:Hide();
            end
        end
    end
end;
settings.Initialize = function(self)
    PanelTemplates_SetNumTabs(self, #self.Tabs);

    if not BattlePetWorldQuestSettings then
        BattlePetWorldQuestSettings = DeepCopy(SettingsBase);
    end

    OnClickForTab(self.Tabs[1]);
    self:Refresh();
end
settings.Get = function(self, category, option)
    if category == "MailerOptions" and option == "Character" then
        local _, realm = UnitName("player");
        realm = realm or GetRealmName();

        if BattlePetWorldQuestSettings then
            local character = BattlePetWorldQuestSettings[category][option][realm] or "";

            BattlePetWorldQuestSettings[category][option][realm] = character;

            return character;
        else
            return nil;
        end
    else
        return BattlePetWorldQuestSettings and BattlePetWorldQuestSettings[category][option];
    end
end
settings.GetMailerItem = function(self, itemId)
    return BattlePetWorldQuestSettings and BattlePetWorldQuestSettings["MailerOptions"]["Items"][itemId];
end
settings.GetWorldQuestTrackerItem = function(self, itemId)
    return BattlePetWorldQuestSettings and BattlePetWorldQuestSettings["WorldQuestTrackerOptions"]["Items"][itemId];
end
settings.Set = function(self, category, option, value)
    if category == "MailerOptions" and option == "Character" then
        local _, realm = UnitName("player");
        realm = realm or GetRealmName();

        if BattlePetWorldQuestSettings then
            BattlePetWorldQuestSettings[category][option][realm] = value;
        end
    else
        BattlePetWorldQuestSettings[category][option] = value;
    end

    self:Refresh();
    app:UpdateWorldQuestDisplay();
end
settings.SetMailerItem = function(self, itemId, value)
    BattlePetWorldQuestSettings["MailerOptions"]["Items"][itemId] = value;
    self:Refresh();
end
settings.SetWorldQuestTrackerItem = function(self, itemId, value)
    BattlePetWorldQuestSettings["WorldQuestTrackerOptions"]["Items"][itemId] = value;

    self:Refresh();
    app:UpdateWorldQuestDisplay();
end
settings.Refresh = function(self)
    for i,tab in ipairs(self.Tabs) do
        if tab.OnRefresh then
            tab:OnRefresh();
        end

        for j,o in ipairs(tab.objects) do
            if o.OnRefresh then
                o:OnRefresh();
            end
        end
    end
end
settings.CreateCheckBox = function(self, text, OnRefresh, OnClick)
    local cb = CreateFrame("CheckButton", self:GetName() .. "-" .. text, self, "InterfaceOptionsCheckButtonTemplate");

    table.insert(self.MostRecentTab.objects, cb);

    cb:SetScript("OnClick", OnClick);
    cb.OnRefresh = OnRefresh;
    cb.Text:SetText(text);
    cb:SetHitRectInsets(0,0 - cb.Text:GetWidth(),0,0);

    return cb;
end
settings.CreateTab = function(self, text)
    local id = #self.Tabs + 1;
    local tab = CreateFrame("Button", self:GetName() .. "-Tab" .. id, self, "OptionsFrameTabButtonTemplate");

    if id > 1 then
        tab:SetPoint("TOPLEFT", self.Tabs[id - 1], "TOPRIGHT", 0, 0);
    end

    table.insert(self.Tabs, tab);
    self.MostRecentTab = tab;

    tab.objects = {};
    tab:SetID(id);
    tab:SetText(text);

    PanelTemplates_TabResize(tab, 0);
    tab:SetScript("OnClick", OnClickForTab);

    return tab;
end

local f = settings:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
f:SetPoint("TOPLEFT", settings, "TOPLEFT", 12, -12);
f:SetJustifyH("LEFT");
f:SetText(L["TITLE"]);
f:SetScale(1.5);
f:Show();
settings.title = f;

f = settings:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
f:SetPoint("TOPRIGHT", settings, "TOPRIGHT", -12, -12);
f:SetJustifyH("RIGHT");
f:SetText("v" .. GetAddOnMetadata("Battle Pet World Quest Tracker", "Version"));
f:Show();
settings.version = f;

--[[
    The World Quest Tracker Tab
]]
local line;
(function()
    local tab = settings:CreateTab(L["OPTIONS_WORLDQUESTTRACKER_HEADER"]);
    tab:SetPoint("TOPLEFT", settings.title, "BOTTOMLEFT", 16, -8);

    line = settings:CreateTexture(nil, "ARTWORK");
    line:SetPoint("LEFT", settings, "LEFT", 4, 0);
    line:SetPoint("RIGHT", settings, "RIGHT", -4, 0);
    line:SetPoint("TOP", settings.Tabs[1], "BOTTOM", 0, 0);
    line:SetColorTexture(1, 1, 1, 0.4);
    line:SetHeight(2);

    local HeaderLabel = settings:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    HeaderLabel:SetPoint("TOPLEFT", line, "BOTTOMLEFT", 8, -8);
    HeaderLabel:SetJustifyH("LEFT");
    HeaderLabel:Show();
    HeaderLabel:SetText(L["OPTIONS_WORLDQUESTTRACKER_HEADER"]);
    table.insert(settings.MostRecentTab.objects, HeaderLabel);

    local ShowNoItemCheckBox = settings:CreateCheckBox(L["OPTIONS_WORLDQUESTTRACKER_SHOW_NO_ITEM"],
    function(self) -- OnRefresh
        self:SetChecked(settings:Get("WorldQuestTrackerOptions", "ShowNoItem"));
    end,
    function(self) -- OnClick
        settings:Set("WorldQuestTrackerOptions", "ShowNoItem", self:GetChecked());
    end);
    ShowNoItemCheckBox:SetPoint("TOPLEFT", HeaderLabel, "BOTTOMLEFT", 0, -1);

    local ShowUnknownItemCheckBox = settings:CreateCheckBox(L["OPTIONS_WORLDQUESTTRACKER_SHOW_UNKNOWN_ITEM"],
    function(self) -- OnRefresh
        self:SetChecked(settings:Get("WorldQuestTrackerOptions", "ShowUnknownItem"));
    end,
    function(self) -- OnClick
        settings:Set("WorldQuestTrackerOptions", "ShowUnknownItem", self:GetChecked());
    end);
    ShowUnknownItemCheckBox:SetPoint("TOPLEFT", ShowNoItemCheckBox, "BOTTOMLEFT", 0, 4);

    local PrintUnknownItemCheckBox = settings:CreateCheckBox(L["OPTIONS_WORLDQUESTTRACKER_PRINT_UNKNOWN_ITEM"],
    function(self) -- OnRefresh
        self:SetChecked(settings:Get("WorldQuestTrackerOptions", "PrintUnknownItem"));
    end,
    function(self) -- OnClick
        settings:Set("WorldQuestTrackerOptions", "PrintUnknownItem", self:GetChecked());
    end);
    PrintUnknownItemCheckBox:SetPoint("TOPLEFT", ShowUnknownItemCheckBox, "BOTTOMLEFT", 0, 4);

    local ItemLabel = settings:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    ItemLabel:SetPoint("TOPLEFT", PrintUnknownItem, "BOTTOMLEFT", 0, -6);
    ItemLabel:SetJustifyH("LEFT");
    ItemLabel:SetText(L["OPTIONS_WORLDQUESTTRACKER_ITEMS_HEADER"]);
    ItemLabel:Show();
    table.insert(settings.MostRecentTab.objects, ItemLabel);

    (function(relativeTo, labelOffset, checkBoxOffset, horizontalOffset, data)
        local y = 0;
        local nextY = 0;

        for group=1,#data do
            local label = settings:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall");
            label:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", 0, y + labelOffset);
            label:SetJustifyH("LEFT");
            label:SetText(data[group]["Title"]);
            label:Show();
            table.insert(settings.MostRecentTab.objects, label);

            y = y + label:GetHeight() + labelOffset;

            for item=1,#data[group]["Items"] do
                local checkbox = settings:CreateCheckBox(
                    data[group]["Items"][item]["Name"],
                    function(self) -- OnRefresh
                        self:SetChecked(settings:GetWorldQuestTrackerItem(data[group]["Item"][item]["ItemId"]));
                    end,
                    function(self) -- OnClick
                        settings:SetWorldQuestTrackerItem(data[group]["Item"][item]["ItemId"], self:GetChecked());
                    end);

                if item % 2 == 1 then
                    checkbox:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", 0, y + checkBoxOffset);
                    nextY = y + checkbox:GetHeight() + checkBoxOffset;
                else
                    checkbox:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", horizontalOffset, y + checkBoxOffset);
                    y = nextY;
                end
            end

            y = nextY;
        end
    end)(ItemLabel, -6, 4, 220, {
        {   -- General Items
            ["Title"] = L["OPTIONS_ITEM_GENERAL_HEADER"],
            ["Items"] = {
                {
                    ["Name"] = L["OPTIONS_ITEM_BATTLE_PET_BANDAGE"],
                    ["ItemId"] = 86143
                } -- [1]
            }
        }, -- [1]
        {   -- Pet Charms
            ["Title"] = L["OPTIONS_ITEM_PETCHARMS_HEADER"],
            ["Items"] = {
                {
                    ["Name"] = L["OPTIONS_ITEM_POLISHED_PET_CHARM"],
                    ["ItemId"] = 163036
                }, -- [1]
                {
                    ["Name"] = L["OPTIONS_ITEM_SHINY_PET_CHARM"],
                    ["ItemId"] = 116415
                } -- [2]
            }
        }, -- [2]
        {   -- General Battle-Stones
            ["Title"] = L["OPTIONS_ITEM_GENERAL_BATTLESTONES_HEADER"],
            ["Items"] = {
                {
                    ["Name"] = L["OPTIONS_ITEM_ULTIMATE_BATTLE_TRAINING_STONE"],
                    ["ItemId"] = 163036
                }, -- [1]
                {
                    ["Name"] = L["OPTIONS_ITEM_MARKED_FLAWLESS_BATTLE_STONE"],
                    ["ItemId"] = 163036
                }, -- [2]
                {
                    ["Name"] = L["OPTIONS_ITEM_FELTOUCHED_BATTLE_TRAINING_STONE"],
                    ["ItemId"] = 163036
                }, -- [3]
                {
                    ["Name"] = L["OPTIONS_ITEM_FLAWLESS_BATTLE_TRAINING_STONE"],
                    ["ItemId"] = 116415
                } -- [4]
            }
        }, -- [3]
        {   -- Family Battle-Stones
            ["Title"] = L["OPTIONS_ITEM_FAMILY_BATTLESTONES_HEADER"],
            ["Items"] = {
                {
                    ["Name"] = L["OPTIONS_ITEM_BTS_BEAST"],
                    ["ItemId"] = 163036
                }, -- [1]
                {
                    ["Name"] = L["OPTIONS_ITEM_FBS_BEAST"],
                    ["ItemId"] = 163036
                }, -- [2]
                {
                    ["Name"] = L["OPTIONS_ITEM_BTS_BEAST"],
                    ["ItemId"] = 163036
                }, -- [3]
                {
                    ["Name"] = L["OPTIONS_ITEM_FBS_BEAST"],
                    ["ItemId"] = 163036
                }, -- [4]
                {
                    ["Name"] = L["OPTIONS_ITEM_BTS_BEAST"],
                    ["ItemId"] = 163036
                }, -- [5]
                {
                    ["Name"] = L["OPTIONS_ITEM_FBS_BEAST"],
                    ["ItemId"] = 163036
                }, -- [6]
                {
                    ["Name"] = L["OPTIONS_ITEM_BTS_BEAST"],
                    ["ItemId"] = 163036
                }, -- [7]
                {
                    ["Name"] = L["OPTIONS_ITEM_FBS_BEAST"],
                    ["ItemId"] = 163036
                }, -- [8]
                {
                    ["Name"] = L["OPTIONS_ITEM_BTS_BEAST"],
                    ["ItemId"] = 163036
                }, -- [9]
                {
                    ["Name"] = L["OPTIONS_ITEM_FBS_BEAST"],
                    ["ItemId"] = 163036
                }, -- [10]
                {
                    ["Name"] = L["OPTIONS_ITEM_BTS_BEAST"],
                    ["ItemId"] = 163036
                }, -- [11]
                {
                    ["Name"] = L["OPTIONS_ITEM_FBS_BEAST"],
                    ["ItemId"] = 163036
                }, -- [12]
                {
                    ["Name"] = L["OPTIONS_ITEM_BTS_BEAST"],
                    ["ItemId"] = 163036
                }, -- [13]
                {
                    ["Name"] = L["OPTIONS_ITEM_FBS_BEAST"],
                    ["ItemId"] = 163036
                }, -- [14]
                {
                    ["Name"] = L["OPTIONS_ITEM_BTS_BEAST"],
                    ["ItemId"] = 163036
                }, -- [15]
                {
                    ["Name"] = L["OPTIONS_ITEM_FBS_BEAST"],
                    ["ItemId"] = 163036
                }, -- [16]
                {
                    ["Name"] = L["OPTIONS_ITEM_BTS_BEAST"],
                    ["ItemId"] = 163036
                }, -- [17]
                {
                    ["Name"] = L["OPTIONS_ITEM_FBS_BEAST"],
                    ["ItemId"] = 163036
                }, -- [18]
                {
                    ["Name"] = L["OPTIONS_ITEM_FELTOUCHED_BATTLE_TRAINING_STONE"],
                    ["ItemId"] = 163036
                }, -- [19]
                {
                    ["Name"] = L["OPTIONS_ITEM_FLAWLESS_BATTLE_TRAINING_STONE"],
                    ["ItemId"] = 116415
                } -- [20]
            }
        } -- [4]
    });
end)();
