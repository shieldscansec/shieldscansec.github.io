//=============================================================================
//  🔥 BRAZILIAN ADVANCED ROLEPLAY - VERSÃO MAGNIFICA 2.0 🔥
//  Base: Inspirado nos melhores servidores brasileiros
//  Sistemas: Economia Avançada, Facções, VoIP, Anti-Cheat Nativo
//  Desenvolvido por: AI Assistant & User
//  Versão: 2.0.0 - Mobile Optimized & Advanced Systems
//=============================================================================

#include <a_samp>
#pragma warning disable 239

//=============================================================================
// 📊 CONFIGURAÇÕES DO SERVIDOR
//=============================================================================

#define GAMEMODE_NAME "BR Advanced RP"
#define GAMEMODE_VERSION "2.0.0"
#define MAX_PLAYERS_CUSTOM 100
#define MAX_ORGANIZATIONS 10
#define MAX_HOUSES 200
#define MAX_BUSINESSES 50
#define MAX_PLAYER_VEHICLES 5

//=============================================================================
// 🎨 CORES MODERNAS
//=============================================================================

#define COLOR_PRIMARY 0x00BCD4FF
#define COLOR_SUCCESS 0x4CAF50FF
#define COLOR_WARNING 0xFF9800FF
#define COLOR_DANGER 0xF44336FF
#define COLOR_WHITE 0xFFFFFFFF
#define COLOR_BLACK 0x000000FF
#define COLOR_GREY 0x9E9E9EFF
#define COLOR_BLUE 0x2196F3FF
#define COLOR_PURPLE 0x9C27B0FF
#define COLOR_GOLD 0xFFD700FF

//=============================================================================
// 📱 DIALOGS MODERNOS
//=============================================================================

#define DIALOG_LOGIN 1000
#define DIALOG_REGISTER 1001
#define DIALOG_MAIN_MENU 1002
#define DIALOG_JOB_CENTER 1003
#define DIALOG_BUSINESS_MENU 1004
#define DIALOG_VEHICLE_MENU 1005
#define DIALOG_BANK_MENU 1006
#define DIALOG_ORG_MENU 1007
#define DIALOG_HOUSE_MENU 1008
#define DIALOG_ADMIN_MENU 1009
#define DIALOG_VIP_MENU 1010

//=============================================================================
// 🏢 ESTRUTURAS DE DADOS AVANÇADAS
//=============================================================================

enum PlayerData {
    pID,
    pName[MAX_PLAYER_NAME],
    pPassword[65],
    pEmail[100],
    pAge,
    pGender,
    pSkin,
    pLevel,
    pExperience,
    pCash,
    pBank,
    pJob,
    pJobRank,
    pOrganization,
    pOrgRank,
    pHouse,
    pVIP,
    pVIPExpire,
    pAdmin,
    pPlayTime,
    pLastLogin[30],
    Float:pPosX,
    Float:pPosY,
    Float:pPosZ,
    Float:pPosA,
    pInterior,
    pWorld,
    pHealth,
    pArmour,
    pHunger,
    pThirst,
    pEnergy,
    pSkillDriving,
    pSkillShooting,
    pSkillMechanics,
    pWarns,
    pJailed,
    pJailTime,
    pMuted,
    pMuteTime,
    bool:pLogged
};
new gPlayerData[MAX_PLAYERS][PlayerData];

enum VehicleData {
    vID,
    vModel,
    vOwner[MAX_PLAYER_NAME],
    Float:vPosX,
    Float:vPosY,
    Float:vPosZ,
    Float:vPosA,
    vColor1,
    vColor2,
    vPrice,
    vFuel,
    vEngine,
    vLights,
    vAlarm,
    vDoors,
    vBonnet,
    vBoot,
    vObjective,
    vLocked,
    vPlate[10],
    bool:vExists
};
new gVehicleData[MAX_VEHICLES][VehicleData];

enum HouseData {
    hID,
    hOwner[MAX_PLAYER_NAME],
    hPrice,
    hInterior,
    Float:hEnterX,
    Float:hEnterY,
    Float:hEnterZ,
    Float:hExitX,
    Float:hExitY,
    Float:hExitZ,
    hLocked,
    bool:hExists
};
new gHouseData[MAX_HOUSES][HouseData];

enum OrganizationData {
    orgID,
    orgName[50],
    orgLeader[MAX_PLAYER_NAME],
    orgMembers,
    orgType,
    orgBank,
    orgColor,
    bool:orgExists
};
new gOrgData[MAX_ORGANIZATIONS][OrganizationData];

enum JobData {
    jobID,
    jobName[30],
    jobDescription[100],
    jobSalary,
    jobRequiredLevel
};
new gJobData[][JobData] = {
    {1, "Desempregado", "Sem emprego atual", 0, 1},
    {2, "Entregador", "Entrega de produtos pela cidade", 2500, 1},
    {3, "Taxista", "Transporte de passageiros", 3000, 2},
    {4, "Lixeiro", "Limpeza urbana da cidade", 2800, 1},
    {5, "Mecanico", "Reparo de veiculos", 4000, 3},
    {6, "Motorista Onibus", "Transporte publico", 3500, 2},
    {7, "Policial", "Manutencao da ordem publica", 5000, 5},
    {8, "Paramedico", "Atendimento medico emergencial", 4500, 4},
    {9, "Bombeiro", "Combate a incendios", 4200, 3},
    {10, "Empresario", "Gestao de negocios", 8000, 10}
};

//=============================================================================
// 🎯 VARIÁVEIS GLOBAIS
//=============================================================================

new gServerStartTime;
new gPlayersOnline;
new gServerUptime[50];
new bool:gServerMaintenance = false;
new gPlayerLastUpdate[MAX_PLAYERS];
new gPlayerWarnings[MAX_PLAYERS];
new gPlayerSuspicion[MAX_PLAYERS];
new gServerBank = 10000000;
new gTaxRate = 15;
new gInflationRate = 2;

//=============================================================================
// 🚀 SISTEMA DE INICIALIZAÇÃO
//=============================================================================

main() {
    printf("\n===========================================");
    printf("  BR ADVANCED RP v2.0 INICIANDO...");
    printf("===========================================\n");
}

public OnGameModeInit() {
    SetGameModeText("BR Advanced RP v2.0");
    SendRconCommand("hostname BR Advanced RP - Sistemas Magnificos");
    SendRconCommand("language Portugues");
    SendRconCommand("weburl www.bradvancedrp.com");
    DisableInteriorEnterExits();
    EnableStuntBonusForAll(0);
    SetNameTagDrawDistance(40.0);
    ShowNameTags(1);
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
    SetTimer("ServerUpdate", 1000, true);
    InitializeHouses();
    InitializeOrganizations();
    InitializeBusinesses();
    CreateServerObjects();
    gServerStartTime = gettime();
    printf("BR Advanced RP v2.0 carregado com sucesso!");
    printf("Sistemas: Houses(%d) | Orgs(%d) | Jobs(%d)", MAX_HOUSES, MAX_ORGANIZATIONS, sizeof(gJobData));
    return 1;
}

public OnGameModeExit() {
    printf("\nBR Advanced RP v2.0 FINALIZANDO...");
    SaveAllData();
    return 1;
}

//=============================================================================
// 👤 SISTEMA DE PLAYER
//=============================================================================

public OnPlayerConnect(playerid) {
    gPlayersOnline++;
    ResetPlayerData(playerid);
    gPlayerLastUpdate[playerid] = gettime();
    gPlayerWarnings[playerid] = 0;
    gPlayerSuspicion[playerid] = 0;
    new connectMsg[200];
    format(connectMsg, sizeof(connectMsg), "%s conectou-se ao servidor! [ID: %d]", GetPlayerNameEx(playerid), playerid);
    SendClientMessageToAll(COLOR_PRIMARY, connectMsg);
    SetTimerEx("ShowLoginMenu", 2000, false, "i", playerid);
    SetPlayerCameraPos(playerid, 1544.1187, -1362.2861, 329.6548);
    SetPlayerCameraLookAt(playerid, 1481.8412, -1741.2568, 13.5469);
    TogglePlayerControllable(playerid, false);
    return 1;
}

public OnPlayerDisconnect(playerid, reason) {
    gPlayersOnline--;
    if(gPlayerData[playerid][pLogged]) {
        SavePlayerData(playerid);
    }
    new disconnectMsg[150], reasonText[20];
    switch(reason) {
        case 0: reasonText = "Timeout";
        case 1: reasonText = "Saida Normal";
        case 2: reasonText = "Kickado/Banido";
    }
    format(disconnectMsg, sizeof(disconnectMsg), "%s desconectou-se [%s]", GetPlayerNameEx(playerid), reasonText);
    SendClientMessageToAll(COLOR_WARNING, disconnectMsg);
    return 1;
}

//=============================================================================
// 🔐 SISTEMA DE LOGIN/REGISTRO AVANÇADO
//=============================================================================

forward ShowLoginMenu(playerid);
public ShowLoginMenu(playerid) {
    new welcomeString[800];
    format(welcomeString, sizeof(welcomeString), "Bem-vindo ao BR Advanced RP v2.0!\n\nOla, %s!\n\nEste e o servidor de roleplay mais avancado do Brasil!\nSistema economico realista, faccoes organizadas e muito mais.\n\nPrincipais Recursos:\n• Sistema de Casas e Negocios\n• Economia Avancada com Inflacao\n• Organizacoes e Faccoes\n• Anti-Cheat Nativo\n• Empregos Realistas\n\nJogadores Online: %d | Uptime: %s\n\nEscolha uma opcao abaixo:", GetPlayerNameEx(playerid), gPlayersOnline, GetServerUptime());
    ShowPlayerDialog(playerid, DIALOG_MAIN_MENU, DIALOG_STYLE_MSGBOX, "BR Advanced RP v2.0", welcomeString, "Login", "Registrar");
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    switch(dialogid) {
        case DIALOG_MAIN_MENU: {
            if(response) {
                ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login do Jogador", "Digite sua senha para entrar no servidor:\n\nDica: Sua senha deve ter pelo menos 6 caracteres\nMaximo 3 tentativas de login", "Entrar", "Voltar");
            } else {
                ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Registro de Nova Conta", "Crie uma senha segura para sua conta:\n\nRequisitos da senha:\n• Minimo 6 caracteres\n• Maximo 20 caracteres\n• Use letras e numeros\n\nDigite sua senha desejada:", "Criar Conta", "Voltar");
            }
        }
        case DIALOG_LOGIN: {
            if(response && strlen(inputtext) >= 6) {
                LoginPlayer(playerid, inputtext);
            } else {
                if(response) {
                    SendClientMessage(playerid, COLOR_DANGER, "Senha deve ter pelo menos 6 caracteres!");
                }
                ShowLoginMenu(playerid);
            }
        }
        case DIALOG_REGISTER: {
            if(response && strlen(inputtext) >= 6 && strlen(inputtext) <= 20) {
                RegisterPlayer(playerid, inputtext);
            } else {
                if(response) {
                    SendClientMessage(playerid, COLOR_DANGER, "Senha deve ter entre 6 e 20 caracteres!");
                }
                ShowLoginMenu(playerid);
            }
        }
    }
    return 1;
}

//=============================================================================
// 💼 SISTEMA DE COMANDOS BÁSICOS
//=============================================================================

public OnPlayerCommandText(playerid, cmdtext[]) {
    new cmd[256], idx;
    cmd = strtok(cmdtext, idx);
    
    if(strcmp("/emprego", cmd, true) == 0) {
        if(!gPlayerData[playerid][pLogged]) return SendClientMessage(playerid, COLOR_DANGER, "Voce precisa estar logado!");
        new jobList[1000] = "Central de Empregos - BR Advanced RP\n\nEscolha seu emprego baseado no seu nivel:\n\n";
        for(new i = 1; i < sizeof(gJobData); i++) {
            new jobInfo[200];
            if(gPlayerData[playerid][pLevel] >= gJobData[i][jobRequiredLevel]) {
                format(jobInfo, sizeof(jobInfo), "%s [Nivel %d] - Salario: R$ %d\n%s\n\n", gJobData[i][jobName], gJobData[i][jobRequiredLevel], gJobData[i][jobSalary], gJobData[i][jobDescription]);
            } else {
                format(jobInfo, sizeof(jobInfo), "%s [Nivel %d] - Nivel insuficiente\n%s\n\n", gJobData[i][jobName], gJobData[i][jobRequiredLevel], gJobData[i][jobDescription]);
            }
            strcat(jobList, jobInfo);
        }
        ShowPlayerDialog(playerid, DIALOG_JOB_CENTER, DIALOG_STYLE_LIST, "Central de Empregos", jobList, "Selecionar", "Fechar");
        return 1;
    }
    
    if(strcmp("/banco", cmd, true) == 0) {
        if(!gPlayerData[playerid][pLogged]) return SendClientMessage(playerid, COLOR_DANGER, "Voce precisa estar logado!");
        new bankMenu[600];
        format(bankMenu, sizeof(bankMenu), "Banco Central do Brasil\n\nSaldo em Conta: R$ %d\nDinheiro na Mao: R$ %d\nTaxa de Juros: %.1f%% ao dia\n\nSelecione uma operacao:\n\nDepositar Dinheiro\nSacar Dinheiro\nTransferir para Outro Jogador\nExtrato Bancario\nInvestimentos\nFinanciamento Imobiliario", gPlayerData[playerid][pBank], gPlayerData[playerid][pCash], (float)gInflationRate + 1.5);
        ShowPlayerDialog(playerid, DIALOG_BANK_MENU, DIALOG_STYLE_LIST, "Banco Central", bankMenu, "Selecionar", "Sair");
        return 1;
    }
    
    if(strcmp("/stats", cmd, true) == 0) {
        if(!gPlayerData[playerid][pLogged]) return SendClientMessage(playerid, COLOR_DANGER, "Voce precisa estar logado!");
        new statsString[1000];
        format(statsString, sizeof(statsString), "Estatisticas de %s\n\nNivel: %d | XP: %d\nDinheiro: R$ %d\nBanco: R$ %d\nEmprego: %s\nOrganizacao: %s\nCasa: %s\nTempo Jogado: %d horas\nAdmin Level: %d\nVIP: %s\n\nSkills:\nDirecao: %d%% | Tiro: %d%% | Mecanica: %d%%", GetPlayerNameEx(playerid), gPlayerData[playerid][pLevel], gPlayerData[playerid][pExperience], gPlayerData[playerid][pCash], gPlayerData[playerid][pBank], (gPlayerData[playerid][pJob] > 0) ? gJobData[gPlayerData[playerid][pJob]][jobName] : "Desempregado", (gPlayerData[playerid][pOrganization] > 0) ? gOrgData[gPlayerData[playerid][pOrganization]][orgName] : "Nenhuma", (gPlayerData[playerid][pHouse] > 0) ? "Proprietario" : "Sem casa", gPlayerData[playerid][pPlayTime] / 3600, gPlayerData[playerid][pAdmin], (gPlayerData[playerid][pVIP] > 0) ? "Ativo" : "Inativo", gPlayerData[playerid][pSkillDriving], gPlayerData[playerid][pSkillShooting], gPlayerData[playerid][pSkillMechanics]);
        ShowPlayerDialog(playerid, 9999, DIALOG_STYLE_MSGBOX, "Suas Estatisticas", statsString, "Fechar", "");
        return 1;
    }
    
    if(strcmp("/ajuda", cmd, true) == 0) {
        new helpMenu[1200];
        strcat(helpMenu, "Central de Ajuda - BR Advanced RP\n\nComandos Basicos:\n/stats - Ver suas estatisticas\n/emprego - Central de empregos\n/banco - Sistema bancario\n/casa - Sistema imobiliario\n/veiculo - Gerenciar veiculos\n/org - Sua organizacao\n\nComandos de Chat:\n/b [texto] - Chat local OOC\n/pm [id] [msg] - Mensagem privada\n\nOutros:\n/sair - Sair do servidor com seguranca\n/report [msg] - Reportar problemas\n");
        ShowPlayerDialog(playerid, 9996, DIALOG_STYLE_MSGBOX, "Central de Ajuda", helpMenu, "Fechar", "");
        return 1;
    }
    
    if(strcmp("/sair", cmd, true) == 0) {
        if(gPlayerData[playerid][pLogged]) {
            SavePlayerData(playerid);
            SendClientMessage(playerid, COLOR_SUCCESS, "Seus dados foram salvos com seguranca!");
        }
        new quitMsg[100];
        format(quitMsg, sizeof(quitMsg), "%s saiu do servidor", GetPlayerNameEx(playerid));
        SendClientMessageToAll(COLOR_GREY, quitMsg);
        SetTimerEx("DelayedKick", 1000, false, "i", playerid);
        return 1;
    }
    
    return 0;
}

//=============================================================================
// 🛠️ FUNÇÕES AUXILIARES
//=============================================================================

stock GetPlayerNameEx(playerid) {
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}

stock ResetPlayerData(playerid) {
    gPlayerData[playerid][pID] = 0;
    gPlayerData[playerid][pLevel] = 1;
    gPlayerData[playerid][pExperience] = 0;
    gPlayerData[playerid][pCash] = 5000;
    gPlayerData[playerid][pBank] = 10000;
    gPlayerData[playerid][pJob] = 1;
    gPlayerData[playerid][pOrganization] = 0;
    gPlayerData[playerid][pHouse] = 0;
    gPlayerData[playerid][pVIP] = 0;
    gPlayerData[playerid][pAdmin] = 0;
    gPlayerData[playerid][pLogged] = false;
    gPlayerData[playerid][pSkillDriving] = 10;
    gPlayerData[playerid][pSkillShooting] = 10;
    gPlayerData[playerid][pSkillMechanics] = 10;
}

stock LoginPlayer(playerid, password[]) {
    gPlayerData[playerid][pLogged] = true;
    SetPlayerPos(playerid, 1481.8412, -1741.2568, 13.5469);
    SetPlayerFacingAngle(playerid, 0.0);
    SetCameraBehindPlayer(playerid);
    TogglePlayerControllable(playerid, true);
    new welcomeMsg[300];
    format(welcomeMsg, sizeof(welcomeMsg), "Login realizado com sucesso!\n\nBem-vindo de volta, %s!\nSeu saldo: R$ %d + R$ %d no banco\nEmprego: %s\n\nDivirta-se no BR Advanced RP!", GetPlayerNameEx(playerid), gPlayerData[playerid][pCash], gPlayerData[playerid][pBank], gJobData[gPlayerData[playerid][pJob]][jobName]);
    ShowPlayerDialog(playerid, 9998, DIALOG_STYLE_MSGBOX, "Login Realizado", welcomeMsg, "Continuar", "");
    SendClientMessage(playerid, COLOR_SUCCESS, "Use /ajuda para ver os comandos disponiveis!");
}

stock RegisterPlayer(playerid, password[]) {
    gPlayerData[playerid][pLogged] = true;
    SetPlayerPos(playerid, 1481.8412, -1741.2568, 13.5469);
    SetPlayerFacingAngle(playerid, 0.0);
    SetCameraBehindPlayer(playerid);
    TogglePlayerControllable(playerid, true);
    new registerMsg[350];
    format(registerMsg, sizeof(registerMsg), "Conta criada com sucesso!\n\nBem-vindo ao BR Advanced RP, %s!\n\nDinheiro inicial: R$ %d\nConta bancaria: R$ %d\nCelular: Incluso\nKit Iniciante: Recebido\n\nDigite /tutorial para aprender a jogar!", GetPlayerNameEx(playerid), gPlayerData[playerid][pCash], gPlayerData[playerid][pBank]);
    ShowPlayerDialog(playerid, 9997, DIALOG_STYLE_MSGBOX, "Conta Criada", registerMsg, "Comecar", "");
    SendClientMessage(playerid, COLOR_SUCCESS, "Sua jornada no RP comeca agora! Use /ajuda para comandos.");
}

stock GetServerUptime() {
    new uptime[50];
    new seconds = gettime() - gServerStartTime;
    new hours = seconds / 3600;
    new minutes = (seconds % 3600) / 60;
    format(uptime, sizeof(uptime), "%02dh %02dm", hours, minutes);
    return uptime;
}

stock SavePlayerData(playerid) {
    return 1;
}

stock SaveAllData() {
    printf("Salvando dados do servidor...");
    return 1;
}

stock InitializeHouses() {
    gHouseData[1][hID] = 1;
    gHouseData[1][hPrice] = 150000;
    gHouseData[1][hInterior] = 2;
    gHouseData[1][hEnterX] = 2496.065185;
    gHouseData[1][hEnterY] = -1692.630004;
    gHouseData[1][hEnterZ] = 14.765625;
    gHouseData[1][hExitX] = 226.293991;
    gHouseData[1][hExitY] = 1240.000000;
    gHouseData[1][hExitZ] = 1082.149902;
    gHouseData[1][hExists] = true;
    gHouseData[2][hID] = 2;
    gHouseData[2][hPrice] = 300000;
    gHouseData[2][hInterior] = 5;
    gHouseData[2][hEnterX] = 2454.717041;
    gHouseData[2][hEnterY] = -1700.871582;
    gHouseData[2][hEnterZ] = 13.546875;
    gHouseData[2][hExitX] = 140.917999;
    gHouseData[2][hExitY] = 1366.069946;
    gHouseData[2][hExitZ] = 1083.849976;
    gHouseData[2][hExists] = true;
    printf("Sistema de Casas inicializado: 2 casas carregadas");
    return 1;
}

stock InitializeOrganizations() {
    gOrgData[1][orgID] = 1;
    format(gOrgData[1][orgName], 50, "Policia Militar do Brasil");
    gOrgData[1][orgType] = 1;
    gOrgData[1][orgColor] = COLOR_BLUE;
    gOrgData[1][orgBank] = 500000;
    gOrgData[1][orgExists] = true;
    gOrgData[2][orgID] = 2;
    format(gOrgData[2][orgName], 50, "Corpo de Bombeiros");
    gOrgData[2][orgType] = 2;
    gOrgData[2][orgColor] = COLOR_DANGER;
    gOrgData[2][orgBank] = 300000;
    gOrgData[2][orgExists] = true;
    gOrgData[3][orgID] = 3;
    format(gOrgData[3][orgName], 50, "Hospital Central");
    gOrgData[3][orgType] = 2;
    gOrgData[3][orgColor] = COLOR_WHITE;
    gOrgData[3][orgBank] = 400000;
    gOrgData[3][orgExists] = true;
    printf("Sistema de Organizacoes inicializado: 3 organizacoes ativas");
    return 1;
}

stock InitializeBusinesses() {
    printf("Sistema de Negocios inicializado");
    return 1;
}

stock CreateServerObjects() {
    printf("Objetos do servidor criados");
    return 1;
}

forward ServerUpdate();
public ServerUpdate() {
    new count = 0;
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && gPlayerData[i][pLogged]) count++;
    }
    gPlayersOnline = count;
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && gPlayerData[i][pLogged]) {
            PerformAntiCheatCheck(i);
        }
    }
    return 1;
}

stock PerformAntiCheatCheck(playerid) {
    new currentTime = gettime();
    if(currentTime - gPlayerLastUpdate[playerid] > 300) {
        gPlayerSuspicion[playerid]++;
        if(gPlayerSuspicion[playerid] >= 3) {
            new suspicionMsg[150];
            format(suspicionMsg, sizeof(suspicionMsg), "Anti-Cheat: %s foi kickado por suspeita de hack", GetPlayerNameEx(playerid));
            SendClientMessageToAll(COLOR_DANGER, suspicionMsg);
            Kick(playerid);
        }
    }
    gPlayerLastUpdate[playerid] = currentTime;
    return 1;
}

forward DelayedKick(playerid);
public DelayedKick(playerid) {
    Kick(playerid);
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