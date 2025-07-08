// ==================== BRASIL ELITE RP ====================
//        Gamemode Desenvolvido para LemeHost
//         Sistema de Login/Registro Avançado
//            CPF/RG Brasileiro + MySQL
//              © 2024 Brasil Elite RP
// ==========================================================

#define SSCANF_NO_NICE_FEATURES
#include <a_samp>
#include <a_mysql>
#include <sscanf2>
#undef MAX_OBJECTS
#include <streamer>

// ==================== CONFIGURAÇÕES MYSQL ====================
#define MYSQL_HOST              "127.0.0.1"
#define MYSQL_USER              "root"
#define MYSQL_PASS              ""
#define MYSQL_DB                "brasielite"

// ==================== CONFIGURAÇÕES DO SERVIDOR ====================
#define NOME_SERVIDOR           "Brasil Elite RP"
#define VERSAO_GAMEMODE         "2.0"
#define MAX_PING                300

// ==================== CORES ====================
#define COR_BRANCO              0xFFFFFFFF
#define COR_AZUL_ELITE          0x4169E1FF
#define COR_VERDE_ELITE         0x32CD32FF
#define COR_VERMELHO_ELITE      0xFF6347FF
#define COR_DOURADO_ELITE       0xFFD700FF
#define COR_LARANJA_ELITE       0xFF8C00FF
#define COR_ROXO_ELITE          0x9370DBFF
#define COR_ROSA_ELITE          0xFF69B4FF
#define COR_CIANO_ELITE         0x00FFFFFF
#define COR_AMARELO_ELITE       0xFFFF00FF
#define COR_CINZA_ELITE         0x808080FF
#define COR_PRETO_ELITE         0x000000FF
#define COR_ERRO                0xFF0000FF
#define COR_SUCESSO             0x00FF00FF
#define COR_INFO                0x87CEEBFF
#define COR_AVISO               0xFFA500FF
#define COR_CHAT_LOCAL          0xE6E6FAFF
#define COR_CHAT_OOC            0xFFFFFFFF

// ==================== DIALOGS ====================
#define DIALOG_REGISTRO         100
#define DIALOG_LOGIN            101
#define DIALOG_IDADE            102
#define DIALOG_SEXO             103
#define DIALOG_EMAIL            104
#define DIALOG_STATS            105

// ==================== ENUMS ====================
enum pInfo
{
    pID,
    pNome[MAX_PLAYER_NAME],
    pSenha[128],
    pEmail[128],
    pCPF[15],
    pRG[12],
    pIdade,
    pSexo,
    Float:pDinheiro,
    pBanco,
    pLevel,
    pExp,
    Float:pVida,
    Float:pColete,
    Float:pFome,
    Float:pSede,
    Float:pEnergia,
    Float:pStress,
    Float:pPosX,
    Float:pPosY,
    Float:pPosZ,
    Float:pAngle,
    pInterior,
    pVirtualWorld,
    pSkin,
    pEmprego,
    pFaccao,
    pCargo,
    pCasa,
    pVeiculo,
    pAdmin,
    pVIP,
    pLogado,
    pRegistrado
};

// ==================== VARIÁVEIS GLOBAIS ====================
new PlayerInfo[MAX_PLAYERS][pInfo];
new bool:PlayerOnline[MAX_PLAYERS];
new PlayerCPF[MAX_PLAYERS][15];
new PlayerRG[MAX_PLAYERS][12];
new MySQL:conexao;
new ServidorHora = 12;
new ServidorMinuto = 0;
new TotalPlayers = 0;

// Variáveis Anti-Cheat
new PlayerMoneyCheck[MAX_PLAYERS];
new PlayerHealthCheck[MAX_PLAYERS];
new PlayerSpeedCheck[MAX_PLAYERS];

// Textdraws HUD
new Text:TDHud_Fundo;
new Text:TDHud_Vida;
new Text:TDHud_Colete;
new Text:TDHud_Fome;
new Text:TDHud_Sede;
new Text:TDHud_Dinheiro;
new Text:TDHud_Level;
new Text:TDHud_FPS;
new Text:TDHud_Ping;
new Text:TDHud_Tempo;
new Text:TDHud_Data;
new Text:TDHud_Speedometer;
new Text:TDHud_Velocidade;
new Text:TDHud_Combustivel;
new Text:TDHud_KM;

// Textdraws de Login (PlayerTextDraw)
new PlayerText:PTDLogin_Fundo[MAX_PLAYERS];
new PlayerText:PTDLogin_Logo[MAX_PLAYERS];
new PlayerText:PTDLogin_BemVindo[MAX_PLAYERS];
new PlayerText:PTDLogin_Input[MAX_PLAYERS];
new PlayerText:PTDLogin_Botao[MAX_PLAYERS];

// ==================== FORWARDS ====================
forward OnPlayerLogin(playerid);
forward AtualizarServidor();
forward AntiCheatTimer();
forward KickPlayerDelayed(playerid);

// ==================== MAIN ====================
main()
{
    print("\n================================================");
    print("      BRASIL ELITE RP - GAMEMODE INICIADO");
    print("        Versao: 2.0 - LemeHost Edition");
    print("================================================\n");
}

// ==================== ON GAMEMODE INIT ====================
public OnGameModeInit()
{
    // Configurações básicas do servidor
    SetGameModeText("Brasil Elite RP v2.0");
    
    // Conectar ao MySQL
    conexao = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DB);
    
    if(mysql_errno(conexao) != 0)
    {
        print("❌ ERRO: Falha na conexão com MySQL!");
        print("Verifique as configurações do banco de dados.");
        SendRconCommand("exit");
        return 1;
    }
    else
    {
        print("✅ MySQL conectado com sucesso!");
        mysql_set_charset("utf8", conexao);
        CriarTabelasBanco();
    }
    
    // Configurar servidor
    DisableInteriorEnterExits();
    EnableStuntBonusForAll(0);
    SetNameTagDrawDistance(40.0);
    ShowNameTags(1);
    ShowPlayerMarkers(0);
    
    // Criar textdraws
    CriarTextdraws();
    
    // Configurar tempo
    SetWorldTime(ServidorHora);
    
    // Timers
    SetTimer("AtualizarServidor", 60000, true); // 1 minuto
    SetTimer("AntiCheatTimer", 5000, true); // 5 segundos
    
    print("✅ Gamemode carregado com sucesso!");
    print("📊 Sistema Anti-Cheat ativado!");
    print("🔐 Sistema de Login/Registro ativo!");
    print("💾 Sistema MySQL configurado!");
    
    return 1;
}

// ==================== ON GAMEMODE EXIT ====================
public OnGameModeExit()
{
    // Salvar todos os players online
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(PlayerOnline[i] && PlayerInfo[i][pLogado])
        {
            SalvarPlayer(i);
        }
    }
    
    // Fechar conexão MySQL
    mysql_close(conexao);
    
    print("🔴 Gamemode finalizado!");
    return 1;
}

// ==================== PLAYER CONNECT ====================
public OnPlayerConnect(playerid)
{
    // Resetar variáveis
    ResetarVariaveisPlayer(playerid);
    PlayerOnline[playerid] = true;
    TotalPlayers++;
    
    // Obter nome do player
    GetPlayerName(playerid, PlayerInfo[playerid][pNome], MAX_PLAYER_NAME);
    
    // Criar textdraws de login
    CriarTextdrawsLogin(playerid);
    
    // Verificar se o player está registrado
    new query[256];
    mysql_format(conexao, query, sizeof(query), 
        "SELECT `id` FROM `jogadores` WHERE `nome` = '%e' LIMIT 1", 
        PlayerInfo[playerid][pNome]);
    mysql_tquery(conexao, query, "VerificarRegistro", "i", playerid);
    
    // Mensagem de boas-vindas
    new string[256];
    format(string, sizeof(string), 
        "🌟 {FFFFFF}%s conectou ao {FFD700}%s{FFFFFF}!", 
        PlayerInfo[playerid][pNome], NOME_SERVIDOR);
    SendClientMessageToAll(COR_AZUL_ELITE, string);
    
    SendClientMessage(playerid, COR_BRANCO, "════════════════════════════════════════════════");
    SendClientMessage(playerid, COR_DOURADO_ELITE, "    🇧🇷 Bem-vindo ao Brasil Elite RP! 🇧🇷");
    SendClientMessage(playerid, COR_AZUL_ELITE, "      ✨ Servidor de Roleplay Brasileiro ✨");
    SendClientMessage(playerid, COR_VERDE_ELITE, "        📋 Sistema de CPF/RG Brasileiro");
    SendClientMessage(playerid, COR_ROXO_ELITE, "         🏆 HUD Avançado Estilo GTA V");
    SendClientMessage(playerid, COR_ROSA_ELITE, "          🛡️ Sistema Anti-Cheat Ativo");
    SendClientMessage(playerid, COR_BRANCO, "════════════════════════════════════════════════");
    
    printf("🌟 %s conectou ao servidor (ID: %d)", PlayerInfo[playerid][pNome], playerid);
    
    return 1;
}

// ==================== PLAYER DISCONNECT ====================
public OnPlayerDisconnect(playerid, reason)
{
    // Salvar dados se estiver logado
    if(PlayerInfo[playerid][pLogado])
    {
        SalvarPlayer(playerid);
    }
    
    // Destruir textdraws
    DestruirTextdrawsPlayer(playerid);
    
    // Marcar player como offline
    PlayerOnline[playerid] = false;
    TotalPlayers--;
    
    // Mensagem de saída
    new string[128], motivo[32];
    switch(reason)
    {
        case 0: motivo = "Crash/Timeout";
        case 1: motivo = "Saiu";
        case 2: motivo = "Kickado/Banido";
        default: motivo = "Desconhecido";
    }
    
    format(string, sizeof(string), 
        "👋 {FFFFFF}%s saiu do servidor. Motivo: {FFD700}%s", 
        PlayerInfo[playerid][pNome], motivo);
    SendClientMessageToAll(COR_CINZA_ELITE, string);
    
    printf("👋 %s desconectou do servidor. Motivo: %s", PlayerInfo[playerid][pNome], motivo);
    
    return 1;
}

// ==================== PLAYER SPAWN ====================
public OnPlayerSpawn(playerid)
{
    if(!PlayerInfo[playerid][pLogado])
    {
        Kick(playerid);
        return 1;
    }
    
    // Definir posição de spawn padrão
    SetPlayerPos(playerid, 1686.7, -2240.1, 13.5);
    SetPlayerFacingAngle(playerid, 0.0);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    
    // Configurar player
    SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
    SetPlayerHealth(playerid, PlayerInfo[playerid][pVida]);
    SetPlayerArmour(playerid, PlayerInfo[playerid][pColete]);
    GivePlayerMoney(playerid, floatround(PlayerInfo[playerid][pDinheiro]));
    
    // Atualizar anti-cheat
    PlayerMoneyCheck[playerid] = GetPlayerMoney(playerid);
    new Float:tempHealth;
    GetPlayerHealth(playerid, tempHealth);
    PlayerHealthCheck[playerid] = floatround(tempHealth);
    
    // Mostrar HUD
    MostrarHUDPlayer(playerid);
    
    printf("🎯 %s spawnou no servidor", PlayerInfo[playerid][pNome]);
    
    return 1;
}

// ==================== PLAYER DEATH ====================
public OnPlayerDeath(playerid, killerid, reason)
{
    // Resetar posição para hospital
    PlayerInfo[playerid][pPosX] = 1172.0;
    PlayerInfo[playerid][pPosY] = -1323.0;
    PlayerInfo[playerid][pPosZ] = 15.4;
    PlayerInfo[playerid][pAngle] = 270.0;
    
    // Diminuir vida e adicionar stress
    PlayerInfo[playerid][pVida] = 50.0;
    PlayerInfo[playerid][pStress] += 10.0;
    if(PlayerInfo[playerid][pStress] > 100.0) PlayerInfo[playerid][pStress] = 100.0;
    
    // Cobrar taxa do hospital
    new taxa = 500;
    if(PlayerInfo[playerid][pDinheiro] >= taxa)
    {
        PlayerInfo[playerid][pDinheiro] -= taxa;
        GivePlayerMoney(playerid, -taxa);
    }
    
    SendClientMessage(playerid, COR_VERMELHO_ELITE, "💀 Você morreu e foi levado ao hospital!");
    SendClientMessage(playerid, COR_INFO, "🏥 Taxa hospitalar: R$ 500");
    
    return 1;
}

// ==================== PLAYER TEXT ====================
public OnPlayerText(playerid, text[])
{
    if(!PlayerInfo[playerid][pLogado]) return 0;
    
    // Anti-spam básico
    if(strlen(text) < 2) return 0;
    
    // Formatar mensagem
    new string[256];
    format(string, sizeof(string), "%s diz: %s", PlayerInfo[playerid][pNome], text);
    
    // Enviar para players próximos
    SendLocalMessage(playerid, string, 20.0);
    
    return 0; // Não usar o chat padrão
}

// ==================== PLAYER COMMAND TEXT ====================
public OnPlayerCommandText(playerid, cmdtext[])
{
    if(!PlayerInfo[playerid][pLogado] && strcmp(cmdtext, "/q", true) != 0)
    {
        SendClientMessage(playerid, COR_ERRO, "❌ Você precisa estar logado para usar comandos!");
        return 1;
    }
    
    // Sistema de comandos manual (substituindo ZCMD)
    new cmd[32], params[128], pos;
    pos = strfind(cmdtext, " ", false);
    
    if(pos == -1)
    {
        strmid(cmd, cmdtext, 1, strlen(cmdtext));
        params[0] = EOS;
    }
    else
    {
        strmid(cmd, cmdtext, 1, pos);
        strmid(params, cmdtext, pos + 1, strlen(cmdtext));
    }
    
    // Comandos disponíveis
    if(!strcmp(cmd, "cpf", true))
    {
        CMD_cpf(playerid, params);
        return 1;
    }
    else if(!strcmp(cmd, "stats", true))
    {
        CMD_stats(playerid, params);
        return 1;
    }
    else if(!strcmp(cmd, "me", true))
    {
        CMD_me(playerid, params);
        return 1;
    }
    else if(!strcmp(cmd, "do", true))
    {
        CMD_do(playerid, params);
        return 1;
    }
    else if(!strcmp(cmd, "b", true))
    {
        CMD_b(playerid, params);
        return 1;
    }
    else if(!strcmp(cmd, "s", true))
    {
        CMD_s(playerid, params);
        return 1;
    }
    else if(!strcmp(cmd, "w", true))
    {
        CMD_w(playerid, params);
        return 1;
    }
    else if(!strcmp(cmd, "comandos", true))
    {
        CMD_comandos(playerid, params);
        return 1;
    }
    else if(!strcmp(cmd, "q", true))
    {
        CMD_q(playerid, params);
        return 1;
    }
    
    SendClientMessage(playerid, COR_ERRO, "❌ Comando inválido! Use {FFFF00}/comandos{FF0000} para ver os comandos disponíveis.");
    return 1;
}

// ==================== DIALOG RESPONSE ====================
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_REGISTRO:
        {
            if(!response) return Kick(playerid);
            
            if(strlen(inputtext) < 6 || strlen(inputtext) > 32)
            {
                SendClientMessage(playerid, COR_ERRO, "❌ A senha deve ter entre 6 e 32 caracteres!");
                MostrarDialogRegistro(playerid);
                return 1;
            }
            
            // Validar senha
            if(!ValidarSenha(inputtext))
            {
                SendClientMessage(playerid, COR_ERRO, "❌ Senha muito fraca! Use letras, números e símbolos.");
                MostrarDialogRegistro(playerid);
                return 1;
            }
            
            // Salvar senha temporariamente
            format(PlayerInfo[playerid][pSenha], 128, "%s", inputtext);
            
            // Pedir idade
            ShowPlayerDialog(playerid, DIALOG_IDADE, DIALOG_STYLE_INPUT,
                "{FFD700}• BRASIL ELITE RP - IDADE •",
                "{FFFFFF}Digite sua idade (entre 18 e 80 anos):",
                "Continuar", "Voltar");
        }
        
        case DIALOG_IDADE:
        {
            if(!response)
            {
                MostrarDialogRegistro(playerid);
                return 1;
            }
            
            new idade = strval(inputtext);
            if(idade < 18 || idade > 80)
            {
                SendClientMessage(playerid, COR_ERRO, "❌ Idade deve estar entre 18 e 80 anos!");
                ShowPlayerDialog(playerid, DIALOG_IDADE, DIALOG_STYLE_INPUT,
                    "{FFD700}• BRASIL ELITE RP - IDADE •",
                    "{FF6347}❌ Idade inválida!\n\n{FFFFFF}Digite sua idade (entre 18 e 80 anos):",
                    "Continuar", "Voltar");
                return 1;
            }
            
            PlayerInfo[playerid][pIdade] = idade;
            
            // Pedir sexo
            ShowPlayerDialog(playerid, DIALOG_SEXO, DIALOG_STYLE_LIST,
                "{FFD700}• BRASIL ELITE RP - SEXO •",
                "Masculino\nFeminino",
                "Selecionar", "Voltar");
        }
        
        case DIALOG_SEXO:
        {
            if(!response)
            {
                ShowPlayerDialog(playerid, DIALOG_IDADE, DIALOG_STYLE_INPUT,
                    "{FFD700}• BRASIL ELITE RP - IDADE •",
                    "{FFFFFF}Digite sua idade (entre 18 e 80 anos):",
                    "Continuar", "Voltar");
                return 1;
            }
            
            PlayerInfo[playerid][pSexo] = listitem; // 0=Masculino, 1=Feminino
            
            // Pedir email
            ShowPlayerDialog(playerid, DIALOG_EMAIL, DIALOG_STYLE_INPUT,
                "{FFD700}• BRASIL ELITE RP - EMAIL •",
                "{FFFFFF}Digite seu email (será usado para recuperação de conta):",
                "Finalizar", "Voltar");
        }
        
        case DIALOG_EMAIL:
        {
            if(!response)
            {
                ShowPlayerDialog(playerid, DIALOG_SEXO, DIALOG_STYLE_LIST,
                    "{FFD700}• BRASIL ELITE RP - SEXO •",
                    "Masculino\nFeminino",
                    "Selecionar", "Voltar");
                return 1;
            }
            
            if(strlen(inputtext) < 5 || !ValidarEmail(inputtext))
            {
                SendClientMessage(playerid, COR_ERRO, "❌ Email inválido!");
                ShowPlayerDialog(playerid, DIALOG_EMAIL, DIALOG_STYLE_INPUT,
                    "{FFD700}• BRASIL ELITE RP - EMAIL •",
                    "{FF6347}❌ Email inválido!\n\n{FFFFFF}Digite um email válido:",
                    "Finalizar", "Voltar");
                return 1;
            }
            
            format(PlayerInfo[playerid][pEmail], 128, "%s", inputtext);
            
            // Criar conta
            CriarConta(playerid);
        }
        
        case DIALOG_LOGIN:
        {
            if(!response) return Kick(playerid);
            
            if(strlen(inputtext) < 1)
            {
                SendClientMessage(playerid, COR_ERRO, "❌ Digite sua senha!");
                MostrarDialogLogin(playerid);
                return 1;
            }
            
            // Verificar senha
            new query[512];
            mysql_format(conexao, query, sizeof(query),
                "SELECT * FROM `jogadores` WHERE `nome` = '%e' AND `senha` = SHA2('%e', 256) LIMIT 1",
                PlayerInfo[playerid][pNome], inputtext);
            mysql_tquery(conexao, query, "OnPlayerLogin", "i", playerid);
        }
        
        case DIALOG_STATS:
        {
            // Dialog apenas informativo
            return 1;
        }
    }
    
    return 1;
}

// ==================== CALLBACKS DE TIMER ====================
public AtualizarServidor()
{
    // Atualizar tempo
    ServidorMinuto++;
    if(ServidorMinuto >= 60)
    {
        ServidorMinuto = 0;
        ServidorHora++;
        if(ServidorHora >= 24)
        {
            ServidorHora = 0;
        }
    }
    
    // Atualizar todos os players
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(PlayerOnline[i] && PlayerInfo[i][pLogado])
        {
            AtualizarStatusPlayer(i);
            AtualizarHUDPlayer(i);
        }
    }
    
    return 1;
}

public AntiCheatTimer()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(PlayerOnline[i] && PlayerInfo[i][pLogado])
        {
            DetectarAntiCheat(i);
        }
    }
    
    return 1;
}

// ==================== MYSQL CALLBACKS ====================
public OnPlayerLogin(playerid)
{
    if(cache_get_row_count() > 0)
    {
        // Login bem-sucedido
        PlayerInfo[playerid][pID] = cache_get_value_int(0, 0);
        cache_get_value(0, 1, PlayerInfo[playerid][pEmail], 128);
        cache_get_value(0, 2, PlayerInfo[playerid][pCPF], 15);
        cache_get_value(0, 3, PlayerInfo[playerid][pRG], 12);
        PlayerInfo[playerid][pIdade] = cache_get_value_int(0, 4);
        PlayerInfo[playerid][pSexo] = cache_get_value_int(0, 5);
        PlayerInfo[playerid][pDinheiro] = cache_get_value_float(0, 6);
        PlayerInfo[playerid][pBanco] = cache_get_value_int(0, 7);
        PlayerInfo[playerid][pLevel] = cache_get_value_int(0, 8);
        PlayerInfo[playerid][pExp] = cache_get_value_int(0, 9);
        PlayerInfo[playerid][pVida] = cache_get_value_float(0, 10);
        PlayerInfo[playerid][pColete] = cache_get_value_float(0, 11);
        PlayerInfo[playerid][pFome] = cache_get_value_float(0, 12);
        PlayerInfo[playerid][pSede] = cache_get_value_float(0, 13);
        PlayerInfo[playerid][pPosX] = cache_get_value_float(0, 14);
        PlayerInfo[playerid][pPosY] = cache_get_value_float(0, 15);
        PlayerInfo[playerid][pPosZ] = cache_get_value_float(0, 16);
        PlayerInfo[playerid][pAngle] = cache_get_value_float(0, 17);
        PlayerInfo[playerid][pInterior] = cache_get_value_int(0, 18);
        PlayerInfo[playerid][pVirtualWorld] = cache_get_value_int(0, 19);
        PlayerInfo[playerid][pSkin] = cache_get_value_int(0, 20);
        
        // Copiar CPF e RG do banco para as variáveis locais
        format(PlayerCPF[playerid], 15, "%s", PlayerInfo[playerid][pCPF]);
        format(PlayerRG[playerid], 12, "%s", PlayerInfo[playerid][pRG]);
        
        PlayerInfo[playerid][pRegistrado] = 1;
        PlayerInfo[playerid][pLogado] = 1;
        
        // Esconder textdraws de login
        PlayerTextDrawHide(playerid, PTDLogin_Fundo[playerid]);
        PlayerTextDrawHide(playerid, PTDLogin_Logo[playerid]);
        PlayerTextDrawHide(playerid, PTDLogin_BemVindo[playerid]);
        PlayerTextDrawHide(playerid, PTDLogin_Input[playerid]);
        PlayerTextDrawHide(playerid, PTDLogin_Botao[playerid]);
        
        // Mensagens de boas-vindas
        SendClientMessage(playerid, COR_VERDE_ELITE, "✅ Login realizado com sucesso!");
        SendClientMessage(playerid, COR_AZUL_ELITE, "🎮 Bem-vindo de volta ao Brasil Elite RP!");
        
        // Spawnar o player
        SpawnPlayer(playerid);
        
        printf("✅ %s fez login com sucesso (ID: %d)", PlayerInfo[playerid][pNome], PlayerInfo[playerid][pID]);
    }
    else
    {
        // Senha incorreta
        SendClientMessage(playerid, COR_ERRO, "❌ Senha incorreta!");
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, 
            "{FFD700}• BRASIL ELITE RP - LOGIN •", 
            "{FF6347}❌ Senha incorreta! Tente novamente.\n\n{FFFFFF}Digite sua senha para fazer login:", 
            "Entrar", "Sair");
    }
    
    return 1;
}

// ==================== FUNÇÕES AUXILIARES ====================

// Função para verificar registro do player
public VerificarRegistro(playerid)
{
    if(cache_get_row_count() > 0)
    {
        // Player já registrado - mostrar dialog de login
        MostrarDialogLogin(playerid);
    }
    else
    {
        // Player não registrado - mostrar dialog de registro
        MostrarDialogRegistro(playerid);
    }
    
    return 1;
}

// Função para criar conta
stock CriarConta(playerid)
{
    // Gerar CPF e RG brasileiros
    GerarCPF(playerid);
    GerarRG(playerid);
    
    // Salvar no banco
    new query[1024];
    mysql_format(conexao, query, sizeof(query),
        "INSERT INTO `jogadores` (`nome`, `senha`, `email`, `cpf`, `rg`, `idade`, `sexo`) VALUES ('%e', SHA2('%e', 256), '%e', '%e', '%e', %d, %d)",
        PlayerInfo[playerid][pNome], PlayerInfo[playerid][pSenha], PlayerInfo[playerid][pEmail], 
        PlayerCPF[playerid], PlayerRG[playerid], PlayerInfo[playerid][pIdade], PlayerInfo[playerid][pSexo]);
    mysql_tquery(conexao, query, "OnAccountCreated", "i", playerid);
    
    return 1;
}

// Callback para conta criada
public OnAccountCreated(playerid)
{
    PlayerInfo[playerid][pID] = cache_insert_id();
    PlayerInfo[playerid][pRegistrado] = 1;
    PlayerInfo[playerid][pLogado] = 1;
    
    // Definir valores padrão
    PlayerInfo[playerid][pDinheiro] = 5000.0;
    PlayerInfo[playerid][pLevel] = 1;
    PlayerInfo[playerid][pVida] = 100.0;
    PlayerInfo[playerid][pColete] = 0.0;
    PlayerInfo[playerid][pFome] = 100.0;
    PlayerInfo[playerid][pSede] = 100.0;
    PlayerInfo[playerid][pEnergia] = 100.0;
    PlayerInfo[playerid][pStress] = 0.0;
    PlayerInfo[playerid][pSkin] = (PlayerInfo[playerid][pSexo] == 0) ? 26 : 56;
    
    // Esconder textdraws de login
    DestruirTextdrawsLogin(playerid);
    
    // Mensagens de boas-vindas
    SendClientMessage(playerid, COR_VERDE_ELITE, "✅ Conta criada com sucesso!");
    SendClientMessage(playerid, COR_AZUL_ELITE, "🎮 Bem-vindo ao Brasil Elite RP!");
    
    new string[256];
    format(string, sizeof(string), "📋 Seus documentos foram gerados:");
    SendClientMessage(playerid, COR_INFO, string);
    format(string, sizeof(string), "🆔 CPF: {FFFF00}%s", PlayerCPF[playerid]);
    SendClientMessage(playerid, COR_INFO, string);
    format(string, sizeof(string), "🆔 RG: {FFFF00}%s", PlayerRG[playerid]);
    SendClientMessage(playerid, COR_INFO, string);
    
    SendClientMessage(playerid, COR_INFO, "📋 Digite {FFFF00}/comandos {87CEEB}para ver todos os comandos disponíveis.");
    SendClientMessage(playerid, COR_INFO, "💬 Discord: {FFFF00}discord.gg/brasielite");
    
    // Spawnar o player
    SpawnPlayer(playerid);
    
    printf("✅ %s criou uma nova conta (ID: %d)", PlayerInfo[playerid][pNome], PlayerInfo[playerid][pID]);
    
    return 1;
}

// Função para salvar player
stock SalvarPlayer(playerid)
{
    if(!PlayerInfo[playerid][pLogado]) return 0;
    
    new Float:x, Float:y, Float:z, Float:angle;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, angle);
    
    new query[1024];
    mysql_format(conexao, query, sizeof(query),
        "UPDATE `jogadores` SET `dinheiro` = %.2f, `banco` = %d, `level` = %d, `exp` = %d, `vida` = %.1f, `colete` = %.1f, `fome` = %.1f, `sede` = %.1f, `energia` = %.1f, `stress` = %.1f, `pos_x` = %.3f, `pos_y` = %.3f, `pos_z` = %.3f, `angle` = %.3f, `interior` = %d, `virtual_world` = %d, `skin` = %d WHERE `id` = %d",
        PlayerInfo[playerid][pDinheiro], PlayerInfo[playerid][pBanco], PlayerInfo[playerid][pLevel], PlayerInfo[playerid][pExp], 
        PlayerInfo[playerid][pVida], PlayerInfo[playerid][pColete], PlayerInfo[playerid][pFome], PlayerInfo[playerid][pSede], 
        PlayerInfo[playerid][pEnergia], PlayerInfo[playerid][pStress], x, y, z, angle, 
        GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), GetPlayerSkin(playerid), PlayerInfo[playerid][pID]);
    mysql_tquery(conexao, query);
    
    return 1;
}

// Função para mostrar dialog de registro
stock MostrarDialogRegistro(playerid)
{
    new string[512];
    format(string, sizeof(string),
        "{FFFFFF}Olá {FFD700}%s{FFFFFF}!\n\n"
        "Você não possui uma conta registrada.\n"
        "Para jogar no {FFD700}Brasil Elite RP{FFFFFF}, você precisa criar uma conta.\n\n"
        "{FF6347}• {FFFFFF}A senha deve ter pelo menos 6 caracteres\n"
        "{FF6347}• {FFFFFF}Use letras, números e símbolos\n"
        "{FF6347}• {FFFFFF}Mantenha sua senha segura\n\n"
        "Digite uma senha para criar sua conta:",
        PlayerInfo[playerid][pNome]);
    
    ShowPlayerDialog(playerid, DIALOG_REGISTRO, DIALOG_STYLE_PASSWORD,
        "{FFD700}• BRASIL ELITE RP - REGISTRO •", string, "Criar", "Sair");
    
    return 1;
}

// Função para mostrar dialog de login
stock MostrarDialogLogin(playerid)
{
    new string[512];
    format(string, sizeof(string),
        "{FFFFFF}Olá {FFD700}%s{FFFFFF}!\n\n"
        "Você já possui uma conta registrada.\n"
        "Digite sua senha para fazer login:\n\n"
        "{87CEEB}💡 Dica: Se esqueceu sua senha, contate um administrador.",
        PlayerInfo[playerid][pNome]);
    
    ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,
        "{FFD700}• BRASIL ELITE RP - LOGIN •", string, "Entrar", "Sair");
    
    return 1;
}

// Função para criar textdraws de login
stock CriarTextdrawsLogin(playerid)
{
    // Fundo
    PTDLogin_Fundo[playerid] = CreatePlayerTextDraw(playerid, 320.0, 240.0, "_");
    PlayerTextDrawTextSize(playerid, PTDLogin_Fundo[playerid], 220.0, 180.0);
    PlayerTextDrawAlignment(playerid, PTDLogin_Fundo[playerid], 2);
    PlayerTextDrawColor(playerid, PTDLogin_Fundo[playerid], -1);
    PlayerTextDrawUseBox(playerid, PTDLogin_Fundo[playerid], 1);
    PlayerTextDrawBoxColor(playerid, PTDLogin_Fundo[playerid], 0x00000099);
    PlayerTextDrawSetShadow(playerid, PTDLogin_Fundo[playerid], 0);
    PlayerTextDrawSetOutline(playerid, PTDLogin_Fundo[playerid], 0);
    PlayerTextDrawBackgroundColor(playerid, PTDLogin_Fundo[playerid], 255);
    PlayerTextDrawFont(playerid, PTDLogin_Fundo[playerid], 1);
    PlayerTextDrawSetProportional(playerid, PTDLogin_Fundo[playerid], 1);
    
    // Logo
    PTDLogin_Logo[playerid] = CreatePlayerTextDraw(playerid, 320.0, 180.0, "~y~BRASIL ELITE RP");
    PlayerTextDrawAlignment(playerid, PTDLogin_Logo[playerid], 2);
    PlayerTextDrawColor(playerid, PTDLogin_Logo[playerid], -1);
    PlayerTextDrawSetShadow(playerid, PTDLogin_Logo[playerid], 0);
    PlayerTextDrawSetOutline(playerid, PTDLogin_Logo[playerid], 1);
    PlayerTextDrawBackgroundColor(playerid, PTDLogin_Logo[playerid], 255);
    PlayerTextDrawFont(playerid, PTDLogin_Logo[playerid], 1);
    PlayerTextDrawLetterSize(playerid, PTDLogin_Logo[playerid], 0.5, 2.0);
    PlayerTextDrawSetProportional(playerid, PTDLogin_Logo[playerid], 1);
    
    // Texto de boas-vindas
    PTDLogin_BemVindo[playerid] = CreatePlayerTextDraw(playerid, 320.0, 220.0, "Carregando...");
    PlayerTextDrawAlignment(playerid, PTDLogin_BemVindo[playerid], 2);
    PlayerTextDrawColor(playerid, PTDLogin_BemVindo[playerid], -1);
    PlayerTextDrawSetShadow(playerid, PTDLogin_BemVindo[playerid], 0);
    PlayerTextDrawSetOutline(playerid, PTDLogin_BemVindo[playerid], 1);
    PlayerTextDrawBackgroundColor(playerid, PTDLogin_BemVindo[playerid], 255);
    PlayerTextDrawFont(playerid, PTDLogin_BemVindo[playerid], 2);
    PlayerTextDrawLetterSize(playerid, PTDLogin_BemVindo[playerid], 0.3, 1.2);
    PlayerTextDrawSetProportional(playerid, PTDLogin_BemVindo[playerid], 1);
    
    // Mostrar textdraws
    PlayerTextDrawShow(playerid, PTDLogin_Fundo[playerid]);
    PlayerTextDrawShow(playerid, PTDLogin_Logo[playerid]);
    PlayerTextDrawShow(playerid, PTDLogin_BemVindo[playerid]);
    
    return 1;
}

// Função para destruir textdraws de login
stock DestruirTextdrawsLogin(playerid)
{
    PlayerTextDrawDestroy(playerid, PTDLogin_Fundo[playerid]);
    PlayerTextDrawDestroy(playerid, PTDLogin_Logo[playerid]);
    PlayerTextDrawDestroy(playerid, PTDLogin_BemVindo[playerid]);
    PlayerTextDrawDestroy(playerid, PTDLogin_Input[playerid]);
    PlayerTextDrawDestroy(playerid, PTDLogin_Botao[playerid]);
    
    return 1;
}

// Função para destruir textdraws do player
stock DestruirTextdrawsPlayer(playerid)
{
    // Esconder HUD
    TextDrawHideForPlayer(playerid, TDHud_Fundo);
    TextDrawHideForPlayer(playerid, TDHud_Vida);
    TextDrawHideForPlayer(playerid, TDHud_Colete);
    TextDrawHideForPlayer(playerid, TDHud_Fome);
    TextDrawHideForPlayer(playerid, TDHud_Sede);
    TextDrawHideForPlayer(playerid, TDHud_Dinheiro);
    TextDrawHideForPlayer(playerid, TDHud_Level);
    TextDrawHideForPlayer(playerid, TDHud_FPS);
    TextDrawHideForPlayer(playerid, TDHud_Ping);
    TextDrawHideForPlayer(playerid, TDHud_Tempo);
    TextDrawHideForPlayer(playerid, TDHud_Data);
    TextDrawHideForPlayer(playerid, TDHud_Speedometer);
    TextDrawHideForPlayer(playerid, TDHud_Velocidade);
    TextDrawHideForPlayer(playerid, TDHud_Combustivel);
    TextDrawHideForPlayer(playerid, TDHud_KM);
    
    // Destruir textdraws de login se existirem
    DestruirTextdrawsLogin(playerid);
    
    return 1;
}

// ==================== COMANDOS ====================
stock CMD_cpf(playerid, params[])
{
    if(!PlayerInfo[playerid][pLogado]) return 1;
    
    new string[128];
    format(string, sizeof(string), 
        "🆔 Seu CPF: {FFFF00}%s", PlayerCPF[playerid]);
    SendClientMessage(playerid, COR_INFO, string);
    
    format(string, sizeof(string), 
        "🆔 Seu RG: {FFFF00}%s", PlayerRG[playerid]);
    SendClientMessage(playerid, COR_INFO, string);
    
    return 1;
}

stock CMD_stats(playerid, params[])
{
    if(!PlayerInfo[playerid][pLogado]) return 1;
    
    new string[1024];
    new sexoText[16];
    if(PlayerInfo[playerid][pSexo] == 0) sexoText = "Masculino";
    else sexoText = "Feminino";
    
    format(string, sizeof(string),
        "{FFD700}═══════════ ESTATÍSTICAS ═══════════\n"
        "{FFFFFF}Nome: {FFD700}%s\n"
        "{FFFFFF}ID: {FFD700}%d\n"
        "{FFFFFF}Level: {FFD700}%d {FFFFFF}| Experiência: {FFD700}%d\n"
        "{FFFFFF}Dinheiro: {32CD32}R$ %.2f\n"
        "{FFFFFF}Banco: {32CD32}R$ %d\n"
        "{FFFFFF}Idade: {FFD700}%d anos\n"
        "{FFFFFF}Sexo: {FFD700}%s\n"
        "{FFFFFF}CPF: {FFD700}%s\n"
        "{FFFFFF}RG: {FFD700}%s\n"
        "{FFFFFF}Vida: {FF6347}%.1f%% {FFFFFF}| Colete: {87CEEB}%.1f%%\n"
        "{FFFFFF}Fome: {FFD700}%.1f%% {FFFFFF}| Sede: {87CEEB}%.1f%%\n"
        "{FFFFFF}Energia: {32CD32}%.1f%% {FFFFFF}| Stress: {FF6347}%.1f%%",
        PlayerInfo[playerid][pNome], playerid, PlayerInfo[playerid][pLevel], PlayerInfo[playerid][pExp],
        PlayerInfo[playerid][pDinheiro], PlayerInfo[playerid][pBanco], PlayerInfo[playerid][pIdade], sexoText,
        PlayerCPF[playerid], PlayerRG[playerid], PlayerInfo[playerid][pVida], PlayerInfo[playerid][pColete],
        PlayerInfo[playerid][pFome], PlayerInfo[playerid][pSede], PlayerInfo[playerid][pEnergia], PlayerInfo[playerid][pStress]);
    
    ShowPlayerDialog(playerid, DIALOG_STATS, DIALOG_STYLE_MSGBOX,
        "{FFD700}• BRASIL ELITE RP - STATS •", string, "Fechar", "");
    
    return 1;
}

stock CMD_me(playerid, params[])
{
    if(!PlayerInfo[playerid][pLogado]) return 1;
    
    if(isnull(params))
    {
        SendClientMessage(playerid, COR_ERRO, "❌ Use: /me [ação]");
        SendClientMessage(playerid, COR_INFO, "💡 Exemplo: /me acende um cigarro");
        return 1;
    }
    
    new string[256];
    format(string, sizeof(string), "* %s %s", PlayerInfo[playerid][pNome], params);
    SendLocalMessage(playerid, string, 20.0);
    
    return 1;
}

stock CMD_do(playerid, params[])
{
    if(!PlayerInfo[playerid][pLogado]) return 1;
    
    if(isnull(params))
    {
        SendClientMessage(playerid, COR_ERRO, "❌ Use: /do [ação]");
        SendClientMessage(playerid, COR_INFO, "💡 Exemplo: /do há uma mesa quebrada no chão");
        return 1;
    }
    
    new string[256];
    format(string, sizeof(string), "* %s (( %s ))", params, PlayerInfo[playerid][pNome]);
    SendLocalMessage(playerid, string, 20.0);
    
    return 1;
}

stock CMD_b(playerid, params[])
{
    if(!PlayerInfo[playerid][pLogado]) return 1;
    
    if(isnull(params))
    {
        SendClientMessage(playerid, COR_ERRO, "❌ Use: /b [mensagem OOC]");
        SendClientMessage(playerid, COR_INFO, "💡 Exemplo: /b alguém sabe onde fica a loja?");
        return 1;
    }
    
    new string[256];
    format(string, sizeof(string), "(( %s: %s ))", PlayerInfo[playerid][pNome], params);
    SendLocalMessage(playerid, string, 20.0);
    
    return 1;
}

stock CMD_s(playerid, params[])
{
    if(!PlayerInfo[playerid][pLogado]) return 1;
    
    if(isnull(params))
    {
        SendClientMessage(playerid, COR_ERRO, "❌ Use: /s [mensagem]");
        SendClientMessage(playerid, COR_INFO, "💡 Exemplo: /s Socorro! Alguém me ajuda!");
        return 1;
    }
    
    new string[256];
    format(string, sizeof(string), "%s grita: %s", PlayerInfo[playerid][pNome], params);
    SendLocalMessage(playerid, string, 40.0);
    
    return 1;
}

stock CMD_w(playerid, params[])
{
    if(!PlayerInfo[playerid][pLogado]) return 1;
    
    if(isnull(params))
    {
        SendClientMessage(playerid, COR_ERRO, "❌ Use: /w [mensagem]");
        SendClientMessage(playerid, COR_INFO, "💡 Exemplo: /w psiu, vem aqui...");
        return 1;
    }
    
    new string[256];
    format(string, sizeof(string), "%s sussurra: %s", PlayerInfo[playerid][pNome], params);
    SendLocalMessage(playerid, string, 5.0);
    
    return 1;
}

stock CMD_comandos(playerid, params[])
{
    if(!PlayerInfo[playerid][pLogado]) return 1;
    
    SendClientMessage(playerid, COR_DOURADO_ELITE, "════════════ COMANDOS DISPONÍVEIS ════════════");
    SendClientMessage(playerid, COR_INFO, "📋 {FFFF00}/cpf {87CEEB}- Mostra seu CPF e RG");
    SendClientMessage(playerid, COR_INFO, "📊 {FFFF00}/stats {87CEEB}- Mostra suas estatísticas");
    SendClientMessage(playerid, COR_INFO, "🎭 {FFFF00}/me [ação] {87CEEB}- Fazer uma ação RP");
    SendClientMessage(playerid, COR_INFO, "🌍 {FFFF00}/do [ação] {87CEEB}- Descrever o ambiente");
    SendClientMessage(playerid, COR_INFO, "💬 {FFFF00}/b [mensagem] {87CEEB}- Chat OOC local");
    SendClientMessage(playerid, COR_INFO, "📢 {FFFF00}/s [mensagem] {87CEEB}- Gritar (alcance maior)");
    SendClientMessage(playerid, COR_INFO, "🤫 {FFFF00}/w [mensagem] {87CEEB}- Sussurrar (alcance menor)");
    SendClientMessage(playerid, COR_INFO, "🚪 {FFFF00}/q {87CEEB}- Sair do servidor");
    SendClientMessage(playerid, COR_DOURADO_ELITE, "═══════════════════════════════════════════════");
    
    return 1;
}

stock CMD_q(playerid, params[])
{
    SendClientMessage(playerid, COR_INFO, "👋 Obrigado por jogar no Brasil Elite RP!");
    SendClientMessage(playerid, COR_INFO, "💬 Discord: discord.gg/brasielite");
    
    SetTimerEx("KickPlayerDelayed", 2000, false, "i", playerid);
    return 1;
}

public KickPlayerDelayed(playerid)
{
    Kick(playerid);
    return 1;
}

// ==================== FUNÇÕES DE SISTEMA ====================

// Função para formatar dinheiro brasileiro
stock FormatarDinheiro(valor)
{
    new string[32];
    
    if(valor >= 1000000)
    {
        format(string, sizeof(string), "%d.%03d.%03d", 
            valor / 1000000, (valor % 1000000) / 1000, valor % 1000);
    }
    else if(valor >= 1000)
    {
        format(string, sizeof(string), "%d.%03d", valor / 1000, valor % 1000);
    }
    else
    {
        format(string, sizeof(string), "%d", valor);
    }
    
    return string;
}

// Função para enviar mensagem local
stock SendLocalMessage(playerid, const message[], Float:radius)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(PlayerOnline[i])
        {
            if(GetPlayerDistanceFromPoint(i, x, y, z) <= radius)
            {
                if(GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid))
                {
                    SendClientMessage(i, COR_CHAT_LOCAL, message);
                }
            }
        }
    }
    
    return 1;
}

// Função para atualizar status do player
stock AtualizarStatusPlayer(playerid)
{
    if(!PlayerInfo[playerid][pLogado]) return 0;
    
    // Diminuir fome e sede gradualmente
    PlayerInfo[playerid][pFome] -= 0.1;
    PlayerInfo[playerid][pSede] -= 0.15;
    PlayerInfo[playerid][pEnergia] -= 0.05;
    
    // Verificar limites
    if(PlayerInfo[playerid][pFome] < 0.0) PlayerInfo[playerid][pFome] = 0.0;
    if(PlayerInfo[playerid][pSede] < 0.0) PlayerInfo[playerid][pSede] = 0.0;
    if(PlayerInfo[playerid][pEnergia] < 0.0) PlayerInfo[playerid][pEnergia] = 0.0;
    
    // Aumentar stress se fome/sede baixas
    if(PlayerInfo[playerid][pFome] < 20.0 || PlayerInfo[playerid][pSede] < 20.0)
    {
        PlayerInfo[playerid][pStress] += 0.2;
        if(PlayerInfo[playerid][pStress] > 100.0) PlayerInfo[playerid][pStress] = 100.0;
    }
    
    // Diminuir vida se fome/sede zeradas
    if(PlayerInfo[playerid][pFome] == 0.0 || PlayerInfo[playerid][pSede] == 0.0)
    {
        new Float:vida;
        GetPlayerHealth(playerid, vida);
        if(vida > 10.0)
        {
            SetPlayerHealth(playerid, vida - 1.0);
        }
    }
    
    return 1;
}

// Função para atualizar HUD do player
stock AtualizarHUDPlayer(playerid)
{
    if(!PlayerInfo[playerid][pLogado]) return 0;
    
    new string[128];
    new Float:vida, Float:colete;
    GetPlayerHealth(playerid, vida);
    GetPlayerArmour(playerid, colete);
    
    // Atualizar vida
    format(string, sizeof(string), "VIDA: %.0f%%", vida);
    TextDrawSetString(TDHud_Vida, string);
    
    // Atualizar colete
    format(string, sizeof(string), "COLETE: %.0f%%", colete);
    TextDrawSetString(TDHud_Colete, string);
    
    // Atualizar fome
    format(string, sizeof(string), "FOME: %.0f%%", PlayerInfo[playerid][pFome]);
    TextDrawSetString(TDHud_Fome, string);
    
    // Atualizar sede
    format(string, sizeof(string), "SEDE: %.0f%%", PlayerInfo[playerid][pSede]);
    TextDrawSetString(TDHud_Sede, string);
    
    // Atualizar dinheiro
    format(string, sizeof(string), "DINHEIRO: R$ %s", 
        FormatarDinheiro(GetPlayerMoney(playerid)));
    TextDrawSetString(TDHud_Dinheiro, string);
    
    // Atualizar level
    format(string, sizeof(string), "LEVEL: %d", PlayerInfo[playerid][pLevel]);
    TextDrawSetString(TDHud_Level, string);
    
    // Atualizar FPS (estimativa baseada no ping)
    new ping = GetPlayerPing(playerid);
    new fps = 60 - (ping / 10); // Estimativa simples
    if(fps < 10) fps = 10;
    if(fps > 60) fps = 60;
    format(string, sizeof(string), "FPS: %d", fps);
    TextDrawSetString(TDHud_FPS, string);
    
    // Atualizar ping
    format(string, sizeof(string), "PING: %d", ping);
    TextDrawSetString(TDHud_Ping, string);
    
    // Atualizar tempo
    format(string, sizeof(string), "%02d:%02d", ServidorHora, ServidorMinuto);
    TextDrawSetString(TDHud_Tempo, string);
    
    // Atualizar data
    new ano, mes, dia;
    getdate(ano, mes, dia);
    format(string, sizeof(string), "%02d/%02d/%d", dia, mes, ano);
    TextDrawSetString(TDHud_Data, string);
    
    // Atualizar speedometer se estiver em veículo
    if(IsPlayerInAnyVehicle(playerid))
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        new Float:velocidade_x, Float:velocidade_y, Float:velocidade_z;
        GetVehicleVelocity(vehicleid, velocidade_x, velocidade_y, velocidade_z);
        
        new velocidade = floatround(floatsqroot(
            velocidade_x * velocidade_x + 
            velocidade_y * velocidade_y + 
            velocidade_z * velocidade_z) * 100.0);
        
        format(string, sizeof(string), "%d KM/H", velocidade);
        TextDrawSetString(TDHud_Velocidade, string);
        
        // Mostrar speedometer
        TextDrawShowForPlayer(playerid, TDHud_Speedometer);
        TextDrawShowForPlayer(playerid, TDHud_Velocidade);
        TextDrawShowForPlayer(playerid, TDHud_Combustivel);
        TextDrawShowForPlayer(playerid, TDHud_KM);
    }
    else
    {
        // Esconder speedometer
        TextDrawHideForPlayer(playerid, TDHud_Speedometer);
        TextDrawHideForPlayer(playerid, TDHud_Velocidade);
        TextDrawHideForPlayer(playerid, TDHud_Combustivel);
        TextDrawHideForPlayer(playerid, TDHud_KM);
    }
    
    return 1;
}

// Função para mostrar HUD do player
stock MostrarHUDPlayer(playerid)
{
    // Mostrar HUD principal
    TextDrawShowForPlayer(playerid, TDHud_Fundo);
    TextDrawShowForPlayer(playerid, TDHud_Vida);
    TextDrawShowForPlayer(playerid, TDHud_Colete);
    TextDrawShowForPlayer(playerid, TDHud_Fome);
    TextDrawShowForPlayer(playerid, TDHud_Sede);
    TextDrawShowForPlayer(playerid, TDHud_Dinheiro);
    TextDrawShowForPlayer(playerid, TDHud_Level);
    TextDrawShowForPlayer(playerid, TDHud_FPS);
    TextDrawShowForPlayer(playerid, TDHud_Ping);
    TextDrawShowForPlayer(playerid, TDHud_Tempo);
    TextDrawShowForPlayer(playerid, TDHud_Data);
    
    return 1;
}

// Função para detectar anti-cheat
stock DetectarAntiCheat(playerid)
{
    // Anti Money Hack
    new dinheiro_atual = GetPlayerMoney(playerid);
    if(dinheiro_atual > PlayerMoneyCheck[playerid] + 1000) // Tolerância de R$ 1000
    {
        new diferenca = dinheiro_atual - PlayerMoneyCheck[playerid];
        ResetPlayerMoney(playerid);
        GivePlayerMoney(playerid, PlayerMoneyCheck[playerid]);
        
        new string[128];
        format(string, sizeof(string), "🛡️ {FF0000}%s foi detectado usando Money Hack! (+R$ %d)", PlayerInfo[playerid][pNome], diferenca);
        SendClientMessageToAll(COR_VERMELHO_ELITE, string);
        printf("[ANTI-CHEAT] %s - Money Hack (+%d)", PlayerInfo[playerid][pNome], diferenca);
    }
    PlayerMoneyCheck[playerid] = dinheiro_atual;
    
    // Anti Health Hack
    new Float:vida_atual;
    GetPlayerHealth(playerid, vida_atual);
    if(floatround(vida_atual) > PlayerHealthCheck[playerid] + 10) // Tolerância de 10 HP
    {
        SetPlayerHealth(playerid, PlayerHealthCheck[playerid]);
        
        new string[128];
        format(string, sizeof(string), "🛡️ {FF0000}%s foi detectado usando Health Hack!", PlayerInfo[playerid][pNome]);
        SendClientMessageToAll(COR_VERMELHO_ELITE, string);
        printf("[ANTI-CHEAT] %s - Health Hack", PlayerInfo[playerid][pNome]);
    }
    PlayerHealthCheck[playerid] = floatround(vida_atual);
    
    return 1;
}

// Função para resetar variáveis do player
stock ResetarVariaveisPlayer(playerid)
{
    PlayerInfo[playerid][pID] = 0;
    PlayerInfo[playerid][pLogado] = 0;
    PlayerInfo[playerid][pRegistrado] = 0;
    PlayerInfo[playerid][pDinheiro] = 5000.0;
    PlayerInfo[playerid][pLevel] = 1;
    PlayerInfo[playerid][pVida] = 100.0;
    PlayerInfo[playerid][pFome] = 100.0;
    PlayerInfo[playerid][pSede] = 100.0;
    PlayerInfo[playerid][pEnergia] = 100.0;
    PlayerInfo[playerid][pStress] = 0.0;
    PlayerInfo[playerid][pSkin] = 26;
    
    // Resetar anti-cheat
    PlayerMoneyCheck[playerid] = 0;
    PlayerHealthCheck[playerid] = 100;
    PlayerSpeedCheck[playerid] = 0;
    
    return 1;
}

// Função para validar senha
stock ValidarSenha(const senha[])
{
    new len = strlen(senha);
    if(len < 6) return 0;
    
    new temLetra = 0, temNumero = 0;
    for(new i = 0; i < len; i++)
    {
        if((senha[i] >= 'A' && senha[i] <= 'Z') || (senha[i] >= 'a' && senha[i] <= 'z')) 
            temLetra = 1;
        if(senha[i] >= '0' && senha[i] <= '9') 
            temNumero = 1;
    }
    
    return (temLetra && temNumero);
}

// Função para validar email
stock ValidarEmail(const email[])
{
    if(strlen(email) < 5) return 0;
    if(strfind(email, "@", true) == -1) return 0;
    if(strfind(email, ".", true) == -1) return 0;
    return 1;
}

// Função para verificar se string está vazia
stock isnull(const string[])
{
    return (strlen(string) == 0);
}

// Função para gerar CPF brasileiro válido
stock GerarCPF(playerid)
{
    new digitos[11];
    
    // Gera os 9 primeiros dígitos
    for(new i = 0; i < 9; i++)
    {
        digitos[i] = random(10);
    }
    
    // Calcula o primeiro dígito verificador
    new soma = 0;
    for(new i = 0; i < 9; i++)
    {
        soma += digitos[i] * (10 - i);
    }
    new resto = soma % 11;
    digitos[9] = (resto < 2) ? 0 : (11 - resto);
    
    // Calcula o segundo dígito verificador
    soma = 0;
    for(new i = 0; i < 10; i++)
    {
        soma += digitos[i] * (11 - i);
    }
    resto = soma % 11;
    digitos[10] = (resto < 2) ? 0 : (11 - resto);
    
    // Formata o CPF
    format(PlayerCPF[playerid], 15, "%d%d%d.%d%d%d.%d%d%d-%d%d",
        digitos[0], digitos[1], digitos[2],
        digitos[3], digitos[4], digitos[5],
        digitos[6], digitos[7], digitos[8],
        digitos[9], digitos[10]);
    
    // Copia para a estrutura do player
    format(PlayerInfo[playerid][pCPF], 15, "%s", PlayerCPF[playerid]);
    
    return 1;
}

// Função para gerar RG brasileiro
stock GerarRG(playerid)
{
    new rg[9];
    for(new i = 0; i < 9; i++)
    {
        rg[i] = random(10);
    }
    
    format(PlayerRG[playerid], 12, "%d%d.%d%d%d.%d%d%d-%d",
        rg[0], rg[1], rg[2], rg[3], rg[4], rg[5], rg[6], rg[7], rg[8]);
    
    // Copia para a estrutura do player
    format(PlayerInfo[playerid][pRG], 12, "%s", PlayerRG[playerid]);
    
    return 1;
}

// Função para criar textdraws globais
stock CriarTextdraws()
{
    // HUD Principal - Fundo
    TDHud_Fundo = TextDrawCreate(498.0, 350.0, "box");
    TextDrawTextSize(TDHud_Fundo, 640.0, 440.0);
    TextDrawUseBox(TDHud_Fundo, 1);
    TextDrawBoxColor(TDHud_Fundo, 0x00000066);
    TextDrawFont(TDHud_Fundo, 1);
    
    // Vida
    TDHud_Vida = TextDrawCreate(505.0, 355.0, "VIDA: 100%");
    TextDrawColor(TDHud_Vida, 0xFF6347FF);
    TextDrawFont(TDHud_Vida, 2);
    TextDrawLetterSize(TDHud_Vida, 0.2, 1.0);
    TextDrawSetOutline(TDHud_Vida, 1);
    
    // Colete
    TDHud_Colete = TextDrawCreate(505.0, 365.0, "COLETE: 0%");
    TextDrawColor(TDHud_Colete, 0x87CEEBFF);
    TextDrawFont(TDHud_Colete, 2);
    TextDrawLetterSize(TDHud_Colete, 0.2, 1.0);
    TextDrawSetOutline(TDHud_Colete, 1);
    
    // Fome
    TDHud_Fome = TextDrawCreate(505.0, 375.0, "FOME: 100%");
    TextDrawColor(TDHud_Fome, 0xFFD700FF);
    TextDrawFont(TDHud_Fome, 2);
    TextDrawLetterSize(TDHud_Fome, 0.2, 1.0);
    TextDrawSetOutline(TDHud_Fome, 1);
    
    // Sede
    TDHud_Sede = TextDrawCreate(505.0, 385.0, "SEDE: 100%");
    TextDrawColor(TDHud_Sede, 0x00BFFFFF);
    TextDrawFont(TDHud_Sede, 2);
    TextDrawLetterSize(TDHud_Sede, 0.2, 1.0);
    TextDrawSetOutline(TDHud_Sede, 1);
    
    // Dinheiro
    TDHud_Dinheiro = TextDrawCreate(505.0, 395.0, "DINHEIRO: R$ 5.000");
    TextDrawColor(TDHud_Dinheiro, 0x32CD32FF);
    TextDrawFont(TDHud_Dinheiro, 2);
    TextDrawLetterSize(TDHud_Dinheiro, 0.2, 1.0);
    TextDrawSetOutline(TDHud_Dinheiro, 1);
    
    // Level
    TDHud_Level = TextDrawCreate(505.0, 405.0, "LEVEL: 1");
    TextDrawColor(TDHud_Level, 0xFFD700FF);
    TextDrawFont(TDHud_Level, 2);
    TextDrawLetterSize(TDHud_Level, 0.2, 1.0);
    TextDrawSetOutline(TDHud_Level, 1);
    
    // FPS
    TDHud_FPS = TextDrawCreate(505.0, 415.0, "FPS: 60");
    TextDrawColor(TDHud_FPS, 0xFFFFFFFF);
    TextDrawFont(TDHud_FPS, 2);
    TextDrawLetterSize(TDHud_FPS, 0.2, 1.0);
    TextDrawSetOutline(TDHud_FPS, 1);
    
    // Ping
    TDHud_Ping = TextDrawCreate(505.0, 425.0, "PING: 0");
    TextDrawColor(TDHud_Ping, 0xFFFFFFFF);
    TextDrawFont(TDHud_Ping, 2);
    TextDrawLetterSize(TDHud_Ping, 0.2, 1.0);
    TextDrawSetOutline(TDHud_Ping, 1);
    
    // Tempo
    TDHud_Tempo = TextDrawCreate(570.0, 50.0, "12:00");
    TextDrawColor(TDHud_Tempo, 0xFFFFFFFF);
    TextDrawFont(TDHud_Tempo, 2);
    TextDrawLetterSize(TDHud_Tempo, 0.3, 1.5);
    TextDrawSetOutline(TDHud_Tempo, 1);
    
    // Data
    TDHud_Data = TextDrawCreate(570.0, 70.0, "01/01/2024");
    TextDrawColor(TDHud_Data, 0xFFFFFFFF);
    TextDrawFont(TDHud_Data, 2);
    TextDrawLetterSize(TDHud_Data, 0.2, 1.0);
    TextDrawSetOutline(TDHud_Data, 1);
    
    // Speedometer
    TDHud_Speedometer = TextDrawCreate(520.0, 300.0, "box");
    TextDrawTextSize(TDHud_Speedometer, 620.0, 340.0);
    TextDrawUseBox(TDHud_Speedometer, 1);
    TextDrawBoxColor(TDHud_Speedometer, 0x00000099);
    TextDrawFont(TDHud_Speedometer, 1);
    
    // Velocidade
    TDHud_Velocidade = TextDrawCreate(570.0, 310.0, "0 KM/H");
    TextDrawColor(TDHud_Velocidade, 0xFFFFFFFF);
    TextDrawFont(TDHud_Velocidade, 2);
    TextDrawLetterSize(TDHud_Velocidade, 0.3, 1.5);
    TextDrawSetOutline(TDHud_Velocidade, 1);
    TextDrawAlignment(TDHud_Velocidade, 2);
    
    // Combustível
    TDHud_Combustivel = TextDrawCreate(530.0, 325.0, "COMBUSTIVEL: 100%");
    TextDrawColor(TDHud_Combustivel, 0xFFD700FF);
    TextDrawFont(TDHud_Combustivel, 2);
    TextDrawLetterSize(TDHud_Combustivel, 0.15, 0.8);
    TextDrawSetOutline(TDHud_Combustivel, 1);
    
    // KM
    TDHud_KM = TextDrawCreate(580.0, 325.0, "KM: 0");
    TextDrawColor(TDHud_KM, 0x87CEEBFF);
    TextDrawFont(TDHud_KM, 2);
    TextDrawLetterSize(TDHud_KM, 0.15, 0.8);
    TextDrawSetOutline(TDHud_KM, 1);
    
    print("✅ Textdraws criados com sucesso!");
    return 1;
}

// Função para criar tabelas do banco
stock CriarTabelasBanco()
{
    mysql_query(conexao, 
        "CREATE TABLE IF NOT EXISTS `jogadores` ("
        "`id` INT AUTO_INCREMENT PRIMARY KEY,"
        "`nome` VARCHAR(24) NOT NULL UNIQUE,"
        "`senha` VARCHAR(65) NOT NULL,"
        "`email` VARCHAR(128),"
        "`cpf` VARCHAR(15),"
        "`rg` VARCHAR(12),"
        "`idade` INT DEFAULT 18,"
        "`sexo` INT DEFAULT 0,"
        "`dinheiro` DECIMAL(15,2) DEFAULT 5000.00,"
        "`banco` INT DEFAULT 0,"
        "`level` INT DEFAULT 1,"
        "`exp` INT DEFAULT 0,"
        "`vida` DECIMAL(5,2) DEFAULT 100.00,"
        "`colete` DECIMAL(5,2) DEFAULT 0.00,"
        "`fome` DECIMAL(5,2) DEFAULT 100.00,"
        "`sede` DECIMAL(5,2) DEFAULT 100.00,"
        "`energia` DECIMAL(5,2) DEFAULT 100.00,"
        "`stress` DECIMAL(5,2) DEFAULT 0.00,"
        "`pos_x` DECIMAL(10,6) DEFAULT 1686.7,"
        "`pos_y` DECIMAL(10,6) DEFAULT -2240.1,"
        "`pos_z` DECIMAL(10,6) DEFAULT 13.5,"
        "`angle` DECIMAL(10,6) DEFAULT 0.0,"
        "`interior` INT DEFAULT 0,"
        "`virtual_world` INT DEFAULT 0,"
        "`skin` INT DEFAULT 26,"
        "`emprego` INT DEFAULT 0,"
        "`faccao` INT DEFAULT 0,"
        "`cargo` INT DEFAULT 0,"
        "`casa` INT DEFAULT 0,"
        "`veiculo` INT DEFAULT 0,"
        "`admin` INT DEFAULT 0,"
        "`vip` INT DEFAULT 0,"
        "`banido` INT DEFAULT 0,"
        "`mutado` INT DEFAULT 0,"
        "`tempo_ban` TIMESTAMP NULL,"
        "`tempo_mute` TIMESTAMP NULL,"
        "`registrado` TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
        ")", false);
    
    print("✅ Tabelas criadas/verificadas com sucesso!");
    return 1;
}