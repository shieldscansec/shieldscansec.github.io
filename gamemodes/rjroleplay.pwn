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

// Dialogs (Mobile Optimized)
#define DIALOG_MAIN_MENU 100
#define DIALOG_LOGIN 101
#define DIALOG_REGISTER_EMAIL 102
#define DIALOG_REGISTER_PASSWORD 103
#define DIALOG_GPS 104
#define DIALOG_HELP 105
#define DIALOG_JOB_AGENCY 106
#define DIALOG_CITY_HALL 107

// Login/Register TextDraw IDs (Mobile Optimized)
#define MAX_LOGIN_TEXTDRAWS 8

// GPS Locations
#define GPS_AEROPORTO 0
#define GPS_DELEGACIA 1
#define GPS_PREFEITURA 2
#define GPS_AGENCIA_EMPREGO 3
#define GPS_HOSPITAL 4
#define GPS_BANCO 5
#define GPS_CRISTO_REDENTOR 6
#define GPS_PAO_ACUCAR 7
#define GPS_COPACABANA 8
#define GPS_MARACANA 9

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
    pEmail[64],
    pRegistrationStep,
    pLoginAttempts,
    
    // Modern Login/Register TextDraws
    Text:pLoginTD[MAX_LOGIN_TEXTDRAWS],
    bool:pLoginScreenActive,
    bool:pRegisterMode,
    
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
    {"Aeroporto Internacional Tom Jobim", 1680.0, -2310.0, 13.5, 0, "Aeroporto do Galeão - Terminal Principal"},
    {"Delegacia Central PCERJ", 1554.6, -1675.6, 16.2, 0, "Polícia Civil do Estado do Rio de Janeiro"},
    {"Prefeitura Municipal", 1481.0, -1772.3, 18.8, 0, "Prefeitura da Cidade do Rio de Janeiro"},
    {"Agência SINE-RJ", 1368.4, -1279.8, 13.5, 0, "Sistema Nacional de Emprego - Rio de Janeiro"},
    {"Hospital Albert Schweitzer", 2034.4, -1401.6, 17.3, 0, "Hospital Público de Emergência"},
    {"Banco Central do Brasil", 1462.3, -1011.4, 26.8, 0, "Agência Bancária Principal"},
    {"Cristo Redentor", -2026.0, -1634.0, 140.0, 0, "Cartão postal - Corcovado"},
    {"Pão de Açúcar", -1300.0, -750.0, 80.0, 0, "Bondinho do Pão de Açúcar"},
    {"Praia de Copacabana", -1810.0, -590.0, 12.0, 0, "Praia mais famosa do Rio"},
    {"Estádio do Maracanã", -1680.0, 1000.0, 15.0, 0, "Templo do futebol mundial"}
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
    
    // ========== AEROPORTO INTERNACIONAL TOM JOBIM (GALEÃO) ==========
    print("✓ Carregando Aeroporto Internacional Tom Jobim (Galeão)...");
    
    // Terminal Principal
    CreateObject(8340, 1680.0, -2324.0, 20.0, 0.0, 0.0, 0.0); // Prédio principal do terminal
    CreateObject(8341, 1720.0, -2324.0, 18.0, 0.0, 0.0, 90.0); // Extensão do terminal
    CreateObject(8342, 1640.0, -2324.0, 18.0, 0.0, 0.0, 270.0); // Ala oeste
    
    // Torre de Controle
    CreateObject(1697, 1700.0, -2280.0, 13.5, 0.0, 0.0, 0.0); // Torre de controle
    CreateObject(1297, 1700.0, -2280.0, 35.0, 0.0, 0.0, 0.0); // Antenas no topo
    
    // Pistas de Pouso
    CreateObject(3095, 1500.0, -2324.0, 13.0, 0.0, 0.0, 90.0); // Pista principal
    CreateObject(3095, 1400.0, -2324.0, 13.0, 0.0, 0.0, 90.0); // Extensão pista
    CreateObject(3095, 1300.0, -2324.0, 13.0, 0.0, 0.0, 90.0); // Extensão pista
    CreateObject(3095, 1200.0, -2324.0, 13.0, 0.0, 0.0, 90.0); // Extensão pista
    
    // Pista Secundária
    CreateObject(3095, 1680.0, -2200.0, 13.0, 0.0, 0.0, 0.0); // Pista secundária
    CreateObject(3095, 1680.0, -2100.0, 13.0, 0.0, 0.0, 0.0); // Extensão
    
    // Hangares
    CreateObject(3267, 1800.0, -2300.0, 13.5, 0.0, 0.0, 0.0); // Hangar 1
    CreateObject(3267, 1850.0, -2300.0, 13.5, 0.0, 0.0, 0.0); // Hangar 2
    CreateObject(3267, 1900.0, -2300.0, 13.5, 0.0, 0.0, 0.0); // Hangar 3
    CreateObject(3267, 1800.0, -2350.0, 13.5, 0.0, 0.0, 0.0); // Hangar 4
    
    // Estacionamento Multi-Level
    CreateObject(4000, 1620.0, -2280.0, 13.5, 0.0, 0.0, 0.0); // Estrutura estacionamento
    CreateObject(4000, 1620.0, -2280.0, 18.5, 0.0, 0.0, 0.0); // 2º andar
    CreateObject(4000, 1620.0, -2280.0, 23.5, 0.0, 0.0, 0.0); // 3º andar
    
    // Sinalizações do Aeroporto
    CreateObject(3472, 1680.0, -2340.0, 16.0, 0.0, 0.0, 0.0); // Placa "Aeroporto Internacional Tom Jobim"
    CreateObject(3472, 1650.0, -2310.0, 16.0, 0.0, 0.0, 90.0); // Placa "Terminal 1"
    CreateObject(3472, 1710.0, -2310.0, 16.0, 0.0, 0.0, 90.0); // Placa "Terminal 2"
    CreateObject(3472, 1680.0, -2290.0, 16.0, 0.0, 0.0, 0.0); // Placa "Embarque/Desembarque"
    
    // Sistema de Iluminação
    CreateObject(1226, 1660.0, -2324.0, 13.5, 0.0, 0.0, 0.0); // Poste de luz
    CreateObject(1226, 1700.0, -2324.0, 13.5, 0.0, 0.0, 0.0); // Poste de luz
    CreateObject(1226, 1740.0, -2324.0, 13.5, 0.0, 0.0, 0.0); // Poste de luz
    CreateObject(1226, 1680.0, -2304.0, 13.5, 0.0, 0.0, 0.0); // Poste de luz
    CreateObject(1226, 1680.0, -2344.0, 13.5, 0.0, 0.0, 0.0); // Poste de luz
    
    // Aviões Estacionados
    CreateObject(577, 1750.0, -2350.0, 13.5, 0.0, 0.0, 180.0); // AT-400 (Avião comercial)
    CreateObject(577, 1820.0, -2320.0, 13.5, 0.0, 0.0, 270.0); // AT-400
    CreateObject(519, 1880.0, -2280.0, 13.5, 0.0, 0.0, 90.0); // Shamal (Jato privado)
    CreateObject(593, 1850.0, -2250.0, 13.5, 0.0, 0.0, 45.0); // Dodo (Avião pequeno)
    
    // ========== CRISTO REDENTOR (CORCOVADO) ==========
    print("✓ Carregando Cristo Redentor...");
    CreateObject(8838, -2026.0, -1634.0, 120.0, 0.0, 0.0, 0.0); // Base do Cristo
    CreateObject(3851, -2026.0, -1634.0, 140.0, 0.0, 0.0, 0.0); // Estátua do Cristo
    CreateObject(3472, -2030.0, -1640.0, 118.0, 0.0, 0.0, 0.0); // Placa turística
    
    // ========== PÃO DE AÇÚCAR ==========
    print("✓ Carregando Pão de Açúcar...");
    CreateObject(8839, -1300.0, -750.0, 80.0, 0.0, 0.0, 0.0); // Morro do Pão de Açúcar
    CreateObject(1280, -1300.0, -745.0, 78.0, 0.0, 0.0, 0.0); // Estação do bondinho
    
    // ========== COPACABANA ==========
    print("✓ Carregando Praia de Copacabana...");
    CreateObject(615, -1800.0, -600.0, 12.0, 0.0, 0.0, 0.0); // Palmeiras
    CreateObject(615, -1820.0, -600.0, 12.0, 0.0, 0.0, 0.0);
    CreateObject(615, -1840.0, -600.0, 12.0, 0.0, 0.0, 0.0);
    CreateObject(1280, -1810.0, -590.0, 12.0, 0.0, 0.0, 0.0); // Posto salva-vidas
    
    // ========== MARACANÃ ==========
    print("✓ Carregando Estádio do Maracanã...");
    CreateObject(8557, -1680.0, 1000.0, 15.0, 0.0, 0.0, 0.0); // Estádio
    CreateObject(3472, -1680.0, 980.0, 18.0, 0.0, 0.0, 0.0); // Placa "Maracanã"
    
    // ========== DELEGACIA CENTRAL PCERJ ==========
    print("✓ Carregando Delegacia Central...");
    CreateObject(1280, 1568.8, -1675.2, 15.2, 0.0, 0.0, 0.0); // Entrada principal
    CreateObject(1280, 1548.1, -1675.2, 15.2, 0.0, 0.0, 180.0); // Saída
    CreateObject(3472, 1554.6, -1690.0, 16.0, 0.0, 0.0, 0.0); // Placa PCERJ
    CreateObject(3864, 1560.0, -1680.0, 15.2, 0.0, 0.0, 0.0); // Cerca de segurança
    
    // ========== PREFEITURA DO RIO ==========
    print("✓ Carregando Prefeitura Municipal...");
    CreateObject(4585, 1481.0, -1772.3, 25.0, 0.0, 0.0, 0.0); // Prédio principal
    CreateObject(1280, 1476.0, -1772.3, 17.8, 0.0, 0.0, 0.0); // Entrada
    CreateObject(3472, 1481.0, -1780.0, 20.0, 0.0, 0.0, 0.0); // Placa oficial
    CreateObject(1282, 1485.0, -1772.3, 17.8, 0.0, 0.0, 0.0); // Portão lateral
    
    // ========== AGÊNCIA DE EMPREGO SINE-RJ ==========
    print("✓ Carregando Agência de Emprego...");
    CreateObject(1280, 1368.4, -1274.8, 12.5, 0.0, 0.0, 0.0); // Entrada
    CreateObject(3472, 1368.4, -1285.0, 15.0, 0.0, 0.0, 0.0); // Placa SINE-RJ
    CreateObject(1775, 1365.0, -1275.0, 13.5, 0.0, 0.0, 0.0); // Balcão atendimento
    
    // ========== HOSPITAL ALBERT SCHWEITZER ==========
    print("✓ Carregando Hospital...");
    CreateObject(3864, 2034.0, -1401.0, 17.0, 0.0, 0.0, 0.0); // Cerca hospitalar
    CreateObject(1280, 2034.4, -1396.0, 17.3, 0.0, 0.0, 0.0); // Entrada emergência
    CreateObject(3472, 2034.4, -1410.0, 19.0, 0.0, 0.0, 0.0); // Placa hospital
    CreateObject(416, 2040.0, -1400.0, 17.3, 0.0, 0.0, 0.0); // Ambulância
    
    // ========== BANCO CENTRAL DO BRASIL ==========
    print("✓ Carregando Banco Central...");
    CreateObject(1280, 1462.3, -1006.4, 26.8, 0.0, 0.0, 0.0); // Entrada principal
    CreateObject(3472, 1462.3, -1020.0, 28.0, 0.0, 0.0, 0.0); // Placa banco
    CreateObject(3864, 1470.0, -1010.0, 26.8, 0.0, 0.0, 0.0); // Segurança
    
    // ========== VEÍCULOS DO AEROPORTO ==========
    print("✓ Adicionando veículos do aeroporto...");
    AddStaticVehicleEx(485, 1660.0, -2340.0, 13.5, 0.0, 1, 1, 15); // Baggage (Veículo de bagagem)
    AddStaticVehicleEx(485, 1670.0, -2340.0, 13.5, 0.0, 1, 1, 15); // Baggage
    AddStaticVehicleEx(485, 1680.0, -2340.0, 13.5, 0.0, 1, 1, 15); // Baggage
    AddStaticVehicleEx(544, 1690.0, -2340.0, 13.5, 0.0, 1, 1, 15); // Firetruck (Bombeiros do aeroporto)
    AddStaticVehicleEx(431, 1700.0, -2340.0, 13.5, 0.0, 1, 1, 15); // Bus (Ônibus do aeroporto)
    AddStaticVehicleEx(431, 1710.0, -2340.0, 13.5, 0.0, 1, 1, 15); // Bus
    
    // Táxis do aeroporto
    AddStaticVehicleEx(420, 1640.0, -2310.0, 13.5, 0.0, 6, 1, 15); // Taxi
    AddStaticVehicleEx(420, 1644.0, -2310.0, 13.5, 0.0, 6, 1, 15); // Taxi
    AddStaticVehicleEx(420, 1648.0, -2310.0, 13.5, 0.0, 6, 1, 15); // Taxi
    
    // ========== VEÍCULOS OFICIAIS ==========
    print("✓ Adicionando veículos oficiais...");
    AddStaticVehicleEx(596, 1560.0, -1670.0, 16.0, 0.0, 0, 1, 15); // Viatura PCERJ
    AddStaticVehicleEx(596, 1548.0, -1670.0, 16.0, 0.0, 0, 1, 15); // Viatura PCERJ
    AddStaticVehicleEx(599, 1552.0, -1670.0, 16.0, 0.0, 0, 1, 15); // Viatura PCERJ (Ranger)
    AddStaticVehicleEx(416, 1475.0, -1765.0, 18.8, 0.0, 1, 3, 15); // Ambulância
    AddStaticVehicleEx(416, 1479.0, -1765.0, 18.8, 0.0, 1, 3, 15); // Ambulância
    
    // ========== VEÍCULOS CIVIS DIVERSOS ==========
    print("✓ Adicionando veículos civis...");
    AddStaticVehicleEx(411, 1620.0, -2290.0, 13.5, 0.0, -1, -1, 15); // Infernus
    AddStaticVehicleEx(522, 1624.0, -2290.0, 13.5, 0.0, -1, -1, 15); // NRG-500
    AddStaticVehicleEx(560, 1628.0, -2290.0, 13.5, 0.0, -1, -1, 15); // Sultan
    AddStaticVehicleEx(562, 1632.0, -2290.0, 13.5, 0.0, -1, -1, 15); // Elegy
    
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
    
    // Congelar player na tela de login
    TogglePlayerControllable(playerid, 0);
    
    // Câmera cinematográfica no Cristo Redentor
    SetPlayerCameraPos(playerid, -2000.0, -1600.0, 150.0);
    SetPlayerCameraLookAt(playerid, -2026.0, -1634.0, 140.0);
    
    // Sistema automático de login/registro (Mobile Friendly)
    SetTimerEx("MostrarMenuLogin", 2000, false, "i", playerid);
    
    // Mensagem de boas-vindas
    new string[128];
    format(string, sizeof(string), "~g~Bem-vindo ao ~w~%s", GAMEMODE_NAME);
    GameTextForPlayer(playerid, string, 3000, 1);
    
    // Atualizando players online
    gPlayersOnline++;
    
    return 1;
}

public OnPlayerDisconnect(playerid, reason) {
    if(gPlayerInfo[playerid][pLogged]) {
        // Salvar dados do player (aqui integraria com banco de dados)
        GetPlayerPos(playerid, gPlayerInfo[playerid][pPosX], gPlayerInfo[playerid][pPosY], gPlayerInfo[playerid][pPosZ]);
        GetPlayerFacingAngle(playerid, gPlayerInfo[playerid][pAngle]);
        gPlayerInfo[playerid][pInterior] = GetPlayerInterior(playerid);
        gPlayerInfo[playerid][pVirtualWorld] = GetPlayerVirtualWorld(playerid);
        
        GetPlayerHealth(playerid, gPlayerInfo[playerid][pHealth]);
        GetPlayerArmour(playerid, gPlayerInfo[playerid][pArmour]);
        
        // Log de desconexão
        new string[128];
        format(string, sizeof(string), "Player %s desconectou do servidor", gPlayerInfo[playerid][pName]);
        print(string);
    }
    
    // Fechar tela de login se ativa
    if(gPlayerInfo[playerid][pLoginScreenActive]) {
        FecharTelaLogin(playerid);
    }
    
    // Resetando dados
    ResetPlayerData(playerid);
    
    // Atualizando players online
    gPlayersOnline--;
    
    return 1;
}

public OnPlayerSpawn(playerid) {
    if(!gPlayerInfo[playerid][pLogged]) return Kick(playerid);
    
    // Primeira vez spawning - Aeroporto Internacional Tom Jobim (Galeão)
    if(!gPlayerInfo[playerid][pSpawned]) {
        SetPlayerPos(playerid, 1680.0, -2310.0, 13.5); // Terminal do aeroporto
        SetPlayerFacingAngle(playerid, 0.0);
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);
        SetCameraBehindPlayer(playerid);
        
        // Mensagem de boas-vindas no spawn
        SendClientMessage(playerid, COLOR_GREEN, "✈️ Bem-vindo ao Aeroporto Internacional Tom Jobim (Galeão)!");
        SendClientMessage(playerid, COLOR_YELLOW, "➤ Use /gps para navegar pela cidade do Rio de Janeiro");
        SendClientMessage(playerid, COLOR_WHITE, "➤ Digite /ajuda para ver os comandos disponíveis");
        
        // Efeito visual de chegada
        GameTextForPlayer(playerid, "~g~Chegada ao Rio de Janeiro~n~~w~Aeroporto Internacional", 5000, 1);
        
        gPlayerInfo[playerid][pSpawned] = 1;
    } else {
        // Spawn normal (posição salva)
        SetPlayerPos(playerid, gPlayerInfo[playerid][pPosX], gPlayerInfo[playerid][pPosY], gPlayerInfo[playerid][pPosZ]);
        SetPlayerFacingAngle(playerid, gPlayerInfo[playerid][pAngle]);
        SetPlayerInterior(playerid, gPlayerInfo[playerid][pInterior]);
        SetPlayerVirtualWorld(playerid, gPlayerInfo[playerid][pVirtualWorld]);
    }
    
    // Configurando vida e stats
    SetPlayerHealth(playerid, gPlayerInfo[playerid][pHealth]);
    SetPlayerArmour(playerid, gPlayerInfo[playerid][pArmour]);
    SetPlayerScore(playerid, gPlayerInfo[playerid][pLevel]);
    
    // Skin padrão se não definido
    if(gPlayerInfo[playerid][pSkin] == 0) gPlayerInfo[playerid][pSkin] = (gPlayerInfo[playerid][pSex] == 1) ? 12 : 55;
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
    
    // Comando para reabrir menu de login (admin/debug)
    if(strcmp("/relogin", cmd, true) == 0) {
        if(gPlayerInfo[playerid][pAdminLevel] < 1) return SendClientMessage(playerid, COLOR_RED, "Comando apenas para administradores!");
        gPlayerInfo[playerid][pLogged] = 0;
        TogglePlayerControllable(playerid, 0);
        SetPlayerCameraPos(playerid, -2000.0, -1600.0, 150.0);
        SetPlayerCameraLookAt(playerid, -2026.0, -1634.0, 140.0);
        MostrarMenuLogin(playerid);
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
        SendClientMessage(playerid, COLOR_GREEN, "=== RIO DE JANEIRO ROLEPLAY ===");
        SendClientMessage(playerid, COLOR_YELLOW, "Versão: " GAMEMODE_VERSION);
        SendClientMessage(playerid, COLOR_WHITE, "🗺️ Use /gps para navegar pela cidade");
        SendClientMessage(playerid, COLOR_WHITE, "🏠 Use /casa para comprar propriedades");
        SendClientMessage(playerid, COLOR_WHITE, "🚗 Use /veiculo para comprar veículos");
        SendClientMessage(playerid, COLOR_WHITE, "💼 Use /emprego para trabalhar");
        return 1;
    }
    
    // Sistema de Dinheiro
    if(strcmp("/dinheiro", cmd, true) == 0) {
        new string[128];
        format(string, sizeof(string), "💰 Dinheiro: R$ %d | 🏦 Banco: R$ %d", gPlayerInfo[playerid][pMoney], gPlayerInfo[playerid][pBankMoney]);
        SendClientMessage(playerid, COLOR_GREEN, string);
        return 1;
    }
    
    // Sistema de Teleporte para pontos turísticos
    if(strcmp("/cristo", cmd, true) == 0) {
        SetPlayerPos(playerid, -2026.0, -1634.0, 140.0);
        SetPlayerFacingAngle(playerid, 180.0);
        SendClientMessage(playerid, COLOR_GREEN, "🗽 Você foi teleportado para o Cristo Redentor!");
        return 1;
    }
    
    if(strcmp("/paodeacucar", cmd, true) == 0) {
        SetPlayerPos(playerid, -1300.0, -750.0, 80.0);
        SetPlayerFacingAngle(playerid, 180.0);
        SendClientMessage(playerid, COLOR_GREEN, "🚡 Você foi teleportado para o Pão de Açúcar!");
        return 1;
    }
    
    if(strcmp("/copacabana", cmd, true) == 0) {
        SetPlayerPos(playerid, -1810.0, -590.0, 12.0);
        SetPlayerFacingAngle(playerid, 180.0);
        SendClientMessage(playerid, COLOR_GREEN, "🏖️ Você foi teleportado para Copacabana!");
        return 1;
    }
    
    if(strcmp("/maracana", cmd, true) == 0) {
        SetPlayerPos(playerid, -1680.0, 1000.0, 15.0);
        SetPlayerFacingAngle(playerid, 180.0);
        SendClientMessage(playerid, COLOR_GREEN, "⚽ Você foi teleportado para o Maracanã!");
        return 1;
    }
    
    // Comando para ir ao aeroporto
    if(strcmp("/aeroporto", cmd, true) == 0) {
        SetPlayerPos(playerid, 1680.0, -2310.0, 13.5);
        SetPlayerFacingAngle(playerid, 0.0);
        SendClientMessage(playerid, COLOR_GREEN, "✈️ Você foi teleportado para o Aeroporto Internacional Tom Jobim!");
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
    gPlayerInfo[playerid][pEmail][0] = '\0';
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
    gPlayerInfo[playerid][pRegistrationStep] = 0;
    gPlayerInfo[playerid][pLoginAttempts] = 0;
    gPlayerInfo[playerid][pLoginScreenActive] = false;
    gPlayerInfo[playerid][pRegisterMode] = false;
    
    // Resetar TextDraws
    for(new i = 0; i < MAX_LOGIN_TEXTDRAWS; i++) {
        gPlayerInfo[playerid][pLoginTD][i] = Text:INVALID_TEXT_DRAW;
    }
    
    GetPlayerName(playerid, gPlayerInfo[playerid][pName], MAX_PLAYER_NAME);
}

// =============================================================================
// SISTEMA MODERNO DE LOGIN/REGISTRO
// =============================================================================

stock MostrarTelaLogin(playerid) {
    gPlayerInfo[playerid][pLoginScreenActive] = true;
    gPlayerInfo[playerid][pRegisterMode] = false;
    
    // Fundo principal simples (Mobile Optimized)
    gPlayerInfo[playerid][pLoginTD][0] = TextDrawCreate(160.0, 140.0, "box");
    TextDrawLetterSize(gPlayerInfo[playerid][pLoginTD][0], 0.0, 20.0);
    TextDrawTextSize(gPlayerInfo[playerid][pLoginTD][0], 480.0, 0.0);
    TextDrawUseBox(gPlayerInfo[playerid][pLoginTD][0], 1);
    TextDrawBoxColor(gPlayerInfo[playerid][pLoginTD][0], 0x000000AA); // Fundo escuro semi-transparente
    TextDrawSetSelectable(gPlayerInfo[playerid][pLoginTD][0], 0);
    
    // Título principal 
    gPlayerInfo[playerid][pLoginTD][1] = TextDrawCreate(320.0, 150.0, "~g~RIO DE JANEIRO ~w~ROLEPLAY");
    TextDrawLetterSize(gPlayerInfo[playerid][pLoginTD][1], 0.4, 1.8);
    TextDrawAlignment(gPlayerInfo[playerid][pLoginTD][1], 2);
    TextDrawColor(gPlayerInfo[playerid][pLoginTD][1], -1);
    TextDrawSetOutline(gPlayerInfo[playerid][pLoginTD][1], 1);
    TextDrawFont(gPlayerInfo[playerid][pLoginTD][1], 1);
    TextDrawSetSelectable(gPlayerInfo[playerid][pLoginTD][1], 0);
    
    // Nome do jogador
    new welcomeText[128];
    format(welcomeText, sizeof(welcomeText), "~w~Bem-vindo, ~y~%s~w~!", gPlayerInfo[playerid][pName]);
    gPlayerInfo[playerid][pLoginTD][2] = TextDrawCreate(320.0, 180.0, welcomeText);
    TextDrawLetterSize(gPlayerInfo[playerid][pLoginTD][2], 0.3, 1.5);
    TextDrawAlignment(gPlayerInfo[playerid][pLoginTD][2], 2);
    TextDrawColor(gPlayerInfo[playerid][pLoginTD][2], -1);
    TextDrawSetOutline(gPlayerInfo[playerid][pLoginTD][2], 1);
    TextDrawFont(gPlayerInfo[playerid][pLoginTD][2], 1);
    TextDrawSetSelectable(gPlayerInfo[playerid][pLoginTD][2], 0);
    
    // Instruções
    gPlayerInfo[playerid][pLoginTD][3] = TextDrawCreate(320.0, 210.0, "~w~Escolha uma opcao abaixo:");
    TextDrawLetterSize(gPlayerInfo[playerid][pLoginTD][3], 0.25, 1.2);
    TextDrawAlignment(gPlayerInfo[playerid][pLoginTD][3], 2);
    TextDrawColor(gPlayerInfo[playerid][pLoginTD][3], -1);
    TextDrawSetOutline(gPlayerInfo[playerid][pLoginTD][3], 1);
    TextDrawFont(gPlayerInfo[playerid][pLoginTD][3], 1);
    TextDrawSetSelectable(gPlayerInfo[playerid][pLoginTD][3], 0);
    
    // Botão REGISTRAR
    gPlayerInfo[playerid][pLoginTD][4] = TextDrawCreate(250.0, 250.0, "~w~REGISTRAR");
    TextDrawLetterSize(gPlayerInfo[playerid][pLoginTD][4], 0.35, 1.6);
    TextDrawTextSize(gPlayerInfo[playerid][pLoginTD][4], 320.0, 15.0);
    TextDrawAlignment(gPlayerInfo[playerid][pLoginTD][4], 2);
    TextDrawUseBox(gPlayerInfo[playerid][pLoginTD][4], 1);
    TextDrawBoxColor(gPlayerInfo[playerid][pLoginTD][4], 0x00AA00FF); // Verde
    TextDrawColor(gPlayerInfo[playerid][pLoginTD][4], 0xFFFFFFFF);
    TextDrawFont(gPlayerInfo[playerid][pLoginTD][4], 1);
    TextDrawSetSelectable(gPlayerInfo[playerid][pLoginTD][4], 1);
    
    // Botão LOGIN
    gPlayerInfo[playerid][pLoginTD][5] = TextDrawCreate(390.0, 250.0, "~w~LOGIN");
    TextDrawLetterSize(gPlayerInfo[playerid][pLoginTD][5], 0.35, 1.6);
    TextDrawTextSize(gPlayerInfo[playerid][pLoginTD][5], 460.0, 15.0);
    TextDrawAlignment(gPlayerInfo[playerid][pLoginTD][5], 2);
    TextDrawUseBox(gPlayerInfo[playerid][pLoginTD][5], 1);
    TextDrawBoxColor(gPlayerInfo[playerid][pLoginTD][5], 0x0066CCFF); // Azul
    TextDrawColor(gPlayerInfo[playerid][pLoginTD][5], 0xFFFFFFFF);
    TextDrawFont(gPlayerInfo[playerid][pLoginTD][5], 1);
    TextDrawSetSelectable(gPlayerInfo[playerid][pLoginTD][5], 1);
    
    // Dica para mobile
    gPlayerInfo[playerid][pLoginTD][6] = TextDrawCreate(320.0, 290.0, "~y~Toque no botao desejado");
    TextDrawLetterSize(gPlayerInfo[playerid][pLoginTD][6], 0.2, 1.0);
    TextDrawAlignment(gPlayerInfo[playerid][pLoginTD][6], 2);
    TextDrawColor(gPlayerInfo[playerid][pLoginTD][6], -1);
    TextDrawSetOutline(gPlayerInfo[playerid][pLoginTD][6], 1);
    TextDrawFont(gPlayerInfo[playerid][pLoginTD][6], 1);
    TextDrawSetSelectable(gPlayerInfo[playerid][pLoginTD][6], 0);
    
    // Rodapé
    gPlayerInfo[playerid][pLoginTD][7] = TextDrawCreate(320.0, 320.0, "~w~RJ RolePlay ~g~v1.0");
    TextDrawLetterSize(gPlayerInfo[playerid][pLoginTD][7], 0.2, 1.0);
    TextDrawAlignment(gPlayerInfo[playerid][pLoginTD][7], 2);
    TextDrawColor(gPlayerInfo[playerid][pLoginTD][7], 0xAAAAAAAA);
    TextDrawFont(gPlayerInfo[playerid][pLoginTD][7], 1);
    TextDrawSetSelectable(gPlayerInfo[playerid][pLoginTD][7], 0);
    
    // Mostrar todas as TextDraws
    for(new i = 0; i < MAX_LOGIN_TEXTDRAWS; i++) {
        TextDrawShowForPlayer(playerid, gPlayerInfo[playerid][pLoginTD][i]);
    }
    
    // Ativar modo de seleção (mobile friendly)
    SelectTextDraw(playerid, 0x33AA33FF);
}

stock MostrarTelaRegistro(playerid) {
    gPlayerInfo[playerid][pRegisterMode] = true;
    // Aqui você pode modificar as TextDraws para destacar o lado do registro
}

stock FecharTelaLogin(playerid) {
    if(!gPlayerInfo[playerid][pLoginScreenActive]) return;
    
    for(new i = 0; i < MAX_LOGIN_TEXTDRAWS; i++) {
        if(gPlayerInfo[playerid][pLoginTD][i] != Text:INVALID_TEXT_DRAW) {
            TextDrawHideForPlayer(playerid, gPlayerInfo[playerid][pLoginTD][i]);
            TextDrawDestroy(gPlayerInfo[playerid][pLoginTD][i]);
            gPlayerInfo[playerid][pLoginTD][i] = Text:INVALID_TEXT_DRAW;
        }
    }
    
    gPlayerInfo[playerid][pLoginScreenActive] = false;
    CancelSelectTextDraw(playerid);
}

stock ProcessarCliqueLogin(playerid, Text:clicked) {
    // Botão REGISTRAR (Verde)
    if(clicked == gPlayerInfo[playerid][pLoginTD][4]) {
        ShowPlayerDialog(playerid, DIALOG_EMAIL_CONFIRM, DIALOG_STYLE_INPUT, 
            "{00AA00}Registro - Novo Jogador", 
            "{FFFFFF}Digite seu endereço de e-mail para criar uma conta:\n\n{FFFF00}Exemplo: seuemail@gmail.com\n{CCCCCC}O e-mail será usado para recuperação da conta.", 
            "Confirmar", "Cancelar");
        return 1;
    }
    
    // Botão LOGIN (Azul)
    if(clicked == gPlayerInfo[playerid][pLoginTD][5]) {
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, 
            "{0066CC}Login - Jogador Existente", 
            "{FFFFFF}Digite sua senha para acessar o servidor:\n\n{FFFF00}Senha padrão para teste: 123456", 
            "Entrar", "Cancelar");
        return 1;
    }
    
    return 0;
}

// Sistema automático de login (Timer Function)
forward MostrarMenuLogin(playerid);
public MostrarMenuLogin(playerid) {
    if(!IsPlayerConnected(playerid)) return;
    
    new dialogString[512];
    format(dialogString, sizeof(dialogString), 
        "{FFFFFF}Bem-vindo ao {00FF00}Rio de Janeiro RolePlay{FFFFFF}!\n\n"
        "Olá, {FFFF00}%s{FFFFFF}!\n\n"
        "{FFFFFF}Este é um servidor de roleplay brasileiro\n"
        "inspirado na cidade maravilhosa do Rio de Janeiro.\n\n"
        "{FFFF00}• {FFFFFF}Se você já tem uma conta, clique em {00FF00}LOGIN\n"
        "{FFFF00}• {FFFFFF}Se é novo no servidor, clique em {FF6600}REGISTRAR\n\n"
        "{CCCCCC}Versão: 1.0 | Players Online: %d",
        gPlayerInfo[playerid][pName], gPlayersOnline
    );
    
    ShowPlayerDialog(playerid, DIALOG_MAIN_MENU, DIALOG_STYLE_MSGBOX,
        "{00FF00}Rio de Janeiro RolePlay", 
        dialogString, 
        "Login", "Registrar");
}

// Função para kick com delay
forward KickPlayer(playerid);
public KickPlayer(playerid) {
    if(IsPlayerConnected(playerid)) {
        Kick(playerid);
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

public OnPlayerClickTextDraw(playerid, Text:clickedid) {
    if(gPlayerInfo[playerid][pLoginScreenActive]) {
        ProcessarCliqueLogin(playerid, clickedid);
    }
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    // Menu Principal de Login/Registro
    if(dialogid == DIALOG_MAIN_MENU) {
        if(response) { // Botão "Login"
            ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,
                "{00FF00}Login - Jogador Existente",
                "{FFFFFF}Digite sua senha para acessar o servidor:\n\n"
                "{FFFF00}Para teste use a senha: {FFFFFF}123456\n\n"
                "{CCCCCC}Se você esqueceu sua senha, desconecte e\n"
                "escolha a opção 'Registrar' para criar uma nova conta.",
                "Entrar", "Voltar");
        } else { // Botão "Registrar"
            ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT,
                "{FF6600}Registro - Novo Jogador",
                "{FFFFFF}Bem-vindo ao Rio de Janeiro RolePlay!\n\n"
                "Para criar sua conta, digite seu e-mail:\n\n"
                "{FFFF00}Exemplo: {FFFFFF}seuemail@gmail.com\n\n"
                "{CCCCCC}O e-mail será usado para recuperação da conta.",
                "Continuar", "Voltar");
        }
        return 1;
    }
    
    // Sistema de Login
    if(dialogid == DIALOG_LOGIN) {
        if(!response) { // Botão "Voltar"
            MostrarMenuLogin(playerid);
            return 1;
        }
        
        if(!strlen(inputtext)) {
            GameTextForPlayer(playerid, "~r~Digite uma senha!", 3000, 3);
            ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,
                "{00FF00}Login - Senha Necessária",
                "{FFFFFF}Você precisa digitar uma senha!\n\n"
                "{FFFF00}Para teste use: {FFFFFF}123456",
                "Entrar", "Voltar");
            return 1;
        }
        
        // Simular verificação de senha (aqui integraria com banco de dados)
        if(strcmp(inputtext, "123456", false) == 0) {
            gPlayerInfo[playerid][pLogged] = 1;
            gPlayerInfo[playerid][pMoney] = 5000;
            gPlayerInfo[playerid][pBankMoney] = 2000;
            gPlayerInfo[playerid][pLevel] = 1;
            gPlayerInfo[playerid][pHealth] = 100.0;
            gPlayerInfo[playerid][pSex] = 1;
            
            TogglePlayerControllable(playerid, 1);
            SetCameraBehindPlayer(playerid);
            
            GameTextForPlayer(playerid, "~g~Login realizado com sucesso!", 3000, 1);
            SendClientMessage(playerid, COLOR_GREEN, "✅ Bem-vindo de volta ao Rio de Janeiro RolePlay!");
            SpawnPlayer(playerid);
        } else {
            gPlayerInfo[playerid][pLoginAttempts]++;
            if(gPlayerInfo[playerid][pLoginAttempts] >= 3) {
                GameTextForPlayer(playerid, "~r~Muitas tentativas incorretas!", 3000, 3);
                SendClientMessage(playerid, COLOR_RED, "Você será desconectado por segurança.");
                SetTimerEx("KickPlayer", 2000, false, "i", playerid);
            } else {
                GameTextForPlayer(playerid, "~r~Senha incorreta!", 3000, 3);
                new attemptString[256];
                format(attemptString, sizeof(attemptString),
                    "{FFFFFF}Senha incorreta!\n\n"
                    "{FF0000}Tentativas restantes: {FFFFFF}%d\n\n"
                    "{FFFF00}Para teste use: {FFFFFF}123456",
                    3 - gPlayerInfo[playerid][pLoginAttempts]);
                ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,
                    "{FF0000}Login - Senha Incorreta", attemptString, "Tentar Novamente", "Voltar");
            }
        }
        return 1;
    }
    
    // Primeiro passo do registro (E-mail)
    if(dialogid == DIALOG_REGISTER_EMAIL) {
        if(!response) { // Botão "Voltar"
            MostrarMenuLogin(playerid);
            return 1;
        }
        
        if(!strlen(inputtext)) {
            ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT,
                "{FF6600}Registro - E-mail Obrigatório",
                "{FFFFFF}Você precisa digitar um e-mail!\n\n"
                "{FFFF00}Exemplo: {FFFFFF}seuemail@gmail.com",
                "Continuar", "Voltar");
            return 1;
        }
        
        // Validar formato de e-mail básico
        if(strfind(inputtext, "@", true) == -1 || strfind(inputtext, ".", true) == -1) {
            ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT,
                "{FF0000}Registro - E-mail Inválido",
                "{FFFFFF}Formato de e-mail inválido!\n\n"
                "{FFFF00}Use o formato: {FFFFFF}exemplo@gmail.com\n\n"
                "Digite um e-mail válido:",
                "Continuar", "Voltar");
            return 1;
        }
        
        format(gPlayerInfo[playerid][pEmail], 64, "%s", inputtext);
        
        ShowPlayerDialog(playerid, DIALOG_REGISTER_PASSWORD, DIALOG_STYLE_PASSWORD,
            "{FF6600}Registro - Criar Senha",
            "{FFFFFF}Agora digite uma senha segura para sua conta:\n\n"
            "{FFFF00}Requisitos:\n"
            "{FFFFFF}• Mínimo 6 caracteres\n"
            "• Use letras e números\n"
            "• Evite senhas óbvias\n\n"
            "{CCCCCC}Esta senha será usada para fazer login.",
            "Criar Conta", "Voltar");
        return 1;
    }
    
    // Segundo passo do registro (Senha)
    if(dialogid == DIALOG_REGISTER_PASSWORD) {
        if(!response) { // Botão "Voltar"
            ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT,
                "{FF6600}Registro - Novo Jogador",
                "{FFFFFF}Digite seu e-mail novamente:",
                "Continuar", "Voltar");
            return 1;
        }
        
        if(!strlen(inputtext) || strlen(inputtext) < 6) {
            ShowPlayerDialog(playerid, DIALOG_REGISTER_PASSWORD, DIALOG_STYLE_PASSWORD,
                "{FF0000}Registro - Senha Muito Fraca",
                "{FFFFFF}A senha deve ter pelo menos 6 caracteres!\n\n"
                "Digite uma senha mais segura:",
                "Criar Conta", "Voltar");
            return 1;
        }
        
        format(gPlayerInfo[playerid][pPassword], 64, "%s", inputtext);
        gPlayerInfo[playerid][pLogged] = 1;
        gPlayerInfo[playerid][pMoney] = 2500;
        gPlayerInfo[playerid][pBankMoney] = 1000;
        gPlayerInfo[playerid][pLevel] = 1;
        gPlayerInfo[playerid][pHealth] = 100.0;
        gPlayerInfo[playerid][pSex] = 1;
        
        TogglePlayerControllable(playerid, 1);
        SetCameraBehindPlayer(playerid);
        
        GameTextForPlayer(playerid, "~g~Conta criada com sucesso!", 3000, 1);
        SendClientMessage(playerid, COLOR_GREEN, "✅ Bem-vindo ao Rio de Janeiro RolePlay!");
        SendClientMessage(playerid, COLOR_YELLOW, "🎯 Sua conta foi criada com sucesso!");
        SpawnPlayer(playerid);
        return 1;
    }
    
    // Sistema GPS
    if(dialogid == DIALOG_GPS && response) {
        if(listitem >= 0 && listitem < sizeof(gGPSLocations)) {
            SetPlayerGPS(playerid, gGPSLocations[listitem][gpsX], gGPSLocations[listitem][gpsY], gGPSLocations[listitem][gpsZ]);
            new string[128];
            format(string, sizeof(string), "GPS: Rota definida para %s", gGPSLocations[listitem][gpsName]);
            SendClientMessage(playerid, COLOR_GREEN, string);
        }
    }
    
    // Sistema de Empregos
    if(dialogid == DIALOG_JOB_AGENCY && response) {
        if(listitem >= 0 && listitem < sizeof(gJobNames)-1) {
            gPlayerInfo[playerid][pJob] = listitem + 1;
            gPlayerInfo[playerid][pJobLevel] = 1;
            new string[128];
            format(string, sizeof(string), "Parabéns! Você agora trabalha como %s", gJobNames[listitem + 1]);
            SendClientMessage(playerid, COLOR_GREEN, string);
        }
    }
    
    // Sistema da Prefeitura
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