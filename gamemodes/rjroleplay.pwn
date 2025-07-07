/*
================================================================================
                    RIO DE JANEIRO ROLEPLAY - SA-MP GAMEMODE
================================================================================
    Servidor RolePlay brasileiro inspirado no Rio de Janeiro
    Desenvolvido com sistemas avançados e realistas
    
    Recursos:
    - Sistema de HUD avançado (fome, sede, energia)
    - Inventário gráfico com Textdraw
    - Celular com VoIP e WhatsApp RP
    - Facções: CV, ADA, TCP, Milícia, PMERJ, BOPE, CORE, UPP
    - Sistema de economia dinâmica
    - Anti-cheat completo
    - Territórios com lucro passivo
    - Sistema de crafting
    - Integração com pagamentos (PIX, PagSeguro, PicPay)
================================================================================
*/

#include <a_samp>
#include <a_mysql>
#include <sscanf2>
#include <streamer>
#include <zcmd>
#include <YSI\y_ini>
#include <whirlpool>
#include <foreach>
#include <crashdetect>

// =============================================================================
// CONFIGURAÇÕES PRINCIPAIS
// =============================================================================

#define GAMEMODE_VERSION "1.0.0"
#define GAMEMODE_NAME "Rio de Janeiro RolePlay"

// Configurações do MySQL
#define MYSQL_HOST "localhost"
#define MYSQL_USER "root"
#define MYSQL_PASS "password"
#define MYSQL_BASE "rjroleplay"

// Configurações gerais
#define MAX_CHARACTERS 3
#define MAX_INVENTORY_SLOTS 20
#define MAX_PHONE_CONTACTS 50
#define MAX_TERRITORIES 50
#define MAX_BUSINESSES 100
#define MAX_HOUSES 500

// Cores das facções
#define COLOR_CV 0xFF0000FF
#define COLOR_ADA 0x00FF00FF
#define COLOR_TCP 0x0000FFFF
#define COLOR_MILICIA 0x8B4513FF
#define COLOR_PMERJ 0x000080FF
#define COLOR_BOPE 0x2F4F4FFF
#define COLOR_CORE 0x808080FF
#define COLOR_UPP 0x4169E1FF
#define COLOR_EXERCITO 0x228B22FF
#define COLOR_PCERJ 0x00008BFF
#define COLOR_PRF 0x483D8BFF

// Cores do sistema
#define COLOR_WHITE 0xFFFFFFFF
#define COLOR_RED 0xFF0000FF
#define COLOR_GREEN 0x00FF00FF
#define COLOR_BLUE 0x0000FFFF
#define COLOR_YELLOW 0xFFFF00FF
#define COLOR_ORANGE 0xFF8000FF
#define COLOR_GREY 0x808080FF
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_LIGHTGREEN 0x9ACD32AA

// =============================================================================
// ENUMERATORS
// =============================================================================

enum PlayerInfo {
    pID,
    pAccountID,
    pName[MAX_PLAYER_NAME],
    pPassword[129],
    pSalt[129],
    pEmail[100],
    pAge,
    pSex, // 0=Masculino, 1=Feminino
    pSkin,
    pMoney,
    pBankMoney,
    pLevel,
    pExp,
    Float:pPosX,
    Float:pPosY,
    Float:pPosZ,
    Float:pAngle,
    pInterior,
    pVirtualWorld,
    Float:pHealth,
    Float:pArmour,
    pHunger,
    pThirst,
    pEnergy,
    pFactionID,
    pFactionRank,
    pJobID,
    pPhoneNumber[15],
    pCPF[14],
    pRG[12],
    pCNH,
    pWeaponLicense,
    pJailTime,
    pWantedLevel,
    pHospitalTime,
    pAdminLevel,
    pVIPLevel,
    pVIPExpire,
    pCoins,
    pTotalHours,
    pBanned,
    pBanReason[128],
    pLastLogin,
    pRegistered,
    pLogged,
    pSpawned,
    pTutorial,
    
    // Sistema de HUD
    Text:pHUDMain,
    Text:pHUDMoney,
    Text:pHUDStats,
    
    // Sistema de inventário
    pInventoryOpen,
    pInventory[MAX_INVENTORY_SLOTS][3], // [item_id, quantity, slot]
    
    // Sistema de celular
    pPhoneOpen,
    pPhoneOnCall,
    pPhoneCallerID,
    Text:pPhoneScreen,
    
    // Anti-cheat
    pLastPosX,
    pLastPosY,
    pLastPosZ,
    pSpeedHackWarns,
    pTeleportWarns,
    pWeaponHackWarns,
    pMoneyHackWarns,
    
    // Outros sistemas
    pLastCommand[128],
    pLastChat[128],
    pAfkTime,
    pPlayingTime
};

enum FactionInfo {
    fID,
    fName[50],
    fType, // 0=Criminal, 1=Police, 2=Government
    fColor,
    fBank,
    fLeader,
    Float:fSpawnX,
    Float:fSpawnY,
    Float:fSpawnZ,
    Float:fSpawnAngle,
    fSpawnInterior,
    fSpawnVW,
    fMaxMembers,
    fMembers
};

enum VehicleInfo {
    vID,
    vOwnerID,
    vFactionID,
    vModel,
    Float:vPosX,
    Float:vPosY,
    Float:vPosZ,
    Float:vAngle,
    vColor1,
    vColor2,
    vInterior,
    vVirtualWorld,
    vPlate[8],
    Float:vFuel,
    vEngine,
    vLights,
    vAlarm,
    vLocked,
    vDamagePanels,
    vDamageDoors,
    vDamageLights,
    vDamageTires,
    vMods[17],
    vPaintjob,
    vImpounded,
    vImpoundPrice,
    vInsurance,
    vSAMPID
};

enum ItemInfo {
    iID,
    iName[50],
    iModel,
    iType, // 1=Weapon, 2=Food, 3=Drink, 4=Drug, 5=Tool, 6=Document
    iMaxStack,
    Float:iWeight,
    iPrice,
    iCraftable,
    iDescription[128]
};

enum TerritoryInfo {
    tID,
    tFactionID,
    tName[50],
    Float:tMinX,
    Float:tMinY,
    Float:tMaxX,
    Float:tMaxY,
    tColor,
    tMoneyPerHour,
    tDrugProduction,
    tLastCollect,
    tGangZone
};

// =============================================================================
// VARIÁVEIS GLOBAIS
// =============================================================================

new MySQL:gMySQL;
new gPlayerInfo[MAX_PLAYERS][PlayerInfo];
new gFactionInfo[20][FactionInfo];
new gVehicleInfo[2000][VehicleInfo];
new gItemInfo[200][ItemInfo];
new gTerritoryInfo[MAX_TERRITORIES][TerritoryInfo];

new gServerUptime;
new gPlayersOnline;
new gEconomyInflation = 100; // 100 = sem inflação

// Textdraws globais
new Text:gServerLogo;
new Text:gWelcomeText;
new Text:gOnlinePlayersText;

// Timers
new gHUDTimer;
new gAntiCheatTimer;
new gEconomyTimer;
new gTerritoryTimer;

// Sistema de login
new gLoginStep[MAX_PLAYERS];
new gLoginAttempts[MAX_PLAYERS];
new gRegistrationStep[MAX_PLAYERS];

// =============================================================================
// CALLBACKS PRINCIPAIS
// =============================================================================

public OnGameModeInit() {
    print("\n====================================");
    print(" RIO DE JANEIRO ROLEPLAY - LOADING");
    print("====================================");
    
    // Conectando ao MySQL
    gMySQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_BASE, MYSQL_PASS);
    if(mysql_errno(gMySQL) != 0) {
        print("ERRO: Falha na conexão com MySQL!");
        SendRconCommand("exit");
        return 1;
    }
    print("✓ MySQL conectado com sucesso!");
    
    // Configurações do servidor
    SetGameModeText("RJ RolePlay v1.0");
    SendRconCommand("mapname Rio de Janeiro");
    SendRconCommand("weburl www.rjroleplay.com.br");
    SendRconCommand("language Português BR");
    
    // Carregando dados
    LoadFactions();
    LoadItems();
    LoadVehicles();
    LoadTerritories();
    LoadBusinesses();
    LoadHouses();
    
    // Criando textdraws globais
    CreateGlobalTextdraws();
    
    // Iniciando timers
    gHUDTimer = SetTimer("UpdateHUD", 1000, true);
    gAntiCheatTimer = SetTimer("AntiCheatCheck", 500, true);
    gEconomyTimer = SetTimer("EconomyUpdate", 300000, true); // 5 minutos
    gTerritoryTimer = SetTimer("TerritoryUpdate", 60000, true); // 1 minuto
    
    // Configurações do mundo
    DisableInteriorEnterExits();
    SetNameTagDrawDistance(40.0);
    ShowNameTags(1);
    ShowPlayerMarkers(0);
    LimitGlobalChatRadius(20.0);
    
    // Spawns de veículos das facções
    SpawnFactionVehicles();
    
    print("✓ Servidor inicializado com sucesso!");
    print("====================================\n");
    return 1;
}

public OnGameModeExit() {
    print("====================================");
    print(" DESLIGANDO SERVIDOR");
    print("====================================");
    
    // Salvando dados de todos os players
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && gPlayerInfo[i][pLogged]) {
            SavePlayerData(i);
        }
    }
    
    // Destruindo timers
    KillTimer(gHUDTimer);
    KillTimer(gAntiCheatTimer);
    KillTimer(gEconomyTimer);
    KillTimer(gTerritoryTimer);
    
    // Fechando conexão MySQL
    mysql_close(gMySQL);
    
    print("✓ Servidor desligado com sucesso!");
    print("====================================");
    return 1;
}

public OnPlayerConnect(playerid) {
    // Resetando dados do player
    ResetPlayerData(playerid);
    
    // Verificando ban
    CheckPlayerBan(playerid);
    
    // Sistema anti-flood
    SetPVarInt(playerid, "LastConnect", gettime());
    
    // Mensagem de boas-vindas
    new string[256];
    format(string, sizeof(string), "{FFFFFF}Bem-vindo ao {00FF00}%s{FFFFFF}!", GAMEMODE_NAME);
    SendClientMessage(playerid, COLOR_WHITE, string);
    SendClientMessage(playerid, COLOR_YELLOW, "➤ Aguarde o carregamento dos dados...");
    
    // Verificando se tem conta
    CheckPlayerAccount(playerid);
    
    // Logs
    new playerName[MAX_PLAYER_NAME], playerIP[16];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    GetPlayerIp(playerid, playerIP, sizeof(playerIP));
    
    format(string, sizeof(string), "Player %s conectou de %s", playerName, playerIP);
    SaveLog("connect", playerName, playerIP, string);
    
    // Atualizando players online
    gPlayersOnline++;
    UpdateOnlinePlayersText();
    
    return 1;
}

public OnPlayerDisconnect(playerid, reason) {
    if(gPlayerInfo[playerid][pLogged]) {
        SavePlayerData(playerid);
        
        // Salvando posição
        GetPlayerPos(playerid, gPlayerInfo[playerid][pPosX], gPlayerInfo[playerid][pPosY], gPlayerInfo[playerid][pPosZ]);
        GetPlayerFacingAngle(playerid, gPlayerInfo[playerid][pAngle]);
        gPlayerInfo[playerid][pInterior] = GetPlayerInterior(playerid);
        gPlayerInfo[playerid][pVirtualWorld] = GetPlayerVirtualWorld(playerid);
        
        // Salvando vida e colete
        GetPlayerHealth(playerid, gPlayerInfo[playerid][pHealth]);
        GetPlayerArmour(playerid, gPlayerInfo[playerid][pArmour]);
    }
    
    // Logs de desconexão
    new playerName[MAX_PLAYER_NAME], playerIP[16], string[128];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    GetPlayerIp(playerid, playerIP, sizeof(playerIP));
    
    new reasonText[32];
    switch(reason) {
        case 0: reasonText = "Timeout/Crash";
        case 1: reasonText = "Saída normal";
        case 2: reasonText = "Kickado/Banido";
    }
    
    format(string, sizeof(string), "Player %s desconectou (%s)", playerName, reasonText);
    SaveLog("disconnect", playerName, playerIP, string);
    
    // Destruindo textdraws
    if(gPlayerInfo[playerid][pHUDMain] != Text:INVALID_TEXT_DRAW) {
        TextDrawDestroy(gPlayerInfo[playerid][pHUDMain]);
        TextDrawDestroy(gPlayerInfo[playerid][pHUDMoney]);
        TextDrawDestroy(gPlayerInfo[playerid][pHUDStats]);
    }
    
    // Resetando dados
    ResetPlayerData(playerid);
    
    // Atualizando players online
    gPlayersOnline--;
    UpdateOnlinePlayersText();
    
    return 1;
}

public OnPlayerSpawn(playerid) {
    if(!gPlayerInfo[playerid][pLogged]) return Kick(playerid);
    
    // Primeira vez spawning
    if(!gPlayerInfo[playerid][pSpawned]) {
        SetPlayerPos(playerid, 1680.3, -2324.8, 13.5); // Aeroporto (Galeão)
        SetPlayerFacingAngle(playerid, 90.0);
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);
        SetCameraBehindPlayer(playerid);
        
        // Tutorial para novos players
        if(!gPlayerInfo[playerid][pTutorial]) {
            StartTutorial(playerid);
        }
        
        gPlayerInfo[playerid][pSpawned] = 1;
    } else {
        // Spawn normal
        SetPlayerPos(playerid, gPlayerInfo[playerid][pPosX], gPlayerInfo[playerid][pPosY], gPlayerInfo[playerid][pPosZ]);
        SetPlayerFacingAngle(playerid, gPlayerInfo[playerid][pAngle]);
        SetPlayerInterior(playerid, gPlayerInfo[playerid][pInterior]);
        SetPlayerVirtualWorld(playerid, gPlayerInfo[playerid][pVirtualWorld]);
    }
    
    // Configurando vida e stats
    SetPlayerHealth(playerid, gPlayerInfo[playerid][pHealth]);
    SetPlayerArmour(playerid, gPlayerInfo[playerid][pArmour]);
    SetPlayerScore(playerid, gPlayerInfo[playerid][pLevel]);
    GivePlayerMoney(playerid, gPlayerInfo[playerid][pMoney]);
    
    // Criando HUD
    CreatePlayerHUD(playerid);
    
    // Skin da facção
    if(gPlayerInfo[playerid][pFactionID] > 0) {
        SetPlayerSkin(playerid, GetFactionSkin(gPlayerInfo[playerid][pFactionID], gPlayerInfo[playerid][pFactionRank]));
    } else {
        SetPlayerSkin(playerid, gPlayerInfo[playerid][pSkin]);
    }
    
    return 1;
}

// =============================================================================
// SISTEMA DE LOGIN E REGISTRO
// =============================================================================

stock CheckPlayerAccount(playerid) {
    new playerName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    
    new query[256];
    format(query, sizeof(query), "SELECT * FROM accounts WHERE username = '%s' LIMIT 1", playerName);
    mysql_tquery(gMySQL, query, "OnPlayerAccountCheck", "i", playerid);
}

forward OnPlayerAccountCheck(playerid);
public OnPlayerAccountCheck(playerid) {
    if(!IsPlayerConnected(playerid)) return 1;
    
    if(cache_num_rows() > 0) {
        // Conta existe - mostrar login
        ShowLoginDialog(playerid);
    } else {
        // Conta não existe - mostrar registro
        ShowRegisterDialog(playerid);
    }
    return 1;
}

stock ShowLoginDialog(playerid) {
    new playerName[MAX_PLAYER_NAME], string[512];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    
    format(string, sizeof(string), 
        "{FFFFFF}Olá {00FF00}%s{FFFFFF}!\n\n"
        "{FFFFFF}Sua conta foi encontrada em nosso banco de dados.\n"
        "{FFFFFF}Digite sua senha para fazer login:\n\n"
        "{FFFF00}➤ Digite sua senha abaixo:",
        playerName
    );
    
    ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, 
        "{00FF00}Rio de Janeiro RolePlay - Login", string, "Entrar", "Sair");
        
    gLoginStep[playerid] = 1;
}

stock ShowRegisterDialog(playerid) {
    new playerName[MAX_PLAYER_NAME], string[512];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    
    format(string, sizeof(string), 
        "{FFFFFF}Olá {00FF00}%s{FFFFFF}!\n\n"
        "{FFFFFF}Sua conta não foi encontrada em nosso banco de dados.\n"
        "{FFFFFF}Você precisa se registrar para jogar.\n\n"
        "{FFFF00}➤ Digite uma senha (mínimo 6 caracteres):",
        playerName
    );
    
    ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, 
        "{00FF00}Rio de Janeiro RolePlay - Registro", string, "Registrar", "Sair");
        
    gRegistrationStep[playerid] = 1;
}

// =============================================================================
// SISTEMA DE HUD
// =============================================================================

stock CreatePlayerHUD(playerid) {
    // HUD Principal
    gPlayerInfo[playerid][pHUDMain] = TextDrawCreate(498.000000, 110.000000, "box");
    TextDrawLetterSize(gPlayerInfo[playerid][pHUDMain], 0.000000, 10.000000);
    TextDrawTextSize(gPlayerInfo[playerid][pHUDMain], 640.000000, 0.000000);
    TextDrawAlignment(gPlayerInfo[playerid][pHUDMain], 1);
    TextDrawColor(gPlayerInfo[playerid][pHUDMain], -1);
    TextDrawUseBox(gPlayerInfo[playerid][pHUDMain], 1);
    TextDrawBoxColor(gPlayerInfo[playerid][pHUDMain], 0x000000AA);
    TextDrawSetShadow(gPlayerInfo[playerid][pHUDMain], 0);
    TextDrawSetOutline(gPlayerInfo[playerid][pHUDMain], 0);
    TextDrawBackgroundColor(gPlayerInfo[playerid][pHUDMain], 255);
    TextDrawFont(gPlayerInfo[playerid][pHUDMain], 1);
    TextDrawSetProportional(gPlayerInfo[playerid][pHUDMain], 1);
    TextDrawSetShadow(gPlayerInfo[playerid][pHUDMain], 0);
    
    // Dinheiro
    gPlayerInfo[playerid][pHUDMoney] = TextDrawCreate(510.000000, 115.000000, "R$ 0");
    TextDrawLetterSize(gPlayerInfo[playerid][pHUDMoney], 0.300000, 1.500000);
    TextDrawAlignment(gPlayerInfo[playerid][pHUDMoney], 1);
    TextDrawColor(gPlayerInfo[playerid][pHUDMoney], 0x00FF00FF);
    TextDrawSetShadow(gPlayerInfo[playerid][pHUDMoney], 0);
    TextDrawSetOutline(gPlayerInfo[playerid][pHUDMoney], 1);
    TextDrawBackgroundColor(gPlayerInfo[playerid][pHUDMoney], 255);
    TextDrawFont(gPlayerInfo[playerid][pHUDMoney], 1);
    TextDrawSetProportional(gPlayerInfo[playerid][pHUDMoney], 1);
    
    // Stats (Fome, Sede, Energia)
    gPlayerInfo[playerid][pHUDStats] = TextDrawCreate(510.000000, 135.000000, "Fome: 100%~n~Sede: 100%~n~Energia: 100%");
    TextDrawLetterSize(gPlayerInfo[playerid][pHUDStats], 0.250000, 1.000000);
    TextDrawAlignment(gPlayerInfo[playerid][pHUDStats], 1);
    TextDrawColor(gPlayerInfo[playerid][pHUDStats], 0xFFFFFFFF);
    TextDrawSetShadow(gPlayerInfo[playerid][pHUDStats], 0);
    TextDrawSetOutline(gPlayerInfo[playerid][pHUDStats], 1);
    TextDrawBackgroundColor(gPlayerInfo[playerid][pHUDStats], 255);
    TextDrawFont(gPlayerInfo[playerid][pHUDStats], 1);
    TextDrawSetProportional(gPlayerInfo[playerid][pHUDStats], 1);
    
    // Mostrando textdraws
    TextDrawShowForPlayer(playerid, gPlayerInfo[playerid][pHUDMain]);
    TextDrawShowForPlayer(playerid, gPlayerInfo[playerid][pHUDMoney]);
    TextDrawShowForPlayer(playerid, gPlayerInfo[playerid][pHUDStats]);
}

forward UpdateHUD();
public UpdateHUD() {
    new string[128];
    
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && gPlayerInfo[i][pLogged] && gPlayerInfo[i][pSpawned]) {
            // Atualizando dinheiro
            format(string, sizeof(string), "R$ %s", FormatNumber(gPlayerInfo[i][pMoney]));
            TextDrawSetString(gPlayerInfo[i][pHUDMoney], string);
            
            // Atualizando stats
            format(string, sizeof(string), "Fome: %d%%~n~Sede: %d%%~n~Energia: %d%%", 
                gPlayerInfo[i][pHunger], gPlayerInfo[i][pThirst], gPlayerInfo[i][pEnergy]);
            TextDrawSetString(gPlayerInfo[i][pHUDStats], string);
            
            // Diminuindo stats com o tempo
            if(GetTickCount() % 60000 == 0) { // A cada 1 minuto
                if(gPlayerInfo[i][pHunger] > 0) gPlayerInfo[i][pHunger]--;
                if(gPlayerInfo[i][pThirst] > 0) gPlayerInfo[i][pThirst]--;
                if(gPlayerInfo[i][pEnergy] > 0) gPlayerInfo[i][pEnergy]--;
                
                // Efeitos de stats baixos
                if(gPlayerInfo[i][pHunger] <= 10) {
                    new Float:health;
                    GetPlayerHealth(i, health);
                    if(health > 10.0) SetPlayerHealth(i, health - 5.0);
                    GameTextForPlayer(i, "~r~FOME CRITICA!", 3000, 5);
                }
                
                if(gPlayerInfo[i][pThirst] <= 10) {
                    new Float:health;
                    GetPlayerHealth(i, health);
                    if(health > 10.0) SetPlayerHealth(i, health - 3.0);
                    GameTextForPlayer(i, "~r~SEDE CRITICA!", 3000, 5);
                }
                
                if(gPlayerInfo[i][pEnergy] <= 10) {
                    SetPlayerDrunkLevel(i, 2000);
                    GameTextForPlayer(i, "~r~CANSACO EXTREMO!", 3000, 5);
                }
            }
        }
    }
    return 1;
}

// =============================================================================
// SISTEMA ANTI-CHEAT
// =============================================================================

forward AntiCheatCheck();
public AntiCheatCheck() {
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && gPlayerInfo[i][pLogged]) {
            // Speed hack check
            CheckSpeedHack(i);
            
            // Teleport hack check
            CheckTeleportHack(i);
            
            // Weapon hack check
            CheckWeaponHack(i);
            
            // Money hack check
            CheckMoneyHack(i);
            
            // Health hack check
            CheckHealthHack(i);
        }
    }
    return 1;
}

stock CheckSpeedHack(playerid) {
    if(IsPlayerInAnyVehicle(playerid)) return 1; // Ignorar se estiver em veículo
    
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    
    new Float:distance = GetDistanceBetweenPoints3D(
        gPlayerInfo[playerid][pLastPosX], 
        gPlayerInfo[playerid][pLastPosY], 
        gPlayerInfo[playerid][pLastPosZ], 
        x, y, z
    );
    
    if(distance > 50.0) { // Mais de 50 metros em 0.5 segundos
        gPlayerInfo[playerid][pSpeedHackWarns]++;
        
        if(gPlayerInfo[playerid][pSpeedHackWarns] >= 3) {
            new string[128];
            format(string, sizeof(string), "%s foi kickado por Speed Hack (Distância: %.2f)", GetPlayerNameEx(playerid), distance);
            SendClientMessageToAll(COLOR_RED, string);
            
            SaveLog("anticheat", GetPlayerNameEx(playerid), GetPlayerIPEx(playerid), string);
            
            BanPlayer(playerid, "Sistema Anti-Cheat", "Speed Hack detectado");
            return 1;
        }
        
        // Teleportar de volta para posição anterior
        SetPlayerPos(playerid, gPlayerInfo[playerid][pLastPosX], gPlayerInfo[playerid][pLastPosY], gPlayerInfo[playerid][pLastPosZ]);
        SendClientMessage(playerid, COLOR_RED, "ANTI-CHEAT: Speed hack detectado! Aviso: %d/3", gPlayerInfo[playerid][pSpeedHackWarns]);
    }
    
    // Salvando posição atual
    gPlayerInfo[playerid][pLastPosX] = x;
    gPlayerInfo[playerid][pLastPosY] = y;
    gPlayerInfo[playerid][pLastPosZ] = z;
    
    return 1;
}

stock CheckTeleportHack(playerid) {
    // Implementar verificação de teleport
    return 1;
}

stock CheckWeaponHack(playerid) {
    // Verificar armas não autorizadas
    for(new i = 0; i < 13; i++) {
        new weapon, ammo;
        GetPlayerWeaponData(playerid, i, weapon, ammo);
        
        if(weapon > 0 && !IsPlayerAllowedWeapon(playerid, weapon)) {
            gPlayerInfo[playerid][pWeaponHackWarns]++;
            
            ResetPlayerWeapons(playerid);
            SendClientMessage(playerid, COLOR_RED, "ANTI-CHEAT: Weapon hack detectado! Aviso: %d/3", gPlayerInfo[playerid][pWeaponHackWarns]);
            
            if(gPlayerInfo[playerid][pWeaponHackWarns] >= 3) {
                new string[128];
                format(string, sizeof(string), "%s foi kickado por Weapon Hack (Arma: %d)", GetPlayerNameEx(playerid), weapon);
                SendClientMessageToAll(COLOR_RED, string);
                
                BanPlayer(playerid, "Sistema Anti-Cheat", "Weapon Hack detectado");
                return 1;
            }
        }
    }
    return 1;
}

stock CheckMoneyHack(playerid) {
    new currentMoney = GetPlayerMoney(playerid);
    if(currentMoney != gPlayerInfo[playerid][pMoney]) {
        // Money hack detectado
        ResetPlayerMoney(playerid);
        GivePlayerMoney(playerid, gPlayerInfo[playerid][pMoney]);
        
        gPlayerInfo[playerid][pMoneyHackWarns]++;
        SendClientMessage(playerid, COLOR_RED, "ANTI-CHEAT: Money hack detectado! Aviso: %d/3", gPlayerInfo[playerid][pMoneyHackWarns]);
        
        if(gPlayerInfo[playerid][pMoneyHackWarns] >= 3) {
            new string[128];
            format(string, sizeof(string), "%s foi kickado por Money Hack", GetPlayerNameEx(playerid));
            SendClientMessageToAll(COLOR_RED, string);
            
            BanPlayer(playerid, "Sistema Anti-Cheat", "Money Hack detectado");
            return 1;
        }
    }
    return 1;
}

stock CheckHealthHack(playerid) {
    new Float:health;
    GetPlayerHealth(playerid, health);
    
    if(health > 100.0) {
        SetPlayerHealth(playerid, 100.0);
        SendClientMessage(playerid, COLOR_RED, "ANTI-CHEAT: Health hack detectado!");
        
        new string[128];
        format(string, sizeof(string), "%s foi detectado com Health Hack (Vida: %.1f)", GetPlayerNameEx(playerid), health);
        SaveLog("anticheat", GetPlayerNameEx(playerid), GetPlayerIPEx(playerid), string);
    }
    return 1;
}

// Continuando na próxima parte...

#define DIALOG_LOGIN 1
#define DIALOG_REGISTER 2
#define DIALOG_EMAIL 3
#define DIALOG_AGE 4
#define DIALOG_SEX 5
#define DIALOG_PHONE 6
#define DIALOG_INVENTORY 7
#define DIALOG_CRAFT 8
#define DIALOG_BUSINESS 9
#define DIALOG_HOUSE 10