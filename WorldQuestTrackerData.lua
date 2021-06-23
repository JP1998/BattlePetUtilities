local _,app = ...;

local L = app.L;

--[[
    Enums:
]]

local QuestTypes = {
    ["daily"] = "daily",
    ["weekly"] = "weekly"
};

local Factions = {
    ["Alliance"] = "Alliance",
    ["Horde"] = "Horde",
    ["Neutral"] = "Neutral"
};

local ZoneIds = {
    ["Ashenvale"]= 63, -- 1310 (?)
    ["Azsuna"] = 630, -- 1187 (?) probably not 867 (dungeon; ?)
    ["Boralus"] = 1161,
    ["Burning_Steppes"] = 36, -- 1255 (?)
    ["Crystalsong_Forest"] = 127, -- 1405 (?)
    ["Darkmoon_Island"] = 407, -- 408 (dungeon; ?)
    ["Dazaralor"] = 1165,
    ["Deadwind_Pass"] = 42, -- 1257 (?)
    ["Deepholm"] = 207,
    ["Desolace"] = 66, -- 1313 (?)
    ["Dragonblight"] = 115, -- 1397 (?)
    ["Dread_Wastes"] = 422,
    ["Dun_Morogh"] = 27, -- 1253 (?) probably not 523 (micro; ?)
    ["Duskwood"] = 47, -- 1258 (?)
    ["Dustwallow_Marsh"] = 70, -- 1315 (?) 483 (orphan; ?) 416 (orphan; ?)
    ["Durotar"] = 1, -- 1305 (?) 1535 (orphan; ?)
    ["Eastern_Plaguelands"] = 23, -- 1250 (?)
    ["Elwynn_Forest"] = 37, -- 1256 (?)
    ["Felwood"] = 77, -- 1318
    ["Feralas"] = 69, -- 1314 (?)
    ["Frostfire_Ridge"] = 525,
    ["Frostwall"] = 590,
    ["Gorgrond"] = 543,
    ["Hellfire_Peninsula"] = 100,
    ["Howling_Fjord"] = 117, -- 1399 (?)
    ["Icecrown"] = 118, -- 1400 (?)
    ["Krasarang_Wilds"] = 418, -- 498 (orphan; ?) 486 (orphan; ?)
    ["Kun_Lai_Summit"] = 379,
    ["Lunarfall"] = 582,
    ["Moonglade"] = 80, -- 1320 (?)
    ["Mount_Hyjal"] = 198, -- 1328 (?)
    ["Nagrand_Draenor"] = 550,
    ["Nagrand_Outland"] = 107,
    ["Northern_Barrens"] = 10, -- 1307 (?)
    ["Northern_Stranglethorn"] = 50,
    ["Redridge_Mountains"] = 49, -- 1260 (?)
    ["Searing_Gorge"] = 32, -- 1254 (?)
    ["Shadowmoon_Valley_Draenor"] = 539,
    ["Shadowmoon_Valley_Outland"] = 104,
    ["Shattrath_City"] = 111, -- 594 (orphan; ?)
    ["Southern_Barrens"] = 199, -- 1329 (?)
    ["Spires_of_Arak"] = 542,
    ["Stonetalon_Mountains"] = 50,
    ["Swamp_of_Sorrow"] = 51, -- 1261 (?)
    ["Talador"] = 535,
    ["The_Cape_of_Stranglethorn"] = 210,
    ["The_Hinterlands"] = 26, -- 1252 (?)
    ["The_Jade_Forest"] = 371, -- 448 (orphan; ?)
    ["Thousand_Needles"] = 64, -- 1311 (?)
    ["Timeless_Isle"] = 554,
    ["Townlong_Steppes"] = 388,
    ["Twilight_Highlands"] = 241, -- 1275 (?) 1476 (orphan; ?)
    ["Uldum"] = 249, -- 1571 (orphan; ?) 1527 (8.3 ?) 1330 (8.1 ?)
    ["Vale_of_Eternal_Blossoms"] = 390, -- 1570 (micro; ?) 1530 (8.3; ?)
    ["Valley_of_the_Four_Winds"] = 376,
    ["Westfall"] = 52, -- 1262 (?)
    ["Winterspring"] = 83, -- 1322 (?)
    ["Zangarmarsh"] = 102,
    ["ZulDrak"] = 121, -- 1403 (?)
};

--[[
    Classes (or something like that, lol)
]]

local function Location(x, y)
    return {
        ["x"] = x,
        ["y"] = y
    };
end

local function QuestGiver(name, zoneid, location)
    return {
        ["name"] = name,
        ["zoneId"] = zoneid,
        ["location"] = location
    };
end

local function _Reward(amount)
    assert(type(amount) == "number", "Reward amount cannot be of type " .. type(amount));

    return {
        ["amount"] = amount
    };
end

local function ItemReward(itemId, amount)
    assert(type(itemId) == "number", "ItemID for quest reward cannot be of type " .. type(itemId));

    local reward = _Reward(amount);

    reward["itemId"] = itemId;

    return reward;
end

local function CurrencyReward(currencyId, amount)
    assert(type(currencyId) == "number", "CurrencyID for quest reward cannot be of type " .. type(currencyId));

    local reward = _Reward(amount);

    reward["currencyId"] = currencyId;

    return reward;
end

local function GenericQuestGiver(name, questgiver)
    return { name, questgiver };    -- Has to be packed, since it is passes as varargs to QuestGiverTable
                                    -- and returning a multival would cut off the second return value.
end
local function NeutralQuestGiver(questgiver)
    return GenericQuestGiver(Factions.Neutral, questgiver);
end
local function AllianceQuestGiver(questgiver)
    return GenericQuestGiver(Factions.Alliance, questgiver);
end
local function HordeQuestGiver(questgiver)
    return GenericQuestGiver(Factions.Horde, questgiver);
end
local function QuestGiverTable( ... )
    local args = { ... };

    assert(#args > 0, "QuestGiverTable cannot be empty.");

    local params = {};

    for i,v in pairs(args) do
        assert(type(v) == "table" and #v == 2, "Given Questgiver couldn't be assigned.");

        for key,value in pairs(v) do
            table.insert(params, value);
        end
    end

    assert(#params % 2 == 0, "Not possible, making sure nonetheless.");

    local result = {};

    for i = 1,#params,2 do
        result[params[i]] = params[i + 1];
    end

    return result;
end

local function Quest(name, id, questtype, faction, questgivers, ...)
    return {
        ["name"] = name,
        ["questId"] = id,
        ["questType"] = questtype,
        ["faction"] = faction,
        -- What if there are several questgivers for a faction
        -- like on "What We've Been Training For" which has (in
        -- part  for that reason) been left out of this list.
        -- Perhaps have lists for each faction? But then which will be selected for waypoints?
        ["questgiver"] = questgivers,
        ["rewards"] = {
            ...
        }
    };
end

local QuestGivers = {
    ["Master_Li"]                   = QuestGiver(L["QUESTDATA_QUESTGIVERS_MASTER_LI"],                   ZoneIds.Timeless_Isle,              Location(34.8, 59.6)),
    ["Muyani"]                      = QuestGiver(L["QUESTDATA_QUESTGIVERS_MUYANI"],                      ZoneIds.Northern_Barrens,           Location(38.8, 68.2)),
    ["Marcus_Bagman_Brown"]         = QuestGiver(L["QUESTDATA_QUESTGIVERS_MARCUS_BAGMAN_BROWN"],         ZoneIds.Westfall,                   Location(41.4, 71.2)),
    ["Radek_Fuselock"]              = QuestGiver(L["QUESTDATA_QUESTGIVERS_RADEK_FUSELOCK"],              ZoneIds.Dazaralor,                  Location(56.2, 31)),
    ["Tizzy_Gearjolt"]              = QuestGiver(L["QUESTDATA_QUESTGIVERS_TIZZY_GEARJOLT"],              ZoneIds.Boralus,                    Location(50, 46.8)),
    ["Micro_Zoox"]                  = QuestGiver(L["QUESTDATA_QUESTGIVERS_MICRO_ZOOX"],                  ZoneIds.Dun_Morogh,                 Location(31.6, 71.2)),
    ["Sean_Wilkers"]                = QuestGiver(L["QUESTDATA_QUESTGIVERS_SEAN_WILKERS"],                ZoneIds.Eastern_Plaguelands,        Location(43.2, 20)),
    ["Jeremy_Feasel"]               = QuestGiver(L["QUESTDATA_QUESTGIVERS_JEREMY_FEASEL"],               ZoneIds.Darkmoon_Island,            Location(47.8, 62.4)),
    ["Christoph_VonFeasel"]         = QuestGiver(L["QUESTDATA_QUESTGIVERS_CHRISTOPH_VONFEASEL"],         ZoneIds.Darkmoon_Island,            Location(47.4, 62.2)),
    ["Shipwrecked_Captive"]         = QuestGiver(L["QUESTDATA_QUESTGIVERS_SHIPWRECKED_CAPTIVE"],         ZoneIds.Azsuna,                     Location(49.2, 45.4)),
    ["Serrah"]                      = QuestGiver(L["QUESTDATA_QUESTGIVERS_SERRAH"],                      ZoneIds.Frostwall,                  Location(32.4, 42.4)),
    ["Lio_the_Lioness"]             = QuestGiver(L["QUESTDATA_QUESTGIVERS_LIO_THE_LIONESS"],             ZoneIds.Lunarfall,                  Location(28.8, 39.2)),
    ["Kura_Thunderhoof"]            = QuestGiver(L["QUESTDATA_QUESTGIVERS_KURA_THUNDERHOOF"],            ZoneIds.Frostwall,                  Location(33.6, 42.4)),
    ["Erris_the_Collector"]         = QuestGiver(L["QUESTDATA_QUESTGIVERS_ERRIS_THE_COLLECTOR"],         ZoneIds.Lunarfall,                  Location(29, 40.4)),
    ["Cymre_Brightblade"]           = QuestGiver(L["QUESTDATA_QUESTGIVERS_CYMRE_BRIGHTBLADE"],           ZoneIds.Gorgrond,                   Location(51, 70.6)),
    ["Taralune"]                    = QuestGiver(L["QUESTDATA_QUESTGIVERS_TARALUNE"],                    ZoneIds.Talador,                    Location(49, 80.4)),
    ["Vesharr"]                     = QuestGiver(L["QUESTDATA_QUESTGIVERS_VESHARR"],                     ZoneIds.Spires_of_Arak,             Location(46.4, 45.2)),
    ["Ashlei"]                      = QuestGiver(L["QUESTDATA_QUESTGIVERS_ASHLEI"],                      ZoneIds.Shadowmoon_Valley_Draenor,  Location(50, 31.2)),
    ["Tarr_the_Terrible"]           = QuestGiver(L["QUESTDATA_QUESTGIVERS_TARR_THE_TERRIBLE"],           ZoneIds.Nagrand_Draenor,            Location(56.2, 9.8)),
    ["Gargra"]                      = QuestGiver(L["QUESTDATA_QUESTGIVERS_GARGRA"],                      ZoneIds.Frostfire_Ridge,            Location(68.6, 64.6)),
    ["Gentle_San"]                  = QuestGiver(L["QUESTDATA_QUESTGIVERS_GENTLE_SAN"],                  ZoneIds.Vale_of_Eternal_Blossoms,   Location(60.8, 23.6)),
    ["Sara_Finkleswitch"]           = QuestGiver(L["QUESTDATA_QUESTGIVERS_SARA_FINKLESWITCH"],           ZoneIds.Vale_of_Eternal_Blossoms,   Location(86.4, 60)),
    ["Aki_the_Chosen"]              = QuestGiver(L["QUESTDATA_QUESTGIVERS_AKI_THE_CHOSEN"],              ZoneIds.Vale_of_Eternal_Blossoms,   Location(84, 28.6)),
    ["Hyuna_of_the_Shrines"]        = QuestGiver(L["QUESTDATA_QUESTGIVERS_HYUNA_OF_THE_SHRINES"],        ZoneIds.The_Jade_Forest,            Location(48, 54)),
    ["Moruk"]                       = QuestGiver(L["QUESTDATA_QUESTGIVERS_MORUK"],                       ZoneIds.Krasarang_Wilds,            Location(62.2, 45.8)),
    ["Wastewalker_Shu"]             = QuestGiver(L["QUESTDATA_QUESTGIVERS_WASTEWALKER_SHU"],             ZoneIds.Dread_Wastes,               Location(55, 37.4)),
    ["Farmer_Nishi"]                = QuestGiver(L["QUESTDATA_QUESTGIVERS_FARMER_NISHI"],                ZoneIds.Valley_of_the_Four_Winds,   Location(46, 43.6)),
    ["Seeker_Zusshi"]               = QuestGiver(L["QUESTDATA_QUESTGIVERS_SEEKER_ZUSSHI"],               ZoneIds.Townlong_Steppes,           Location(36.2, 52.2)),
    ["Courageous_Yon"]              = QuestGiver(L["QUESTDATA_QUESTGIVERS_COURAGEOUS_YON"],              ZoneIds.Kun_Lai_Summit,             Location(35.8, 73.6)),
    ["Thundering_Pandaren_Spirit"]  = QuestGiver(L["QUESTDATA_QUESTGIVERS_THUNDERING_PANDAREN_SPIRIT"],  ZoneIds.Kun_Lai_Summit,             Location(64.8, 93.6)),
    ["Burning_Pandaren_Spirit"]     = QuestGiver(L["QUESTDATA_QUESTGIVERS_BURNING_PANDAREN_SPIRIT"],     ZoneIds.Townlong_Steppes,           Location(57, 42.2)),
    ["Whispering_Pandaren_Spirit"]  = QuestGiver(L["QUESTDATA_QUESTGIVERS_WHISPERING_PANDAREN_SPIRIT"],  ZoneIds.The_Jade_Forest,            Location(28.8, 36)),
    ["Flowing_Pandaren_Spirit"]     = QuestGiver(L["QUESTDATA_QUESTGIVERS_FLOWING_PANDAREN_SPIRIT"],     ZoneIds.Dread_Wastes,               Location(61.2, 87.6)),
    ["Little_Tommy_Newcomer"]       = QuestGiver(L["QUESTDATA_QUESTGIVERS_LITTLE_TOMMY_NEWCOMER"],       ZoneIds.Timeless_Isle,              Location(34.6, 60.4)),
    ["Brok"]                        = QuestGiver(L["QUESTDATA_QUESTGIVERS_BROK"],                        ZoneIds.Mount_Hyjal,                Location(61.4, 32.8)),
    ["Bordin_Steadyfist"]           = QuestGiver(L["QUESTDATA_QUESTGIVERS_BORDIN_STEADYFIST"],           ZoneIds.Deepholm,                   Location(49.8, 57)),
    ["Obalis"]                      = QuestGiver(L["QUESTDATA_QUESTGIVERS_OBALIS"],                      ZoneIds.Uldum,                      Location(54.4, 37.6)),
    ["Goz_Banefury"]                = QuestGiver(L["QUESTDATA_QUESTGIVERS_GOZ_BANEFURY"],                ZoneIds.Twilight_Highlands,         Location(56.6, 56.8)),
    ["Nearly_Headless_Jacob"]       = QuestGiver(L["QUESTDATA_QUESTGIVERS_NEARLY_HEADLESS_JACOB"],       ZoneIds.Crystalsong_Forest,         Location(50.2, 59)),
    ["Okrut_Dragonwaste"]           = QuestGiver(L["QUESTDATA_QUESTGIVERS_OKRUT_DRAGONWASTE"],           ZoneIds.Dragonblight,               Location(59, 77)),
    ["Gutretch"]                    = QuestGiver(L["QUESTDATA_QUESTGIVERS_GUTRETCH"],                    ZoneIds.ZulDrak,                    Location(13.2, 66.8)),
    ["Major_Payne"]                 = QuestGiver(L["QUESTDATA_QUESTGIVERS_MAJOR_PAYNE"],                 ZoneIds.Icecrown,                   Location(77.4, 19.6)),
    ["Beegle_Blastfuse"]            = QuestGiver(L["QUESTDATA_QUESTGIVERS_BEEGLE_BLASTFUSE"],            ZoneIds.Howling_Fjord,              Location(28.6, 33.8)),
    ["Morulu_The_Elder"]            = QuestGiver(L["QUESTDATA_QUESTGIVERS_MORULU_THE_ELDER"],            ZoneIds.Shattrath_City,             Location(59, 70)),
    ["Bloodknight_Antari"]          = QuestGiver(L["QUESTDATA_QUESTGIVERS_BLOODKNIGHT_ANTARI"],          ZoneIds.Shadowmoon_Valley_Outland,  Location(30.4, 41.8)),
    ["Nicki_Tinytech"]              = QuestGiver(L["QUESTDATA_QUESTGIVERS_NICKI_TINYTECH"],              ZoneIds.Hellfire_Peninsula,         Location(64.4, 49.2)),
    ["Rasan"]                       = QuestGiver(L["QUESTDATA_QUESTGIVERS_RASAN"],                       ZoneIds.Zangarmarsh,                Location(17.2, 50.4)),
    ["Narrok"]                      = QuestGiver(L["QUESTDATA_QUESTGIVERS_NARROK"],                      ZoneIds.Nagrand_Outland,            Location(61, 49.4)),
    ["Environeer_Bert"]             = QuestGiver(L["QUESTDATA_QUESTGIVERS_ENVIRONEER_BERT"],             ZoneIds.Dun_Morogh,                 Location(43, 73.6)),
    ["Crysa"]                       = QuestGiver(L["QUESTDATA_QUESTGIVERS_CRYSA"],                       ZoneIds.Northern_Barrens,           Location(63.6, 35.8)),
    ["Stone_Cold_Trixxy"]           = QuestGiver(L["QUESTDATA_QUESTGIVERS_STONE_COLD_TRIXXY"],           ZoneIds.Winterspring,               Location(65.6, 64.4)),
    ["Dagra_the_Fierce"]            = QuestGiver(L["QUESTDATA_QUESTGIVERS_DAGRA_THE_FIERCE"],            ZoneIds.Northern_Barrens,           Location(58.6, 53)),
    ["Julia_Stevens"]               = QuestGiver(L["QUESTDATA_QUESTGIVERS_JULIA_STEVENS"],               ZoneIds.Elwynn_Forest,              Location(41.6, 83.6)),
    ["Analynn"]                     = QuestGiver(L["QUESTDATA_QUESTGIVERS_ANALYNN"],                     ZoneIds.Ashenvale,                  Location(20.2, 29.6)),
    ["Bill_Buckler"]                = QuestGiver(L["QUESTDATA_QUESTGIVERS_BILL_BUCKLER"],                ZoneIds.The_Cape_of_Stranglethorn,  Location(51.4, 73.2)),
    ["Traitor_Gluk"]                = QuestGiver(L["QUESTDATA_QUESTGIVERS_TRAITOR_GLUK"],                ZoneIds.Feralas,                    Location(59.6, 49.6)),
    ["Eric_Davidson"]               = QuestGiver(L["QUESTDATA_QUESTGIVERS_ERIC_DAVIDSON"],               ZoneIds.Duskwood,                   Location(19.8, 44.8)),
    ["Cassandra_Kaboom"]            = QuestGiver(L["QUESTDATA_QUESTGIVERS_CASSANDRA_KABOOM"],            ZoneIds.Southern_Barrens,           Location(39.6, 79.2)),
    ["Kortas_Darkhammer"]           = QuestGiver(L["QUESTDATA_QUESTGIVERS_KORTAS_DARKHAMMER"],           ZoneIds.Searing_Gorge,              Location(35.4, 27.8)),
    ["Durin_Darkhammer"]            = QuestGiver(L["QUESTDATA_QUESTGIVERS_DURIN_DARKHAMMER"],            ZoneIds.Burning_Steppes,            Location(25.6, 47.4)),
    ["Kela_Grimtotem"]              = QuestGiver(L["QUESTDATA_QUESTGIVERS_KELA_GRIMTOTEM"],              ZoneIds.Thousand_Needles,           Location(31.8, 32.8)),
    ["Elena_Flutterfly"]            = QuestGiver(L["QUESTDATA_QUESTGIVERS_ELENA_FLUTTERFLY"],            ZoneIds.Moonglade,                  Location(46, 60.4)),
    ["Lydia_Accoste"]               = QuestGiver(L["QUESTDATA_QUESTGIVERS_LYDIA_ACCOSTE"],               ZoneIds.Deadwind_Pass,              Location(40.2, 76.4)),
    ["Grazzle_the_Great"]           = QuestGiver(L["QUESTDATA_QUESTGIVERS_GRAZZLE_THE_GREAT"],           ZoneIds.Dustwallow_Marsh,           Location(53.8, 74.8)),
    ["Old_MacDonald"]               = QuestGiver(L["QUESTDATA_QUESTGIVERS_OLD_MACDONALD"],               ZoneIds.Westfall,                   Location(60.8, 18.6)),
    ["Zoltan"]                      = QuestGiver(L["QUESTDATA_QUESTGIVERS_ZOLTAN"],                      ZoneIds.Felwood,                    Location(40, 56.6)),
    ["Zunta"]                       = QuestGiver(L["QUESTDATA_QUESTGIVERS_ZUNTA"],                       ZoneIds.Durotar,                    Location(43.8, 28.8)),
    ["David_Kosse"]                 = QuestGiver(L["QUESTDATA_QUESTGIVERS_DAVID_KOSSE"],                 ZoneIds.The_Hinterlands,            Location(62.8, 54.6)),
    ["Merda_Stronghoof"]            = QuestGiver(L["QUESTDATA_QUESTGIVERS_MERDA_STRONGHOOF"],            ZoneIds.Desolace,                   Location(57.2, 45.8)),
    ["Steven_Lisbane"]              = QuestGiver(L["QUESTDATA_QUESTGIVERS_STEVEN_LISBANE"],              ZoneIds.Northern_Stranglethorn,     Location(46, 40.4)),
    ["Zonya_the_Sadist"]            = QuestGiver(L["QUESTDATA_QUESTGIVERS_ZONYA_THE_SADIST"],            ZoneIds.Stonetalon_Mountains,       Location(59.6, 71.6)),
    ["Everessa"]                    = QuestGiver(L["QUESTDATA_QUESTGIVERS_EVERESSA"],                    ZoneIds.Swamp_of_Sorrow,            Location(76.6, 41.4)),
    ["Deiza_Plaguehorn"]            = QuestGiver(L["QUESTDATA_QUESTGIVERS_DEIZA_PLAGUEHORN"],            ZoneIds.Eastern_Plaguelands,        Location(67, 52.4)),
    ["Lindsay"]                     = QuestGiver(L["QUESTDATA_QUESTGIVERS_LINDSAY"],                     ZoneIds.Redridge_Mountains,         Location(33.2, 52.6)),
};

app.WorldQuestTracker.QuestData = {
    ["WorldQuests"] = {
        ["shadowlands"] = {
            61784, 61787, 61783, 61791, -- Bastion
            61866, 61867, 61868, 61870, -- Maldraxxus
            61879, 61883, 61885, 61886, -- Revendreth
            61946, 61947, 61948, 61949, -- Ardenweald
        },
        ["battleforazeroth"] = {
            56382, 56386, 56391, 56392, 56389, 56388, 56385, 56381, 56387, 56384, 56383, 56390, -- Nazjatar
            56397, 56396, 56393, 56395, 56399, 56400, 56398, 56394, -- Mechagon
            58746, 58747, 58748, 58749, -- Vale of Eternal Blossoms
            58742, 58744, 58743, 58745, -- Uldum
            52471, 52751, 52430, 52455, -- Tiragarde Sound
            52325, 52316, 52165, 52126, -- Stormsong Valley
            52297, 52278, 52218, 52009, -- Drustvar
            52923, 52938, 52937, 52892, -- Zuldazar
            52779, 52754, 52803, 52799, -- Nazmir
            52850, 52878, 52864, 52856, -- Vol'dun
        },
        ["legion"] = {
            46111, 46112, 46113, -- The Broken Shore
            42442, 40299, 41881, 40298, 41886, 42062, 40277, -- Dalaran
            42063, 42146, 42159, 42148, 42154, -- Azsuna
            40279, 41862, 41861, 41855, 41860, -- Val'sharah
            40280, 40282, 41766, 42064, 41687, 41624, -- Highmountain
            42067, 41944, 41958, 40278, 41948, 41935, -- Stormheim
            41895, 41914, 41990, 40337, 42015, 41931, -- Suramar
            49044, 49043, 49045, 49042, 49046, 49041, -- Krokuun
            49052, 49047, 49048, 49049, 49050, 49051, -- Mac'Aree
            49057, 49056, 49054, 49058, 49053, 49055, -- Antoran Wastes
        },
    },
    ["RepeatableQuests"] = {
        ["dungeons"] = {
            Quest(L["QUESTDATA_QUESTNAME_THE_CELESTIAL_TOURNAMENT"],                33137,  QuestTypes.weekly,  Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Master_Li)),                                                          ItemReward(101529, 1), CurrencyReward(777, 1000)), -- [1]
            Quest(L["QUESTDATA_QUESTNAME_PET_BATTLE_CHALLENGE_WAILING_CAVERNS"],    45539,  QuestTypes.weekly,  Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Muyani)),                                                             ItemReward(143753, 1)), -- [2]
            Quest(L["QUESTDATA_QUESTNAME_PET_BATTLE_CHALLENGE_DEADMINES"],          46292,  QuestTypes.weekly,  Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Marcus_Bagman_Brown)),                                                ItemReward(151191, 1)), -- [3]
            Quest(L["QUESTDATA_QUESTNAME_PET_BATTLE_CHALLENGE_BLACKROCK_DEPTHS"],   58458,  QuestTypes.weekly,  Factions.neutral,   QuestGiverTable(HordeQuestGiver(QuestGivers.Radek_Fuselock), AllianceQuestGiver(QuestGivers.Tizzy_Gearjolt)),       ItemReward(174360, 1)), -- [4]
            Quest(L["QUESTDATA_QUESTNAME_PET_BATTLE_CHALLENGE_GNOMEREGAN"],         54186,  QuestTypes.weekly,  Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Micro_Zoox)),                                                         ItemReward(165835, 1)), -- [5]
            Quest(L["QUESTDATA_QUESTNAME_PET_BATTLE_CHALLENGE_STRATHOLME"],         56492,  QuestTypes.weekly,  Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Sean_Wilkers)),                                                       ItemReward(169665, 1)), -- [6]
        },
        ["darkmoonfaire"] = {
            Quest(L["QUESTDATA_QUESTNAME_DARKMOON_PET_BATTLE"],                     32175,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Jeremy_Feasel)),                                                      ItemReward(91086, 1)), -- [1]
            Quest(L["QUESTDATA_QUESTNAME_A_NEW_DARKMOON_CHALLENGER"],               36471,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Christoph_VonFeasel)),                                                ItemReward(116062, 1)), -- [2]
        },
        -- TODO: Investigate whether there really are no BfA/SL dailies
        ["legion"] = {
            Quest(L["QUESTDATA_QUESTNAME_SHIPWRECKED_CAPTIVE"],                     40310,  QuestTypes.weekly,  Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Shipwrecked_Captive)),                                                ItemReward(116415, 4)), -- [1]
        },
        ["warlordsofdraenor"] = {
            Quest(L["QUESTDATA_QUESTNAME_BATTLE_PET_TAMERS_WARLORDS"],              40329,  QuestTypes.weekly,  Factions.neutral,   QuestGiverTable(HordeQuestGiver(QuestGivers.Serrah), AllianceQuestGiver(QuestGivers.Lio_the_Lioness)),              ItemReward(116429, 1)), -- [1]
            Quest(L["QUESTDATA_QUESTNAME_MASTERING_THE_MENAGERIE"],                 37644,  QuestTypes.daily,   Factions.alliance,  QuestGiverTable(AllianceQuestGiver(QuestGivers.Lio_the_Lioness)),                                                   ItemReward(118697, 1)), -- [2]
            Quest(L["QUESTDATA_QUESTNAME_MASTERING_THE_MENAGERIE"],                 37645,  QuestTypes.daily,   Factions.horde,     QuestGiverTable(HordeQuestGiver(QuestGivers.Serrah)),                                                               ItemReward(118697, 1)), -- [3]
            Quest(L["QUESTDATA_QUESTNAME_CRITTERS_OF_DRAENOR"],                     38299,  QuestTypes.daily,   Factions.alliance,  QuestGiverTable(AllianceQuestGiver(QuestGivers.Erris_the_Collector)),                                               ItemReward(122535, 1), ItemReward(116429, 3)), -- [4]
            Quest(L["QUESTDATA_QUESTNAME_CRITTERS_OF_DRAENOR"],                     38300,  QuestTypes.daily,   Factions.horde,     QuestGiverTable(HordeQuestGiver(QuestGivers.Kura_Thunderhoof)),                                                     ItemReward(122535, 1), ItemReward(116429, 3)), -- [5]
            Quest(L["QUESTDATA_QUESTNAME_BATTLE_PET_ROUNDUP"],                      36483,  QuestTypes.daily,   Factions.alliance,  QuestGiverTable(AllianceQuestGiver(QuestGivers.Lio_the_Lioness)),                                                   ItemReward(116415, 4)), -- [6]
            Quest(L["QUESTDATA_QUESTNAME_SCRAPPIN"],                                36662,  QuestTypes.daily,   Factions.horde,     QuestGiverTable(HordeQuestGiver(QuestGivers.Serrah)),                                                               ItemReward(116415, 4)), -- [7]
            Quest(L["QUESTDATA_QUESTNAME_CYMRE_BRIGHTBLADE"],                       37201,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Cymre_Brightblade)),                                                  ItemReward(116415, 2)), -- [8]
            Quest(L["QUESTDATA_QUESTNAME_TARALUNE"],                                37208,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Taralune)),                                                           ItemReward(116415, 2)), -- [9]
            Quest(L["QUESTDATA_QUESTNAME_VESHARR"],                                 37207,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Vesharr)),                                                            ItemReward(116415, 2)), -- [10]
            Quest(L["QUESTDATA_QUESTNAME_ASHLEI"],                                  37203,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Ashlei)),                                                             ItemReward(116415, 2)), -- [11]
            Quest(L["QUESTDATA_QUESTNAME_TARR_THE_TERRIBLE"],                       37206,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Tarr_the_Terrible)),                                                  ItemReward(116415, 2)), -- [12]
            Quest(L["QUESTDATA_QUESTNAME_GARGRA"],                                  37205,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Gargra)),                                                             ItemReward(116415, 2)), -- [13]
        },
        ["mistsofpandaria"] = {
            Quest(L["QUESTDATA_QUESTNAME_BEASTS_OF_FABLE_BOOK_I"],                  32604,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(HordeQuestGiver(QuestGivers.Gentle_San), AllianceQuestGiver(QuestGivers.Sara_Finkleswitch)),        ItemReward(94207, 1)), -- [1]
            Quest(L["QUESTDATA_QUESTNAME_BEASTS_OF_FABLE_BOOK_II"],                 32868,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(HordeQuestGiver(QuestGivers.Gentle_San), AllianceQuestGiver(QuestGivers.Sara_Finkleswitch)),        ItemReward(94207, 1)), -- [2]
            Quest(L["QUESTDATA_QUESTNAME_BEASTS_OF_FABLE_BOOK_III"],                32869,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(HordeQuestGiver(QuestGivers.Gentle_San), AllianceQuestGiver(QuestGivers.Sara_Finkleswitch)),        ItemReward(94207, 1)), -- [3]
            Quest(L["QUESTDATA_QUESTNAME_GRAND_MASTER_AKI"],                        31958,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Aki_the_Chosen)),                                                     ItemReward(89125, 1)), -- [4]
            Quest(L["QUESTDATA_QUESTNAME_GRAND_MASTER_HYUNA"],                      31953,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Hyuna_of_the_Shrines)),                                               ItemReward(89125, 1)), -- [5]
            Quest(L["QUESTDATA_QUESTNAME_GRAND_MASTER_MORUK"],                      31954,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Moruk)),                                                              ItemReward(89125, 1)), -- [6]
            Quest(L["QUESTDATA_QUESTNAME_GRAND_MASTER_SHU"],                        31957,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Wastewalker_Shu)),                                                    ItemReward(89125, 1)), -- [7]
            Quest(L["QUESTDATA_QUESTNAME_GRAND_MASTER_NISHI"],                      31955,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Farmer_Nishi)),                                                       ItemReward(89125, 1)), -- [8]
            Quest(L["QUESTDATA_QUESTNAME_GRAND_MASTER_ZUSSHI"],                     31991,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Seeker_Zusshi)),                                                      ItemReward(89125, 1)), -- [9]
            Quest(L["QUESTDATA_QUESTNAME_GRAND_MASTER_YON"],                        31956,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Courageous_Yon)),                                                     ItemReward(89125, 1)), -- [10]
            Quest(L["QUESTDATA_QUESTNAME_THUNDERING_PANDAREN_SPIRIT"],              32441,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Thundering_Pandaren_Spirit)),                                         ItemReward(93149, 1)), -- [11]
            Quest(L["QUESTDATA_QUESTNAME_BURNING_PANDAREN_SPIRIT"],                 32434,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Burning_Pandaren_Spirit)),                                            ItemReward(93146, 1)), -- [12]
            Quest(L["QUESTDATA_QUESTNAME_WHISPERING_PANDAREN_SPIRIT"],              32440,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Whispering_Pandaren_Spirit)),                                         ItemReward(93148, 1)), -- [13]
            Quest(L["QUESTDATA_QUESTNAME_FLOWING_PANDAREN_SPIRIT"],                 32439,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Flowing_Pandaren_Spirit)),                                            ItemReward(93147, 1)), -- [14]
            Quest(L["QUESTDATA_QUESTNAME_LITTLE_TOMMY_NEWCOMER"],                   33222,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Little_Tommy_Newcomer)),                                              CurrencyReward(777, 500)), -- [15]
        },
        ["cataclysm"] = {
            Quest(L["QUESTDATA_QUESTNAME_BROK"],                                    31972,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Brok))), -- [1]
            Quest(L["QUESTDATA_QUESTNAME_BORDIN_STEADYFIST"],                       31973,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Bordin_Steadyfist))), -- [3]
            Quest(L["QUESTDATA_QUESTNAME_GRAND_MASTER_OBALIS"],                     31971,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Obalis)),                                                             ItemReward(89125, 1)), -- [2]
            Quest(L["QUESTDATA_QUESTNAME_GOZ_BANEFURY"],                            31974,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Goz_Banefury))), -- [4]
        },
        ["wrathofthelichking"] = {
            Quest(L["QUESTDATA_QUESTNAME_NEARLY_HEADLESS_JACOB"],                   31932,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Nearly_Headless_Jacob))), -- [1]
            Quest(L["QUESTDATA_QUESTNAME_OKRUT_DRAGONWASTE"],                       31933,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Okrut_Dragonwaste))), -- [2]
            Quest(L["QUESTDATA_QUESTNAME_GUTRETCH"],                                31934,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Gutretch))), -- [3]
            Quest(L["QUESTDATA_QUESTNAME_GRAND_MASTER_PAYNE"],                      31935,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Major_Payne)),                                                        ItemReward(89125, 1)), -- [4]
            Quest(L["QUESTDATA_QUESTNAME_BEEGLE_BLASTFUSE"],                        31931,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Beegle_Blastfuse))), -- [5]
        },
        ["theburningcrusade"] = {
            Quest(L["QUESTDATA_QUESTNAME_MORULU_THE_ELDER"],                        31925,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Morulu_The_Elder))), -- [1]
            Quest(L["QUESTDATA_QUESTNAME_GRAND_MASTER_ANTARI"],                     31926,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Bloodknight_Antari)),                                                 ItemReward(89125, 1)), -- [2]
            Quest(L["QUESTDATA_QUESTNAME_NICKI_TINYTECH"],                          31922,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Nicki_Tinytech))), -- [3]
            Quest(L["QUESTDATA_QUESTNAME_RASAN"],                                   31923,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Rasan))), -- [4]
            Quest(L["QUESTDATA_QUESTNAME_NARROK"],                                  31924,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Narrok))), -- [5]
        },
        ["classic"] = {
            -- TODO: Investigate the validity of the faction
            Quest(L["QUESTDATA_QUESTNAME_BERTS_BOTS"],                              47895,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Environeer_Bert)),                                                    ItemReward(151638, 1)), -- [1]
            Quest(L["QUESTDATA_QUESTNAME_CRYSAS_FLYERS"],                           45083,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Crysa)),                                                              ItemReward(142447, 1)), -- [2]
            Quest(L["QUESTDATA_QUESTNAME_GRAND_MASTER_TRIXXY"],                     31909,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Stone_Cold_Trixxy)),                                                  ItemReward(89125, 1)), -- [3]
            Quest(L["QUESTDATA_QUESTNAME_DAGRA_THE_FIERCE"],                        31819,  QuestTypes.daily,   Factions.horde,     QuestGiverTable(HordeQuestGiver(QuestGivers.Dagra_the_Fierce))), -- [4]
            Quest(L["QUESTDATA_QUESTNAME_JULIA_STEVENS"],                           31693,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Julia_Stevens))), -- [5]
            Quest(L["QUESTDATA_QUESTNAME_ANALYNN"],                                 31854,  QuestTypes.daily,   Factions.horde,     QuestGiverTable(HordeQuestGiver(QuestGivers.Analynn))), -- [6]
            Quest(L["QUESTDATA_QUESTNAME_BILL_BUCKLER"],                            31851,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Bill_Buckler))), -- [7]
            Quest(L["QUESTDATA_QUESTNAME_TRAITOR_GLUK"],                            31871,  QuestTypes.daily,   Factions.horde,     QuestGiverTable(HordeQuestGiver(QuestGivers.Traitor_Gluk))), -- [8]
            Quest(L["QUESTDATA_QUESTNAME_ERIC_DAVIDSON"],                           31850,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Eric_Davidson))), -- [9]
            Quest(L["QUESTDATA_QUESTNAME_CASSANDRA_KABOOM"],                        31904,  QuestTypes.daily,   Factions.horde,     QuestGiverTable(HordeQuestGiver(QuestGivers.Cassandra_Kaboom))), -- [10]
            Quest(L["QUESTDATA_QUESTNAME_KORTAS_DARKHAMMER"],                       31912,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Kortas_Darkhammer))), -- [11]
            Quest(L["QUESTDATA_QUESTNAME_DURIN_DARKHAMMER"],                        31914,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Durin_Darkhammer))), -- [12]
            Quest(L["QUESTDATA_QUESTNAME_KELA_GRIMTOTEM"],                          31906,  QuestTypes.daily,   Factions.horde,     QuestGiverTable(HordeQuestGiver(QuestGivers.Kela_Grimtotem))), -- [13]
            Quest(L["QUESTDATA_QUESTNAME_ELENA_FLUTTERFLY"],                        31908,  QuestTypes.daily,   Factions.horde,     QuestGiverTable(HordeQuestGiver(QuestGivers.Elena_Flutterfly))), -- [14]
            Quest(L["QUESTDATA_QUESTNAME_LINDSAY"],                                 31781,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Lindsay))), -- [15]
            Quest(L["QUESTDATA_QUESTNAME_GRAND_MASTER_LYDIA_ACCOSTE"],              31916,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Lydia_Accoste)),                                                      ItemReward(89125, 1)), -- [16]
            Quest(L["QUESTDATA_QUESTNAME_GRAZZLE_THE_GREAT"],                       31905,  QuestTypes.daily,   Factions.horde,     QuestGiverTable(HordeQuestGiver(QuestGivers.Grazzle_the_Great))), -- [17]
            Quest(L["QUESTDATA_QUESTNAME_OLD_MACDONALD"],                           31780,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Old_MacDonald))), -- [18]
            Quest(L["QUESTDATA_QUESTNAME_ZOLTAN"],                                  31907,  QuestTypes.daily,   Factions.horde,     QuestGiverTable(HordeQuestGiver(QuestGivers.Zoltan))), -- [19]
            Quest(L["QUESTDATA_QUESTNAME_ZUNTA"],                                   31818,  QuestTypes.daily,   Factions.horde,     QuestGiverTable(HordeQuestGiver(QuestGivers.Zunta))), -- [20]
            Quest(L["QUESTDATA_QUESTNAME_DAVID_KOSSE"],                             31910,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.David_Kosse))), -- [21]
            Quest(L["QUESTDATA_QUESTNAME_MERDA_STRONGHOOF"],                        31872,  QuestTypes.daily,   Factions.horde,     QuestGiverTable(HordeQuestGiver(QuestGivers.Merda_Stronghoof))), -- [22]
            Quest(L["QUESTDATA_QUESTNAME_STEVEN_LISBANE"],                          31852,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Steven_Lisbane))), -- [23]
            Quest(L["QUESTDATA_QUESTNAME_ZONYA_THE_SADIST"],                        31862,  QuestTypes.daily,   Factions.horde,     QuestGiverTable(HordeQuestGiver(QuestGivers.Zonya_the_Sadist))), -- [24]
            Quest(L["QUESTDATA_QUESTNAME_EVERESSA"],                                31913,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Everessa))), -- [25]
            Quest(L["QUESTDATA_QUESTNAME_DEIZA_PLAGUEHORN"],                        31911,  QuestTypes.daily,   Factions.neutral,   QuestGiverTable(NeutralQuestGiver(QuestGivers.Deiza_Plaguehorn))), -- [26]
        }
    }
};
