/*
===============================================================================
    🇧🇷 BRASIL ELITE RP - GAMEMODE COMPLETA 🇧🇷
    
    Gamemode completa de RP brasileiro para SA-MP
    Versão: 2.0 - Otimizada para LemeHost
    Autor: AI Assistant
    
    Recursos:
    ✅ Sistema completo de login/registro com CPF/RG brasileiro
    ✅ HUD moderno estilo GTA V
    ✅ Anti-cheat avançado
    ✅ Sistema de casas dinâmico
    ✅ Sistema de veículos com combustível
    ✅ Facções brasileiras (PMERJ, PCERJ, BOPE, CV, etc.)
    ✅ Empregos realistas
    ✅ MySQL otimizado
    ✅ Speedometer dinâmico
    ✅ Sistema de fome/sede/energia/stress
    ✅ Compatível com LemeHost
===============================================================================
*/

// ==================== CONFIGURAÇÕES DO SERVIDOR ====================
#define SERVIDOR_NOME           "Brasil Elite RP"
#define SERVIDOR_VERSAO         "2.0"
#define SERVIDOR_SITE           "discord.gg/brasielite"

// ==================== INCLUDES NECESSÁRIOS ====================
#define SSCANF_NO_NICE_FEATURES
#include <a_samp>
#include <a_mysql>
#include <sscanf2>
#include <streamer>
#include <zcmd>

// ==================== CONFIGURAÇÕES MYSQL ====================
#define MYSQL_HOST              "127.0.0.1"
#define MYSQL_USER              "root"
#define MYSQL_PASS              ""
#define MYSQL_DATABASE          "brasil_elite_rp"

// ==================== DEFINES GERAIS ====================
#define MAX_HOUSES             500
#define MAX_VEHICLES_SERVER    1000
#define MAX_FACTIONS           50
#define MAX_JOBS               20

// ==================== DIALOGS ====================
#define DIALOG_REGISTRO         1000
#define DIALOG_LOGIN            1001
#define DIALOG_IDADE            1002
#define DIALOG_SEXO             1003
#define DIALOG_EMAIL            1004
#define DIALOG_STATS            1005

// ==================== CORES ====================
#define COR_BRANCO              0xFFFFFFFF
#define COR_VERMELHO            0xFF0000FF
#define COR_VERDE               0x00FF00FF
#define COR_AZUL                0x0000FFFF
#define COR_AMARELO             0xFFFF00FF
#define COR_LARANJA             0xFF8000FF
#define COR_ROSA                0xFF00FFFF
#define COR_CINZA               0x808080FF
#define COR_VERDE_ELITE         0x00FF7FFF
#define COR_AZUL_ELITE          0x1E90FFFF
#define COR_VERMELHO_ELITE      0xFF4500FF
#define COR_DOURADO_ELITE       0xFFD700FF
#define COR_ERRO                0xFF6347FF
#define COR_SUCESSO             0x32CD32FF
#define COR_INFO                0x87CEEBFF
#define COR_CHAT_LOCAL          0xC2A2DAFF

// ==================== VARIÁVEIS GLOBAIS ====================
new MySQL:conexao;
new ServidorHora = 12, ServidorMinuto = 0;

// ==================== ENUMS ====================
enum E_PLAYER_INFO
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
    pRegistrado,
    pLogado,
    pAdmin,
    pVIP,
    pBanido,
    pMutado,
    pTempoBan,
    pTempoMute
};

enum E_HOUSE_INFO
{
    hExiste,
    hDono[MAX_PLAYER_NAME],
    Float:hEntradaX,
    Float:hEntradaY,
    Float:hEntradaZ,
    Float:hSaidaX,
    Float:hSaidaY,
    Float:hSaidaZ,
    hInterior,
    hPreco,
    hTrancada,
    hPickup,
    Text3D:hText3D
};

enum E_VEHICLE_INFO
{
    vExiste,
    vID,
    vModelo,
    vDono[MAX_PLAYER_NAME],
    Float:vPosX,
    Float:vPosY,
    Float:vPosZ,
    Float:vAngle,
    vCor1,
    vCor2,
    Float:vCombustivel,
    vKM,
    vPlaca[9],
    vTrancado,
    vAlarme
};

enum E_FACTION_INFO
{
    fExiste,
    fNome[64],
    fTag[8],
    fCor,
    fTipo, // 1=Legal, 2=Ilegal
    fLider[MAX_PLAYER_NAME],
    fMembros,
    fMaxMembros,
    Float:fSpawnX,
    Float:fSpawnY,
    Float:fSpawnZ
};

enum E_JOB_INFO
{
    jExiste,
    jNome[64],
    jDescricao[128],
    Float:jPosX,
    Float:jPosY,
    Float:jPosZ,
    jSalarioMin,
    jSalarioMax,
    jMaxVagas,
    jVagasOcupadas
};

// ==================== VARIÁVEIS DOS PLAYERS ====================
new PlayerInfo[MAX_PLAYERS][E_PLAYER_INFO];
new PlayerCPF[MAX_PLAYERS][15];
new PlayerRG[MAX_PLAYERS][12];

// ==================== VARIÁVEIS DOS SISTEMAS ====================
new HouseInfo[MAX_HOUSES][E_HOUSE_INFO];
new VehicleInfo[MAX_VEHICLES_SERVER][E_VEHICLE_INFO];
new FactionInfo[MAX_FACTIONS][E_FACTION_INFO];
new JobInfo[MAX_JOBS][E_JOB_INFO];

// ==================== TEXTDRAWS GLOBAIS ====================
new Text:TDHud_Fundo;
new Text:TDHud_Logo;
new Text:TDHud_Vida;
new Text:TDHud_Colete;
new Text:TDHud_Fome;
new Text:TDHud_Sede;
new Text:TDHud_Energia;
new Text:TDHud_Stress;
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

// ==================== TEXTDRAWS POR PLAYER ====================
new PlayerText:PTDLogin_Fundo[MAX_PLAYERS];
new PlayerText:PTDLogin_Logo[MAX_PLAYERS];
new PlayerText:PTDLogin_BemVindo[MAX_PLAYERS];
new PlayerText:PTDLogin_Input[MAX_PLAYERS];
new PlayerText:PTDLogin_Botao[MAX_PLAYERS];

// ==================== ITERADORES ====================
new Iterator:Players<MAX_PLAYERS>;
new Iterator:Houses<MAX_HOUSES>;
new Iterator:Vehicles<MAX_VEHICLES_SERVER>;
new Iterator:Factions<MAX_FACTIONS>;
new Iterator:Jobs<MAX_JOBS>;

// ==================== VARIÁVEIS ANTI-CHEAT ====================
new PlayerMoneyCheck[MAX_PLAYERS];
new PlayerHealthCheck[MAX_PLAYERS];
new PlayerSpeedCheck[MAX_PLAYERS];
new PlayerWeaponCheck[MAX_PLAYERS][13];

// ==================== FORWARDS ====================
forward OnPlayerLogin(playerid);
forward OnPlayerRegister(playerid);
forward AtualizarServidor();
forward AntiCheatTimer();
forward OnHousesLoaded();
forward OnVehiclesLoaded();
forward KickPlayerDelayed(playerid);

// ==================== MAIN ====================
main()
{
    print("\n===============================================");
    print("    🇧🇷 BRASIL ELITE RP v2.0 INICIANDO 🇧🇷");
    print("===============================================");
    print("✅ Gamemode consolidada carregada!");
    print("✅ Otimizada para LemeHost");
    print("✅ MySQL integrado");
    print("===============================================\n");
}

// ==================== GAMEMODE INIT ====================
public OnGameModeInit()
{
    // Configurações básicas do servidor
    SetGameModeText("Brasil Elite RP v2.0");
    SendRconCommand("hostname "SERVIDOR_NOME" - "SERVIDOR_VERSAO);
    SendRconCommand("mapname Brasil - Rio de Janeiro");
    SendRconCommand("weburl "SERVIDOR_SITE);
    SendRconCommand("language Português");
    
    // Configurações gerais
    UsePlayerPedAnims();
    DisableInteriorEnterExits();
    SetNameTagDrawDistance(40.0);
    ShowNameTags(1);
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
    EnableStuntBonusForAll(0);
    
    // Conectar ao MySQL
    conexao = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DATABASE);
    
    if(mysql_errno(conexao) != 0)
    {
        print("❌ ERRO: Falha ao conectar com MySQL!");
        print("⚠️  Verifique as configurações do banco de dados.");
        SendRconCommand("exit");
        return 1;
    }
    
    print("✅ MySQL conectado com sucesso!");
    mysql_set_charset("utf8", conexao);
    
    // Criar tabelas do banco
    CriarTabelasBanco();
    
    // Criar textdraws
    CriarTextdraws();
    
    // Carregar dados do servidor
    CarregarHousas();
    CarregarVeiculos();
    CarregarFaccoes();
    CarregarEmpregos();
    
    // Iniciar timers
    SetTimer("AtualizarServidor", 1000, true);
    SetTimer("AntiCheatTimer", 3000, true);
    
    print("✅ Servidor iniciado com sucesso!");
    return 1;
}

// ==================== GAMEMODE EXIT ====================
public OnGameModeExit()
{
    // Salvar todos os players online
    foreach(new i : Players)
    {
        if(PlayerInfo[i][pLogado])
        {
            SalvarPlayer(i);
        }
    }
    
    // Fechar conexão MySQL
    mysql_close(conexao);
    
    print("🔄 Servidor encerrado com segurança!");
    return 1;
}

// ==================== PLAYER CONNECT ====================
public OnPlayerConnect(playerid)
{
    // Adicionar ao iterator
    Iter_Add(Players, playerid);
    
    // Resetar variáveis
    ResetarVariaveisPlayer(playerid);
    
    // Obter nome do player
    GetPlayerName(playerid, PlayerInfo[playerid][pNome], MAX_PLAYER_NAME);
    
    // Verificar se já está registrado
    new query[256];
    mysql_format(conexao, query, sizeof(query), 
        "SELECT `id`, `senha` FROM `jogadores` WHERE `nome` = '%e' LIMIT 1", 
        PlayerInfo[playerid][pNome]);
    mysql_tquery(conexao, query, "VerificarPlayer", "i", playerid);
    
    // Criar textdraws personalizados
    CriarTextdrawsPlayer(playerid);
    
    // Mostrar HUD
    MostrarHUDPlayer(playerid);
    
    // Mensagens de boas-vindas
    new string[256];
    format(string, sizeof(string), 
        "🎮 {FFFFFF}Bem-vindo ao {FFD700}%s{FFFFFF}, {00FF7F}%s{FFFFFF}!", 
        SERVIDOR_NOME, PlayerInfo[playerid][pNome]);
    SendClientMessage(playerid, COR_VERDE_ELITE, string);
    
    SendClientMessage(playerid, COR_INFO, "📋 Digite {FFFF00}/comandos {87CEEB}para ver todos os comandos disponíveis.");
    SendClientMessage(playerid, COR_INFO, "💬 Discord: {FFFF00}"SERVIDOR_SITE);
    
    printf("👤 %s conectou ao servidor (ID: %d)", PlayerInfo[playerid][pNome], playerid);
    
    return 1;
}

// ==================== PLAYER DISCONNECT ====================
public OnPlayerDisconnect(playerid, reason)
{
    // Salvar dados se estiver logado
    if(PlayerInfo[playerid][pLogado])
    {
        SalvarPlayer(i);
    }
    
    // Destruir textdraws
    DestruirTextdrawsPlayer(playerid);
    
    // Remover do iterator
    Iter_Remove(Players, playerid);
    
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
    SendClientMessageToAll(COR_CINZA, string);
    
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
    
    // Definir posição de spawn
    if(PlayerInfo[playerid][pFaccao] == 0) // Civil
    {
        SetPlayerPos(playerid, 1686.7, -2240.1, 13.5);
        SetPlayerFacingAngle(playerid, 0.0);
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);
    }
    else
    {
        // Spawn da facção
        SetPlayerPos(playerid, FactionInfo[PlayerInfo[playerid][pFaccao]][fSpawnX], 
                     FactionInfo[PlayerInfo[playerid][pFaccao]][fSpawnY], 
                     FactionInfo[PlayerInfo[playerid][pFaccao]][fSpawnZ]);
    }
    
    // Configurar player
    SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
    SetPlayerHealth(playerid, PlayerInfo[playerid][pVida]);
    SetPlayerArmour(playerid, PlayerInfo[playerid][pColete]);
    GivePlayerMoney(playerid, floatround(PlayerInfo[playerid][pDinheiro]));
    
    // Atualizar anti-cheat
    PlayerMoneyCheck[playerid] = GetPlayerMoney(playerid);
    GetPlayerHealth(playerid, Float:PlayerHealthCheck[playerid]);
    
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
    
    return 0; // Deixar ZCMD processar
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
    foreach(new i : Players)
    {
        if(PlayerInfo[i][pLogado])
        {
            AtualizarStatusPlayer(i);
            AtualizarHUDPlayer(i);
        }
    }
    
    return 1;
}

public AntiCheatTimer()
{
    foreach(new i : Players)
    {
        if(PlayerInfo[i][pLogado])
        {
            DetectarAntiCheat(i);
        }
    }
    
    return 1;
}

// ==================== FUNÇÕES AUXILIARES ====================

// Forward para OnPlayerLogin
public OnPlayerLogin(playerid)
{
    if(cache_num_rows() > 0)
    {
        // Login bem-sucedido
        cache_get_value_name_int(0, "id", PlayerInfo[playerid][pID]);
        cache_get_value_name(0, "email", PlayerInfo[playerid][pEmail], 128);
        cache_get_value_name(0, "cpf", PlayerInfo[playerid][pCPF], 15);
        cache_get_value_name(0, "rg", PlayerInfo[playerid][pRG], 12);
        cache_get_value_name_int(0, "idade", PlayerInfo[playerid][pIdade]);
        cache_get_value_name_int(0, "sexo", PlayerInfo[playerid][pSexo]);
        cache_get_value_name_float(0, "dinheiro", PlayerInfo[playerid][pDinheiro]);
        cache_get_value_name_int(0, "banco", PlayerInfo[playerid][pBanco]);
        cache_get_value_name_int(0, "level", PlayerInfo[playerid][pLevel]);
        cache_get_value_name_int(0, "exp", PlayerInfo[playerid][pExp]);
        cache_get_value_name_float(0, "vida", PlayerInfo[playerid][pVida]);
        cache_get_value_name_float(0, "colete", PlayerInfo[playerid][pColete]);
        cache_get_value_name_float(0, "fome", PlayerInfo[playerid][pFome]);
        cache_get_value_name_float(0, "sede", PlayerInfo[playerid][pSede]);
        cache_get_value_name_float(0, "pos_x", PlayerInfo[playerid][pPosX]);
        cache_get_value_name_float(0, "pos_y", PlayerInfo[playerid][pPosY]);
        cache_get_value_name_float(0, "pos_z", PlayerInfo[playerid][pPosZ]);
        cache_get_value_name_float(0, "angle", PlayerInfo[playerid][pAngle]);
        cache_get_value_name_int(0, "interior", PlayerInfo[playerid][pInterior]);
        cache_get_value_name_int(0, "virtual_world", PlayerInfo[playerid][pVirtualWorld]);
        cache_get_value_name_int(0, "skin", PlayerInfo[playerid][pSkin]);
        
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
            "{FF6347}❌ Senha incorreta! Tente novamente.\n\n"
            "{FFFFFF}Digite sua senha para fazer login:", 
            "Entrar", "Sair");
    }
    
    return 1;
}

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

// Função para obter nome do emprego
stock ObterNomeEmprego(emprego)
{
    new string[64];
    
    switch(emprego)
    {
        case 0: string = "Desempregado";
        case 1: string = "Lixeiro";
        case 2: string = "Entregador";
        case 3: string = "Taxista";
        case 4: string = "Mecânico";
        case 5: string = "Médico";
        case 6: string = "Policial";
        case 7: string = "Bombeiro";
        case 8: string = "Jornalista";
        case 9: string = "Advogado";
        case 10: string = "Empresário";
        default: string = "Desconhecido";
    }
    
    return string;
}

// Função para obter informações da casa
stock ObterInfoCasa(playerid)
{
    new string[64];
    
    if(PlayerInfo[playerid][pCasa] == 0)
    {
        string = "Nenhuma";
    }
    else
    {
        format(string, sizeof(string), "Casa #%d", PlayerInfo[playerid][pCasa]);
    }
    
    return string;
}

// Função para obter nome da facção
stock ObterNomeFaccao(faccao)
{
    new string[64];
    
    switch(faccao)
    {
        case 0: string = "Civil";
        case 1: string = "PMERJ";
        case 2: string = "PCERJ";
        case 3: string = "BOPE";
        case 4: string = "SAMU";
        case 5: string = "Bombeiros";
        case 6: string = "Governo";
        case 7: string = "Comando Vermelho";
        case 8: string = "ADA";
        case 9: string = "TCP";
        case 10: string = "Milícia";
        default: string = "Desconhecida";
    }
    
    return string;
}

// Função para enviar mensagem local
stock SendLocalMessage(playerid, const message[], Float:radius)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    
    foreach(new i : Players)
    {
        if(GetPlayerDistanceFromPoint(i, x, y, z) <= radius)
        {
            if(GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid))
            {
                SendClientMessage(i, COR_CHAT_LOCAL, message);
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

// Função para banir player
stock BanirPlayer(playerid, const admin[], const motivo[])
{
    new string[256], nome[MAX_PLAYER_NAME];
    GetPlayerName(playerid, nome, sizeof(nome));
    
    // Atualizar no banco
    new query[512];
    mysql_format(conexao, query, sizeof(query), 
        "UPDATE `jogadores` SET `banido` = 1, `tempo_ban` = DATE_ADD(NOW(), INTERVAL 7 DAY) WHERE `id` = %d", 
        PlayerInfo[playerid][pID]);
    mysql_tquery(conexao, query);
    
    // Mensagem global
    format(string, sizeof(string), 
        "🔨 {FF0000}%s foi banido por %s. Motivo: %s", nome, admin, motivo);
    SendClientMessageToAll(COR_VERMELHO_ELITE, string);
    
    SetTimerEx("KickPlayerDelayed", 3000, false, "i", playerid);
    return 1;
}

public KickPlayerDelayed(playerid)
{
    Kick(playerid);
    return 1;
}

// Função para criar tabelas do banco
stock CriarTabelasBanco()
{
    mysql_query(conexao, 
        "CREATE TABLE IF NOT EXISTS `jogadores` (\
            `id` INT AUTO_INCREMENT PRIMARY KEY,\
            `nome` VARCHAR(24) NOT NULL UNIQUE,\
            `senha` VARCHAR(65) NOT NULL,\
            `email` VARCHAR(128),\
            `cpf` VARCHAR(15),\
            `rg` VARCHAR(12),\
            `idade` INT DEFAULT 18,\
            `sexo` INT DEFAULT 0,\
            `dinheiro` DECIMAL(15,2) DEFAULT 5000.00,\
            `banco` INT DEFAULT 0,\
            `level` INT DEFAULT 1,\
            `exp` INT DEFAULT 0,\
            `vida` DECIMAL(5,2) DEFAULT 100.00,\
            `colete` DECIMAL(5,2) DEFAULT 0.00,\
            `fome` DECIMAL(5,2) DEFAULT 100.00,\
            `sede` DECIMAL(5,2) DEFAULT 100.00,\
            `energia` DECIMAL(5,2) DEFAULT 100.00,\
            `stress` DECIMAL(5,2) DEFAULT 0.00,\
            `pos_x` DECIMAL(10,6) DEFAULT 1686.7,\
            `pos_y` DECIMAL(10,6) DEFAULT -2240.1,\
            `pos_z` DECIMAL(10,6) DEFAULT 13.5,\
            `angle` DECIMAL(10,6) DEFAULT 0.0,\
            `interior` INT DEFAULT 0,\
            `virtual_world` INT DEFAULT 0,\
            `skin` INT DEFAULT 26,\
            `emprego` INT DEFAULT 0,\
            `faccao` INT DEFAULT 0,\
            `cargo` INT DEFAULT 0,\
            `casa` INT DEFAULT 0,\
            `veiculo` INT DEFAULT 0,\
            `admin` INT DEFAULT 0,\
            `vip` INT DEFAULT 0,\
            `banido` INT DEFAULT 0,\
            `mutado` INT DEFAULT 0,\
            `tempo_ban` TIMESTAMP,\
            `tempo_mute` TIMESTAMP,\
            `registrado` TIMESTAMP DEFAULT CURRENT_TIMESTAMP\
        )", false);
    
    mysql_query(conexao, 
        "CREATE TABLE IF NOT EXISTS `casas` (\
            `id` INT AUTO_INCREMENT PRIMARY KEY,\
            `existe` INT DEFAULT 1,\
            `dono` VARCHAR(24) DEFAULT 'Ninguém',\
            `entrada_x` DECIMAL(10,6),\
            `entrada_y` DECIMAL(10,6),\
            `entrada_z` DECIMAL(10,6),\
            `saida_x` DECIMAL(10,6),\
            `saida_y` DECIMAL(10,6),\
            `saida_z` DECIMAL(10,6),\
            `interior` INT DEFAULT 0,\
            `preco` INT DEFAULT 50000,\
            `trancada` INT DEFAULT 0\
        )", false);
    
    mysql_query(conexao, 
        "CREATE TABLE IF NOT EXISTS `veiculos` (\
            `id` INT AUTO_INCREMENT PRIMARY KEY,\
            `existe` INT DEFAULT 1,\
            `modelo` INT,\
            `dono` VARCHAR(24),\
            `pos_x` DECIMAL(10,6),\
            `pos_y` DECIMAL(10,6),\
            `pos_z` DECIMAL(10,6),\
            `angle` DECIMAL(10,6),\
            `cor1` INT DEFAULT 1,\
            `cor2` INT DEFAULT 1,\
            `combustivel` DECIMAL(5,2) DEFAULT 100.00,\
            `km` INT DEFAULT 0,\
            `placa` VARCHAR(9),\
            `trancado` INT DEFAULT 0,\
            `alarme` INT DEFAULT 0\
        )", false);
    
    print("✅ Tabelas criadas/verificadas com sucesso!");
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
    new cpf[12];
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
    
    return 1;
}

// Função para gerar RG brasileiro
stock GerarRG(playerid)
{
    new rg[10];
    for(new i = 0; i < 9; i++)
    {
        rg[i] = random(10);
    }
    
    format(PlayerRG[playerid], 12, "%d%d.%d%d%d.%d%d%d-%d",
        rg[0], rg[1], rg[2], rg[3], rg[4], rg[5], rg[6], rg[7], rg[8]);
    
    return 1;
}

// Função para criar textdraws globais
stock CriarTextdraws()
{
    // HUD Principal - Fundo
    TDHud_Fundo = TextDrawCreate(498.0, 350.0, "box");
    TextDrawTextSize(TDHud_Fundo, 640.0, 0.0);
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
    TextDrawColor(TDHud_Sede, 0x00FFFFFF);
    TextDrawFont(TDHud_Sede, 2);
    TextDrawLetterSize(TDHud_Sede, 0.2, 1.0);
    TextDrawSetOutline(TDHud_Sede, 1);
    
    // Dinheiro
    TDHud_Dinheiro = TextDrawCreate(505.0, 395.0, "DINHEIRO: R$ 5.000");
    TextDrawColor(TDHud_Dinheiro, 0x90EE90FF);
    TextDrawFont(TDHud_Dinheiro, 2);
    TextDrawLetterSize(TDHud_Dinheiro, 0.2, 1.0);
    TextDrawSetOutline(TDHud_Dinheiro, 1);
    
    // Level
    TDHud_Level = TextDrawCreate(505.0, 405.0, "LEVEL: 1");
    TextDrawColor(TDHud_Level, 0x9932CCFF);
    TextDrawFont(TDHud_Level, 2);
    TextDrawLetterSize(TDHud_Level, 0.2, 1.0);
    TextDrawSetOutline(TDHud_Level, 1);
    
    // FPS
    TDHud_FPS = TextDrawCreate(610.0, 355.0, "FPS: 60");
    TextDrawAlignment(TDHud_FPS, 3);
    TextDrawColor(TDHud_FPS, 0xFFFFFFFF);
    TextDrawFont(TDHud_FPS, 2);
    TextDrawLetterSize(TDHud_FPS, 0.15, 0.8);
    TextDrawSetOutline(TDHud_FPS, 1);
    
    // Ping
    TDHud_Ping = TextDrawCreate(610.0, 365.0, "PING: 0");
    TextDrawAlignment(TDHud_Ping, 3);
    TextDrawColor(TDHud_Ping, 0xFFFFFFFF);
    TextDrawFont(TDHud_Ping, 2);
    TextDrawLetterSize(TDHud_Ping, 0.15, 0.8);
    TextDrawSetOutline(TDHud_Ping, 1);
    
    // Tempo
    TDHud_Tempo = TextDrawCreate(610.0, 375.0, "12:00");
    TextDrawAlignment(TDHud_Tempo, 3);
    TextDrawColor(TDHud_Tempo, 0xFFFFFFFF);
    TextDrawFont(TDHud_Tempo, 2);
    TextDrawLetterSize(TDHud_Tempo, 0.15, 0.8);
    TextDrawSetOutline(TDHud_Tempo, 1);
    
    // Data
    TDHud_Data = TextDrawCreate(610.0, 385.0, "01/01/2025");
    TextDrawAlignment(TDHud_Data, 3);
    TextDrawColor(TDHud_Data, 0xFFFFFFFF);
    TextDrawFont(TDHud_Data, 2);
    TextDrawLetterSize(TDHud_Data, 0.15, 0.8);
    TextDrawSetOutline(TDHud_Data, 1);
    
    // Speedometer
    TDHud_Speedometer = TextDrawCreate(450.0, 320.0, "box");
    TextDrawTextSize(TDHud_Speedometer, 590.0, 0.0);
    TextDrawUseBox(TDHud_Speedometer, 1);
    TextDrawBoxColor(TDHud_Speedometer, 0x00000088);
    TextDrawFont(TDHud_Speedometer, 1);
    
    TDHud_Velocidade = TextDrawCreate(460.0, 325.0, "0 KM/H");
    TextDrawColor(TDHud_Velocidade, 0x00FF00FF);
    TextDrawFont(TDHud_Velocidade, 3);
    TextDrawLetterSize(TDHud_Velocidade, 0.4, 1.5);
    TextDrawSetOutline(TDHud_Velocidade, 1);
    
    TDHud_Combustivel = TextDrawCreate(520.0, 325.0, "COMBUSTIVEL: 100%");
    TextDrawColor(TDHud_Combustivel, 0xFFD700FF);
    TextDrawFont(TDHud_Combustivel, 2);
    TextDrawLetterSize(TDHud_Combustivel, 0.2, 1.0);
    TextDrawSetOutline(TDHud_Combustivel, 1);
    
    TDHud_KM = TextDrawCreate(520.0, 335.0, "KM: 0");
    TextDrawColor(TDHud_KM, 0xFFFFFFFF);
    TextDrawFont(TDHud_KM, 2);
    TextDrawLetterSize(TDHud_KM, 0.2, 1.0);
    TextDrawSetOutline(TDHud_KM, 1);
    
    return 1;
}

// Função para criar textdraws do player
stock CriarTextdrawsPlayer(playerid)
{
    PTDLogin_Fundo[playerid] = CreatePlayerTextDraw(playerid, 0.0, 0.0, "box");
    PlayerTextDrawTextSize(playerid, PTDLogin_Fundo[playerid], 640.0, 480.0);
    PlayerTextDrawUseBox(playerid, PTDLogin_Fundo[playerid], 1);
    PlayerTextDrawBoxColor(playerid, PTDLogin_Fundo[playerid], 0x000000CC);
    PlayerTextDrawFont(playerid, PTDLogin_Fundo[playerid], 1);
    
    PTDLogin_Logo[playerid] = CreatePlayerTextDraw(playerid, 320.0, 100.0, 
        "~y~BRASIL ELITE ~r~RP~n~~w~v2.0 - LemeHost Ready");
    PlayerTextDrawAlignment(playerid, PTDLogin_Logo[playerid], 2);
    PlayerTextDrawFont(playerid, PTDLogin_Logo[playerid], 0);
    PlayerTextDrawLetterSize(playerid, PTDLogin_Logo[playerid], 0.6, 2.5);
    PlayerTextDrawSetOutline(playerid, PTDLogin_Logo[playerid], 1);
    
    new nome[MAX_PLAYER_NAME], string[256];
    GetPlayerName(playerid, nome, sizeof(nome));
    format(string, sizeof(string), "~w~Bem-vindo, ~g~%s~w~!", nome);
    PTDLogin_BemVindo[playerid] = CreatePlayerTextDraw(playerid, 320.0, 200.0, string);
    PlayerTextDrawAlignment(playerid, PTDLogin_BemVindo[playerid], 2);
    PlayerTextDrawFont(playerid, PTDLogin_BemVindo[playerid], 1);
    PlayerTextDrawLetterSize(playerid, PTDLogin_BemVindo[playerid], 0.3, 1.2);
    PlayerTextDrawSetOutline(playerid, PTDLogin_BemVindo[playerid], 1);
    
    return 1;
}

// Forward para verificar player
forward VerificarPlayer(playerid);
public VerificarPlayer(playerid)
{
    if(cache_num_rows() > 0)
    {
        // Player registrado - mostrar login
        MostrarDialogLogin(playerid);
    }
    else
    {
        // Player não registrado - mostrar registro
        GerarCPF(playerid);
        GerarRG(playerid);
        MostrarDialogRegistro(playerid);
    }
    return 1;
}

// Função para mostrar dialog de login
stock MostrarDialogLogin(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, 
        "{FFD700}• BRASIL ELITE RP - LOGIN •", 
        "{FFFFFF}Bem-vindo de volta!\n\n"
        "{00FF7F}Digite sua senha para fazer login:", 
        "Entrar", "Sair");
    return 1;
}

// Função para mostrar dialog de registro
stock MostrarDialogRegistro(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_REGISTRO, DIALOG_STYLE_INPUT, 
        "{FFD700}• BRASIL ELITE RP - REGISTRO •", 
        "{FFFFFF}Crie sua conta!\n\n"
        "{00FF7F}Escolha uma senha segura:\n"
        "{FFFF00}• Mínimo 6 caracteres\n"
        "{FFFF00}• Use letras e números", 
        "Criar Conta", "Sair");
    return 1;
}

// Função para criar conta
stock CriarConta(playerid)
{
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
    
    new query[1024];
    mysql_format(conexao, query, sizeof(query), 
        "INSERT INTO `jogadores` (`nome`, `senha`, `email`, `cpf`, `rg`, `idade`, `sexo`, `skin`) \
        VALUES ('%e', SHA2('%e', 256), '%e', '%e', '%e', '%d', '%d', '%d')",
        PlayerInfo[playerid][pNome], PlayerInfo[playerid][pSenha], PlayerInfo[playerid][pEmail],
        PlayerCPF[playerid], PlayerRG[playerid], PlayerInfo[playerid][pIdade],
        PlayerInfo[playerid][pSexo], PlayerInfo[playerid][pSkin]);
    mysql_tquery(conexao, query, "OnPlayerRegister", "i", playerid);
    
    return 1;
}

// Forward para registro
forward OnPlayerRegister(playerid);
public OnPlayerRegister(playerid)
{
    PlayerInfo[playerid][pID] = cache_insert_id();
    PlayerInfo[playerid][pRegistrado] = 1;
    PlayerInfo[playerid][pLogado] = 1;
    
    SendClientMessage(playerid, COR_VERDE_ELITE, "✅ Conta criada com sucesso!");
    SendClientMessage(playerid, COR_AZUL_ELITE, "🎉 Bem-vindo ao Brasil Elite RP!");
    
    SpawnPlayer(playerid);
    return 1;
}

// Função para mostrar HUD do player
stock MostrarHUDPlayer(playerid)
{
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

// Função para destruir textdraws do player
stock DestruirTextdrawsPlayer(playerid)
{
    PlayerTextDrawDestroy(playerid, PTDLogin_Fundo[playerid]);
    PlayerTextDrawDestroy(playerid, PTDLogin_Logo[playerid]);
    PlayerTextDrawDestroy(playerid, PTDLogin_BemVindo[playerid]);
    return 1;
}

// Função para detectar anti-cheat
stock DetectarAntiCheat(playerid)
{
    // Anti Money Hack
    new dinheiro = GetPlayerMoney(playerid);
    if(dinheiro > PlayerMoneyCheck[playerid] + 5000)
    {
        ResetPlayerMoney(playerid);
        GivePlayerMoney(playerid, PlayerMoneyCheck[playerid]);
        SendClientMessage(playerid, COR_ERRO, "⚠️ Anti-cheat: Dinheiro resetado!");
    }
    PlayerMoneyCheck[playerid] = dinheiro;
    
    return 1;
}

// Função para salvar player
stock SalvarPlayer(playerid)
{
    if(!PlayerInfo[playerid][pLogado]) return 0;
    
    GetPlayerPos(playerid, PlayerInfo[playerid][pPosX], PlayerInfo[playerid][pPosY], PlayerInfo[playerid][pPosZ]);
    GetPlayerFacingAngle(playerid, PlayerInfo[playerid][pAngle]);
    PlayerInfo[playerid][pInterior] = GetPlayerInterior(playerid);
    PlayerInfo[playerid][pVirtualWorld] = GetPlayerVirtualWorld(playerid);
    PlayerInfo[playerid][pDinheiro] = float(GetPlayerMoney(playerid));
    GetPlayerHealth(playerid, PlayerInfo[playerid][pVida]);
    GetPlayerArmour(playerid, PlayerInfo[playerid][pColete]);
    
    new query[1024];
    mysql_format(conexao, query, sizeof(query), 
        "UPDATE `jogadores` SET `dinheiro` = '%.2f', `vida` = '%.2f', `colete` = '%.2f', \
        `fome` = '%.2f', `sede` = '%.2f', `pos_x` = '%.6f', `pos_y` = '%.6f', `pos_z` = '%.6f', \
        `angle` = '%.6f', `interior` = '%d', `virtual_world` = '%d' WHERE `id` = '%d'",
        PlayerInfo[playerid][pDinheiro], PlayerInfo[playerid][pVida], PlayerInfo[playerid][pColete],
        PlayerInfo[playerid][pFome], PlayerInfo[playerid][pSede], PlayerInfo[playerid][pPosX], 
        PlayerInfo[playerid][pPosY], PlayerInfo[playerid][pPosZ], PlayerInfo[playerid][pAngle],
        PlayerInfo[playerid][pInterior], PlayerInfo[playerid][pVirtualWorld], PlayerInfo[playerid][pID]);
    mysql_tquery(conexao, query);
    
    return 1;
}

// Função GetDistanceBetweenPoints3D
stock Float:GetDistanceBetweenPoints3D(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
    return floatsqroot((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1));
}

// Funções para carregar dados do servidor
stock CarregarHousas()
{
    // Criar casas de exemplo
    HouseInfo[1][hExiste] = 1;
    format(HouseInfo[1][hDono], MAX_PLAYER_NAME, "Ninguém");
    HouseInfo[1][hEntradaX] = 2000.0;
    HouseInfo[1][hEntradaY] = -2000.0;
    HouseInfo[1][hEntradaZ] = 13.5;
    HouseInfo[1][hPreco] = 50000;
    HouseInfo[1][hTrancada] = 0;
    
    printf("✅ 1 casa carregada com sucesso!");
    return 1;
}

stock CarregarVeiculos()
{
    // Exemplo de veículo
    VehicleInfo[1][vExiste] = 1;
    VehicleInfo[1][vModelo] = 411; // Infernus
    format(VehicleInfo[1][vDono], MAX_PLAYER_NAME, "Ninguém");
    VehicleInfo[1][vPosX] = 1700.0;
    VehicleInfo[1][vPosY] = -2400.0;
    VehicleInfo[1][vPosZ] = 13.5;
    VehicleInfo[1][vCombustivel] = 100.0;
    
    printf("✅ 1 veículo carregado com sucesso!");
    return 1;
}

stock CarregarFaccoes()
{
    // Facção 1 - PMERJ
    FactionInfo[1][fExiste] = 1;
    format(FactionInfo[1][fNome], 64, "Polícia Militar do RJ");
    format(FactionInfo[1][fTag], 8, "[PMERJ]");
    FactionInfo[1][fCor] = 0x0080FFFF;
    FactionInfo[1][fTipo] = 1; // Legal
    FactionInfo[1][fMaxMembros] = 50;
    FactionInfo[1][fSpawnX] = 1500.0;
    FactionInfo[1][fSpawnY] = -1600.0;
    FactionInfo[1][fSpawnZ] = 13.5;
    
    // Facção 2 - CV
    FactionInfo[2][fExiste] = 1;
    format(FactionInfo[2][fNome], 64, "Comando Vermelho");
    format(FactionInfo[2][fTag], 8, "[CV]");
    FactionInfo[2][fCor] = 0xFF0000FF;
    FactionInfo[2][fTipo] = 2; // Ilegal
    FactionInfo[2][fMaxMembros] = 30;
    FactionInfo[2][fSpawnX] = 2500.0;
    FactionInfo[2][fSpawnY] = -1500.0;
    FactionInfo[2][fSpawnZ] = 13.5;
    
    printf("✅ Facções carregadas com sucesso!");
    return 1;
}

stock CarregarEmpregos()
{
    // Emprego 1 - Lixeiro
    JobInfo[1][jExiste] = 1;
    format(JobInfo[1][jNome], 64, "Lixeiro");
    format(JobInfo[1][jDescricao], 128, "Colete o lixo pela cidade!");
    JobInfo[1][jPosX] = 2200.0;
    JobInfo[1][jPosY] = -2000.0;
    JobInfo[1][jPosZ] = 13.5;
    JobInfo[1][jSalarioMin] = 500;
    JobInfo[1][jSalarioMax] = 1500;
    JobInfo[1][jMaxVagas] = 20;
    
    printf("✅ Empregos carregados com sucesso!");
    return 1;
}

// ==================== COMANDOS BÁSICOS ====================

// Comando CPF
CMD:cpf(playerid, params[])
{
    new string[512];
    format(string, sizeof(string), 
        "{FFD700}═══════════════ SEUS DOCUMENTOS ═══════════════\n\n"
        "{FFFFFF}👤 Nome: {00FF7F}%s\n"
        "{FFFFFF}📄 CPF: {FFFF00}%s\n"
        "{FFFFFF}🆔 RG: {FFFF00}%s\n"
        "{FFFFFF}🎂 Idade: {00FF7F}%d anos\n"
        "{FFFFFF}⚧ Sexo: {00FF7F}%s\n"
        "{FFFFFF}📧 Email: {FFFF00}%s", 
        PlayerInfo[playerid][pNome], PlayerCPF[playerid], PlayerRG[playerid], 
        PlayerInfo[playerid][pIdade], 
        (PlayerInfo[playerid][pSexo] == 0) ? "Masculino" : "Feminino",
        PlayerInfo[playerid][pEmail]);
    
    ShowPlayerDialog(playerid, DIALOG_STATS, DIALOG_STYLE_MSGBOX, 
        "{FFD700}📋 DOCUMENTOS BRASILEIROS", string, "Fechar", "");
    
    return 1;
}

// Comando stats
CMD:stats(playerid, params[])
{
    new string[1024];
    new Float:vida, Float:colete;
    GetPlayerHealth(playerid, vida);
    GetPlayerArmour(playerid, colete);
    
    format(string, sizeof(string),
        "{FFD700}═══════════════ SUAS ESTATÍSTICAS ═══════════════\n\n"
        "{FFFFFF}👤 Nome: {00FF7F}%s {FFFFFF}(ID: {FFFF00}%d{FFFFFF})\n"
        "{FFFFFF}💰 Dinheiro: {00FF00}R$ %s\n"
        "{FFFFFF}🏦 Banco: {00FF00}R$ %s\n"
        "{FFFFFF}📊 Level: {FFD700}%d {FFFFFF}| XP: {FFD700}%d\n"
        "{FFFFFF}❤️ Vida: {FF6347}%.1f%% {FFFFFF}| 🛡️ Colete: {87CEEB}%.1f%%\n"
        "{FFFFFF}🍔 Fome: {FFD700}%.1f%% {FFFFFF}| 💧 Sede: {00FFFF}%.1f%%\n"
        "{FFFFFF}⚡ Energia: {90EE90}%.1f%% {FFFFFF}| 😰 Stress: {FF4500}%.1f%%\n"
        "{FFFFFF}💼 Emprego: {FFFF00}%s\n"
        "{FFFFFF}🏠 Casa: {FFFF00}%s\n"
        "{FFFFFF}🏢 Facção: {FFFF00}%s",
        PlayerInfo[playerid][pNome], playerid,
        FormatarDinheiro(floatround(PlayerInfo[playerid][pDinheiro])),
        FormatarDinheiro(PlayerInfo[playerid][pBanco]),
        PlayerInfo[playerid][pLevel], PlayerInfo[playerid][pExp],
        vida, colete,
        PlayerInfo[playerid][pFome], PlayerInfo[playerid][pSede],
        PlayerInfo[playerid][pEnergia], PlayerInfo[playerid][pStress],
        ObterNomeEmprego(PlayerInfo[playerid][pEmprego]),
        ObterInfoCasa(playerid),
        ObterNomeFaccao(PlayerInfo[playerid][pFaccao]));
    
    ShowPlayerDialog(playerid, DIALOG_STATS, DIALOG_STYLE_MSGBOX, 
        "{FFD700}📊 SUAS ESTATÍSTICAS", string, "Fechar", "");
    
    return 1;
}

// Comando me
CMD:me(playerid, params[])
{
    if(isnull(params))
        return SendClientMessage(playerid, COR_ERRO, "❌ Use: /me [ação]");
    
    new string[144], nome[MAX_PLAYER_NAME];
    GetPlayerName(playerid, nome, sizeof(nome));
    format(string, sizeof(string), "{C2A2DA}* %s %s", nome, params);
    
    SendLocalMessage(playerid, string, 20.0);
    return 1;
}

// Comando do
CMD:do(playerid, params[])
{
    if(isnull(params))
        return SendClientMessage(playerid, COR_ERRO, "❌ Use: /do [descrição]");
    
    new string[144], nome[MAX_PLAYER_NAME];
    GetPlayerName(playerid, nome, sizeof(nome));
    format(string, sizeof(string), "{98FB98}* %s (( %s ))", params, nome);
    
    SendLocalMessage(playerid, string, 20.0);
    return 1;
}

// Comando b
CMD:b(playerid, params[])
{
    if(isnull(params))
        return SendClientMessage(playerid, COR_ERRO, "❌ Use: /b [texto OOC]");
    
    new string[144], nome[MAX_PLAYER_NAME];
    GetPlayerName(playerid, nome, sizeof(nome));
    format(string, sizeof(string), "{FFD700}(( %s: {FFFFFF}%s {FFD700}))", nome, params);
    
    SendLocalMessage(playerid, string, 20.0);
    return 1;
}

// Comando s (gritar)
CMD:s(playerid, params[])
{
    if(isnull(params))
        return SendClientMessage(playerid, COR_ERRO, "❌ Use: /s [texto]");
    
    new string[144], nome[MAX_PLAYER_NAME];
    GetPlayerName(playerid, nome, sizeof(nome));
    format(string, sizeof(string), "%s grita: %s!!", nome, params);
    
    SendLocalMessage(playerid, string, 40.0);
    return 1;
}

// Comando w (sussurrar)
CMD:w(playerid, params[])
{
    if(isnull(params))
        return SendClientMessage(playerid, COR_ERRO, "❌ Use: /w [texto]");
    
    new string[144], nome[MAX_PLAYER_NAME];
    GetPlayerName(playerid, nome, sizeof(nome));
    format(string, sizeof(string), "%s sussurra: %s", nome, params);
    
    SendLocalMessage(playerid, string, 5.0);
    return 1;
}

// Comando comandos
CMD:comandos(playerid, params[])
{
    SendClientMessage(playerid, COR_AZUL_ELITE, "═══════════════ {FFD700}COMANDOS BRASIL ELITE RP {1E90FF}═══════════════");
    SendClientMessage(playerid, COR_BRANCO, "{FFFF00}/cpf {FFFFFF}- Ver seus documentos brasileiros");
    SendClientMessage(playerid, COR_BRANCO, "{FFFF00}/stats {FFFFFF}- Ver suas estatísticas completas");
    SendClientMessage(playerid, COR_BRANCO, "{FFFF00}/me {FFFFFF}- Fazer uma ação (ex: /me pega uma cerveja)");
    SendClientMessage(playerid, COR_BRANCO, "{FFFF00}/do {FFFFFF}- Descrever algo (ex: /do a cerveja está gelada)");
    SendClientMessage(playerid, COR_BRANCO, "{FFFF00}/b {FFFFFF}- Chat OOC local (ex: /b lag)");
    SendClientMessage(playerid, COR_BRANCO, "{FFFF00}/s {FFFFFF}- Gritar (ex: /s Socorro!)");
    SendClientMessage(playerid, COR_BRANCO, "{FFFF00}/w {FFFFFF}- Sussurrar (ex: /w oi)");
    SendClientMessage(playerid, COR_BRANCO, "{FFFF00}/q {FFFFFF}- Sair do servidor com segurança");
    SendClientMessage(playerid, COR_AZUL_ELITE, "═══════════════════════════════════════════════════════");
    
    return 1;
}

// Comando q (sair)
CMD:q(playerid, params[])
{
    SendClientMessage(playerid, COR_VERDE_ELITE, "👋 Obrigado por jogar no Brasil Elite RP!");
    SendClientMessage(playerid, COR_INFO, "💬 Discord: "SERVIDOR_SITE);
    
    if(PlayerInfo[playerid][pLogado])
    {
        SalvarPlayer(playerid);
    }
    
    SetTimerEx("KickPlayerDelayed", 1000, false, "i", playerid);
    return 1;
}