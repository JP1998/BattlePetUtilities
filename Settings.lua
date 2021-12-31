
local app = select(2, ...);
local L = app.L;

-- TODO: Put the window into a variable `Frame` and put the actual setting values into a new variable `Values`

app.Settings = {};
local settings = app.Settings;

local settingsFrame = CreateFrame("FRAME", app:GetName() .. "-Settings", UIParent, BackdropTemplateMixin and "BackdropTemplate");
settings.Frame = settingsFrame;

settingsFrame.name = app:GetName();
settingsFrame.MostRecentTab = nil;
settingsFrame.Tabs = {};
settingsFrame.ModifierKeys = { "None", "Shift", "Ctrl", "Alt" };
settingsFrame:SetBackdrop({
    bgFile = "Interface/RAIDFRAME/UI-RaidFrame-GroupBg",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = false,
    edgeSize = 16,
    insets = {
        left = 4,
        right = 4,
        top = 4,
        bottom = 4
    }
});
settingsFrame:SetBackdropColor(0, 0, 0, 1);
InterfaceOptions_AddCategory(settingsFrame);
settings.Open = function(self)
    -- Open the Options menu.
    if InterfaceOptionsFrame:IsVisible() then
        InterfaceOptionsFrame_Show();
    else
        InterfaceOptionsFrame_OpenToCategory(self.Frame.name);
        InterfaceOptionsFrame_OpenToCategory(self.Frame.name);
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
            [92679]  = true, -- Flawless Aquatic Battle-Stone

            [101529] = true, -- Celestial Coins
            [151191] = true, -- Old Bottle Cap
            [165835] = true, -- Pristine Gizmo
            [169665] = true, -- Cleansed Remains
            [174360] = true, -- Shadowy Gems
            [143753] = true, -- Damp Pet Supplies

            [116062] = true, -- Greater Darkmoon Pet Supplies
            [91086]  = true, -- Darkmoon Pet Supplies
            [93146]  = true, -- Pandaren Spirit Pet Supplies (Burning)
            [93147]  = true, -- Pandaren Spirit Pet Supplies (Flowing)
            [93148]  = true, -- Pandaren Spirit Pet Supplies (Whispering)
            [93149]  = true, -- Pandaren Spirit Pet Supplies (Thundering)
            [89125]  = true, -- Sack of Pet Supplies
            [118697] = true, -- Big Bag of Pet Supplies
            [122535] = true, -- Traveler's Pet Supplies
            [151638] = true, -- Leprous Sack of Pet Supplies
            [142447] = true, -- Torn Sack of Pet Supplies
            [94207]  = true, -- Fabled Pandaren Pet Supplies
            [184866] = true, -- Grummlepouch
        }
    },
    ["SquirtDayHelper"] = {
        ["Enabled"] = false
    }
};
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
    PanelTemplates_SetNumTabs(self.Frame, #self.Frame.Tabs);

    if not BattlePetWorldQuestSettings then
        BattlePetWorldQuestSettings = CopyTable(SettingsBase);
    end

    settings.Data = BattlePetWorldQuestSettings;

    OnClickForTab(self.Frame.Tabs[1]);
    self.Frame:Refresh();
end
settings.Get = function(self, category, option)
    if category == nil then
        return BattlePetWorldQuestSettings;
    elseif option == nil then
        return BattlePetWorldQuestSettings and BattlePetWorldQuestSettings[category];
    elseif category == "MailerOptions" and option == "Character" then
        local _, realm = UnitFullName("player");
        local faction, _ = UnitFactionGroup("player");

        if BattlePetWorldQuestSettings then
            if not BattlePetWorldQuestSettings[category][option][realm] then
                BattlePetWorldQuestSettings[category][option][realm] = {};
            end

            local character = BattlePetWorldQuestSettings[category][option][realm][faction] or "";

            BattlePetWorldQuestSettings[category][option][realm][faction] = character;

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
        local _, realm = UnitFullName("player");
        local faction, _ = UnitFactionGroup("player");

        if BattlePetWorldQuestSettings then
            if not BattlePetWorldQuestSettings[category][option][realm] then
                BattlePetWorldQuestSettings[category][option][realm] = {};
            end

            BattlePetWorldQuestSettings[category][option][realm][faction] = value;
        end
    else
        BattlePetWorldQuestSettings[category][option] = value;
    end

    self.Frame:Refresh();
    app.WorldQuestTracker:UpdateWorldQuestDisplay();
end
settings.SetMailerItem = function(self, itemId, value)
    BattlePetWorldQuestSettings["MailerOptions"]["Items"][itemId] = value;
    self.Frame:Refresh();
end
settings.SetWorldQuestTrackerItem = function(self, itemId, value)
    BattlePetWorldQuestSettings["WorldQuestTrackerOptions"]["Items"][itemId] = value;

    self.Frame:Refresh();
    app.WorldQuestTracker:UpdateWorldQuestDisplay();
end
settingsFrame.Refresh = function(self)
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
settingsFrame.CreateCheckBox = function(self, text, OnRefresh, OnClick)
    local cb = CreateFrame("CheckButton", self:GetName() .. "-" .. text, self, "InterfaceOptionsCheckButtonTemplate");

    table.insert(self.MostRecentTab.objects, cb);

    cb:SetScript("OnClick", OnClick);
    cb.OnRefresh = OnRefresh;
    cb.Text:SetText(text);
    cb:SetHitRectInsets(0,0 - cb.Text:GetWidth(),0,0);

    return cb;
end
settingsFrame.CreateTab = function(self, text)
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
settingsFrame.CreateItemGroupings = function(self, relativeTo, labelOffset, checkBoxOffset, horizontalOffset, data, Setter, Getter)
    local y = 0;
    local nextY = 0;

    for group=1,#data do
        local label = self:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall");
        label:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", 0, y + labelOffset);
        label:SetJustifyH("LEFT");
        label:SetText(data[group]["Title"]);
        label:Show();
        table.insert(self.MostRecentTab.objects, label);

        y = y + label:GetHeight() + labelOffset;

        for item=1,#data[group]["Items"] do
            local checkbox = self:CreateCheckBox(
                data[group]["Items"][item]["Name"],
                (function(Set, Get, itemId)
                    return function(self) -- OnRefresh
                            self:SetChecked(Get(settings, itemId));
                        end,
                        function(self) -- OnClick
                            Set(settings, itemId, self:GetChecked());
                        end
                end)(Setter, Getter, data[group]["Item"][item]["ItemId"])
            );

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
end

local ITEMS_GENERAL = {
    ["Title"] = L["OPTIONS_ITEM_GENERAL_HEADER"],
    ["Items"] = {
        {
            ["Name"] = L["OPTIONS_ITEM_BATTLE_PET_BANDAGE"],
            ["ItemId"] = 86143
        } -- [1]
    }
};
local ITEMS_PET_CHARMS = {
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
};
local ITEMS_GENERAL_BS = {
    ["Title"] = L["OPTIONS_ITEM_GENERAL_BATTLESTONES_HEADER"],
    ["Items"] = {
        {
            ["Name"] = L["OPTIONS_ITEM_ULTIMATE_BATTLE_TRAINING_STONE"],
            ["ItemId"] = 122457
        }, -- [1]
        {
            ["Name"] = L["OPTIONS_ITEM_MARKED_FLAWLESS_BATTLE_STONE"],
            ["ItemId"] = 98715
        }, -- [2]
        {
            ["Name"] = L["OPTIONS_ITEM_FELTOUCHED_BATTLE_TRAINING_STONE"],
            ["ItemId"] = 127755
        }, -- [3]
        {
            ["Name"] = L["OPTIONS_ITEM_FLAWLESS_BATTLE_TRAINING_STONE"],
            ["ItemId"] = 116429
        } -- [4]
    }
};
local ITEMS_FAMILY_BS = {
    ["Title"] = L["OPTIONS_ITEM_FAMILY_BATTLESTONES_HEADER"],
    ["Items"] = {
        {
            ["Name"] = L["OPTIONS_ITEM_BTS_BEAST"],
            ["ItemId"] = 116374
        }, -- [1]
        {
            ["Name"] = L["OPTIONS_ITEM_FBS_BEAST"],
            ["ItemId"] = 92675
        }, -- [2]
        {
            ["Name"] = L["OPTIONS_ITEM_BTS_HUMANOID"],
            ["ItemId"] = 116416
        }, -- [3]
        {
            ["Name"] = L["OPTIONS_ITEM_FBS_HUMANOID"],
            ["ItemId"] = 92682
        }, -- [4]
        {
            ["Name"] = L["OPTIONS_ITEM_BTS_MECHANICAL"],
            ["ItemId"] = 116417
        }, -- [5]
        {
            ["Name"] = L["OPTIONS_ITEM_FBS_MECHANICAL"],
            ["ItemId"] = 92680
        }, -- [6]
        {
            ["Name"] = L["OPTIONS_ITEM_BTS_CRITTER"],
            ["ItemId"] = 116418
        }, -- [7]
        {
            ["Name"] = L["OPTIONS_ITEM_FBS_CRITTER"],
            ["ItemId"] = 92676
        }, -- [8]
        {
            ["Name"] = L["OPTIONS_ITEM_BTS_DRAGONKIN"],
            ["ItemId"] = 116419
        }, -- [9]
        {
            ["Name"] = L["OPTIONS_ITEM_FBS_DRAGONKIN"],
            ["ItemId"] = 92683
        }, -- [10]
        {
            ["Name"] = L["OPTIONS_ITEM_BTS_ELEMENTAL"],
            ["ItemId"] = 116420
        }, -- [11]
        {
            ["Name"] = L["OPTIONS_ITEM_FBS_ELEMENTAL"],
            ["ItemId"] = 92665
        }, -- [12]
        {
            ["Name"] = L["OPTIONS_ITEM_BTS_FLYING"],
            ["ItemId"] = 116421
        }, -- [13]
        {
            ["Name"] = L["OPTIONS_ITEM_FBS_FLYING"],
            ["ItemId"] = 92677
        }, -- [14]
        {
            ["Name"] = L["OPTIONS_ITEM_BTS_MAGIC"],
            ["ItemId"] = 116422
        }, -- [15]
        {
            ["Name"] = L["OPTIONS_ITEM_FBS_MAGIC"],
            ["ItemId"] = 92678
        }, -- [16]
        {
            ["Name"] = L["OPTIONS_ITEM_BTS_UNDEAD"],
            ["ItemId"] = 116423
        }, -- [17]
        {
            ["Name"] = L["OPTIONS_ITEM_FBS_UNDEAD"],
            ["ItemId"] = 92681
        }, -- [18]
        {
            ["Name"] = L["OPTIONS_ITEM_BTS_AQUATIC"],
            ["ItemId"] = 116424
        }, -- [19]
        {
            ["Name"] = L["OPTIONS_ITEM_FBS_AQUATIC"],
            ["ItemId"] = 92679
        } -- [20]
    }
};
local ITEMS_DUNGEON_REWARDS = {
    ["Title"] = L["OPTIONS_ITEM_DUNGEON_REWARDS_HEADER"],
    ["Items"] = {
        {
            ["Name"] = L["OPTIONS_ITEM_CELESTIAL_COIN"],
            ["ItemId"] = 101529
        }, -- [1]
        {
            ["Name"] = L["OPTIONS_ITEM_OLD_BOTTLE_CAP"],
            ["ItemId"] = 151191
        }, -- [2]
        {
            ["Name"] = L["OPTIONS_ITEM_PRISTINE_GIZMO"],
            ["ItemId"] = 165835
        }, -- [3]
        {
            ["Name"] = L["OPTIONS_ITEM_CLEANSED_REMAINS"],
            ["ItemId"] = 169665
        }, -- [4]
        {
            ["Name"] = L["OPTIONS_ITEM_SHADOWY_GEMS"],
            ["ItemId"] = 174360
        }, -- [5]
        {
            ["Name"] = L["OPTIONS_ITEM_DAMP_PET_SUPPLIES"],
            ["ItemId"] = 143753
        }  -- [6]
    }
};
local ITEMS_PET_SUPPLIES = {
    ["Title"] = L["OPTIONS_ITEM_PETSUPPLIES_HEADER"],
    ["Items"] = {
        {
            ["Name"] = L["OPTIONS_ITEM_GREATER_DARKMOON_PET_SUPPLIES"],
            ["ItemId"] = 116062
        }, -- [1]
        {
            ["Name"] = L["OPTIONS_ITEM_DARKMOON_PET_SUPPLIES"],
            ["ItemId"] = 163036
        }, -- [2]
        {
            ["Name"] = L["OPTIONS_ITEM_PSPS_BURNING"],
            ["ItemId"] = 163036
        }, -- [3]
        {
            ["Name"] = L["OPTIONS_ITEM_PSPS_FLOWING"],
            ["ItemId"] = 163036
        }, -- [4]
        {
            ["Name"] = L["OPTIONS_ITEM_PSPS_WHISPERING"],
            ["ItemId"] = 163036
        }, -- [5]
        {
            ["Name"] = L["OPTIONS_ITEM_PSPS_THUNDERING"],
            ["ItemId"] = 163036
        }, -- [6]
        {
            ["Name"] = L["OPTIONS_ITEM_SACK_OF_PET_SUPPLIES"],
            ["ItemId"] = 163036
        }, -- [7]
        {
            ["Name"] = L["OPTIONS_ITEM_BIG_BAG_OF_PET_SUPPLIES"],
            ["ItemId"] = 163036
        }, -- [8]
        {
            ["Name"] = L["OPTIONS_ITEM_TRAVELERS_PET_SUPPLIES"],
            ["ItemId"] = 163036
        }, -- [9]
        {
            ["Name"] = L["OPTIONS_ITEM_LEPROUS_SACK_OF_PET_SUPPLIES"],
            ["ItemId"] = 163036
        }, -- [10]
        {
            ["Name"] = L["OPTIONS_ITEM_TORN_SACK_OF_PET_SUPPLIES"],
            ["ItemId"] = 163036
        }, -- [11]
        {
            ["Name"] = L["OPTIONS_ITEM_FABLED_PANDAREN_PET_SUPPLIES"],
            ["ItemId"] = 116415
        }, -- [12]
        {
            ["Name"] = L["OPTIONS_ITEM_GRUMMLEPOUCH"],
            ["ItemId"] = 184866
        } -- [13]
    }
};

local f = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
f:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 12, -12);
f:SetJustifyH("LEFT");
f:SetText(L["TITLE"]);
f:SetScale(1.5);
f:Show();
settingsFrame.title = f;

f = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
f:SetPoint("TOPRIGHT", settingsFrame, "TOPRIGHT", -12, -12);
f:SetJustifyH("RIGHT");
f:SetText("v" .. GetAddOnMetadata(app:GetName(), "Version"));
f:Show();
settingsFrame.version = f;

--[[
    The World Quest Tracker Tab
]]
local line;
(function()
    local tab = settingsFrame:CreateTab(L["OPTIONS_WORLDQUESTTRACKER_HEADER"]);
    tab:SetPoint("TOPLEFT", settingsFrame.title, "BOTTOMLEFT", 16, -8);

    line = settingsFrame:CreateTexture(nil, "ARTWORK");
    line:SetPoint("LEFT", settingsFrame, "LEFT", 4, 0);
    line:SetPoint("RIGHT", settingsFrame, "RIGHT", -4, 0);
    line:SetPoint("TOP", settingsFrame.Tabs[1], "BOTTOM", 0, 0);
    line:SetColorTexture(1, 1, 1, 0.4);
    line:SetHeight(2);

    local HeaderLabel = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    HeaderLabel:SetPoint("TOPLEFT", line, "BOTTOMLEFT", 8, -8);
    HeaderLabel:SetJustifyH("LEFT");
    HeaderLabel:Show();
    HeaderLabel:SetText(L["OPTIONS_WORLDQUESTTRACKER_HEADER"]);
    table.insert(settingsFrame.MostRecentTab.objects, HeaderLabel);

    local ShowNoItemCheckBox = settingsFrame:CreateCheckBox(L["OPTIONS_WORLDQUESTTRACKER_SHOW_NO_ITEM"],
    function(self) -- OnRefresh
        self:SetChecked(settings:Get("WorldQuestTrackerOptions", "ShowNoItem"));
    end,
    function(self) -- OnClick
        settings:Set("WorldQuestTrackerOptions", "ShowNoItem", self:GetChecked());
    end);
    ShowNoItemCheckBox:SetPoint("TOPLEFT", HeaderLabel, "BOTTOMLEFT", 0, -1);

    local ShowUnknownItemCheckBox = settingsFrame:CreateCheckBox(L["OPTIONS_WORLDQUESTTRACKER_SHOW_UNKNOWN_ITEM"],
    function(self) -- OnRefresh
        self:SetChecked(settings:Get("WorldQuestTrackerOptions", "ShowUnknownItem"));
    end,
    function(self) -- OnClick
        settings:Set("WorldQuestTrackerOptions", "ShowUnknownItem", self:GetChecked());
    end);
    ShowUnknownItemCheckBox:SetPoint("TOPLEFT", ShowNoItemCheckBox, "BOTTOMLEFT", 0, 4);

    local PrintUnknownItemCheckBox = settingsFrame:CreateCheckBox(L["OPTIONS_WORLDQUESTTRACKER_PRINT_UNKNOWN_ITEM"],
    function(self) -- OnRefresh
        self:SetChecked(settings:Get("WorldQuestTrackerOptions", "PrintUnknownItem"));
    end,
    function(self) -- OnClick
        settings:Set("WorldQuestTrackerOptions", "PrintUnknownItem", self:GetChecked());
    end);
    PrintUnknownItemCheckBox:SetPoint("TOPLEFT", ShowUnknownItemCheckBox, "BOTTOMLEFT", 0, 4);

    local ItemLabel = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    ItemLabel:SetPoint("TOPLEFT", PrintUnknownItemCheckBox, "BOTTOMLEFT", 0, -6);
    ItemLabel:SetJustifyH("LEFT");
    ItemLabel:SetText(L["OPTIONS_WORLDQUESTTRACKER_ITEMS_HEADER"]);
    ItemLabel:Show();
    table.insert(settingsFrame.MostRecentTab.objects, ItemLabel);
    
    settingsFrame:CreateItemGroupings(ItemLabel, -6, 4, 220, {
        ITEMS_GENERAL,
        ITEMS_PET_CHARMS,
        ITEMS_GENERAL_BS,
        ITEMS_FAMILY_BS,
        ITEMS_DUNGEON_REWARDS,
        ITEMS_PET_SUPPLIES
    }, settings.SetWorldQuestTrackerItem, settings.GetWorldQuestTrackerItem);
end)();

(function()
    local tab = settingsFrame:CreateTab(L["OPTIONS_MAILER_HEADER"]);

    local HeaderLabel = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    HeaderLabel:SetPoint("TOPLEFT", line, "BOTTOMLEFT", 8, -8);
    HeaderLabel:SetJustifyH("LEFT");
    HeaderLabel:Show();
    HeaderLabel:SetText(L["OPTIONS_MAILER_HEADER"]);
    table.insert(settingsFrame.MostRecentTab.objects, HeaderLabel);

    local DescriptionLabel = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall");
    DescriptionLabel:SetPoint("TOPLEFT", HeaderLabel, "BOTTOMLEFT", 0, -8);
    DescriptionLabel:SetPoint("RIGHT", line, "BOTTOMRIGHT", -8, 0);
    DescriptionLabel:SetJustifyH("LEFT");
    DescriptionLabel:SetText(L["OPTIONS_MAILER_DESCRIPTION"]);
    DescriptionLabel:Show();
    table.insert(settingsFrame.MostRecentTab.objects, DescriptionLabel);

    local EnabledCheckBox = settingsFrame:CreateCheckBox(L["OPTIONS_MAILER_ENABLED_DESCRIPTION"],
    function(self) -- OnRefresh
        self:SetChecked(settings:Get("MailerOptions", "Enabled"));
    end,
    function(self) -- OnClick
        settings:Set("MailerOptions", "Enabled", self:GetChecked());
    end);
    EnabledCheckBox:SetPoint("TOPLEFT", DescriptionLabel, "BOTTOMLEFT", 0, -1);

    local CharacterLabel = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall");
    CharacterLabel:SetPoint("TOPLEFT", EnabledCheckBox, "BOTTOMLEFT", 0, -8);
    CharacterLabel:SetJustifyH("LEFT");
    CharacterLabel:SetText(L["OPTIONS_MAILER_CHARACTER_DESCRIPTION"]);
    CharacterLabel:Show();
    table.insert(settingsFrame.MostRecentTab.objects, CharacterLabel);

    local CharacterEditBox = settingsFrame:CreateFrame("EditBox", "Character-EditBox", settingsFrame);
    CharacterEditBox:SetPoint("TOPLEFT", CharacterLabel, "TOPRIGHT", 4, 4);
    CharacterEditBox:SetPoint("RIGHT", line, "BOTTOMRIGHT", -4, 0);
    CharacterEditBox:SetMultiLine(false);
    CharacterEditBox.OnRefresh = function(self)
        self:SetText(settings.Get("MailerOptions", "Character"));
    end;
    CharacterEditBox.SetScript("OnTextChanged", function(self)
        settings.Set("MailerOptions", "Character", self:GetText());
    end);
    CharacterEditBox:Show();
    table.insert(settingsFrame.MostRecentTab.objects, CharacterEditBox);

    local ItemLabel = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    ItemLabel:SetPoint("TOPLEFT", CharacterLabel, "BOTTOMLEFT", 0, -6);
    ItemLabel:SetJustifyH("LEFT");
    ItemLabel:SetText(L["OPTIONS_MAILER_ITEMS_HEADER"]);
    ItemLabel:Show();
    table.insert(settingsFrame.MostRecentTab.objects, ItemLabel);

    settingsFrame:CreateItemGroupings(ItemLabel, -6, 4, 220, {
        ITEMS_GENERAL,
        ITEMS_PET_CHARMS,
        ITEMS_GENERAL_BS,
        ITEMS_FAMILY_BS
    }, settings.SetMailerItem, settings.GetMailerItem);
end)();

(function()
    local tab = settingsFrame:CreateTab(L["OPTIONS_SQUIRTDAYHELPER_HEADER"]);

    local HeaderLabel = settingsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    HeaderLabel:SetPoint("TOPLEFT", line, "BOTTOMLEFT", 8, -8);
    HeaderLabel:SetJustifyH("LEFT");
    HeaderLabel:Show();
    HeaderLabel:SetText(L["OPTIONS_SQUIRTDAYHELPER_HEADER"]);
    table.insert(settingsFrame.MostRecentTab.objects, HeaderLabel);

    local EnabledCheckBox = settingsFrame:CreateCheckBox(L["OPTIONS_SQUIRTDAYHELPER_ENABLED_DESCRIPTION"],
            function(self) -- OnRefresh
                self:SetChecked(settings:Get("SquirtDayHelper", "Enabled"));
                app.SquirtDayHelper:UpdateDisplays();
            end,
            function(self) -- OnClick
                settings:Set("SquirtDayHelper", "Enabled", self:GetChecked());
            end);
    EnabledCheckBox:SetPoint("TOPLEFT", HeaderLabel, "BOTTOMLEFT", 0, -8);
end)();
