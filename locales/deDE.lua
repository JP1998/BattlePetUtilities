

if GetLocale() ~= "deDE" then
    return;
end

local _, app = ...;
local L = app.L;

for key, value in pairs({
    -- ["TITLE"] = "|cFFD13653Battle Pet Utilities|r";
    ["HELP"] = "Du kannst '/bpu' mit folgenden Argumenten benutzen:\n - keines oder 'main': Zeigt oder schließt das Quest Tracker Fenster\n - 'options': Zeigt die Einstellungen des Addons\n - 'help': Zeigt diese Hilfe-Nachricht";
    ["HELP_ADVANCED"] = "Du kannst '/bpu' mit folgenden Argumenten benutzen:\n - keines oder 'main': Zeigt oder schließt das Quest Tracker Fenster\n - 'options': Zeigt die Einstellungen des Addons\n - 'help': Zeigt diese Hilfe-Nachricht\n - 'debug': Toggelt das Debug-Flag\n     Dies zeigt Debug-Nachrichten im Chat und gibt Zugang zu folgenden Befehlen:\n - 'dump': Zeigt den kompletten Addon-Zutand im Chat an\n    (das ist eine ganze Menge, daher Benutzung auf eigene Gefahr)";
    ["ERROR_UNKNOWN_COMMAND"] = "Unbekannter Befehl: '%s'. Gib '/bpu help' ein, um die Hilfe anzuzeigen.";
    ["MESSAGE_GENERAL_DUMP"] = "Hier ist ein Dump von dem Zustand des Addons:\n%s";
    ["MESSAGE_DEBUG_TOGGLE"] = "Debug-Modus wurde getoggelt. Derzeitiger Wert: %s";
    ["MESSAGE_DEBUG_DISABLED"] = "Dieser Befehl kann nur genutzt werden, wenn der Debug-Modus eingestellt ist.";
    ["MESSAGE_DEBUG_GREETING"] = "Sie haben den Debug-Modus aktiv. Um ihn auszuschalten, geben Sie '/bpu debug' in Ihren Chat ein.";

    --[[
        Settings Strings
    ]]

    -- Item Mailer Options Strings
    ["OPTIONS_MAILER_HEADER"] = "Artikel-Mailer";
    ["OPTIONS_MAILER_DESCRIPTION"] = "Wenn aktiviert, wird diese Funktion, jedes Mal wenn Sie das Postfach öffnen, Kampfhaustier-Artikel an einen Charakter senden. Es werden nur Artikel gesendet, welche Sie bestimmen, und an einen Charakter, den ebenfalls Sie bestimmen müssen. Da Sie Post nur an Charaktere auf Ihrem Server senden können, ist diese Einstellung für jeden Server separat gespeichert.\n\nDiese Funktion ist nicht funktional und wird es (mit hoher Wahrscheinlichkeit) auch niemals sein. Dies ist ein Resultat einer Limitation in WeakAuras, welcher ich sogar teilweise zustimmen muss. Da der Code (mit der Ausnahme des Absenden der Post) funktioniert, kann man sich ein Makro erstellen, welches die Post an Ihren bestimmten Charakter sendet, und diese WA nutzen um die Post mit den Artikeln zu befüllen. Hierzu müssen Sie das Kennzeichen `DISABLED` in dem benutzerdefinierten Auslöser \"Pet Items Auto Mailer\" auf false setzen.\n\nDas erwähnte Makro würde wie folgt aussehen: `/run SendMail(\"<char name>\", \"Your Pet Battle Item Package\", \"\");`";
    ["OPTIONS_MAILER_ENABLED_DESCRIPTION"] = "Aktiviere den Artikel-Mailer";
    ["OPTIONS_MAILER_CHARACTER_DESCRIPTION"] = "Charakter:";
    ["OPTIONS_MAILER_USEWARBANK_DESCRIPTION"] = "Nutze die Kriegsmeuten-Bank statt die Items per Post zu senden.";
    ["OPTIONS_MAILER_WARBANKTAB_DESCRIPTION"] = "Kriegsmeutenbank-Tab:";
    ["OPTIONS_MAILER_ITEMS_HEADER"] = "Artikel zu Versenden";

    -- World Quest Tracker Options Strings
    -- ["OPTIONS_WORLDQUESTTRACKER_HEADER"] = "Quest Tracker";
    ["OPTIONS_WORLDQUESTTRACKER_SHOW_NO_ITEM"] = "Zeige Quests ohne Artikel-Belohnung";
    ["OPTIONS_WORLDQUESTTRACKER_SHOW_UNKNOWN_ITEM"] = "Zeige Quests mit Artikel-Belohnungen, die dem Addon nicht bekannt sind";
    ["OPTIONS_WORLDQUESTTRACKER_PRINT_UNKNOWN_ITEM"] = "Zeige (dem Addon) unbekannte Artikel-Belohnungen an";
    ["OPTIONS_WORLDQUESTTRACKER_ITEMS_HEADER"] = "Artikel, die angezeigt werden sollen";

    -- Squirt Day Helper Options Strings
    ["OPTIONS_SQUIRTDAYHELPER_HEADER"] = "Squirt Day Helfer";
    ["OPTIONS_SQUIRTDAYHELPER_ENABLED_DESCRIPTION"] = "Aktiviere den Squirt Day Helfer";

    -- Item descriptions
    ["OPTIONS_ITEM_GENERAL_HEADER"] = "Allgemeine Kampfhaustier-Artikel";
    ["OPTIONS_ITEM_BATTLE_PET_BANDAGE"] = "Kampfhaustierbandage";
    ["OPTIONS_ITEM_PETCHARMS_HEADER"] = "Haustierglücksbringer";
    ["OPTIONS_ITEM_POLISHED_PET_CHARM"] = "Polierter Haustierglücksbringer";
    ["OPTIONS_ITEM_SHINY_PET_CHARM"] = "Glänzender Haustierglücksbringer";
    ["OPTIONS_ITEM_GENERAL_BATTLESTONES_HEADER"] = "Allgemeine Kampfsteine";
    ["OPTIONS_ITEM_ULTIMATE_BATTLE_TRAINING_STONE"] = "Ultimativer Kampfübungsstein";
    ["OPTIONS_ITEM_MARKED_FLAWLESS_BATTLE_STONE"] = "Gekennzeichneter Makelloser Kampfstein";
    ["OPTIONS_ITEM_FELTOUCHED_BATTLE_TRAINING_STONE"] = "Teufelsberührter Kampfübungsstein";
    ["OPTIONS_ITEM_FLAWLESS_BATTLE_TRAINING_STONE"] = "Makelloser Kampfübungsstein";
    ["OPTIONS_ITEM_FAMILY_BATTLESTONES_HEADER"] = "Kampfübungssteine für Haustierarten";
    ["OPTIONS_ITEM_BTS_BEAST"] = "Kampfübungsstein für Wildtiere";
    ["OPTIONS_ITEM_FBS_BEAST"] = "Makelloser Wildtierkampfstein";
    ["OPTIONS_ITEM_BTS_HUMANOID"] = "Kampfübungsstein für Humanoiden";
    ["OPTIONS_ITEM_FBS_HUMANOID"] = "Makelloser Humanoidenkampfstein";
    ["OPTIONS_ITEM_BTS_MECHANICAL"] = "Kampfübungsstein für mechanische Wesen";
    ["OPTIONS_ITEM_FBS_MECHANICAL"] = "Makelloser Mechanikkampfstein";
    ["OPTIONS_ITEM_BTS_CRITTER"] = "Kampfübungsstein für Kleintiere";
    ["OPTIONS_ITEM_FBS_CRITTER"] = "Makelloser Kleintierkampfstein";
    ["OPTIONS_ITEM_BTS_DRAGONKIN"] = "Kampfübungsstein für Drachkin";
    ["OPTIONS_ITEM_FBS_DRAGONKIN"] = "Makelloser Drachkinkampfstein";
    ["OPTIONS_ITEM_BTS_ELEMENTAL"] = "Kampfübungsstein Elementare";
    ["OPTIONS_ITEM_FBS_ELEMENTAL"] = "Makelloser Elementarkampfstein";
    ["OPTIONS_ITEM_BTS_FLYING"] = "Kampfübungsstein für Flugwesen";
    ["OPTIONS_ITEM_FBS_FLYING"] = "Makelloser Flugkampfstein";
    ["OPTIONS_ITEM_BTS_MAGIC"] = "Kampfübungsstein für Magiewesen";
    ["OPTIONS_ITEM_FBS_MAGIC"] = "Makelloser Magiekampfstein";
    ["OPTIONS_ITEM_BTS_UNDEAD"] = "Kampfübungsstein für Untote";
    ["OPTIONS_ITEM_FBS_UNDEAD"] = "Makelloser Untodkampfstein";
    ["OPTIONS_ITEM_BTS_AQUATIC"] = "Kampfübungsstein für Wasserwesen";
    ["OPTIONS_ITEM_FBS_AQUATIC"] = "Makelloser Aquatikkampfstein";
    ["OPTIONS_ITEM_DUNGEON_REWARDS_HEADER"] = "Belohnungen aus Kampfhaustier-Dungeons";
    ["OPTIONS_ITEM_CELESTIAL_COIN"] = "Münze der Erhabenen";
    ["OPTIONS_ITEM_OLD_BOTTLE_CAP"] = "Alter Kronkorken";
    ["OPTIONS_ITEM_PRISTINE_GIZMO"] = "Tadelloser Schnickschnack";
    ["OPTIONS_ITEM_CLEANSED_REMAINS"] = "Geläuterte Überreste";
    ["OPTIONS_ITEM_SHADOWY_GEMS"] = "Shattenhafter Edelstein";
    ["OPTIONS_ITEM_DAMP_PET_SUPPLIES"] = "Durchnässter Haustierbedarf";
    ["OPTIONS_ITEM_PETSUPPLIES_HEADER"] = "Haustierbedarf";
    ["OPTIONS_ITEM_GREATER_DARKMOON_PET_SUPPLIES"] = "Hochwertiger Dunkelmond-Haustierbedarf";
    ["OPTIONS_ITEM_DARKMOON_PET_SUPPLIES"] = "Dunkelmond-Haustierbedarf";
    ["OPTIONS_ITEM_PSPS_BURNING"] = "Pandarischer Geisterbeutel mit Haustierbedarf (Brennend)";
    ["OPTIONS_ITEM_PSPS_FLOWING"] = "Pandarischer Geisterbeutel mit Haustierbedarf (Fließend)";
    ["OPTIONS_ITEM_PSPS_WHISPERING"] = "Pandarischer Geisterbeutel mit Haustierbedarf (Flüsternd)";
    ["OPTIONS_ITEM_PSPS_THUNDERING"] = "Pandarischer Geisterbeutel mit Haustierbedarf (Bebend)";
    ["OPTIONS_ITEM_SACK_OF_PET_SUPPLIES"] = "Beutel mit Haustierbedarf";
    ["OPTIONS_ITEM_BIG_BAG_OF_PET_SUPPLIES"] = "Großer Beutel mit Haustierbedarf";
    ["OPTIONS_ITEM_TRAVELERS_PET_SUPPLIES"] = "Haustierbedarf des Reisenden";
    ["OPTIONS_ITEM_LEPROUS_SACK_OF_PET_SUPPLIES"] = "Verseuchter Beutel mit Haustierbedarf";
    ["OPTIONS_ITEM_TORN_SACK_OF_PET_SUPPLIES"] = "Kaputter Beutel mit Haustierbedarf";
    ["OPTIONS_ITEM_FABLED_PANDAREN_PET_SUPPLIES"] = "Berühmter pandarischer Haustierbedarf";
    ["OPTIONS_ITEM_GRUMMLEPOUCH"] = "Grummelbeutel";

    --[[
        Quest Data Strings
    ]]

    -- Quest Givers
    ["QUESTDATA_QUESTGIVERS_MASTER_LI"] = "Meister Li";
    -- ["QUESTDATA_QUESTGIVERS_MUYANI"] = "Muyani";
    ["QUESTDATA_QUESTGIVERS_MARCUS_BAGMAN_BROWN"] = "Markus \"Taschmann\" Braun";
    ["QUESTDATA_QUESTGIVERS_MICRO_ZOOX"] = "Mikrozoox";
    -- ["QUESTDATA_QUESTGIVERS_SEAN_WILKERS"] = "Sean Wilkers";
    -- ["QUESTDATA_QUESTGIVERS_JEREMY_FEASEL"] = "Jeremy Feasel";
    ["QUESTDATA_QUESTGIVERS_CHRISTOPH_VONFEASEL"] = "Christoph von Feasel";
    ["QUESTDATA_QUESTGIVERS_SHIPWRECKED_CAPTIVE"] = "Schiffbrüchiger Gefangener";
    -- ["QUESTDATA_QUESTGIVERS_SERRAH"] = "Serr'ah";
    ["QUESTDATA_QUESTGIVERS_LIO_THE_LIONESS"] = "Lio die Löwin";
    ["QUESTDATA_QUESTGIVERS_KURA_THUNDERHOOF"] = "Kura Donnerhuf";
    ["QUESTDATA_QUESTGIVERS_ERRIS_THE_COLLECTOR"] = "Erris die Sammlerin";
    ["QUESTDATA_QUESTGIVERS_CYMRE_BRIGHTBLADE"] = "Cymre Leuchtklinge";
    -- ["QUESTDATA_QUESTGIVERS_TARALUNE"] = "Taralune";
    -- ["QUESTDATA_QUESTGIVERS_VESHARR"] = "Vesharr";
    -- ["QUESTDATA_QUESTGIVERS_ASHLEI"] = "Ashlei";
    ["QUESTDATA_QUESTGIVERS_TARR_THE_TERRIBLE"] = "Tarr der Schreckliche";
    -- ["QUESTDATA_QUESTGIVERS_GARGRA"] = "Gargra";
    ["QUESTDATA_QUESTGIVERS_GENTLE_SAN"] = "San die Sanfte";
    ["QUESTDATA_QUESTGIVERS_SARA_FINKLESWITCH"] = "Sara Finkelknips";
    ["QUESTDATA_QUESTGIVERS_AKI_THE_CHOSEN"] = "Aki die Auserwählte";
    ["QUESTDATA_QUESTGIVERS_HYUNA_OF_THE_SHRINES"] = "Hyuna von den Schreinen";
    -- ["QUESTDATA_QUESTGIVERS_MORUK"] = "Mo'ruk";
    ["QUESTDATA_QUESTGIVERS_WASTEWALKER_SHU"] = "Ödniswandler Shu";
    ["QUESTDATA_QUESTGIVERS_FARMER_NISHI"] = "Bäuerin Nishi";
    ["QUESTDATA_QUESTGIVERS_SEEKER_ZUSSHI"] = "Sucher Zusshi";
    ["QUESTDATA_QUESTGIVERS_COURAGEOUS_YON"] = "Mutiger Yon";
    ["QUESTDATA_QUESTGIVERS_THUNDERING_PANDAREN_SPIRIT"] = "Bebender Pandarengeist";
    ["QUESTDATA_QUESTGIVERS_BURNING_PANDAREN_SPIRIT"] = "Brennender Pandarengeist";
    ["QUESTDATA_QUESTGIVERS_WHISPERING_PANDAREN_SPIRIT"] = "Flüsternder Pandarengeist";
    ["QUESTDATA_QUESTGIVERS_FLOWING_PANDAREN_SPIRIT"] = "Fließender Pandarengeist";
    ["QUESTDATA_QUESTGIVERS_LITTLE_TOMMY_NEWCOMER"] = "Klein Tommy Grünschnabel";
    -- ["QUESTDATA_QUESTGIVERS_BROK"] = "Brok";
    ["QUESTDATA_QUESTGIVERS_BORDIN_STEADYFIST"] = "Bordin Ruhigfaust";
    -- ["QUESTDATA_QUESTGIVERS_OBALIS"] = "Obalis";
    ["QUESTDATA_QUESTGIVERS_GOZ_BANEFURY"] = "Goz Unheilsfuror";
    ["QUESTDATA_QUESTGIVERS_NEARLY_HEADLESS_JACOB"] = "Fast kopfloser Jakob";
    ["QUESTDATA_QUESTGIVERS_OKRUT_DRAGONWASTE"] = "Okrut Drachenwüste";
    ["QUESTDATA_QUESTGIVERS_GUTRETCH"] = "Darmwürger";
    -- ["QUESTDATA_QUESTGIVERS_MAJOR_PAYNE"] = "Major Payne";
    ["QUESTDATA_QUESTGIVERS_BEEGLE_BLASTFUSE"] = "Beegli Lunte";
    ["QUESTDATA_QUESTGIVERS_MORULU_THE_ELDER"] = "Morulu der Ältere";
    ["QUESTDATA_QUESTGIVERS_BLOODKNIGHT_ANTARI"] = "Blutritter Antari";
    ["QUESTDATA_QUESTGIVERS_NICKI_TINYTECH"] = "Nicki Mikrotech";
    -- ["QUESTDATA_QUESTGIVERS_RASAN"] = "Ras'an";
    -- ["QUESTDATA_QUESTGIVERS_NARROK"] = "Narrok";
    ["QUESTDATA_QUESTGIVERS_ENVIRONEER_BERT"] = "Biosphäreningenieur Bert";
    -- ["QUESTDATA_QUESTGIVERS_CRYSA"] = "Crysa";
    ["QUESTDATA_QUESTGIVERS_STONE_COLD_TRIXXY"] = "Die eiskalte Trixxy";
    ["QUESTDATA_QUESTGIVERS_DAGRA_THE_FIERCE"] = "Dagra die Grimmige";
    -- ["QUESTDATA_QUESTGIVERS_JULIA_STEVENS"] = "Julia Stevens";
    -- ["QUESTDATA_QUESTGIVERS_ANALYNN"] = "Analynn";
    ["QUESTDATA_QUESTGIVERS_BILL_BUCKLER"] = "Bill Schildbuckel";
    ["QUESTDATA_QUESTGIVERS_TRAITOR_GLUK"] = "Gluk der Verräter";
    -- ["QUESTDATA_QUESTGIVERS_ERIC_DAVIDSON"] = "Eric Davidson";
    ["QUESTDATA_QUESTGIVERS_CASSANDRA_KABOOM"] = "Kassandra Kabumm";
    ["QUESTDATA_QUESTGIVERS_KORTAS_DARKHAMMER"] = "Kortas Düsterhammer";
    ["QUESTDATA_QUESTGIVERS_DURIN_DARKHAMMER"] = "Durin Düsterhammer";
    ["QUESTDATA_QUESTGIVERS_KELA_GRIMTOTEM"] = "Kela Grimmtotem";
    ["QUESTDATA_QUESTGIVERS_ELENA_FLUTTERFLY"] = "Elena Flatterflug";
    -- ["QUESTDATA_QUESTGIVERS_LYDIA_ACCOSTE"] = "Lydia Accoste";
    ["QUESTDATA_QUESTGIVERS_GRAZZLE_THE_GREAT"] = "Grazzel der Große";
    ["QUESTDATA_QUESTGIVERS_OLD_MACDONALD"] = "Mac Donald";
    -- ["QUESTDATA_QUESTGIVERS_ZOLTAN"] = "Zoltan";
    -- ["QUESTDATA_QUESTGIVERS_ZUNTA"] = "Zunta";
    -- ["QUESTDATA_QUESTGIVERS_DAVID_KOSSE"] = "David Kosse";
    ["QUESTDATA_QUESTGIVERS_MERDA_STRONGHOOF"] = "Merda Starkhuf";
    -- ["QUESTDATA_QUESTGIVERS_STEVEN_LISBANE"] = "Steven Lisbane";
    ["QUESTDATA_QUESTGIVERS_ZONYA_THE_SADIST"] = "Zonya die Sadistin";
    -- ["QUESTDATA_QUESTGIVERS_EVERESSA"] = "Everessa";
    ["QUESTDATA_QUESTGIVERS_DEIZA_PLAGUEHORN"] = "Deiza Seuchenhorn";
    -- ["QUESTDATA_QUESTGIVERS_LINDSAY"] = "Lindsay";
    -- ["QUESTDATA_QUESTGIVERS_ANTHEA"] = "Anthea";
    -- ["QUESTDATA_QUESTGIVERS_BURT_MACKLYN"] = "Burt Macklyn";

    -- Quest Names
    ["QUESTDATA_QUESTNAME_THE_CELESTIAL_TOURNAMENT"] = "Das Turnier der Erhabenen";
    ["QUESTDATA_QUESTNAME_PET_BATTLE_CHALLENGE_WAILING_CAVERNS"] = "Haustierkampfherausforderung: Die Höhlen des Wehklagens";
    ["QUESTDATA_QUESTNAME_PET_BATTLE_CHALLENGE_DEADMINES"] = "Haustierkampfherausforderung: Todesminen";
    ["QUESTDATA_QUESTNAME_PET_BATTLE_CHALLENGE_BLACKROCK_DEPTHS"] = "Haustierkampfherausforderung: Schwarzfelstiefen";
    ["QUESTDATA_QUESTNAME_PET_BATTLE_CHALLENGE_GNOMEREGAN"] = "Haustierkampfherausforderung: Gnomeregan";
    ["QUESTDATA_QUESTNAME_PET_BATTLE_CHALLENGE_STRATHOLME"] = "Haustierkampfherausforderung: Stratholme";
    ["QUESTDATA_QUESTNAME_DARKMOON_PET_BATTLE"] = "Haustierkampf des Dunkelmonds!";
    ["QUESTDATA_QUESTNAME_A_NEW_DARKMOON_CHALLENGER"] = "Ein neuer Herausforderer des Dunkelmonds!";
    ["QUESTDATA_QUESTNAME_SHIPWRECKED_CAPTIVE"] = "Schiffbrüchiger Gefangener";
    ["QUESTDATA_QUESTNAME_BATTLE_PET_TAMERS_WARLORDS"] = "Kampfhaustierzähmer: Warlords";
    ["QUESTDATA_QUESTNAME_MASTERING_THE_MENAGERIE"] = "Meister der Menagerie";
    ["QUESTDATA_QUESTNAME_CRITTERS_OF_DRAENOR"] = "Geschöpfe von Draenor";
    ["QUESTDATA_QUESTNAME_BATTLE_PET_ROUNDUP"] = "Zusammentrieb der Kampfhaustiere";
    ["QUESTDATA_QUESTNAME_SCRAPPIN"] = "Hauerei";
    ["QUESTDATA_QUESTNAME_CYMRE_BRIGHTBLADE"] = "Cymre Leuchtklinge";
    -- ["QUESTDATA_QUESTNAME_TARALUNE"] = "Taralune";
    -- ["QUESTDATA_QUESTNAME_VESHARR"] = "Vesharr";
    -- ["QUESTDATA_QUESTNAME_ASHLEI"] = "Ashlei";
    ["QUESTDATA_QUESTNAME_TARR_THE_TERRIBLE"] = "Tarr der Schreckliche";
    -- ["QUESTDATA_QUESTNAME_GARGRA"] = "Gargra";
    ["QUESTDATA_QUESTNAME_BEASTS_OF_FABLE_BOOK_I"] = "Fabelhafte Wesen, Buch I";
    ["QUESTDATA_QUESTNAME_BEASTS_OF_FABLE_BOOK_II"] = "Fabelhafte Wesen, Buch II";
    ["QUESTDATA_QUESTNAME_BEASTS_OF_FABLE_BOOK_III"] = "Fabelhafte Wesen, Buch III";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_AKI"] = "Großmeisterin Aki";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_HYUNA"] = "Großmeisterin Hyuna";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_MORUK"] = "Großmeister Mo'ruk";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_SHU"] = "Großmeister Shu";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_NISHI"] = "Großmeisterin Nishi";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_ZUSSHI"] = "Großmeister Zusshi";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_YON"] = "Großmeister Yon";
    ["QUESTDATA_QUESTNAME_THUNDERING_PANDAREN_SPIRIT"] = "Bebender Pandarengeist";
    ["QUESTDATA_QUESTNAME_BURNING_PANDAREN_SPIRIT"] = "Brennender Pandarengeist";
    ["QUESTDATA_QUESTNAME_WHISPERING_PANDAREN_SPIRIT"] = "Flüsternder Pandarengeist";
    ["QUESTDATA_QUESTNAME_FLOWING_PANDAREN_SPIRIT"] = "Fließender Pandarengeist";
    ["QUESTDATA_QUESTNAME_LITTLE_TOMMY_NEWCOMER"] = "Klein Tommy Grünschnabel";
    -- ["QUESTDATA_QUESTNAME_BROK"] = "Brok";
    ["QUESTDATA_QUESTNAME_BORDIN_STEADYFIST"] = "Bordin Ruhigfaust";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_OBALIS"] = "Großmeister Obalis";
    ["QUESTDATA_QUESTNAME_GOZ_BANEFURY"] = "Goz Unheilsfuror";
    ["QUESTDATA_QUESTNAME_NEARLY_HEADLESS_JACOB"] = "Fast kopfloser Jakob";
    ["QUESTDATA_QUESTNAME_OKRUT_DRAGONWASTE"] = "Okrut Drachenwüste";
    ["QUESTDATA_QUESTNAME_GUTRETCH"] = "Darmwürger";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_PAYNE"] = "Großmeister Payne";
    ["QUESTDATA_QUESTNAME_BEEGLE_BLASTFUSE"] = "Beegli Lunte";
    ["QUESTDATA_QUESTNAME_MORULU_THE_ELDER"] = "Morulu der Ältere";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_ANTARI"] = "Großmeister Antari";
    ["QUESTDATA_QUESTNAME_NICKI_TINYTECH"] = "Nicki Mikrotech";
    -- ["QUESTDATA_QUESTNAME_RASAN"] = "Ras'an";
    -- ["QUESTDATA_QUESTNAME_NARROK"] = "Narrok";
    ["QUESTDATA_QUESTNAME_BERTS_BOTS"] = "Berts Bots";
    ["QUESTDATA_QUESTNAME_CRYSAS_FLYERS"] = "Crysas Flieger";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_TRIXXY"] = "Großmeisterin Trixxy";
    ["QUESTDATA_QUESTNAME_DAGRA_THE_FIERCE"] = "Dagra die Grimmige";
    -- ["QUESTDATA_QUESTNAME_JULIA_STEVENS"] = "Julia Stevens";
    -- ["QUESTDATA_QUESTNAME_ANALYNN"] = "Analynn";
    ["QUESTDATA_QUESTNAME_BILL_BUCKLER"] = "Bill Schildbuckel";
    ["QUESTDATA_QUESTNAME_TRAITOR_GLUK"] = "Gluk der Verräter";
    -- ["QUESTDATA_QUESTNAME_ERIC_DAVIDSON"] = "Eric Davidson";
    ["QUESTDATA_QUESTNAME_CASSANDRA_KABOOM"] = "Kassandra Kabumm";
    ["QUESTDATA_QUESTNAME_KORTAS_DARKHAMMER"] = "Kortas Düsterhammer";
    ["QUESTDATA_QUESTNAME_DURIN_DARKHAMMER"] = "Durin Düsterhammer";
    ["QUESTDATA_QUESTNAME_KELA_GRIMTOTEM"] = "Kela Grimmtotem";
    ["QUESTDATA_QUESTNAME_ELENA_FLUTTERFLY"] = "Elena Flatterflug";
    -- ["QUESTDATA_QUESTNAME_LINDSAY"] = "Lindsay";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_LYDIA_ACCOSTE"] = "Großmeisterin Lydia Accoste";
    ["QUESTDATA_QUESTNAME_GRAZZLE_THE_GREAT"] = "Grazzel der Große";
    ["QUESTDATA_QUESTNAME_OLD_MACDONALD"] = "Mac Donald";
    -- ["QUESTDATA_QUESTNAME_ZOLTAN"] = "Zoltan";
    -- ["QUESTDATA_QUESTNAME_ZUNTA"] = "Zunta";
    -- ["QUESTDATA_QUESTNAME_DAVID_KOSSE"] = "David Kosse";
    ["QUESTDATA_QUESTNAME_MERDA_STRONGHOOF"] = "Merda Starkhuf";
    -- ["QUESTDATA_QUESTNAME_STEVEN_LISBANE"] = "Steven Lisbane";
    ["QUESTDATA_QUESTNAME_ZONYA_THE_SADIST"] = "Zonya die Sadistin";
    -- ["QUESTDATA_QUESTNAME_EVERESSA"] = "Everessa";
    ["QUESTDATA_QUESTNAME_DEIZA_PLAGUEHORN"] = "Deiza Seuchenhorn";
    ["QUESTDATA_QUESTNAME_TEMPLE_THROWDOWN"] = "Tempeltacheles";

    --[[
        Feature Strings
    ]]

    -- Item Mailer Strings
    ["MAILER_SUBJECT"] = "Dein Kampfhaustier-Paket ist angekommen!";
    ["MAILER_BODY"] = "Ich hoffe du hast Spaß damit. :)";
    ["MAILER_SENT"] = "Wir haben deine Artikel verschickt. %s/%s";
    ["MAILER_ABORT"] = "Wir mussten das Senden deiner Artikel abbrechen.";
    ["MAILER_BROKE"] = "Wir konnten deine Post nicht versenden, da du das Porto nicht bezahlen kannst.";
    ["MAILER_CHARACTERNOTSET"] = "Du hast nicht angegeben an welchen Charakter du deine Items senden möchtest. Du kannst /bpu options nutzen um die Optionen zu öffnen und deinen Kampfhaustier-Charakter anzugeben.";
    ["MAILER_WARBANKFULL"] = "Der konfigurierte Kriegsmeutenbank-Tab für Kampfhaustiere ist voll. Bitte bereinige diesen, oder ändere den benutzten Tab.";
    ["MAILER_WARBANKNOTSET"] = "Du hast nicht konfiguriert welchen Kriegsmeutenbank-Tab du für deine Kampfhaustier-Items verwenden möchtest. Du kannst mit /bpu options das Optionsfenster öffnen und dies tun.";

    -- World Quest Tracker Strings
    ["WORLDQUESTTRACKER_UNKNOWNITEM"] = "Wir haben einen Quest mit einer unbekannten Artikel-Belohnung gefunden: %s.";
    -- ["WORLDQUESTTRACKER_DEFAULT_ICON"] = "Interface\\Icons\\PetJournalPortrait";
    -- ["WORLDQUESTTRACKER_ROOT_ICON"] = "Interface\\Icons\\Inv_Pet_Frostwolfpup";
    -- ["WORLDQUESTTRACKER_FACTION_ICON"] = "|TInterface\\FriendsFrame\\PlusManz-%s:0|t %s";
    -- ["WORLDQUESTTRACKER_WORLDQUEST_TITLE"] = "World Quests";
    -- ["WORLDQUESTTRACKER_WORLDQUEST_ICON"] = "Interface\\BUTTONS\\AdventureGuideMicrobuttonAlert";
    ["WORLDQUESTTRACKER_REPEATABLEQUEST_TITLE"] = "Wiederholbare Quests";
    -- ["WORLDQUESTTRACKER_REPEATABLEQUEST_ICON"] = "Interface\\GossipFrame\\DailyActiveQuestIcon";
    -- ["WORLDQUESTTRACKER_DUNGEONS_TITLE"] = "Battle Pet Dungeons";
    -- ["WORLDQUESTTRACKER_DUNGEONS_ICON"] = "Interface\\MINIMAP\\Dungeon";
    -- ["WORLDQUESTTRACKER_DARKMOONFAIRE_TITLE"] = "Darkmoon Faire";
    -- ["WORLDQUESTTRACKER_DARKMOONFAIRE_ICON"] = "Interface\\ICONS\\INV_MISC_Cape_DarkmoonFaire_C_01";
    -- ["WORLDQUESTTRACKER_SHADOWLANDS_TITLE"] = "Shadowlands";
    -- ["WORLDQUESTTRACKER_SHADOWLANDS_ICON"] = "assets\\expansion-9-shadowlands";
    -- ["WORLDQUESTTRACKER_BATTLEFORAZEROTH_TITLE"] = "Battle for Azeroth";
    -- ["WORLDQUESTTRACKER_BATTLEFORAZEROTH_ICON"] = "assets\\expansion-8-battleforazeroth";
    -- ["WORLDQUESTTRACKER_LEGION_TITLE"] = "Legion";
    -- ["WORLDQUESTTRACKER_LEGION_ICON"] = "assets\\expansion-7-legion";
    -- ["WORLDQUESTTRACKER_WARLORDSOFDRAENOR_TITLE"] = "Warlords of Draenor";
    -- ["WORLDQUESTTRACKER_WARLORDSOFDRAENOR_ICON"] = "assets\\expansion-6-warlordsofdraenor";
    -- ["WORLDQUESTTRACKER_MISTSOFPANDARIA_TITLE"] = "Mists of Pandaria";
    -- ["WORLDQUESTTRACKER_MISTSOFPANDARIA_ICON"] = "assets\\expansion-5-mistsofpandaria";
    -- ["WORLDQUESTTRACKER_CATACLYSM_TITLE"] = "Cataclysm";
    -- ["WORLDQUESTTRACKER_CATACLYSM_ICON"] = "assets\\expansion-4-cataclysm";
    -- ["WORLDQUESTTRACKER_WRATHOFTHELICHKING_TITLE"] = "Wrath of the Lich King";
    -- ["WORLDQUESTTRACKER_WRATHOFTHELICHKING_ICON"] = "assets\\expansion-3-wrathofthelichking";
    -- ["WORLDQUESTTRACKER_THEBURNINGCRUSADE_TITLE"] = "The Burning Crusade";
    -- ["WORLDQUESTTRACKER_THEBURNINGCRUSADE_ICON"] = "assets\\expansion-2-theburningcrusade";
    -- ["WORLDQUESTTRACKER_CLASSIC_TITLE"] = "Classic";
    -- ["WORLDQUESTTRACKER_CLASSIC_ICON"] = "assets\\expansion-1-classic";

    -- Squirt Day Helper Strings
    ["SDH_SUPER_SQUIRT_DAY"] = "|c%s|c%sHeute|r ist SUPER SQUIRT DAY!!!|r";
    ["SDH_SQUIRT_DAY"] = "|c%s|c%sHeute|r ist squirt day!|r";
    ["SDH_NEXT_SQUIRT"] = "|c%sDer nächste squirt day ist am |c%s{weekday}, {day}. {month}|r.|r";
    ["SDH_NOT_SUPPORTED"] = "|c%sDeine Region ist leider nicht unterstützt.|r";
    ["SDH_PET_TREAT"] = "Gib' deinem Haustier ein %s!";
    ["SDH_PET_HAT"] = "Zieh deinen Hut auf!!";
    ["SDH_STATISTICS"] = "Squirt Day Helfer: Bis jetzt hast du {pets} Haustiere in {battles} Kämpfen gelevelt.";

    -- Date Strings
    ["WEEKDAY_2"] = "Montag";
    ["WEEKDAY_3"] = "Dienstag";
    ["WEEKDAY_4"] = "Mittwoch";
    ["WEEKDAY_5"] = "Donnerstag";
    ["WEEKDAY_6"] = "Freitag";
    ["WEEKDAY_7"] = "Samstag";
    ["WEEKDAY_1"] = "Sonntag";
    ["MONTH_1"] = "Januar";
    ["MONTH_2"] = "Februar";
    ["MONTH_3"] = "März";
    -- ["MONTH_4"] = "April";
    ["MONTH_5"] = "Mai";
    ["MONTH_6"] = "Juni";
    ["MONTH_7"] = "Juli";
    -- ["MONTH_8"] = "August";
    -- ["MONTH_9"] = "September";
    ["MONTH_10"] = "Oktober";
    -- ["MONTH_11"] = "November";
    ["MONTH_12"] = "Dezember";
})
do L[key] = value; end
