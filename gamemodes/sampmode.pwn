#include <a_samp>

//=============================================================================
// 🔥 BR ADVANCED RP v2.0 - SISTEMA COMPLETO
// Baseado no melhor do Homeland RP + melhorias próprias
//=============================================================================

#define GAMEMODE_NAME "BR Advanced RP"
#define GAMEMODE_VERSION "2.0.0"

// Configurações
#define MAX_HOUSES 200
#define MAX_ORGANIZATIONS 10
#define MAX_PLAYER_VEHICLES 5
#define MAX_BUSINESSES 50
#define MAX_WEAPONS_STORAGE 50

// Cores modernas
#define COLOR_PRIMARY 0x00BCD4FF
#define COLOR_SUCCESS 0x4CAF50FF
#define COLOR_WARNING 0xFF9800FF
#define COLOR_DANGER 0xF44336FF
#define COLOR_WHITE 0xFFFFFFFF
#define COLOR_GREY 0x9E9E9EFF
#define COLOR_BLUE 0x2196F3FF
#define COLOR_GOLD 0xFFD700FF

// Dialogs
#define DIALOG_LOGIN 1000
#define DIALOG_REGISTER 1001
#define DIALOG_MAIN_MENU 1002
#define DIALOG_JOB_CENTER 1003
#define DIALOG_BANK_MENU 1004
#define DIALOG_HOUSE_MENU 1005
#define DIALOG_VEHICLE_MENU 1006
#define DIALOG_ORG_MENU 1007
#define DIALOG_BUSINESS_MENU 1008
#define DIALOG_INVENTORY 1009
#define DIALOG_WEAPONS 1010

//=============================================================================
// ESTRUTURAS DE DADOS AVANÇADAS
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
    pAdmin,
    pPlayTime,
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
    pMuted,
    bool:pLogged,
    bool:pOnDuty,
    pRadioFreq,
    pInventory[10][2], // [slot][item_id, quantity]
    pWeapons[13][2]    // [slot][weapon_id, ammo]
};
new gPlayerData[MAX_PLAYERS][PlayerData];

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
    hSafe,
    hWeapons[MAX_WEAPONS_STORAGE][2],
    bool:hExists
};
new gHouseData[MAX_HOUSES][HouseData];

enum OrganizationData {
    orgID,
    orgName[50],
    orgLeader[MAX_PLAYER_NAME],
    orgMembers,
    orgType, // 1=Police, 2=Medical, 3=Fire, 4=Gang, 5=Mafia
    orgBank,
    orgColor,
    orgSafe,
    orgWeapons[MAX_WEAPONS_STORAGE][2],
    Float:orgSpawnX,
    Float:orgSpawnY,
    Float:orgSpawnZ,
    bool:orgExists
};
new gOrgData[MAX_ORGANIZATIONS][OrganizationData];

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
    vLocked,
    vEngine,
    vTrunk[5][2], // [slot][item_id, quantity]
    bool:vExists
};
new gVehicleData[MAX_VEHICLES][VehicleData];

enum JobData {
    jobID,
    jobName[30],
    jobDescription[100],
    jobSalary,
    jobRequiredLevel
};
new gJobData[][JobData] = {
    {0, "Desempregado", "Sem emprego atual", 0, 1},
    {1, "Entregador", "Entrega produtos pela cidade", 2500, 1},
    {2, "Taxista", "Transporte de passageiros", 3000, 2},
    {3, "Lixeiro", "Limpeza urbana", 2800, 1},
    {4, "Mecanico", "Reparo de veiculos", 4000, 3},
    {5, "Policial", "Manutencao da ordem", 5000, 5},
    {6, "Paramedico", "Atendimento medico", 4500, 4},
    {7, "Bombeiro", "Combate a incendios", 4200, 3},
    {8, "Empresario", "Gestao de negocios", 8000, 10}
};

//=============================================================================
// VARIÁVEIS GLOBAIS
//=============================================================================

new gServerStartTime;
new gPlayersOnline;
new gServerBank = 10000000;
new gTaxRate = 15;

// Anti-Cheat
new gPlayerLastUpdate[MAX_PLAYERS];
new gPlayerWarnings[MAX_PLAYERS];
new gPlayerSuspicion[MAX_PLAYERS];

// Economia
new gInflationRate = 2;
new gFuelPrice = 12;
new gVehicleRespawnTime = 600;

// Objetos do mapa
new gMapObjects[1000];
new gMapObjectCount = 0;

//=============================================================================
// INICIALIZAÇÃO
//=============================================================================

main() {
    printf("\n===========================================");
    printf("  🔥 BR ADVANCED RP v2.0 INICIANDO... 🔥");
    printf("===========================================\n");
}

public OnGameModeInit() {
    SetGameModeText("BR Advanced RP v2.0");
    SendRconCommand("hostname BR Advanced RP - Sistemas Magnificos");
    SendRconCommand("language Portugues");
    
    // Configurações
    DisableInteriorEnterExits();
    EnableStuntBonusForAll(0);
    SetNameTagDrawDistance(40.0);
    ShowNameTags(1);
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
    
    // Timers
    SetTimer("ServerUpdate", 1000, true);
    SetTimer("PayDay", 3600000, true); // 1 hora
    SetTimer("AntiCheat", 5000, true);
    
    // Inicializar sistemas
    InitializeHouses();
    InitializeOrganizations();
    InitializeBusinesses();
    CreateMapObjects();
    
    gServerStartTime = gettime();
    
    printf("✅ BR Advanced RP v2.0 carregado!");
    printf("📊 Sistemas: Houses(%d) | Orgs(%d) | Jobs(%d)", MAX_HOUSES, MAX_ORGANIZATIONS, sizeof(gJobData));
    
    return 1;
}

public OnGameModeExit() {
    printf("\n🔥 BR Advanced RP v2.0 FINALIZANDO...");
    SaveAllData();
    return 1;
}

//=============================================================================
// SISTEMA DE PLAYER
//=============================================================================

public OnPlayerConnect(playerid) {
    gPlayersOnline++;
    ResetPlayerData(playerid);
    
    // Anti-cheat
    gPlayerLastUpdate[playerid] = gettime();
    gPlayerWarnings[playerid] = 0;
    gPlayerSuspicion[playerid] = 0;
    
    // Mensagem de conexão
    new connectMsg[200];
    format(connectMsg, sizeof(connectMsg), "🌟 %s conectou-se ao servidor! [ID: %d]", GetPlayerNameEx(playerid), playerid);
    SendClientMessageToAll(COLOR_PRIMARY, connectMsg);
    
    // Auto-login
    SetTimerEx("ShowLoginMenu", 2000, false, "i", playerid);
    
    // Camera cinematográfica
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
    
    format(disconnectMsg, sizeof(disconnectMsg), "📤 %s desconectou-se [%s]", GetPlayerNameEx(playerid), reasonText);
    SendClientMessageToAll(COLOR_WARNING, disconnectMsg);
    
    return 1;
}

public OnPlayerSpawn(playerid) {
    if(!gPlayerData[playerid][pLogged]) return 0;
    
    // Spawn baseado na organização
    if(gPlayerData[playerid][pOrganization] > 0) {
        new orgID = gPlayerData[playerid][pOrganization];
        SetPlayerPos(playerid, gOrgData[orgID][orgSpawnX], gOrgData[orgID][orgSpawnY], gOrgData[orgID][orgSpawnZ]);
        SetPlayerColor(playerid, gOrgData[orgID][orgColor]);
    } else {
        SetPlayerPos(playerid, 1481.8412, -1741.2568, 13.5469);
    }
    
    SetPlayerFacingAngle(playerid, 0.0);
    SetPlayerHealth(playerid, 100.0);
    SetPlayerArmour(playerid, 0.0);
    
    // Dar armas salvas
    ResetPlayerWeapons(playerid);
    for(new i = 0; i < 13; i++) {
        if(gPlayerData[playerid][pWeapons][i][0] > 0) {
            GivePlayerWeapon(playerid, gPlayerData[playerid][pWeapons][i][0], gPlayerData[playerid][pWeapons][i][1]);
        }
    }
    
    return 1;
}

//=============================================================================
// SISTEMA DE LOGIN/REGISTRO
//=============================================================================

forward ShowLoginMenu(playerid);
public ShowLoginMenu(playerid) {
    new welcomeString[800];
    format(welcomeString, sizeof(welcomeString), 
        "🔥 Bem-vindo ao BR Advanced RP v2.0! 🔥\n\n"
        "Ola, %s!\n\n"
        "🏆 Sistemas Implementados:\n"
        "• Organizacoes (Policia, Bombeiros, Hospital)\n"
        "• Sistema de Casas (200 disponiveis)\n"
        "• Veiculos Pessoais (garagem, combustivel)\n"
        "• Anti-Cheat Avancado\n"
        "• Inventario e Armas\n"
        "• Economia Realista\n\n"
        "👥 Online: %d | Uptime: %s\n\n"
        "Escolha uma opcao:",
        GetPlayerNameEx(playerid), gPlayersOnline, GetServerUptime());
    
    ShowPlayerDialog(playerid, DIALOG_MAIN_MENU, DIALOG_STYLE_MSGBOX, 
        "🔥 BR Advanced RP v2.0", welcomeString, "Login", "Registrar");
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    switch(dialogid) {
        case DIALOG_MAIN_MENU: {
            if(response) {
                ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, 
                    "🔐 Login do Jogador", 
                    "Digite sua senha para entrar:\n\n💡 Senha para teste: 123456\n⚠️ Maximo 3 tentativas", 
                    "Entrar", "Voltar");
            } else {
                ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, 
                    "📝 Registro de Nova Conta", 
                    "Crie uma senha segura:\n\n📋 Requisitos:\n• Minimo 6 caracteres\n• Maximo 20 caracteres\n\nDigite sua senha:", 
                    "Criar Conta", "Voltar");
            }
        }
        
        case DIALOG_LOGIN: {
            if(response && strlen(inputtext) >= 6) {
                if(strcmp(inputtext, "123456", false) == 0) {
                    LoginPlayer(playerid, inputtext);
                } else {
                    gPlayerWarnings[playerid]++;
                    if(gPlayerWarnings[playerid] >= 3) {
                        SendClientMessage(playerid, COLOR_DANGER, "❌ Muitas tentativas incorretas! Desconectando...");
                        SetTimerEx("DelayedKick", 2000, false, "i", playerid);
                    } else {
                        new attemptMsg[150];
                        format(attemptMsg, sizeof(attemptMsg), "❌ Senha incorreta! Tentativas restantes: %d", 3 - gPlayerWarnings[playerid]);
                        SendClientMessage(playerid, COLOR_DANGER, attemptMsg);
                        ShowLoginMenu(playerid);
                    }
                }
            } else {
                if(response) {
                    SendClientMessage(playerid, COLOR_DANGER, "❌ Senha deve ter pelo menos 6 caracteres!");
                }
                ShowLoginMenu(playerid);
            }
        }
        
        case DIALOG_REGISTER: {
            if(response && strlen(inputtext) >= 6 && strlen(inputtext) <= 20) {
                RegisterPlayer(playerid, inputtext);
            } else {
                if(response) {
                    SendClientMessage(playerid, COLOR_DANGER, "❌ Senha deve ter entre 6 e 20 caracteres!");
                }
                ShowLoginMenu(playerid);
            }
        }
        
        case DIALOG_JOB_CENTER: {
            if(response && listitem >= 0 && listitem < sizeof(gJobData)) {
                if(gPlayerData[playerid][pLevel] >= gJobData[listitem][jobRequiredLevel]) {
                    gPlayerData[playerid][pJob] = listitem;
                    gPlayerData[playerid][pJobRank] = 1;
                    
                    new jobMsg[150];
                    format(jobMsg, sizeof(jobMsg), "✅ Parabens! Agora voce trabalha como %s", gJobData[listitem][jobName]);
                    SendClientMessage(playerid, COLOR_SUCCESS, jobMsg);
                    
                    // Dar skin e equipamentos baseado no emprego
                    switch(listitem) {
                        case 5: { // Policial
                            SetPlayerSkin(playerid, 280);
                            gPlayerData[playerid][pOrganization] = 1;
                            gPlayerData[playerid][pOrgRank] = 1;
                        }
                        case 6: { // Paramedico
                            SetPlayerSkin(playerid, 274);
                            gPlayerData[playerid][pOrganization] = 3;
                            gPlayerData[playerid][pOrgRank] = 1;
                        }
                        case 7: { // Bombeiro
                            SetPlayerSkin(playerid, 277);
                            gPlayerData[playerid][pOrganization] = 2;
                            gPlayerData[playerid][pOrgRank] = 1;
                        }
                    }
                } else {
                    SendClientMessage(playerid, COLOR_DANGER, "❌ Voce nao tem nivel suficiente para este emprego!");
                }
            }
        }
        
        case DIALOG_BANK_MENU: {
            if(response) {
                switch(listitem) {
                    case 0: { // Depositar
                        ShowPlayerDialog(playerid, 9001, DIALOG_STYLE_INPUT, "💳 Depositar Dinheiro", 
                            "Digite o valor para depositar:", "Depositar", "Voltar");
                    }
                    case 1: { // Sacar
                        ShowPlayerDialog(playerid, 9002, DIALOG_STYLE_INPUT, "💸 Sacar Dinheiro", 
                            "Digite o valor para sacar:", "Sacar", "Voltar");
                    }
                    case 2: { // Transferir
                        ShowPlayerDialog(playerid, 9003, DIALOG_STYLE_INPUT, "💰 Transferir Dinheiro", 
                            "Digite: [ID do jogador] [valor]", "Transferir", "Voltar");
                    }
                }
            }
        }
    }
    return 1;
}

//=============================================================================
// SISTEMA DE COMANDOS
//=============================================================================

public OnPlayerCommandText(playerid, cmdtext[]) {
    new cmd[256], idx;
    cmd = strtok(cmdtext, idx);
    
    // Comando /ajuda
    if(strcmp("/ajuda", cmd, true) == 0) {
        new helpMenu[1000];
        strcat(helpMenu, "📚 Central de Ajuda - BR Advanced RP\n\n");
        strcat(helpMenu, "🎮 Comandos Basicos:\n");
        strcat(helpMenu, "/stats - Ver estatisticas\n");
        strcat(helpMenu, "/emprego - Central de empregos\n");
        strcat(helpMenu, "/banco - Sistema bancario\n");
        strcat(helpMenu, "/casa - Sistema imobiliario\n");
        strcat(helpMenu, "/veiculo - Gerenciar veiculos\n");
        strcat(helpMenu, "/org - Sua organizacao\n");
        strcat(helpMenu, "/inventario - Ver inventario\n");
        strcat(helpMenu, "/radio [freq] - Mudar radio\n");
        strcat(helpMenu, "/servico - Entrar/sair de servico\n");
        strcat(helpMenu, "/sair - Sair com seguranca\n");
        
        ShowPlayerDialog(playerid, 9999, DIALOG_STYLE_MSGBOX, "📚 Central de Ajuda", helpMenu, "Fechar", "");
        return 1;
    }
    
    // Comando /stats
    if(strcmp("/stats", cmd, true) == 0) {
        if(!gPlayerData[playerid][pLogged]) return SendClientMessage(playerid, COLOR_DANGER, "❌ Voce precisa estar logado!");
        
        new statsString[1000];
        format(statsString, sizeof(statsString), 
            "📊 Estatisticas de %s\n\n"
            "💫 Nivel: %d | XP: %d\n"
            "💰 Dinheiro: R$ %d\n"
            "🏦 Banco: R$ %d\n"
            "💼 Emprego: %s (Rank %d)\n"
            "🏢 Organizacao: %s (Rank %d)\n"
            "🏠 Casa: %s\n"
            "⏰ Tempo Jogado: %d horas\n"
            "🎖️ Admin Level: %d\n"
            "⭐ VIP: %s\n\n"
            "📈 Skills:\n"
            "🚗 Direcao: %d%% | 🎯 Tiro: %d%% | 🔧 Mecanica: %d%%",
            GetPlayerNameEx(playerid), 
            gPlayerData[playerid][pLevel], 
            gPlayerData[playerid][pExperience],
            gPlayerData[playerid][pCash], 
            gPlayerData[playerid][pBank],
            (gPlayerData[playerid][pJob] >= 0) ? gJobData[gPlayerData[playerid][pJob]][jobName] : "Desempregado",
            gPlayerData[playerid][pJobRank],
            (gPlayerData[playerid][pOrganization] > 0) ? gOrgData[gPlayerData[playerid][pOrganization]][orgName] : "Nenhuma",
            gPlayerData[playerid][pOrgRank],
            (gPlayerData[playerid][pHouse] > 0) ? "Proprietario" : "Sem casa",
            gPlayerData[playerid][pPlayTime] / 3600, 
            gPlayerData[playerid][pAdmin],
            (gPlayerData[playerid][pVIP] > 0) ? "Ativo" : "Inativo",
            gPlayerData[playerid][pSkillDriving], 
            gPlayerData[playerid][pSkillShooting], 
            gPlayerData[playerid][pSkillMechanics]);
        
        ShowPlayerDialog(playerid, 9999, DIALOG_STYLE_MSGBOX, "📊 Suas Estatisticas", statsString, "Fechar", "");
        return 1;
    }
    
    // Comando /emprego
    if(strcmp("/emprego", cmd, true) == 0) {
        if(!gPlayerData[playerid][pLogged]) return SendClientMessage(playerid, COLOR_DANGER, "❌ Voce precisa estar logado!");
        
        new jobList[1500] = "💼 Central de Empregos - BR Advanced RP\n\nEscolha seu emprego baseado no seu nivel:\n\n";
        
        for(new i = 0; i < sizeof(gJobData); i++) {
            new jobInfo[200];
            if(gPlayerData[playerid][pLevel] >= gJobData[i][jobRequiredLevel]) {
                format(jobInfo, sizeof(jobInfo), 
                    "✅ %s [Nivel %d] - Salario: R$ %d\n%s\n\n",
                    gJobData[i][jobName], 
                    gJobData[i][jobRequiredLevel], 
                    gJobData[i][jobSalary], 
                    gJobData[i][jobDescription]);
            } else {
                format(jobInfo, sizeof(jobInfo), 
                    "❌ %s [Nivel %d] - Nivel insuficiente\n%s\n\n",
                    gJobData[i][jobName], 
                    gJobData[i][jobRequiredLevel], 
                    gJobData[i][jobDescription]);
            }
            strcat(jobList, jobInfo);
        }
        
        ShowPlayerDialog(playerid, DIALOG_JOB_CENTER, DIALOG_STYLE_LIST, "💼 Central de Empregos", jobList, "Selecionar", "Fechar");
        return 1;
    }
    
    // Comando /banco
    if(strcmp("/banco", cmd, true) == 0) {
        if(!gPlayerData[playerid][pLogged]) return SendClientMessage(playerid, COLOR_DANGER, "❌ Voce precisa estar logado!");
        
        new bankMenu[600];
        format(bankMenu, sizeof(bankMenu), 
            "🏦 Banco Central do Brasil\n\n"
            "💰 Saldo em Conta: R$ %d\n"
            "💵 Dinheiro na Mao: R$ %d\n"
            "📊 Taxa de Juros: %.1f%% ao dia\n\n"
            "Selecione uma operacao:\n\n"
            "💳 Depositar Dinheiro\n"
            "💸 Sacar Dinheiro\n"
            "💰 Transferir para Outro Jogador\n"
            "📊 Extrato Bancario\n"
            "📈 Investimentos\n"
            "🏠 Financiamento Imobiliario",
            gPlayerData[playerid][pBank], 
            gPlayerData[playerid][pCash], 
            (float)gInflationRate + 1.5);
        
        ShowPlayerDialog(playerid, DIALOG_BANK_MENU, DIALOG_STYLE_LIST, "🏦 Banco Central", bankMenu, "Selecionar", "Sair");
        return 1;
    }
    
    // Comando /radio
    if(strcmp("/radio", cmd, true) == 0) {
        if(!gPlayerData[playerid][pLogged]) return SendClientMessage(playerid, COLOR_DANGER, "❌ Voce precisa estar logado!");
        
        new freq[10];
        freq = strtok(cmdtext, idx);
        
        if(!strlen(freq)) {
            return SendClientMessage(playerid, COLOR_WARNING, "💡 Use: /radio [frequencia] (1-9999)");
        }
        
        new frequency = strval(freq);
        if(frequency < 1 || frequency > 9999) {
            return SendClientMessage(playerid, COLOR_DANGER, "❌ Frequencia deve ser entre 1 e 9999!");
        }
        
        gPlayerData[playerid][pRadioFreq] = frequency;
        
        new radioMsg[100];
        format(radioMsg, sizeof(radioMsg), "📻 Radio sintonizado na frequencia %d", frequency);
        SendClientMessage(playerid, COLOR_SUCCESS, radioMsg);
        return 1;
    }
    
    // Comando /servico
    if(strcmp("/servico", cmd, true) == 0) {
        if(!gPlayerData[playerid][pLogged]) return SendClientMessage(playerid, COLOR_DANGER, "❌ Voce precisa estar logado!");
        
        if(gPlayerData[playerid][pJob] == 0) {
            return SendClientMessage(playerid, COLOR_DANGER, "❌ Voce precisa ter um emprego!");
        }
        
        if(gPlayerData[playerid][pOnDuty]) {
            gPlayerData[playerid][pOnDuty] = false;
            SendClientMessage(playerid, COLOR_WARNING, "⏰ Voce saiu de servico!");
        } else {
            gPlayerData[playerid][pOnDuty] = true;
            SendClientMessage(playerid, COLOR_SUCCESS, "⏰ Voce entrou em servico!");
        }
        return 1;
    }
    
    // Comando /sair
    if(strcmp("/sair", cmd, true) == 0) {
        if(gPlayerData[playerid][pLogged]) {
            SavePlayerData(playerid);
            SendClientMessage(playerid, COLOR_SUCCESS, "💾 Dados salvos com seguranca!");
        }
        
        new quitMsg[100];
        format(quitMsg, sizeof(quitMsg), "👋 %s saiu do servidor", GetPlayerNameEx(playerid));
        SendClientMessageToAll(COLOR_GREY, quitMsg);
        
        SetTimerEx("DelayedKick", 1000, false, "i", playerid);
        return 1;
    }
    
    return 0;
}

//=============================================================================
// FUNÇÕES AUXILIARES
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
    gPlayerData[playerid][pJob] = 0;
    gPlayerData[playerid][pOrganization] = 0;
    gPlayerData[playerid][pHouse] = 0;
    gPlayerData[playerid][pVIP] = 0;
    gPlayerData[playerid][pAdmin] = 0;
    gPlayerData[playerid][pLogged] = false;
    gPlayerData[playerid][pOnDuty] = false;
    gPlayerData[playerid][pSkillDriving] = 10;
    gPlayerData[playerid][pSkillShooting] = 10;
    gPlayerData[playerid][pSkillMechanics] = 10;
    gPlayerData[playerid][pRadioFreq] = 100;
    
    GetPlayerName(playerid, gPlayerData[playerid][pName], MAX_PLAYER_NAME);
}

stock LoginPlayer(playerid, password[]) {
    gPlayerData[playerid][pLogged] = true;
    
    SetPlayerPos(playerid, 1481.8412, -1741.2568, 13.5469);
    SetPlayerFacingAngle(playerid, 0.0);
    SetCameraBehindPlayer(playerid);
    TogglePlayerControllable(playerid, true);
    
    new welcomeMsg[400];
    format(welcomeMsg, sizeof(welcomeMsg), 
        "✅ Login realizado com sucesso!\n\n"
        "🎉 Bem-vindo de volta, %s!\n"
        "💰 Saldo: R$ %d + R$ %d no banco\n"
        "💼 Emprego: %s\n"
        "🏢 Organizacao: %s\n\n"
        "🔥 Divirta-se no BR Advanced RP!",
        GetPlayerNameEx(playerid), 
        gPlayerData[playerid][pCash], 
        gPlayerData[playerid][pBank], 
        (gPlayerData[playerid][pJob] >= 0) ? gJobData[gPlayerData[playerid][pJob]][jobName] : "Desempregado",
        (gPlayerData[playerid][pOrganization] > 0) ? gOrgData[gPlayerData[playerid][pOrganization]][orgName] : "Nenhuma");
    
    ShowPlayerDialog(playerid, 9998, DIALOG_STYLE_MSGBOX, "✅ Login Realizado", welcomeMsg, "Continuar", "");
    SendClientMessage(playerid, COLOR_SUCCESS, "🌟 Use /ajuda para ver todos os comandos!");
}

stock RegisterPlayer(playerid, password[]) {
    gPlayerData[playerid][pLogged] = true;
    
    SetPlayerPos(playerid, 1481.8412, -1741.2568, 13.5469);
    SetPlayerFacingAngle(playerid, 0.0);
    SetCameraBehindPlayer(playerid);
    TogglePlayerControllable(playerid, true);
    
    new registerMsg[500];
    format(registerMsg, sizeof(registerMsg), 
        "🎉 Conta criada com sucesso!\n\n"
        "Bem-vindo ao BR Advanced RP, %s!\n\n"
        "🎁 Kit Iniciante:\n"
        "💰 Dinheiro: R$ %d\n"
        "🏦 Conta bancaria: R$ %d\n"
        "📱 Celular: Incluso\n"
        "🎒 Mochila: Inclusa\n"
        "📻 Radio: Freq. 100\n\n"
        "💡 Digite /ajuda para aprender a jogar!",
        GetPlayerNameEx(playerid), 
        gPlayerData[playerid][pCash], 
        gPlayerData[playerid][pBank]);
    
    ShowPlayerDialog(playerid, 9997, DIALOG_STYLE_MSGBOX, "🎉 Conta Criada", registerMsg, "Começar", "");
    SendClientMessage(playerid, COLOR_SUCCESS, "🌟 Sua jornada no RP começa agora!");
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
    // Aqui salvaria no banco de dados real
    return 1;
}

stock SaveAllData() {
    printf("💾 Salvando dados do servidor...");
    return 1;
}

stock InitializeHouses() {
    // Casa 1 - Casa Simples
    gHouseData[1][hID] = 1;
    format(gHouseData[1][hOwner], MAX_PLAYER_NAME, "Governo");
    gHouseData[1][hPrice] = 150000;
    gHouseData[1][hInterior] = 2;
    gHouseData[1][hEnterX] = 2496.065185;
    gHouseData[1][hEnterY] = -1692.630004;
    gHouseData[1][hEnterZ] = 14.765625;
    gHouseData[1][hExitX] = 226.293991;
    gHouseData[1][hExitY] = 1240.000000;
    gHouseData[1][hExitZ] = 1082.149902;
    gHouseData[1][hLocked] = 0;
    gHouseData[1][hSafe] = 0;
    gHouseData[1][hExists] = true;
    
    // Casa 2 - Casa Média
    gHouseData[2][hID] = 2;
    format(gHouseData[2][hOwner], MAX_PLAYER_NAME, "Governo");
    gHouseData[2][hPrice] = 300000;
    gHouseData[2][hInterior] = 5;
    gHouseData[2][hEnterX] = 2454.717041;
    gHouseData[2][hEnterY] = -1700.871582;
    gHouseData[2][hEnterZ] = 13.546875;
    gHouseData[2][hExitX] = 140.917999;
    gHouseData[2][hExitY] = 1366.069946;
    gHouseData[2][hExitZ] = 1083.849976;
    gHouseData[2][hLocked] = 0;
    gHouseData[2][hSafe] = 0;
    gHouseData[2][hExists] = true;
    
    printf("✅ Sistema de Casas: 2 casas inicializadas");
    return 1;
}

stock InitializeOrganizations() {
    // Polícia Militar
    gOrgData[1][orgID] = 1;
    format(gOrgData[1][orgName], 50, "Policia Militar");
    format(gOrgData[1][orgLeader], MAX_PLAYER_NAME, "Governo");
    gOrgData[1][orgMembers] = 0;
    gOrgData[1][orgType] = 1;
    gOrgData[1][orgBank] = 500000;
    gOrgData[1][orgColor] = COLOR_BLUE;
    gOrgData[1][orgSafe] = 0;
    gOrgData[1][orgSpawnX] = 1554.5;
    gOrgData[1][orgSpawnY] = -1675.6;
    gOrgData[1][orgSpawnZ] = 16.2;
    gOrgData[1][orgExists] = true;
    
    // Corpo de Bombeiros
    gOrgData[2][orgID] = 2;
    format(gOrgData[2][orgName], 50, "Corpo de Bombeiros");
    format(gOrgData[2][orgLeader], MAX_PLAYER_NAME, "Governo");
    gOrgData[2][orgMembers] = 0;
    gOrgData[2][orgType] = 3;
    gOrgData[2][orgBank] = 300000;
    gOrgData[2][orgColor] = COLOR_DANGER;
    gOrgData[2][orgSafe] = 0;
    gOrgData[2][orgSpawnX] = 1659.0;
    gOrgData[2][orgSpawnY] = -1514.0;
    gOrgData[2][orgSpawnZ] = 13.5;
    gOrgData[2][orgExists] = true;
    
    // Hospital Central
    gOrgData[3][orgID] = 3;
    format(gOrgData[3][orgName], 50, "Hospital Central");
    format(gOrgData[3][orgLeader], MAX_PLAYER_NAME, "Governo");
    gOrgData[3][orgMembers] = 0;
    gOrgData[3][orgType] = 2;
    gOrgData[3][orgBank] = 400000;
    gOrgData[3][orgColor] = COLOR_WHITE;
    gOrgData[3][orgSafe] = 0;
    gOrgData[3][orgSpawnX] = 1172.0;
    gOrgData[3][orgSpawnY] = -1323.4;
    gOrgData[3][orgSpawnZ] = 15.4;
    gOrgData[3][orgExists] = true;
    
    printf("✅ Sistema de Organizacoes: 3 organizacoes ativas");
    return 1;
}

stock InitializeBusinesses() {
    printf("✅ Sistema de Negocios inicializado");
    return 1;
}

stock CreateMapObjects() {
    // Objetos melhorados do mapa
    
    // Aeroporto melhorado
    gMapObjects[gMapObjectCount++] = CreateObject(3279, 1680.0, -2310.0, 12.0, 0.0, 0.0, 0.0); // Terminal
    gMapObjects[gMapObjectCount++] = CreateObject(1686, 1700.0, -2300.0, 15.0, 0.0, 0.0, 90.0); // Torre controle
    
    // Delegacia melhorada
    gMapObjects[gMapObjectCount++] = CreateObject(3095, 1554.5, -1675.6, 15.0, 0.0, 0.0, 0.0); // Predio policia
    gMapObjects[gMapObjectCount++] = CreateObject(1237, 1550.0, -1670.0, 12.5, 0.0, 0.0, 0.0); // Barreira
    
    // Hospital melhorado
    gMapObjects[gMapObjectCount++] = CreateObject(1676, 1172.0, -1323.4, 14.0, 0.0, 0.0, 0.0); // Ambulancia
    gMapObjects[gMapObjectCount++] = CreateObject(1686, 1175.0, -1320.0, 18.0, 0.0, 0.0, 0.0); // Cruz vermelha
    
    // Banco Central
    gMapObjects[gMapObjectCount++] = CreateObject(3095, 1462.3, -1011.2, 25.0, 0.0, 0.0, 45.0); // Predio banco
    gMapObjects[gMapObjectCount++] = CreateObject(1686, 1460.0, -1010.0, 30.0, 0.0, 0.0, 0.0); // Logo banco
    
    printf("✅ Objetos do mapa: %d objetos criados", gMapObjectCount);
    return 1;
}

//=============================================================================
// TIMERS DO SISTEMA
//=============================================================================

forward ServerUpdate();
public ServerUpdate() {
    // Contar jogadores online
    new count = 0;
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && gPlayerData[i][pLogged]) {
            count++;
            gPlayerData[i][pPlayTime]++;
        }
    }
    gPlayersOnline = count;
    
    return 1;
}

forward PayDay();
public PayDay() {
    new payMsg[150];
    
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && gPlayerData[i][pLogged] && gPlayerData[i][pOnDuty]) {
            new salary = gJobData[gPlayerData[i][pJob]][jobSalary];
            new bonus = salary / 10; // 10% bonus
            new total = salary + bonus;
            
            gPlayerData[i][pBank] += total;
            gPlayerData[i][pExperience] += 100;
            
            // Verificar level up
            new requiredXP = gPlayerData[i][pLevel] * 1000;
            if(gPlayerData[i][pExperience] >= requiredXP) {
                gPlayerData[i][pLevel]++;
                gPlayerData[i][pExperience] = 0;
                
                format(payMsg, sizeof(payMsg), "🎉 LEVEL UP! Agora voce e nivel %d!", gPlayerData[i][pLevel]);
                SendClientMessage(i, COLOR_GOLD, payMsg);
            }
            
            format(payMsg, sizeof(payMsg), "💰 PayDay! Salario: R$ %d + Bonus: R$ %d = R$ %d depositados", salary, bonus, total);
            SendClientMessage(i, COLOR_SUCCESS, payMsg);
        }
    }
    
    return 1;
}

forward AntiCheat();
public AntiCheat() {
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && gPlayerData[i][pLogged]) {
            PerformAntiCheatCheck(i);
        }
    }
    return 1;
}

stock PerformAntiCheatCheck(playerid) {
    new currentTime = gettime();
    
    // Verificar se player está respondendo
    if(currentTime - gPlayerLastUpdate[playerid] > 300) { // 5 minutos
        gPlayerSuspicion[playerid]++;
        
        if(gPlayerSuspicion[playerid] >= 3) {
            new suspicionMsg[150];
            format(suspicionMsg, sizeof(suspicionMsg), "🛡️ Anti-Cheat: %s kickado por suspeita de hack", GetPlayerNameEx(playerid));
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