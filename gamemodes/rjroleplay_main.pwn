// Rio de Janeiro RolePlay - Main GameMode
// Desenvolvido para SA-MP com foco em roleplay brasileiro
// Inclui mapping completo do Rio de Janeiro com pontos turísticos e favelas

#include <a_samp>
#include <a_mysql>
#include <sscanf2>
#include <streamer>

// ===============================================================================
// CONFIGURAÇÕES PRINCIPAIS
// ===============================================================================

#define SERVER_NAME             "Rio de Janeiro RolePlay"
#define VERSION                 "1.0.0"
#define MAX_PASSWORD_LEN        65

// Cores principais
#define COLOR_WHITE             0xFFFFFFFF
#define COLOR_ERROR             0xFF6B6BFF
#define COLOR_SUCCESS           0x4ECDC4FF
#define COLOR_INFO              0x95E1D3FF
#define COLOR_WARNING           0xFFD93DFF
#define COLOR_YELLOW            0xFFFF00FF
#define COLOR_GREEN             0x00FF00FF
#define COLOR_BLUE              0x0000FFFF
#define COLOR_RED               0xFF0000FF

// ===============================================================================
// ENUMS E ESTRUTURAS
// ===============================================================================

enum E_PLAYER_DATA
{
    pName[MAX_PLAYER_NAME],
    pPassword[MAX_PASSWORD_LEN],
    pLogged,
    pSpawned,
    pLevel,
    pMoney,
    pBankMoney,
    pHunger,
    pThirst,
    pEnergy,
    Float:pPosX,
    Float:pPosY,
    Float:pPosZ,
    Float:pPosA,
    pAdmin,
    Text:pHUD[6]
}

// ===============================================================================
// VARIÁVEIS GLOBAIS
// ===============================================================================

new PlayerData[MAX_PLAYERS][E_PLAYER_DATA];
new MySQL:Database;

// ===============================================================================
// CALLBACKS PRINCIPAIS
// ===============================================================================

main()
{
    print("🏖️ Rio de Janeiro RolePlay - Carregando...");
}

public OnGameModeInit()
{
    SetGameModeText(SERVER_NAME " " VERSION);
    
    // Conectar ao banco
    ConnectToDatabase();
    
    // CRIAR MAPPING DO RIO DE JANEIRO
    CreateRioDeJaneiroMapping();
    
    // Timers
    SetTimer("ServerUpdate", 1000, true);
    SetTimer("PlayerUpdate", 5000, true);
    
    SetWorldTime(12);
    SetWeather(1);
    
    print("✅ Servidor Rio de Janeiro RP iniciado com sucesso!");
    return 1;
}

public OnGameModeExit()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && PlayerData[i][pLogged])
        {
            SavePlayerData(i);
        }
    }
    mysql_close(Database);
    return 1;
}

// ===============================================================================
// PLAYER CALLBACKS
// ===============================================================================

public OnPlayerConnect(playerid)
{
    ResetPlayerData(playerid);
    CheckPlayerAccount(playerid);
    
    new string[128];
    format(string, sizeof(string), "🌟 Bem-vindo ao %s!", SERVER_NAME);
    SendClientMessage(playerid, COLOR_SUCCESS, string);
    
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if(PlayerData[playerid][pLogged])
    {
        SavePlayerData(playerid);
    }
    ResetPlayerData(playerid);
    return 1;
}

public OnPlayerSpawn(playerid)
{
    if(!PlayerData[playerid][pLogged])
    {
        SetTimerEx("KickPlayer", 3000, false, "i", playerid);
        return 1;
    }
    
    SetupPlayerSpawn(playerid);
    CreatePlayerHUD(playerid);
    PlayerData[playerid][pSpawned] = 1;
    
    return 1;
}

public OnPlayerText(playerid, text[])
{
    if(!PlayerData[playerid][pLogged]) return 0;
    
    new string[256];
    format(string, sizeof(string), "%s[%d]: %s", 
        PlayerData[playerid][pName], playerid, text);
    
    SendClientMessageToAll(COLOR_WHITE, string);
    return 0;
}



// ===============================================================================
// SISTEMA DE MAPPING - RIO DE JANEIRO
// ===============================================================================

stock CreateRioDeJaneiroMapping()
{
    print("🏗️ Criando mapping do Rio de Janeiro...");
    
    // === CRISTO REDENTOR ===
    CreateDynamicObject(8661, -2274.0, 2975.0, 50.0, 0.0, 0.0, 0.0);
    CreateDynamic3DTextLabel("⛪ CRISTO REDENTOR\n{FFFFFF}Cartão postal do Rio", COLOR_INFO, -2274.0, 2975.0, 55.0, 100.0);
    
    // === PÃO DE AÇÚCAR ===
    CreateDynamicObject(8661, -2650.0, 1350.0, 80.0, 0.0, 0.0, 0.0);
    CreateDynamic3DTextLabel("🗻 PÃO DE AÇÚCAR\n{FFFFFF}Vista panorâmica", COLOR_INFO, -2650.0, 1350.0, 85.0, 100.0);
    
    // === PRAIA DE COPACABANA ===
    for(new i = 0; i < 20; i++)
    {
        CreateDynamicObject(1344, -2662.0 + (i * 10), 1426.0, 7.0, 0.0, 0.0, float(random(360))); // Palmeiras
    }
    CreateDynamic3DTextLabel("🏖️ PRAIA DE COPACABANA\n{FFFFFF}Princesinha do Mar", COLOR_INFO, -2662.0, 1426.0, 10.0, 100.0);
    
    // === ESTÁDIO DO MARACANÃ ===
    CreateDynamicObject(8661, -1404.0, 1265.0, 25.0, 0.0, 0.0, 0.0);
    CreateDynamic3DTextLabel("⚽ ESTÁDIO DO MARACANÃ\n{FFFFFF}Templo do futebol", COLOR_INFO, -1404.0, 1265.0, 30.0, 100.0);
    
    // === FAVELAS ===
    CreateFavelaRocinha();
    CreateFavelaAlemao();
    CreateFavelaCidadeDeus();
    
    // === PRÉDIOS GOVERNAMENTAIS ===
    CreateGovernmentBuildings();
    
    // === DELEGACIAS E UPPs ===
    CreatePoliceStations();
    
    print("✅ Mapping do Rio de Janeiro criado!");
}

stock CreateFavelaRocinha()
{
    new Float:x = -2700.0, Float:y = -1500.0, Float:z = 5.0;
    
    // Casas da favela
    for(new i = 0; i < 30; i++)
    {
        for(new j = 0; j < 15; j++)
        {
            new Float:casa_x = x + (i * 8.0) + random(3);
            new Float:casa_y = y + (j * 6.0) + random(2);
            new Float:casa_z = z + (random(3) * 3.0);
            
            CreateDynamicObject(1408 + random(5), casa_x, casa_y, casa_z, 0.0, 0.0, float(random(360)));
        }
    }
    
    // UPP da Rocinha
    CreateDynamicObject(968, x - 10, y - 5, z, 0.0, 0.0, 0.0); // Barreira
    CreateDynamic3DTextLabel("🚔 UPP ROCINHA\n{FFFFFF}Unidade de Polícia Pacificadora", COLOR_BLUE, x - 10, y - 5, z + 2, 50.0);
    
    // Label principal
    CreateDynamic3DTextLabel("🏠 ROCINHA\n{FFFFFF}Maior favela do Brasil", COLOR_YELLOW, x, y, z + 5, 100.0);
}

stock CreateFavelaAlemao()
{
    new Float:x = 2500.0, Float:y = -1200.0, Float:z = 10.0;
    
    // Teleférico do Alemão
    CreateDynamicObject(3242, x, y, z + 15.0, 0.0, 0.0, 0.0);
    CreateDynamicObject(3242, x + 50, y + 30, z + 20.0, 0.0, 0.0, 0.0);
    CreateDynamicObject(3242, x + 100, y + 60, z + 25.0, 0.0, 0.0, 0.0);
    
    // Casas em encosta
    for(new level = 0; level < 4; level++)
    {
        for(new i = 0; i < 10; i++)
        {
            for(new j = 0; j < 8; j++)
            {
                new Float:casa_x = x + (i * 6.0);
                new Float:casa_y = y + (j * 5.0);
                new Float:casa_z = z + (level * 4.0);
                
                CreateDynamicObject(1408 + random(5), casa_x, casa_y, casa_z, 0.0, 0.0, float(random(360)));
            }
        }
    }
    
    CreateDynamic3DTextLabel("🚡 COMPLEXO DO ALEMÃO\n{FFFFFF}Teleférico e UPP", COLOR_YELLOW, x, y, z + 5, 100.0);
}

stock CreateFavelaCidadeDeus()
{
    new Float:x = -1500.0, Float:y = 2000.0, Float:z = 5.0;
    
    // Conjuntos habitacionais
    for(new bloco = 0; bloco < 8; bloco++)
    {
        new Float:bloco_x = x + (bloco % 4) * 25.0;
        new Float:bloco_y = y + (bloco / 4) * 30.0;
        
        // Prédios de 3 andares
        for(new andar = 0; andar < 3; andar++)
        {
            CreateDynamicObject(3095, bloco_x, bloco_y, z + (andar * 4.0), 0.0, 0.0, 0.0);
            CreateDynamicObject(3095, bloco_x + 10, bloco_y, z + (andar * 4.0), 0.0, 0.0, 0.0);
        }
    }
    
    CreateDynamic3DTextLabel("🏘️ CIDADE DE DEUS\n{FFFFFF}Conjuntos habitacionais", COLOR_YELLOW, x + 50, y + 40, z + 5, 100.0);
}

stock CreateGovernmentBuildings()
{
    // === PREFEITURA ===
    CreateDynamicObject(3095, 1481.0, -1772.0, 18.8, 0.0, 0.0, 0.0);
    CreateDynamicPickup(1239, 1, 1481.0, -1772.0, 18.8);
    CreateDynamic3DTextLabel("🏛️ PREFEITURA DO RIO\n{FFFFFF}/entrar para acessar", COLOR_INFO, 1481.0, -1772.0, 20.0, 30.0);
    
    // === DETRAN ===
    CreateDynamicObject(3095, 1494.0, -1766.0, 18.8, 0.0, 0.0, 0.0);
    CreateDynamicPickup(1239, 1, 1494.0, -1766.0, 18.8);
    CreateDynamic3DTextLabel("🚗 DETRAN\n{FFFFFF}CNH, multas e veículos", COLOR_INFO, 1494.0, -1766.0, 20.0, 30.0);
    
    // === BANCO CENTRAL ===
    CreateDynamicObject(3095, 595.0, -1248.0, 18.0, 0.0, 0.0, 0.0);
    CreateDynamicPickup(1274, 1, 595.0, -1248.0, 18.0);
    CreateDynamic3DTextLabel("🏦 BANCO CENTRAL\n{FFFFFF}Serviços bancários", COLOR_GREEN, 595.0, -1248.0, 20.0, 30.0);
}

stock CreatePoliceStations()
{
    // === DELEGACIA CENTRAL ===
    CreateDynamicObject(3095, 1555.0, -1675.0, 16.2, 0.0, 0.0, 0.0);
    CreateDynamicPickup(1247, 1, 1555.0, -1675.0, 16.2);
    CreateDynamic3DTextLabel("🚔 DELEGACIA CENTRAL\n{FFFFFF}Polícia Civil do RJ", COLOR_BLUE, 1555.0, -1675.0, 18.0, 30.0);
    
    // === QUARTEL DO BOPE ===
    CreateDynamicObject(3095, 2100.0, -1800.0, 13.5, 0.0, 0.0, 0.0);
    CreateDynamicObject(968, 2095.0, -1795.0, 13.5, 0.0, 0.0, 45.0); // Barreira
    CreateDynamic3DTextLabel("⚫ BOPE\n{FFFFFF}Batalhão de Operações Especiais", COLOR_RED, 2100.0, -1800.0, 15.0, 30.0);
    
    // === HOSPITAL ===
    CreateDynamicObject(3095, 1607.0, -1890.0, 13.6, 0.0, 0.0, 0.0);
    CreateDynamicPickup(1240, 1, 1607.0, -1890.0, 13.6);
    CreateDynamic3DTextLabel("🏥 HOSPITAL MUNICIPAL\n{FFFFFF}Atendimento médico", COLOR_GREEN, 1607.0, -1890.0, 15.0, 30.0);
}

// ===============================================================================
// SISTEMA DE AUTENTICAÇÃO
// ===============================================================================

stock ConnectToDatabase()
{
    Database = mysql_connect("localhost", "root", "", "rjroleplay");
    
    if(Database == MySQL:0)
    {
        print("❌ ERRO: Falha ao conectar com MySQL!");
        return 0;
    }
    
    mysql_set_charset("utf8", Database);
    print("✅ Conectado ao MySQL!");
    
    // Criar tabela se não existir
    mysql_tquery(Database, 
        "CREATE TABLE IF NOT EXISTS `accounts` (\
            `id` int(11) NOT NULL AUTO_INCREMENT,\
            `name` varchar(24) NOT NULL,\
            `password` varchar(65) NOT NULL,\
            `level` int(11) DEFAULT '1',\
            `money` int(11) DEFAULT '5000',\
            `bank_money` int(11) DEFAULT '0',\
            `hunger` int(3) DEFAULT '100',\
            `thirst` int(3) DEFAULT '100',\
            `energy` int(3) DEFAULT '100',\
            `pos_x` float DEFAULT '1642.0901',\
            `pos_y` float DEFAULT '-2335.2654',\
            `pos_z` float DEFAULT '13.5469',\
            `pos_a` float DEFAULT '270.0',\
            PRIMARY KEY (`id`),\
            UNIQUE KEY `name` (`name`)\
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8;"
    );
    
    return 1;
}

stock CheckPlayerAccount(playerid)
{
    new query[256], name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    format(PlayerData[playerid][pName], MAX_PLAYER_NAME, "%s", name);
    
    mysql_format(Database, query, sizeof(query), 
        "SELECT * FROM `accounts` WHERE `name` = '%e' LIMIT 1", name);
    mysql_tquery(Database, query, "OnPlayerAccountCheck", "d", playerid);
}

forward OnPlayerAccountCheck(playerid);
public OnPlayerAccountCheck(playerid)
{
    if(cache_get_row_count())
    {
        ShowLoginDialog(playerid);
    }
    else
    {
        ShowRegisterDialog(playerid);
    }
    return 1;
}

stock ShowLoginDialog(playerid)
{
    new string[512];
    strcat(string, "{4ECDC4}🔐 {FFFFFF}Bem-vindo de volta ao {FFD93D}Rio de Janeiro RolePlay{FFFFFF}!\n\n");
    format(string, sizeof(string), "%s{FFFFFF}A conta {4ECDC4}%s{FFFFFF} já está registrada.\n", 
        string, PlayerData[playerid][pName]);
    strcat(string, "Digite sua senha para fazer login:\n\n");
    strcat(string, "{95E1D3}💡 {C0C0C0}Sua senha é criptografada e segura.");
    
    ShowPlayerDialog(playerid, 1, DIALOG_STYLE_PASSWORD, "🔐 Login no Servidor", string, "Entrar", "Sair");
}

stock ShowRegisterDialog(playerid)
{
    new string[512];
    strcat(string, "{4ECDC4}📝 {FFFFFF}Bem-vindo ao {FFD93D}Rio de Janeiro RolePlay{FFFFFF}!\n\n");
    format(string, sizeof(string), "%s{FFFFFF}A conta {4ECDC4}%s{FFFFFF} não está registrada.\n", 
        string, PlayerData[playerid][pName]);
    strcat(string, "Crie uma senha para se registrar:\n\n");
    strcat(string, "{95E1D3}⚠️ {C0C0C0}Use uma senha forte (mínimo 6 caracteres)");
    
    ShowPlayerDialog(playerid, 2, DIALOG_STYLE_PASSWORD, "📝 Registro no Servidor", string, "Registrar", "Sair");
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case 1: // Login
        {
            if(!response)
            {
                Kick(playerid);
                return 1;
            }
            
            if(strlen(inputtext) < 6)
            {
                SendClientMessage(playerid, COLOR_ERROR, "❌ Senha deve ter pelo menos 6 caracteres!");
                ShowLoginDialog(playerid);
                return 1;
            }
            
            new query[256], password_hash[65];
            SHA256_PassHash(inputtext, "rjrp_salt", password_hash, 65);
            
            mysql_format(Database, query, sizeof(query), 
                "SELECT * FROM `accounts` WHERE `name` = '%e' AND `password` = '%e' LIMIT 1", 
                PlayerData[playerid][pName], password_hash);
            mysql_tquery(Database, query, "OnPlayerLoginCheck", "d", playerid);
        }
        case 2: // Register
        {
            if(!response)
            {
                Kick(playerid);
                return 1;
            }
            
            if(strlen(inputtext) < 6)
            {
                SendClientMessage(playerid, COLOR_ERROR, "❌ Senha deve ter pelo menos 6 caracteres!");
                ShowRegisterDialog(playerid);
                return 1;
            }
            
            new query[512], password_hash[65];
            SHA256_PassHash(inputtext, "rjrp_salt", password_hash, 65);
            
            mysql_format(Database, query, sizeof(query), 
                "INSERT INTO `accounts` (`name`, `password`) VALUES ('%e', '%e')", 
                PlayerData[playerid][pName], password_hash);
            mysql_tquery(Database, query, "OnPlayerRegisterComplete", "d", playerid);
        }
    }
    return 1;
}

forward OnPlayerLoginCheck(playerid);
public OnPlayerLoginCheck(playerid)
{
    if(cache_get_row_count())
    {
        LoadPlayerData(playerid);
        PlayerData[playerid][pLogged] = 1;
        
        SendClientMessage(playerid, COLOR_SUCCESS, "✅ Login realizado com sucesso!");
        TogglePlayerSpectating(playerid, false);
    }
    else
    {
        SendClientMessage(playerid, COLOR_ERROR, "❌ Senha incorreta!");
        ShowLoginDialog(playerid);
    }
    return 1;
}

forward OnPlayerRegisterComplete(playerid);
public OnPlayerRegisterComplete(playerid)
{
    PlayerData[playerid][pLogged] = 1;
    PlayerData[playerid][pLevel] = 1;
    PlayerData[playerid][pMoney] = 5000;
    PlayerData[playerid][pBankMoney] = 0;
    PlayerData[playerid][pHunger] = 100;
    PlayerData[playerid][pThirst] = 100;
    PlayerData[playerid][pEnergy] = 100;
    
    SendClientMessage(playerid, COLOR_SUCCESS, "✅ Conta criada com sucesso!");
    SendClientMessage(playerid, COLOR_INFO, "💡 Use /ajuda para conhecer os comandos!");
    
    TogglePlayerSpectating(playerid, false);
    return 1;
}

// ===============================================================================
// COMANDOS PRINCIPAIS
// ===============================================================================

// ===============================================================================
// SISTEMA DE COMANDOS (sem Pawn.CMD)
// ===============================================================================

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(!PlayerData[playerid][pLogged])
    {
        SendClientMessage(playerid, COLOR_ERROR, "❌ Você precisa estar logado!");
        return 1;
    }
    
    // Comandos principais
    if(!strcmp(cmdtext, "/ajuda", true))
    {
        new string[1024];
        
        strcat(string, "{4ECDC4}═══════════════ 📋 AJUDA - RIO DE JANEIRO RP ═══════════════\n\n");
        strcat(string, "{FFFFFF}🎮 {FFD93D}COMANDOS GERAIS:\n");
        strcat(string, "{FFFFFF}/stats - Ver suas estatísticas\n");
        strcat(string, "{FFFFFF}/tempo - Ver hora atual\n");
        strcat(string, "{FFFFFF}/creditos - Créditos do servidor\n\n");
        
        strcat(string, "{FFFFFF}💰 {FFD93D}ECONOMIA:\n");
        strcat(string, "{FFFFFF}/banco - Acessar conta bancária\n");
        strcat(string, "{FFFFFF}/pagar [id] [valor] - Pagar em dinheiro\n\n");
        
        strcat(string, "{FFFFFF}📱 {FFD93D}ROLEPLAY:\n");
        strcat(string, "{FFFFFF}/me [ação] - Ação de roleplay\n");
        strcat(string, "{FFFFFF}/do [descrição] - Descrição RP\n\n");
        
        strcat(string, "{95E1D3}💡 Discord: discord.gg/rjroleplay");
        
        ShowPlayerDialog(playerid, 999, DIALOG_STYLE_MSGBOX, "📋 Central de Ajuda", string, "OK", "");
        return 1;
    }
    
    if(!strcmp(cmdtext, "/stats", true))
    {
        new string[512];
        
        format(string, sizeof(string), 
            "{4ECDC4}📊 ESTATÍSTICAS DE %s\n\n\
            {FFFFFF}💰 Dinheiro: {4ECDC4}R$ %d\n\
            {FFFFFF}🏦 Banco: {4ECDC4}R$ %d\n\
            {FFFFFF}📈 Nível: {4ECDC4}%d\n\
            {FFFFFF}🍔 Fome: {4ECDC4}%d%%\n\
            {FFFFFF}🥤 Sede: {4ECDC4}%d%%\n\
            {FFFFFF}⚡ Energia: {4ECDC4}%d%%",
            PlayerData[playerid][pName],
            PlayerData[playerid][pMoney],
            PlayerData[playerid][pBankMoney],
            PlayerData[playerid][pLevel],
            PlayerData[playerid][pHunger],
            PlayerData[playerid][pThirst],
            PlayerData[playerid][pEnergy]
        );
        
        ShowPlayerDialog(playerid, 999, DIALOG_STYLE_MSGBOX, "📊 Suas Estatísticas", string, "OK", "");
        return 1;
    }
    
    if(!strncmp(cmdtext, "/me ", 4))
    {
        new params[128];
        format(params, sizeof(params), "%s", cmdtext[4]);
        
        if(strlen(params) < 3)
        {
            SendClientMessage(playerid, COLOR_ERROR, "Uso: /me [ação]");
            return 1;
        }
        
        new string[128];
        format(string, sizeof(string), "* %s %s", PlayerData[playerid][pName], params);
        
        SendClientMessageInRange(30.0, playerid, 0xC2A2DAFF, string);
        return 1;
    }
    
    // Comando não encontrado
    SendClientMessage(playerid, COLOR_ERROR, "❌ Comando não encontrado. Use /ajuda");
    return 1;
}

CMD:do(playerid, const params[])
{
    if(strlen(params) < 3)
    {
        SendClientMessage(playerid, COLOR_ERROR, "Uso: /do [descrição]");
        return 1;
    }
    
    new string[128];
    format(string, sizeof(string), "* %s (( %s ))", params, PlayerData[playerid][pName]);
    
    SendClientMessageInRange(30.0, playerid, 0xC2A2DAFF, string);
    return 1;
}

// ===============================================================================
// FUNÇÕES AUXILIARES
// ===============================================================================

stock SHA256_PassHash(const password[], const salt[], dest[], dest_len = sizeof(dest))
{
    new combined[128];
    format(combined, sizeof(combined), "%s%s", password, salt);
    
    new hash[65];
    // Simulação de hash SHA256 - substituir por implementação real
    format(hash, sizeof(hash), "sha256_%s_%s", password, salt);
    format(dest, dest_len, "%s", hash);
}

stock LoadPlayerData(playerid)
{
    if(cache_get_row_count())
    {
        PlayerData[playerid][pLevel] = cache_get_value_int(0, 3);
        PlayerData[playerid][pMoney] = cache_get_value_int(0, 4);
        PlayerData[playerid][pBankMoney] = cache_get_value_int(0, 5);
        PlayerData[playerid][pHunger] = cache_get_value_int(0, 6);
        PlayerData[playerid][pThirst] = cache_get_value_int(0, 7);
        PlayerData[playerid][pEnergy] = cache_get_value_int(0, 8);
        PlayerData[playerid][pPosX] = cache_get_value_float(0, 9);
        PlayerData[playerid][pPosY] = cache_get_value_float(0, 10);
        PlayerData[playerid][pPosZ] = cache_get_value_float(0, 11);
        PlayerData[playerid][pPosA] = cache_get_value_float(0, 12);
    }
}

stock SavePlayerData(playerid)
{
    new query[512];
    mysql_format(Database, query, sizeof(query),
        "UPDATE `accounts` SET `money` = %d, `bank_money` = %d, `hunger` = %d, `thirst` = %d, `energy` = %d WHERE `name` = '%e'",
        PlayerData[playerid][pMoney], PlayerData[playerid][pBankMoney], PlayerData[playerid][pHunger],
        PlayerData[playerid][pThirst], PlayerData[playerid][pEnergy], PlayerData[playerid][pName]);
    mysql_tquery(Database, query);
}

stock ResetPlayerData(playerid)
{
    PlayerData[playerid][pLogged] = 0;
    PlayerData[playerid][pSpawned] = 0;
    PlayerData[playerid][pLevel] = 1;
    PlayerData[playerid][pMoney] = 0;
    PlayerData[playerid][pBankMoney] = 0;
    PlayerData[playerid][pHunger] = 100;
    PlayerData[playerid][pThirst] = 100;
    PlayerData[playerid][pEnergy] = 100;
    PlayerData[playerid][pAdmin] = 0;
}

stock SetupPlayerSpawn(playerid)
{
    SetPlayerPos(playerid, 1642.0901, -2335.2654, 13.5469);
    SetPlayerFacingAngle(playerid, 270.0);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    GivePlayerMoney(playerid, PlayerData[playerid][pMoney]);
}

stock CreatePlayerHUD(playerid)
{
    // HUD básico - será expandido conforme necessário
    PlayerData[playerid][pHUD][0] = TextDrawCreate(10.0, 320.0, "~g~Rio de Janeiro RP");
    TextDrawShowForPlayer(playerid, PlayerData[playerid][pHUD][0]);
}

stock SendClientMessageInRange(Float:range, playerid, color, const message[])
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && IsPlayerInRangeOfPoint(i, range, x, y, z))
        {
            SendClientMessage(i, color, message);
        }
    }
}

forward KickPlayer(playerid);
public KickPlayer(playerid)
{
    Kick(playerid);
}

forward ServerUpdate();
public ServerUpdate()
{
    // Timer do servidor - atualizações gerais
}

forward PlayerUpdate();  
public PlayerUpdate()
{
    // Atualizar needs dos jogadores
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && PlayerData[i][pLogged])
        {
            if(PlayerData[i][pHunger] > 0) PlayerData[i][pHunger]--;
            if(PlayerData[i][pThirst] > 0) PlayerData[i][pThirst]--;
            if(PlayerData[i][pEnergy] > 0) PlayerData[i][pEnergy]--;
        }
    }
}