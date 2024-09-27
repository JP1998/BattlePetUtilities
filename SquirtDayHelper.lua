
local app = select(2, ...);
local L = app.L;

app.SquirtDayHelper = {};

local sdh = app.SquirtDayHelper;


sdh.Initialized = false;
sdh.Location = {};
sdh.Location.SquirtDayHelper = false;
sdh.Location.AuraReminders = false;

sdh.Auras = {};
sdh.Auras.BattlePetEvent = false;
sdh.Auras.LesserPetTreat = false;
sdh.Auras.PetTreat = false;
sdh.Auras.PetHat = false;

sdh.Toys = {};
sdh.Toys.PetHat = false;

local squirt_pets = {
    1400, -- [1] Deebs
    1401, -- [2] Tyri
    1402, -- [3] Puzzle
};
local auras_zones = {
    ["Alliance"] = {
        582, -- Lunarfall
    },
    ["Horde"] = {
        590, -- Frostwall
    },
};
local sdr_zones = {
    ["Class"] = {
        [ 1] = { -- Warrior
            695, -- Skyhold (Class Hall)
            -- 1971, -- Skyhold (9.1.0?)
        },
        [ 2] = { -- Paladin
            -- ????
        },
        [ 3] = { -- Hunter
            739, -- Trueshot Lodge (Class Hall)
        },
        [ 4] = { -- Rogue
            626, -- Dalaran - The Hall of Shadows (Class Hall)
        },
        [ 5] = { -- Priest
            702, -- Netherlight Temple (Class Hall)
        },
        [ 6] = { -- Death Knight
            647, -- Acherus: The Ebon Hold - The Heart of Acherus (Class Hall)
            648, --     - Hall of Comand (Class Hall)
        },
        [ 7] = { -- Shaman
            725, -- The Maelstrom (Class Hall)
            726, --     - The Maelstrom (Class Hall)
            -- 839, -- The Maelstrom (?)
            -- 948, -- The Maelstrom (continent; ?)
            -- 1474, -- The Maelstrom - Heart of Azeroth (8.2.0; ?)
        },
        [ 8] = { -- Mage
            734, -- Hall of the Guardian (Class Hall)
            735, --     - The Guardian's Library (Class Hall)
        },
        [ 9] = { -- Warlock
            717, -- Dreadscar Rift (Class Hall)
            718, -- Dreadscar Rift (Class Hall)
        },
        [10] = { -- Monk
            709, -- The Wandering Isle (Class Hall)
        },
        [11] = { -- Druid
            715, -- Emerald Dreamway (Class Hall ?)
            747, -- The Dreamgrove (Class Hall)
            -- 1468, -- The Dreamgrove (8.2.5; ?)
            -- 1471, -- Emerald Dreamway (8.2.0; ?)
            -- 1475, -- The Emerald Dream (8.2.0; ?)
        },
        [12] = { -- Demon Hunter
            719, -- Mardum, the Shattered Abyss (Class Hall)
            720, --     - Upper Command Center (Class Hall)
            721, --     - Lower Command Center (Class Hall)
        },
    },
    ["Neutral"] = {
        111, -- Shattrath
        125, -- Dalaran (Northrend)
        126, --     - Underbelly
        627, -- Dalaran (Broken Isles)
        628, --     - The Underbelly
        629, --     - Aegwynn's Gallery -- I think that's the mage class hall?
        1670, -- Oribos
        1671, --     - Ring of Transference
        1672, --     - The Broker's Den
        1673, --     - The Crucible
        -- TODO: Add covenant check? idk what changes were made in 9.1/.2
        --       so it could be that you can hang out in other covenant sanctums now
        1698, -- Seat of the Primus (Necrolord Covenant Sanctum)
        1699, -- Sinfall Reaches
        1700, -- Sinfall Depths
        1701, -- Heart of the Forest - The Trunk
        1702, -- Heart of the Forest - The Roots
        1703, -- Heart of the Forest - The Canopy
        1707, -- Elysian Hold - Archon's Rise
        1708, -- Elysian Hold - Sanctum of Binding
        2112, -- Valdrakken (maybe 2134; Orphan 2135)
        2339, -- Dornogal
    },
    ["Alliance"] = {
        84, -- Stormwind
        87, -- Ironforge
        89, -- Darnassus
        103, -- The Exodar
        393, -- Shrine of Seven Stars
        394, -- ^
        582, -- Lunarfall
        1161, -- Boralus
    },
    ["Horde"] = {
        85, -- Orgrimmar
        86, --     - Cleft of Shadow
        88, -- Thunder Bluff
        90, -- Undercity
        110, -- Silvermoon
        391, -- Shrine of Two Moons
        392, -- ^
        590, -- Frostwall
        1165, -- Dazar'alor
        1163, --     - The Great Seal
        1164, --     - Hall of Chroniclers
    },
};

local function isOneOf(value, validValues)
    if type(validValues) ~= "table" then
        return false;
    end

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
    --       How to do that?! Especially hard/inconsistent considering daylight saving time
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

local function checkValidLocation(currentZone, faction, classId, validLocations)
    return isOneOf(currentZone, validLocations["Neutral"]) or
            isOneOf(currentZone, validLocations[faction]) or
            (validLocations.Class and isOneOf(currentZone, validLocations.Class[classId]));
end

local function checkLocations()
    local currentZone = C_Map.GetBestMapForUnit("player");
    local faction, _ = UnitFactionGroup("player");
    local _, _, classId = UnitClass("player");

    app:log("Checking location. Currently in zone " .. tostring(currentZone) .. " as faction " .. tostring(faction) .. " with class " .. tostring(classId));

    sdh.Location.AuraReminders = checkValidLocation(currentZone, faction, classId, auras_zones);
    sdh.Location.SquirtDayHelper = checkValidLocation(currentZone, faction, classId, sdr_zones);
end
local function playerHasAura(auraId)
    return C_UnitAuras.GetPlayerAuraBySpellID(auraId) ~= nil;
end
local function checkAuras()
    sdh.Auras.BattlePetEvent = playerHasAura(186406);
    sdh.Auras.LesserPetTreat = playerHasAura(142204);
    sdh.Auras.PetTreat = playerHasAura(142205);
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
    app:log("Checking for squirt fight. Found following enemy pets:");

    for pet=1,C_PetBattles.GetNumPets(2) do
        local id = C_PetBattles.GetPetSpeciesID(2, pet);
        local speciesName, _, petType, _, _, _, _, _, _, _, _, _ = C_PetJournal.GetPetInfoBySpeciesID(id);

        app:log("Pet '" .. speciesName .. "' (ID: " .. id .. ") has pet type " .. petType);
    end

    return C_PetBattles.IsInBattle() and C_PetBattles.IsPlayerNPC(1) and
            C_PetBattles.GetNumPets(2) == 3 and
            isOneOf(C_PetBattles.GetPetSpeciesID(2, 1), squirt_pets) and
            isOneOf(C_PetBattles.GetPetSpeciesID(2, 2), squirt_pets) and
            isOneOf(C_PetBattles.GetPetSpeciesID(2, 3), squirt_pets);
end
local function findUnleveledBattlePets()
    local result = {};

    for pet = 1,C_PetBattles.GetNumPets(1) do
        if C_PetBattles.GetLevel(1, pet) < 25 then
            table.insert(result, pet);
        end
    end

    return result;
end
local function getAmountNewlyLeveled()
    local amount = 0;

    for _,pet in ipairs(sdh.FightTracker) do
        if C_PetBattles.GetLevel(1, pet) == 25 then
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
        -- TODO: Create settings for those colors
        --       Using ColorSelect-FrameType :)
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
    AssureHidden(group.LesserPetTreat);
    AssureHidden(group.PetTreat);
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
            if not sdh.Auras.PetTreat then
                sdh.Displays.PetTreat:SetText(L["SDH_PET_TREAT"]:format(app.createItemLinkById(98114)));
                AssureShown(sdh.Displays.PetTreat);
            else
                AssureHidden(sdh.Displays.PetTreat);
            end

            if not sdh.Auras.LesserPetTreat then
                sdh.Displays.LesserPetTreat:SetText(L["SDH_PET_TREAT"]:format(app.createItemLinkById(98112)));
                AssureShown(sdh.Displays.LesserPetTreat);
            else
                AssureHidden(sdh.Displays.LesserPetTreat);
            end

            if sdh.Toys.PetHat and not sdh.Auras.PetHat then
                sdh.Displays.PetHat:SetText(L["SDH_PET_HAT"]);
                AssureShown(sdh.Displays.PetHat);
            else
                AssureHidden(sdh.Displays.PetHat);
            end
        else
            AssureAurasHidden(sdh.Displays);
        end
    else
        AssureHidden(sdh.Displays.SquirtDayHelper);
        AssureAurasHidden(sdh.Displays);
    end

    -- Store time in the actual update function, since
    -- it might be updated by an event right before it would
    -- have been updated anyways, making this more efficient
    sdh.LastUpdate = GetTime();
end

sdh.CreateDisplays = function(self)
    self.Displays = {};

    self.Displays.Frame = CreateFrame("FRAME", nil, UIParent);
    self.Displays.Frame:SetPoint("TOP", UIParent, "TOP", 0, 0);
    self.Displays.Frame:SetSize(500, 100);

    self.Displays.SquirtDayHelper = self.Displays.Frame:CreateFontString(nil, "OVERLAY");
    self.Displays.SquirtDayHelper:SetFont("Fonts/FRIZQT__.TTF", 24, "THICKOUTLINE");
    self.Displays.SquirtDayHelper:SetPoint("CENTER", self.Displays.Frame, "CENTER", 0, 0);
    self.Displays.SquirtDayHelper:SetTextColor(1, 1, 1);
    self.Displays.SquirtDayHelper:SetShadowColor(0, 0, 0);

    self.Displays.PetTreat = self.Displays.Frame:CreateFontString(nil, "OVERLAY");
    self.Displays.PetTreat:SetPoint("CENTER", self.Displays.Frame, "CENTER", 0, -420);
    self.Displays.PetTreat:SetFont("Fonts/FRIZQT__.TTF", 18, "THICKOUTLINE");
    self.Displays.PetTreat:SetTextColor(1, 1, 1);
    self.Displays.PetTreat:SetShadowColor(0, 0, 0);

    self.Displays.LesserPetTreat = self.Displays.Frame:CreateFontString(nil, "OVERLAY");
    self.Displays.LesserPetTreat:SetPoint("CENTER", self.Displays.PetTreat, "CENTER", 0, -20);
    self.Displays.LesserPetTreat:SetFont("Fonts/FRIZQT__.TTF", 18, "THICKOUTLINE");
    self.Displays.LesserPetTreat:SetTextColor(1, 1, 1);
    self.Displays.LesserPetTreat:SetShadowColor(0, 0, 0);

    self.Displays.PetHat = self.Displays.Frame:CreateFontString(nil, "OVERLAY");
    self.Displays.PetHat:SetPoint("CENTER", self.Displays.LesserPetTreat, "CENTER", 0, -20);
    self.Displays.PetHat:SetFont("Fonts/FRIZQT__.TTF", 18, "THICKOUTLINE");
    self.Displays.PetHat:SetTextColor(1, 1, 1);
    self.Displays.PetHat:SetShadowColor(0, 0, 0);
end

sdh.Initialize = function(self)
    if not SquirtDayHelperPersistence then
        SquirtDayHelperPersistence = {
            ["SquirtDays"] = createNextSquirt({
                [1] = time({ year=2023, month=10, day=30 }), -- US
                [2] = nil, -- KR
                [3] = time({ year=2023, month=10, day=24 }), -- EU
                [4] = nil, -- TW
                [5] = nil, -- CN
            }, GetServerTime());
            ["Statistics"] = {
                ["Battles"] = 0;
                ["PetsLevelled"] = 0;
            };
        };
    end

    if not SquirtDayHelperPersistence.SquirtDays or #SquirtDayHelperPersistence.SquirtDays == 0 then
        SquirtDayHelperPersistence.SquirtDays = createNextSquirt({
                [1] = time({ year=2023, month=10, day=30 }), -- US
                [2] = nil, -- KR
                [3] = time({ year=2023, month=10, day=24 }), -- EU
                [4] = nil, -- TW
                [5] = nil, -- CN
            }, GetServerTime());
    end

    app:log("Initialized Squirt Day Helper.");

    checkLocations();
    checkAuras();
    checkToys();

    self:CreateDisplays();
    self:UpdateDisplays();

    self.Initialized = true;
end

app:RegisterEvent("ZONE_CHANGED_NEW_AREA", "SquirtDayHelper", function()
    checkLocations();
    sdh:UpdateDisplays();
end);
app:RegisterEvent("UNIT_AURA", "SquirtDayHelper", function(targetUnit)
    if targetUnit == "player" then
        checkAuras();
        sdh:UpdateDisplays();
    end
end);
app:RegisterEvent("TOYS_UPDATED", "SquirtDayHelper", function(itemId, isNew, hasFanfare)
    checkToys();
    sdh:UpdateDisplays();
end);
app:RegisterEvent("PET_BATTLE_OPENING_START", "SquirtDayHelper", function()
    -- TODO: Delete isSquirtDay until we reset to the actual daily reset time in createDay()
    if isSquirtDayFight() then
        sdh.FightTracker = findUnleveledBattlePets();
    end
end);
app:RegisterEvent("PET_BATTLE_CLOSE", "SquirtDayHelper", function()
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
end);
app:RegisterUpdate("SquirtDayHelper", function(elapsed)
    -- TODO: Increase threshold
    local UPDATE_THRESHOLD = 20; -- Update threshold in seconds
    local currentTime = GetTime();

    if sdh.Initialized and (not sdh.LastUpdate or sdh.LastUpdate <= currentTime - UPDATE_THRESHOLD) then
        sdh:UpdateDisplays();
    end
end);
