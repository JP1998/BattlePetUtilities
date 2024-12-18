
local app = select(2, ...);
local L = app.L;

--[[
 --
 -- Mailer Feature Stuff
 --
--]]

local MAX_NUM_MAIL_ITEMS = 12;
local MIN_CHARACTER_NAME_LENGTH = 3;

local STACKSIZES = {
    [86143] = 250, -- Battle Pet Bandage

    [163036] = 5000, -- Polished Pet Charm
    [116415] = 1000, -- Shiny Pet Charm

    [122457] = 20, -- Ultimate Battle-Training Stone
    [98715] = 200, -- Marked Flawless Battle-Stone
    [127755] = 200, -- Fel-Touched Battle-Training Stone
    [116429] = 200, -- Flawless Battle-Training Stone

    [116374] = 200, -- Beast Battle-Training Stone
    [92675] = 200, -- Flawless Beast Battle-Stone
    [116416] = 200, -- Humanoid Battle-Training Stone
    [92682] = 200, -- Flawless Humanoid Battle-Stone
    [116417] = 200, -- Mechanical Battle-Training Stone
    [92680] = 200, -- Flawless Mechanical Battle-Stone
    [116418] = 200, -- Critter Battle-Training Stone
    [92676] = 200, -- Flawless Critter Battle-Stone
    [116419] = 200, -- Dragonkin Battle-Training Stone
    [92683] = 200, -- Flawless Dragonkin Battle-Stone
    [116420] = 200, -- Elemental Battle-Training Stone
    [92665] = 200, -- Flawless Elemental Battle-Stone
    [116421] = 200, -- Flying Battle-Training Stone
    [92677] = 200, -- Flawless Flying Battle-Stone
    [116422] = 200, -- Magic Battle-Training Stone
    [92678] = 200, -- Flawless Magic Battle-Stone
    [116423] = 200, -- Undead Battle-Training Stone
    [92681] = 200, -- Flawless Undead Battle-Stone
    [116424] = 200, -- Aquatic Battle-Training Stone
    [92679] = 200, -- Flawless Aquatic Battle-Stone

    [101529] = 50, -- Celestial Coin
    [151191] = 50, -- Old Bottle Cap
    [165835] = 50, -- Pristine Gizmo
    [169665] = 50, -- Cleansed Remains
    [174360] = 50, -- Shadowy Gem
    [143753] = 20, -- Damp Pet Supplies

    [116062] = 1, -- Greater Darkmoon Pet Supplies
    [91086] = 1, -- Darkmoon Pet Supplies
    [93146] = 1, -- Pandaren Spirit Pet Supplies
    [93147] = 1, -- Pandaren Spirit Pet Supplies
    [93148] = 1, -- Pandaren Spirit Pet Supplies
    [93149] = 1, -- Pandaren Spirit Pet Supplies
    [89125] = 1, -- Sack of Pet Supplies
    [118697] = 20, -- Big Bag of Pet Supplies
    [122535] = 20, -- Traveler's Pet Supplies
    [151638] = 1, -- Leprous Sack of Pet Supplies
    [142447] = 1, -- Torn Sack of Pet Supplies
    [94207] = 1, -- Fabled Pandaren Pet Supplies
    [184866] = 1, -- Grummlepouch
};

app.Mailer = {}
app.Mailer.IsItemToBeMailed = function(self, itemId)
    if itemId == nil then
        return false;
    end

    local itemTable = app.Settings:Get("MailerOptions", "Items");

    return itemTable[itemId] ~= nil and itemTable[itemId];
end

local function delay(tick)
    local th = coroutine.running();
    C_Timer.After(tick, function()
        coroutine.resume(th);
    end);
    coroutine.yield();
end

app.Mailer.DepositItemToWarbank = function(self, warbanktab, bag, slot)
    local itemID = C_Container.GetContainerItemID(bag, slot);

    if itemID == nil then
        return true, false;
    end

    local stackSize = C_Item.GetItemMaxStackSizeByID(itemID);

    if stackSize == nil then
        stackSize = STACKSIZES[itemID];
    end

    for warbankslot = 0, C_Container.GetContainerNumSlots(warbanktab) do
        local ci = C_Container.GetContainerItemInfo(warbanktab, warbankslot);

        if ci ~= nil and itemID == ci.itemID and ci.stackCount < stackSize then
            C_Container.PickupContainerItem(bag, slot);
            C_Container.PickupContainerItem(warbanktab, warbankslot);

            return C_Container.GetContainerItemInfo(bag, slot) == nil, true;
        end
    end

    for warbankslot = 0, C_Container.GetContainerNumSlots(warbanktab) do
        local ci = C_Container.GetContainerItemInfo(warbanktab, warbankslot);

        if ci == nil then
            C_Container.PickupContainerItem(bag, slot);
            C_Container.PickupContainerItem(warbanktab, warbankslot);

            return true, true;
        end
    end

    return false, false;
end
app.Mailer.ScanBagsForWarbank = function(self)
    local warbanktabsetting = app.Settings:Get("MailerOptions", "WarbankTab");

    if warbanktabsetting == 0 then
        app:print(L["MAILER_WARBANKNOTSET"]);
        return;
    end

    local warbanktab = 12 + warbanktabsetting;

    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local itemId = C_Container.GetContainerItemID(bag, slot);

            if itemId ~= nil and self:IsItemToBeMailed(itemId) then
                app:log("Depositing item " .. itemId .. " (bag " .. bag .. "; slot " .. slot .. ")");

                local fullydeposited, possiblyMore;

                repeat
                    fullydeposited, possiblyMore = app.Mailer:DepositItemToWarbank(warbanktab, bag, slot);
                    delay(0.5);
                until fullydeposited or not possiblyMore;

                print(fullydeposited);
                print(possiblyMore);

                if not fullydeposited then
                    app:print(L["MAILER_WARBANKFULL"]);
                    return;
                end
            end
        end
    end
end
app.Mailer.SendMail = function(self, last)
    self.SentMailCount = self.SentMailCount or 0;

    local characters = app.Mailer:GetCharacterStrings();

    if characters < 1 then
        app:print(L["MAILER_CHARACTERNOTSET"]);
        return;
    end

    if GetMoney() >= GetSendMailPrice() then
        SendMail(characters[1], L["MAILER_SUBJECT"], L["MAILER_BODY"]);

        if last then
            app:print(string.format(L["MAILER_SENT"], self.SentMailCount + 1,  self.SentMailCount + 1));
            self.SentMailCount = 0;
        else
            self.SentMailCount = self.SentMailCount + 1;
            app:print(string.format(L["MAILER_SENT"], self.SentMailCount, "?"));
        end
    else
        app:print(L["MAILER_BROKE"]);
    end
end
app.Mailer.ScanBagsForMail = function(self)
    local startBag = 0;
    local startSlot = 1;

    if self.Continuation ~= nil then
        startBag = self.Continuation.StartBag;
        startSlot = self.Continuation.StartSlot;
    end

    local items = 0;

    for bag = startBag, NUM_BAG_SLOTS do
        for slot = startSlot, C_Container.GetContainerNumSlots(bag) do
            local itemId = C_Container.GetContainerItemID(bag, slot);

            if itemId ~= nil and self:IsItemToBeMailed(itemId) then
                items = items + 1;

                if items > MAX_NUM_MAIL_ITEMS then
                    self:SendMail(false);
                    self.Continuation = {
                        ["StartBag"] = bag,
                        ["StartSlot"] = slot
                    };
                else
                    C_Container.PickupContainerItem(bag, slot);
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
app.Mailer.GetCharacterStrings = function(self)
    local characters = { strsplit(',', app.Settings:Get("MailerOptions", "Character")) };

    for i,v in ipairs(characters) do
        characters[i] = app.stringTrim(v);
    end

    characters = app.eliminateEmptyStrings(characters);

    return characters;
end
app.Mailer.CheckPlayerIsInCharacterList = function(self)
    local characters = app.Mailer:GetCharacterStrings();

    if #characters < 1 then
        return false;
    end

    local playerName, realmName = UnitFullName("player");
    local fullPlayerName = string.format("%s-%s", playerName, realmName);

    for i,char in ipairs(characters) do
        if char == playerName or char == fullPlayerName then
            return true;
        end
    end

    return false;
end
app.Mailer.MailerEnabled = function(self)
    local settings = app.Settings:Get("MailerOptions");

    return settings.Enabled and not settings.UseWarbank and not self:CheckPlayerIsInCharacterList();
end
app.Mailer.WarbankEnabled = function(self)
    local settings = app.Settings:Get("MailerOptions");

    return settings.Enabled and settings.UseWarbank and not self:CheckPlayerIsInCharacterList();
end

app:RegisterEvent("MAIL_SHOW", "ItemMailer", function(...)
    app:log("You opened your mail.");

    if app.Mailer:MailerEnabled() then
        app.Mailer:ScanBagsForMail();
    end
end);
app:RegisterEvent("MAIL_SEND_SUCCESS", "ItemMailer", function(...)
    app:log("You successfully sent mail.");

    if app.Mailer:MailerEnabled() and app.Mailer.Continuation then
        app.Mailer:ScanBagsForMail();
    end
end);
app:RegisterEvent("MAIL_FAILED", "ItemMailer", function(...)
    app:log("You tried to send mail, which failed.");

    if app.Mailer:MailerEnabled() then
        app.Mailer:ResetScanner();
    end
end);
app:RegisterEvent("BANKFRAME_OPENED", "ItemMailer", function(...)
    app:log("You opened your bank.");

    if app.Mailer:WarbankEnabled() then
        coroutine.wrap(app.Mailer.ScanBagsForWarbank)(app.Mailer);
    end
end);
