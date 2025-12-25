

if GetLocale() ~= "koKR" then
    return;
end

local _, app = ...;
local L = app.L;

for key, value in pairs({
    ["TITLE"] = "|cFFD13653전투 애완 동물 유틸리티|r";
    -- ["HELP"] = "Use '/bpu' with following arguments:\n - none or 'main': shows or hides the quest tracker window\n - 'options': shows the settings for the addon\n - 'help': shows this help";
    -- ["HELP_ADVANCED"] = "Use '/bpu' with following arguments:\n - none or 'main': shows or hides the quest tracker window\n - 'options': shows the settings for the addon\n - 'help': shows this help\n - 'debug': toggles the debug flag\n    This shows debug messages in chat and gives access to following commands:\n - 'dump': Dumps the full addon state in the chat\n    (this is a buttload, so use at own risk)";
    ["ERROR_UNKNOWN_COMMAND"] = "알 수없는 명령: '%s'. 도움을 받으려먄 '/bpu help' 를 입력하십시오.";
    ["MESSAGE_GENERAL_DUMP"] = "다음은 애드온 상태의 덤프가 있십니다:\n%s";
    ["MESSAGE_DEBUG_TOGGLE"] = "디버그 상태를 토글합니다. 현채 값: %s";
    ["MESSAGE_DEBUG_DISABLED"] = "이 명령은 디버그 모드에서만 사용할 수 있습니다.";
    ["MESSAGE_DEBUG_GREETING"] = "디버그 모드가 활성화되어 있습니다. 비활성화하려면 채팅에 '/bpu debug'를 입력하십시오.";

    --[[
        Settings Strings
    ]]

    -- Item Mailer Options Strings
    ["OPTIONS_MAILER_HEADER"] = "항목 메일러";
    -- ["OPTIONS_MAILER_DESCRIPTION"] = "If enabled, this feature will send battle pet related items to a character, every time you open the mail window. It will send only items you define to be sent to a character defined by you. Since you can only send mail to characters on your server, this setting is stored for each server separately.\n\nThis feature is not functional and (most likely) never will be. This is the result of a WeakAuras limitation, which I kind of agree with, even. Considering the code itself is working (with the exception of the actual sending of the mail) you can make a macro, which sends the mail to your specified character and use this WA to put all the items into the mail. Therefor you'll need to set the `DISABLED` flag in the custom trigger of \"Pet Items Auto Mailer\" to false.\n\nSaid macro would look like this `/run SendMail(\"<char name>\", \"Your Pet Battle Item Package\", \"\");`";
    ["OPTIONS_MAILER_ENABLED_DESCRIPTION"] = "항목 메일러을 활성화합니다";
    ["OPTIONS_MAILER_CHARACTER_DESCRIPTION"] = "캐릭터:";
    -- ["OPTIONS_MAILER_USEWARBANK_DESCRIPTION"] = "Use the warband bank instead of mailing items.";
    -- ["OPTIONS_MAILER_WARBANKTAB_DESCRIPTION"] = "Warbank tab to use:";
    ["OPTIONS_MAILER_ITEMS_HEADER"] = "보내는 항몬";

    -- World Quest Tracker Options Strings
    ["OPTIONS_WORLDQUESTTRACKER_HEADER"] = "퀘스트 추적기";
    ["OPTIONS_WORLDQUESTTRACKER_SHOW_NO_ITEM"] = "보상으로 항목이없는 퀘스트를 표시하십시오";
    ["OPTIONS_WORLDQUESTTRACKER_SHOW_UNKNOWN_ITEM"] = "인식되지 않은 항목 보상으로 퀘스트를 보여줍니다";
    ["OPTIONS_WORLDQUESTTRACKER_PRINT_UNKNOWN_ITEM"] = "인식되지 않은 항목 보상을 인쇄하십시오";
    ["OPTIONS_WORLDQUESTTRACKER_ITEMS_HEADER"] = "추적 할 랑목";

    -- Squirt Day Helper Options Strings
    ["OPTIONS_SQUIRTDAYHELPER_HEADER"] = "Squirt Day 도우미";
    ["OPTIONS_SQUIRTDAYHELPER_ENABLED_DESCRIPTION"] = "Squirt Day 도우미를 사용하십시오";

    -- Item descriptions
    ["OPTIONS_ITEM_GENERAL_HEADER"] = "일반 전투 애완 동물 항목";
    ["OPTIONS_ITEM_BATTLE_PET_BANDAGE"] = "전투 애완동물 붕대";
    ["OPTIONS_ITEM_PETCHARMS_HEADER"] = "애완 동물의 매력";
    ["OPTIONS_ITEM_POLISHED_PET_CHARM"] = "광택나는 애완동물 부적";
    ["OPTIONS_ITEM_SHINY_PET_CHARM"] = "반짝이는 애완동물 부적";
    ["OPTIONS_ITEM_GENERAL_BATTLESTONES_HEADER"] = "일반 전투 돌";
    ["OPTIONS_ITEM_ULTIMATE_BATTLE_TRAINING_STONE"] = "궁극의 전투 훈련석";
    ["OPTIONS_ITEM_MARKED_FLAWLESS_BATTLE_STONE"] = "표시된 무결한 전투석";
    ["OPTIONS_ITEM_FELTOUCHED_BATTLE_TRAINING_STONE"] = "마에 물든 전투 훈련석";
    ["OPTIONS_ITEM_FLAWLESS_BATTLE_TRAINING_STONE"] = "무결한 전투 훈련석";
    ["OPTIONS_ITEM_FAMILY_BATTLESTONES_HEADER"] = "가족 전투 돌";
    ["OPTIONS_ITEM_BTS_BEAST"] = "야수 전투 훈련석";
    ["OPTIONS_ITEM_FBS_BEAST"] = "무결한 야수 전투석";
    ["OPTIONS_ITEM_BTS_HUMANOID"] = "인간형 전투 훈련석";
    ["OPTIONS_ITEM_FBS_HUMANOID"] = "무결한 인간형 전투석";
    ["OPTIONS_ITEM_BTS_MECHANICAL"] = "기계 전투 훈련석";
    ["OPTIONS_ITEM_FBS_MECHANICAL"] = "무결한 기계 전투석";
    ["OPTIONS_ITEM_BTS_CRITTER"] = "동물 전투 훈련석";
    ["OPTIONS_ITEM_FBS_CRITTER"] = "무결한 동물 전투석";
    ["OPTIONS_ITEM_BTS_DRAGONKIN"] = "용족 전투 훈련석";
    ["OPTIONS_ITEM_FBS_DRAGONKIN"] = "무결한 용족 전투석";
    ["OPTIONS_ITEM_BTS_ELEMENTAL"] = "정령 전투 훈련석";
    ["OPTIONS_ITEM_FBS_ELEMENTAL"] = "무결한 정령 전투석";
    ["OPTIONS_ITEM_BTS_FLYING"] = "비행 전투 훈련석";
    ["OPTIONS_ITEM_FBS_FLYING"] = "무결한 비행 전투석";
    ["OPTIONS_ITEM_BTS_MAGIC"] = "마법 전투 훈련석";
    ["OPTIONS_ITEM_FBS_MAGIC"] = "무결한 마법 전투석";
    ["OPTIONS_ITEM_BTS_UNDEAD"] = "언데드 전투 훈련석";
    ["OPTIONS_ITEM_FBS_UNDEAD"] = "무결한 언데드 전투석";
    ["OPTIONS_ITEM_BTS_AQUATIC"] = "물 전투 훈련석";
    ["OPTIONS_ITEM_FBS_AQUATIC"] = "무결한 물 전투석";
    ["OPTIONS_ITEM_DUNGEON_REWARDS_HEADER"] = "전투 애완 동물 던전 보상";
    ["OPTIONS_ITEM_CELESTIAL_COIN"] = "천신의 주화";
    ["OPTIONS_ITEM_OLD_BOTTLE_CAP"] = "오래된 병뚜껑";
    ["OPTIONS_ITEM_PRISTINE_GIZMO"] = "온전한 장치";
    ["OPTIONS_ITEM_CLEANSED_REMAINS"] = "정화된 유해";
    ["OPTIONS_ITEM_SHADOWY_GEMS"] = "그림자 보석";
    ["OPTIONS_ITEM_DAMP_PET_SUPPLIES"] = "축축한 애완동물용품 가방";
    ["OPTIONS_ITEM_PETSUPPLIES_HEADER"] = "애완 동물 공급 가방";
    ["OPTIONS_ITEM_GREATER_DARKMOON_PET_SUPPLIES"] = "두툼한 다크문 애완동물 용품";
    ["OPTIONS_ITEM_DARKMOON_PET_SUPPLIES"] = "다크문 애완동물용품";
    ["OPTIONS_ITEM_PSPS_BURNING"] = "판다렌 정령 애완동물용품 가방";
    ["OPTIONS_ITEM_PSPS_FLOWING"] = "판다렌 정령 애완동물용품 가방";
    ["OPTIONS_ITEM_PSPS_WHISPERING"] = "판다렌 정령 애완동물용품 가방";
    ["OPTIONS_ITEM_PSPS_THUNDERING"] = "판다렌 정령 애완동물용품 가방";
    ["OPTIONS_ITEM_SACK_OF_PET_SUPPLIES"] = "애완동물용품 가방";
    ["OPTIONS_ITEM_BIG_BAG_OF_PET_SUPPLIES"] = "커다란 애완동물용품 가방";
    ["OPTIONS_ITEM_TRAVELERS_PET_SUPPLIES"] = "여행자의 애완동물 용품 가방";
    ["OPTIONS_ITEM_LEPROUS_SACK_OF_PET_SUPPLIES"] = "문드러진 애완동물용품 가방";
    ["OPTIONS_ITEM_TORN_SACK_OF_PET_SUPPLIES"] = "찢어진 애완동물용품 가방";
    ["OPTIONS_ITEM_FABLED_PANDAREN_PET_SUPPLIES"] = "전설적인 판다렌 애완동물용품 가방";
    ["OPTIONS_ITEM_GRUMMLEPOUCH"] = "그루멀 주머니";

    --[[
        Quest Data Strings
    ]]

    -- Quest Givers
    ["QUESTDATA_QUESTGIVERS_MASTER_LI"] = "사부 리";
    ["QUESTDATA_QUESTGIVERS_MUYANI"] = "무야니";
    ["QUESTDATA_QUESTGIVERS_MARCUS_BAGMAN_BROWN"] = "마커스 \"앞잡이\" 브라운";
    ["QUESTDATA_QUESTGIVERS_MICRO_ZOOX"] = "초소형 죽스";
    ["QUESTDATA_QUESTGIVERS_SEAN_WILKERS"] = "션 윌커스";
    ["QUESTDATA_QUESTGIVERS_JEREMY_FEASEL"] = "제레미 피셀";
    ["QUESTDATA_QUESTGIVERS_CHRISTOPH_VONFEASEL"] = "크리스토프 본피젤";
    ["QUESTDATA_QUESTGIVERS_SHIPWRECKED_CAPTIVE"] = "난파당한 포로";
    ["QUESTDATA_QUESTGIVERS_SERRAH"] = "세르아";
    ["QUESTDATA_QUESTGIVERS_LIO_THE_LIONESS"] = "암사자 리오";
    ["QUESTDATA_QUESTGIVERS_KURA_THUNDERHOOF"] = "쿠라 썬더후프";
    ["QUESTDATA_QUESTGIVERS_ERRIS_THE_COLLECTOR"] = "수집가 에리스";
    ["QUESTDATA_QUESTGIVERS_CYMRE_BRIGHTBLADE"] = "사임레 브라이트블레이드";
    ["QUESTDATA_QUESTGIVERS_TARALUNE"] = "타랄룬";
    ["QUESTDATA_QUESTGIVERS_VESHARR"] = "베샤르";
    ["QUESTDATA_QUESTGIVERS_ASHLEI"] = "애쉴레이";
    ["QUESTDATA_QUESTGIVERS_TARR_THE_TERRIBLE"] = "끔찍한 타르";
    ["QUESTDATA_QUESTGIVERS_GARGRA"] = "갈그라";
    ["QUESTDATA_QUESTGIVERS_GENTLE_SAN"] = "부드러운 싼";
    ["QUESTDATA_QUESTGIVERS_SARA_FINKLESWITCH"] = "사라 핀클스위치";
    ["QUESTDATA_QUESTGIVERS_AKI_THE_CHOSEN"] = "선택받은 자 아키";
    ["QUESTDATA_QUESTGIVERS_HYUNA_OF_THE_SHRINES"] = "성소의 현아";
    ["QUESTDATA_QUESTGIVERS_MORUK"] = "모루크";
    ["QUESTDATA_QUESTGIVERS_WASTEWALKER_SHU"] = "황야의 방랑자 슈";
    ["QUESTDATA_QUESTGIVERS_FARMER_NISHI"] = "농부 니스";
    ["QUESTDATA_QUESTGIVERS_SEEKER_ZUSSHI"] = "수색자 주쉬";
    ["QUESTDATA_QUESTGIVERS_COURAGEOUS_YON"] = "용감한 욘";
    ["QUESTDATA_QUESTGIVERS_THUNDERING_PANDAREN_SPIRIT"] = "요동치는 판다렌 정령";
    ["QUESTDATA_QUESTGIVERS_BURNING_PANDAREN_SPIRIT"] = "불타는 판다렌 정령";
    ["QUESTDATA_QUESTGIVERS_WHISPERING_PANDAREN_SPIRIT"] = "속삭이는 판다렌 정령";
    ["QUESTDATA_QUESTGIVERS_FLOWING_PANDAREN_SPIRIT"] = "흐르는 판다렌 정령";
    ["QUESTDATA_QUESTGIVERS_LITTLE_TOMMY_NEWCOMER"] = "꼬마 토미 뉴커머";
    ["QUESTDATA_QUESTGIVERS_BROK"] = "브로크";
    ["QUESTDATA_QUESTGIVERS_BORDIN_STEADYFIST"] = "보르딘 스테디피스트";
    ["QUESTDATA_QUESTGIVERS_OBALIS"] = "오발리스";
    ["QUESTDATA_QUESTGIVERS_GOZ_BANEFURY"] = "고즈 베인퓨리";
    ["QUESTDATA_QUESTGIVERS_NEARLY_HEADLESS_JACOB"] = "뇌가 거의 없는 자콥";
    ["QUESTDATA_QUESTGIVERS_OKRUT_DRAGONWASTE"] = "오크러트 드래곤웨이스트";
    ["QUESTDATA_QUESTGIVERS_GUTRETCH"] = "구역창자";
    ["QUESTDATA_QUESTGIVERS_MAJOR_PAYNE"] = "상사 페인";
    ["QUESTDATA_QUESTGIVERS_BEEGLE_BLASTFUSE"] = "비글 블라스트퓨즈";
    ["QUESTDATA_QUESTGIVERS_MORULU_THE_ELDER"] = "어르신 모룰루";
    ["QUESTDATA_QUESTGIVERS_BLOODKNIGHT_ANTARI"] = "혈기사 안타리";
    ["QUESTDATA_QUESTGIVERS_NICKI_TINYTECH"] = "니키 타이니테크";
    ["QUESTDATA_QUESTGIVERS_RASAN"] = "라스안";
    ["QUESTDATA_QUESTGIVERS_NARROK"] = "나로크";
    ["QUESTDATA_QUESTGIVERS_ENVIRONEER_BERT"] = "환경공학자 버트";
    ["QUESTDATA_QUESTGIVERS_CRYSA"] = "크리사";
    ["QUESTDATA_QUESTGIVERS_STONE_COLD_TRIXXY"] = "차디찬 트릭시";
    ["QUESTDATA_QUESTGIVERS_DAGRA_THE_FIERCE"] = "맹렬한 다그라";
    ["QUESTDATA_QUESTGIVERS_JULIA_STEVENS"] = "줄리아 스티븐스";
    ["QUESTDATA_QUESTGIVERS_ANALYNN"] = "아날린";
    ["QUESTDATA_QUESTGIVERS_BILL_BUCKLER"] = "빌 버클러";
    ["QUESTDATA_QUESTGIVERS_TRAITOR_GLUK"] = "배신자 글루크";
    ["QUESTDATA_QUESTGIVERS_ERIC_DAVIDSON"] = "에릭 데이비슨";
    ["QUESTDATA_QUESTGIVERS_CASSANDRA_KABOOM"] = "카산드라 카붐";
    ["QUESTDATA_QUESTGIVERS_KORTAS_DARKHAMMER"] = "코르타스 다크해머";
    ["QUESTDATA_QUESTGIVERS_DURIN_DARKHAMMER"] = "두린 다크해머";
    ["QUESTDATA_QUESTGIVERS_KELA_GRIMTOTEM"] = "켈라 그림토템";
    ["QUESTDATA_QUESTGIVERS_ELENA_FLUTTERFLY"] = "엘레나 플러터플라이";
    ["QUESTDATA_QUESTGIVERS_LYDIA_ACCOSTE"] = "리디아 아코스테";
    ["QUESTDATA_QUESTGIVERS_GRAZZLE_THE_GREAT"] = "위대한 그라즐";
    ["QUESTDATA_QUESTGIVERS_OLD_MACDONALD"] = "노인 맥도날드";
    ["QUESTDATA_QUESTGIVERS_ZOLTAN"] = "졸탄";
    ["QUESTDATA_QUESTGIVERS_ZUNTA"] = "준타";
    ["QUESTDATA_QUESTGIVERS_DAVID_KOSSE"] = "데이비드 코세";
    ["QUESTDATA_QUESTGIVERS_MERDA_STRONGHOOF"] = "메르다 스트롱후프";
    ["QUESTDATA_QUESTGIVERS_STEVEN_LISBANE"] = "스티븐 리스베인";
    ["QUESTDATA_QUESTGIVERS_ZONYA_THE_SADIST"] = "성격 나쁜 존야";
    ["QUESTDATA_QUESTGIVERS_EVERESSA"] = "에버레사";
    ["QUESTDATA_QUESTGIVERS_DEIZA_PLAGUEHORN"] = "데이자 플레이그혼";
    ["QUESTDATA_QUESTGIVERS_LINDSAY"] = "린제이";
    ["QUESTDATA_QUESTGIVERS_ANTHEA"] = "안시아";
    ["QUESTDATA_QUESTGIVERS_BURT_MACKLYN"] = "버트 맥클린";

    -- Quest Names
    ["QUESTDATA_QUESTNAME_THE_CELESTIAL_TOURNAMENT"] = "천신의 시합";
    ["QUESTDATA_QUESTNAME_PET_BATTLE_CHALLENGE_WAILING_CAVERNS"] = "애완동물 대전 도전: 통곡의 동굴";
    ["QUESTDATA_QUESTNAME_PET_BATTLE_CHALLENGE_DEADMINES"] = "애완동물 대전 도전: 죽음의 폐광";
    ["QUESTDATA_QUESTNAME_PET_BATTLE_CHALLENGE_BLACKROCK_DEPTHS"] = "애완동물 대전 도전: 검은바위 나락";
    ["QUESTDATA_QUESTNAME_PET_BATTLE_CHALLENGE_GNOMEREGAN"] = "애완동물 대전 도전: 놈리건";
    ["QUESTDATA_QUESTNAME_PET_BATTLE_CHALLENGE_STRATHOLME"] = "애완동물 대전 도전: 스트라솔름";
    ["QUESTDATA_QUESTNAME_DARKMOON_PET_BATTLE"] = "다크문 애완동물 대전!";
    ["QUESTDATA_QUESTNAME_A_NEW_DARKMOON_CHALLENGER"] = "새로운 다크문 도전자!";
    ["QUESTDATA_QUESTNAME_SHIPWRECKED_CAPTIVE"] = "난파당한 포로";
    ["QUESTDATA_QUESTNAME_BATTLE_PET_TAMERS_WARLORDS"] = "전투 애완동물 조련사: 전쟁군주";
    ["QUESTDATA_QUESTNAME_MASTERING_THE_MENAGERIE"] = "동물 지배자";
    ["QUESTDATA_QUESTNAME_CRITTERS_OF_DRAENOR"] = "드레노어의 동물들";
    ["QUESTDATA_QUESTNAME_BATTLE_PET_ROUNDUP"] = "전투 애완동물 혼내주기";
    ["QUESTDATA_QUESTNAME_SCRAPPIN"] = "혼내주기";
    ["QUESTDATA_QUESTNAME_CYMRE_BRIGHTBLADE"] = "사임레 브라이트블레이드";
    ["QUESTDATA_QUESTNAME_TARALUNE"] = "타랄룬";
    ["QUESTDATA_QUESTNAME_VESHARR"] = "베샤르";
    ["QUESTDATA_QUESTNAME_ASHLEI"] = "애쉴레이";
    ["QUESTDATA_QUESTNAME_TARR_THE_TERRIBLE"] = "끔찍한 타르";
    ["QUESTDATA_QUESTNAME_GARGRA"] = "갈그라";
    ["QUESTDATA_QUESTNAME_BEASTS_OF_FABLE_BOOK_I"] = "전설의 야수 1권";
    ["QUESTDATA_QUESTNAME_BEASTS_OF_FABLE_BOOK_II"] = "전설의 야수 2권";
    ["QUESTDATA_QUESTNAME_BEASTS_OF_FABLE_BOOK_III"] = "전설의 야수 3권";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_AKI"] = "특급 조련사 아키";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_HYUNA"] = "특급 조련사 현아";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_MORUK"] = "특급 조련사 모루크";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_SHU"] = "특급 조련사 슈";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_NISHI"] = "특급 조련사 니스";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_ZUSSHI"] = "특급 조련사 주쉬";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_YON"] = "특급 조련사 욘";
    ["QUESTDATA_QUESTNAME_THUNDERING_PANDAREN_SPIRIT"] = "요동치는 판다렌 정령";
    ["QUESTDATA_QUESTNAME_BURNING_PANDAREN_SPIRIT"] = "불타는 판다렌 정령";
    ["QUESTDATA_QUESTNAME_WHISPERING_PANDAREN_SPIRIT"] = "속삭이는 판다렌 정령";
    ["QUESTDATA_QUESTNAME_FLOWING_PANDAREN_SPIRIT"] = "흐르는 판다렌 정령";
    ["QUESTDATA_QUESTNAME_LITTLE_TOMMY_NEWCOMER"] = "꼬마 토미 뉴커머";
    ["QUESTDATA_QUESTNAME_BROK"] = "브로크";
    ["QUESTDATA_QUESTNAME_BORDIN_STEADYFIST"] = "보르딘 스테디피스트";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_OBALIS"] = "특급 조련사 오발리스";
    ["QUESTDATA_QUESTNAME_GOZ_BANEFURY"] = "고즈 베인퓨리";
    ["QUESTDATA_QUESTNAME_NEARLY_HEADLESS_JACOB"] = "뇌가 거의 없는 자콥";
    ["QUESTDATA_QUESTNAME_OKRUT_DRAGONWASTE"] = "오크러트 드래곤웨이스트";
    ["QUESTDATA_QUESTNAME_GUTRETCH"] = "구역창자";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_PAYNE"] = "특급 조련사 페인";
    ["QUESTDATA_QUESTNAME_BEEGLE_BLASTFUSE"] = "비글 블라스트퓨즈";
    ["QUESTDATA_QUESTNAME_MORULU_THE_ELDER"] = "어르신 모룰루";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_ANTARI"] = "특급 조련사 안타리";
    ["QUESTDATA_QUESTNAME_NICKI_TINYTECH"] = "니키 타이니테크";
    ["QUESTDATA_QUESTNAME_RASAN"] = "라스안";
    ["QUESTDATA_QUESTNAME_NARROK"] = "나로크";
    ["QUESTDATA_QUESTNAME_BERTS_BOTS"] = "버트의 로봇들";
    ["QUESTDATA_QUESTNAME_CRYSAS_FLYERS"] = "크리사의 비행 애완동물";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_TRIXXY"] = "특급 조련사 트릭시";
    ["QUESTDATA_QUESTNAME_DAGRA_THE_FIERCE"] = "맹렬한 다그라";
    ["QUESTDATA_QUESTNAME_JULIA_STEVENS"] = "줄리아 스티븐스";
    ["QUESTDATA_QUESTNAME_ANALYNN"] = "아날린";
    ["QUESTDATA_QUESTNAME_BILL_BUCKLER"] = "빌 버클러";
    ["QUESTDATA_QUESTNAME_TRAITOR_GLUK"] = "배신자 글루크";
    ["QUESTDATA_QUESTNAME_ERIC_DAVIDSON"] = "에릭 데이비슨";
    ["QUESTDATA_QUESTNAME_CASSANDRA_KABOOM"] = "카산드라 카붐";
    ["QUESTDATA_QUESTNAME_KORTAS_DARKHAMMER"] = "코르타스 다크해머";
    ["QUESTDATA_QUESTNAME_DURIN_DARKHAMMER"] = "두린 다크해머";
    ["QUESTDATA_QUESTNAME_KELA_GRIMTOTEM"] = "켈라 그림토템";
    ["QUESTDATA_QUESTNAME_ELENA_FLUTTERFLY"] = "엘레나 플러터플라이";
    ["QUESTDATA_QUESTNAME_LINDSAY"] = "린제이";
    ["QUESTDATA_QUESTNAME_GRAND_MASTER_LYDIA_ACCOSTE"] = "특급 조련사 리디아 아코스테";
    ["QUESTDATA_QUESTNAME_GRAZZLE_THE_GREAT"] = "위대한 그라즐";
    ["QUESTDATA_QUESTNAME_OLD_MACDONALD"] = "노인 맥도날드";
    ["QUESTDATA_QUESTNAME_ZOLTAN"] = "졸탄";
    ["QUESTDATA_QUESTNAME_ZUNTA"] = "준타";
    ["QUESTDATA_QUESTNAME_DAVID_KOSSE"] = "데이비드 코세";
    ["QUESTDATA_QUESTNAME_MERDA_STRONGHOOF"] = "메르다 스트롱후프";
    ["QUESTDATA_QUESTNAME_STEVEN_LISBANE"] = "스티븐 리스베인";
    ["QUESTDATA_QUESTNAME_ZONYA_THE_SADIST"] = "성격 나쁜 존야";
    ["QUESTDATA_QUESTNAME_EVERESSA"] = "에버레사";
    ["QUESTDATA_QUESTNAME_DEIZA_PLAGUEHORN"] = "데이자 플레이그혼";
    ["QUESTDATA_QUESTNAME_TEMPLE_THROWDOWN"] = "사원에서의 승부";

    --[[
        Feature Strings
    ]]

    -- Item Mailer Strings
    ["MAILER_SUBJECT"] = "전투 애완 동물 관리 패키지가 도착했습니다!";
    ["MAILER_BODY"] = "나는 당신이 그것을 즐길 수 있기를 바랍니다. ~(꒪꒳꒪)~";
    ["MAILER_SENT"] = "우리는 당신의 물건을 보냈습니다. %s/%s";
    ["MAILER_ABORT"] = "우리는 당신의 물건 보내기를 중단해야했습니다.";
    ["MAILER_BROKE"] = "우편 요금울 지불 할 수 없기 때문에 메일을 보낼 수 없습니다.";
    -- ["MAILER_CHARACTERNOTSET"] = "You did not specify which character to send your items to. Use /bpu options to open the options and configure in your battle pet character.";
    -- ["MAILER_WARBANKFULL"] = "Your configured battle pet warbank tab is full. Please clear some space for additional items or change the used tab.";
    -- ["MAILER_WARBANKNOTSET"] = "You have not set which warbank tab you would like to deposit your battle pet items to. You can use /bpu options to open the option panel and configure it.";

    -- World Quest Tracker Strings
    ["WORLDQUESTTRACKER_UNKNOWNITEM"] = "우리는 알려지지 않은 항목 보상을 가진 퀘스트를 발견했습니다: %s.";
    -- ["WORLDQUESTTRACKER_DEFAULT_ICON"] = "Interface\\Icons\\PetJournalPortrait";
    -- ["WORLDQUESTTRACKER_ROOT_ICON"] = "Interface\\Icons\\Inv_Pet_Frostwolfpup";
    -- ["WORLDQUESTTRACKER_FACTION_ICON"] = "|TInterface\\FriendsFrame\\PlusManz-%s:0|t %s";
    -- ["WORLDQUESTTRACKER_WORLDQUEST_TITLE"] = "World Quests";
    -- ["WORLDQUESTTRACKER_WORLDQUEST_ICON"] = "Interface\\BUTTONS\\AdventureGuideMicrobuttonAlert";
    -- ["WORLDQUESTTRACKER_REPEATABLEQUEST_TITLE"] = "Repeatable Quests";
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
    ["SDH_SUPER_SQUIRT_DAY"] = "|c%s|c%s오늘|r은 슈퍼 Squirt Day 입니다!!!|r";
    ["SDH_SQUIRT_DAY"] = "|c%s|c%s오늘|r은 Squirt Day 입니다!|r";
    ["SDH_NEXT_SQUIRT"] = "|c%s다음 Squirt Day 는 |c%s{month}월 {day}일 {weekday}요일|r 에 있습니다.|r";
    ["SDH_NOT_SUPPORTED"] = "|c%s귀하의 지역은 슬프게도 지원되지 않습니다.|r";
    ["SDH_PET_TREAT"] = "애완 동물에게 치료를주십시오!!!";
    ["SDH_PET_HAT"] = "모자를 쓰십시오!!!";
    ["SDH_STATISTICS"] = "Squirt Day Helper: 지금까지 {battles} 개의 전투에서 {pets} 마리의 애왼 동물을 레벨링 했습니다.";

    -- Date Strings
    ["WEEKDAY_2"] = "월";
    ["WEEKDAY_3"] = "화";
    ["WEEKDAY_4"] = "수";
    ["WEEKDAY_5"] = "목";
    ["WEEKDAY_6"] = "금";
    ["WEEKDAY_7"] = "토";
    ["WEEKDAY_1"] = "일";
    ["MONTH_1"] = "1";
    ["MONTH_2"] = "2";
    ["MONTH_3"] = "3";
    ["MONTH_4"] = "4";
    ["MONTH_5"] = "5";
    ["MONTH_6"] = "6";
    ["MONTH_7"] = "7";
    ["MONTH_8"] = "8";
    ["MONTH_9"] = "9";
    ["MONTH_10"] = "10";
    ["MONTH_11"] = "11";
    ["MONTH_12"] = "12";
})
do L[key] = value; end
