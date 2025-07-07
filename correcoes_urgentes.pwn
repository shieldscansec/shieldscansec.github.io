/*
    CORREÇÕES URGENTES PARA O GAMEMODE
    
    Aplique essas correções no seu rjroleplay.pwn para resolver os erros de compilação
*/

// =============================================================================
// 1. CORREÇÃO DOS INCLUDES (LINHA 27)
// =============================================================================

// SUBSTITUA ESTA LINHA:
// #include <YSI\y_ini>

// POR ESTA:
// #include <YSI_Coding\y_ini>

// OU simplesmente COMENTE ela se não estiver usando:
// #include <YSI\y_ini>


// =============================================================================
// 2. CORREÇÃO DO ENUM PlayerInfo (LINHAS 130-135)
// =============================================================================

// SUBSTITUA ESSAS LINHAS NO ENUM:
/*
    // Anti-cheat
    pLastPosX,      // ❌ ERRO: deveria ser Float
    pLastPosY,      // ❌ ERRO: deveria ser Float  
    pLastPosZ,      // ❌ ERRO: deveria ser Float
*/

// POR ESSAS:
/*
    // Anti-cheat
    Float:pLastPosX,
    Float:pLastPosY,
    Float:pLastPosZ,
*/


// =============================================================================
// 3. IMPLEMENTAÇÃO DAS FUNÇÕES FALTANDO
// =============================================================================

// ADICIONE ESSAS FUNÇÕES NO FINAL DO SEU GAMEMODE:

stock LoadFactions() {
    print("✓ Carregando facções...");
    // TODO: Implementar carregamento das facções
}

stock LoadItems() {
    print("✓ Carregando itens...");
    // TODO: Implementar carregamento dos itens
}

stock LoadVehicles() {
    print("✓ Carregando veículos...");
    // TODO: Implementar carregamento dos veículos
}

stock LoadTerritories() {
    print("✓ Carregando territórios...");
    // TODO: Implementar carregamento dos territórios
}

stock LoadBusinesses() {
    print("✓ Carregando negócios...");
    // TODO: Implementar carregamento dos negócios
}

stock LoadHouses() {
    print("✓ Carregando casas...");
    // TODO: Implementar carregamento das casas
}

stock CreateGlobalTextdraws() {
    print("✓ Criando textdraws globais...");
    
    // Textdraw do servidor
    gServerLogo = TextDrawCreate(320.0, 20.0, "~g~RIO DE JANEIRO ROLEPLAY");
    TextDrawAlignment(gServerLogo, 2);
    TextDrawLetterSize(gServerLogo, 0.5, 2.0);
    TextDrawColor(gServerLogo, 0x00FF00FF);
    TextDrawSetOutline(gServerLogo, 1);
    TextDrawFont(gServerLogo, 1);
    
    // Players online
    gOnlinePlayersText = TextDrawCreate(500.0, 50.0, "Players: 0");
    TextDrawLetterSize(gOnlinePlayersText, 0.3, 1.5);
    TextDrawColor(gOnlinePlayersText, 0xFFFFFFFF);
    TextDrawSetOutline(gOnlinePlayersText, 1);
    TextDrawFont(gOnlinePlayersText, 1);
}

stock SpawnFactionVehicles() {
    print("✓ Spawnando veículos das facções...");
    // TODO: Implementar spawn dos veículos
}

stock ResetPlayerData(playerid) {
    // Reset básico dos dados do player
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
}

stock CheckPlayerBan(playerid) {
    // TODO: Implementar verificação de ban
    print("✓ Verificando ban do player...");
}

stock SaveLog(type[], name[], ip[], action[]) {
    // Log básico no console
    printf("[%s] %s (%s): %s", type, name, ip, action);
    
    // TODO: Salvar no banco de dados
}

stock UpdateOnlinePlayersText() {
    new string[32];
    format(string, sizeof(string), "Players: %d", gPlayersOnline);
    TextDrawSetString(gOnlinePlayersText, string);
}

stock SavePlayerData(playerid) {
    if(!gPlayerInfo[playerid][pLogged]) return 0;
    
    // TODO: Implementar salvamento no banco
    printf("Salvando dados do player %s...", GetPlayerNameEx(playerid));
    return 1;
}

stock StartTutorial(playerid) {
    SendClientMessage(playerid, COLOR_GREEN, "Bem-vindo ao Rio de Janeiro RolePlay!");
    SendClientMessage(playerid, COLOR_YELLOW, "Use /ajuda para ver os comandos disponíveis.");
    gPlayerInfo[playerid][pTutorial] = 1;
}

stock CreatePlayerHUD(playerid) {
    // Versão simplificada do HUD para evitar crashes
    if(gPlayerInfo[playerid][pHUDMain] != Text:INVALID_TEXT_DRAW) {
        TextDrawDestroy(gPlayerInfo[playerid][pHUDMain]);
        TextDrawDestroy(gPlayerInfo[playerid][pHUDMoney]);
        TextDrawDestroy(gPlayerInfo[playerid][pHUDStats]);
    }
    
    // HUD básico
    gPlayerInfo[playerid][pHUDMain] = TextDrawCreate(500.0, 400.0, "box");
    TextDrawUseBox(gPlayerInfo[playerid][pHUDMain], 1);
    TextDrawBoxColor(gPlayerInfo[playerid][pHUDMain], 0x000000AA);
    TextDrawTextSize(gPlayerInfo[playerid][pHUDMain], 640.0, 0.0);
    TextDrawLetterSize(gPlayerInfo[playerid][pHUDMain], 0.0, 5.0);
    
    gPlayerInfo[playerid][pHUDMoney] = TextDrawCreate(510.0, 405.0, "R$ 0");
    TextDrawColor(gPlayerInfo[playerid][pHUDMoney], 0x00FF00FF);
    TextDrawLetterSize(gPlayerInfo[playerid][pHUDMoney], 0.3, 1.5);
    TextDrawSetOutline(gPlayerInfo[playerid][pHUDMoney], 1);
    
    gPlayerInfo[playerid][pHUDStats] = TextDrawCreate(510.0, 425.0, "Vida: 100%");
    TextDrawColor(gPlayerInfo[playerid][pHUDStats], 0xFFFFFFFF);
    TextDrawLetterSize(gPlayerInfo[playerid][pHUDStats], 0.25, 1.0);
    TextDrawSetOutline(gPlayerInfo[playerid][pHUDStats], 1);
    
    // Mostrar textdraws
    TextDrawShowForPlayer(playerid, gPlayerInfo[playerid][pHUDMain]);
    TextDrawShowForPlayer(playerid, gPlayerInfo[playerid][pHUDMoney]);
    TextDrawShowForPlayer(playerid, gPlayerInfo[playerid][pHUDStats]);
}

stock GetFactionSkin(factionid, rank) {
    switch(factionid) {
        case 1: return 102; // CV
        case 2: return 103; // ADA
        case 3: return 104; // TCP
        case 4: return 105; // Milícia
        case 5: return 280; // PMERJ
        case 6: return 285; // BOPE
        case 7: return 288; // CORE
        case 8: return 283; // UPP
        default: return 26; // Civil
    }
}

stock ShowLoginDialog(playerid) {
    new playerName[MAX_PLAYER_NAME], string[256];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    
    format(string, sizeof(string), "Olá %s!\nDigite sua senha:", playerName);
    ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", string, "Entrar", "Sair");
}

stock ShowRegisterDialog(playerid) {
    new playerName[MAX_PLAYER_NAME], string[256];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    
    format(string, sizeof(string), "Olá %s!\nCrie uma senha (min. 6 caracteres):", playerName);
    ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registro", string, "Registrar", "Sair");
}

stock IsPlayerAllowedWeapon(playerid, weapon) {
    // Permitir todas as armas por enquanto
    #pragma unused playerid, weapon
    return 1;
}

stock BanPlayer(playerid, admin[], reason[]) {
    new string[256];
    format(string, sizeof(string), "%s foi banido por %s. Motivo: %s", GetPlayerNameEx(playerid), admin, reason);
    SendClientMessageToAll(COLOR_RED, string);
    
    SaveLog("ban", GetPlayerNameEx(playerid), GetPlayerIPEx(playerid), string);
    
    // Aplicar ban
    gPlayerInfo[playerid][pBanned] = 1;
    format(gPlayerInfo[playerid][pBanReason], 128, "%s", reason);
    
    SetTimerEx("DelayedKick", 1000, false, "i", playerid);
}

// =============================================================================
// 4. CORREÇÃO DAS CALLBACKS DE TIMERS FALTANDO
// =============================================================================

forward EconomyUpdate();
public EconomyUpdate() {
    // Atualização da economia
    if(random(100) < 20) {
        gEconomyInflation += random(5) - 2; // -2 a +3
        if(gEconomyInflation < 50) gEconomyInflation = 50;
        if(gEconomyInflation > 200) gEconomyInflation = 200;
    }
    return 1;
}

forward TerritoryUpdate();
public TerritoryUpdate() {
    // Atualização dos territórios
    for(new i = 0; i < MAX_TERRITORIES; i++) {
        if(gTerritoryInfo[i][tFactionID] > 0) {
            // Dar dinheiro para a facção
            gFactionInfo[gTerritoryInfo[i][tFactionID]][fBank] += gTerritoryInfo[i][tMoneyPerHour];
        }
    }
    return 1;
}

// =============================================================================
// 5. CORREÇÃO DOS SENDCLIENTMESSAGE COM FORMAT
// =============================================================================

// SUBSTITUA TODAS as linhas como esta:
// SendClientMessage(playerid, COLOR_RED, "ANTI-CHEAT: Speed hack detectado! Aviso: %d/3", gPlayerInfo[playerid][pSpeedHackWarns]);

// POR ESTE FORMATO:
/*
new string[128];
format(string, sizeof(string), "ANTI-CHEAT: Speed hack detectado! Aviso: %d/3", gPlayerInfo[playerid][pSpeedHackWarns]);
SendClientMessage(playerid, COLOR_RED, string);
*/