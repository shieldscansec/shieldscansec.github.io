
/*
====================================================================================================
    SISTEMA VIP COMPLETO - RIO DE JANEIRO ROLEPLAY
    
    Funcionalidades:
    - 3 Níveis VIP (Bronze, Silver, Gold)
    - Comandos exclusivos para cada nível
    - Sistema de coins integrado
    - Benefícios progressivos
    - Interface moderna
    - Integração com MySQL
    
    Autor: Rio de Janeiro RP Team
    Versão: 2.0
====================================================================================================
*/

#include <a_samp>
#include <a_mysql>
#include <sscanf2>
#include <Pawn.CMD>
#include <easyDialog>

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
new MySQL:Database;

// ====================================================================================================
// EVENTOS DO FILTERSCRIPT
// ====================================================================================================

public OnFilterScriptInit()
{
    print("\n========================================");
    print("  SISTEMA VIP - Rio de Janeiro RP");
    print("  Versão 2.0 - Carregado com sucesso!");
    print("========================================\n");
    
    // Conectar ao banco de dados
    Database = mysql_connect("localhost", "root", "", "rjroleplay");
    
    if (Database == MYSQL_INVALID_HANDLE)
    {
        print("ERRO: Falha ao conectar com o banco de dados MySQL!");
        return 0;
    }
    
    // Criar tabela VIP se não existir
    mysql_tquery(Database, "CREATE TABLE IF NOT EXISTS `vip_players` (\
        `id` int(11) NOT NULL AUTO_INCREMENT,\
        `player_name` varchar(24) NOT NULL,\
        `vip_level` int(11) NOT NULL DEFAULT '0',\
        `expire_date` int(11) NOT NULL DEFAULT '0',\
        `coins` int(11) NOT NULL DEFAULT '0',\
        `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,\
        `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,\
        PRIMARY KEY (`id`),\
        UNIQUE KEY `player_name` (`player_name`)\
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;");
    
    // Registrar comandos VIP
    PC_RegCommand("vip", "vip", 0);
    PC_RegCommand("vheal", "vheal", 0);
    PC_RegCommand("varmour", "varmour", 0);
    PC_RegCommand("vcar", "vcar", 0);
    PC_RegCommand("vtp", "vtp", 0);
    PC_RegCommand("coins", "coins", 0);
    PC_RegCommand("comprarvip", "comprarvip", 0);
    PC_RegCommand("setvip", "setvip", 1);
    PC_RegCommand("setcoins", "setcoins", 1);
    
    return 1;
}

public OnFilterScriptExit()
{
    mysql_close(Database);
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
    LoadPlayerVIP(playerid);
    
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    // Salvar dados VIP
    SavePlayerVIP(playerid);
    return 1;
}

// ====================================================================================================
// FUNÇÕES DO SISTEMA VIP
// ====================================================================================================

stock LoadPlayerVIP(playerid)
{
    new query[256], name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    
    mysql_format(Database, query, sizeof(query), 
        "SELECT `vip_level`, `expire_date`, `coins` FROM `vip_players` WHERE `player_name` = '%e'", 
        name
    );
    
    mysql_tquery(Database, query, "OnLoadPlayerVIP", "d", playerid);
    return 1;
}

forward OnLoadPlayerVIP(playerid);
public OnLoadPlayerVIP(playerid)
{
    if (cache_num_rows() > 0)
    {
        PlayerVIP[playerid][vip_Level] = cache_get_value_int(0, "vip_level");
        PlayerVIP[playerid][vip_ExpireDate] = cache_get_value_int(0, "expire_date");
        PlayerVIP[playerid][vip_Coins] = cache_get_value_int(0, "coins");
        
        // Verificar se o VIP expirou
        if (PlayerVIP[playerid][vip_ExpireDate] > 0 && gettime() > PlayerVIP[playerid][vip_ExpireDate])
        {
            PlayerVIP[playerid][vip_Level] = VIP_NONE;
            PlayerVIP[playerid][vip_ExpireDate] = 0;
            SavePlayerVIP(playerid);
            
            SendClientMessage(playerid, COR_ERRO, "❌ Seu VIP expirou! Renove para continuar aproveitando os benefícios.");
        }
        else if (PlayerVIP[playerid][vip_Level] > 0)
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
    else
    {
        // Criar registro para novo jogador
        new query[256], name[MAX_PLAYER_NAME];
        GetPlayerName(playerid, name, sizeof(name));
        
        mysql_format(Database, query, sizeof(query), 
            "INSERT INTO `vip_players` (`player_name`) VALUES ('%e')", 
            name
        );
        mysql_tquery(Database, query);
    }
    
    return 1;
}

stock SavePlayerVIP(playerid)
{
    new query[256], name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    
    mysql_format(Database, query, sizeof(query), 
        "UPDATE `vip_players` SET `vip_level` = %d, `expire_date` = %d, `coins` = %d WHERE `player_name` = '%e'",
        PlayerVIP[playerid][vip_Level],
        PlayerVIP[playerid][vip_ExpireDate],
        PlayerVIP[playerid][vip_Coins],
        name
    );
    
    mysql_tquery(Database, query);
    return 1;
}

stock GetVIPName(level, output[])
{
    switch (level)
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
    switch (level)
    {
        case VIP_BRONZE: return COR_VIP_BRONZE;
        case VIP_SILVER: return COR_VIP_SILVER;
        case VIP_GOLD: return COR_VIP_GOLD;
        default: return 0xFFFFFFFF;
    }
}

stock GetVIPPrice(level)
{
    switch (level)
    {
        case VIP_BRONZE: return PRECO_VIP_BRONZE;
        case VIP_SILVER: return PRECO_VIP_SILVER;
        case VIP_GOLD: return PRECO_VIP_GOLD;
        default: return 0;
    }
}

stock GetVIPCoins(level)
{
    switch (level)
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
    if (!IsPlayerVIP(playerid, min_level))
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
    if (current_time - cooldown_var < cooldown_time)
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

CMD:vip(playerid, const params[])
{
    if (IsPlayerVIP(playerid))
    {
        ShowVIPStatus(playerid);
    }
    else
    {
        ShowVIPPurchase(playerid);
    }
    return 1;
}

CMD:vheal(playerid, const params[])
{
    if (!CanUseVIPCommand(playerid, VIP_BRONZE, PlayerVIP[playerid][vip_LastHeal], COOLDOWN_VHEAL))
        return 1;
        
    SetPlayerHealth(playerid, 100.0);
    SendClientMessage(playerid, COR_SUCESSO, "💚 Sua vida foi restaurada! (Comando VIP)");
    
    return 1;
}

CMD:varmour(playerid, const params[])
{
    if (!CanUseVIPCommand(playerid, VIP_BRONZE, PlayerVIP[playerid][vip_LastArmour], COOLDOWN_VARMOUR))
        return 1;
        
    SetPlayerArmour(playerid, 100.0);
    SendClientMessage(playerid, COR_SUCESSO, "🛡️ Seu colete foi restaurado! (Comando VIP)");
    
    return 1;
}

CMD:vcar(playerid, const params[])
{
    if (!CanUseVIPCommand(playerid, VIP_GOLD, PlayerVIP[playerid][vip_LastCar], COOLDOWN_VCAR))
        return 1;
        
    ShowVIPCarMenu(playerid);
    
    return 1;
}

CMD:vtp(playerid, const params[])
{
    if (!CanUseVIPCommand(playerid, VIP_SILVER, PlayerVIP[playerid][vip_LastTP], COOLDOWN_VTP))
        return 1;
        
    ShowVIPTeleportMenu(playerid);
    
    return 1;
}

CMD:coins(playerid, const params[])
{
    new string[128];
    format(string, sizeof(string), 
        "💰 Você possui {FFD700}%d coins{FFFFFF}. Use /comprarvip para adquirir mais!", 
        PlayerVIP[playerid][vip_Coins]
    );
    SendClientMessage(playerid, COR_INFO, string);
    
    return 1;
}

CMD:comprarvip(playerid, const params[])
{
    ShowVIPPurchase(playerid);
    return 1;
}

// Comandos administrativos
CMD:setvip(playerid, const params[])
{
    if (GetPlayerAdminLevel(playerid) < 3) // Função fictícia
    {
        SendClientMessage(playerid, COR_ERRO, "❌ Você não tem permissão para usar este comando.");
        return 1;
    }
    
    new targetid, level, days;
    if (sscanf(params, "udd", targetid, level, days))
    {
        SendClientMessage(playerid, COR_INFO, "💡 Use: /setvip [id] [level] [dias]");
        SendClientMessage(playerid, COR_INFO, "💡 Levels: 0 = Nenhum, 1 = Bronze, 2 = Silver, 3 = Gold");
        return 1;
    }
    
    if (!IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, COR_ERRO, "❌ Jogador não encontrado.");
        return 1;
    }
    
    if (level < 0 || level > 3)
    {
        SendClientMessage(playerid, COR_ERRO, "❌ Level inválido! Use 0-3.");
        return 1;
    }
    
    PlayerVIP[targetid][vip_Level] = level;
    if (level > 0 && days > 0)
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

CMD:setcoins(playerid, const params[])
{
    if (GetPlayerAdminLevel(playerid) < 3)
    {
        SendClientMessage(playerid, COR_ERRO, "❌ Você não tem permissão para usar este comando.");
        return 1;
    }
    
    new targetid, coins;
    if (sscanf(params, "ud", targetid, coins))
    {
        SendClientMessage(playerid, COR_INFO, "💡 Use: /setcoins [id] [quantidade]");
        return 1;
    }
    
    if (!IsPlayerConnected(targetid))
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
// INTERFACE VIP
// ====================================================================================================

stock ShowVIPStatus(playerid)
{
    new string[1024], vip_name[16];
    GetVIPName(PlayerVIP[playerid][vip_Level], vip_name);
    
    format(string, sizeof(string), 
        "{%06x}⭐ STATUS VIP - %s\n\n", 
        GetVIPColor(PlayerVIP[playerid][vip_Level]) >>> 8, vip_name
    );
    
    strcat(string, "{FFFFFF}📊 {C0C0C0}Informações da sua conta:\n\n");
    
    format(string, sizeof(string), "%s{FFFFFF}💎 Nível VIP: {%06x}%s\n", 
        string, GetVIPColor(PlayerVIP[playerid][vip_Level]) >>> 8, vip_name);
    
    if (PlayerVIP[playerid][vip_ExpireDate] > 0)
    {
        new remaining_days = (PlayerVIP[playerid][vip_ExpireDate] - gettime()) / 86400;
        format(string, sizeof(string), "%s{FFFFFF}⏰ Tempo restante: {4ECDC4}%d dias\n", 
            string, remaining_days);
    }
    else
    {
        strcat(string, "{FFFFFF}⏰ Tempo restante: {4ECDC4}Permanente\n");
    }
    
    format(string, sizeof(string), "%s{FFFFFF}💰 Coins disponíveis: {FFD700}%d\n\n", 
        string, PlayerVIP[playerid][vip_Coins]);
    
    strcat(string, "{C0C0C0}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n");
    strcat(string, "{FFFFFF}🎮 {C0C0C0}Comandos disponíveis:\n\n");
    
    if (PlayerVIP[playerid][vip_Level] >= VIP_BRONZE)
    {
        strcat(string, "{FFFFFF}/vheal {C0C0C0}- Restaurar vida\n");
        strcat(string, "{FFFFFF}/varmour {C0C0C0}- Restaurar colete\n");
    }
    
    if (PlayerVIP[playerid][vip_Level] >= VIP_SILVER)
    {
        strcat(string, "{FFFFFF}/vtp {C0C0C0}- Teleportes VIP\n");
    }
    
    if (PlayerVIP[playerid][vip_Level] >= VIP_GOLD)
    {
        strcat(string, "{FFFFFF}/vcar {C0C0C0}- Veículos VIP\n");
    }
    
    strcat(string, "\n{95E1D3}💡 {C0C0C0}Use /comprarvip para renovar ou fazer upgrade!");
    
    MostrarMensagem(playerid, "⭐ Status VIP", string);
    
    return 1;
}

stock ShowVIPPurchase(playerid)
{
    Dialog_VIP(playerid);
    return 1;
}

stock ShowVIPCarMenu(playerid)
{
    new string[512];
    
    strcat(string, "{FFD700}🚗 VEÍCULOS VIP - Gold\n\n");
    strcat(string, "{FFFFFF}Selecione um veículo para spawnar:\n\n");
    strcat(string, "🏎️ Infernus (Esportivo)\n");
    strcat(string, "🚙 Rancher (SUV)\n");
    strcat(string, "🏍️ NRG-500 (Moto)\n");
    strcat(string, "🚗 Sultan (Sedan)\n");
    strcat(string, "🚚 Monster (Caminhão)\n");
    strcat(string, "✈️ Shamal (Avião)\n");
    strcat(string, "🚁 Maverick (Helicóptero)\n");
    strcat(string, "⛵ Reefer (Lancha)");
    
    MostrarLista(playerid, "🚗 Veículos VIP", string, "Spawnar", "Cancelar", "OnVIPCarDialog");
    
    return 1;
}

stock ShowVIPTeleportMenu(playerid)
{
    new string[512];
    
    strcat(string, "{C0C0C0}🌟 TELEPORTES VIP - Silver+\n\n");
    strcat(string, "{FFFFFF}Locais exclusivos para VIPs:\n\n");
    strcat(string, "🏖️ Praia VIP (Copacabana)\n");
    strcat(string, "🏢 Cobertura VIP (Ipanema)\n");
    strcat(string, "🎰 Cassino VIP (Barra)\n");
    strcat(string, "🏁 Pista de Corrida VIP\n");
    strcat(string, "🛩️ Aeroporto VIP\n");
    strcat(string, "🏝️ Ilha Particular VIP\n");
    strcat(string, "🏰 Mansão VIP (São Conrado)\n");
    strcat(string, "🎪 Área de Eventos VIP");
    
    MostrarLista(playerid, "🌟 Teleportes VIP", string, "Teleportar", "Cancelar", "OnVIPTPDialog");
    
    return 1;
}

// ====================================================================================================
// HANDLERS DE DIÁLOGOS
// ====================================================================================================

forward OnVIPCarDialog(playerid, response, listitem, const inputtext[]);
public OnVIPCarDialog(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;
    
    new vehicleid, Float:x, Float:y, Float:z, Float:angle;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, angle);
    
    new model_ids[] = {411, 489, 522, 560, 444, 519, 487, 453};
    new vehicle_names[][] = 
    {
        "Infernus", "Rancher", "NRG-500", "Sultan", 
        "Monster", "Shamal", "Maverick", "Reefer"
    };
    
    if (listitem < 0 || listitem >= sizeof(model_ids)) return 1;
    
    vehicleid = CreateVehicle(model_ids[listitem], x + 3, y, z, angle, -1, -1, 300);
    PutPlayerInVehicle(playerid, vehicleid, 0);
    
    new string[128];
    format(string, sizeof(string), 
        "🚗 Veículo VIP %s spawnado! Aproveite!", 
        vehicle_names[listitem]
    );
    SendClientMessage(playerid, COR_SUCESSO, string);
    
    return 1;
}

forward OnVIPTPDialog(playerid, response, listitem, const inputtext[]);
public OnVIPTPDialog(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;
    
    new Float:positions[][4] = 
    {
        {-2662.9, 1426.8, 7.1, 90.0},     // Praia VIP
        {-2897.2, 1224.1, 37.3, 270.0},   // Cobertura VIP
        {2197.7, 1677.1, 12.4, 0.0},      // Cassino VIP
        {-1404.9, 1264.1, 10.0, 180.0},   // Pista VIP
        {1958.2, -2181.6, 13.5, 90.0},    // Aeroporto VIP
        {3434.5, -1975.8, 7.5, 0.0},      // Ilha VIP
        {-2555.8, 193.1, 6.2, 270.0},     // Mansão VIP
        {1245.8, 245.2, 19.6, 45.0}       // Eventos VIP
    };
    
    new location_names[][] = 
    {
        "Praia VIP", "Cobertura VIP", "Cassino VIP", "Pista de Corrida VIP",
        "Aeroporto VIP", "Ilha Particular VIP", "Mansão VIP", "Área de Eventos VIP"
    };
    
    if (listitem < 0 || listitem >= sizeof(positions)) return 1;
    
    SetPlayerPos(playerid, positions[listitem][0], positions[listitem][1], positions[listitem][2]);
    SetPlayerFacingAngle(playerid, positions[listitem][3]);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    
    new string[128];
    format(string, sizeof(string), 
        "🌟 Teleportado para %s! Bem-vindo à área VIP!", 
        location_names[listitem]
    );
    SendClientMessage(playerid, COR_SUCESSO, string);
    
    return 1;
}

// ====================================================================================================
// SISTEMA DE RENOVAÇÃO AUTOMÁTICA
// ====================================================================================================

public OnGameModeInit()
{
    // Timer para verificar VIPs expirados (a cada hora)
    SetTimer("CheckExpiredVIPs", 3600000, true);
    
    // Timer para dar coins mensais (a cada 24 horas)
    SetTimer("GiveMonthlyCoins", 86400000, true);
    
    return 1;
}

forward CheckExpiredVIPs();
public CheckExpiredVIPs()
{
    new query[128];
    format(query, sizeof(query), 
        "UPDATE `vip_players` SET `vip_level` = 0 WHERE `expire_date` > 0 AND `expire_date` <= %d", 
        gettime()
    );
    mysql_tquery(Database, query);
    
    return 1;
}

forward GiveMonthlyCoins();
public GiveMonthlyCoins()
{
    foreach (new playerid : Player)
    {
        if (IsPlayerVIP(playerid))
        {
            new coins_to_give = GetVIPCoins(PlayerVIP[playerid][vip_Level]);
            PlayerVIP[playerid][vip_Coins] += coins_to_give;
            SavePlayerVIP(playerid);
            
            new string[128];
            format(string, sizeof(string), 
                "💰 Você recebeu %d coins mensais do seu VIP! Total: %d coins", 
                coins_to_give, PlayerVIP[playerid][vip_Coins]
            );
            SendClientMessage(playerid, COR_SUCESSO, string);
        }
    }
    
    return 1;
}

// ====================================================================================================
// FUNÇÕES AUXILIARES
// ====================================================================================================

stock GetPlayerAdminLevel(playerid)
{
    // Esta função deve ser implementada no gamemode principal
    // Retorna o nível de admin do jogador
    return 0;
}

#if !defined foreach
    #define foreach(%1:%2) for(%2 = 0; %2 < MAX_PLAYERS; %2++) if(IsPlayerConnected(%2))
    #define Player playerid
#endif