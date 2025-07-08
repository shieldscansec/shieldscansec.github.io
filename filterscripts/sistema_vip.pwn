
/*
====================================================================================================
    SISTEMA VIP COMPLETO - RIO DE JANEIRO ROLEPLAY
    
    Funcionalidades:
    - 3 Níveis VIP (Bronze, Silver, Gold)
    - Comandos exclusivos para cada nível
    - Sistema de coins integrado
    - Benefícios progressivos
    - Interface moderna com diálogos nativos
    - Sistema de arquivos INI
    
    Autor: Rio de Janeiro RP Team
    Versão: 3.0 - Atualizado (INI + ZCMD + Diálogos Nativos)
====================================================================================================
*/

#include <a_samp>
#include <sscanf2>
#include <zcmd>

// Cores do sistema
#define COR_VIP_BRONZE  0x87CEEBFF
#define COR_VIP_SILVER  0xC0C0C0FF
#define COR_VIP_GOLD    0xFFD700FF
#define COR_SUCESSO     0x4ECDC4FF
#define COR_ERRO        0xFF6B6BFF
#define COR_INFO        0x95E1D3FF

// Níveis VIP
#define VIP_NONE    0
#define VIP_BRONZE  1
#define VIP_SILVER  2
#define VIP_GOLD    3

// Preços VIP (em reais)
#define PRECO_VIP_BRONZE    15
#define PRECO_VIP_SILVER    25
#define PRECO_VIP_GOLD      35

// Coins mensais por VIP
#define COINS_VIP_BRONZE    50
#define COINS_VIP_SILVER    100
#define COINS_VIP_GOLD      200

// Cooldowns
#define COOLDOWN_VHEAL      30  // segundos
#define COOLDOWN_VARMOUR    30  // segundos
#define COOLDOWN_VTP        60  // segundos
#define COOLDOWN_VCAR       300 // segundos

// Diálogos
#define DIALOG_VIP_MENU     1001
#define DIALOG_VIP_PURCHASE 1002
#define DIALOG_VIP_TELEPORT 1003
#define DIALOG_VIP_CARS     1004

// Enum para dados VIP
enum E_VIP_DATA
{
    vip_Level,
    vip_ExpireDate,
    vip_Coins,
    vip_LastHeal,
    vip_LastArmour,
    vip_LastTP,
    vip_LastCar
}

// Variáveis globais
new PlayerVIP[MAX_PLAYERS][E_VIP_DATA];

// ====================================================================================================
// EVENTOS DO FILTERSCRIPT
// ====================================================================================================

public OnFilterScriptInit()
{
    print("\n========================================");
    print("  SISTEMA VIP - Rio de Janeiro RP");
    print("  Versão 3.0 - Carregado com sucesso!");
    print("  Sistema: INI + ZCMD + Dialogs Nativos");
    print("========================================\n");
    
    // Criar diretório para dados VIP se não existir
    if(!fexist("scriptfiles/vip/"))
    {
        print("* Criando diretório scriptfiles/vip/");
    }
    
    return 1;
}

public OnFilterScriptExit()
{
    // Salvar dados de todos os jogadores conectados
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            SavePlayerVIP(i);
        }
    }
    
    print("Sistema VIP descarregado!");
    return 1;
}

public OnPlayerConnect(playerid)
{
    // Resetar dados VIP
    PlayerVIP[playerid][vip_Level] = VIP_NONE;
    PlayerVIP[playerid][vip_ExpireDate] = 0;
    PlayerVIP[playerid][vip_Coins] = 0;
    PlayerVIP[playerid][vip_LastHeal] = 0;
    PlayerVIP[playerid][vip_LastArmour] = 0;
    PlayerVIP[playerid][vip_LastTP] = 0;
    PlayerVIP[playerid][vip_LastCar] = 0;
    
    // Carregar dados VIP do jogador
    SetTimerEx("LoadPlayerVIP", 2000, false, "i", playerid);
    
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    // Salvar dados VIP
    SavePlayerVIP(playerid);
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_VIP_MENU:
        {
            if(!response) return 1;
            
            switch(listitem)
            {
                case 0: // Ver status VIP
                {
                    ShowVIPStatus(playerid);
                }
                case 1: // Comandos VIP
                {
                    ShowVIPCommands(playerid);
                }
                case 2: // Teleports VIP
                {
                    if(IsPlayerVIP(playerid, VIP_SILVER))
                    {
                        ShowVIPTeleportMenu(playerid);
                    }
                    else
                    {
                        SendClientMessage(playerid, COR_ERRO, "❌ Você precisa ser VIP Silver ou superior!");
                    }
                }
                case 3: // Carros VIP
                {
                    if(IsPlayerVIP(playerid, VIP_GOLD))
                    {
                        ShowVIPCarMenu(playerid);
                    }
                    else
                    {
                        SendClientMessage(playerid, COR_ERRO, "❌ Você precisa ser VIP Gold!");
                    }
                }
                case 4: // Comprar VIP
                {
                    ShowVIPPurchase(playerid);
                }
            }
        }
        case DIALOG_VIP_PURCHASE:
        {
            if(!response) return 1;
            
            new string[256];
            switch(listitem)
            {
                case 0: // VIP Bronze
                {
                    format(string, sizeof(string), 
                        "💰 VIP Bronze - R$ %d\n\n\
                        ✅ Benefícios:\n\
                        • /vheal - Curar vida\n\
                        • /varmour - Colete\n\
                        • %d coins mensais\n\
                        • Tag [Bronze] no chat\n\n\
                        Entre em contato com a administração para adquirir!",
                        PRECO_VIP_BRONZE, COINS_VIP_BRONZE
                    );
                }
                case 1: // VIP Silver
                {
                    format(string, sizeof(string), 
                        "🥈 VIP Silver - R$ %d\n\n\
                        ✅ Benefícios:\n\
                        • Todos do Bronze +\n\
                        • /vtp - Teleports exclusivos\n\
                        • %d coins mensais\n\
                        • Tag [Silver] no chat\n\n\
                        Entre em contato com a administração para adquirir!",
                        PRECO_VIP_SILVER, COINS_VIP_SILVER
                    );
                }
                case 2: // VIP Gold
                {
                    format(string, sizeof(string), 
                        "🥇 VIP Gold - R$ %d\n\n\
                        ✅ Benefícios:\n\
                        • Todos do Silver +\n\
                        • /vcar - Carros exclusivos\n\
                        • %d coins mensais\n\
                        • Tag [Gold] no chat\n\
                        • Prioridade no servidor\n\n\
                        Entre em contato com a administração para adquirir!",
                        PRECO_VIP_GOLD, COINS_VIP_GOLD
                    );
                }
            }
            ShowPlayerDialog(playerid, 9999, DIALOG_STYLE_MSGBOX, "💎 Informações VIP", string, "OK", "");
        }
        case DIALOG_VIP_TELEPORT:
        {
            if(!response) return 1;
            
            new Float:x, Float:y, Float:z;
            new location_name[64];
            
            switch(listitem)
            {
                case 0: // Cristo Redentor
                {
                    x = -2274.0; y = 2975.0; z = 55.0;
                    strcpy(location_name, "Cristo Redentor");
                }
                case 1: // Pão de Açúcar
                {
                    x = -2650.0; y = 1350.0; z = 85.0;
                    strcpy(location_name, "Pão de Açúcar");
                }
                case 2: // Copacabana
                {
                    x = -2662.0; y = 1426.0; z = 10.0;
                    strcpy(location_name, "Praia de Copacabana");
                }
                case 3: // Maracanã
                {
                    x = -1404.0; y = 1265.0; z = 30.0;
                    strcpy(location_name, "Estádio do Maracanã");
                }
            }
            
            SetPlayerPos(playerid, x, y, z);
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
            
            new string[128];
            format(string, sizeof(string), "✈️ Você foi teleportado para %s! (VIP)", location_name);
            SendClientMessage(playerid, COR_SUCESSO, string);
        }
        case DIALOG_VIP_CARS:
        {
            if(!response) return 1;
            
            new vehicleid, model;
            new Float:x, Float:y, Float:z, Float:a;
            GetPlayerPos(playerid, x, y, z);
            GetPlayerFacingAngle(playerid, a);
            
            switch(listitem)
            {
                case 0: model = 411; // Infernus
                case 1: model = 451; // Turismo
                case 2: model = 541; // Bullet
                case 3: model = 415; // Cheetah
                case 4: model = 494; // Hotring Racer
            }
            
            vehicleid = CreateVehicle(model, x + 3, y, z, a, -1, -1, 300);
            PutPlayerInVehicle(playerid, vehicleid, 0);
            
            SendClientMessage(playerid, COR_SUCESSO, "🚗 Seu carro VIP foi criado! (VIP Gold)");
        }
    }
    return 1;
}

// ====================================================================================================
// FUNÇÕES DO SISTEMA VIP
// ====================================================================================================

forward LoadPlayerVIP(playerid);
public LoadPlayerVIP(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    
    new file_path[64];
    format(file_path, sizeof(file_path), "scriptfiles/vip/%s.ini", name);
    
    if(fexist(file_path))
    {
        new File:file = fopen(file_path, io_read);
        if(file)
        {
            new line[256], key[32], value[64];
            
            while(fread(file, line))
            {
                if(sscanf(line, "p<=>s[32]s[64]", key, value) == 2)
                {
                    if(!strcmp(key, "Level", true))
                        PlayerVIP[playerid][vip_Level] = strval(value);
                    else if(!strcmp(key, "ExpireDate", true))
                        PlayerVIP[playerid][vip_ExpireDate] = strval(value);
                    else if(!strcmp(key, "Coins", true))
                        PlayerVIP[playerid][vip_Coins] = strval(value);
                }
            }
            fclose(file);
            
            // Verificar se o VIP expirou
            if(PlayerVIP[playerid][vip_ExpireDate] > 0 && gettime() > PlayerVIP[playerid][vip_ExpireDate])
            {
                PlayerVIP[playerid][vip_Level] = VIP_NONE;
                PlayerVIP[playerid][vip_ExpireDate] = 0;
                SavePlayerVIP(playerid);
                
                SendClientMessage(playerid, COR_ERRO, "❌ Seu VIP expirou! Renove para continuar aproveitando os benefícios.");
            }
            else if(PlayerVIP[playerid][vip_Level] > 0)
            {
                new string[128], vip_name[16];
                GetVIPName(PlayerVIP[playerid][vip_Level], vip_name);
                
                format(string, sizeof(string), 
                    "{%06x}⭐ Bem-vindo de volta, VIP %s! {FFFFFF}Use /vip para ver seus benefícios.", 
                    GetVIPColor(PlayerVIP[playerid][vip_Level]) >>> 8, vip_name
                );
                SendClientMessage(playerid, -1, string);
            }
        }
    }
    else
    {
        // Criar arquivo para novo jogador
        SavePlayerVIP(playerid);
    }
    
    return 1;
}

stock SavePlayerVIP(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    
    new file_path[64];
    format(file_path, sizeof(file_path), "scriptfiles/vip/%s.ini", name);
    
    new File:file = fopen(file_path, io_write);
    if(file)
    {
        fprintf(file, "Level=%d\n", PlayerVIP[playerid][vip_Level]);
        fprintf(file, "ExpireDate=%d\n", PlayerVIP[playerid][vip_ExpireDate]);
        fprintf(file, "Coins=%d\n", PlayerVIP[playerid][vip_Coins]);
        fclose(file);
    }
    
    return 1;
}

stock GetVIPName(level, output[])
{
    switch(level)
    {
        case VIP_BRONZE: strcpy(output, "Bronze");
        case VIP_SILVER: strcpy(output, "Silver");
        case VIP_GOLD: strcpy(output, "Gold");
        default: strcpy(output, "Nenhum");
    }
    return 1;
}

stock GetVIPColor(level)
{
    switch(level)
    {
        case VIP_BRONZE: return COR_VIP_BRONZE;
        case VIP_SILVER: return COR_VIP_SILVER;
        case VIP_GOLD: return COR_VIP_GOLD;
        default: return 0xFFFFFFFF;
    }
}

stock GetVIPPrice(level)
{
    switch(level)
    {
        case VIP_BRONZE: return PRECO_VIP_BRONZE;
        case VIP_SILVER: return PRECO_VIP_SILVER;
        case VIP_GOLD: return PRECO_VIP_GOLD;
        default: return 0;
    }
}

stock GetVIPCoins(level)
{
    switch(level)
    {
        case VIP_BRONZE: return COINS_VIP_BRONZE;
        case VIP_SILVER: return COINS_VIP_SILVER;
        case VIP_GOLD: return COINS_VIP_GOLD;
        default: return 0;
    }
}

stock IsPlayerVIP(playerid, min_level = VIP_BRONZE)
{
    return (PlayerVIP[playerid][vip_Level] >= min_level && 
           (PlayerVIP[playerid][vip_ExpireDate] == 0 || gettime() < PlayerVIP[playerid][vip_ExpireDate]));
}

stock CanUseVIPCommand(playerid, min_level, &cooldown_var, cooldown_time)
{
    if(!IsPlayerVIP(playerid, min_level))
    {
        new string[128], vip_name[16];
        GetVIPName(min_level, vip_name);
        format(string, sizeof(string), 
            "❌ Este comando é exclusivo para VIP %s ou superior! Use /comprarvip.", 
            vip_name
        );
        SendClientMessage(playerid, COR_ERRO, string);
        return 0;
    }
    
    new current_time = gettime();
    if(current_time - cooldown_var < cooldown_time)
    {
        new remaining = cooldown_time - (current_time - cooldown_var);
        new string[128];
        format(string, sizeof(string), 
            "⏰ Aguarde %d segundos para usar este comando novamente.", 
            remaining
        );
        SendClientMessage(playerid, COR_INFO, string);
        return 0;
    }
    
    cooldown_var = current_time;
    return 1;
}

// ====================================================================================================
// COMANDOS VIP
// ====================================================================================================

CMD:vip(playerid, params[])
{
    ShowVIPMenu(playerid);
    return 1;
}

CMD:vheal(playerid, params[])
{
    if(!CanUseVIPCommand(playerid, VIP_BRONZE, PlayerVIP[playerid][vip_LastHeal], COOLDOWN_VHEAL))
        return 1;
        
    SetPlayerHealth(playerid, 100.0);
    SendClientMessage(playerid, COR_SUCESSO, "💚 Sua vida foi restaurada! (Comando VIP)");
    
    return 1;
}

CMD:varmour(playerid, params[])
{
    if(!CanUseVIPCommand(playerid, VIP_BRONZE, PlayerVIP[playerid][vip_LastArmour], COOLDOWN_VARMOUR))
        return 1;
        
    SetPlayerArmour(playerid, 100.0);
    SendClientMessage(playerid, COR_SUCESSO, "🛡️ Seu colete foi restaurado! (Comando VIP)");
    
    return 1;
}

CMD:vcar(playerid, params[])
{
    if(!CanUseVIPCommand(playerid, VIP_GOLD, PlayerVIP[playerid][vip_LastCar], COOLDOWN_VCAR))
        return 1;
        
    ShowVIPCarMenu(playerid);
    
    return 1;
}

CMD:vtp(playerid, params[])
{
    if(!CanUseVIPCommand(playerid, VIP_SILVER, PlayerVIP[playerid][vip_LastTP], COOLDOWN_VTP))
        return 1;
        
    ShowVIPTeleportMenu(playerid);
    
    return 1;
}

CMD:coins(playerid, params[])
{
    new string[128];
    format(string, sizeof(string), 
        "💰 Você possui {FFD700}%d coins{FFFFFF}. Use /comprarvip para adquirir mais!", 
        PlayerVIP[playerid][vip_Coins]
    );
    SendClientMessage(playerid, COR_INFO, string);
    
    return 1;
}

CMD:comprarvip(playerid, params[])
{
    ShowVIPPurchase(playerid);
    return 1;
}

// Comandos administrativos
CMD:setvip(playerid, params[])
{
    // Função fictícia - substituir pela verificação real de admin
    if(!IsPlayerAdmin(playerid))
    {
        SendClientMessage(playerid, COR_ERRO, "❌ Você não tem permissão para usar este comando.");
        return 1;
    }
    
    new targetid, level, days;
    if(sscanf(params, "udd", targetid, level, days))
    {
        SendClientMessage(playerid, COR_INFO, "💡 Use: /setvip [id] [level] [dias]");
        SendClientMessage(playerid, COR_INFO, "💡 Levels: 0 = Nenhum, 1 = Bronze, 2 = Silver, 3 = Gold");
        return 1;
    }
    
    if(!IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, COR_ERRO, "❌ Jogador não encontrado.");
        return 1;
    }
    
    if(level < 0 || level > 3)
    {
        SendClientMessage(playerid, COR_ERRO, "❌ Level inválido! Use 0-3.");
        return 1;
    }
    
    PlayerVIP[targetid][vip_Level] = level;
    if(level > 0 && days > 0)
    {
        PlayerVIP[targetid][vip_ExpireDate] = gettime() + (days * 86400);
    }
    else
    {
        PlayerVIP[targetid][vip_ExpireDate] = 0;
    }
    
    SavePlayerVIP(targetid);
    
    new string[128], admin_name[MAX_PLAYER_NAME], target_name[MAX_PLAYER_NAME], vip_name[16];
    GetPlayerName(playerid, admin_name, sizeof(admin_name));
    GetPlayerName(targetid, target_name, sizeof(target_name));
    GetVIPName(level, vip_name);
    
    format(string, sizeof(string), 
        "✅ Você definiu o VIP %s de %s por %d dias.", 
        vip_name, target_name, days
    );
    SendClientMessage(playerid, COR_SUCESSO, string);
    
    format(string, sizeof(string), 
        "⭐ Admin %s definiu seu VIP como %s por %d dias!", 
        admin_name, vip_name, days
    );
    SendClientMessage(targetid, COR_SUCESSO, string);
    
    return 1;
}

CMD:setcoins(playerid, params[])
{
    if(!IsPlayerAdmin(playerid))
    {
        SendClientMessage(playerid, COR_ERRO, "❌ Você não tem permissão para usar este comando.");
        return 1;
    }
    
    new targetid, coins;
    if(sscanf(params, "ud", targetid, coins))
    {
        SendClientMessage(playerid, COR_INFO, "💡 Use: /setcoins [id] [quantidade]");
        return 1;
    }
    
    if(!IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, COR_ERRO, "❌ Jogador não encontrado.");
        return 1;
    }
    
    PlayerVIP[targetid][vip_Coins] = coins;
    SavePlayerVIP(targetid);
    
    new string[128], admin_name[MAX_PLAYER_NAME], target_name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, admin_name, sizeof(admin_name));
    GetPlayerName(targetid, target_name, sizeof(target_name));
    
    format(string, sizeof(string), 
        "✅ Você definiu %d coins para %s.", 
        coins, target_name
    );
    SendClientMessage(playerid, COR_SUCESSO, string);
    
    format(string, sizeof(string), 
        "💰 Admin %s definiu seus coins como %d!", 
        admin_name, coins
    );
    SendClientMessage(targetid, COR_SUCESSO, string);
    
    return 1;
}

// ====================================================================================================
// INTERFACE VIP COM DIÁLOGOS NATIVOS
// ====================================================================================================

stock ShowVIPMenu(playerid)
{
    new string[512];
    
    strcat(string, "📋 Painel VIP - Rio de Janeiro RP\n\n");
    strcat(string, "1. 📊 Ver Status VIP\n");
    strcat(string, "2. 📱 Comandos VIP\n");
    strcat(string, "3. ✈️ Teleports VIP (Silver+)\n");
    strcat(string, "4. 🚗 Carros VIP (Gold)\n");
    strcat(string, "5. 💰 Comprar VIP");
    
    ShowPlayerDialog(playerid, DIALOG_VIP_MENU, DIALOG_STYLE_LIST, "💎 Sistema VIP", string, "Selecionar", "Fechar");
}

stock ShowVIPStatus(playerid)
{
    new string[512], vip_name[16];
    GetVIPName(PlayerVIP[playerid][vip_Level], vip_name);
    
    format(string, sizeof(string), 
        "{%06x}📊 STATUS VIP - %s\n\n\
        {FFFFFF}🎯 Nível VIP: {%06x}%s\n\
        {FFFFFF}💰 Coins: {FFD700}%d\n\
        {FFFFFF}⏰ Expira em: %s\n\n\
        {95E1D3}💡 Use /vip para acessar o menu completo!",
        GetVIPColor(PlayerVIP[playerid][vip_Level]) >>> 8,
        vip_name,
        GetVIPColor(PlayerVIP[playerid][vip_Level]) >>> 8,
        vip_name,
        PlayerVIP[playerid][vip_Coins],
        PlayerVIP[playerid][vip_ExpireDate] > 0 ? "Data específica" : "Permanente"
    );
    
    ShowPlayerDialog(playerid, 9999, DIALOG_STYLE_MSGBOX, "📊 Status VIP", string, "OK", "");
}

stock ShowVIPCommands(playerid)
{
    new string[512];
    
    strcat(string, "📱 COMANDOS VIP DISPONÍVEIS\n\n");
    
    if(IsPlayerVIP(playerid, VIP_BRONZE))
    {
        strcat(string, "{87CEEB}🥉 BRONZE:\n");
        strcat(string, "/vheal - Curar vida (30s cooldown)\n");
        strcat(string, "/varmour - Colete (30s cooldown)\n\n");
    }
    
    if(IsPlayerVIP(playerid, VIP_SILVER))
    {
        strcat(string, "{C0C0C0}🥈 SILVER:\n");
        strcat(string, "/vtp - Teleports exclusivos (60s cooldown)\n\n");
    }
    
    if(IsPlayerVIP(playerid, VIP_GOLD))
    {
        strcat(string, "{FFD700}🥇 GOLD:\n");
        strcat(string, "/vcar - Carros exclusivos (300s cooldown)\n\n");
    }
    
    strcat(string, "{FFFFFF}💰 GERAL:\n");
    strcat(string, "/coins - Ver seus coins\n");
    strcat(string, "/comprarvip - Adquirir VIP");
    
    ShowPlayerDialog(playerid, 9999, DIALOG_STYLE_MSGBOX, "📱 Comandos VIP", string, "OK", "");
}

stock ShowVIPPurchase(playerid)
{
    new string[512];
    
    strcat(string, "💰 ADQUIRIR VIP - PLANOS DISPONÍVEIS\n\n");
    strcat(string, "🥉 VIP Bronze - R$ 15,00\n");
    strcat(string, "🥈 VIP Silver - R$ 25,00\n");
    strcat(string, "🥇 VIP Gold - R$ 35,00");
    
    ShowPlayerDialog(playerid, DIALOG_VIP_PURCHASE, DIALOG_STYLE_LIST, "💎 Comprar VIP", string, "Informações", "Fechar");
}

stock ShowVIPTeleportMenu(playerid)
{
    new string[256];
    
    strcat(string, "✈️ TELEPORTS VIP EXCLUSIVOS\n\n");
    strcat(string, "⛪ Cristo Redentor\n");
    strcat(string, "🗻 Pão de Açúcar\n");
    strcat(string, "🏖️ Praia de Copacabana\n");
    strcat(string, "⚽ Estádio do Maracanã");
    
    ShowPlayerDialog(playerid, DIALOG_VIP_TELEPORT, DIALOG_STYLE_LIST, "✈️ Teleports VIP", string, "Teleportar", "Cancelar");
}

stock ShowVIPCarMenu(playerid)
{
    new string[256];
    
    strcat(string, "🚗 CARROS VIP EXCLUSIVOS\n\n");
    strcat(string, "🏎️ Infernus (Super esportivo)\n");
    strcat(string, "🏎️ Turismo (Clássico)\n");
    strcat(string, "🏎️ Bullet (Velocidade)\n");
    strcat(string, "🏎️ Cheetah (Luxo)\n");
    strcat(string, "🏁 Hotring Racer (Corrida)");
    
    ShowPlayerDialog(playerid, DIALOG_VIP_CARS, DIALOG_STYLE_LIST, "🚗 Carros VIP", string, "Spawnar", "Cancelar");
}