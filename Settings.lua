
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

        for k,v in pairs(t) do
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
end
settings.SetMailerItem = function(self, itemId, value) {
    BattlePetWorldQuestSettings["MailerOptions"]["Items"][itemId] = value;
    self:Refresh();
}
settings.SetWorldQuestTrackerItem = function(self, itemId, value) {
    BattlePetWorldQuestSettings["WorldQuestTrackerOptions"]["Items"][itemId] = value;
    self:Refresh();
}
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
