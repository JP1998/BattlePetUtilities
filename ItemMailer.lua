
local app = select(2, ...);
local L = app.L;

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
app.Mailer.DepositItemToWarbank = function(self, warbanktab, bag, slot)
    local itemID = C_Container.GetContainerItemID(bag, slot);
    local _,_,_,_,_,_,_, stackSize, _,_,_,_,_,_,_,_,_ = C_Item.GetItemInfo(itemInfo)

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
    if app.Settings.Get("ItemMailer", "WarbankTab") == 0 then
        print(L["MAILER_WARBANKNOTSET"]);
        return;
    end

    local warbanktab = 12 + app.Settings.Get("ItemMailer", "WarbankTab");

    for bag = 0, NUM_BAG_SLOTS do
        for slot = startSlot, C_Container.GetContainerNumSlots(bag) do
            local itemId = C_Container.GetContainerItemID(bag, slot);

            if itemId ~= nil and self:IsItemToBeMailed(itemId) then
                local fullydeposited, possiblyMore;

                repeat
                    fullydeposited, possiblyMore = app.Mailer:DepositItemToWarbank(warbanktab, bag, slot);
                until fullydeposited or not possiblyMore;

                if not fullydeposited then
                    app.print(L["MAILER_WARBANKFULL"]);
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
        app.Mailer:ScanBagsForWarbank();
    end
end);
