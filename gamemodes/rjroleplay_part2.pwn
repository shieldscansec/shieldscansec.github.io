// =============================================================================
// COMANDOS GERAIS
// =============================================================================

CMD:stats(playerid, params[]) {
    if(!gPlayerInfo[playerid][pLogged]) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você precisa estar logado!");
    
    new string[1024];
    format(string, sizeof(string),
        "{FFFFFF}════════ {00FF00}ESTATÍSTICAS{FFFFFF} ════════\n\n"
        "{FFFFFF}Nome: {FFFF00}%s\n"
        "{FFFFFF}Level: {FFFF00}%d {FFFFFF}| EXP: {FFFF00}%d\n"
        "{FFFFFF}Dinheiro: {00FF00}R$ %s\n"
        "{FFFFFF}Banco: {00FF00}R$ %s\n"
        "{FFFFFF}Idade: {FFFF00}%d anos\n"
        "{FFFFFF}Sexo: {FFFF00}%s\n"
        "{FFFFFF}CPF: {FFFF00}%s\n"
        "{FFFFFF}RG: {FFFF00}%s\n"
        "{FFFFFF}CNH: {FFFF00}%s\n"
        "{FFFFFF}Porte de Arma: {FFFF00}%s\n"
        "{FFFFFF}Celular: {FFFF00}%s\n"
        "{FFFFFF}Facção: {FFFF00}%s\n"
        "{FFFFFF}Cargo: {FFFF00}%s\n"
        "{FFFFFF}VIP: {FFFF00}%s\n"
        "{FFFFFF}Coins: {FFFF00}%d\n"
        "{FFFFFF}Tempo jogado: {FFFF00}%d horas",
        gPlayerInfo[playerid][pName],
        gPlayerInfo[playerid][pLevel],
        gPlayerInfo[playerid][pExp],
        FormatNumber(gPlayerInfo[playerid][pMoney]),
        FormatNumber(gPlayerInfo[playerid][pBankMoney]),
        gPlayerInfo[playerid][pAge],
        (gPlayerInfo[playerid][pSex] == 0) ? "Masculino" : "Feminino",
        gPlayerInfo[playerid][pCPF],
        gPlayerInfo[playerid][pRG],
        (gPlayerInfo[playerid][pCNH]) ? "Sim" : "Não",
        (gPlayerInfo[playerid][pWeaponLicense]) ? "Sim" : "Não",
        gPlayerInfo[playerid][pPhoneNumber],
        GetFactionName(gPlayerInfo[playerid][pFactionID]),
        GetFactionRankName(gPlayerInfo[playerid][pFactionID], gPlayerInfo[playerid][pFactionRank]),
        GetVIPName(gPlayerInfo[playerid][pVIPLevel]),
        gPlayerInfo[playerid][pCoins],
        gPlayerInfo[playerid][pTotalHours]
    );
    
    ShowPlayerDialog(playerid, DIALOG_STATS, DIALOG_STYLE_MSGBOX, "{00FF00}Estatísticas", string, "Fechar", "");
    return 1;
}

CMD:inventario(playerid, params[]) {
    if(!gPlayerInfo[playerid][pLogged]) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você precisa estar logado!");
    
    ShowPlayerInventory(playerid);
    return 1;
}

CMD:celular(playerid, params[]) {
    if(!gPlayerInfo[playerid][pLogged]) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você precisa estar logado!");
    
    ShowPlayerPhone(playerid);
    return 1;
}

CMD:rg(playerid, params[]) {
    new targetid;
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_YELLOW, "USO: /rg [id/nome]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Jogador não encontrado!");
    if(!IsPlayerNearPlayer(playerid, targetid, 5.0)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Jogador muito longe!");
    
    new string[256];
    format(string, sizeof(string), 
        "{FFFFFF}═══════ {00FF00}DOCUMENTO DE IDENTIDADE{FFFFFF} ═══════\n\n"
        "{FFFFFF}Nome: {FFFF00}%s\n"
        "{FFFFFF}RG: {FFFF00}%s\n"
        "{FFFFFF}CPF: {FFFF00}%s\n"
        "{FFFFFF}Idade: {FFFF00}%d anos\n"
        "{FFFFFF}Sexo: {FFFF00}%s",
        gPlayerInfo[targetid][pName],
        gPlayerInfo[targetid][pRG],
        gPlayerInfo[targetid][pCPF],
        gPlayerInfo[targetid][pAge],
        (gPlayerInfo[targetid][pSex] == 0) ? "Masculino" : "Feminino"
    );
    
    ShowPlayerDialog(playerid, DIALOG_RG, DIALOG_STYLE_MSGBOX, "{00FF00}Documento de Identidade", string, "Fechar", "");
    
    format(string, sizeof(string), "* %s mostra o RG para %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid));
    SendNearbyMessage(playerid, COLOR_PURPLE, string, 10.0);
    
    return 1;
}

CMD:cnh(playerid, params[]) {
    new targetid;
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_YELLOW, "USO: /cnh [id/nome]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Jogador não encontrado!");
    if(!gPlayerInfo[playerid][pCNH]) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não possui CNH!");
    if(!IsPlayerNearPlayer(playerid, targetid, 5.0)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Jogador muito longe!");
    
    new string[256];
    format(string, sizeof(string), 
        "{FFFFFF}═══════ {00FF00}CARTEIRA NACIONAL DE HABILITAÇÃO{FFFFFF} ═══════\n\n"
        "{FFFFFF}Nome: {FFFF00}%s\n"
        "{FFFFFF}RG: {FFFF00}%s\n"
        "{FFFFFF}CPF: {FFFF00}%s\n"
        "{FFFFFF}Categoria: {FFFF00}B\n"
        "{FFFFFF}Validade: {00FF00}VÁLIDA",
        gPlayerInfo[playerid][pName],
        gPlayerInfo[playerid][pRG],
        gPlayerInfo[playerid][pCPF]
    );
    
    ShowPlayerDialog(targetid, DIALOG_CNH, DIALOG_STYLE_MSGBOX, "{00FF00}Carteira Nacional de Habilitação", string, "Fechar", "");
    
    format(string, sizeof(string), "* %s mostra a CNH para %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid));
    SendNearbyMessage(playerid, COLOR_PURPLE, string, 10.0);
    
    return 1;
}

CMD:porte(playerid, params[]) {
    new targetid;
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_YELLOW, "USO: /porte [id/nome]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Jogador não encontrado!");
    if(!gPlayerInfo[playerid][pWeaponLicense]) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não possui porte de arma!");
    if(!IsPlayerNearPlayer(playerid, targetid, 5.0)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Jogador muito longe!");
    
    new string[256];
    format(string, sizeof(string), 
        "{FFFFFF}═══════ {00FF00}PORTE DE ARMA{FFFFFF} ═══════\n\n"
        "{FFFFFF}Nome: {FFFF00}%s\n"
        "{FFFFFF}RG: {FFFF00}%s\n"
        "{FFFFFF}CPF: {FFFF00}%s\n"
        "{FFFFFF}Categoria: {FFFF00}Civil\n"
        "{FFFFFF}Status: {00FF00}VÁLIDO",
        gPlayerInfo[playerid][pName],
        gPlayerInfo[playerid][pRG],
        gPlayerInfo[playerid][pCPF]
    );
    
    ShowPlayerDialog(targetid, DIALOG_PORTE, DIALOG_STYLE_MSGBOX, "{00FF00}Porte de Arma", string, "Fechar", "");
    
    format(string, sizeof(string), "* %s mostra o porte de arma para %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid));
    SendNearbyMessage(playerid, COLOR_PURPLE, string, 10.0);
    
    return 1;
}

// =============================================================================
// COMANDOS DAS FACÇÕES POLICIAIS
// =============================================================================

CMD:prender(playerid, params[]) {
    if(!IsPlayerPolice(playerid)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não é policial!");
    
    new targetid, tempo, motivo[128];
    if(sscanf(params, "uis[128]", targetid, tempo, motivo)) return SendClientMessage(playerid, COLOR_YELLOW, "USO: /prender [id] [tempo(min)] [motivo]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Jogador não encontrado!");
    if(!IsPlayerNearPlayer(playerid, targetid, 5.0)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Jogador muito longe!");
    if(tempo < 1 || tempo > 60) return SendClientMessage(playerid, COLOR_RED, "ERRO: Tempo deve ser entre 1 e 60 minutos!");
    
    // Algemas primeiro
    if(!GetPVarInt(targetid, "Algemado")) return SendClientMessage(playerid, COLOR_RED, "ERRO: O suspeito deve estar algemado primeiro! Use /algemar");
    
    gPlayerInfo[targetid][pJailTime] = tempo;
    SetPlayerPos(targetid, 264.6288, 77.5742, 1001.0394); // Cadeia
    SetPlayerInterior(targetid, 6);
    SetPlayerVirtualWorld(targetid, 1);
    
    ResetPlayerWeapons(targetid);
    SetPlayerHealth(targetid, 100.0);
    
    new string[256];
    format(string, sizeof(string), "POLÍCIA: %s prendeu %s por %d minutos. Motivo: %s", 
        GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), tempo, motivo);
    SendClientMessageToAll(COLOR_BLUE, string);
    
    format(string, sizeof(string), "Você foi preso por %s. Tempo: %d minutos | Motivo: %s", 
        GetPlayerNameEx(playerid), tempo, motivo);
    SendClientMessage(targetid, COLOR_RED, string);
    
    // Log
    format(string, sizeof(string), "%s prendeu %s por %d min. Motivo: %s", 
        GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), tempo, motivo);
    SaveLog("prison", GetPlayerNameEx(playerid), GetPlayerIPEx(playerid), string);
    
    DeletePVar(targetid, "Algemado");
    return 1;
}

CMD:algemar(playerid, params[]) {
    if(!IsPlayerPolice(playerid)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não é policial!");
    
    new targetid;
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_YELLOW, "USO: /algemar [id]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Jogador não encontrado!");
    if(!IsPlayerNearPlayer(playerid, targetid, 3.0)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Jogador muito longe!");
    if(playerid == targetid) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não pode algemar a si mesmo!");
    
    if(GetPVarInt(targetid, "Algemado")) {
        // Desalgemar
        TogglePlayerControllable(targetid, 1);
        DeletePVar(targetid, "Algemado");
        
        new string[128];
        format(string, sizeof(string), "* %s desalgema %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid));
        SendNearbyMessage(playerid, COLOR_PURPLE, string, 10.0);
        
        SendClientMessage(targetid, COLOR_GREEN, "Você foi desalgemado!");
    } else {
        // Algemar
        TogglePlayerControllable(targetid, 0);
        SetPVarInt(targetid, "Algemado", 1);
        
        new string[128];
        format(string, sizeof(string), "* %s algema %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid));
        SendNearbyMessage(playerid, COLOR_PURPLE, string, 10.0);
        
        SendClientMessage(targetid, COLOR_RED, "Você foi algemado!");
    }
    
    return 1;
}

CMD:revistar(playerid, params[]) {
    if(!IsPlayerPolice(playerid)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não é policial!");
    
    new targetid;
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_YELLOW, "USO: /revistar [id]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Jogador não encontrado!");
    if(!IsPlayerNearPlayer(playerid, targetid, 3.0)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Jogador muito longe!");
    
    new string[512];
    new foundItems[256] = "Nenhum item encontrado";
    new foundWeapons[256] = "Nenhuma arma encontrada";
    new foundMoney[32];
    
    // Verificar dinheiro
    format(foundMoney, sizeof(foundMoney), "R$ %s", FormatNumber(gPlayerInfo[targetid][pMoney]));
    
    // Verificar armas
    new weaponStr[128] = "";
    for(new i = 0; i < 13; i++) {
        new weapon, ammo;
        GetPlayerWeaponData(targetid, i, weapon, ammo);
        if(weapon > 0) {
            new weaponName[32];
            GetWeaponName(weapon, weaponName, sizeof(weaponName));
            if(strlen(weaponStr) > 0) strcat(weaponStr, ", ");
            format(weaponStr, sizeof(weaponStr), "%s%s (%d munições)", weaponStr, weaponName, ammo);
        }
    }
    if(strlen(weaponStr) > 0) foundWeapons = weaponStr;
    
    // Verificar inventário (drogas, itens ilegais)
    new itemStr[128] = "";
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++) {
        if(gPlayerInfo[targetid][pInventory][i][0] > 0) {
            new itemName[50];
            GetItemName(gPlayerInfo[targetid][pInventory][i][0], itemName);
            if(IsIllegalItem(gPlayerInfo[targetid][pInventory][i][0])) {
                if(strlen(itemStr) > 0) strcat(itemStr, ", ");
                format(itemStr, sizeof(itemStr), "%s%s (%dx)", itemStr, itemName, gPlayerInfo[targetid][pInventory][i][1]);
            }
        }
    }
    if(strlen(itemStr) > 0) foundItems = itemStr;
    
    format(string, sizeof(string),
        "{FFFFFF}════════ {FF0000}RESULTADO DA REVISTA{FFFFFF} ════════\n\n"
        "{FFFFFF}Suspeito: {FFFF00}%s\n"
        "{FFFFFF}Dinheiro: {00FF00}%s\n"
        "{FFFFFF}Armas: {FF0000}%s\n"
        "{FFFFFF}Itens ilegais: {FF8000}%s",
        GetPlayerNameEx(targetid),
        foundMoney,
        foundWeapons,
        foundItems
    );
    
    ShowPlayerDialog(playerid, DIALOG_REVISTA, DIALOG_STYLE_MSGBOX, "{FF0000}Resultado da Revista", string, "Fechar", "");
    
    format(string, sizeof(string), "* %s revista %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid));
    SendNearbyMessage(playerid, COLOR_PURPLE, string, 10.0);
    
    // Log
    format(string, sizeof(string), "%s revistou %s - Armas: %s | Itens: %s", 
        GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), foundWeapons, foundItems);
    SaveLog("revista", GetPlayerNameEx(playerid), GetPlayerIPEx(playerid), string);
    
    return 1;
}

CMD:blitz(playerid, params[]) {
    if(!IsPlayerPolice(playerid)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não é policial!");
    if(gPlayerInfo[playerid][pFactionRank] < 3) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você precisa ser no mínimo Cabo!");
    
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    
    // Criar objetos da blitz
    CreateDynamicObject(968, x + 5.0, y, z, 0.0, 90.0, 0.0); // Barreira
    CreateDynamicObject(968, x - 5.0, y, z, 0.0, 90.0, 0.0); // Barreira
    CreateDynamicObject(1459, x, y + 3.0, z, 0.0, 0.0, 0.0); // Cone
    CreateDynamicObject(1459, x, y - 3.0, z, 0.0, 0.0, 0.0); // Cone
    
    new string[128];
    format(string, sizeof(string), "BLITZ: %s iniciou uma blitz policial!", GetPlayerNameEx(playerid));
    SendClientMessageToAll(COLOR_BLUE, string);
    
    // Criar checkpoint para a blitz
    SetPlayerCheckpoint(playerid, x, y, z, 10.0);
    
    return 1;
}

// =============================================================================
// COMANDOS DAS FACÇÕES CRIMINOSAS
// =============================================================================

CMD:dominar(playerid, params[]) {
    if(!IsPlayerCriminal(playerid)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não é de uma facção criminosa!");
    if(gPlayerInfo[playerid][pFactionRank] < 5) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você precisa ser no mínimo Soldado!");
    
    new territoryID = GetPlayerTerritory(playerid);
    if(territoryID == -1) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não está em um território!");
    
    if(gTerritoryInfo[territoryID][tFactionID] == gPlayerInfo[playerid][pFactionID]) {
        return SendClientMessage(playerid, COLOR_RED, "ERRO: Sua facção já domina este território!");
    }
    
    // Iniciar guerra de território
    new string[128];
    format(string, sizeof(string), "GUERRA: %s (%s) está tentando dominar o território %s!", 
        GetPlayerNameEx(playerid), 
        GetFactionName(gPlayerInfo[playerid][pFactionID]),
        gTerritoryInfo[territoryID][tName]
    );
    SendClientMessageToAll(COLOR_RED, string);
    
    // Criar pickup de dominação
    CreateDynamicPickup(1314, 1, gTerritoryInfo[territoryID][tMinX], gTerritoryInfo[territoryID][tMinY], 
        gTerritoryInfo[territoryID][tMaxZ] + 1.0);
    
    SetPVarInt(playerid, "DominandoTerritorio", territoryID);
    SetPVarInt(playerid, "TempoDominacao", 300); // 5 minutos
    
    return 1;
}

CMD:drogas(playerid, params[]) {
    if(!gPlayerInfo[playerid][pLogged]) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você precisa estar logado!");
    
    new action[32], quantity;
    if(sscanf(params, "s[32]i", action, quantity)) {
        SendClientMessage(playerid, COLOR_YELLOW, "USO: /drogas [produzir/vender] [quantidade]");
        return 1;
    }
    
    if(!strcmp(action, "produzir", true)) {
        if(!IsPlayerCriminal(playerid)) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não é de uma facção criminosa!");
        
        new territoryID = GetPlayerTerritory(playerid);
        if(territoryID == -1) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não está em um território!");
        if(gTerritoryInfo[territoryID][tFactionID] != gPlayerInfo[playerid][pFactionID]) {
            return SendClientMessage(playerid, COLOR_RED, "ERRO: Sua facção não domina este território!");
        }
        
        if(quantity < 1 || quantity > 50) return SendClientMessage(playerid, COLOR_RED, "ERRO: Quantidade deve ser entre 1 e 50!");
        
        new materials = GetPlayerInventoryItem(playerid, 15); // Material para droga
        if(materials < quantity * 2) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você precisa de mais materiais!");
        
        RemovePlayerInventoryItem(playerid, 15, quantity * 2);
        GivePlayerInventoryItem(playerid, 16, quantity); // Droga
        
        new string[128];
        format(string, sizeof(string), "Você produziu %d unidades de droga usando %d materiais!", quantity, quantity * 2);
        SendClientMessage(playerid, COLOR_GREEN, string);
        
    } else if(!strcmp(action, "vender", true)) {
        new drugs = GetPlayerInventoryItem(playerid, 16);
        if(drugs < quantity) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não tem drogas suficientes!");
        
        new price = quantity * (500 + random(300)); // R$ 500-800 por unidade
        RemovePlayerInventoryItem(playerid, 16, quantity);
        GivePlayerMoney(playerid, price);
        
        new string[128];
        format(string, sizeof(string), "Você vendeu %d unidades de droga por R$ %s!", quantity, FormatNumber(price));
        SendClientMessage(playerid, COLOR_GREEN, string);
        
        // Chance de polícia descobrir
        if(random(100) < 20) { // 20% de chance
            SendClientMessage(playerid, COLOR_RED, "ALERTA: Alguém te denunciou para a polícia!");
            gPlayerInfo[playerid][pWantedLevel] += 2;
        }
    }
    
    return 1;
}

// =============================================================================
// SISTEMA DE INVENTÁRIO
// =============================================================================

stock ShowPlayerInventory(playerid) {
    new string[1024], itemStr[64];
    string = "{FFFFFF}═══════ {00FF00}INVENTÁRIO{FFFFFF} ═══════\n\n";
    
    new itemCount = 0;
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++) {
        if(gPlayerInfo[playerid][pInventory][i][0] > 0) {
            new itemName[50];
            GetItemName(gPlayerInfo[playerid][pInventory][i][0], itemName);
            
            format(itemStr, sizeof(itemStr), "{FFFFFF}%d. {FFFF00}%s {FFFFFF}x%d\n", 
                i + 1, itemName, gPlayerInfo[playerid][pInventory][i][1]);
            strcat(string, itemStr);
            itemCount++;
        }
    }
    
    if(itemCount == 0) {
        strcat(string, "{FFFFFF}Seu inventário está vazio!\n");
    }
    
    format(itemStr, sizeof(itemStr), "\n{FFFFFF}Slots ocupados: {FFFF00}%d{FFFFFF}/%d", itemCount, MAX_INVENTORY_SLOTS);
    strcat(string, itemStr);
    
    ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_MSGBOX, "{00FF00}Inventário", string, "Fechar", "");
    gPlayerInfo[playerid][pInventoryOpen] = 1;
}

stock GivePlayerInventoryItem(playerid, itemid, quantity) {
    // Verificar se o item pode ser stackado
    new maxStack = GetItemMaxStack(itemid);
    
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++) {
        // Se o slot tem o mesmo item e pode stackar mais
        if(gPlayerInfo[playerid][pInventory][i][0] == itemid && 
           gPlayerInfo[playerid][pInventory][i][1] < maxStack) {
            
            new canAdd = maxStack - gPlayerInfo[playerid][pInventory][i][1];
            if(canAdd >= quantity) {
                gPlayerInfo[playerid][pInventory][i][1] += quantity;
                return 1;
            } else {
                gPlayerInfo[playerid][pInventory][i][1] = maxStack;
                quantity -= canAdd;
            }
        }
    }
    
    // Procurar slot vazio
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++) {
        if(gPlayerInfo[playerid][pInventory][i][0] == 0) {
            gPlayerInfo[playerid][pInventory][i][0] = itemid;
            gPlayerInfo[playerid][pInventory][i][1] = quantity;
            gPlayerInfo[playerid][pInventory][i][2] = i;
            return 1;
        }
    }
    
    return 0; // Inventário cheio
}

stock RemovePlayerInventoryItem(playerid, itemid, quantity) {
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++) {
        if(gPlayerInfo[playerid][pInventory][i][0] == itemid) {
            if(gPlayerInfo[playerid][pInventory][i][1] >= quantity) {
                gPlayerInfo[playerid][pInventory][i][1] -= quantity;
                if(gPlayerInfo[playerid][pInventory][i][1] <= 0) {
                    gPlayerInfo[playerid][pInventory][i][0] = 0;
                    gPlayerInfo[playerid][pInventory][i][1] = 0;
                }
                return 1;
            } else {
                quantity -= gPlayerInfo[playerid][pInventory][i][1];
                gPlayerInfo[playerid][pInventory][i][0] = 0;
                gPlayerInfo[playerid][pInventory][i][1] = 0;
            }
        }
    }
    return 0;
}

stock GetPlayerInventoryItem(playerid, itemid) {
    new total = 0;
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++) {
        if(gPlayerInfo[playerid][pInventory][i][0] == itemid) {
            total += gPlayerInfo[playerid][pInventory][i][1];
        }
    }
    return total;
}

// =============================================================================
// SISTEMA DE CELULAR
// =============================================================================

CMD:ligar(playerid, params[]) {
    if(!gPlayerInfo[playerid][pLogged]) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você precisa estar logado!");
    
    new number[15];
    if(sscanf(params, "s[15]", number)) return SendClientMessage(playerid, COLOR_YELLOW, "USO: /ligar [número]");
    
    new targetid = GetPlayerByPhoneNumber(number);
    if(targetid == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "ERRO: Número não encontrado!");
    if(targetid == playerid) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não pode ligar para si mesmo!");
    
    if(gPlayerInfo[targetid][pPhoneOnCall]) return SendClientMessage(playerid, COLOR_RED, "ERRO: Este número está ocupado!");
    
    // Iniciando chamada
    gPlayerInfo[playerid][pPhoneOnCall] = 1;
    gPlayerInfo[playerid][pPhoneCallerID] = targetid;
    gPlayerInfo[targetid][pPhoneOnCall] = 1;
    gPlayerInfo[targetid][pPhoneCallerID] = playerid;
    
    new string[128];
    format(string, sizeof(string), "Ligando para %s...", number);
    SendClientMessage(playerid, COLOR_YELLOW, string);
    
    format(string, sizeof(string), "Celular tocando... Chamada de %s. Digite /atender para atender ou /desligar para recusar.", 
        gPlayerInfo[playerid][pPhoneNumber]);
    SendClientMessage(targetid, COLOR_YELLOW, string);
    
    return 1;
}

CMD:atender(playerid, params[]) {
    if(!gPlayerInfo[playerid][pPhoneOnCall]) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não está recebendo ligação!");
    
    new callerID = gPlayerInfo[playerid][pPhoneCallerID];
    
    SendClientMessage(playerid, COLOR_GREEN, "Chamada atendida! Digite /desligar para encerrar.");
    SendClientMessage(callerID, COLOR_GREEN, "Chamada atendida! Digite /desligar para encerrar.");
    
    new string[128];
    format(string, sizeof(string), "* %s atende o celular", GetPlayerNameEx(playerid));
    SendNearbyMessage(playerid, COLOR_PURPLE, string, 10.0);
    
    return 1;
}

CMD:desligar(playerid, params[]) {
    if(!gPlayerInfo[playerid][pPhoneOnCall]) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não está em ligação!");
    
    new targetID = gPlayerInfo[playerid][pPhoneCallerID];
    
    gPlayerInfo[playerid][pPhoneOnCall] = 0;
    gPlayerInfo[playerid][pPhoneCallerID] = INVALID_PLAYER_ID;
    gPlayerInfo[targetID][pPhoneOnCall] = 0;
    gPlayerInfo[targetID][pPhoneCallerID] = INVALID_PLAYER_ID;
    
    SendClientMessage(playerid, COLOR_RED, "Ligação encerrada.");
    SendClientMessage(targetID, COLOR_RED, "Ligação encerrada.");
    
    new string[128];
    format(string, sizeof(string), "* %s desliga o celular", GetPlayerNameEx(playerid));
    SendNearbyMessage(playerid, COLOR_PURPLE, string, 10.0);
    
    return 1;
}

CMD:sms(playerid, params[]) {
    if(!gPlayerInfo[playerid][pLogged]) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você precisa estar logado!");
    
    new number[15], message[128];
    if(sscanf(params, "s[15]s[128]", number, message)) return SendClientMessage(playerid, COLOR_YELLOW, "USO: /sms [número] [mensagem]");
    
    new targetid = GetPlayerByPhoneNumber(number);
    if(targetid == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_RED, "ERRO: Número não encontrado!");
    if(targetid == playerid) return SendClientMessage(playerid, COLOR_RED, "ERRO: Você não pode enviar SMS para si mesmo!");
    
    // Salvando SMS no banco
    new query[512];
    format(query, sizeof(query), 
        "INSERT INTO phone_messages (sender_number, receiver_number, message) VALUES ('%s', '%s', '%s')",
        gPlayerInfo[playerid][pPhoneNumber], number, message);
    mysql_tquery(gMySQL, query);
    
    new string[256];
    format(string, sizeof(string), "SMS enviado para %s: %s", number, message);
    SendClientMessage(playerid, COLOR_GREEN, string);
    
    format(string, sizeof(string), "SMS de %s: %s", gPlayerInfo[playerid][pPhoneNumber], message);
    SendClientMessage(targetid, COLOR_YELLOW, string);
    
    return 1;
}

// Continuando na próxima parte...