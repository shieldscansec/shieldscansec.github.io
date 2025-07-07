#include <a_samp>

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

#define DIALOG_LOGIN 1000
#define DIALOG_REGISTER 1001
#define DIALOG_MAIN_MENU 1002
#define DIALOG_JOB_CENTER 1003
#define DIALOG_BANK_MENU 1006

enum pData {
    pName[MAX_PLAYER_NAME],
    pCash,
    pBank,
    pLevel,
    pJob,
    pAdmin,
    bool:pLogged
}
new PlayerInfo[MAX_PLAYERS][pData];

new gPlayersOnline;

main() {
    print("BR Advanced RP v2.0 - Termux Edition");
}

public OnGameModeInit() {
    SetGameModeText("BR Advanced RP v2.0");
    SendRconCommand("hostname BR Advanced RP - Termux Edition");
    print("Gamemode carregado com sucesso!");
    return 1;
}

public OnPlayerConnect(playerid) {
    gPlayersOnline++;
    GetPlayerName(playerid, PlayerInfo[playerid][pName], MAX_PLAYER_NAME);
    PlayerInfo[playerid][pCash] = 5000;
    PlayerInfo[playerid][pBank] = 10000;
    PlayerInfo[playerid][pLevel] = 1;
    PlayerInfo[playerid][pJob] = 0;
    PlayerInfo[playerid][pAdmin] = 0;
    PlayerInfo[playerid][pLogged] = false;
    
    SetTimerEx("ShowWelcome", 2000, false, "i", playerid);
    
    new msg[128];
    format(msg, sizeof(msg), "%s conectou ao servidor!", PlayerInfo[playerid][pName]);
    SendClientMessageToAll(COLOR_GREEN, msg);
    return 1;
}

public OnPlayerDisconnect(playerid, reason) {
    gPlayersOnline--;
    new msg[128];
    format(msg, sizeof(msg), "%s desconectou do servidor", PlayerInfo[playerid][pName]);
    SendClientMessageToAll(COLOR_YELLOW, msg);
    return 1;
}

forward ShowWelcome(playerid);
public ShowWelcome(playerid) {
    new string[500];
    format(string, sizeof(string), "Bem-vindo ao BR Advanced RP v2.0!\n\nOla %s!\n\nServidor de roleplay mais avancado do Brasil!\nSistemas: Economia, Casas, Organizacoes, Anti-Cheat\n\nJogadores online: %d\n\nEscolha uma opcao:", PlayerInfo[playerid][pName], gPlayersOnline);
    ShowPlayerDialog(playerid, DIALOG_MAIN_MENU, DIALOG_STYLE_MSGBOX, "BR Advanced RP v2.0", string, "Login", "Registrar");
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    switch(dialogid) {
        case DIALOG_MAIN_MENU: {
            if(response) {
                ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Digite sua senha:\n\nPara teste use: 123456", "Entrar", "Voltar");
            } else {
                ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Registro", "Crie uma senha (minimo 6 caracteres):", "Criar", "Voltar");
            }
        }
        case DIALOG_LOGIN: {
            if(response) {
                if(strcmp(inputtext, "123456", false) == 0) {
                    PlayerInfo[playerid][pLogged] = true;
                    SpawnPlayer(playerid);
                    SendClientMessage(playerid, COLOR_GREEN, "Login realizado com sucesso!");
                } else {
                    SendClientMessage(playerid, COLOR_RED, "Senha incorreta!");
                    ShowWelcome(playerid);
                }
            } else {
                ShowWelcome(playerid);
            }
        }
        case DIALOG_REGISTER: {
            if(response && strlen(inputtext) >= 6) {
                PlayerInfo[playerid][pLogged] = true;
                SpawnPlayer(playerid);
                SendClientMessage(playerid, COLOR_GREEN, "Conta criada com sucesso!");
            } else {
                if(response) {
                    SendClientMessage(playerid, COLOR_RED, "Senha deve ter pelo menos 6 caracteres!");
                }
                ShowWelcome(playerid);
            }
        }
    }
    return 1;
}

public OnPlayerSpawn(playerid) {
    if(!PlayerInfo[playerid][pLogged]) return 0;
    
    SetPlayerPos(playerid, 1481.0, -1741.0, 13.5);
    SetPlayerFacingAngle(playerid, 0.0);
    SetPlayerHealth(playerid, 100.0);
    GivePlayerMoney(playerid, PlayerInfo[playerid][pCash]);
    
    SendClientMessage(playerid, COLOR_BLUE, "Bem-vindo ao BR Advanced RP!");
    SendClientMessage(playerid, COLOR_WHITE, "Use /ajuda para ver os comandos");
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[]) {
    if(strcmp("/ajuda", cmdtext, true) == 0) {
        SendClientMessage(playerid, COLOR_GREEN, "=== COMANDOS DISPONIVEIS ===");
        SendClientMessage(playerid, COLOR_WHITE, "/stats - Ver estatisticas");
        SendClientMessage(playerid, COLOR_WHITE, "/dinheiro - Ver saldo");
        SendClientMessage(playerid, COLOR_WHITE, "/emprego - Procurar emprego");
        SendClientMessage(playerid, COLOR_WHITE, "/sair - Sair com seguranca");
        return 1;
    }
    
    if(strcmp("/stats", cmdtext, true) == 0) {
        if(!PlayerInfo[playerid][pLogged]) return SendClientMessage(playerid, COLOR_RED, "Voce precisa estar logado!");
        
        new string[300];
        format(string, sizeof(string), "=== ESTATISTICAS ===\n\nNome: %s\nLevel: %d\nDinheiro: $%d\nBanco: $%d\nEmprego: %d\nAdmin: %d", PlayerInfo[playerid][pName], PlayerInfo[playerid][pLevel], PlayerInfo[playerid][pCash], PlayerInfo[playerid][pBank], PlayerInfo[playerid][pJob], PlayerInfo[playerid][pAdmin]);
        ShowPlayerDialog(playerid, 999, DIALOG_STYLE_MSGBOX, "Suas Estatisticas", string, "Fechar", "");
        return 1;
    }
    
    if(strcmp("/dinheiro", cmdtext, true) == 0) {
        if(!PlayerInfo[playerid][pLogged]) return SendClientMessage(playerid, COLOR_RED, "Voce precisa estar logado!");
        
        new string[100];
        format(string, sizeof(string), "Dinheiro na mao: $%d | Banco: $%d", PlayerInfo[playerid][pCash], PlayerInfo[playerid][pBank]);
        SendClientMessage(playerid, COLOR_GREEN, string);
        return 1;
    }
    
    if(strcmp("/emprego", cmdtext, true) == 0) {
        if(!PlayerInfo[playerid][pLogged]) return SendClientMessage(playerid, COLOR_RED, "Voce precisa estar logado!");
        
        ShowPlayerDialog(playerid, 998, DIALOG_STYLE_LIST, "Central de Empregos", "Taxista\nPolicial\nMedico\nMecanico\nEntregador", "Escolher", "Fechar");
        return 1;
    }
    
    if(strcmp("/sair", cmdtext, true) == 0) {
        SendClientMessage(playerid, COLOR_GREEN, "Obrigado por jogar!");
        Kick(playerid);
        return 1;
    }
    
    return 0;
}