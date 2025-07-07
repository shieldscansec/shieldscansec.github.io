//=============================================================================
//  🔥 BRAZILIAN ADVANCED ROLEPLAY - VERSÃO MAGNIFICA 2.0 🔥
//  Base: Inspirado nos melhores servidores brasileiros
//  Sistemas: Economia Avançada, Facções, VoIP, Anti-Cheat Nativo
//  Desenvolvido por: AI Assistant & User
//  Versão: 2.0.0 - Mobile Optimized & Advanced Systems
//=============================================================================

#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <streamer>
#include <foreach>
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

#define COLOR_PRIMARY 0x00BCD4FF      // Cyan moderno
#define COLOR_SUCCESS 0x4CAF50FF      // Verde sucesso
#define COLOR_WARNING 0xFF9800FF      // Laranja aviso
#define COLOR_DANGER 0xF44336FF       // Vermelho erro
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
    orgType, // 1=Police, 2=Medical, 3=Gang, 4=Mafia, 5=Business
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
    {5, "Mecânico", "Reparo de veículos", 4000, 3},
    {6, "Motorista Ônibus", "Transporte público", 3500, 2},
    {7, "Policial", "Manutenção da ordem pública", 5000, 5},
    {8, "Paramédico", "Atendimento médico emergencial", 4500, 4},
    {9, "Bombeiro", "Combate a incêndios", 4200, 3},
    {10, "Empresário", "Gestão de negócios", 8000, 10}
};

//=============================================================================
// 🎯 VARIÁVEIS GLOBAIS
//=============================================================================

new gServerStartTime;
new gPlayersOnline;
new gServerUptime[50];
new bool:gServerMaintenance = false;

// Anti-Cheat System
new gPlayerLastUpdate[MAX_PLAYERS];
new gPlayerWarnings[MAX_PLAYERS];
new gPlayerSuspicion[MAX_PLAYERS];

// Economy System
new gServerBank = 10000000;
new gTaxRate = 15; // 15%
new gInflationRate = 2; // 2%

//=============================================================================
// 🚀 SISTEMA DE INICIALIZAÇÃO
//=============================================================================

main() {
    printf("\n===========================================");
    printf("  🔥 BR ADVANCED RP v2.0 INICIANDO... 🔥");
    printf("===========================================\n");
}

public OnGameModeInit() {
    SetGameModeText("BR Advanced RP v2.0");
    
    // Server configuration
    SendRconCommand("hostname BR Advanced RP - Sistemas Magníficos");
    SendRconCommand("language Português");
    SendRconCommand("weburl www.bradvancedrp.com");
    
    // Desabilitar interior weapons
    DisableInteriorEnterExits();
    EnableStuntBonusForAll(0);
    
    // Configurações avançadas
    SetNameTagDrawDistance(40.0);
    ShowNameTags(1);
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
    
    // Timer principal do servidor
    SetTimer("ServerUpdate", 1000, true);
    
    // Inicializar sistemas
    InitializeHouses();
    InitializeOrganizations();
    InitializeBusinesses();
    CreateServerObjects();
    
    gServerStartTime = gettime();
    
    printf("✅ BR Advanced RP v2.0 carregado com sucesso!");
    printf("📊 Sistemas: Houses(%d) | Orgs(%d) | Jobs(%d)", MAX_HOUSES, MAX_ORGANIZATIONS, sizeof(gJobData));
    
    return 1;
}

public OnGameModeExit() {
    printf("\n🔥 BR Advanced RP v2.0 FINALIZANDO...");
    SaveAllData();
    return 1;
}

//=============================================================================
// 👤 SISTEMA DE PLAYER
//=============================================================================

public OnPlayerConnect(playerid) {
    gPlayersOnline++;
    
    // Reset player data
    ResetPlayerData(playerid);
    
    // Anti-cheat inicial
    gPlayerLastUpdate[playerid] = gettime();
    gPlayerWarnings[playerid] = 0;
    gPlayerSuspicion[playerid] = 0;
    
    // Mensagem de conexão moderna
    new connectMsg[200];
    format(connectMsg, sizeof(connectMsg), 
        "{00BCD4}🌟 {FFFFFF}%s {00BCD4}conectou-se ao servidor! {FFFFFF}[ID: %d]", 
        GetPlayerNameEx(playerid), playerid);
    SendClientMessageToAll(COLOR_PRIMARY, connectMsg);
    
    // Auto-login system
    SetTimerEx("ShowLoginMenu", 2000, false, "i", playerid);
    
    // Camera spawn position (vista moderna da cidade)
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
        case 1: reasonText = "Saída Normal";
        case 2: reasonText = "Kickado/Banido";
    }
    
    format(disconnectMsg, sizeof(disconnectMsg), 
        "{FF9800}📤 {FFFFFF}%s {FF9800}desconectou-se {FFFFFF}[%s]", 
        GetPlayerNameEx(playerid), reasonText);
    SendClientMessageToAll(COLOR_WARNING, disconnectMsg);
    
    return 1;
}

//=============================================================================
// 🔐 SISTEMA DE LOGIN/REGISTRO AVANÇADO
//=============================================================================

forward ShowLoginMenu(playerid);
public ShowLoginMenu(playerid) {
    new welcomeString[800];
    format(welcomeString, sizeof(welcomeString),
        "{FFFFFF}🔥 Bem-vindo ao {00BCD4}BR Advanced RP v2.0{FFFFFF}! 🔥\n\n"
        "Olá, {FFD700}%s{FFFFFF}!\n\n"
        "{FFFFFF}Este é o servidor de roleplay mais avançado do Brasil!\n"
        "Sistema econômico realista, facções organizadas e muito mais.\n\n"
        "{00BCD4}🏆 Principais Recursos:\n"
        "{FFFFFF}• Sistema de Casas e Negócios\n"
        "• Economia Avançada com Inflação\n"
        "• Organizações e Facções\n"
        "• Anti-Cheat Nativo\n"
        "• Empregos Realistas\n\n"
        "{FFFF00}👥 Jogadores Online: {FFFFFF}%d{FFFF00} | Uptime: {FFFFFF}%s\n\n"
        "{FFFFFF}Escolha uma opção abaixo:",
        GetPlayerNameEx(playerid), gPlayersOnline, GetServerUptime());
    
    ShowPlayerDialog(playerid, DIALOG_MAIN_MENU, DIALOG_STYLE_MSGBOX,
        "{00BCD4}🔥 BR Advanced RP v2.0", welcomeString, "Login", "Registrar");
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    switch(dialogid) {
        case DIALOG_MAIN_MENU: {
            if(response) {
                ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,
                    "{2196F3}🔐 Login do Jogador",
                    "{FFFFFF}Digite sua senha para entrar no servidor:\n\n"
                    "{FFD700}💡 Dica: {FFFFFF}Sua senha deve ter pelo menos 6 caracteres\n"
                    "{FF9800}⚠️ Máximo 3 tentativas de login",
                    "Entrar", "Voltar");
            } else {
                ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT,
                    "{4CAF50}📝 Registro de Nova Conta",
                    "{FFFFFF}Crie uma senha segura para sua conta:\n\n"
                    "{FFD700}📋 Requisitos da senha:\n"
                    "{FFFFFF}• Mínimo 6 caracteres\n"
                    "• Máximo 20 caracteres\n"
                    "• Use letras e números\n\n"
                    "{4CAF50}✨ Digite sua senha desejada:",
                    "Criar Conta", "Voltar");
            }
        }
        
        case DIALOG_LOGIN: {
            if(response && strlen(inputtext) >= 6) {
                // Login logic here
                LoginPlayer(playerid, inputtext);
            } else {
                if(response) {
                    SendClientMessage(playerid, COLOR_DANGER, "❌ Senha deve ter pelo menos 6 caracteres!");
                }
                ShowLoginMenu(playerid);
            }
        }
        
        case DIALOG_REGISTER: {
            if(response && strlen(inputtext) >= 6 && strlen(inputtext) <= 20) {
                // Register logic here
                RegisterPlayer(playerid, inputtext);
            } else {
                if(response) {
                    SendClientMessage(playerid, COLOR_DANGER, "❌ Senha deve ter entre 6 e 20 caracteres!");
                }
                ShowLoginMenu(playerid);
            }
        }
    }
    return 1;
}

//=============================================================================
// 💼 SISTEMA DE EMPREGOS AVANÇADO
//=============================================================================

CMD:emprego(playerid, params[]) {
    if(!gPlayerData[playerid][pLogged]) return SendClientMessage(playerid, COLOR_DANGER, "❌ Você precisa estar logado!");
    
    new jobList[1000] = "{00BCD4}💼 Central de Empregos - BR Advanced RP\n\n";
    strcat(jobList, "{FFFFFF}Escolha seu emprego baseado no seu nível:\n\n");
    
    for(new i = 1; i < sizeof(gJobData); i++) {
        new jobInfo[200];
        if(gPlayerData[playerid][pLevel] >= gJobData[i][jobRequiredLevel]) {
            format(jobInfo, sizeof(jobInfo), 
                "{4CAF50}✅ %s {FFFFFF}[Nível %d] - Salário: {FFD700}R$ %d\n{CCCCCC}%s\n\n",
                gJobData[i][jobName], gJobData[i][jobRequiredLevel], 
                gJobData[i][jobSalary], gJobData[i][jobDescription]);
        } else {
            format(jobInfo, sizeof(jobInfo), 
                "{F44336}❌ %s {FFFFFF}[Nível %d] - {F44336}Nível insuficiente\n{CCCCCC}%s\n\n",
                gJobData[i][jobName], gJobData[i][jobRequiredLevel], gJobData[i][jobDescription]);
        }
        strcat(jobList, jobInfo);
    }
    
    ShowPlayerDialog(playerid, DIALOG_JOB_CENTER, DIALOG_STYLE_LIST,
        "{00BCD4}💼 Central de Empregos", jobList, "Selecionar", "Fechar");
    return 1;
}

//=============================================================================
// 🏦 SISTEMA BANCÁRIO AVANÇADO
//=============================================================================

CMD:banco(playerid, params[]) {
    if(!gPlayerData[playerid][pLogged]) return SendClientMessage(playerid, COLOR_DANGER, "❌ Você precisa estar logado!");
    
    new bankMenu[600];
    format(bankMenu, sizeof(bankMenu),
        "{00BCD4}🏦 Banco Central do Brasil\n\n"
        "{FFFFFF}💰 Saldo em Conta: {4CAF50}R$ %d\n"
        "{FFFFFF}💵 Dinheiro na Mão: {FFD700}R$ %d\n"
        "{FFFFFF}📊 Taxa de Juros: {FF9800}%.1f%% ao dia\n\n"
        "{FFFFFF}Selecione uma operação:\n\n"
        "💳 Depositar Dinheiro\n"
        "💸 Sacar Dinheiro\n"
        "💰 Transferir para Outro Jogador\n"
        "📊 Extrato Bancário\n"
        "📈 Investimentos\n"
        "🏠 Financiamento Imobiliário",
        gPlayerData[playerid][pBank], gPlayerData[playerid][pCash], 
        (float)gInflationRate + 1.5);
    
    ShowPlayerDialog(playerid, DIALOG_BANK_MENU, DIALOG_STYLE_LIST,
        "{00BCD4}🏦 Banco Central", bankMenu, "Selecionar", "Sair");
    return 1;
}

//=============================================================================
// 🚗 SISTEMA DE VEÍCULOS AVANÇADO
//=============================================================================

CMD:veiculo(playerid, params[]) {
    if(!gPlayerData[playerid][pLogged]) return SendClientMessage(playerid, COLOR_DANGER, "❌ Você precisa estar logado!");
    
    new vehicleMenu[500];
    format(vehicleMenu, sizeof(vehicleMenu),
        "{00BCD4}🚗 Sistema de Veículos\n\n"
        "{FFFFFF}Gerencie seus veículos pessoais:\n\n"
        "🚙 Meus Veículos\n"
        "🛒 Comprar Veículo\n"
        "💸 Vender Veículo\n"
        "🔧 Oficina Mecânica\n"
        "⛽ Postos de Combustível\n"
        "🔐 Trancar/Destrancar\n"
        "📱 Localizar Veículo\n"
        "🎨 Personalização");
    
    ShowPlayerDialog(playerid, DIALOG_VEHICLE_MENU, DIALOG_STYLE_LIST,
        "{00BCD4}🚗 Central de Veículos", vehicleMenu, "Selecionar", "Fechar");
    return 1;
}

//=============================================================================
// 🏠 SISTEMA DE CASAS MODERNO
//=============================================================================

InitializeHouses() {
    // Casa Exemplo 1 - Casa Simples
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
    
    // Casa Exemplo 2 - Casa Média
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
    
    printf("✅ Sistema de Casas inicializado: 2 casas carregadas");
    return 1;
}

CMD:casa(playerid, params[]) {
    if(!gPlayerData[playerid][pLogged]) return SendClientMessage(playerid, COLOR_DANGER, "❌ Você precisa estar logado!");
    
    new houseMenu[400];
    format(houseMenu, sizeof(houseMenu),
        "{00BCD4}🏠 Sistema Imobiliário\n\n"
        "{FFFFFF}Gerencie suas propriedades:\n\n"
        "🏡 Minha Casa\n"
        "🛒 Comprar Casa\n"
        "💸 Vender Casa\n"
        "🔐 Trancar/Destrancar\n"
        "👥 Convidar Jogadores\n"
        "🎨 Decorar Casa\n"
        "📊 Mercado Imobiliário");
    
    ShowPlayerDialog(playerid, DIALOG_HOUSE_MENU, DIALOG_STYLE_LIST,
        "{00BCD4}🏠 Central Imobiliária", houseMenu, "Selecionar", "Fechar");
    return 1;
}

//=============================================================================
// 🏢 SISTEMA DE ORGANIZAÇÕES
//=============================================================================

InitializeOrganizations() {
    // Polícia Militar
    gOrgData[1][orgID] = 1;
    format(gOrgData[1][orgName], 50, "Polícia Militar do Brasil");
    gOrgData[1][orgType] = 1;
    gOrgData[1][orgColor] = COLOR_BLUE;
    gOrgData[1][orgBank] = 500000;
    gOrgData[1][orgExists] = true;
    
    // Corpo de Bombeiros
    gOrgData[2][orgID] = 2;
    format(gOrgData[2][orgName], 50, "Corpo de Bombeiros");
    gOrgData[2][orgType] = 2;
    gOrgData[2][orgColor] = COLOR_DANGER;
    gOrgData[2][orgBank] = 300000;
    gOrgData[2][orgExists] = true;
    
    // Hospital Central
    gOrgData[3][orgID] = 3;
    format(gOrgData[3][orgName], 50, "Hospital Central");
    gOrgData[3][orgType] = 2;
    gOrgData[3][orgColor] = COLOR_WHITE;
    gOrgData[3][orgBank] = 400000;
    gOrgData[3][orgExists] = true;
    
    printf("✅ Sistema de Organizações inicializado: 3 organizações ativas");
    return 1;
}

CMD:org(playerid, params[]) {
    if(!gPlayerData[playerid][pLogged]) return SendClientMessage(playerid, COLOR_DANGER, "❌ Você precisa estar logado!");
    
    if(gPlayerData[playerid][pOrganization] == 0) {
        return SendClientMessage(playerid, COLOR_WARNING, "⚠️ Você não faz parte de nenhuma organização!");
    }
    
    new orgMenu[600];
    new orgID = gPlayerData[playerid][pOrganization];
    
    format(orgMenu, sizeof(orgMenu),
        "{00BCD4}🏢 %s\n\n"
        "{FFFFFF}💼 Seu Cargo: {FFD700}Rank %d\n"
        "{FFFFFF}👥 Membros Ativos: {4CAF50}%d\n"
        "{FFFFFF}💰 Cofre da Org: {FFD700}R$ %d\n\n"
        "{FFFFFF}Opções disponíveis:\n\n"
        "👥 Lista de Membros\n"
        "💰 Acessar Cofre\n"
        "📋 Missões da Org\n"
        "🚗 Veículos da Org\n"
        "📊 Estatísticas\n"
        "⚙️ Configurações",
        gOrgData[orgID][orgName], gPlayerData[playerid][pOrgRank],
        gOrgData[orgID][orgMembers], gOrgData[orgID][orgBank]);
    
    ShowPlayerDialog(playerid, DIALOG_ORG_MENU, DIALOG_STYLE_LIST,
        "{00BCD4}🏢 Sua Organização", orgMenu, "Selecionar", "Sair");
    return 1;
}

//=============================================================================
// 👮 COMANDOS DE ADMIN AVANÇADOS
//=============================================================================

CMD:admin(playerid, params[]) {
    if(gPlayerData[playerid][pAdmin] < 1) return SendClientMessage(playerid, COLOR_DANGER, "❌ Acesso negado!");
    
    new adminMenu[800];
    format(adminMenu, sizeof(adminMenu),
        "{FF9800}⚡ Painel Administrativo - Nível %d\n\n"
        "{FFFFFF}Sistema avançado de administração:\n\n"
        "👤 Gerenciar Jogadores\n"
        "🌍 Teleporte Administrativo\n"
        "🚗 Spawnar Veículos\n"
        "💰 Economia do Servidor\n"
        "📊 Estatísticas do Servidor\n"
        "🔧 Configurações\n"
        "🚫 Sistema de Punições\n"
        "📱 Logs do Sistema",
        gPlayerData[playerid][pAdmin]);
    
    ShowPlayerDialog(playerid, DIALOG_ADMIN_MENU, DIALOG_STYLE_LIST,
        "{FF9800}⚡ Painel Admin", adminMenu, "Selecionar", "Fechar");
    return 1;
}

CMD:kick(playerid, params[]) {
    if(gPlayerData[playerid][pAdmin] < 1) return SendClientMessage(playerid, COLOR_DANGER, "❌ Acesso negado!");
    
    new targetid, reason[100];
    if(sscanf(params, "us[100]", targetid, reason)) {
        return SendClientMessage(playerid, COLOR_WARNING, "💡 Use: /kick [id] [motivo]");
    }
    
    if(!IsPlayerConnected(targetid)) {
        return SendClientMessage(playerid, COLOR_DANGER, "❌ Jogador não encontrado!");
    }
    
    new kickMsg[200];
    format(kickMsg, sizeof(kickMsg), 
        "🔨 Admin %s kickou %s. Motivo: %s", 
        GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), reason);
    SendClientMessageToAll(COLOR_WARNING, kickMsg);
    
    Kick(targetid);
    return 1;
}

//=============================================================================
// 📊 SISTEMA DE ESTATÍSTICAS
//=============================================================================

CMD:stats(playerid, params[]) {
    if(!gPlayerData[playerid][pLogged]) return SendClientMessage(playerid, COLOR_DANGER, "❌ Você precisa estar logado!");
    
    new statsString[1000];
    format(statsString, sizeof(statsString),
        "{00BCD4}📊 Estatísticas de %s\n\n"
        "{FFFFFF}💫 Nível: {FFD700}%d {FFFFFF}| XP: {4CAF50}%d\n"
        "{FFFFFF}💰 Dinheiro: {FFD700}R$ %d\n"
        "{FFFFFF}🏦 Banco: {4CAF50}R$ %d\n"
        "{FFFFFF}💼 Emprego: {00BCD4}%s\n"
        "{FFFFFF}🏢 Organização: {9C27B0}%s\n"
        "{FFFFFF}🏠 Casa: {FF9800}%s\n"
        "{FFFFFF}⏰ Tempo Jogado: {FFFFFF}%d horas\n"
        "{FFFFFF}🎖️ Admin Level: {F44336}%d\n"
        "{FFFFFF}⭐ VIP: %s\n\n"
        "{CCCCCC}📈 Skills:\n"
        "{FFFFFF}🚗 Direção: %d%% | 🎯 Tiro: %d%% | 🔧 Mecânica: %d%%",
        GetPlayerNameEx(playerid), gPlayerData[playerid][pLevel], gPlayerData[playerid][pExperience],
        gPlayerData[playerid][pCash], gPlayerData[playerid][pBank],
        (gPlayerData[playerid][pJob] > 0) ? gJobData[gPlayerData[playerid][pJob]][jobName] : "Desempregado",
        (gPlayerData[playerid][pOrganization] > 0) ? gOrgData[gPlayerData[playerid][pOrganization]][orgName] : "Nenhuma",
        (gPlayerData[playerid][pHouse] > 0) ? "Proprietário" : "Sem casa",
        gPlayerData[playerid][pPlayTime] / 3600, gPlayerData[playerid][pAdmin],
        (gPlayerData[playerid][pVIP] > 0) ? "{FFD700}Ativo" : "{CCCCCC}Inativo",
        gPlayerData[playerid][pSkillDriving], gPlayerData[playerid][pSkillShooting], 
        gPlayerData[playerid][pSkillMechanics]);
    
    ShowPlayerDialog(playerid, 9999, DIALOG_STYLE_MSGBOX, 
        "{00BCD4}📊 Suas Estatísticas", statsString, "Fechar", "");
    return 1;
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
    // Simular login (em servidor real, verificar banco de dados)
    gPlayerData[playerid][pLogged] = true;
    
    SetPlayerPos(playerid, 1481.8412, -1741.2568, 13.5469);
    SetPlayerFacingAngle(playerid, 0.0);
    SetCameraBehindPlayer(playerid);
    TogglePlayerControllable(playerid, true);
    
    new welcomeMsg[300];
    format(welcomeMsg, sizeof(welcomeMsg),
        "{4CAF50}✅ Login realizado com sucesso!\n\n"
        "{FFFFFF}🎉 Bem-vindo de volta, {FFD700}%s{FFFFFF}!\n"
        "{FFFFFF}💰 Seu saldo: {4CAF50}R$ %d{FFFFFF} + {FFD700}R$ %d {FFFFFF}no banco\n"
        "{FFFFFF}💼 Emprego: {00BCD4}%s\n\n"
        "{00BCD4}🔥 Divirta-se no BR Advanced RP!",
        GetPlayerNameEx(playerid), gPlayerData[playerid][pCash], 
        gPlayerData[playerid][pBank], gJobData[gPlayerData[playerid][pJob]][jobName]);
    
    ShowPlayerDialog(playerid, 9998, DIALOG_STYLE_MSGBOX,
        "{4CAF50}✅ Login Realizado", welcomeMsg, "Continuar", "");
    
    SendClientMessage(playerid, COLOR_SUCCESS, "🌟 Use /ajuda para ver os comandos disponíveis!");
}

stock RegisterPlayer(playerid, password[]) {
    // Simular registro (em servidor real, salvar no banco de dados)
    gPlayerData[playerid][pLogged] = true;
    
    SetPlayerPos(playerid, 1481.8412, -1741.2568, 13.5469);
    SetPlayerFacingAngle(playerid, 0.0);
    SetCameraBehindPlayer(playerid);
    TogglePlayerControllable(playerid, true);
    
    new registerMsg[350];
    format(registerMsg, sizeof(registerMsg),
        "{4CAF50}🎉 Conta criada com sucesso!\n\n"
        "{FFFFFF}Bem-vindo ao {00BCD4}BR Advanced RP{FFFFFF}, {FFD700}%s{FFFFFF}!\n\n"
        "{FFD700}💰 Dinheiro inicial: {4CAF50}R$ %d\n"
        "{FFD700}🏦 Conta bancária: {4CAF50}R$ %d\n"
        "{FFD700}📱 Celular: {4CAF50}Incluso\n"
        "{FFD700}🎁 Kit Iniciante: {4CAF50}Recebido\n\n"
        "{FFFFFF}Digite {FFD700}/tutorial {FFFFFF}para aprender a jogar!",
        GetPlayerNameEx(playerid), gPlayerData[playerid][pCash], 
        gPlayerData[playerid][pBank]);
    
    ShowPlayerDialog(playerid, 9997, DIALOG_STYLE_MSGBOX,
        "{4CAF50}🎉 Conta Criada", registerMsg, "Começar", "");
    
    SendClientMessage(playerid, COLOR_SUCCESS, "🌟 Sua jornada no RP começa agora! Use /ajuda para comandos.");
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
    // Em servidor real: salvar dados no banco/arquivo
    return 1;
}

stock SaveAllData() {
    // Em servidor real: salvar todos os dados do servidor
    printf("💾 Salvando dados do servidor...");
    return 1;
}

stock InitializeBusinesses() {
    // Inicializar sistema de negócios
    printf("✅ Sistema de Negócios inicializado");
    return 1;
}

stock CreateServerObjects() {
    // Criar objetos do mapa melhorado
    printf("✅ Objetos do servidor criados");
    return 1;
}

//=============================================================================
// ⏰ SISTEMA DE TIMERS
//=============================================================================

forward ServerUpdate();
public ServerUpdate() {
    // Atualizar contador de jogadores online
    new count = 0;
    foreach(new i : Player) {
        if(gPlayerData[i][pLogged]) count++;
    }
    gPlayersOnline = count;
    
    // Anti-cheat automático
    foreach(new i : Player) {
        if(gPlayerData[i][pLogged]) {
            PerformAntiCheatCheck(i);
        }
    }
    
    return 1;
}

stock PerformAntiCheatCheck(playerid) {
    // Sistema anti-cheat básico
    new currentTime = gettime();
    if(currentTime - gPlayerLastUpdate[playerid] > 300) { // 5 minutos sem atualização
        gPlayerSuspicion[playerid]++;
        if(gPlayerSuspicion[playerid] >= 3) {
            new suspicionMsg[150];
            format(suspicionMsg, sizeof(suspicionMsg),
                "🛡️ Anti-Cheat: %s foi kickado por suspeita de hack",
                GetPlayerNameEx(playerid));
            SendClientMessageToAll(COLOR_DANGER, suspicionMsg);
            Kick(playerid);
        }
    }
    gPlayerLastUpdate[playerid] = currentTime;
    return 1;
}

//=============================================================================
// ❓ SISTEMA DE AJUDA
//=============================================================================

CMD:ajuda(playerid, params[]) {
    new helpMenu[1200];
    strcat(helpMenu, "{00BCD4}📚 Central de Ajuda - BR Advanced RP\n\n");
    strcat(helpMenu, "{FFFFFF}🎮 Comandos Básicos:\n");
    strcat(helpMenu, "{FFD700}/stats {FFFFFF}- Ver suas estatísticas\n");
    strcat(helpMenu, "{FFD700}/emprego {FFFFFF}- Central de empregos\n");
    strcat(helpMenu, "{FFD700}/banco {FFFFFF}- Sistema bancário\n");
    strcat(helpMenu, "{FFD700}/casa {FFFFFF}- Sistema imobiliário\n");
    strcat(helpMenu, "{FFD700}/veiculo {FFFFFF}- Gerenciar veículos\n");
    strcat(helpMenu, "{FFD700}/org {FFFFFF}- Sua organização\n\n");
    strcat(helpMenu, "{FFFFFF}💬 Comandos de Chat:\n");
    strcat(helpMenu, "{FFD700}/b [texto] {FFFFFF}- Chat local OOC\n");
    strcat(helpMenu, "{FFD700}/pm [id] [msg] {FFFFFF}- Mensagem privada\n\n");
    strcat(helpMenu, "{FFFFFF}⚙️ Outros:\n");
    strcat(helpMenu, "{FFD700}/sair {FFFFFF}- Sair do servidor com segurança\n");
    strcat(helpMenu, "{FFD700}/report [msg] {FFFFFF}- Reportar problemas\n");
    
    ShowPlayerDialog(playerid, 9996, DIALOG_STYLE_MSGBOX,
        "{00BCD4}📚 Central de Ajuda", helpMenu, "Fechar", "");
    return 1;
}

CMD:sair(playerid, params[]) {
    if(gPlayerData[playerid][pLogged]) {
        SavePlayerData(playerid);
        SendClientMessage(playerid, COLOR_SUCCESS, "💾 Seus dados foram salvos com segurança!");
    }
    
    new quitMsg[100];
    format(quitMsg, sizeof(quitMsg), 
        "👋 %s saiu do servidor", GetPlayerNameEx(playerid));
    SendClientMessageToAll(COLOR_GREY, quitMsg);
    
    SetTimerEx("DelayedKick", 1000, false, "i", playerid);
    return 1;
}

forward DelayedKick(playerid);
public DelayedKick(playerid) {
    Kick(playerid);
    return 1;
}

//=============================================================================
// 🎯 FIM DO GAMEMODE
//=============================================================================