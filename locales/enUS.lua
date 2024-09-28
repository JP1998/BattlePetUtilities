
local name, app = ...;
app.L = {
    ["TITLE"] = "|cFFD13653Battle Pet Utilities|r";
    ["HELP"] = "Use '/bpu' with following arguments:\n - none or 'main': shows or hides the quest tracker window\n - 'options': shows the settings for the addon\n - 'help': shows this help";
    ["HELP_ADVANCED"] = "Use '/bpu' with following arguments:\n - none or 'main': shows or hides the quest tracker window\n - 'options': shows the settings for the addon\n - 'help': shows this help\n - 'debug': toggles the debug flag\n    This shows debug messages in chat and gives access to following commands:\n - 'dump': Dumps the full addon state in the chat\n    (this is a buttload, so use at own risk)";
    ["ERROR_UNKNOWN_COMMAND"] = "Unknown command: '%s'. Type '/bpu help' for some help.";
    ["MESSAGE_GENERAL_DUMP"] = "Here's a dump of the current addon's state:\n%s";
    ["MESSAGE_DEBUG_TOGGLE"] = "Toggled debug state. Current value: %s";
    ["MESSAGE_DEBUG_DISABLED"] = "This command is only usable with debug mode on.";
    ["MESSAGE_DEBUG_GREETING"] = "You have debug mode enabled. To disable type '/bpu debug' into chat.";

    --[[
        Settings Strings
    ]]

    -- Item Mailer Options Strings
    ["OPTIONS_MAILER_HEADER"] = "Items Mailer";
    ["OPTIONS_MAILER_DESCRIPTION"] = "If enabled, this feature will send battle pet related items to a character, every time you open the mail window. It will send only items you define to be sent to a character defined by you. Since you can only send mail to characters on your server, this setting is stored for each server separately.\n\nThis feature is not functional and (most likely) never will be. This is the result of a WeakAuras limitation, which I kind of agree with, even. Considering the code itself is working (with the exception of the actual sending of the mail) you can make a macro, which sends the mail to your specified character and use this WA to put all the items into the mail. Therefor you'll need to set the `DISABLED` flag in the custom trigger of \"Pet Items Auto Mailer\" to false.\n\nSaid macro would look like this `/run SendMail(\"<char name>\", \"Your Pet Battle Item Package\", \"\");`";
    ["OPTIONS_MAILER_ENABLED_DESCRIPTION"] = "Enable Items Mailer";
    ["OPTIONS_MAILER_CHARACTER_DESCRIPTION"] = "Character:";
    ["OPTIONS_MAILER_USEWARBANK_DESCRIPTION"] = "Use the warband bank instead of mailing items.";
    ["OPTIONS_MAILER_WARBANKTAB_DESCRIPTION"] = "Warbank tab to use:";
    ["OPTIONS_MAILER_ITEMS_HEADER"] = "Items To Mail";

    -- World Quest Tracker Options Strings
    ["OPTIONS_WORLDQUESTTRACKER_HEADER"] = "Quest Tracker";
    ["OPTIONS_WORLDQUESTTRACKER_SHOW_NO_ITEM"] = "Show Quests with no item reward";
    ["OPTIONS_WORLDQUESTTRACKER_SHOW_UNKNOWN_ITEM"] = "Show Quests with item rewards that are not recognized";
    ["OPTIONS_WORLDQUESTTRACKER_PRINT_UNKNOWN_ITEM"] = "Print item rewards that are not recognized";
    ["OPTIONS_WORLDQUESTTRACKER_ITEMS_HEADER"] = "Items To Track";

    -- Squirt Day Helper Options Strings
    ["OPTIONS_SQUIRTDAYHELPER_HEADER"] = "Squirt Day Helper";
    ["OPTIONS_SQUIRTDAYHELPER_ENABLED_DESCRIPTION"] = "Enable Squirt Day Helper";

    -- Item descriptions
    ["OPTIONS_ITEM_GENERAL_HEADER"] = "General Battle Pet Items";
    ["OPTIONS_ITEM_BATTLE_PET_BANDAGE"] = "Battle Pet Bandage";
    ["OPTIONS_ITEM_PETCHARMS_HEADER"] = "Pet Charms";
    ["OPTIONS_ITEM_POLISHED_PET_CHARM"] = "Polished Pet Charm";
    ["OPTIONS_ITEM_SHINY_PET_CHARM"] = "Shiny Pet Charm";
    ["OPTIONS_ITEM_GENERAL_BATTLESTONES_HEADER"] = "General Battle-Stones";
    ["OPTIONS_ITEM_ULTIMATE_BATTLE_TRAINING_STONE"] = "Ultimate Battle-Training Stone";
    ["OPTIONS_ITEM_MARKED_FLAWLESS_BATTLE_STONE"] = "Marked Flawless Battle-Stone";
    ["OPTIONS_ITEM_FELTOUCHED_BATTLE_TRAINING_STONE"] = "Fel-Touched Battle-Training Stone";
    ["OPTIONS_ITEM_FLAWLESS_BATTLE_TRAINING_STONE"] = "Flawless Battle-Training Stone";
    ["OPTIONS_ITEM_FAMILY_BATTLESTONES_HEADER"] = "Family Battle-Stones";
    ["OPTIONS_ITEM_BTS_BEAST"] = "Beast Battle-Training Stone";
    ["OPTIONS_ITEM_FBS_BEAST"] = "Flawless Beast Battle-Stone";
    ["OPTIONS_ITEM_BTS_HUMANOID"] = "Humanoid Battle-Training Stone";
    ["OPTIONS_ITEM_FBS_HUMANOID"] = "Flawless Humanoid Battle-Stone";
    ["OPTIONS_ITEM_BTS_MECHANICAL"] = "Mechanical Battle-Training Stone";
    ["OPTIONS_ITEM_FBS_MECHANICAL"] = "Flawless Mechanical Battle-Stone";
    ["OPTIONS_ITEM_BTS_CRITTER"] = "Critter Battle-Training Stone";
    ["OPTIONS_ITEM_FBS_CRITTER"] = "Flawless Critter Battle-Stone";
    ["OPTIONS_ITEM_BTS_DRAGONKIN"] = "Dragonkin Battle-Training Stone";
    ["OPTIONS_ITEM_FBS_DRAGONKIN"] = "Flawless Dragonkin Battle-Stone";
    ["OPTIONS_ITEM_BTS_ELEMENTAL"] = "Elemental Battle-Training Stone";
    ["OPTIONS_ITEM_FBS_ELEMENTAL"] = "Flawless Elemental Battle-Stone";
    ["OPTIONS_ITEM_BTS_FLYING"] = "Flying Battle-Training Stone";
    ["OPTIONS_ITEM_FBS_FLYING"] = "Flawless Flying Battle-Stone";
    ["OPTIONS_ITEM_BTS_MAGIC"] = "Magic Battle-Training Stone";
    ["OPTIONS_ITEM_FBS_MAGIC"] = "Flawless Magic Battle-Stone";
    ["OPTIONS_ITEM_BTS_UNDEAD"] = "Undead Battle-Training Stone";
    ["OPTIONS_ITEM_FBS_UNDEAD"] = "Flawless Undead Battle-Stone";
    ["OPTIONS_ITEM_BTS_AQUATIC"] = "Aquatic Battle-Training Stone";
    ["OPTIONS_ITEM_FBS_AQUATIC"] = "Flawless Aquatic Battle-Stone";
    ["OPTIONS_ITEM_DUNGEON_REWARDS_HEADER"] = "Battle Pet Dungeon Rewards";
    ["OPTIONS_ITEM_CELESTIAL_COIN"] = "Celestial Coins";
    ["OPTIONS_ITEM_OLD_BOTTLE_CAP"] = "Old Bottle Cap";
    ["OPTIONS_ITEM_PRISTINE_GIZMO"] = "Pristine Gizmo";
    ["OPTIONS_ITEM_CLEANSED_REMAINS"] = "Cleansed Remains";
    ["OPTIONS_ITEM_SHADOWY_GEMS"] = "Shadowy Gems";
    ["OPTIONS_ITEM_DAMP_PET_SUPPLIES"] = "Damp Pet Supplies";
    ["OPTIONS_ITEM_PETSUPPLIES_HEADER"] = "Pet Supply Bags";
    ["OPTIONS_ITEM_GREATER_DARKMOON_PET_SUPPLIES"] = "Greater Darkmoon Pet Supplies";
    ["OPTIONS_ITEM_DARKMOON_PET_SUPPLIES"] = "Darkmoon Pet Supplies";
    ["OPTIONS_ITEM_PSPS_BURNING"] = "Pandaren Spirit Pet Supplies (Burning)";
    ["OPTIONS_ITEM_PSPS_FLOWING"] = "Pandaren Spirit Pet Supplies (Flowing)";
    ["OPTIONS_ITEM_PSPS_WHISPERING"] = "Pandaren Spirit Pet Supplies (Whispering)";
    ["OPTIONS_ITEM_PSPS_THUNDERING"] = "Pandaren Spirit Pet Supplies (Thundering)";
    ["OPTIONS_ITEM_SACK_OF_PET_SUPPLIES"] = "Sack of Pet Supplies";
    ["OPTIONS_ITEM_BIG_BAG_OF_PET_SUPPLIES"] = "Big Bag of Pet Supplies";
    ["OPTIONS_ITEM_TRAVELERS_PET_SUPPLIES"] = "Traveler's Pet Supplies";
    ["OPTIONS_ITEM_LEPROUS_SACK_OF_PET_SUPPLIES"] = "Leprous Sack of Pet Supplies";
    ["OPTIONS_ITEM_TORN_SACK_OF_PET_SUPPLIES"] = "Torn Sack of Pet Supplies";
    ["OPTIONS_ITEM_FABLED_PANDAREN_PET_SUPPLIES"] = "Fabled Pandaren Pet Supplies";
    ["OPTIONS_ITEM_GRUMMLEPOUCH"] = "Grummlepouch";

    --[[
        Quest Data Strings
    ]]

    -- Quest Givers
    ["QUESTDATA_QUESTGIVERS_MASTER_LI"] = "Master Li";
    ["QUESTDATA_QUESTGIVERS_MUYANI"] = "Muyani";
    ["QUESTDATA_QUESTGIVERS_MARCUS_BAGMAN_BROWN"] = "Marcus \"Bagman\" Brown";
    ["QUESTDATA_QUESTGIVERS_MICRO_ZOOX"] = "Micro Zoox";
    ["QUESTDATA_QUESTGIVERS_SEAN_WILKERS"] = "Sean Wilkers";
    ["QUESTDATA_QUESTGIVERS_JEREMY_FEASEL"] = "Jeremy Feasel";
    ["QUESTDATA_QUESTGIVERS_CHRISTOPH_VONFEASEL"] = "Christoph VonFeasel";
    ["QUESTDATA_QUESTGIVERS_SHIPWRECKED_CAPTIVE"] = "Shipwrecked Captive";
    ["QUESTDATA_QUESTGIVERS_SERRAH"] = "Serr'ah";
    ["QUESTDATA_QUESTGIVERS_LIO_THE_LIONESS"] = "Lio the Lioness";
    ["QUESTDATA_QUESTGIVERS_KURA_THUNDERHOOF"] = "Kura Thunderhoof";
    ["QUESTDATA_QUESTGIVERS_ERRIS_THE_COLLECTOR"] = "Erris the Collector";
    ["QUESTDATA_QUESTGIVERS_CYMRE_BRIGHTBLADE"] = "Cymre Brightblade";
    ["QUESTDATA_QUESTGIVERS_TARALUNE"] = "Taralune";
    ["QUESTDATA_QUESTGIVERS_VESHARR"] = "Vesharr";
    ["QUESTDATA_QUESTGIVERS_ASHLEI"] = "Ashlei";
    ["QUESTDATA_QUESTGIVERS_TARR_THE_TERRIBLE"] = "Tarr the Terrible";
    ["QUESTDATA_QUESTGIVERS_GARGRA"] = "Gargra";
    ["QUESTDATA_QUESTGIVERS_GENTLE_SAN"] = "Gentle San";
    ["QUESTDATA_QUESTGIVERS_SARA_FINKLESWITCH"] = "Sara Finkleswitch";
    ["QUESTDATA_QUESTGIVERS_AKI_THE_CHOSEN"] = "Aki the Chosen";
    ["QUESTDATA_QUESTGIVERS_HYUNA_OF_THE_SHRINES"] = "Hyuna of the Shrines";
    ["QUESTDATA_QUESTGIVERS_MORUK"] = "Mo'ruk";
    ["QUESTDATA_QUESTGIVERS_WASTEWALKER_SHU"] = "Wastewalker Shu";
    ["QUESTDATA_QUESTGIVERS_FARMER_NISHI"] = "Farmer Nishi";
    ["QUESTDATA_QUESTGIVERS_SEEKER_ZUSSHI"] = "Seeker Zusshi";
    ["QUESTDATA_QUESTGIVERS_COURAGEOUS_YON"] = "Courageous Yon";
    ["QUESTDATA_QUESTGIVERS_THUNDERING_PANDAREN_SPIRIT"] = "Thundering Pandaren Spirit";
    ["QUESTDATA_QUESTGIVERS_BURNING_PANDAREN_SPIRIT"] = "Burning Pandaren Spirit";
    ["QUESTDATA_QUESTGIVERS_WHISPERING_PANDAREN_SPIRIT"] = "Whispering Pandaren Spirit";
    ["QUESTDATA_QUESTGIVERS_FLOWING_PANDAREN_SPIRIT"] = "Flowing Pandaren Spirit";
    ["QUESTDATA_QUESTGIVERS_LITTLE_TOMMY_NEWCOMER"] = "Little Tommy Newcomer";
    ["QUESTDATA_QUESTGIVERS_BROK"] = "Brok";
    ["QUESTDATA_QUESTGIVERS_BORDIN_STEADYFIST"] = "Bordin Steadyfist";
    ["QUESTDATA_QUESTGIVERS_OBALIS"] = "Obalis";
    ["QUESTDATA_QUESTGIVERS_GOZ_BANEFURY"] = "Goz Banefury";
    ["QUESTDATA_QUESTGIVERS_NEARLY_HEADLESS_JACOB"] = "Nearly Headless Jacob";
    ["QUESTDATA_QUESTGIVERS_OKRUT_DRAGONWASTE"] = "Okrut Dragonwaste";
    ["QUESTDATA_QUESTGIVERS_GUTRETCH"] = "Gutretch";
    ["QUESTDATA_QUESTGIVERS_MAJOR_PAYNE"] = "Major Payne";
    ["QUESTDATA_QUESTGIVERS_BEEGLE_BLASTFUSE"] = "Beegle Blastfuse";
    ["QUESTDATA_QUESTGIVERS_MORULU_THE_ELDER"] = "Morulu The Elder";
    ["QUESTDATA_QUESTGIVERS_BLOODKNIGHT_ANTARI"] = "Bloodknight Antari";
    ["QUESTDATA_QUESTGIVERS_NICKI_TINYTECH"] = "Nicki Tinytech";
    ["QUESTDATA_QUESTGIVERS_RASAN"] = "Ras'an";
    ["QUESTDATA_QUESTGIVERS_NARROK"] = "Narrok";
    ["QUESTDATA_QUESTGIVERS_ENVIRONEER_BERT"] = "Environeer Bert";
    ["QUESTDATA_QUESTGIVERS_CRYSA"] = "Crysa";
    ["QUESTDATA_QUESTGIVERS_STONE_COLD_TRIXXY"] = "Stone Cold Trixxy";
    ["QUESTDATA_QUESTGIVERS_DAGRA_THE_FIERCE"] = "Dagra the Fierce";
    ["QUESTDATA_QUESTGIVERS_JULIA_STEVENS"] = "Julia Stevens";
    ["QUESTDATA_QUESTGIVERS_ANALYNN"] = "Analynn";
    ["QUESTDATA_QUESTGIVERS_BILL_BUCKLER"] = "Bill Buckler";
    ["QUESTDATA_QUESTGIVERS_TRAITOR_GLUK"] = "Traitor Gluk";
    ["QUESTDATA_QUESTGIVERS_ERIC_DAVIDSON"] = "Eric Davidson";
    ["QUESTDATA_QUESTGIVERS_CASSANDRA_KABOOM"] = "Cassandra Kaboom";
    ["QUESTDATA_QUESTGIVERS_KORTAS_DARKHAMMER"] = "Kortas Darkhammer";
    ["QUESTDATA_QUESTGIVERS_DURIN_DARKHAMMER"] = "Durin Darkhammer";
    ["QUESTDATA_QUESTGIVERS_KELA_GRIMTOTEM"] = "Kela Grimtotem";
    ["QUESTDATA_QUESTGIVERS_ELENA_FLUTTERFLY"] = "Elena Flutterfly";
    ["QUESTDATA_QUESTGIVERS_LYDIA_ACCOSTE"] = "Lydia Accoste";
    ["QUESTDATA_QUESTGIVERS_GRAZZLE_THE_GREAT"] = "Grazzle the Great";
    ["QUESTDATA_QUESTGIVERS_OLD_MACDONALD"] = "Old MacDonald";
    ["QUESTDATA_QUESTGIVERS_ZOLTAN"] = "Zoltan";
    ["QUESTDATA_QUESTGIVERS_ZUNTA"] = "Zunta";
    ["QUESTDATA_QUESTGIVERS_DAVID_KOSSE"] = "David Kosse";
    ["QUESTDATA_QUESTGIVERS_MERDA_STRONGHOOF"] = "Merda Stronghoof";
    ["QUESTDATA_QUESTGIVERS_STEVEN_LISBANE"] = "Steven Lisbane";
    ["QUESTDATA_QUESTGIVERS_ZONYA_THE_SADIST"] = "Zonya the Sadist";
    ["QUESTDATA_QUESTGIVERS_EVERESSA"] = "Everessa";
    ["QUESTDATA_QUESTGIVERS_DEIZA_PLAGUEHORN"] = "Deiza Plaguehorn";
    ["QUESTDATA_QUESTGIVERS_LINDSAY"] = "Lindsay";
    ["QUESTDATA_QUESTGIVERS_ANTHEA"] = "Anthea";
    ["QUESTDATA_QUESTGIVERS_BURT_MACKLYN"] = "Burt Macklyn";

    -- Quest Names
    ["QUESTDATA_QUESTNAME_THE_CELESTIAL_TOURNAMENT"] = "The Celestial Tournament";
    ["QUESTDATA_QUESTNAME_PET_BATTLE_CHALLENGE_WAILING_CAVERNS"] = "Pet Battle Challenge: Wailing Caverns";
    ["QUESTDATA_QUESTNAME_PET_BATTLE_CHALLENGE_DEADMINES"] = "Pet Battle Challenge: Deadmines";
    ["QUESTDATA_QUESTNAME_PET_BATTLE_CHALLENGE_BLACKROCK_DEPTHS"] = "Pet Battle Challenge: Blackrock Depths";
    ["QUESTDATA_QUESTNAME_PET_BATTLE_CHALLENGE_GNOMEREGAN"] = "Pet Battle Challenge: Gnomeregan";
    ["QUESTDATA_QUESTNAME_PET_BATTLE_CHALLENGE_STRATHOLME"] = "Pet Battle Challenge: Stratholme";
    ["QUESTDATA_QUESTNAME_DARKMOON_PET_BATTLE"] = "Darkmoon Pet Battle!";
    ["QUESTDATA_QUESTNAME_A_NEW_DARKMOON_CHALLENGER"] = "A New Darkmoon Challenger!";
    ["QUESTDATA_QUESTNAME_SHIPWRECKED_CAPTIVE"] = "Shipwrecked Captive";
    ["QUESTDATA_QUESTNAME_BATTLE_PET_TAMERS_WARLORDS"] = "Battle Pet Tamers: Warlords";
    ["QUESTDATA_QUESTNAME_MASTERING_THE_MENAGERIE"] = "Mastering the Menagerie";
    ["QUESTDATA_QUESTNAME_CRITTERS_OF_DRAENOR"] = "Critters of Draenor";
    ["QUESTDATA_QUESTNAME_BATTLE_PET_ROUNDUP"] = "Battle Pet Roundup";
    ["QUESTDATA_QUESTNAME_SCRAPPIN"] = "Scrappin'";
    ["QUESTDATA_QUESTNAME_CYMRE_BRIGHTBLADE"] = "Cymre Brightblade";
    ["QUESTDATA_QUESTNAME_TARALUNE"] = "Taralune";
    ["QUESTDATA_QUESTNAME_VESHARR"] = "Vesharr";
    ["QUESTDATA_QUESTNAME_ASHLEI"] = "Ashlei";
    ["QUESTDATA_QUESTNAME_TARR_THE_TERRIBLE"] = "Tarr the Terrible";
    ["QUESTDATA_QUESTNAME_GARGRA"] = "Gargra";
    ["QUESTDATA_QUESTNAME_BEASTS_OF_FABLE_BOOK_I"] = "Beasts of Fable Book I";
    ["QUESTDATA_QUESTNAME_BEASTS_OF_FABLE_BOOK_II"] = "Beasts of Fable Book II";
    ["QUESTDATA_QUESTNAME_BEASTS_OF_FABLE_BOOK_III"] = "Beasts of Fable Book III";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_AKI"] = "Grand Master Aki";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_HYUNA"] = "Grand Master Hyuna";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_MORUK"] = "Grand Master Mo'ruk";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_SHU"] = "Grand Master Shu";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_NISHI"] = "Grand Master Nishi";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_ZUSSHI"] = "Grand Master Zusshi";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_YON"] = "Grand Master Yon";
    ["QUESTDATA_QUESTNAME_THUNDERING_PANDAREN_SPIRIT"] = "Thundering Pandaren Spirit";
    ["QUESTDATA_QUESTNAME_BURNING_PANDAREN_SPIRIT"] = "Burning Pandaren Spirit";
    ["QUESTDATA_QUESTNAME_WHISPERING_PANDAREN_SPIRIT"] = "Whispering Pandaren Spirit";
    ["QUESTDATA_QUESTNAME_FLOWING_PANDAREN_SPIRIT"] = "Flowing Pandaren Spirit";
    ["QUESTDATA_QUESTNAME_LITTLE_TOMMY_NEWCOMER"] = "Little Tommy Newcomer";
    ["QUESTDATA_QUESTNAME_BROK"] = "Brok";
    ["QUESTDATA_QUESTNAME_BORDIN_STEADYFIST"] = "Bordin Steadyfist";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_OBALIS"] = "Grand Master Obalis";
    ["QUESTDATA_QUESTNAME_GOZ_BANEFURY"] = "Goz Banefury";
    ["QUESTDATA_QUESTNAME_NEARLY_HEADLESS_JACOB"] = "Nearly Headless Jacob";
    ["QUESTDATA_QUESTNAME_OKRUT_DRAGONWASTE"] = "Okrut Dragonwaste";
    ["QUESTDATA_QUESTNAME_GUTRETCH"] = "Gutretch";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_PAYNE"] = "Grand Master Payne";
    ["QUESTDATA_QUESTNAME_BEEGLE_BLASTFUSE"] = "Beegle Blastfuse";
    ["QUESTDATA_QUESTNAME_MORULU_THE_ELDER"] = "Morulu The Elder";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_ANTARI"] = "Grand Master Antari";
    ["QUESTDATA_QUESTNAME_NICKI_TINYTECH"] = "Nicki Tinytech";
    ["QUESTDATA_QUESTNAME_RASAN"] = "Ras'an";
    ["QUESTDATA_QUESTNAME_NARROK"] = "Narrok";
    ["QUESTDATA_QUESTNAME_BERTS_BOTS"] = "Bert's Bots";
    ["QUESTDATA_QUESTNAME_CRYSAS_FLYERS"] = "Crysa's Flyers";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_TRIXXY"] = "Grand Master Trixxy";
    ["QUESTDATA_QUESTNAME_DAGRA_THE_FIERCE"] = "Dagra the Fierce";
    ["QUESTDATA_QUESTNAME_JULIA_STEVENS"] = "Julia Stevens";
    ["QUESTDATA_QUESTNAME_ANALYNN"] = "Analynn";
    ["QUESTDATA_QUESTNAME_BILL_BUCKLER"] = "Bill Buckler";
    ["QUESTDATA_QUESTNAME_TRAITOR_GLUK"] = "Traitor Gluk";
    ["QUESTDATA_QUESTNAME_ERIC_DAVIDSON"] = "Eric Davidson";
    ["QUESTDATA_QUESTNAME_CASSANDRA_KABOOM"] = "Cassandra Kaboom";
    ["QUESTDATA_QUESTNAME_KORTAS_DARKHAMMER"] = "Kortas Darkhammer";
    ["QUESTDATA_QUESTNAME_DURIN_DARKHAMMER"] = "Durin Darkhammer";
    ["QUESTDATA_QUESTNAME_KELA_GRIMTOTEM"] = "Kela Grimtotem";
    ["QUESTDATA_QUESTNAME_ELENA_FLUTTERFLY"] = "Elena Flutterfly";
    ["QUESTDATA_QUESTNAME_LINDSAY"] = "Lindsay";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_LYDIA_ACCOSTE"] = "Grand Master Lydia Accoste";
    ["QUESTDATA_QUESTNAME_GRAZZLE_THE_GREAT"] = "Grazzle the Great";
    ["QUESTDATA_QUESTNAME_OLD_MACDONALD"] = "Old MacDonald";
    ["QUESTDATA_QUESTNAME_ZOLTAN"] = "Zoltan";
    ["QUESTDATA_QUESTNAME_ZUNTA"] = "Zunta";
    ["QUESTDATA_QUESTNAME_DAVID_KOSSE"] = "David Kosse";
    ["QUESTDATA_QUESTNAME_MERDA_STRONGHOOF"] = "Merda Stronghoof";
    ["QUESTDATA_QUESTNAME_STEVEN_LISBANE"] = "Steven Lisbane";
    ["QUESTDATA_QUESTNAME_ZONYA_THE_SADIST"] = "Zonya the Sadist";
    ["QUESTDATA_QUESTNAME_EVERESSA"] = "Everessa";
    ["QUESTDATA_QUESTNAME_DEIZA_PLAGUEHORN"] = "Deiza Plaguehorn";
    ["QUESTDATA_QUESTNAME_TEMPLE_THROWDOWN"] = "Temple Throwdown";

    --[[
        Feature Strings
    ]]

    -- Item Mailer Strings
    ["MAILER_SUBJECT"] = "Your Battle Pet Care Package has arrived!";
    ["MAILER_BODY"] = "I hope you will enjoy it. :)";
    ["MAILER_SENT"] = "We sent your items away. %s/%s";
    ["MAILER_ABORT"] = "We had to abort sending your items.";
    ["MAILER_BROKE"] = "We couldn't send your mail, because you can't pay the postage.";
    ["MAILER_CHARACTERNOTSET"] = "You did not specify which character to send your items to. Use /bpu options to open the options and configure in your battle pet character.";
    ["MAILER_WARBANKFULL"] = "Your configured battle pet warbank tab is full. Please clear some space for additional items or change the used tab.";
    ["MAILER_WARBANKNOTSET"] = "You have not set which warbank tab you would like to deposit your battle pet items to. You can use /bpu options to open the option panel and configure it.";

    -- World Quest Tracker Strings
    ["WORLDQUESTTRACKER_UNKNOWNITEM"] = "We found a world quest with an unknown item reward: %s.";
    ["WORLDQUESTTRACKER_DEFAULT_ICON"] = "Interface\\Icons\\PetJournalPortrait";
    ["WORLDQUESTTRACKER_ROOT_ICON"] = "Interface\\Icons\\Inv_Pet_Frostwolfpup";
    ["WORLDQUESTTRACKER_FACTION_ICON"] = "|TInterface\\FriendsFrame\\PlusManz-%s:0|t %s";
    ["WORLDQUESTTRACKER_WORLDQUEST_TITLE"] = "World Quests";
    ["WORLDQUESTTRACKER_WORLDQUEST_ICON"] = "Interface\\BUTTONS\\AdventureGuideMicrobuttonAlert";
    ["WORLDQUESTTRACKER_REPEATABLEQUEST_TITLE"] = "Repeatable Quests";
    ["WORLDQUESTTRACKER_REPEATABLEQUEST_ICON"] = "Interface\\GossipFrame\\DailyActiveQuestIcon";
    ["WORLDQUESTTRACKER_DUNGEONS_TITLE"] = "Battle Pet Dungeons";
    ["WORLDQUESTTRACKER_DUNGEONS_ICON"] = "Interface\\MINIMAP\\Dungeon";
    ["WORLDQUESTTRACKER_DARKMOONFAIRE_TITLE"] = "Darkmoon Faire";
    ["WORLDQUESTTRACKER_DARKMOONFAIRE_ICON"] = "Interface\\ICONS\\INV_MISC_Cape_DarkmoonFaire_C_01";
    ["WORLDQUESTTRACKER_SHADOWLANDS_TITLE"] = "Shadowlands";
    ["WORLDQUESTTRACKER_SHADOWLANDS_ICON"] = "assets\\expansion-9-shadowlands";
    ["WORLDQUESTTRACKER_BATTLEFORAZEROTH_TITLE"] = "Battle for Azeroth";
    ["WORLDQUESTTRACKER_BATTLEFORAZEROTH_ICON"] = "assets\\expansion-8-battleforazeroth";
    ["WORLDQUESTTRACKER_LEGION_TITLE"] = "Legion";
    ["WORLDQUESTTRACKER_LEGION_ICON"] = "assets\\expansion-7-legion";
    ["WORLDQUESTTRACKER_WARLORDSOFDRAENOR_TITLE"] = "Warlords of Draenor";
    ["WORLDQUESTTRACKER_WARLORDSOFDRAENOR_ICON"] = "assets\\expansion-6-warlordsofdraenor";
    ["WORLDQUESTTRACKER_MISTSOFPANDARIA_TITLE"] = "Mists of Pandaria";
    ["WORLDQUESTTRACKER_MISTSOFPANDARIA_ICON"] = "assets\\expansion-5-mistsofpandaria";
    ["WORLDQUESTTRACKER_CATACLYSM_TITLE"] = "Cataclysm";
    ["WORLDQUESTTRACKER_CATACLYSM_ICON"] = "assets\\expansion-4-cataclysm";
    ["WORLDQUESTTRACKER_WRATHOFTHELICHKING_TITLE"] = "Wrath of the Lich King";
    ["WORLDQUESTTRACKER_WRATHOFTHELICHKING_ICON"] = "assets\\expansion-3-wrathofthelichking";
    ["WORLDQUESTTRACKER_THEBURNINGCRUSADE_TITLE"] = "The Burning Crusade";
    ["WORLDQUESTTRACKER_THEBURNINGCRUSADE_ICON"] = "assets\\expansion-2-theburningcrusade";
    ["WORLDQUESTTRACKER_CLASSIC_TITLE"] = "Classic";
    ["WORLDQUESTTRACKER_CLASSIC_ICON"] = "assets\\expansion-1-classic";

    -- Squirt Day Helper Strings
    ["SDH_SUPER_SQUIRT_DAY"] = "|c%s|c%sToday|r is SUPER SQUIRT DAY!!!|r";
    ["SDH_SQUIRT_DAY"] = "|c%s|c%sToday|r is squirt day!|r";
    ["SDH_NEXT_SQUIRT"] = "|c%sNext squirt day is on |c%s{weekday}, {day}. {month}|r.|r";
    ["SDH_NOT_SUPPORTED"] = "|c%sYour region is sadly not supported.|r";
    ["SDH_PET_TREAT"] = "You're missing the %s buff!";
    ["SDH_PET_HAT"] = "Put on your hat!!";
    ["SDH_STATISTICS"] = "Squirt Day Helper: So far you have levelled {pets} pets in {battles} battles.";

    -- Date Strings
    ["WEEKDAY_2"] = "Monday";
    ["WEEKDAY_3"] = "Tuesday";
    ["WEEKDAY_4"] = "Wednesday";
    ["WEEKDAY_5"] = "Thursday";
    ["WEEKDAY_6"] = "Friday";
    ["WEEKDAY_7"] = "Saturday";
    ["WEEKDAY_1"] = "Sunday";
    ["MONTH_1"] = "January";
    ["MONTH_2"] = "February";
    ["MONTH_3"] = "March";
    ["MONTH_4"] = "April";
    ["MONTH_5"] = "May";
    ["MONTH_6"] = "June";
    ["MONTH_7"] = "July";
    ["MONTH_8"] = "August";
    ["MONTH_9"] = "September";
    ["MONTH_10"] = "October";
    ["MONTH_11"] = "November";
    ["MONTH_12"] = "December";
};
