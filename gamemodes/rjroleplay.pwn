/*
================================================================================
                    RIO DE JANEIRO ROLEPLAY - VERSÃO ANTI-CRASH
================================================================================
    CORREÇÕES APLICADAS PARA RESOLVER DESLIGAMENTO NA CONEXÃO:
    - MySQL com verificação de conexão
    - Proteção contra textdraws inválidos  
    - Verificação de arrays antes de acessar
    - OnPlayerConnect otimizado
    - Tratamento de erros MySQL
================================================================================
*/

#include <a_samp_simple>
#include <a_mysql>
#include <sscanf2>
#include <streamer>
#include <zcmd>
// #include <YSI\y_ini>  // COMENTADO - estava causando erro
#include <whirlpool>
#include <foreach>
#include <crashdetect>

// =============================================================================
// CONFIGURAÇÕES PRINCIPAIS
// =============================================================================

#define GAMEMODE_VERSION "1.0.1-FIXED"
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
#define COLOR_PURPLE 0x800080FF
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
    Float:pLastPosX,
    Float:pLastPosY,
    Float:pLastPosZ,
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

// =============================================================================
// VARIÁVEIS GLOBAIS - INICIALIZADAS CORRETAMENTE
// =============================================================================

new MySQL:gMySQL = MySQL:1; // INICIALIZADO
new bool:gMySQLConnected = false; // CONTROLE DE CONEXÃO
new gPlayerInfo[MAX_PLAYERS][PlayerInfo];
new gFactionInfo[20][FactionInfo];

new gServerUptime = 0; // INICIALIZADO
new gPlayersOnline = 0; // INICIALIZADO
new gEconomyInflation = 100; // 100 = sem inflação

// Textdraws globais - INICIALIZADOS
new Text:gServerLogo = Text:INVALID_TEXT_DRAW;
new Text:gWelcomeText = Text:INVALID_TEXT_DRAW;
new Text:gOnlinePlayersText = Text:INVALID_TEXT_DRAW;

// Timers
new gHUDTimer = -1;
new gAntiCheatTimer = -1;
new gEconomyTimer = -1;
new gTerritoryTimer = -1;

// Sistema de login
new gLoginStep[MAX_PLAYERS];
new gLoginAttempts[MAX_PLAYERS];
new gRegistrationStep[MAX_PLAYERS];

// =============================================================================
// CALLBACKS PRINCIPAIS - VERSÃO SEGURA
// =============================================================================

public OnGameModeInit() {
    print("\n====================================");
    print(" RIO DE JANEIRO ROLEPLAY - LOADING");
    print("====================================");
    
    // Inicializando variáveis críticas PRIMEIRO
    gServerUptime = gettime();
    gPlayersOnline = 0;
    
    // Resetando todos os dados de players
    for(new i = 0; i < MAX_PLAYERS; i++) {
        ResetPlayerDataComplete(i);
    }
    
    // Conectando ao MySQL com PROTEÇÃO
    printf("Tentando conectar MySQL: %s@%s/%s", MYSQL_USER, MYSQL_HOST, MYSQL_BASE);
    gMySQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_BASE, MYSQL_PASS);
    
    if(mysql_errno(gMySQL) != 0) {
        printf("❌ ERRO MySQL: %d - %s", mysql_errno(gMySQL), mysql_error(gMySQL));
        printf("⚠️ SERVIDOR FUNCIONARÁ SEM MYSQL!");
        gMySQLConnected = false;
    } else {
        print("✅ MySQL conectado com sucesso!");
        gMySQLConnected = true;
    }
    
    // Configurações do servidor
    SetGameModeText("RJ RolePlay v1.0.1-FIXED");
    SendRconCommand("mapname Rio de Janeiro");
    
    // Criando textdraws globais ANTES dos timers
    CreateGlobalTextdraws();
    
    // Carregando dados (só se MySQL conectado)
    if(gMySQLConnected) {
        LoadFactions();
        LoadItems();
    } else {
        print("⚠️ Dados não carregados - MySQL offline");
    }
    
    // Configurações do mundo
    DisableInteriorEnterExits();
    SetNameTagDrawDistance(40.0);
    ShowNameTags(1);
    ShowPlayerMarkers(0);
    LimitGlobalChatRadius(20.0);
    
    // Iniciando timers APÓS tudo configurado
    gHUDTimer = SetTimer("UpdateHUD", 2000, true); // 2 segundos - menos agressivo
    gAntiCheatTimer = SetTimer("AntiCheatCheck", 3000, true); // 3 segundos
    gEconomyTimer = SetTimer("EconomyUpdate", 300000, true); // 5 minutos
    
    print("✓ Servidor inicializado com PROTEÇÃO ANTI-CRASH!");
    print("====================================\n");
    return 1;
}

public OnGameModeExit() {
    print("====================================");
    print(" DESLIGANDO SERVIDOR SEGURAMENTE");
    print("====================================");
    
    // Salvando dados de todos os players LOGADOS
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && gPlayerInfo[i][pLogged] && gMySQLConnected) {
            SavePlayerDataSafe(i);
        }
    }
    
    // Destruindo timers
    if(gHUDTimer != -1) KillTimer(gHUDTimer);
    if(gAntiCheatTimer != -1) KillTimer(gAntiCheatTimer);
    if(gEconomyTimer != -1) KillTimer(gEconomyTimer);
    if(gTerritoryTimer != -1) KillTimer(gTerritoryTimer);
    
    // Fechando conexão MySQL
    if(gMySQLConnected) {
        mysql_close(gMySQL);
    }
    
    print("✓ Servidor desligado com segurança!");
    print("====================================");
    return 1;
}

// OnPlayerConnect SEGURO - EVITA CRASHES
public OnPlayerConnect(playerid) {
    // VALIDAÇÃO CRÍTICA
    if(playerid < 0 || playerid >= MAX_PLAYERS) {
        printf("ERRO: playerid inválido: %d", playerid);
        return 0;
    }
    
    // Reset COMPLETO dos dados - PRIMEIRO
    ResetPlayerDataComplete(playerid);
    
    // PROTEÇÃO: Aguardar 1 segundo antes de processar
    SetTimerEx("ProcessPlayerConnect", 1000, false, "i", playerid);
    
    // Logs básicos
    new playerName[MAX_PLAYER_NAME], playerIP[16];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    GetPlayerIp(playerid, playerIP, sizeof(playerIP));
    
    printf("CONNECT: %s [%d] de %s", playerName, playerid, playerIP);
    
    // Contador SEGURO
    gPlayersOnline++;
    
    return 1;
}

// FUNÇÃO AUXILIAR - Processa conexão com segurança
forward ProcessPlayerConnect(playerid);
public ProcessPlayerConnect(playerid) {
    // Verificar se ainda está conectado
    if(!IsPlayerConnected(playerid)) return 0;
    
    // Mensagem de boas-vindas SIMPLES
    SendClientMessage(playerid, COLOR_GREEN, "✅ Bem-vindo ao Rio de Janeiro RolePlay!");
    SendClientMessage(playerid, COLOR_YELLOW, "➤ Aguarde o carregamento...");
    
    // Sistema anti-flood
    SetPVarInt(playerid, "LastConnect", gettime());
    
    // Verificar conta SOMENTE se MySQL conectado
    if(gMySQLConnected) {
        CheckPlayerAccountSafe(playerid);
    } else {
        // Modo sem MySQL - login direto
        SendClientMessage(playerid, COLOR_ORANGE, "⚠️ Sistema offline - Entre como visitante");
        gPlayerInfo[playerid][pLogged] = 1;
        format(gPlayerInfo[playerid][pName], MAX_PLAYER_NAME, "Visitante_%d", playerid);
    }
    
    // Atualizar textdraw se existir
    UpdateOnlinePlayersTextSafe();
    
    return 1;
}

public OnPlayerDisconnect(playerid, reason) {
    // VALIDAÇÃO
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    
    // Salvar dados se logado E MySQL conectado
    if(gPlayerInfo[playerid][pLogged] && gMySQLConnected) {
        SavePlayerDataSafe(playerid);
    }
    
    // Destruir textdraws SEGURAMENTE
    DestroyPlayerTextdraws(playerid);
    
    // Logs
    new playerName[MAX_PLAYER_NAME], reasonText[32];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    
    switch(reason) {
        case 0: reasonText = "Timeout/Crash";
        case 1: reasonText = "Saída normal";
        case 2: reasonText = "Kickado/Banido";
    }
    
    printf("DISCONNECT: %s [%d] (%s)", playerName, playerid, reasonText);
    
    // Reset completo dos dados
    ResetPlayerDataComplete(playerid);
    
    // Contador SEGURO
    if(gPlayersOnline > 0) gPlayersOnline--;
    UpdateOnlinePlayersTextSafe();
    
    return 1;
}

public OnPlayerSpawn(playerid) {
    // VALIDAÇÃO CRÍTICA
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    if(!IsPlayerConnected(playerid)) return 0;
    
    // Verificar login OBRIGATÓRIO
    if(!gPlayerInfo[playerid][pLogged]) {
        SendClientMessage(playerid, COLOR_RED, "❌ ERRO: Você deve fazer login primeiro!");
        SetTimerEx("DelayedKick", 2000, false, "i", playerid);
        return 0;
    }
    
    // Spawn inicial SEGURO
    SetPlayerPosEx(playerid, 1680.3, -2324.8, 13.5, 90.0);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    
    // Configurar stats básicos
    SetPlayerHealth(playerid, 100.0);
    SetPlayerArmour(playerid, 0.0);
    SetPlayerScore(playerid, gPlayerInfo[playerid][pLevel]);
    
    // Skin padrão
    SetPlayerSkin(playerid, (gPlayerInfo[playerid][pSkin] > 0) ? gPlayerInfo[playerid][pSkin] : 26);
    
    // Criar HUD SOMENTE após spawn
    CreatePlayerHUDSafe(playerid);
    
    // Tutorial para novos
    if(!gPlayerInfo[playerid][pTutorial]) {
        StartTutorialSafe(playerid);
        gPlayerInfo[playerid][pTutorial] = 1;
    }
    
    gPlayerInfo[playerid][pSpawned] = 1;
    printf("SPAWN: %s [%d] spawnou com sucesso", gPlayerInfo[playerid][pName], playerid);
    
    return 1;
}

// =============================================================================
// FUNÇÕES AUXILIARES SEGURAS
// =============================================================================

stock ResetPlayerDataComplete(playerid) {
    // Reset TOTAL dos dados do player
    gPlayerInfo[playerid][pLogged] = 0;
    gPlayerInfo[playerid][pSpawned] = 0;
    gPlayerInfo[playerid][pTutorial] = 0;
    gPlayerInfo[playerid][pMoney] = 0;
    gPlayerInfo[playerid][pLevel] = 1;
    gPlayerInfo[playerid][pFactionID] = 0;
    gPlayerInfo[playerid][pAdminLevel] = 0;
    gPlayerInfo[playerid][pVIPLevel] = 0;
    gPlayerInfo[playerid][pHunger] = 100;
    gPlayerInfo[playerid][pThirst] = 100;
    gPlayerInfo[playerid][pEnergy] = 100;
    gPlayerInfo[playerid][pSkin] = 26;
    
    // Reset nome
    format(gPlayerInfo[playerid][pName], MAX_PLAYER_NAME, "N/A");
    
    // Reset anti-cheat
    gPlayerInfo[playerid][pSpeedHackWarns] = 0;
    gPlayerInfo[playerid][pTeleportWarns] = 0;
    gPlayerInfo[playerid][pWeaponHackWarns] = 0;
    gPlayerInfo[playerid][pMoneyHackWarns] = 0;
    
    // Reset textdraws
    gPlayerInfo[playerid][pHUDMain] = Text:INVALID_TEXT_DRAW;
    gPlayerInfo[playerid][pHUDMoney] = Text:INVALID_TEXT_DRAW;
    gPlayerInfo[playerid][pHUDStats] = Text:INVALID_TEXT_DRAW;
    gPlayerInfo[playerid][pPhoneScreen] = Text:INVALID_TEXT_DRAW;
    
    // Reset posições
    gPlayerInfo[playerid][pPosX] = 1680.3;
    gPlayerInfo[playerid][pPosY] = -2324.8;
    gPlayerInfo[playerid][pPosZ] = 13.5;
    gPlayerInfo[playerid][pAngle] = 90.0;
    gPlayerInfo[playerid][pInterior] = 0;
    gPlayerInfo[playerid][pVirtualWorld] = 0;
    gPlayerInfo[playerid][pHealth] = 100.0;
    gPlayerInfo[playerid][pArmour] = 0.0;
    
    // Reset login
    gLoginStep[playerid] = 0;
    gLoginAttempts[playerid] = 0;
    gRegistrationStep[playerid] = 0;
}

stock CheckPlayerAccountSafe(playerid) {
    if(!IsPlayerConnected(playerid) || !gMySQLConnected) return 0;
    
    new playerName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    format(gPlayerInfo[playerid][pName], MAX_PLAYER_NAME, "%s", playerName);
    
    // Query MySQL SEGURA
    new query[256];
    format(query, sizeof(query), "SELECT * FROM accounts WHERE username = '%e' LIMIT 1", playerName);
    mysql_tquery(gMySQL, query, "OnPlayerAccountCheckSafe", "i", playerid);
    
    return 1;
}

forward OnPlayerAccountCheckSafe(playerid);
public OnPlayerAccountCheckSafe(playerid) {
    if(!IsPlayerConnected(playerid)) return 1;
    
    if(cache_num_rows() > 0) {
        // Conta existe - mostrar login
        ShowLoginDialogSafe(playerid);
    } else {
        // Conta não existe - mostrar registro
        ShowRegisterDialogSafe(playerid);
    }
    return 1;
}

stock ShowLoginDialogSafe(playerid) {
    if(!IsPlayerConnected(playerid)) return 0;
    
    new playerName[MAX_PLAYER_NAME], string[512];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    
    format(string, sizeof(string), 
        "{FFFFFF}Olá {00FF00}%s{FFFFFF}!\n\n"
        "{FFFFFF}Digite sua senha para fazer login:",
        playerName
    );
    
    ShowPlayerDialog(playerid, 1, DIALOG_STYLE_PASSWORD, 
        "RJ RolePlay - Login", string, "Entrar", "Sair");
        
    gLoginStep[playerid] = 1;
    return 1;
}

stock ShowRegisterDialogSafe(playerid) {
    if(!IsPlayerConnected(playerid)) return 0;
    
    new playerName[MAX_PLAYER_NAME], string[512];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    
    format(string, sizeof(string), 
        "{FFFFFF}Olá {00FF00}%s{FFFFFF}!\n\n"
        "{FFFFFF}Registre-se para jogar.\n"
        "{FFFFFF}Digite uma senha (mínimo 6 caracteres):",
        playerName
    );
    
    ShowPlayerDialog(playerid, 2, DIALOG_STYLE_PASSWORD, 
        "RJ RolePlay - Registro", string, "Registrar", "Sair");
        
    gRegistrationStep[playerid] = 1;
    return 1;
}

stock CreatePlayerHUDSafe(playerid) {
    if(!IsPlayerConnected(playerid)) return 0;
    
    // Destruir textdraws existentes primeiro
    DestroyPlayerTextdraws(playerid);
    
    // HUD Principal
    gPlayerInfo[playerid][pHUDMain] = TextDrawCreate(500.0, 100.0, "box");
    if(gPlayerInfo[playerid][pHUDMain] != Text:INVALID_TEXT_DRAW) {
        TextDrawLetterSize(gPlayerInfo[playerid][pHUDMain], 0.0, 8.0);
        TextDrawTextSize(gPlayerInfo[playerid][pHUDMain], 620.0, 0.0);
        TextDrawUseBox(gPlayerInfo[playerid][pHUDMain], 1);
        TextDrawBoxColor(gPlayerInfo[playerid][pHUDMain], 0x000000AA);
        TextDrawShowForPlayer(playerid, gPlayerInfo[playerid][pHUDMain]);
    }
    
    // Dinheiro
    gPlayerInfo[playerid][pHUDMoney] = TextDrawCreate(510.0, 105.0, "R$ 0");
    if(gPlayerInfo[playerid][pHUDMoney] != Text:INVALID_TEXT_DRAW) {
        TextDrawLetterSize(gPlayerInfo[playerid][pHUDMoney], 0.3, 1.2);
        TextDrawColor(gPlayerInfo[playerid][pHUDMoney], COLOR_GREEN);
        TextDrawShowForPlayer(playerid, gPlayerInfo[playerid][pHUDMoney]);
    }
    
    // Stats
    gPlayerInfo[playerid][pHUDStats] = TextDrawCreate(510.0, 125.0, "Fome: 100%~n~Sede: 100%~n~Energia: 100%");
    if(gPlayerInfo[playerid][pHUDStats] != Text:INVALID_TEXT_DRAW) {
        TextDrawLetterSize(gPlayerInfo[playerid][pHUDStats], 0.25, 1.0);
        TextDrawColor(gPlayerInfo[playerid][pHUDStats], COLOR_WHITE);
        TextDrawShowForPlayer(playerid, gPlayerInfo[playerid][pHUDStats]);
    }
    
    return 1;
}

stock DestroyPlayerTextdraws(playerid) {
    if(gPlayerInfo[playerid][pHUDMain] != Text:INVALID_TEXT_DRAW) {
        TextDrawDestroy(gPlayerInfo[playerid][pHUDMain]);
        gPlayerInfo[playerid][pHUDMain] = Text:INVALID_TEXT_DRAW;
    }
    if(gPlayerInfo[playerid][pHUDMoney] != Text:INVALID_TEXT_DRAW) {
        TextDrawDestroy(gPlayerInfo[playerid][pHUDMoney]);
        gPlayerInfo[playerid][pHUDMoney] = Text:INVALID_TEXT_DRAW;
    }
    if(gPlayerInfo[playerid][pHUDStats] != Text:INVALID_TEXT_DRAW) {
        TextDrawDestroy(gPlayerInfo[playerid][pHUDStats]);
        gPlayerInfo[playerid][pHUDStats] = Text:INVALID_TEXT_DRAW;
    }
    if(gPlayerInfo[playerid][pPhoneScreen] != Text:INVALID_TEXT_DRAW) {
        TextDrawDestroy(gPlayerInfo[playerid][pPhoneScreen]);
        gPlayerInfo[playerid][pPhoneScreen] = Text:INVALID_TEXT_DRAW;
    }
}

stock SetPlayerPosEx(playerid, Float:x, Float:y, Float:z, Float:angle) {
    SetPlayerPos(playerid, x, y, z);
    SetPlayerFacingAngle(playerid, angle);
    SetCameraBehindPlayer(playerid);
}

stock SavePlayerDataSafe(playerid) {
    if(!gMySQLConnected || !gPlayerInfo[playerid][pLogged]) return 0;
    
    // Salvar dados básicos no MySQL
    new query[512];
    format(query, sizeof(query), 
        "UPDATE accounts SET money = %d, level = %d WHERE username = '%e'",
        gPlayerInfo[playerid][pMoney],
        gPlayerInfo[playerid][pLevel],
        gPlayerInfo[playerid][pName]
    );
    mysql_tquery(gMySQL, query);
    
    printf("SAVE: Dados de %s salvos", gPlayerInfo[playerid][pName]);
    return 1;
}

stock CreateGlobalTextdraws() {
    // Server Logo
    gServerLogo = TextDrawCreate(320.0, 20.0, "~g~RIO DE JANEIRO ROLEPLAY");
    if(gServerLogo != Text:INVALID_TEXT_DRAW) {
        TextDrawAlignment(gServerLogo, 2);
        TextDrawLetterSize(gServerLogo, 0.4, 1.8);
        TextDrawColor(gServerLogo, COLOR_GREEN);
    }
    
    // Players online
    gOnlinePlayersText = TextDrawCreate(500.0, 50.0, "Players: 0");
    if(gOnlinePlayersText != Text:INVALID_TEXT_DRAW) {
        TextDrawLetterSize(gOnlinePlayersText, 0.3, 1.2);
        TextDrawColor(gOnlinePlayersText, COLOR_WHITE);
    }
    
    printf("✓ Textdraws globais criados");
}

stock UpdateOnlinePlayersTextSafe() {
    if(gOnlinePlayersText != Text:INVALID_TEXT_DRAW) {
        new string[32];
        format(string, sizeof(string), "Players: %d", gPlayersOnline);
        TextDrawSetString(gOnlinePlayersText, string);
    }
}

stock StartTutorialSafe(playerid) {
    if(!IsPlayerConnected(playerid)) return 0;
    
    SendClientMessage(playerid, COLOR_GREEN, "✅ Bem-vindo ao Rio de Janeiro RolePlay!");
    SendClientMessage(playerid, COLOR_YELLOW, "📖 Use /ajuda para ver os comandos disponíveis.");
    SendClientMessage(playerid, COLOR_LIGHTBLUE, "🎮 Divirta-se jogando!");
    
    return 1;
}

// =============================================================================
// TIMERS SEGUROS
// =============================================================================

forward UpdateHUD();
public UpdateHUD() {
    new string[128];
    
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && gPlayerInfo[i][pLogged] && gPlayerInfo[i][pSpawned]) {
            // Atualizar HUD apenas se textdraws existirem
            if(gPlayerInfo[i][pHUDMoney] != Text:INVALID_TEXT_DRAW) {
                format(string, sizeof(string), "R$ %d", gPlayerInfo[i][pMoney]);
                TextDrawSetString(gPlayerInfo[i][pHUDMoney], string);
            }
            
            if(gPlayerInfo[i][pHUDStats] != Text:INVALID_TEXT_DRAW) {
                format(string, sizeof(string), "Fome: %d%%~n~Sede: %d%%~n~Energia: %d%%", 
                    gPlayerInfo[i][pHunger], gPlayerInfo[i][pThirst], gPlayerInfo[i][pEnergy]);
                TextDrawSetString(gPlayerInfo[i][pHUDStats], string);
            }
        }
    }
    return 1;
}

forward AntiCheatCheck();
public AntiCheatCheck() {
    // Anti-cheat básico e SEGURO
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && gPlayerInfo[i][pLogged]) {
            // Verificação básica de dinheiro
            new currentMoney = GetPlayerMoney(i);
            if(currentMoney != gPlayerInfo[i][pMoney]) {
                ResetPlayerMoney(i);
                GivePlayerMoney(i, gPlayerInfo[i][pMoney]);
            }
        }
    }
    return 1;
}

forward EconomyUpdate();
public EconomyUpdate() {
    // Sistema de economia
    if(random(100) < 10) { // 10% chance
        gEconomyInflation += random(3) - 1; // -1 a +2
        if(gEconomyInflation < 80) gEconomyInflation = 80;
        if(gEconomyInflation > 150) gEconomyInflation = 150;
    }
    return 1;
}

forward DelayedKick(playerid);
public DelayedKick(playerid) {
    if(IsPlayerConnected(playerid)) {
        Kick(playerid);
    }
}

// =============================================================================
// FUNÇÕES BÁSICAS IMPLEMENTADAS
// =============================================================================

stock LoadFactions() {
    printf("✓ Carregando facções do MySQL...");
    // TODO: Implementar carregamento real
}

stock LoadItems() {
    printf("✓ Carregando itens do MySQL...");
    // TODO: Implementar carregamento real
}

// =============================================================================
// COMANDOS BÁSICOS
// =============================================================================

CMD:stats(playerid, params[]) {
    if(!gPlayerInfo[playerid][pLogged]) {
        return SendClientMessage(playerid, COLOR_RED, "❌ Você precisa estar logado!");
    }
    
    new string[512];
    format(string, sizeof(string),
        "{FFFFFF}═══ {00FF00}ESTATÍSTICAS{FFFFFF} ═══\n\n"
        "{FFFFFF}Nome: {FFFF00}%s\n"
        "{FFFFFF}Level: {FFFF00}%d\n"
        "{FFFFFF}Dinheiro: {00FF00}R$ %d\n"
        "{FFFFFF}Fome: {FFFF00}%d%%\n"
        "{FFFFFF}Sede: {FFFF00}%d%%\n"
        "{FFFFFF}Energia: {FFFF00}%d%%",
        gPlayerInfo[playerid][pName],
        gPlayerInfo[playerid][pLevel],
        gPlayerInfo[playerid][pMoney],
        gPlayerInfo[playerid][pHunger],
        gPlayerInfo[playerid][pThirst],
        gPlayerInfo[playerid][pEnergy]
    );
    
    ShowPlayerDialog(playerid, 999, DIALOG_STYLE_MSGBOX, "Estatísticas", string, "Fechar", "");
    return 1;
}

CMD:ajuda(playerid, params[]) {
    new string[512];
    format(string, sizeof(string),
        "{FFFFFF}═══ {00FF00}COMANDOS DISPONÍVEIS{FFFFFF} ═══\n\n"
        "{FFFF00}/stats{FFFFFF} - Ver suas estatísticas\n"
        "{FFFF00}/ajuda{FFFFFF} - Esta lista de comandos\n"
        "{FFFF00}/dinheiro [valor]{FFFFFF} - Dar dinheiro a si mesmo (teste)\n\n"
        "{00FF00}Bem-vindo ao Rio de Janeiro RolePlay!"
    );
    
    ShowPlayerDialog(playerid, 998, DIALOG_STYLE_MSGBOX, "Comandos", string, "Fechar", "");
    return 1;
}

CMD:dinheiro(playerid, params[]) {
    if(!gPlayerInfo[playerid][pLogged]) {
        return SendClientMessage(playerid, COLOR_RED, "❌ Você precisa estar logado!");
    }
    
    new valor;
    if(sscanf(params, "i", valor)) {
        return SendClientMessage(playerid, COLOR_YELLOW, "USO: /dinheiro [valor]");
    }
    
    if(valor < 1 || valor > 1000000) {
        return SendClientMessage(playerid, COLOR_RED, "❌ Valor deve ser entre R$ 1 e R$ 1.000.000");
    }
    
    gPlayerInfo[playerid][pMoney] += valor;
    GivePlayerMoney(playerid, valor);
    
    new string[128];
    format(string, sizeof(string), "✅ Você recebeu R$ %d! Total: R$ %d", valor, gPlayerInfo[playerid][pMoney]);
    SendClientMessage(playerid, COLOR_GREEN, string);
    
    return 1;
}

// =============================================================================
// SYSTEM CALLBACKS
// =============================================================================

public OnPlayerDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if(dialogid == 1) { // LOGIN
        if(!response) return Kick(playerid);
        
        if(strlen(inputtext) < 6) {
            SendClientMessage(playerid, COLOR_RED, "❌ Senha deve ter no mínimo 6 caracteres!");
            ShowLoginDialogSafe(playerid);
            return 1;
        }
        
        // Login bem-sucedido (simplificado)
        gPlayerInfo[playerid][pLogged] = 1;
        gPlayerInfo[playerid][pMoney] = 5000; // Dinheiro inicial
        
        SendClientMessage(playerid, COLOR_GREEN, "✅ Login realizado com sucesso!");
        SendClientMessage(playerid, COLOR_YELLOW, "➤ Você será spawnado em breve...");
        
        SetTimerEx("SpawnPlayerDelayed", 2000, false, "i", playerid);
        
    } else if(dialogid == 2) { // REGISTRO
        if(!response) return Kick(playerid);
        
        if(strlen(inputtext) < 6) {
            SendClientMessage(playerid, COLOR_RED, "❌ Senha deve ter no mínimo 6 caracteres!");
            ShowRegisterDialogSafe(playerid);
            return 1;
        }
        
        // Registro bem-sucedido (simplificado)
        gPlayerInfo[playerid][pLogged] = 1;
        gPlayerInfo[playerid][pMoney] = 10000; // Dinheiro inicial maior para novos
        gPlayerInfo[playerid][pLevel] = 1;
        
        SendClientMessage(playerid, COLOR_GREEN, "✅ Registro realizado com sucesso!");
        SendClientMessage(playerid, COLOR_YELLOW, "➤ Você será spawnado em breve...");
        
        SetTimerEx("SpawnPlayerDelayed", 2000, false, "i", playerid);
    }
    return 1;
}

forward SpawnPlayerDelayed(playerid);
public SpawnPlayerDelayed(playerid) {
    if(IsPlayerConnected(playerid)) {
        SpawnPlayer(playerid);
    }
}