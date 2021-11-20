
local app = select(2, ...);
local L = app.L;

app.SquirtDayHelper = {};

local sdh = app.SquirtDayHelper;

sdh.Location = {};
sdh.Location.SquirtDayHelper = false;
sdh.Location.AuraReminders = false;

sdh.Auras = {};
sdh.Auras.BattlePetEvent = false;
sdh.Auras.PetTreats = false;
sdh.Auras.PetHat = false;

sdh.Toys = {};
sdh.Toys.PetHat = false;

local auras_zones = {
    582, -- Lunarfall
    590, -- Frostwall
};
local sdr_zones = {
    84, -- Stormwind
    85, -- Orgrimmar
    86, --     - Clecft of Shadow
    87, -- Ironforge
    88, -- Thunder Bluff
    89, -- Darnassus
    90, -- Undercity
    103, -- The Exodar
    110, -- Silvermoon
    111, -- Shattrath
    125, -- Dalaran (Northrend)
    126, --     - Underbelly
    391, -- Shrine of Two Moons
    392, -- ^
    393, -- Shrine of Seven Stars
    394, -- ^
    582, -- Lunarfall
    590, -- Frostwall
    627, -- Dalaran (Broken Isles)
    626, --     - The Hall of Shadows
    628, --     - The Underbelly
    629, --     - Aegwynn's Gallery
    1161, -- Boralus
    1165, -- Dazar'alor
    1163, --     - The Great Seal
    1164, --     - Hall of Chroniclers
    1670, -- Oribos
    1671, --     - Ring of Transference
    1672, --     - The Broker's Den
    1673, --     - The Crucible
    1698, -- Seat of the Primus (Necrolord Covenant Sanctum)
    1699, -- Sinfall Reaches
    1700, -- Sinfall Depths
    1701, -- Heart of the Forest - The Trunk
    1702, -- Heart of the Forest - The Roots
    1703, -- Heart of the Forest - The Canopy
    1707, -- Elysian Hold - Archon's Rise
    1708, -- Elysian Hold - Sanctum of Binding
};

local function isOneOf(value, validValues)
    for _,v in ipairs(validValues) do
        if value == v then
            return true;
        end
    end

    return false;
end
local function createDay(toConvert)
    local daydate = date("*t", toConvert);
    
    local seconds = 1;
    local minutes = 60 * seconds;
    local hours = 60 * minutes;
    
    local daytime = toConvert - (daydate.hour * hours + daydate.min * minutes + daydate.sec * seconds);
    
    -- TODO: Instead of trimming to 0:00 ST we should trim to
    --       server reset time (whatever that is for the current region)
    --       How to do that?!
    return daytime;
end
local function createNextSquirt(knownSquirts, currentTime)
    local day = 86400;
    local today = createDay(currentTime);
    
    for i=1,5 do
        if knownSquirts[i] ~= nil then
            while knownSquirts[i] < today do
                knownSquirts[i] = knownSquirts[i] + 15 * day;
            end
        end
    end
    
    return knownSquirts;
end

local function checkLocations()
    local currentZone = C_Map.GetBestMapForUnit("player");

    sdh.Location.AuraReminders = isOneOf(currentZone, auras_zones);
    sdh.Location.SquirtDayHelper = isOneOf(currentZone, sdr_zones);
end
local function playerHasAura(auraId)
    return GetPlayerAuraBySpellID(auraId) ~= nil;
end
local function checkAuras()
    sdh.Auras.BattlePetEvent = playerHasAura(186406);
    sdh.Auras.PetTreats = playerHasAura(142204) or playerHasAura(142205);
    sdh.Auras.PetHat = playerHasAura(158486);
end
local function checkToys()
    sdh.Toys.PetHat = PlayerHasToy(92738);
end
local function createColorString(color)
    return string.format("%02X%02X%02X%02X", color[4], color[1], color[2], color[3]);
end

local function isSquirtDay()
    return sdh:ResolveConditional({
        [sdh.Conditionals.REGION_NOT_SUPPORTED] = false,
        [sdh.Conditionals.NO_SQUIRT_DAY]        = false,
        [sdh.Conditionals.SQUIRT_DAY]           = true,
        [sdh.Conditionals.SUPER_SQUIRT_DAY]     = true,
    });
end
local function isSquirtDayFight()
    return C_PetBattles.IsInBattle();
end
local function findUnleveledBattlePets()
    local result = {};

    for pet = 1,C_PetBattles.GetNumPets(2) do
        if C_PetBattles.GetLevel(2, pet) < 25 then
            table.insert(result, pet);
        end
    end

    return result;
end
local function getAmountNewlyLeveled()
    local amount = 0;

    for _,pet in ipairs(sdh.FightTracker) do
        if C_PetBattles.GetLevel(2, pet) == 25 then
            amount = amount + 1;
        end
    end

    return amount;
end
local function createReminderText()
    local region = GetCurrentRegion();
    local squirtday = date("*t", SquirtDayHelperPersistence.SquirtDays[region]);

    return string.format(L[sdh:ResolveConditional({
            [sdh.Conditionals.REGION_NOT_SUPPORTED] = "SDH_NOT_SUPPORTED",
            [sdh.Conditionals.NO_SQUIRT_DAY]        = "SDH_NEXT_SQUIRT",
            [sdh.Conditionals.SQUIRT_DAY]           = "SDH_SQUIRT_DAY",
            [sdh.Conditionals.SUPER_SQUIRT_DAY]     = "SDH_SUPER_SQUIRT_DAY",
        })],
        createColorString({ 255, 255, 255, 255 }), -- text color
        createColorString({ 255,   0,   0, 255 }) -- date color
    )
    :gsub("{month}", L["MONTH_" .. squirtday.month]) -- month (string)
    :gsub("{day}", squirtday.day) -- month day (integer)
    :gsub("{weekday}", L["WEEKDAY_" .. squirtday.wday]); -- week day (string)
end

sdh.Conditionals = {
    ["REGION_NOT_SUPPORTED"] = -1,
    ["NO_SQUIRT_DAY"] = 0,
    ["SQUIRT_DAY"] = 1,
    ["SUPER_SQUIRT_DAY"] = 2
};
sdh.ResolveConditional = function(self, conditionals)
    local region = GetCurrentRegion();
    local value;
    
    local c = self.Conditionals;
    
    if SquirtDayHelperPersistence.SquirtDays[region] ~= nil then
        local today = createDay(GetServerTime());
        
        if SquirtDayHelperPersistence.SquirtDays[region] < today then
            createNextSquirt(SquirtDayHelperPersistence.SquirtDays, GetServerTime());
        end
        
        local hour = 60 --[[ mins ]] * 60 --[[ secs ]];
        local offset = 12 * hour;
                
        if SquirtDayHelperPersistence.SquirtDays[region] - offset == today then
            if sdh.Auras.BattlePetEvent then
                value = conditionals[c.SUPER_SQUIRT_DAY];
            else
                value = conditionals[c.SQUIRT_DAY];
            end
        else
            value = conditionals[c.NO_SQUIRT_DAY];
        end
    else
        value = conditionals[c.REGION_NOT_SUPPORTED];
    end
    
    return value;
end

local function AssureShown(display)
    if not display:IsVisible() then
        display:Show();
    end
end
local function AssureHidden(display)
    if display:IsVisible() then
        display:Hide();
    end
end
local function AssureAurasHidden(group)
    AssureHidden(group.PetTreats);
    AssureHidden(group.PetHat);
end

sdh.UpdateDisplays = function(self)
    local settings = app.Settings:Get("SquirtDayHelper");

    if settings.Enabled then
        if sdh.Location.SquirtDayHelper then
            sdh.Displays.SquirtDayHelper:SetText(createReminderText());
            AssureShown(sdh.Displays.SquirtDayHelper);
        else
            AssureHidden(sdh.Displays.SquirtDayHelper);
        end

        if sdh.Location.AuraReminders and isSquirtDay() then
            if not sdh.Auras.PetTreats then
                AssureShown(sdh.Displays.PetTreats);
            else
                AssureHidden(sdh.Displays.PetTreats);
            end

            if sdh.Toys.PetHat and not sdh.Auras.PetHat then
                AssureShown(sdh.Displays.PetHat);
            else
                AssureHidden(sdh.Displays.PetHat);
            end
        else
            AssureAurasHidden(self.Displays);
        end
    else
        AssureHidden(self.Displays.SquirtDayHelper);
        AssureAurasHidden(self.Displays);
    end

    -- Store time in the actual update function, since
    -- it might be updated by an event right before it would
    -- have been updated anyways, making this more efficient
    sdh.LastUpdate = GetTime();
end

sdh.CreateDisplays = function(self)
    self.Displays = {};

    self.Displays.Frame = CreateFrame("FRAME", nil, UIParent);
    self.Displays.Frame:SetPoint("CENTER", UIParent, "TOP", 0, 120);

    self.Displays.SquirtDayHelper = self.Displays.Frame:CreateFontString(nil, "OVERLAY");
    self.Displays.SquirtDayHelper:SetPoint("CENTER", self.Displays.Frame, "CENTER", 0, 0);
    self.Displays.SquirtDayHelper:SetFont("Fonts/FRIZQT__.TTF", 24, "THICKOUTLINE");
    self.Displays.SquirtDayHelper:SetTextColor(1, 1, 1);
    self.Displays.SquirtDayHelper:SetShadowColor(0, 0, 0);

    self.Displays.PetTreats = self.Displays.Frame:CreateFontString(nil, "OVERLAY");
    self.Displays.PetTreats:SetPoint("CENTER", self.Displays.Frame, "CENTER", 0, -300);
    self.Displays.PetTreats:SetText(L["SDH_PET_TREAT"]);
    self.Displays.PetTreats:SetFont("Fonts/FRIZQT__.TTF", 18, "THICKOUTLINE");
    self.Displays.PetTreats:SetTextColor(1, 1, 1);
    self.Displays.PetTreats:SetShadowColor(0, 0, 0);

    self.Displays.PetHat = self.Displays.Frame:CreateFontString(nil, "OVERLAY");
    self.Displays.PetHat:SetPoint("CENTER", self.Displays.Frame, "CENTER", 0, -360);
    self.Displays.PetHat:SetText(L["SDH_PET_HAT"]);
    self.Displays.PetHat:SetFont("Fonts/FRIZQT__.TTF", 18, "THICKOUTLINE");
    self.Displays.PetHat:SetTextColor(1, 1, 1);
    self.Displays.PetHat:SetShadowColor(0, 0, 0);
end

sdh.Initialize = function(self)
    if not SquirtDayHelperPersistence then
        SquirtDayHelperPersistence = {
            ["SquirtDays"] = createNextSquirt({
                [1] = time({ year=2020, month=12, day=14 }), -- US
                [2] = nil, -- KR
                [3] = time({ year=2020, month=12, day=23 }), -- EU
                [4] = nil, -- TW
                [5] = nil, -- CN
            }, GetServerTime());
            ["Statistics"] = {
                ["Battles"] = 0;
                ["PetsLevelled"] = 0;
            };
        };
    end

    checkLocations();
    checkAuras();
    checkToys();

    self:CreateDisplays();

    self:UpdateDisplays();
end

app:RegisterEvent("ZONE_CHANGED");
app.events.ZONE_CHANGED = function()
    checkLocations();
    sdh:UpdateDisplays();
end
app:RegisterEvent("UNIT_AURA");
app.events.UNIT_AURA = function(targetUnit)
    if targetUnit == "player" then
        checkAuras();
        sdh:UpdateDisplays();
    end
end
app:RegisterEvent("TOYS_UPDATED");
app.events.TOYS_UPDATED = function(itemId, isNew, hasFanfare)
    checkToys();
    sdh:UpdateDisplays();
end
app:RegisterEvent("PET_BATTLE_OPENING_START");
app.events.PET_BATTLE_OPENING_START = function()
    if isSquirtDayFight() then
        sdh.FightTracker = findUnleveledBattlePets();
    end
end
app:RegisterEvent("PET_BATTLE_CLOSE");
app.event.PET_BATTLE_CLOSE = function()
    if sdh.FightTracker ~= nil then
        SquirtDayHelperPersistence.Statistics.Battles = SquirtDayHelperPersistence.Statistics.Battles + 1;
        local amount_levelled = getAmountNewlyLeveled();
        SquirtDayHelperPersistence.Statistics.PetsLevelled = SquirtDayHelperPersistence.Statistics.PetsLevelled + amount_levelled;

        sdh.FightTracker = nil;

        if amount_levelled > 0 then
            local message = L["SDH_STATISTICS"]
                    :gsub("{battles}", SquirtDayHelperPersistence.Statistics.Battles)
                    :gsub("{pets}", SquirtDayHelperPersistence.Statistics.PetsLevelled);
            app:print(message);
        end
    end
end

app:RegisterUpdate("SquirtDayHelper", function(elapsed)
    local UPDATE_THRESHOLD = 20; -- Update threshold in seconds
    local currentTime = GetTime();

    if not sdh.LastUpdate or sdh.LastUpdate >= currentTime - UPDATE_THRESHOLD then
        sdh:UpdateDisplays();
    end
end);
