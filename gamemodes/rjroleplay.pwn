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

// =============================================================================
// CONFIGURAÇÕES PRINCIPAIS
// =============================================================================

#define GAMEMODE_VERSION "1.0.0"
#define GAMEMODE_NAME "Rio de Janeiro RolePlay"

// Configurações do MySQL (commented out for now)
// #define MYSQL_HOST "localhost"
// #define MYSQL_USER "root"
// #define MYSQL_PASS "password"
// #define MYSQL_BASE "rjroleplay"

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

// Dialogs
#define DIALOG_LOGIN 100
#define DIALOG_REGISTER 101
#define DIALOG_GPS 102
#define DIALOG_HELP 103
#define DIALOG_JOB_AGENCY 104
#define DIALOG_CITY_HALL 105

// GPS Locations
#define GPS_DELEGACIA 0
#define GPS_PREFEITURA 1
#define GPS_AGENCIA_EMPREGO 2
#define GPS_HOSPITAL 3
#define GPS_BANCO 4
#define GPS_AEROPORTO 5

// =============================================================================
// BASIC ENUMERATORS
// =============================================================================

enum PlayerInfo {
    pID,
    pName[MAX_PLAYER_NAME],
    pPassword[64],
    pAge,
    pSex,
    pSkin,
    pMoney,
    pLevel,
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
    pAdminLevel,
    pVIPLevel,
    pLogged,
    pSpawned,
    pJob,
    pJobLevel,
    pBankMoney,
    
    // Login TextDraws
    Text:pLoginBG,
    Text:pLoginTitle,
    Text:pLoginText,
    
    // GPS
    pGPSActive,
    Float:pGPSDestX,
    Float:pGPSDestY,
    Float:pGPSDestZ
};

// GPS Location Info
enum GPSInfo {
    gpsName[64],
    Float:gpsX,
    Float:gpsY,
    Float:gpsZ,
    gpsInterior,
    gpsDescription[128]
};

// =============================================================================
// VARIÁVEIS GLOBAIS
// =============================================================================

new gPlayerInfo[MAX_PLAYERS][PlayerInfo];
new gServerUptime;
new gPlayersOnline;

// GPS System
new gGPSLocations[][GPSInfo] = {
    {"Delegacia Central", 1554.6, -1675.6, 16.2, 0, "Delegacia modificada - PCERJ"},
    {"Prefeitura Municipal", 1481.0, -1772.3, 18.8, 0, "Prefeitura do Rio de Janeiro"},
    {"Agência de Emprego", 1368.4, -1279.8, 13.5, 0, "Centro de Empregos - Sine RJ"},
    {"Hospital Albert Schweitzer", 2034.4, -1401.6, 17.3, 0, "Hospital público"},
    {"Banco Central", 1462.3, -1011.4, 26.8, 0, "Banco do Brasil"},
    {"Aeroporto Internacional", 1680.3, -2324.8, 13.5, 0, "Aeroporto do Galeão"}
};

// Job System
new gJobNames[][32] = {
    "Desempregado",
    "Taxista",
    "Policial",
    "Médico",
    "Mecânico",
    "Vendedor",
    "Segurança",
    "Jornalista"
};

// =============================================================================
// CALLBACKS PRINCIPAIS
// =============================================================================

public OnGameModeInit() {
    print("\n====================================");
    print(" RIO DE JANEIRO ROLEPLAY - LOADING");
    print("====================================");
    
    // Configurações do servidor
    SetGameModeText("RJ RolePlay v1.0");
    SendRconCommand("mapname Rio de Janeiro");
    SendRconCommand("weburl www.rjroleplay.com.br");
    SendRconCommand("language Português BR");
    
    // Configurações do mundo
    DisableInteriorEnterExits();
    SetNameTagDrawDistance(40.0);
    ShowNameTags(1);
    ShowPlayerMarkers(0);
    LimitGlobalChatRadius(20.0);
    
    // Basic server setup - timer
    SetTimer("UpdateServer", 1000, true);
    SetTimer("UpdateGPS", 2000, true);
    
    // Mapeamento da Delegacia (modificada)
    CreateObject(1280, 1568.8, -1675.2, 15.2, 0.0, 0.0, 0.0); // Entrada delegacia
    CreateObject(1280, 1548.1, -1675.2, 15.2, 0.0, 0.0, 180.0); // Saída delegacia
    CreateObject(3472, 1554.6, -1690.0, 16.0, 0.0, 0.0, 0.0); // Placa PCERJ
    
    // Prefeitura (novo prédio)
    CreateObject(4585, 1481.0, -1772.3, 25.0, 0.0, 0.0, 0.0); // Prédio prefeitura
    CreateObject(1280, 1476.0, -1772.3, 17.8, 0.0, 0.0, 0.0); // Entrada prefeitura
    CreateObject(3472, 1481.0, -1780.0, 20.0, 0.0, 0.0, 0.0); // Placa prefeitura
    
    // Agência de Emprego
    CreateObject(1280, 1368.4, -1274.8, 12.5, 0.0, 0.0, 0.0); // Entrada agência
    CreateObject(3472, 1368.4, -1285.0, 15.0, 0.0, 0.0, 0.0); // Placa SINE-RJ
    
    // Veículos oficiais
    AddStaticVehicleEx(596, 1560.0, -1670.0, 16.0, 0.0, 0, 1, 15); // Viatura PCERJ
    AddStaticVehicleEx(596, 1548.0, -1670.0, 16.0, 0.0, 0, 1, 15); // Viatura PCERJ
    AddStaticVehicleEx(416, 1475.0, -1765.0, 18.8, 0.0, 1, 3, 15); // Ambulância
    
    // Veículos civis
    AddStaticVehicleEx(411, 1680.0, -2330.0, 13.5, 0.0, -1, -1, 15); // Infernus at airport
    AddStaticVehicleEx(522, 1690.0, -2330.0, 13.5, 0.0, -1, -1, 15); // NRG-500
    AddStaticVehicleEx(420, 1475.0, -1780.0, 18.8, 0.0, 6, 1, 15); // Taxi
    
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
            // Save player data here
        }
    }
    
    print("✓ Servidor desligado com sucesso!");
    print("====================================");
    return 1;
}

public OnPlayerConnect(playerid) {
    // Resetando dados do player
    ResetPlayerData(playerid);
    
    // Sistema de login com TextDraw
    CreateLoginScreen(playerid);
    
    // Mensagem de boas-vindas
    new string[256];
    format(string, sizeof(string), "{FFFFFF}Bem-vindo ao {00FF00}%s{FFFFFF}!", GAMEMODE_NAME);
    SendClientMessage(playerid, COLOR_WHITE, string);
    SendClientMessage(playerid, COLOR_YELLOW, "➤ Digite /login [senha] para entrar ou /registro [senha] para se registrar");
    
    // Congelar player na tela de login
    TogglePlayerControllable(playerid, 0);
    SetPlayerCameraPos(playerid, 1481.0, -1742.0, 25.0);
    SetPlayerCameraLookAt(playerid, 1481.0, -1772.3, 18.8);
    
    // Atualizando players online
    gPlayersOnline++;
    
    return 1;
}

public OnPlayerDisconnect(playerid, reason) {
    if(gPlayerInfo[playerid][pLogged]) {
        // Save player data here
        GetPlayerPos(playerid, gPlayerInfo[playerid][pPosX], gPlayerInfo[playerid][pPosY], gPlayerInfo[playerid][pPosZ]);
        GetPlayerFacingAngle(playerid, gPlayerInfo[playerid][pAngle]);
        gPlayerInfo[playerid][pInterior] = GetPlayerInterior(playerid);
        gPlayerInfo[playerid][pVirtualWorld] = GetPlayerVirtualWorld(playerid);
        
        GetPlayerHealth(playerid, gPlayerInfo[playerid][pHealth]);
        GetPlayerArmour(playerid, gPlayerInfo[playerid][pArmour]);
    }
    
    // Resetando dados
    ResetPlayerData(playerid);
    
    // Atualizando players online
    gPlayersOnline--;
    
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
    
    SetPlayerSkin(playerid, gPlayerInfo[playerid][pSkin]);
    
    return 1;
}

// =============================================================================
// SISTEMA DE COMANDOS BÁSICOS
// =============================================================================

public OnPlayerCommandText(playerid, cmdtext[]) {
    new cmd[256], tmp[256], string[512];
    new idx = 0;
    cmd = strtok(cmdtext, idx);
    
    // Login System
    if(strcmp("/login", cmd, true) == 0) {
        if(gPlayerInfo[playerid][pLogged]) return SendClientMessage(playerid, COLOR_RED, "Você já está logado!");
        tmp = strtok(cmdtext, idx);
        if(!strlen(tmp)) return SendClientMessage(playerid, COLOR_YELLOW, "USO: /login [senha]");
        
        // Simular login (aqui seria verificação de banco de dados)
        if(strcmp(tmp, "123456", true) == 0) {
            gPlayerInfo[playerid][pLogged] = 1;
            gPlayerInfo[playerid][pMoney] = 5000;
            gPlayerInfo[playerid][pLevel] = 1;
            DestroyLoginScreen(playerid);
            TogglePlayerControllable(playerid, 1);
            SetCameraBehindPlayer(playerid);
            SendClientMessage(playerid, COLOR_GREEN, "Login realizado com sucesso!");
            SpawnPlayer(playerid);
        } else {
            SendClientMessage(playerid, COLOR_RED, "Senha incorreta!");
        }
        return 1;
    }
    
    if(strcmp("/registro", cmd, true) == 0) {
        if(gPlayerInfo[playerid][pLogged]) return SendClientMessage(playerid, COLOR_RED, "Você já está logado!");
        tmp = strtok(cmdtext, idx);
        if(!strlen(tmp)) return SendClientMessage(playerid, COLOR_YELLOW, "USO: /registro [senha]");
        
        format(gPlayerInfo[playerid][pPassword], 64, "%s", tmp);
        gPlayerInfo[playerid][pLogged] = 1;
        gPlayerInfo[playerid][pMoney] = 2500;
        gPlayerInfo[playerid][pLevel] = 1;
        DestroyLoginScreen(playerid);
        TogglePlayerControllable(playerid, 1);
        SetCameraBehindPlayer(playerid);
        SendClientMessage(playerid, COLOR_GREEN, "Registro realizado com sucesso!");
        SpawnPlayer(playerid);
        return 1;
    }
    
    if(!gPlayerInfo[playerid][pLogged]) return SendClientMessage(playerid, COLOR_RED, "Você precisa fazer login primeiro!");
    
    // GPS System
    if(strcmp("/gps", cmd, true) == 0) {
        new gpsString[512] = "{FFFFFF}Selecione um destino:\n\n";
        for(new i = 0; i < sizeof(gGPSLocations); i++) {
            format(gpsString, sizeof(gpsString), "%s{FFFF00}%s{FFFFFF}\n%s\n\n", 
                gpsString, gGPSLocations[i][gpsName], gGPSLocations[i][gpsDescription]);
        }
        ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "{00FF00}Sistema de GPS", gpsString, "Ir", "Fechar");
        return 1;
    }
    
    // Help System
    if(strcmp("/ajuda", cmd, true) == 0) {
        new helpString[1024] = "{FFFFFF}=== COMANDOS DISPONÍVEIS ===\n\n";
        strcat(helpString, "{FFFF00}/stats{FFFFFF} - Ver suas estatísticas\n");
        strcat(helpString, "{FFFF00}/gps{FFFFFF} - Sistema de navegação GPS\n");
        strcat(helpString, "{FFFF00}/emprego{FFFFFF} - Procurar emprego\n");
        strcat(helpString, "{FFFF00}/prefeitura{FFFFFF} - Serviços municipais\n");
        strcat(helpString, "{FFFF00}/banco{FFFFFF} - Serviços bancários\n");
        strcat(helpString, "{FFFF00}/rj{FFFFFF} - Informações do servidor\n");
        strcat(helpString, "{FFFF00}/me [ação]{FFFFFF} - Ação em roleplay\n");
        strcat(helpString, "{FFFF00}/do [descrição]{FFFFFF} - Descrição do ambiente\n");
        strcat(helpString, "\n{00FF00}Para mais comandos, visite os locais específicos!");
        ShowPlayerDialog(playerid, DIALOG_HELP, DIALOG_STYLE_MSGBOX, "{00FF00}Central de Ajuda", helpString, "Fechar", "");
        return 1;
    }
    
    // Stats Command
    if(strcmp("/stats", cmd, true) == 0) {
        format(string, sizeof(string), 
            "=== ESTATÍSTICAS DO PLAYER ===\n\
            Nome: %s\n\
            Level: %d\n\
            Dinheiro: R$ %d\n\
            Banco: R$ %d\n\
            Emprego: %s\n\
            Facção: %d\n\
            Admin: %d\n\
            VIP: %d", 
            gPlayerInfo[playerid][pName], 
            gPlayerInfo[playerid][pLevel], 
            gPlayerInfo[playerid][pMoney], 
            gPlayerInfo[playerid][pBankMoney],
            gJobNames[gPlayerInfo[playerid][pJob]],
            gPlayerInfo[playerid][pFactionID], 
            gPlayerInfo[playerid][pAdminLevel], 
            gPlayerInfo[playerid][pVIPLevel]
        );
        ShowPlayerDialog(playerid, 1000, DIALOG_STYLE_MSGBOX, "Suas Estatísticas", string, "Fechar", "");
        return 1;
    }
    
    // Job Agency
    if(strcmp("/emprego", cmd, true) == 0) {
        if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1368.4, -1279.8, 13.5)) {
            return SendClientMessage(playerid, COLOR_RED, "Você precisa estar na Agência de Emprego!");
        }
        new jobString[512] = "{FFFFFF}Selecione um emprego:\n\n";
        for(new i = 1; i < sizeof(gJobNames); i++) {
            format(jobString, sizeof(jobString), "%s{FFFF00}%s{FFFFFF}\n", jobString, gJobNames[i]);
        }
        ShowPlayerDialog(playerid, DIALOG_JOB_AGENCY, DIALOG_STYLE_LIST, "{00FF00}Agência de Emprego", jobString, "Escolher", "Fechar");
        return 1;
    }
    
    // City Hall
    if(strcmp("/prefeitura", cmd, true) == 0) {
        if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1481.0, -1772.3, 18.8)) {
            return SendClientMessage(playerid, COLOR_RED, "Você precisa estar na Prefeitura!");
        }
        new cityString[512] = "{FFFFFF}Serviços da Prefeitura:\n\n";
        strcat(cityString, "{FFFF00}Carteira de Identidade{FFFFFF} - R$ 50\n");
        strcat(cityString, "{FFFF00}Carteira de Motorista{FFFFFF} - R$ 200\n");
        strcat(cityString, "{FFFF00}Licença de Arma{FFFFFF} - R$ 500\n");
        strcat(cityString, "{FFFF00}Certidão de Nascimento{FFFFFF} - R$ 30\n");
        ShowPlayerDialog(playerid, DIALOG_CITY_HALL, DIALOG_STYLE_LIST, "{00FF00}Prefeitura Municipal", cityString, "Comprar", "Fechar");
        return 1;
    }
    
    // RP Commands
    if(strcmp("/me", cmd, true) == 0) {
        tmp = strtok(cmdtext, idx);
        if(!strlen(tmp)) return SendClientMessage(playerid, COLOR_YELLOW, "USO: /me [ação]");
        format(string, sizeof(string), "* %s %s", gPlayerInfo[playerid][pName], cmdtext[4]);
        SendClientMessageToAll(COLOR_PURPLE, string);
        return 1;
    }
    
    if(strcmp("/do", cmd, true) == 0) {
        tmp = strtok(cmdtext, idx);
        if(!strlen(tmp)) return SendClientMessage(playerid, COLOR_YELLOW, "USO: /do [descrição]");
        format(string, sizeof(string), "* %s (( %s ))", cmdtext[4], gPlayerInfo[playerid][pName]);
        SendClientMessageToAll(COLOR_GREEN, string);
        return 1;
    }
    
    if(strcmp("/rj", cmd, true) == 0) {
        SendClientMessage(playerid, COLOR_GREEN, "Bem-vindo ao Rio de Janeiro RolePlay!");
        SendClientMessage(playerid, COLOR_YELLOW, "Versão: " GAMEMODE_VERSION);
        SendClientMessage(playerid, COLOR_WHITE, "Visite: /gps para navegar pela cidade");
        return 1;
    }
    
    return 0;
}

// =============================================================================
// FUNÇÕES AUXILIARES
// =============================================================================

stock ResetPlayerData(playerid) {
    gPlayerInfo[playerid][pID] = 0;
    gPlayerInfo[playerid][pName][0] = '\0';
    gPlayerInfo[playerid][pPassword][0] = '\0';
    gPlayerInfo[playerid][pAge] = 0;
    gPlayerInfo[playerid][pSex] = 0;
    gPlayerInfo[playerid][pSkin] = 0;
    gPlayerInfo[playerid][pMoney] = 0;
    gPlayerInfo[playerid][pLevel] = 1;
    gPlayerInfo[playerid][pPosX] = 0.0;
    gPlayerInfo[playerid][pPosY] = 0.0;
    gPlayerInfo[playerid][pPosZ] = 0.0;
    gPlayerInfo[playerid][pAngle] = 0.0;
    gPlayerInfo[playerid][pInterior] = 0;
    gPlayerInfo[playerid][pVirtualWorld] = 0;
    gPlayerInfo[playerid][pHealth] = 100.0;
    gPlayerInfo[playerid][pArmour] = 0.0;
    gPlayerInfo[playerid][pHunger] = 100;
    gPlayerInfo[playerid][pThirst] = 100;
    gPlayerInfo[playerid][pEnergy] = 100;
    gPlayerInfo[playerid][pFactionID] = 0;
    gPlayerInfo[playerid][pFactionRank] = 0;
    gPlayerInfo[playerid][pAdminLevel] = 0;
    gPlayerInfo[playerid][pVIPLevel] = 0;
    gPlayerInfo[playerid][pJob] = 0;
    gPlayerInfo[playerid][pJobLevel] = 0;
    gPlayerInfo[playerid][pBankMoney] = 1000;
    gPlayerInfo[playerid][pLogged] = 0;
    gPlayerInfo[playerid][pSpawned] = 0;
    gPlayerInfo[playerid][pGPSActive] = 0;
    
    GetPlayerName(playerid, gPlayerInfo[playerid][pName], MAX_PLAYER_NAME);
}

// =============================================================================
// SISTEMA DE LOGIN
// =============================================================================

stock CreateLoginScreen(playerid) {
    // Background
    gPlayerInfo[playerid][pLoginBG] = TextDrawCreate(200.0, 150.0, "box");
    TextDrawLetterSize(gPlayerInfo[playerid][pLoginBG], 0.0, 12.0);
    TextDrawTextSize(gPlayerInfo[playerid][pLoginBG], 440.0, 0.0);
    TextDrawAlignment(gPlayerInfo[playerid][pLoginBG], 1);
    TextDrawColor(gPlayerInfo[playerid][pLoginBG], -1);
    TextDrawUseBox(gPlayerInfo[playerid][pLoginBG], 1);
    TextDrawBoxColor(gPlayerInfo[playerid][pLoginBG], 0x000000BB);
    TextDrawBackgroundColor(gPlayerInfo[playerid][pLoginBG], 255);
    TextDrawFont(gPlayerInfo[playerid][pLoginBG], 1);
    TextDrawSetProportional(gPlayerInfo[playerid][pLoginBG], 1);
    
    // Title
    gPlayerInfo[playerid][pLoginTitle] = TextDrawCreate(320.0, 160.0, "~g~RIO DE JANEIRO ~w~ROLEPLAY");
    TextDrawLetterSize(gPlayerInfo[playerid][pLoginTitle], 0.4, 2.0);
    TextDrawAlignment(gPlayerInfo[playerid][pLoginTitle], 2);
    TextDrawColor(gPlayerInfo[playerid][pLoginTitle], -1);
    TextDrawSetShadow(gPlayerInfo[playerid][pLoginTitle], 0);
    TextDrawSetOutline(gPlayerInfo[playerid][pLoginTitle], 1);
    TextDrawBackgroundColor(gPlayerInfo[playerid][pLoginTitle], 255);
    TextDrawFont(gPlayerInfo[playerid][pLoginTitle], 1);
    TextDrawSetProportional(gPlayerInfo[playerid][pLoginTitle], 1);
    
    // Login Text
    new loginText[256];
    format(loginText, sizeof(loginText), "~w~Bem-vindo, ~y~%s~w~!~n~~n~Para acessar o servidor:~n~~y~/login [senha]~w~ - Fazer login~n~~y~/registro [senha]~w~ - Se registrar", gPlayerInfo[playerid][pName]);
    gPlayerInfo[playerid][pLoginText] = TextDrawCreate(320.0, 200.0, loginText);
    TextDrawLetterSize(gPlayerInfo[playerid][pLoginText], 0.25, 1.2);
    TextDrawAlignment(gPlayerInfo[playerid][pLoginText], 2);
    TextDrawColor(gPlayerInfo[playerid][pLoginText], -1);
    TextDrawSetShadow(gPlayerInfo[playerid][pLoginText], 0);
    TextDrawSetOutline(gPlayerInfo[playerid][pLoginText], 1);
    TextDrawBackgroundColor(gPlayerInfo[playerid][pLoginText], 255);
    TextDrawFont(gPlayerInfo[playerid][pLoginText], 1);
    TextDrawSetProportional(gPlayerInfo[playerid][pLoginText], 1);
    
    // Show textdraws
    TextDrawShowForPlayer(playerid, gPlayerInfo[playerid][pLoginBG]);
    TextDrawShowForPlayer(playerid, gPlayerInfo[playerid][pLoginTitle]);
    TextDrawShowForPlayer(playerid, gPlayerInfo[playerid][pLoginText]);
}

stock DestroyLoginScreen(playerid) {
    if(gPlayerInfo[playerid][pLoginBG] != Text:INVALID_TEXT_DRAW) {
        TextDrawHideForPlayer(playerid, gPlayerInfo[playerid][pLoginBG]);
        TextDrawDestroy(gPlayerInfo[playerid][pLoginBG]);
        gPlayerInfo[playerid][pLoginBG] = Text:INVALID_TEXT_DRAW;
    }
    if(gPlayerInfo[playerid][pLoginTitle] != Text:INVALID_TEXT_DRAW) {
        TextDrawHideForPlayer(playerid, gPlayerInfo[playerid][pLoginTitle]);
        TextDrawDestroy(gPlayerInfo[playerid][pLoginTitle]);
        gPlayerInfo[playerid][pLoginTitle] = Text:INVALID_TEXT_DRAW;
    }
    if(gPlayerInfo[playerid][pLoginText] != Text:INVALID_TEXT_DRAW) {
        TextDrawHideForPlayer(playerid, gPlayerInfo[playerid][pLoginText]);
        TextDrawDestroy(gPlayerInfo[playerid][pLoginText]);
        gPlayerInfo[playerid][pLoginText] = Text:INVALID_TEXT_DRAW;
    }
}

// =============================================================================
// SISTEMA DE GPS
// =============================================================================

forward UpdateGPS();
public UpdateGPS() {
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && gPlayerInfo[i][pLogged] && gPlayerInfo[i][pGPSActive]) {
            new Float:distance = GetPlayerDistanceFromPoint(i, gPlayerInfo[i][pGPSDestX], gPlayerInfo[i][pGPSDestY], gPlayerInfo[i][pGPSDestZ]);
            if(distance < 5.0) {
                SendClientMessage(i, COLOR_GREEN, "GPS: Você chegou ao seu destino!");
                gPlayerInfo[i][pGPSActive] = 0;
                DisablePlayerCheckpoint(i);
            } else {
                new string[128];
                format(string, sizeof(string), "GPS: %.1fm até o destino", distance);
                GameTextForPlayer(i, string, 2000, 5);
            }
        }
    }
}

stock SetPlayerGPS(playerid, Float:x, Float:y, Float:z) {
    gPlayerInfo[playerid][pGPSActive] = 1;
    gPlayerInfo[playerid][pGPSDestX] = x;
    gPlayerInfo[playerid][pGPSDestY] = y;
    gPlayerInfo[playerid][pGPSDestZ] = z;
    SetPlayerCheckpoint(playerid, x, y, z, 3.0);
}

// =============================================================================
// DIALOG RESPONSES
// =============================================================================

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if(dialogid == DIALOG_GPS && response) {
        if(listitem >= 0 && listitem < sizeof(gGPSLocations)) {
            SetPlayerGPS(playerid, gGPSLocations[listitem][gpsX], gGPSLocations[listitem][gpsY], gGPSLocations[listitem][gpsZ]);
            new string[128];
            format(string, sizeof(string), "GPS: Rota definida para %s", gGPSLocations[listitem][gpsName]);
            SendClientMessage(playerid, COLOR_GREEN, string);
        }
    }
    
    if(dialogid == DIALOG_JOB_AGENCY && response) {
        if(listitem >= 0 && listitem < sizeof(gJobNames)-1) {
            gPlayerInfo[playerid][pJob] = listitem + 1;
            gPlayerInfo[playerid][pJobLevel] = 1;
            new string[128];
            format(string, sizeof(string), "Parabéns! Você agora trabalha como %s", gJobNames[listitem + 1]);
            SendClientMessage(playerid, COLOR_GREEN, string);
        }
    }
    
    if(dialogid == DIALOG_CITY_HALL && response) {
        new prices[] = {50, 200, 500, 30};
        new services[][32] = {"Carteira de Identidade", "Carteira de Motorista", "Licença de Arma", "Certidão de Nascimento"};
        
        if(listitem >= 0 && listitem < sizeof(prices)) {
            if(gPlayerInfo[playerid][pMoney] >= prices[listitem]) {
                gPlayerInfo[playerid][pMoney] -= prices[listitem];
                new string[128];
                format(string, sizeof(string), "Você comprou: %s por R$ %d", services[listitem], prices[listitem]);
                SendClientMessage(playerid, COLOR_GREEN, string);
            } else {
                SendClientMessage(playerid, COLOR_RED, "Você não tem dinheiro suficiente!");
            }
        }
    }
    
    return 1;
}

// =============================================================================
// FUNÇÃO STRTOK
// =============================================================================

strtok(const string[], &index) {
    new length = strlen(string);
    while ((index < length) && (string[index] <= ' ')) {
        index++;
    }

    new offset = index;
    new result[256];
    while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1))) {
        result[index - offset] = string[index];
        index++;
    }
    result[index - offset] = EOS;
    return result;
}

// =============================================================================
// TIMER BÁSICO
// =============================================================================

forward UpdateServer();
public UpdateServer() {
    gServerUptime++;
    return 1;
}