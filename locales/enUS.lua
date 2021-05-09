
local name, app = ...;
app.L = {
    ["TITLE"] = "|cFFD13653Battle Pet World Quest Tracker|r";

    --[[
        Settings strings
    ]]

    ["OPTIONS_MAILER_HEADER"] = "Items Mailer";
    ["OPTIONS_MAILER_DESCRIPTION"] = "If enabled, this feature will send battle pet related items to a character, every time you open the mail window. It will send only items you define to be sent to a character defined by you. Since you can only send mail to characters on your server, this setting is stored for each server separately.\n\nThis feature is not functional and (most likely) never will be. This is the result of a WeakAuras limitation, which I kind of agree with, even. Considering the code itself is working (with the exception of the actual sending of the mail) you can make a macro, which sends the mail to your specified character and use this WA to put all the items into the mail. Therefor you'll need to set the `DISABLED` flag in the custom trigger of \"Pet Items Auto Mailer\" to false.\n\nSaid macro would look like this `/run SendMail(\"<char name>\", \"Your Pet Battle Item Package\", \"\");";
    ["OPTIONS_MAILER_ENABLED_DESCRIPTION"] = "Enable Items Mailer";
    ["OPTIONS_MAILER_CHARACTER_DESCRIPTION"] = "Character:";
    ["OPTIONS_MAILER_ITEMS_HEADER"] = "Items To Mail";

    ["OPTIONS_WORLDQUESTTRACKER_HEADER"] = "World Quest Tracker";
    ["OPTIONS_WORLDQUESTTRACKER_SHOW_NO_ITEM"] = "Show World Quests with no item reward";
    ["OPTIONS_WORLDQUESTTRACKER_SHOW_UNKNOWN_ITEM"] = "Show World Quests with item rewards that are not recognized";
    ["OPTIONS_WORLDQUESTTRACKER_PRINT_UNKNOWN_ITEM"] = "Print item rewards that are not recognized";
    ["OPTIONS_WORLDQUESTTRACKER_ITEMS_HEADER"] = "Items To Track";

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
};
