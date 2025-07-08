/*
 * Pawn.CMD - Command processor for SA-MP
 * Modern and fast command system
 * Version: 3.3.0+
 */

#if defined _pawncmd_included
    #endinput
#endif
#define _pawncmd_included

// Command callback format
#define CMD:%1(%2) \
    forward cmd_%1(%2); \
    public cmd_%1(%2)

#define cmd(%1) \
    CMD:%1(playerid, const params[])

#define PC_EmulateCommand(%0) \
    SetPlayerChatInputText(%0, "")

// Command aliases
#define PCMD:%1(%2) \
    CMD:%1(%2)

#define command(%1) \
    CMD:%1(playerid, const params[])

// Error constants
#define COMMAND_OK (1)
#define COMMAND_ERROR (-1)
#define COMMAND_UNKNOWN (-2)
#define COMMAND_NO_ACCESS (-3)

// Brazilian command helpers
#define COMANDO:%1(%2) \
    CMD:%1(%2)

// Performance settings
#define PC_MAX_COMMANDS 512
#define PC_MAX_COMMAND_LENGTH 32

// Command storage
enum E_COMMAND_DATA
{
    cmd_name[PC_MAX_COMMAND_LENGTH],
    cmd_function[PC_MAX_COMMAND_LENGTH + 4],
    cmd_level,
    cmd_enabled
}

static CommandData[PC_MAX_COMMANDS][E_COMMAND_DATA];
static CommandCount = 0;

// Register a command
stock PC_RegCommand(const cmdname[], const function[], level = 0)
{
    if (CommandCount >= PC_MAX_COMMANDS) return 0;
    
    format(CommandData[CommandCount][cmd_name], PC_MAX_COMMAND_LENGTH, "%s", cmdname);
    format(CommandData[CommandCount][cmd_function], PC_MAX_COMMAND_LENGTH + 4, "cmd_%s", function);
    CommandData[CommandCount][cmd_level] = level;
    CommandData[CommandCount][cmd_enabled] = 1;
    
    CommandCount++;
    return 1;
}

// Brazilian command registration
stock PC_RegistrarComando(const comando[], const funcao[], nivel = 0)
{
    return PC_RegCommand(comando, funcao, nivel);
}

// Enable/disable commands
stock PC_EnableCommand(const cmdname[], bool:enable = true)
{
    for (new i = 0; i < CommandCount; i++)
    {
        if (!strcmp(CommandData[i][cmd_name], cmdname, true))
        {
            CommandData[i][cmd_enabled] = enable ? 1 : 0;
            return 1;
        }
    }
    return 0;
}

// Set command level
stock PC_SetCommandLevel(const cmdname[], level)
{
    for (new i = 0; i < CommandCount; i++)
    {
        if (!strcmp(CommandData[i][cmd_name], cmdname, true))
        {
            CommandData[i][cmd_level] = level;
            return 1;
        }
    }
    return 0;
}

// Check if player can use command
stock PC_HasAccess(playerid, const cmdname[])
{
    // Get player level (this would be implemented based on your system)
    new player_level = 0; // GetPlayerAdminLevel(playerid);
    
    for (new i = 0; i < CommandCount; i++)
    {
        if (!strcmp(CommandData[i][cmd_name], cmdname, true))
        {
            return (player_level >= CommandData[i][cmd_level] && CommandData[i][cmd_enabled]);
        }
    }
    return 0;
}

// Command processor (call this in OnPlayerCommandText)
stock PC_ProcessCommand(playerid, const cmdtext[])
{
    new cmd[32], params[128];
    new pos = strfind(cmdtext, " ");
    
    if (pos == -1)
    {
        strmid(cmd, cmdtext, 1, strlen(cmdtext));
        params[0] = EOS;
    }
    else
    {
        strmid(cmd, cmdtext, 1, pos);
        strmid(params, cmdtext, pos + 1, strlen(cmdtext));
    }
    
    // Check if command exists and player has access
    for (new i = 0; i < CommandCount; i++)
    {
        if (!strcmp(CommandData[i][cmd_name], cmd, true))
        {
            if (!CommandData[i][cmd_enabled])
            {
                SendClientMessage(playerid, 0xFF6B6BFF, "❌ Este comando está temporariamente desabilitado.");
                return COMMAND_ERROR;
            }
            
            if (!PC_HasAccess(playerid, cmd))
            {
                SendClientMessage(playerid, 0xFF6B6BFF, "❌ Você não tem permissão para usar este comando.");
                return COMMAND_NO_ACCESS;
            }
            
            // Call the command function
            CallLocalFunction(CommandData[i][cmd_function], "ds", playerid, params);
            return COMMAND_OK;
        }
    }
    
    return COMMAND_UNKNOWN;
}

// Brazilian command processor
stock PC_ProcessarComando(playerid, const texto_comando[])
{
    return PC_ProcessCommand(playerid, texto_comando);
}

// Get command list for player
stock PC_GetPlayerCommands(playerid, output[], size)
{
    new count = 0;
    new temp[256];
    
    strcat(output, "Comandos disponíveis:\n", size);
    
    for (new i = 0; i < CommandCount; i++)
    {
        if (PC_HasAccess(playerid, CommandData[i][cmd_name]))
        {
            if (count % 3 == 0 && count > 0) strcat(output, "\n", size);
            
            format(temp, sizeof(temp), "/%s ", CommandData[i][cmd_name]);
            strcat(output, temp, size);
            count++;
        }
    }
    
    if (count == 0)
    {
        strcat(output, "Nenhum comando disponível.", size);
    }
    
    return count;
}

// Command help system
stock PC_GetCommandHelp(const cmdname[], output[], size)
{
    // This would be expanded with help text for each command
    format(output, size, "Ajuda para o comando /%s não disponível.", cmdname);
    return 1;
}

// Common Brazilian RP commands with automatic registration

// Auto-register essential commands
stock PC_InitializeBrazilianCommands()
{
    // Player commands
    PC_RegCommand("ajuda", "ajuda", 0);
    PC_RegCommand("comandos", "comandos", 0);
    PC_RegCommand("creditos", "creditos", 0);
    PC_RegCommand("regras", "regras", 0);
    PC_RegCommand("discord", "discord", 0);
    PC_RegCommand("site", "site", 0);
    
    // Character commands
    PC_RegCommand("stats", "stats", 0);
    PC_RegCommand("inventario", "inventario", 0);
    PC_RegCommand("rg", "rg", 0);
    PC_RegCommand("cnh", "cnh", 0);
    PC_RegCommand("celular", "celular", 0);
    PC_RegCommand("tempo", "tempo", 0);
    
    // Roleplay commands
    PC_RegCommand("me", "me", 0);
    PC_RegCommand("do", "do", 0);
    PC_RegCommand("tentar", "tentar", 0);
    PC_RegCommand("gritar", "gritar", 0);
    PC_RegCommand("sussurrar", "sussurrar", 0);
    PC_RegCommand("olhar", "olhar", 0);
    PC_RegCommand("deitar", "deitar", 0);
    PC_RegCommand("sentar", "sentar", 0);
    PC_RegCommand("dj", "dj", 0);
    PC_RegCommand("b", "b", 0);
    
    // Economy commands
    PC_RegCommand("banco", "banco", 0);
    PC_RegCommand("transferir", "transferir", 0);
    PC_RegCommand("pagar", "pagar", 0);
    PC_RegCommand("pix", "pix", 0);
    PC_RegCommand("coins", "coins", 0);
    
    // Vehicle commands
    PC_RegCommand("carro", "carro", 0);
    PC_RegCommand("trancar", "trancar", 0);
    PC_RegCommand("motor", "motor", 0);
    PC_RegCommand("luzes", "luzes", 0);
    PC_RegCommand("capô", "capo", 0);
    PC_RegCommand("porta-malas", "portamalas", 0);
    
    // House commands
    PC_RegCommand("casa", "casa", 0);
    PC_RegCommand("comprar", "comprar", 0);
    PC_RegCommand("vender", "vender", 0);
    PC_RegCommand("alugar", "alugar", 0);
    PC_RegCommand("entrar", "entrar", 0);
    PC_RegCommand("sair", "sair", 0);
    
    // Faction commands
    PC_RegCommand("faccao", "faccao", 1);
    PC_RegCommand("f", "f", 1);
    PC_RegCommand("r", "r", 1);
    PC_RegCommand("d", "d", 1);
    PC_RegCommand("lider", "lider", 5);
    
    // Police commands
    PC_RegCommand("prender", "prender", 1);
    PC_RegCommand("algemar", "algemar", 1);
    PC_RegCommand("revistar", "revistar", 1);
    PC_RegCommand("multar", "multar", 1);
    PC_RegCommand("guincho", "guincho", 1);
    PC_RegCommand("blitz", "blitz", 1);
    PC_RegCommand("porte", "porte", 1);
    
    // EMS commands
    PC_RegCommand("curar", "curar", 1);
    PC_RegCommand("reanimar", "reanimar", 1);
    PC_RegCommand("ambulancia", "ambulancia", 1);
    
    // Admin commands
    PC_RegCommand("admin", "admin", 1);
    PC_RegCommand("kick", "kick", 1);
    PC_RegCommand("ban", "ban", 2);
    PC_RegCommand("goto", "goto", 1);
    PC_RegCommand("trazer", "trazer", 1);
    PC_RegCommand("ir", "ir", 1);
    PC_RegCommand("carspawn", "carspawn", 2);
    PC_RegCommand("setlevel", "setlevel", 5);
    PC_RegCommand("setvip", "setvip", 3);
    PC_RegCommand("setmoney", "setmoney", 3);
    PC_RegCommand("announce", "announce", 2);
    PC_RegCommand("gmx", "gmx", 5);
    
    // VIP commands
    PC_RegCommand("vip", "vip", 0);
    PC_RegCommand("vheal", "vheal", 1);
    PC_RegCommand("varmour", "varmour", 1);
    PC_RegCommand("vcar", "vcar", 2);
    PC_RegCommand("vtp", "vtp", 2);
    PC_RegCommand("vnick", "vnick", 3);
    
    return 1;
}

// Command usage helpers
stock PC_ShowUsage(playerid, const usage[])
{
    new string[128];
    format(string, sizeof(string), "{FF6B6B}❌ Uso correto: {FFFFFF}%s", usage);
    SendClientMessage(playerid, -1, string);
    return 1;
}

stock PC_MostrarUso(playerid, const uso[])
{
    return PC_ShowUsage(playerid, uso);
}

// Permission levels
#define PC_LEVEL_PLAYER     0
#define PC_LEVEL_HELPER     1
#define PC_LEVEL_MODERATOR  2
#define PC_LEVEL_ADMIN      3
#define PC_LEVEL_MANAGER    4
#define PC_LEVEL_OWNER      5

// Brazilian permission names
#define PC_NIVEL_JOGADOR    PC_LEVEL_PLAYER
#define PC_NIVEL_AJUDANTE   PC_LEVEL_HELPER
#define PC_NIVEL_MODERADOR  PC_LEVEL_MODERATOR
#define PC_NIVEL_ADMIN      PC_LEVEL_ADMIN
#define PC_NIVEL_GERENTE    PC_LEVEL_MANAGER
#define PC_NIVEL_DONO       PC_LEVEL_OWNER

// Command statistics
stock PC_GetCommandStats()
{
    return CommandCount;
}

// Initialize the command system
stock PC_Init()
{
    printf("* Pawn.CMD inicializado com %d comandos registrados", CommandCount);
    return 1;
}

#endif