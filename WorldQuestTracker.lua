
local _,app = ...;

--[[
 --
 -- World Quest Tracker Stuff
 --
 -- Much of the following code was taken (and adopted) from the AllTheThings-Addon.
 -- Credit goes to Dylan Fortune (IGN: Crieve-Sargeras) and his team.
 --
--]]

app.WorldQuestTracker = {};

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
local function CreateRow(window)
    local row = CreateFrame("Button", nil, window.Container);
    row.index = #window.Container.Rows;
    if row.index == 0 then
        -- This means relative to the parent.
        row:SetPoint("TOPLEFT");
        row:SetPoint("TOPRIGHT");
    else
        -- This means relative to the row above this one.
        row:SetPoint("TOPLEFT", window.Container.Rows[row.index], "BOTTOMLEFT");
        row:SetPoint("TOPRIGHT", window.Container.Rows[row.index], "BOTTOMRIGHT");
    end
    table.insert(window.Container.Rows, row);

    row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD");
    -- TODO: Implement collapse/expand of groups.
    -- row:RegisterForClicks("LeftButtonDown","RightButtonDown");
    -- row:SetScript("OnClick", RowOnClick);
    -- row:SetScript("OnEnter", RowOnEnter);
    -- row:SetScript("OnLeave", RowOnLeave);
    -- row:EnableMouse(true);

    row.Icon = row:CreateTexture(nil, "ARTWORK");
    row.Icon:SetPoint("LEFT");
    row.Icon:SetPoint("TOP");
    row.Icon.Background = row:CreateTexture(nil, "BACKGROUND");
    row.Icon.Background:SetPoint("LEFT");
    row.Icon.Background:SetPoint("TOP");
    row.Icon.Border = row:CreateTexture(nil, "BORDER");
    row.Icon.Border:SetPoint("LEFT");
    row.Icon.Border:SetPoint("TOP");

    row.TitleLabel = row:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    row.TitleLabel:SetJustifyH("LEFT");
    row.TitleLabel:SetPoint("TOP");

    local iconSize = select(2, row.TitleLabel:GetFont());
    row.Icon:SetHeight(iconSize);
    row.Icon:SetWidth(iconSize);
    row.Icon.Background:SetHeight(iconSize);
    row.Icon.Background:SetWidth(iconSize);
    row.Icon.Border:SetHeight(iconSize);
    row.Icon.Border:SetWidth(iconSize);

    row.TitleLabel:SetPoint("LEFT", row.Icon, "RIGHT", 4, 0);

    row.SubTitleLabel = row:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    row.SubTitleLabel:SetJustifyH("LEFT");
    row.SubTitleLabel:SetPoint("TOPLEFT", row.TitleLabel, "BOTTOMLEFT", -8, 6);

    row.Background = row:CreateTexture(nil, "BACKGROUND");
    row.Background:SetPoint("LEFT", 4, 0);
    row.Background:SetPoint("BOTTOM");
    row.Background:SetPoint("RIGHT");
    row.Background:SetPoint("TOP");
    row.Background:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");
end
local function PopulateRow(window, data, rowInd, indent)
    local row = window.Container.Rows[rowInd];

    row:SetPoint("LEFT", window.Container, "LEFT", indent * 8, 0);

    row.Icon:SetTexture(data.icon);
    row.TitleLabel:SetText(data.title);

    if data.subtitle then
        row:SetHeight(select(2, row.TitleLabel:GetFont()) + select(2, row.SubTitleLabel:GetFont()) + 10);
        row.SubTitleLabel:SetText(data.subtitle);
    else
        row:SetHeight(select(2, row.TitleLabel:GetFont()) + 4);
        row.SubTitleLabel:Hide();
    end
end
local function CreateOrRefreshRow(window, data, rowInd, indent)
    if #window.Container.Rows < rowInd then
        CreateRow(window);
    end

    PopulateRow(window, data, rowInd, indent);
    rowInd = rowInd + 1;

    if data.children then
        for i,dataChild in ipairs(data.children) do
            rowInd = CreateOrRefreshRow(window, dataChild, rowInd, indent + 1);
        end
    end

    return rowInd;
end
local function RefreshWorldQuestTrackerFrame(self)
    local firstNonPopulatedIndex = CreateOrRefreshRow(self, self.data, 1, 0);

    -- Hide every row after the last populated index.
    for i = firstNonPopulatedIndex,#self.Container.Rows do
        self.Container.Rows[i].Icon:Hide();
        self.Container.Rows[i].TitleLabel:Hide();
        self.Container.Rows[i].SubTitleLabel:Hide();
        self.Container.Rows[i].Background:Hide();
        self.Container.Rows[i]:Hide();
    end
end
local function UpdateWorldQuestTrackerFrame(self)
    self.data = app.WorldQuestTracker:CreateWorldQuestData();
    self:Refresh();
end
app.WorldQuestTracker.CreateWorldQuestTrackerFrame = function(suffix, parent)
    local window = CreateFrame("Frame", app:GetName() .. "-Frame-" .. suffix, parent, BackdropTemplateMixin and "BackdropTemplate");
    app:RegisterWindow(suffix, window);
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
        ["icon"] = "Interface\\Icons\\INV_Misc_SeagullPet_01",
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
    grip:SetTexture("Interface\\AddOns\\BattlePetWorldQuestTracker\\assets\\grip");
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
    container.Rows = {};
    scrollbar:SetValue(1);
    container:Show();

    window.Update = UpdateWorldQuestTrackerFrame;
    window:Update();

    return window;
end

--[[
    General world quest tracker functions
]]

app.WorldQuestTracker.AssembleExpansionData = function(self, expansion)
    return {
        ["title"] = L["WORLDQUESTTRACKER_" .. string.upper(expansion) .. "_TITLE"],
        ["subtitle"] = nil,
        ["icon"] = L["WORLDQUESTTRACKER_" .. string.upper(expansion) .. "_ICON"],
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


    for i,xpac in pairs(app.WorldQuestTracker.QuestData.WorldQuests) do
        local expansionData = app.WorldQuestTracker:AssembleExpansionData(xpac);
        table.insert(data.children, expansionData);

        for j,questId in pairs(app.WorldQuestTracker.QuestData.WorldQuests[xpac]) do
            if C_TaskQuest.IsActive(questId) then
                local zoneName = C_Map.GetMapInfo(C_TaskQuest.GetQuestZoneID(quest).name);
                local name, _ = C_TaskQuest.GetQuestInfoByQuestID(questId);

                local rewardName, rewardIcon, rewardAmount, rewardQuality, _, rewardItemId, _
                    = GetQuestLogRewardInfo(1, questId);

                if app.WorldQuestTracker:ShowReward(rewardItemId) then
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
            app:print(string.format(
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
    app:log("Updated your world quest display :)");
    app.WorldQuestTracker.GetWindow("WorldQuestTracker"):Update();
end


app:RegisterEvent("QUEST_LOG_UPDATE");
app.events.QUEST_LOG_UPDATE = function(...)
    app:log("Quest log has updated.");
    app.WorldQuestTracker:UpdateWorldQuestDisplay();
end
