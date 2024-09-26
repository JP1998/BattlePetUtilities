
local app = select(2, ...);
local L = app.L;

local initialized = false;

app.Settings = {};
local settings = app.Settings;

local settingsFrame = CreateFrame("FRAME", app:GetName() .. "-Settings", UIParent);
settings.Frame = settingsFrame;

settingsFrame.name = app:GetName();
settingsFrame.MostRecentTab = nil;
settingsFrame.Tabs = {};
settingsFrame.ModifierKeys = { "None", "Shift", "Ctrl", "Alt" };

local mainCategory = Settings.RegisterCanvasLayoutCategory(settingsFrame, settingsFrame.name, settingsFrame.name);
mainCategory.ID = settingsFrame.name;
Settings.RegisterAddOnCategory(mainCategory);


settings.Open = function(self)
    -- Open the Options menu.
    if not SettingsPanel:IsVisible() then
        SettingsPanel:Show();
    end

    Settings.OpenToCategory(app:GetName());
end

local SettingsBase = {
    ["Debug"] = {
        ["Enabled"] = false
    },
    ["MailerOptions"] = {
        ["Enabled"] = false,
        ["Character"] = "",
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

    self.Frame:Refresh();

    initialized = true;
end
settings.Get = function(self, category, option)
    if category == nil then
        return BattlePetWorldQuestSettings;
    elseif option == nil then
        return BattlePetWorldQuestSettings and BattlePetWorldQuestSettings[category];
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
    BattlePetWorldQuestSettings[category][option] = value;

    self.Frame:Refresh();
    -- app.WorldQuestTracker:UpdateWorldQuestDisplay(); TODO:
end
settings.SetMailerItem = function(self, itemId, value)
    BattlePetWorldQuestSettings["MailerOptions"]["Items"][itemId] = value;
    self.Frame:Refresh();
end
settings.SetWorldQuestTrackerItem = function(self, itemId, value)
    BattlePetWorldQuestSettings["WorldQuestTrackerOptions"]["Items"][itemId] = value;

    self.Frame:Refresh();
    -- app.WorldQuestTracker:UpdateWorldQuestDisplay(); TODO:
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
settingsFrame.CreateCheckBox = function(self, parent, text, OnRefresh, OnClick)
    local cb = CreateFrame("CheckButton", self:GetName() .. "-" .. text, parent, "InterfaceOptionsCheckButtonTemplate");

    self.MostRecentTab:AddObject(cb);

    cb:SetScript("OnClick", OnClick);
    cb.OnRefresh = OnRefresh;
    cb.Text:SetText(text);
    cb:SetHitRectInsets(0,0 - cb.Text:GetWidth(),0,0);
    cb:Show();

    return cb;
end
settingsFrame.CreateTab = function(self, text, scroll)
    local id = #self.Tabs + 1;

    local settingsPanel;
    local subcategoryPanel;

    if scroll then
        local scrollFrame = CreateFrame("ScrollFrame", self:GetName() .. "-Tab" .. id .. "-Scroll", self, "ScrollFrameTemplate");
        settingsPanel = CreateFrame("Frame", self:GetName() .. "-Tab" .. id);
        
        scrollFrame:SetScrollChild(settingsPanel);
        settingsPanel:SetID(id);
        settingsPanel:SetWidth(1);    -- This is automatically defined, so long as the attribute exists at all
        settingsPanel:SetHeight(1);   -- This is automatically defined, so long as the attribute exists at all

        -- Move the scrollbar to its proper position (only needed for subcategories)
        scrollFrame.ScrollBar:ClearPoint("RIGHT");
        scrollFrame.ScrollBar:SetPoint("RIGHT", -36, 0);

        scrollFrame.Content = settingsPanel;

        -- Create the nested subcategory
        subcategoryPanel = scrollFrame;
    else
        settingsPanel = CreateFrame("Frame", self:GetName() .. "-Tab" .. id);
        
        settingsPanel:SetID(id);

        subcategoryPanel = settingsPanel;
    end

    subcategoryPanel.name = text;
    subcategoryPanel.parent = app:GetName();

    local subcategory = Settings.RegisterCanvasLayoutSubcategory(mainCategory, subcategoryPanel, text)

    table.insert(self.Tabs, settingsPanel);
    self.MostRecentTab = settingsPanel;

    settingsPanel.AddObject = function(self, obj)
        if not self.objects then
            self.objects = {};
        end

        table.insert(self.objects, obj);
    end

    return subcategoryPanel;
end
settingsFrame.CreateItemGroupings = function(self, parent, relativeTo, labelOffset, checkBoxOffset, horizontalOffset, data, Setter, Getter)
    local y = 0;
    local nextY = 0;

    for group=1,#data do
        local label = parent:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall");
        label:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", 0, y - labelOffset);
        label:SetJustifyH("LEFT");
        label:SetText(data[group]["Title"]);
        label:Show();
        self.MostRecentTab:AddObject(label);

        y = y - label:GetHeight() - labelOffset;

        for item=1,#data[group]["Items"] do
            local checkbox = self:CreateCheckBox(
                parent,
                data[group]["Items"][item]["Name"],
                (function(Set, Get, itemId)
                    return function(self) -- OnRefresh
                        self:SetChecked(Get(settings, itemId));
                    end,
                    function(self) -- OnClick
                        Set(settings, itemId, self:GetChecked());
                    end
                end)(Setter, Getter, data[group]["Items"][item]["ItemId"])
            );

            if item % 2 == 1 then
                checkbox:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", 0, y + checkBoxOffset);
                nextY = y - checkbox:GetHeight() - checkBoxOffset;
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
            ["ItemId"] = 91086
        }, -- [2]
        {
            ["Name"] = L["OPTIONS_ITEM_PSPS_BURNING"],
            ["ItemId"] = 93146
        }, -- [3]
        {
            ["Name"] = L["OPTIONS_ITEM_PSPS_FLOWING"],
            ["ItemId"] = 93147
        }, -- [4]
        {
            ["Name"] = L["OPTIONS_ITEM_PSPS_WHISPERING"],
            ["ItemId"] = 93148
        }, -- [5]
        {
            ["Name"] = L["OPTIONS_ITEM_PSPS_THUNDERING"],
            ["ItemId"] = 93149
        }, -- [6]
        {
            ["Name"] = L["OPTIONS_ITEM_SACK_OF_PET_SUPPLIES"],
            ["ItemId"] = 89125
        }, -- [7]
        {
            ["Name"] = L["OPTIONS_ITEM_BIG_BAG_OF_PET_SUPPLIES"],
            ["ItemId"] = 118697
        }, -- [8]
        {
            ["Name"] = L["OPTIONS_ITEM_TRAVELERS_PET_SUPPLIES"],
            ["ItemId"] = 122535
        }, -- [9]
        {
            ["Name"] = L["OPTIONS_ITEM_LEPROUS_SACK_OF_PET_SUPPLIES"],
            ["ItemId"] = 151638
        }, -- [10]
        {
            ["Name"] = L["OPTIONS_ITEM_TORN_SACK_OF_PET_SUPPLIES"],
            ["ItemId"] = 142447
        }, -- [11]
        {
            ["Name"] = L["OPTIONS_ITEM_FABLED_PANDAREN_PET_SUPPLIES"],
            ["ItemId"] = 94207
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
f:SetText("v" .. C_AddOns.GetAddOnMetadata(app:GetName(), "Version"));
f:Show();
settingsFrame.version = f;

local line;
--[[
    World Quest Tracker tab
]]--
--[[
(function()
    local tab = settingsFrame:CreateTab(L["OPTIONS_WORLDQUESTTRACKER_HEADER"], true);

    local HeaderLabel = tab:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    HeaderLabel:SetPoint("TOPLEFT", tab, "BOTTOMLEFT", 0, -8);
    HeaderLabel:SetJustifyH("LEFT");
    HeaderLabel:SetText(L["OPTIONS_WORLDQUESTTRACKER_HEADER"]);
    settingsFrame.MostRecentTab:AddObject(HeaderLabel);
    HeaderLabel:Show();

    local ShowNoItemCheckBox = settingsFrame:CreateCheckBox(tab, L["OPTIONS_WORLDQUESTTRACKER_SHOW_NO_ITEM"],
    function(self) -- OnRefresh
        self:SetChecked(settings:Get("WorldQuestTrackerOptions", "ShowNoItem"));
    end,
    function(self) -- OnClick
        settings:Set("WorldQuestTrackerOptions", "ShowNoItem", self:GetChecked());
    end);
    ShowNoItemCheckBox:SetPoint("TOPLEFT", HeaderLabel, "BOTTOMLEFT", 0, 0);
    ShowNoItemCheckBox:Show();

    local ShowUnknownItemCheckBox = settingsFrame:CreateCheckBox(tab, L["OPTIONS_WORLDQUESTTRACKER_SHOW_UNKNOWN_ITEM"],
    function(self) -- OnRefresh
        self:SetChecked(settings:Get("WorldQuestTrackerOptions", "ShowUnknownItem"));
    end,
    function(self) -- OnClick
        settings:Set("WorldQuestTrackerOptions", "ShowUnknownItem", self:GetChecked());
    end);
    ShowUnknownItemCheckBox:SetPoint("TOPLEFT", ShowNoItemCheckBox, "BOTTOMLEFT", 0, 0);
    ShowUnknownItemCheckBox:Show();

    local PrintUnknownItemCheckBox = settingsFrame:CreateCheckBox(tab, L["OPTIONS_WORLDQUESTTRACKER_PRINT_UNKNOWN_ITEM"],
    function(self) -- OnRefresh
        self:SetChecked(settings:Get("WorldQuestTrackerOptions", "PrintUnknownItem"));
    end,
    function(self) -- OnClick
        settings:Set("WorldQuestTrackerOptions", "PrintUnknownItem", self:GetChecked());
    end);
    PrintUnknownItemCheckBox:SetPoint("TOPLEFT", ShowUnknownItemCheckBox, "BOTTOMLEFT", 0, 0);
    PrintUnknownItemCheckBox:Show();

    local ItemLabel = tab:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    ItemLabel:SetPoint("TOPLEFT", PrintUnknownItemCheckBox, "BOTTOMLEFT", 0, 0);
    ItemLabel:SetJustifyH("LEFT");
    ItemLabel:SetText(L["OPTIONS_WORLDQUESTTRACKER_ITEMS_HEADER"]);
    settingsFrame.MostRecentTab:AddObject(ItemLabel);
    ItemLabel:Show();
    
    settingsFrame:CreateItemGroupings(tab, ItemLabel, 8, 0, 360, {
        ITEMS_GENERAL,
        ITEMS_PET_CHARMS,
        ITEMS_GENERAL_BS,
        ITEMS_FAMILY_BS,
        ITEMS_DUNGEON_REWARDS,
        ITEMS_PET_SUPPLIES
    }, settings.SetWorldQuestTrackerItem, settings.GetWorldQuestTrackerItem);
end)();
--]]
--[[
    Mailer Settings tab
]]--
(function()
    local scroll = settingsFrame:CreateTab(L["OPTIONS_MAILER_HEADER"], true);
    local tab = scroll.Content;

    local HeaderLabel = tab:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    HeaderLabel:SetPoint("TOPLEFT", tab, "BOTTOMLEFT", 8, -8);
    HeaderLabel:SetJustifyH("LEFT");
    HeaderLabel:SetText(L["OPTIONS_MAILER_HEADER"]);
    -- table.insert(settingsFrame.MostRecentTab.objects, HeaderLabel);
    settingsFrame.MostRecentTab:AddObject(HeaderLabel);
    HeaderLabel:Show();

    local DescriptionLabel = tab:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall");
    DescriptionLabel:SetPoint("TOPLEFT", HeaderLabel, "BOTTOMLEFT", 8, -8);
    --DescriptionLabel:SetPoint("RIGHT", tab.parent, "TOPRIGHT", -800, 0);
    DescriptionLabel:SetPoint("RIGHT", scroll, "TOPRIGHT", -32, 0);
    DescriptionLabel:SetJustifyH("LEFT");
    DescriptionLabel:SetText(L["OPTIONS_MAILER_DESCRIPTION"]);
    -- table.insert(settingsFrame.MostRecentTab.objects, DescriptionLabel);
    settingsFrame.MostRecentTab:AddObject(DescriptionLabel);
    DescriptionLabel:Show();

    local EnabledCheckBox = settingsFrame:CreateCheckBox(tab, L["OPTIONS_MAILER_ENABLED_DESCRIPTION"],
function(self) -- OnRefresh
            self:SetChecked(settings:Get("MailerOptions", "Enabled"));
        end,
function(self) -- OnClick
            settings:Set("MailerOptions", "Enabled", self:GetChecked());
        end);
    EnabledCheckBox:SetPoint("TOPLEFT", DescriptionLabel, "BOTTOMLEFT", 0, -8);
    EnabledCheckBox:Show();

    local CharacterLabel = tab:CreateFontString(nil, "ARTWORK", "GameFontWhite");
    CharacterLabel:SetPoint("TOPLEFT", EnabledCheckBox, "BOTTOMLEFT", 0, -8);
    CharacterLabel:SetJustifyH("LEFT");
    CharacterLabel:SetText(L["OPTIONS_MAILER_CHARACTER_DESCRIPTION"]);
    -- table.insert(settingsFrame.MostRecentTab.objects, CharacterLabel);
    settingsFrame.MostRecentTab:AddObject(CharacterLabel);
    CharacterLabel:Show();

    local CharacterEditBox = CreateFrame("EditBox", "Character-EditBox", tab, "InputBoxTemplate");
    CharacterEditBox:SetFontObject("GameFontWhite");
    CharacterEditBox:SetPoint("TOPLEFT", CharacterLabel, "TOPRIGHT", 16, 4);
    CharacterEditBox:SetPoint("RIGHT", scroll, "RIGHT", -32, 0);
    CharacterEditBox:SetHeight(18);
    CharacterEditBox:SetAutoFocus(false);
    CharacterEditBox:SetMultiLine(false);
    CharacterEditBox.OnRefresh = function(self)
        local characterstring = settings:Get("MailerOptions", "Character");

        if characterstring ~= nil and type(characterstring) == "string" then
            self:SetText(characterstring);

            if not CharacterEditBox.Initialized then
                CharacterEditBox:SetCursorPosition(0);
                CharacterEditBox.Initialized = true;
            end
        end
    end;
    CharacterEditBox:SetScript("OnTextChanged", function(self)
        if initialized then
            settings:Set("MailerOptions", "Character", self:GetText());
        end
    end);
    settingsFrame.MostRecentTab:AddObject(CharacterEditBox);
    CharacterEditBox:OnRefresh();
    CharacterEditBox:Show();

    local ItemLabel = tab:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    ItemLabel:SetPoint("TOPLEFT", CharacterLabel, "BOTTOMLEFT", 0, -12);
    ItemLabel:SetJustifyH("LEFT");
    ItemLabel:SetText(L["OPTIONS_MAILER_ITEMS_HEADER"]);
    settingsFrame.MostRecentTab:AddObject(ItemLabel);
    ItemLabel:Show();

    settingsFrame:CreateItemGroupings(tab, ItemLabel, 8, 0, 360, {
        ITEMS_GENERAL,
        ITEMS_PET_CHARMS,
        ITEMS_GENERAL_BS,
        ITEMS_FAMILY_BS
    }, settings.SetMailerItem, settings.GetMailerItem);
end)();
--[[
    Squirt Day Helper tab
]]--
(function()
    local tab = settingsFrame:CreateTab(L["OPTIONS_SQUIRTDAYHELPER_HEADER"], false);

    local HeaderLabel = tab:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    HeaderLabel:SetPoint("TOPLEFT", tab, "TOPLEFT", 0, -8);
    HeaderLabel:SetJustifyH("LEFT");
    HeaderLabel:SetText(L["OPTIONS_SQUIRTDAYHELPER_HEADER"]);
    settingsFrame.MostRecentTab:AddObject(HeaderLabel);
    HeaderLabel:Show();

    local EnabledCheckBox = settingsFrame:CreateCheckBox(tab, L["OPTIONS_SQUIRTDAYHELPER_ENABLED_DESCRIPTION"],
    function(self) -- OnRefresh
        self:SetChecked(settings:Get("SquirtDayHelper", "Enabled"));
    end,
    function(self) -- OnClick
        settings:Set("SquirtDayHelper", "Enabled", self:GetChecked());
        app.SquirtDayHelper:UpdateDisplays();
    end);
    EnabledCheckBox:SetPoint("TOPLEFT", HeaderLabel, "BOTTOMLEFT", 0, 0);
    EnabledCheckBox:Show();
end)();

