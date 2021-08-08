
local _, app = ...;

app.SquirtDayHelper = {};

local sdh = app.SquirtDayHelper;

sdh.Location = {};
sdh.Location.SquirtDayHelper = false;
sdh.Location.AuraReminders = false 

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

-- TODO: Check for module being enabled before displaying anything

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

sdh.Initialize = function(self)
    checkLocations();
    checkAuras();
    checkToys();

    -- TODO: Update displays
end

local function isOneOf(value, validValues)
    for _,v in ipairs(validValues) do
        if value == v then
            return true;
        end
    end

    return false;
end

app:RegisterEvent("ZONE_CHANGED");
app.events.ZONE_CHANGED = function(e)
    checkLocations();
    -- TODO: Update displays
end
app:RegisterEvent("UNIT_AURA");
app.events.UNIT_AURA = function(e, targetUnit)
    if targetUnit == "player" then
        checkAuras();
        -- TODO: Update displays
    end
end
app:RegisterEvent("TOYS_UPDATED");
app.events.TOYS_UPDATED = function(e, itemId, isNew, hasFanfare)
    checkToys();
    -- TODO: Update displays
end
