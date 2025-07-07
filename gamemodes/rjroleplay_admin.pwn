// =============================================================================
// COMANDOS ADMINISTRATIVOS
// =============================================================================

CMD:ban(playerid, params[]) {
    if(gPlayerInfo[playerid][pAdminLevel] < 2) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não tem permissão!");
    
    new targetid, motivo[128];
    if(sscanf(params, "us[128]", targetid, motivo)) return SendClientMessage(playerid, COLOR_YELLOW, "USO: /ban [id] [motivo]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Jogador não encontrado!");
    
    BanPlayer(targetid, GetPlayerNameEx(playerid), motivo);
    
    new string[256];
    format(string, sizeof(string), "ADMIN: %s baniu %s. Motivo: %s", 
        GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), motivo);
    SendClientMessageToAll(COLOR_RED, string);
    
    format(string, sizeof(string), "%s baniu %s. Motivo: %s", 
        GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), motivo);
    SaveLog("ban", GetPlayerNameEx(playerid), GetPlayerIPEx(playerid), string);
    
    return 1;
}

CMD:kick(playerid, params[]) {
    if(gPlayerInfo[playerid][pAdminLevel] < 1) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não tem permissão!");
    
    new targetid, motivo[128];
    if(sscanf(params, "us[128]", targetid, motivo)) return SendClientMessage(playerid, COLOR_YELLOW, "USO: /kick [id] [motivo]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Jogador não encontrado!");
    
    new string[256];
    format(string, sizeof(string), "ADMIN: %s kickou %s. Motivo: %s", 
        GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), motivo);
    SendClientMessageToAll(COLOR_RED, string);
    
    format(string, sizeof(string), "%s kickou %s. Motivo: %s", 
        GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), motivo);
    SaveLog("kick", GetPlayerNameEx(playerid), GetPlayerIPEx(playerid), string);
    
    SendClientMessage(targetid, COLOR_RED, "Você foi kickado do servidor!");
    SetTimerEx("DelayedKick", 1000, false, "i", targetid);
    
    return 1;
}

CMD:goto(playerid, params[]) {
    if(gPlayerInfo[playerid][pAdminLevel] < 1) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não tem permissão!");
    
    new targetid;
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_YELLOW, "USO: /goto [id]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Jogador não encontrado!");
    
    new Float:x, Float:y, Float:z;
    GetPlayerPos(targetid, x, y, z);
    SetPlayerPos(playerid, x + 1.0, y + 1.0, z);
    SetPlayerInterior(playerid, GetPlayerInterior(targetid));
    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));
    
    new string[128];
    format(string, sizeof(string), "Você foi até %s", GetPlayerNameEx(targetid));
    SendClientMessage(playerid, COLOR_GREEN, string);
    
    format(string, sizeof(string), "%s foi até %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid));
    SaveLog("goto", GetPlayerNameEx(playerid), GetPlayerIPEx(playerid), string);
    
    return 1;
}

CMD:get(playerid, params[]) {
    if(gPlayerInfo[playerid][pAdminLevel] < 1) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não tem permissão!");
    
    new targetid;
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_YELLOW, "USO: /get [id]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Jogador não encontrado!");
    
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    SetPlayerPos(targetid, x + 1.0, y + 1.0, z);
    SetPlayerInterior(targetid, GetPlayerInterior(playerid));
    SetPlayerVirtualWorld(targetid, GetPlayerVirtualWorld(playerid));
    
    new string[128];
    format(string, sizeof(string), "Você trouxe %s até você", GetPlayerNameEx(targetid));
    SendClientMessage(playerid, COLOR_GREEN, string);
    
    format(string, sizeof(string), "Admin %s te trouxe até ele", GetPlayerNameEx(playerid));
    SendClientMessage(targetid, COLOR_YELLOW, string);
    
    return 1;
}

CMD:setlevel(playerid, params[]) {
    if(gPlayerInfo[playerid][pAdminLevel] < 5) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não tem permissão!");
    
    new targetid, level;
    if(sscanf(params, "ui", targetid, level)) return SendClientMessage(playerid, COLOR_YELLOW, "USO: /setlevel [id] [level]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Jogador não encontrado!");
    if(level < 0 || level > 5) return SendClientMessage(playerid, COLOR_RED, "ERRO: Level deve ser entre 0 e 5!");
    
    gPlayerInfo[targetid][pAdminLevel] = level;
    
    new string[128];
    format(string, sizeof(string), "ADMIN: %s alterou o nível admin de %s para %d", 
        GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), level);
    SendClientMessageToAll(COLOR_ORANGE, string);
    
    format(string, sizeof(string), "Seu nível administrativo foi alterado para %d", level);
    SendClientMessage(targetid, COLOR_GREEN, string);
    
    SavePlayerData(targetid);
    return 1;
}

CMD:setvip(playerid, params[]) {
    if(gPlayerInfo[playerid][pAdminLevel] < 3) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não tem permissão!");
    
    new targetid, level, dias;
    if(sscanf(params, "uii", targetid, level, dias)) return SendClientMessage(playerid, COLOR_YELLOW, "USO: /setvip [id] [level] [dias]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Jogador não encontrado!");
    if(level < 0 || level > 3) return SendClientMessage(playerid, COLOR_RED, "ERRO: Level VIP deve ser entre 0 e 3!");
    
    gPlayerInfo[targetid][pVIPLevel] = level;
    if(level > 0) {
        gPlayerInfo[targetid][pVIPExpire] = gettime() + (dias * 86400); // dias em segundos
    } else {
        gPlayerInfo[targetid][pVIPExpire] = 0;
    }
    
    new string[128];
    format(string, sizeof(string), "ADMIN: %s alterou o VIP de %s para nível %d (%d dias)", 
        GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), level, dias);
    SendClientMessageToAll(COLOR_ORANGE, string);
    
    format(string, sizeof(string), "Seu VIP foi alterado para nível %d por %d dias", level, dias);
    SendClientMessage(targetid, COLOR_GREEN, string);
    
    SavePlayerData(targetid);
    return 1;
}

CMD:setmoney(playerid, params[]) {
    if(gPlayerInfo[playerid][pAdminLevel] < 2) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não tem permissão!");
    
    new targetid, amount;
    if(sscanf(params, "ui", targetid, amount)) return SendClientMessage(playerid, COLOR_YELLOW, "USO: /setmoney [id] [quantia]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Jogador não encontrado!");
    
    gPlayerInfo[targetid][pMoney] = amount;
    ResetPlayerMoney(targetid);
    GivePlayerMoney(targetid, amount);
    
    new string[128];
    format(string, sizeof(string), "ADMIN: %s alterou o dinheiro de %s para R$ %s", 
        GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), FormatNumber(amount));
    SendClientMessageToAll(COLOR_ORANGE, string);
    
    format(string, sizeof(string), "Seu dinheiro foi alterado para R$ %s", FormatNumber(amount));
    SendClientMessage(targetid, COLOR_GREEN, string);
    
    return 1;
}

CMD:setfaction(playerid, params[]) {
    if(gPlayerInfo[playerid][pAdminLevel] < 3) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não tem permissão!");
    
    new targetid, factionid, rank;
    if(sscanf(params, "uii", targetid, factionid, rank)) return SendClientMessage(playerid, COLOR_YELLOW, "USO: /setfaction [id] [facção] [cargo]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Jogador não encontrado!");
    if(factionid < 0 || factionid > 11) return SendClientMessage(playerid, COLOR_RED, "ERRO: ID da facção inválido (0-11)!");
    if(rank < 0 || rank > 10) return SendClientMessage(playerid, COLOR_RED, "ERRO: Cargo deve ser entre 0 e 10!");
    
    gPlayerInfo[targetid][pFactionID] = factionid;
    gPlayerInfo[targetid][pFactionRank] = rank;
    
    new string[256];
    if(factionid == 0) {
        format(string, sizeof(string), "ADMIN: %s removeu %s de sua facção", 
            GetPlayerNameEx(playerid), GetPlayerNameEx(targetid));
        SendClientMessage(targetid, COLOR_YELLOW, "Você foi removido de sua facção!");
    } else {
        format(string, sizeof(string), "ADMIN: %s colocou %s na facção %s (Cargo: %d)", 
            GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), GetFactionName(factionid), rank);
        format(string, sizeof(string), "Você foi adicionado à facção %s (Cargo: %d)", 
            GetFactionName(factionid), rank);
        SendClientMessage(targetid, COLOR_GREEN, string);
    }
    
    SendClientMessageToAll(COLOR_ORANGE, string);
    SavePlayerData(targetid);
    
    return 1;
}

CMD:verip(playerid, params[]) {
    if(gPlayerInfo[playerid][pAdminLevel] < 1) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não tem permissão!");
    
    new targetid;
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_YELLOW, "USO: /verip [id]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Jogador não encontrado!");
    
    new string[128];
    format(string, sizeof(string), "IP de %s: %s", GetPlayerNameEx(targetid), GetPlayerIPEx(targetid));
    SendClientMessage(playerid, COLOR_YELLOW, string);
    
    return 1;
}

CMD:logs(playerid, params[]) {
    if(gPlayerInfo[playerid][pAdminLevel] < 2) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não tem permissão!");
    
    new type[32], target[24];
    if(sscanf(params, "s[32]s[24]", type, target)) {
        SendClientMessage(playerid, COLOR_YELLOW, "USO: /logs [tipo] [nome]");
        SendClientMessage(playerid, COLOR_WHITE, "Tipos: connect, disconnect, command, ban, kick, money, weapon");
        return 1;
    }
    
    new query[256];
    format(query, sizeof(query), 
        "SELECT * FROM logs WHERE type = '%s' AND player_name = '%s' ORDER BY timestamp DESC LIMIT 10",
        type, target);
    mysql_tquery(gMySQL, query, "OnAdminViewLogs", "is", playerid, target);
    
    return 1;
}

forward OnAdminViewLogs(playerid, target[]);
public OnAdminViewLogs(playerid, target[]) {
    if(cache_num_rows() == 0) {
        SendClientMessage(playerid, COLOR_RED, "Nenhum log encontrado!");
        return 1;
    }
    
    new string[512];
    format(string, sizeof(string), "Logs de %s:", target);
    SendClientMessage(playerid, COLOR_YELLOW, string);
    
    for(new i = 0; i < cache_num_rows(); i++) {
        new action[128], timestamp[32];
        cache_get_value_name(i, "action", action);
        cache_get_value_name(i, "timestamp", timestamp);
        
        format(string, sizeof(string), "%s - %s", timestamp, action);
        SendClientMessage(playerid, COLOR_WHITE, string);
    }
    
    return 1;
}

// =============================================================================
// COMANDOS VIP
// =============================================================================

CMD:vcar(playerid, params[]) {
    if(gPlayerInfo[playerid][pVIPLevel] < 1) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você precisa ser VIP!");
    
    new modelid;
    if(sscanf(params, "i", modelid)) return SendClientMessage(playerid, COLOR_YELLOW, "USO: /vcar [model id]");
    if(modelid < 400 || modelid > 611) return SendClientMessage(playerid, COLOR_RED, "ERRO: Model ID inválido!");
    
    // Verificar se já tem carro VIP spawned
    if(GetPVarInt(playerid, "VIPCar") != 0) {
        DestroyVehicle(GetPVarInt(playerid, "VIPCar"));
        DeletePVar(playerid, "VIPCar");
    }
    
    new Float:x, Float:y, Float:z, Float:angle;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, angle);
    
    new vehicleid = CreateVehicle(modelid, x + 3.0, y, z + 1.0, angle, -1, -1, -1);
    SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
    LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
    
    SetPVarInt(playerid, "VIPCar", vehicleid);
    
    new string[128];
    format(string, sizeof(string), "Veículo VIP spawned! Model: %d", modelid);
    SendClientMessage(playerid, COLOR_GREEN, string);
    
    return 1;
}

CMD:vheal(playerid, params[]) {
    if(gPlayerInfo[playerid][pVIPLevel] < 1) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você precisa ser VIP!");
    
    SetPlayerHealth(playerid, 100.0);
    SetPlayerArmour(playerid, 100.0);
    SendClientMessage(playerid, COLOR_GREEN, "VIP: Vida e colete restaurados!");
    
    return 1;
}

CMD:vtp(playerid, params[]) {
    if(gPlayerInfo[playerid][pVIPLevel] < 2) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você precisa ser VIP Gold!");
    
    new location[32];
    if(sscanf(params, "s[32]", location)) {
        SendClientMessage(playerid, COLOR_YELLOW, "USO: /vtp [local]");
        SendClientMessage(playerid, COLOR_WHITE, "Locais: aeroporto, hospital, prefeitura, banco, praia, shopping");
        return 1;
    }
    
    if(!strcmp(location, "aeroporto", true)) {
        SetPlayerPos(playerid, 1680.3, -2324.8, 13.5);
        SendClientMessage(playerid, COLOR_GREEN, "VIP: Teleportado para o Aeroporto!");
    } else if(!strcmp(location, "hospital", true)) {
        SetPlayerPos(playerid, 1172.0, -1323.0, 15.4);
        SendClientMessage(playerid, COLOR_GREEN, "VIP: Teleportado para o Hospital!");
    } else if(!strcmp(location, "prefeitura", true)) {
        SetPlayerPos(playerid, 1481.0, -1772.4, 18.8);
        SendClientMessage(playerid, COLOR_GREEN, "VIP: Teleportado para a Prefeitura!");
    } else if(!strcmp(location, "banco", true)) {
        SetPlayerPos(playerid, 1462.0, -1012.0, 26.8);
        SendClientMessage(playerid, COLOR_GREEN, "VIP: Teleportado para o Banco!");
    } else if(!strcmp(location, "praia", true)) {
        SetPlayerPos(playerid, 1093.0, -1277.0, 15.8);
        SendClientMessage(playerid, COLOR_GREEN, "VIP: Teleportado para a Praia de Copacabana!");
    } else if(!strcmp(location, "shopping", true)) {
        SetPlayerPos(playerid, 1038.0, -1340.0, 13.7);
        SendClientMessage(playerid, COLOR_GREEN, "VIP: Teleportado para o Shopping!");
    } else {
        SendClientMessage(playerid, COLOR_RED, "Local não encontrado!");
    }
    
    return 1;
}

CMD:vcoins(playerid, params[]) {
    if(!gPlayerInfo[playerid][pLogged]) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você precisa estar logado!");
    
    new string[256];
    format(string, sizeof(string), 
        "{FFFFFF}═══════ {FFD700}LOJA VIP - COINS{FFFFFF} ═══════\n\n"
        "{FFFFFF}Seus Coins: {FFD700}%d\n\n"
        "{FFFFFF}Itens disponíveis:\n"
        "{FFD700}• {FFFFFF}Dinheiro (R$ 100.000) - {FFD700}50 Coins\n"
        "{FFD700}• {FFFFFF}Arma Desert Eagle - {FFD700}30 Coins\n"
        "{FFD700}• {FFFFFF}Colete à prova de balas - {FFD700}20 Coins\n"
        "{FFD700}• {FFFFFF}Kit médico - {FFD700}15 Coins\n"
        "{FFD700}• {FFFFFF}Celular premium - {FFD700}25 Coins",
        gPlayerInfo[playerid][pCoins]
    );
    
    ShowPlayerDialog(playerid, DIALOG_COIN_SHOP, DIALOG_STYLE_LIST, 
        "{FFD700}Loja de Coins", 
        "R$ 100.000 - 50 Coins\nDesert Eagle - 30 Coins\nColete - 20 Coins\nKit Médico - 15 Coins\nCelular Premium - 25 Coins", 
        "Comprar", "Fechar");
    
    return 1;
}

// =============================================================================
// SISTEMA DE CRAFTING
// =============================================================================

CMD:craft(playerid, params[]) {
    if(!gPlayerInfo[playerid][pLogged]) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você precisa estar logado!");
    
    ShowCraftingMenu(playerid);
    return 1;
}

stock ShowCraftingMenu(playerid) {
    new string[1024];
    string = "{FFFFFF}═══════ {00FF00}SISTEMA DE CRAFTING{FFFFFF} ═══════\n\n";
    strcat(string, "{FFFFFF}Receitas disponíveis:\n\n");
    strcat(string, "{FFFF00}ARMAS:\n");
    strcat(string, "{FFFFFF}• Pistola 9mm - 5 Ferro + 3 Pólvora\n");
    strcat(string, "{FFFFFF}• Taco de Baseball - 3 Madeira\n");
    strcat(string, "{FFFFFF}• Faca - 2 Ferro + 1 Madeira\n\n");
    strcat(string, "{FFFF00}DROGAS:\n");
    strcat(string, "{FFFFFF}• Maconha - 2 Semente + 1 Adubo\n");
    strcat(string, "{FFFFFF}• Cocaína - 3 Pasta Base + 2 Químico\n\n");
    strcat(string, "{FFFF00}ITENS:\n");
    strcat(string, "{FFFFFF}• Kit Médico - 2 Bandagem + 1 Remédio\n");
    strcat(string, "{FFFFFF}• Colete - 4 Kevlar + 2 Tecido\n");
    
    ShowPlayerDialog(playerid, DIALOG_CRAFT, DIALOG_STYLE_LIST, 
        "{00FF00}Sistema de Crafting",
        "Pistola 9mm\nTaco de Baseball\nFaca\nMaconha\nCocaína\nKit Médico\nColete",
        "Craftar", "Fechar");
}

// =============================================================================
// SISTEMA DE TERRITÓRIOS
// =============================================================================

forward TerritoryUpdate();
public TerritoryUpdate() {
    for(new i = 0; i < MAX_TERRITORIES; i++) {
        if(gTerritoryInfo[i][tFactionID] > 0) {
            // Gerar dinheiro para a facção
            gFactionInfo[gTerritoryInfo[i][tFactionID]][fBank] += gTerritoryInfo[i][tMoneyPerHour];
            
            // Produzir drogas automaticamente
            new query[256];
            format(query, sizeof(query), 
                "UPDATE territories SET last_collect = NOW() WHERE id = %d",
                gTerritoryInfo[i][tID]);
            mysql_tquery(gMySQL, query);
        }
    }
    
    // Atualizar players nos territórios
    for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) {
        if(IsPlayerConnected(playerid) && gPlayerInfo[playerid][pLogged]) {
            new territoryID = GetPlayerTerritory(playerid);
            if(territoryID != -1) {
                // Verificar se está dominando território
                if(GetPVarInt(playerid, "DominandoTerritorio") == territoryID) {
                    new tempo = GetPVarInt(playerid, "TempoDominacao");
                    tempo--;
                    
                    if(tempo <= 0) {
                        // Território dominado!
                        gTerritoryInfo[territoryID][tFactionID] = gPlayerInfo[playerid][pFactionID];
                        GangZoneShowForAll(gTerritoryInfo[territoryID][tGangZone], 
                            GetFactionColor(gPlayerInfo[playerid][pFactionID]));
                        
                        new string[128];
                        format(string, sizeof(string), "TERRITÓRIO: %s dominou o território %s!", 
                            GetFactionName(gPlayerInfo[playerid][pFactionID]),
                            gTerritoryInfo[territoryID][tName]);
                        SendClientMessageToAll(COLOR_ORANGE, string);
                        
                        DeletePVar(playerid, "DominandoTerritorio");
                        DeletePVar(playerid, "TempoDominacao");
                    } else {
                        SetPVarInt(playerid, "TempoDominacao", tempo);
                        new string[64];
                        format(string, sizeof(string), "~r~DOMINANDO TERRITORIO~n~~w~%d segundos", tempo);
                        GameTextForPlayer(playerid, string, 2000, 3);
                    }
                }
            }
        }
    }
    
    return 1;
}

// =============================================================================
// SISTEMA DE ECONOMIA
// =============================================================================

forward EconomyUpdate();
public EconomyUpdate() {
    // Atualizar inflação baseada na economia do servidor
    new totalMoney = 0;
    new playersWithMoney = 0;
    
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && gPlayerInfo[i][pLogged]) {
            totalMoney += gPlayerInfo[i][pMoney] + gPlayerInfo[i][pBankMoney];
            playersWithMoney++;
        }
    }
    
    if(playersWithMoney > 0) {
        new averageMoney = totalMoney / playersWithMoney;
        
        // Ajustar inflação baseada na riqueza média
        if(averageMoney > 1000000) { // Mais de 1M em média
            gEconomyInflation += 2; // Aumentar inflação
        } else if(averageMoney < 100000) { // Menos de 100K em média
            gEconomyInflation -= 1; // Diminuir inflação
            if(gEconomyInflation < 50) gEconomyInflation = 50; // Mínimo 50%
        }
        
        if(gEconomyInflation > 200) gEconomyInflation = 200; // Máximo 200%
    }
    
    // Atualizar preços dos negócios
    for(new i = 0; i < MAX_BUSINESSES; i++) {
        if(gBusinessInfo[i][bOwnerID] > 0) {
            // Gerar produtos automaticamente
            if(gBusinessInfo[i][bProducts] < gBusinessInfo[i][bMaxProducts]) {
                gBusinessInfo[i][bProducts] += 5;
                if(gBusinessInfo[i][bProducts] > gBusinessInfo[i][bMaxProducts]) {
                    gBusinessInfo[i][bProducts] = gBusinessInfo[i][bMaxProducts];
                }
            }
        }
    }
    
    return 1;
}

// =============================================================================
// SISTEMA DE EVENTOS AUTOMÁTICOS
// =============================================================================

stock StartRandomEvent() {
    new eventType = random(5);
    
    switch(eventType) {
        case 0: StartBankRobbery();
        case 1: StartDrugBust();
        case 2: StartCarChase();
        case 3: StartHostageSituation();
        case 4: StartStreetRace();
    }
}

stock StartBankRobbery() {
    SendClientMessageToAll(COLOR_RED, "EVENTO: Assalto ao banco em andamento! Polícia e criminosos podem participar!");
    
    // Criar checkpoint no banco
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i)) {
            SetPlayerCheckpoint(i, 1462.0, -1012.0, 26.8, 5.0);
        }
    }
    
    SetTimer("EndBankRobbery", 300000, false); // 5 minutos
}

stock StartDrugBust() {
    SendClientMessageToAll(COLOR_BLUE, "EVENTO: Operação policial anti-drogas iniciada! Reward em dinheiro!");
    
    // Spawnar NPCs com drogas
    new Float:positions[][3] = {
        {2495.0, -1688.0, 13.3},
        {2787.0, -1926.0, 13.5},
        {2522.0, -2020.0, 13.5}
    };
    
    for(new i = 0; i < sizeof(positions); i++) {
        CreateDynamicPickup(1279, 1, positions[i][0], positions[i][1], positions[i][2]);
    }
}

stock StartCarChase() {
    new suspectID = GetRandomCriminal();
    if(suspectID == INVALID_PLAYER_ID) return;
    
    gPlayerInfo[suspectID][pWantedLevel] += 3;
    
    new string[128];
    format(string, sizeof(string), "EVENTO: %s está fugindo da polícia! Wanted Level: %d estrelas!", 
        GetPlayerNameEx(suspectID), gPlayerInfo[suspectID][pWantedLevel]);
    SendClientMessageToAll(COLOR_RED, string);
    
    // Reward para quem prender
    SetPVarInt(suspectID, "ChaseReward", 50000);
}

stock StartHostageSituation() {
    SendClientMessageToAll(COLOR_ORANGE, "EVENTO: Situação de refém no hospital! SWAT/BOPE necessário!");
    
    // Criar área de evento
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && IsPlayerPolice(i)) {
            SetPlayerCheckpoint(i, 1172.0, -1323.0, 15.4, 10.0);
        }
    }
}

stock StartStreetRace() {
    SendClientMessageToAll(COLOR_YELLOW, "EVENTO: Racha na Marginal! Prêmio: R$ 100.000!");
    
    // Criar checkpoints da corrida
    new Float:checkpoints[][3] = {
        {1385.0, -2498.0, 9.7},   // Início
        {1385.0, -2030.0, 9.7},   // Checkpoint 1
        {1385.0, -1580.0, 9.7},   // Checkpoint 2
        {1385.0, -1350.0, 9.7}    // Fim
    };
    
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && IsPlayerInAnyVehicle(i)) {
            SetPlayerRaceCheckpoint(i, 0, checkpoints[0][0], checkpoints[0][1], checkpoints[0][2],
                checkpoints[1][0], checkpoints[1][1], checkpoints[1][2], 5.0);
            SetPVarInt(i, "RaceCP", 0);
        }
    }
}

// =============================================================================
// FUNÇÕES AUXILIARES
// =============================================================================

stock GetRandomCriminal() {
    new criminals[MAX_PLAYERS], count = 0;
    
    for(new i = 0; i < MAX_PLAYERS; i++) {
        if(IsPlayerConnected(i) && IsPlayerCriminal(i)) {
            criminals[count] = i;
            count++;
        }
    }
    
    if(count == 0) return INVALID_PLAYER_ID;
    return criminals[random(count)];
}

stock IsPlayerCriminal(playerid) {
    new factionID = gPlayerInfo[playerid][pFactionID];
    return (factionID >= 1 && factionID <= 4); // CV, ADA, TCP, Milícia
}

stock IsPlayerPolice(playerid) {
    new factionID = gPlayerInfo[playerid][pFactionID];
    return (factionID >= 5 && factionID <= 11); // PMERJ, BOPE, CORE, UPP, etc
}

stock GetPlayerTerritory(playerid) {
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    
    for(new i = 0; i < MAX_TERRITORIES; i++) {
        if(x >= gTerritoryInfo[i][tMinX] && x <= gTerritoryInfo[i][tMaxX] &&
           y >= gTerritoryInfo[i][tMinY] && y <= gTerritoryInfo[i][tMaxY]) {
            return i;
        }
    }
    return -1;
}

stock GetFactionColor(factionid) {
    switch(factionid) {
        case 1: return COLOR_CV;
        case 2: return COLOR_ADA;
        case 3: return COLOR_TCP;
        case 4: return COLOR_MILICIA;
        case 5: return COLOR_PMERJ;
        case 6: return COLOR_BOPE;
        case 7: return COLOR_CORE;
        case 8: return COLOR_UPP;
        case 9: return COLOR_EXERCITO;
        case 10: return COLOR_PCERJ;
        case 11: return COLOR_PRF;
    }
    return COLOR_WHITE;
}

stock GetFactionName(factionid) {
    new factionName[50];
    switch(factionid) {
        case 0: factionName = "Civil";
        case 1: factionName = "Comando Vermelho";
        case 2: factionName = "Amigos dos Amigos";
        case 3: factionName = "Terceiro Comando Puro";
        case 4: factionName = "Milícia";
        case 5: factionName = "PMERJ";
        case 6: factionName = "BOPE";
        case 7: factionName = "CORE";
        case 8: factionName = "UPP";
        case 9: factionName = "Exército Brasileiro";
        case 10: factionName = "PCERJ";
        case 11: factionName = "PRF";
        default: factionName = "Desconhecida";
    }
    return factionName;
}