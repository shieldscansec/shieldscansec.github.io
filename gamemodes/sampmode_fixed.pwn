#include <a_samp>

#define GAMEMODE_NAME "Rio de Janeiro RolePlay"
#define GAMEMODE_VERSION "1.0.0"

#define COLOR_WHITE 0xFFFFFFFF
#define COLOR_RED 0xFF0000FF
#define COLOR_GREEN 0x00FF00FF
#define COLOR_BLUE 0x0000FFFF
#define COLOR_YELLOW 0xFFFF00FF
#define COLOR_ORANGE 0xFF8000FF
#define COLOR_GREY 0x808080FF
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_LIGHTGREEN 0x9ACD32AA
#define COLOR_PURPLE 0x800080FF

#define DIALOG_MAIN_MENU 100
#define DIALOG_LOGIN 101
#define DIALOG_REGISTER_EMAIL 102
#define DIALOG_REGISTER_PASSWORD 103
#define DIALOG_GPS 200
#define DIALOG_JOB_AGENCY 300
#define DIALOG_CITY_HALL 400

#define MAX_LOGIN_TEXTDRAWS 8

enum pInfo {
    pID,
    pName[MAX_PLAYER_NAME],
    pPassword[64],
    pEmail[64],
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
    pJob,
    pJobLevel,
    pBankMoney,
    pLogged,
    pSpawned,
    pGPSActive,
    Float:pGPSDestX,
    Float:pGPSDestY,
    Float:pGPSDestZ,
    pRegistrationStep,
    pLoginAttempts,
    bool:pLoginScreenActive,
    bool:pRegisterMode,
    Text:pLoginTD[MAX_LOGIN_TEXTDRAWS]
}

new gPlayerInfo[MAX_PLAYERS][pInfo];
new gPlayersOnline = 0;
new gServerUptime = 0;

new gJobNames[][32] = {
    "Desempregado",
    "Taxista",
    "Policial",
    "Medico",
    "Vendedor",
    "Mecanico",
    "Piloto",
    "Jornalista"
};

enum gpsInfo {
    gpsName[32],
    gpsDescription[64],
    Float:gpsX,
    Float:gpsY,
    Float:gpsZ
}

new gGPSLocations[][gpsInfo] = {
    {"Cristo Redentor", "Estatua do Cristo no Corcovado", -2026.0, -1634.0, 140.0},
    {"Pao de Acucar", "Bondinho do Pao de Acucar", -1300.0, -750.0, 80.0},
    {"Copacabana", "Praia de Copacabana", -1810.0, -590.0, 12.0},
    {"Maracana", "Estadio do Maracana", -1680.0, 1000.0, 15.0},
    {"Aeroporto", "Aeroporto Internacional Tom Jobim", 1680.0, -2310.0, 13.5},
    {"Delegacia", "Delegacia PCERJ", 1554.5, -1675.6, 16.2},
    {"Hospital", "Hospital Municipal", 1172.0, -1323.4, 15.4},
    {"Prefeitura", "Prefeitura Municipal", 1481.0, -1772.3, 18.8},
    {"Agencia Emprego", "Agencia de Emprego", 1368.4, -1279.8, 13.5},
    {"Banco Central", "Banco Central", 1462.3, -1011.2, 26.8}
};

main() {
    print("=================================");
    print(GAMEMODE_NAME " " GAMEMODE_VERSION);
    print("=================================");
}

public OnGameModeInit() {
    SetGameModeText(GAMEMODE_NAME " " GAMEMODE_VERSION);
    SendRconCommand("mapname Rio de Janeiro");
    SendRconCommand("hostname " GAMEMODE_NAME);
    
    // Timer principal
    SetTimer("UpdateServer", 1000, true);
    SetTimer("UpdateGPS", 2000, true);
    
    return 1;
}

public OnPlayerConnect(playerid) {
    gPlayersOnline++;
    ResetPlayerData(playerid);
    
    // Timer para mostrar menu automaticamente
    SetTimerEx("MostrarMenuLogin", 2000, false, "i", playerid);
    
    // Camera cinematografica
    SetPlayerCameraPos(playerid, -2025.0, -1635.0, 150.0);
    SetPlayerCameraLookAt(playerid, -2026.0, -1634.0, 140.0);
    TogglePlayerControllable(playerid, 0);
    
    new string[128];
    format(string, sizeof(string), "Bem-vindo ao %s", GAMEMODE_NAME);
    GameTextForPlayer(playerid, string, 3000, 1);
    
    return 1;
}

public OnPlayerDisconnect(playerid, reason) {
    gPlayersOnline--;
    new string[128];
    if(gPlayerInfo[playerid][pLogged]) {
        format(string, sizeof(string), "Player %s desconectou do servidor", gPlayerInfo[playerid][pName]);
        SendClientMessageToAll(COLOR_GREY, string);
    }
    return 1;
}

public OnPlayerSpawn(playerid) {
    if(!gPlayerInfo[playerid][pLogged]) return 0;
    
    SetPlayerPos(playerid, 1680.0, -2310.0, 13.5);
    SetPlayerFacingAngle(playerid, 0.0);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerHealth(playerid, 100.0);
    SetPlayerArmour(playerid, 0.0);
    
    gPlayerInfo[playerid][pSpawned] = 1;
    
    SendClientMessage(playerid, COLOR_GREEN, "Bem-vindo ao Aeroporto Internacional Tom Jobim!");
    SendClientMessage(playerid, COLOR_YELLOW, "Use /ajuda para ver os comandos disponiveis");
    
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[]) {
    new cmd[256], idx;
    cmd = strtok(cmdtext, idx);
    
    if(strcmp("/ajuda", cmd, true) == 0) {
        SendClientMessage(playerid, COLOR_GREEN, "=== COMANDOS DISPONIVEIS ===");
        SendClientMessage(playerid, COLOR_WHITE, "/stats - Ver suas estatisticas");
        SendClientMessage(playerid, COLOR_WHITE, "/gps - Sistema de navegacao GPS");
        SendClientMessage(playerid, COLOR_WHITE, "/emprego - Procurar emprego");
        SendClientMessage(playerid, COLOR_WHITE, "/prefeitura - Servicos municipais");
        SendClientMessage(playerid, COLOR_WHITE, "/rj - Informacoes do servidor");
        SendClientMessage(playerid, COLOR_WHITE, "/cristo /paodeacucar /copacabana /maracana /aeroporto");
        return 1;
    }
    
    if(strcmp("/gps", cmd, true) == 0) {
        new gpsString[1024] = "Escolha um destino:\n\n";
        for(new i = 0; i < sizeof(gGPSLocations); i++) {
            format(gpsString, sizeof(gpsString), "%s%s\n%s\n\n", gpsString, gGPSLocations[i][gpsName], gGPSLocations[i][gpsDescription]);
        }
        ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "Sistema GPS", gpsString, "Ir", "Fechar");
        return 1;
    }
    
    if(strcmp("/stats", cmd, true) == 0) {
        new statsString[512];
        format(statsString, sizeof(statsString), "=== ESTATISTICAS DO PLAYER ===\n\nNome: %s\nLevel: %d\nDinheiro: R$ %d\nBanco: R$ %d\nEmprego: %s\nFaccao: %d\nAdmin: %d\nVIP: %d", gPlayerInfo[playerid][pName], gPlayerInfo[playerid][pLevel], gPlayerInfo[playerid][pMoney], gPlayerInfo[playerid][pBankMoney], gJobNames[gPlayerInfo[playerid][pJob]], gPlayerInfo[playerid][pFactionID], gPlayerInfo[playerid][pAdminLevel], gPlayerInfo[playerid][pVIPLevel]);
        ShowPlayerDialog(playerid, 1000, DIALOG_STYLE_MSGBOX, "Suas Estatisticas", statsString, "Fechar", "");
        return 1;
    }
    
    if(strcmp("/emprego", cmd, true) == 0) {
        if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1368.4, -1279.8, 13.5)) {
            return SendClientMessage(playerid, COLOR_RED, "Voce precisa estar na Agencia de Emprego!");
        }
        new jobString[512] = "Selecione um emprego:\n\n";
        for(new i = 1; i < sizeof(gJobNames); i++) {
            format(jobString, sizeof(jobString), "%s%s\n", jobString, gJobNames[i]);
        }
        ShowPlayerDialog(playerid, DIALOG_JOB_AGENCY, DIALOG_STYLE_LIST, "Agencia de Emprego", jobString, "Escolher", "Fechar");
        return 1;
    }
    
    if(strcmp("/prefeitura", cmd, true) == 0) {
        if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1481.0, -1772.3, 18.8)) {
            return SendClientMessage(playerid, COLOR_RED, "Voce precisa estar na Prefeitura!");
        }
        ShowPlayerDialog(playerid, DIALOG_CITY_HALL, DIALOG_STYLE_LIST, "Prefeitura Municipal", "Carteira de Identidade - R$ 50\nCarteira de Motorista - R$ 200\nLicenca de Arma - R$ 500\nCertidao de Nascimento - R$ 30", "Comprar", "Fechar");
        return 1;
    }
    
    if(strcmp("/cristo", cmd, true) == 0) {
        SetPlayerPos(playerid, -2026.0, -1634.0, 140.0);
        SetPlayerFacingAngle(playerid, 180.0);
        SendClientMessage(playerid, COLOR_GREEN, "Voce foi teleportado para o Cristo Redentor!");
        return 1;
    }
    
    if(strcmp("/paodeacucar", cmd, true) == 0) {
        SetPlayerPos(playerid, -1300.0, -750.0, 80.0);
        SetPlayerFacingAngle(playerid, 180.0);
        SendClientMessage(playerid, COLOR_GREEN, "Voce foi teleportado para o Pao de Acucar!");
        return 1;
    }
    
    if(strcmp("/copacabana", cmd, true) == 0) {
        SetPlayerPos(playerid, -1810.0, -590.0, 12.0);
        SetPlayerFacingAngle(playerid, 180.0);
        SendClientMessage(playerid, COLOR_GREEN, "Voce foi teleportado para Copacabana!");
        return 1;
    }
    
    if(strcmp("/maracana", cmd, true) == 0) {
        SetPlayerPos(playerid, -1680.0, 1000.0, 15.0);
        SetPlayerFacingAngle(playerid, 180.0);
        SendClientMessage(playerid, COLOR_GREEN, "Voce foi teleportado para o Maracana!");
        return 1;
    }
    
    if(strcmp("/aeroporto", cmd, true) == 0) {
        SetPlayerPos(playerid, 1680.0, -2310.0, 13.5);
        SetPlayerFacingAngle(playerid, 0.0);
        SendClientMessage(playerid, COLOR_GREEN, "Voce foi teleportado para o Aeroporto Internacional Tom Jobim!");
        return 1;
    }
    
    return 0;
}

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
    
    GetPlayerName(playerid, gPlayerInfo[playerid][pName], MAX_PLAYER_NAME);
}

forward MostrarMenuLogin(playerid);
public MostrarMenuLogin(playerid) {
    if(!IsPlayerConnected(playerid)) return;
    
    new dialogString[512];
    format(dialogString, sizeof(dialogString), "Bem-vindo ao Rio de Janeiro RolePlay!\n\nOla, %s!\n\nEste e um servidor de roleplay brasileiro\ninspirado na cidade maravilhosa do Rio de Janeiro.\n\nSe voce ja tem uma conta, clique em LOGIN\nSe e novo no servidor, clique em REGISTRAR\n\nVersao: 1.0 | Players Online: %d", gPlayerInfo[playerid][pName], gPlayersOnline);
    
    ShowPlayerDialog(playerid, DIALOG_MAIN_MENU, DIALOG_STYLE_MSGBOX, "Rio de Janeiro RolePlay", dialogString, "Login", "Registrar");
}

forward KickPlayer(playerid);
public KickPlayer(playerid) {
    if(IsPlayerConnected(playerid)) {
        Kick(playerid);
    }
}

forward UpdateGPS();
public UpdateGPS() {
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && gPlayerInfo[i][pLogged] && gPlayerInfo[i][pGPSActive]) {
            new Float:distance = GetPlayerDistanceFromPoint(i, gPlayerInfo[i][pGPSDestX], gPlayerInfo[i][pGPSDestY], gPlayerInfo[i][pGPSDestZ]);
            if(distance < 5.0) {
                SendClientMessage(i, COLOR_GREEN, "GPS: Voce chegou ao seu destino!");
                gPlayerInfo[i][pGPSActive] = 0;
                DisablePlayerCheckpoint(i);
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

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if(dialogid == DIALOG_MAIN_MENU) {
        if(response) {
            ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login - Jogador Existente", "Digite sua senha para acessar o servidor:\n\nPara teste use a senha: 123456", "Entrar", "Voltar");
        } else {
            ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Registro - Novo Jogador", "Digite seu e-mail para criar uma conta:\n\nExemplo: seuemail@gmail.com", "Continuar", "Voltar");
        }
        return 1;
    }
    
    if(dialogid == DIALOG_LOGIN) {
        if(!response) {
            MostrarMenuLogin(playerid);
            return 1;
        }
        
        if(!strlen(inputtext)) {
            ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login - Senha Necessaria", "Voce precisa digitar uma senha!\n\nPara teste use: 123456", "Entrar", "Voltar");
            return 1;
        }
        
        if(strcmp(inputtext, "123456", false) == 0) {
            gPlayerInfo[playerid][pLogged] = 1;
            gPlayerInfo[playerid][pMoney] = 5000;
            gPlayerInfo[playerid][pBankMoney] = 2000;
            gPlayerInfo[playerid][pLevel] = 1;
            gPlayerInfo[playerid][pHealth] = 100.0;
            gPlayerInfo[playerid][pSex] = 1;
            
            TogglePlayerControllable(playerid, 1);
            SetCameraBehindPlayer(playerid);
            
            GameTextForPlayer(playerid, "Login realizado com sucesso!", 3000, 1);
            SendClientMessage(playerid, COLOR_GREEN, "Bem-vindo de volta ao Rio de Janeiro RolePlay!");
            SpawnPlayer(playerid);
        } else {
            gPlayerInfo[playerid][pLoginAttempts]++;
            if(gPlayerInfo[playerid][pLoginAttempts] >= 3) {
                GameTextForPlayer(playerid, "Muitas tentativas incorretas!", 3000, 3);
                SendClientMessage(playerid, COLOR_RED, "Voce sera desconectado por seguranca.");
                SetTimerEx("KickPlayer", 2000, false, "i", playerid);
            } else {
                new string[256];
                format(string, sizeof(string), "Senha incorreta!\n\nTentativas restantes: %d\n\nPara teste use: 123456", 3 - gPlayerInfo[playerid][pLoginAttempts]);
                ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login - Senha Incorreta", string, "Tentar Novamente", "Voltar");
            }
        }
        return 1;
    }
    
    if(dialogid == DIALOG_REGISTER_EMAIL) {
        if(!response) {
            MostrarMenuLogin(playerid);
            return 1;
        }
        
        if(!strlen(inputtext)) {
            ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Registro - E-mail Obrigatorio", "Voce precisa digitar um e-mail!\n\nExemplo: seuemail@gmail.com", "Continuar", "Voltar");
            return 1;
        }
        
        if(strfind(inputtext, "@", true) == -1 || strfind(inputtext, ".", true) == -1) {
            ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Registro - E-mail Invalido", "Formato de e-mail invalido!\n\nUse o formato: exemplo@gmail.com", "Continuar", "Voltar");
            return 1;
        }
        
        format(gPlayerInfo[playerid][pEmail], 64, "%s", inputtext);
        ShowPlayerDialog(playerid, DIALOG_REGISTER_PASSWORD, DIALOG_STYLE_PASSWORD, "Registro - Criar Senha", "Digite uma senha segura para sua conta:\n\nMinimo 6 caracteres", "Criar Conta", "Voltar");
        return 1;
    }
    
    if(dialogid == DIALOG_REGISTER_PASSWORD) {
        if(!response) {
            ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT, "Registro - Novo Jogador", "Digite seu e-mail novamente:", "Continuar", "Voltar");
            return 1;
        }
        
        if(!strlen(inputtext) || strlen(inputtext) < 6) {
            ShowPlayerDialog(playerid, DIALOG_REGISTER_PASSWORD, DIALOG_STYLE_PASSWORD, "Registro - Senha Muito Fraca", "A senha deve ter pelo menos 6 caracteres!", "Criar Conta", "Voltar");
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
        
        GameTextForPlayer(playerid, "Conta criada com sucesso!", 3000, 1);
        SendClientMessage(playerid, COLOR_GREEN, "Bem-vindo ao Rio de Janeiro RolePlay!");
        SpawnPlayer(playerid);
        return 1;
    }
    
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
            format(string, sizeof(string), "Parabens! Voce agora trabalha como %s", gJobNames[listitem + 1]);
            SendClientMessage(playerid, COLOR_GREEN, string);
        }
    }
    
    if(dialogid == DIALOG_CITY_HALL && response) {
        new prices[] = {50, 200, 500, 30};
        new services[][32] = {"Carteira de Identidade", "Carteira de Motorista", "Licenca de Arma", "Certidao de Nascimento"};
        
        if(listitem >= 0 && listitem < sizeof(prices)) {
            if(gPlayerInfo[playerid][pMoney] >= prices[listitem]) {
                gPlayerInfo[playerid][pMoney] -= prices[listitem];
                new string[128];
                format(string, sizeof(string), "Voce comprou: %s por R$ %d", services[listitem], prices[listitem]);
                SendClientMessage(playerid, COLOR_GREEN, string);
            } else {
                SendClientMessage(playerid, COLOR_RED, "Voce nao tem dinheiro suficiente!");
            }
        }
    }
    
    return 1;
}

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

forward UpdateServer();
public UpdateServer() {
    gServerUptime++;
    return 1;
}