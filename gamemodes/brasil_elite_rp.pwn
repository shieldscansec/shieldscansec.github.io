/*
===============================================================================
██████╗ ██████╗  ██████╗ ███████╗██╗██╗         ███████╗██╗     ██╗████████╗███████╗    ██████╗ ██████╗ 
██╔══██╗██╔══██╗██╔═══██╗██╔════╝██║██║         ██╔════╝██║     ██║╚══██╔══╝██╔════╝    ██╔══██╗██╔══██╗
██████╔╝██████╔╝██║   ██║███████╗██║██║         █████╗  ██║     ██║   ██║   █████╗      ██████╔╝██████╔╝
██╔══██╗██╔══██╗██║   ██║╚════██║██║██║         ██╔══╝  ██║     ██║   ██║   ██╔══╝      ██╔══██╗██╔═══╝ 
██████╔╝██║  ██║╚██████╔╝███████║██║███████╗    ███████╗███████╗██║   ██║   ███████╗    ██║  ██║██║     
╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝╚══════╝    ╚══════╝╚══════╝╚═╝   ╚═╝   ╚══════╝    ╚═╝  ╚═╝╚═╝     
                                                                                                          
    🔥 BRASIL ELITE ROLEPLAY - O FUTURO DO RP BRASILEIRO 🔥
    
    ✨ Baseado nos melhores sistemas das GMs brasileiras:
    • Homeland RP - Sistema intuitivo sem comandos
    • Paradise City RP - Casas e factions dinâmicas
    • Samp RPG - Sistema de empregos e progressão
    • Speedometer avançado - HUD moderno
    • GTA V HUD - Interface next-gen
    • Anti-cheat de última geração
    
    🚀 Desenvolvido em 2025 - Estado da Arte em RP
===============================================================================
*/

// ==================== CONFIGURAÇÕES PRINCIPAIS ====================
#pragma tabsize 0
#pragma dynamic 8192

// Definições especiais para sistemas avançados
#define SSCANF_NO_NICE_FEATURES
#define MAX_HOUSES 500
#define MAX_BUSINESSES 200
#define MAX_FACTIONS 50
#define MAX_VEHICLES_SERVER 2000
#define MAX_JOBS 25

// Sistema de textdraws avançado
#define MAX_TEXTDRAWS_PLAYER 128
#define MAX_GLOBAL_TEXTDRAWS 2048

// ==================== INCLUDES PRINCIPAIS ====================
#include <a_samp>
#include <streamer>
#include <sscanf2>
#include <zcmd>
#include <YSI_Coding\y_hooks>
#include <YSI_Data\y_iterate>
#include <mysql>
#include <crashdetect>

// Sistema anti-cheat avançado
native WP_Hash(buffer[], len, const str[]);

// ==================== CORES MODERNAS ====================
#define COR_BRANCA          0xFFFFFFFF
#define COR_PRETA           0x000000FF
#define COR_AZUL_ELITE      0x1E90FFFF
#define COR_VERDE_ELITE     0x00FF7FFF
#define COR_VERMELHO_ELITE  0xFF4500FF
#define COR_DOURADO_ELITE   0xFFD700FF
#define COR_ROXO_ELITE      0x9932CCFF
#define COR_CYAN_ELITE      0x00FFFFFF
#define COR_LARANJA_ELITE   0xFF8C00FF
#define COR_ROSA_ELITE      0xFF69B4FF

// Cores para chat e sistema
#define COR_CHAT_OOC        0xE0E0E0FF
#define COR_CHAT_IC         0xFFFFFFFF
#define COR_CHAT_LOCAL      0xE6E6FAFF
#define COR_CHAT_SUSSURRO   0xD3D3D3FF
#define COR_CHAT_GRITO      0xFFFFFFFF
#define COR_ERRO            0xFF6347FF
#define COR_SUCESSO         0x90EE90FF
#define COR_INFO            0x87CEEBFF
#define COR_AVISO           0xFFD700FF

// ==================== ENUMS PRINCIPAIS ====================

// Sistema de jogador avançado
enum pInfo
{
    // Dados básicos
    pID,
    pNome[MAX_PLAYER_NAME],
    pSenha[65],
    pEmail[128],
    pCPF[15],
    pRG[12],
    
    // Dados pessoais
    pIdade,
    pSexo,
    pNascimento[32],
    pNaturalidade[64],
    
    // Sistema econômico
    Float:pDinheiro,
    pBanco,
    pContaBanco,
    pSalario,
    
    // Experiência e progressão
    pLevel,
    pExp,
    pExpTotal,
    pRespect,
    
    // Status físico
    Float:pVida,
    Float:pColete,
    Float:pFome,
    Float:pSede,
    Float:pEnergia,
    Float:pStress,
    
    // Localização
    Float:pPosX,
    Float:pPosY,
    Float:pPosZ,
    Float:pAngle,
    pInterior,
    pVirtualWorld,
    
    // Sistema de emprego
    pEmprego,
    pEmpregoPag,
    pTrabalho,
    pSkillEmprego,
    
    // Sistema de facção
    pFaccao,
    pCargoFaccao,
    pRankFaccao,
    
    // Sistema de crime
    pProcurado,
    pCrimes,
    pTempoJail,
    pJailAdmin,
    
    // Sistema de habilitação
    pCNH,
    pCNH_Moto,
    pCNH_Caminhao,
    pCNH_Barco,
    pCNH_Aviao,
    
    // Sistema de licenças
    pLicencaArma,
    pLicencaCaca,
    pLicencaPesca,
    
    // Sistema de propriedades
    pCasa,
    pEmpresa,
    
    // Veículos
    pVeiculos[5],
    
    // Sistema de relacionamento
    pCasado,
    pConjuge[MAX_PLAYER_NAME],
    
    // Sistema temporal
    pLogado,
    pRegistrado,
    pUltimoLogin,
    pTempoJogado,
    
    // Sistema de configurações
    pConfigs[32],
    
    // Sistema de celular
    pCelular,
    pNumero,
    pCreditos,
    
    // Anti-cheat
    pWarnings,
    pBanido,
    pMuted,
    pTempoBan,
    pTejmpaMute,
    
    // Sistema de skin personalizada
    pSkin,
    pSkins[10],
    
    // Sistema de animações
    pAnimacao,
    pAnimLib[32],
    pAnimName[32],
    
    // Sistema de drogas
    pMaconha,
    pCocaina,
    pCrack,
    pEcstasy,
    
    // Sistema médico
    pFerido,
    pHospital,
    pMedico,
    
    // Sistema VIP
    pVIP,
    pVIPDias,
    pVIPFeatures[20],
    
    // Sistema de conquistas
    pConquistas[100],
    
    // Sistema de tatuagens
    pTatuagens[20],
    
    // Sistema de máscaras
    pMascara,
    pMascaraID
};

// Sistema de casas dinâmicas
enum hInfo
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
    hAluguel,
    hTipo,
    hGaragem,
    hTrancada,
    hCofre,
    hDinheiroCofre,
    hArmario,
    hArmasCofre[10],
    hMunicaoCofre[10],
    hExtras[20],
    hPickup,
    Text3D:hText3D,
    hAreaID,
    hAlugada,
    hInquilino[MAX_PLAYER_NAME],
    hSeguranca,
    hUpgrade[10]
};

// Sistema de veículos dinâmicos
enum vInfo
{
    vExiste,
    vModelo,
    vDono[MAX_PLAYER_NAME],
    Float:vPosX,
    Float:vPosY,
    Float:vPosZ,
    Float:vAngle,
    vCor1,
    vCor2,
    vInterior,
    vVirtualWorld,
    Float:vCombustivel,
    vTrancado,
    vSeguro,
    vAlarme,
    vTuning[17],
    vPlaca[9],
    vKM,
    vTempoSeguro,
    vDanos[4],
    vNeon[4],
    vSom,
    vTipoCombustivel,
    vVelocimetro,
    vGPS,
    vUpgrades[15],
    vConcessionaria,
    vTempoMulta,
    vValorMulta,
    vID,
    vStatus
};

// Sistema de facções dinâmicas
enum fInfo
{
    fExiste,
    fNome[64],
    fTag[8],
    fCor,
    fTipo,
    fLider[MAX_PLAYER_NAME],
    fSubLider[MAX_PLAYER_NAME],
    fMembros,
    fMaxMembros,
    Float:fBaseX,
    Float:fBaseY,
    Float:fBaseZ,
    fInterior,
    fVirtualWorld,
    fCofre,
    fArmas[20],
    fMunicao[20],
    fDrogas[10],
    fVeiculos[20],
    fCargos[10][32],
    fSalarios[10],
    fRankNomes[10][32],
    fAliados[10],
    fInimigos[10],
    fGuerra,
    fGuerraWith,
    fPontos,
    fStatus,
    fUpgrades[15],
    fAreaID,
    Text3D:fText3D,
    fPickup
};

// Sistema de empregos avançado
enum jInfo
{
    jExiste,
    jNome[64],
    jDescricao[128],
    Float:jPosX,
    Float:jPosY,
    Float:jPosZ,
    jSalarioMin,
    jSalarioMax,
    jSkillNecessaria,
    jLevelNecessario,
    jHorarios[24],
    jRequisitos[128],
    jBeneficios[128],
    jVaga,
    jMaxVagas,
    jChefe[MAX_PLAYER_NAME],
    jPickup,
    Text3D:jText3D,
    jAreaID,
    jStatus,
    jTipo,
    jUniforms[5],
    jVeiculos[10],
    jSedes[3][3], // X, Y, Z
    jExtras[20]
};

// ==================== VARIÁVEIS GLOBAIS ====================
new PlayerInfo[MAX_PLAYERS][pInfo];
new HouseInfo[MAX_HOUSES][hInfo];
new VehicleInfo[MAX_VEHICLES_SERVER][vInfo];
new FactionInfo[MAX_FACTIONS][fInfo];
new JobInfo[MAX_JOBS][jInfo];

// Sistema de MySQL
new MySQL:conexao;

// Sistema de textdraws globais (HUD moderno)
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

// Sistema de textdraws do player
new PlayerText:PTDLogin_Fundo[MAX_PLAYERS];
new PlayerText:PTDLogin_Logo[MAX_PLAYERS];
new PlayerText:PTDLogin_BemVindo[MAX_PLAYERS];
new PlayerText:PTDLogin_Input[MAX_PLAYERS];
new PlayerText:PTDLogin_Botao[MAX_PLAYERS];
new PlayerText:PTDRegister_Fundo[MAX_PLAYERS];
new PlayerText:PTDRegister_Form[MAX_PLAYERS];

// Sistema de CPF brasileiro
new PlayerCPF[MAX_PLAYERS][15];
new PlayerRG[MAX_PLAYERS][12];

// Sistema de status do servidor
new ServidorStatus[32];
new ServidorJogadores;
new ServidorRecord;
new ServidorClima;
new ServidorHora;
new ServidorMinuto;

// Sistema anti-cheat avançado
new PlayerAC_Warnings[MAX_PLAYERS];
new PlayerAC_Money[MAX_PLAYERS];
new PlayerAC_Weapons[MAX_PLAYERS][13];
new PlayerAC_Ammo[MAX_PLAYERS][13];
new Float:PlayerAC_Health[MAX_PLAYERS];
new Float:PlayerAC_Armour[MAX_PLAYERS];
new Float:PlayerAC_PosX[MAX_PLAYERS], Float:PlayerAC_PosY[MAX_PLAYERS], Float:PlayerAC_PosZ[MAX_PLAYERS];
new PlayerAC_SpeedHack[MAX_PLAYERS];
new PlayerAC_AirBreak[MAX_PLAYERS];
new PlayerAC_GodMode[MAX_PLAYERS];

// Sistema de chat
new ChatOOC_Status = 1;
new ChatIC_Status = 1;
new ChatLocal_Distancia = 20;
new ChatSussurro_Distancia = 5;
new ChatGrito_Distancia = 40;

// Iteradores para performance
new Iterator:Players<MAX_PLAYERS>;
new Iterator:Houses<MAX_HOUSES>;
new Iterator:Vehicles<MAX_VEHICLES_SERVER>;
new Iterator:Factions<MAX_FACTIONS>;
new Iterator:Jobs<MAX_JOBS>;

// ==================== SISTEMA DE LOGIN AVANÇADO ====================

// Gerador de CPF brasileiro válido
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

// Gerador de RG brasileiro
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

// Sistema de verificação de força da senha
stock VerificarForcaSenha(const senha[])
{
    new len = strlen(senha);
    if(len < 6) return 0; // Muito fraca
    
    new temMaiuscula = 0, temMinuscula = 0, temNumero = 0, temEspecial = 0;
    
    for(new i = 0; i < len; i++)
    {
        if(senha[i] >= 'A' && senha[i] <= 'Z') temMaiuscula = 1;
        else if(senha[i] >= 'a' && senha[i] <= 'z') temMinuscula = 1;
        else if(senha[i] >= '0' && senha[i] <= '9') temNumero = 1;
        else if(senha[i] == '@' || senha[i] == '#' || senha[i] == '$' || 
                senha[i] == '%' || senha[i] == '&' || senha[i] == '*') temEspecial = 1;
    }
    
    new forca = temMaiuscula + temMinuscula + temNumero + temEspecial;
    
    if(len >= 8 && forca >= 3) return 3; // Forte
    if(len >= 6 && forca >= 2) return 2; // Média
    return 1; // Fraca
}

// ==================== CALLBACKS PRINCIPAIS ====================

public OnGameModeInit()
{
    print("\n");
    print("===============================================");
    print("    🚀 BRASIL ELITE RP - INICIALIZANDO 🚀");
    print("===============================================");
    
    // Configurações do servidor
    SetGameModeText("Brasil Elite RP v1.0");
    SendRconCommand("hostname [BR] Brasil Elite RP | O Futuro do RP");
    SendRconCommand("mapname San Andreas");
    SendRconCommand("weburl discord.gg/brasielite");
    SendRconCommand("language Português");
    
    // Sistema de clima e tempo
    SetWorldTime(12);
    SetWeather(1);
    
    // Configurações de spawn
    UsePlayerPedAnims();
    DisableInteriorEnterExits();
    EnableStuntBonusForAll(0);
    SetNameTagDrawDistance(40.0);
    ShowNameTags(1);
    ShowPlayerMarkers(0);
    
    // Conectar ao MySQL
    ConectarMySQL();
    
    // Carregar dados do servidor
    CarregarHousas();
    CarregarVeiculos();
    CarregarFaccoes();
    CarregarEmpregos();
    
    // Criar textdraws globais
    CriarTextdrawsGlobais();
    
    // Sistema de tempo automático
    SetTimer("AtualizarTempo", 60000, true);
    SetTimer("SalvarDados", 300000, true); // Salvar a cada 5 minutos
    SetTimer("AtualizarHUD", 1000, true);
    SetTimer("AntiCheatCheck", 2000, true);
    
    print("===============================================");
    print("    ✅ BRASIL ELITE RP - ONLINE COM SUCESSO!");
    print("===============================================");
    print("\n");
    
    return 1;
}

public OnGameModeExit()
{
    print("===============================================");
    print("    🔴 BRASIL ELITE RP - DESLIGANDO SERVIDOR");
    print("===============================================");
    
    // Salvar todos os dados dos jogadores online
    foreach(new i : Players)
    {
        if(PlayerInfo[i][pLogado])
        {
            SalvarPlayer(i);
        }
    }
    
    // Fechar conexão MySQL
    mysql_close(conexao);
    
    print("    ✅ DADOS SALVOS COM SUCESSO!");
    print("===============================================");
    
    return 1;
}

public OnPlayerConnect(playerid)
{
    // Resetar variáveis do player
    ResetarVariaveisPlayer(playerid);
    
    // Adicionar ao iterator
    Iter_Add(Players, playerid);
    
    // Gerar CPF e RG
    GerarCPF(playerid);
    GerarRG(playerid);
    
    // Verificar se está registrado
    new query[256], nome[MAX_PLAYER_NAME];
    GetPlayerName(playerid, nome, sizeof(nome));
    
    mysql_format(conexao, query, sizeof(query), 
        "SELECT * FROM `jogadores` WHERE `nome` = '%e' LIMIT 1", nome);
    mysql_tquery(conexao, query, "OnPlayerDataLoaded", "i", playerid);
    
    // Mensagens de boas-vindas
    new string[256];
    format(string, sizeof(string), 
        "{00FF7F}✅ {FFFFFF}%s {00FF7F}conectou-se ao {FFD700}Brasil Elite RP{00FF7F}!", nome);
    SendClientMessageToAll(COR_VERDE_ELITE, string);
    
    SendClientMessage(playerid, COR_AZUL_ELITE, 
        "═══════════════════════════════════════════════════════════════");
    SendClientMessage(playerid, COR_BRANCA, 
        "          {FFD700}🚀 BEM-VINDO AO BRASIL ELITE ROLEPLAY! 🚀");
    SendClientMessage(playerid, COR_BRANCA,
        "               {00FF7F}O FUTURO DO ROLEPLAY BRASILEIRO");
    SendClientMessage(playerid, COR_AZUL_ELITE,
        "═══════════════════════════════════════════════════════════════");
    SendClientMessage(playerid, COR_BRANCA,
        "   {FFFF00}💎 Discord: {FFFFFF}discord.gg/brasielite");
    SendClientMessage(playerid, COR_BRANCA,
        "   {FFFF00}🌐 Site: {FFFFFF}www.brasieliterp.com");
    SendClientMessage(playerid, COR_BRANCA,
        "   {FFFF00}📋 Leia: {FFFFFF}/regras | /comandos | /duvidas");
    SendClientMessage(playerid, COR_AZUL_ELITE,
        "═══════════════════════════════════════════════════════════════");
    
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    // Salvar dados antes de desconectar
    if(PlayerInfo[playerid][pLogado])
    {
        SalvarPlayer(playerid);
    }
    
    // Remover do iterator
    Iter_Remove(Players, playerid);
    
    // Destruir textdraws do player
    DestruirTextdrawsPlayer(playerid);
    
    // Mensagem de saída
    new nome[MAX_PLAYER_NAME], string[256], razao[32];
    GetPlayerName(playerid, nome, sizeof(nome));
    
    switch(reason)
    {
        case 0: razao = "Timeout/Crash";
        case 1: razao = "Saiu do jogo";
        case 2: razao = "Kickado/Banido";
    }
    
    format(string, sizeof(string), 
        "{FF6347}❌ {FFFFFF}%s {FF6347}desconectou-se do servidor. {FFFFFF}[%s]", nome, razao);
    SendClientMessageToAll(COR_VERMELHO_ELITE, string);
    
    return 1;
}

public OnPlayerSpawn(playerid)
{
    if(!PlayerInfo[playerid][pLogado])
    {
        MostrarTelaLogin(playerid);
        return 1;
    }
    
    // Spawn seguro
    SetPlayerPos(playerid, PlayerInfo[playerid][pPosX], PlayerInfo[playerid][pPosY], PlayerInfo[playerid][pPosZ]);
    SetPlayerFacingAngle(playerid, PlayerInfo[playerid][pAngle]);
    SetPlayerInterior(playerid, PlayerInfo[playerid][pInterior]);
    SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pVirtualWorld]);
    
    // Aplicar skin
    SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
    
    // Restaurar vida e colete
    SetPlayerHealth(playerid, PlayerInfo[playerid][pVida]);
    SetPlayerArmour(playerid, PlayerInfo[playerid][pColete]);
    
    // Dar dinheiro
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, floatround(PlayerInfo[playerid][pDinheiro]));
    
    // Mostrar HUD
    MostrarHUD(playerid);
    
    return 1;
}

// ==================== SISTEMA DE TEXTDRAWS MODERNOS ====================

stock CriarTextdrawsGlobais()
{
    // HUD Principal - Fundo moderno
    TDHud_Fundo = TextDrawCreate(498.000000, 350.000000, "box");
    TextDrawTextSize(TDHud_Fundo, 640.000000, 0.000000);
    TextDrawAlignment(TDHud_Fundo, 1);
    TextDrawColor(TDHud_Fundo, -1);
    TextDrawUseBox(TDHud_Fundo, 1);
    TextDrawBoxColor(TDHud_Fundo, 0x00000066);
    TextDrawSetShadow(TDHud_Fundo, 0);
    TextDrawBackgroundColor(TDHud_Fundo, 255);
    TextDrawFont(TDHud_Fundo, 1);
    TextDrawSetProportional(TDHud_Fundo, 1);
    
    // Vida
    TDHud_Vida = TextDrawCreate(505.000000, 355.000000, "VIDA:");
    TextDrawAlignment(TDHud_Vida, 1);
    TextDrawColor(TDHud_Vida, 0xFF6347FF);
    TextDrawFont(TDHud_Vida, 2);
    TextDrawLetterSize(TDHud_Vida, 0.2, 1.0);
    TextDrawSetOutline(TDHud_Vida, 1);
    TextDrawSetProportional(TDHud_Vida, 1);
    
    // Colete
    TDHud_Colete = TextDrawCreate(505.000000, 365.000000, "COLETE:");
    TextDrawAlignment(TDHud_Colete, 1);
    TextDrawColor(TDHud_Colete, 0x87CEEBFF);
    TextDrawFont(TDHud_Colete, 2);
    TextDrawLetterSize(TDHud_Colete, 0.2, 1.0);
    TextDrawSetOutline(TDHud_Colete, 1);
    TextDrawSetProportional(TDHud_Colete, 1);
    
    // Fome
    TDHud_Fome = TextDrawCreate(505.000000, 375.000000, "FOME:");
    TextDrawAlignment(TDHud_Fome, 1);
    TextDrawColor(TDHud_Fome, 0xFFD700FF);
    TextDrawFont(TDHud_Fome, 2);
    TextDrawLetterSize(TDHud_Fome, 0.2, 1.0);
    TextDrawSetOutline(TDHud_Fome, 1);
    TextDrawSetProportional(TDHud_Fome, 1);
    
    // Sede
    TDHud_Sede = TextDrawCreate(505.000000, 385.000000, "SEDE:");
    TextDrawAlignment(TDHud_Sede, 1);
    TextDrawColor(TDHud_Sede, 0x00FFFFFF);
    TextDrawFont(TDHud_Sede, 2);
    TextDrawLetterSize(TDHud_Sede, 0.2, 1.0);
    TextDrawSetOutline(TDHud_Sede, 1);
    TextDrawSetProportional(TDHud_Sede, 1);
    
    // Dinheiro
    TDHud_Dinheiro = TextDrawCreate(505.000000, 395.000000, "DINHEIRO:");
    TextDrawAlignment(TDHud_Dinheiro, 1);
    TextDrawColor(TDHud_Dinheiro, 0x90EE90FF);
    TextDrawFont(TDHud_Dinheiro, 2);
    TextDrawLetterSize(TDHud_Dinheiro, 0.2, 1.0);
    TextDrawSetOutline(TDHud_Dinheiro, 1);
    TextDrawSetProportional(TDHud_Dinheiro, 1);
    
    // Level
    TDHud_Level = TextDrawCreate(505.000000, 405.000000, "LEVEL:");
    TextDrawAlignment(TDHud_Level, 1);
    TextDrawColor(TDHud_Level, 0x9932CCFF);
    TextDrawFont(TDHud_Level, 2);
    TextDrawLetterSize(TDHud_Level, 0.2, 1.0);
    TextDrawSetOutline(TDHud_Level, 1);
    TextDrawSetProportional(TDHud_Level, 1);
    
    // FPS Counter
    TDHud_FPS = TextDrawCreate(610.000000, 355.000000, "FPS: 0");
    TextDrawAlignment(TDHud_FPS, 3);
    TextDrawColor(TDHud_FPS, 0xFFFFFFFF);
    TextDrawFont(TDHud_FPS, 2);
    TextDrawLetterSize(TDHud_FPS, 0.15, 0.8);
    TextDrawSetOutline(TDHud_FPS, 1);
    TextDrawSetProportional(TDHud_FPS, 1);
    
    // Ping
    TDHud_Ping = TextDrawCreate(610.000000, 365.000000, "PING: 0");
    TextDrawAlignment(TDHud_Ping, 3);
    TextDrawColor(TDHud_Ping, 0xFFFFFFFF);
    TextDrawFont(TDHud_Ping, 2);
    TextDrawLetterSize(TDHud_Ping, 0.15, 0.8);
    TextDrawSetOutline(TDHud_Ping, 1);
    TextDrawSetProportional(TDHud_Ping, 1);
    
    // Tempo
    TDHud_Tempo = TextDrawCreate(610.000000, 375.000000, "00:00");
    TextDrawAlignment(TDHud_Tempo, 3);
    TextDrawColor(TDHud_Tempo, 0xFFFFFFFF);
    TextDrawFont(TDHud_Tempo, 2);
    TextDrawLetterSize(TDHud_Tempo, 0.15, 0.8);
    TextDrawSetOutline(TDHud_Tempo, 1);
    TextDrawSetProportional(TDHud_Tempo, 1);
    
    // Data
    TDHud_Data = TextDrawCreate(610.000000, 385.000000, "01/01/2025");
    TextDrawAlignment(TDHud_Data, 3);
    TextDrawColor(TDHud_Data, 0xFFFFFFFF);
    TextDrawFont(TDHud_Data, 2);
    TextDrawLetterSize(TDHud_Data, 0.15, 0.8);
    TextDrawSetOutline(TDHud_Data, 1);
    TextDrawSetProportional(TDHud_Data, 1);
    
    // Speedometer (aparece apenas no veículo)
    TDHud_Speedometer = TextDrawCreate(450.000000, 320.000000, "box");
    TextDrawTextSize(TDHud_Speedometer, 590.000000, 0.000000);
    TextDrawAlignment(TDHud_Speedometer, 1);
    TextDrawColor(TDHud_Speedometer, -1);
    TextDrawUseBox(TDHud_Speedometer, 1);
    TextDrawBoxColor(TDHud_Speedometer, 0x00000088);
    TextDrawSetShadow(TDHud_Speedometer, 0);
    TextDrawBackgroundColor(TDHud_Speedometer, 255);
    TextDrawFont(TDHud_Speedometer, 1);
    TextDrawSetProportional(TDHud_Speedometer, 1);
    
    // Velocidade
    TDHud_Velocidade = TextDrawCreate(460.000000, 325.000000, "0 KM/H");
    TextDrawAlignment(TDHud_Velocidade, 1);
    TextDrawColor(TDHud_Velocidade, 0x00FF00FF);
    TextDrawFont(TDHud_Velocidade, 3);
    TextDrawLetterSize(TDHud_Velocidade, 0.4, 1.5);
    TextDrawSetOutline(TDHud_Velocidade, 1);
    TextDrawSetProportional(TDHud_Velocidade, 1);
    
    // Combustível
    TDHud_Combustivel = TextDrawCreate(520.000000, 325.000000, "COMBUSTIVEL: 100%");
    TextDrawAlignment(TDHud_Combustivel, 1);
    TextDrawColor(TDHud_Combustivel, 0xFFD700FF);
    TextDrawFont(TDHud_Combustivel, 2);
    TextDrawLetterSize(TDHud_Combustivel, 0.2, 1.0);
    TextDrawSetOutline(TDHud_Combustivel, 1);
    TextDrawSetProportional(TDHud_Combustivel, 1);
    
    // KM
    TDHud_KM = TextDrawCreate(520.000000, 335.000000, "KM: 0");
    TextDrawAlignment(TDHud_KM, 1);
    TextDrawColor(TDHud_KM, 0xFFFFFFFF);
    TextDrawFont(TDHud_KM, 2);
    TextDrawLetterSize(TDHud_KM, 0.2, 1.0);
    TextDrawSetOutline(TDHud_KM, 1);
    TextDrawSetProportional(TDHud_KM, 1);
    
    return 1;
}

stock CriarTextdrawsLogin(playerid)
{
    // Fundo da tela de login
    PTDLogin_Fundo[playerid] = CreatePlayerTextDraw(playerid, 0.000000, 0.000000, "box");
    PlayerTextDrawTextSize(playerid, PTDLogin_Fundo[playerid], 640.000000, 480.000000);
    PlayerTextDrawAlignment(playerid, PTDLogin_Fundo[playerid], 1);
    PlayerTextDrawColor(playerid, PTDLogin_Fundo[playerid], -1);
    PlayerTextDrawUseBox(playerid, PTDLogin_Fundo[playerid], 1);
    PlayerTextDrawBoxColor(playerid, PTDLogin_Fundo[playerid], 0x000000CC);
    PlayerTextDrawSetShadow(playerid, PTDLogin_Fundo[playerid], 0);
    PlayerTextDrawBackgroundColor(playerid, PTDLogin_Fundo[playerid], 255);
    PlayerTextDrawFont(playerid, PTDLogin_Fundo[playerid], 1);
    PlayerTextDrawSetProportional(playerid, PTDLogin_Fundo[playerid], 1);
    
    // Logo do servidor
    PTDLogin_Logo[playerid] = CreatePlayerTextDraw(playerid, 320.000000, 100.000000, 
        "~y~BRASIL ELITE ~r~RP~n~~w~O FUTURO DO ROLEPLAY");
    PlayerTextDrawAlignment(playerid, PTDLogin_Logo[playerid], 2);
    PlayerTextDrawColor(playerid, PTDLogin_Logo[playerid], -1);
    PlayerTextDrawFont(playerid, PTDLogin_Logo[playerid], 0);
    PlayerTextDrawLetterSize(playerid, PTDLogin_Logo[playerid], 0.6, 2.5);
    PlayerTextDrawSetOutline(playerid, PTDLogin_Logo[playerid], 1);
    PlayerTextDrawSetProportional(playerid, PTDLogin_Logo[playerid], 1);
    
    // Texto de boas-vindas
    new nome[MAX_PLAYER_NAME], string[256];
    GetPlayerName(playerid, nome, sizeof(nome));
    
    format(string, sizeof(string), 
        "~w~Bem-vindo(a), ~g~%s~w~!~n~Digite sua senha para fazer login:", nome);
    PTDLogin_BemVindo[playerid] = CreatePlayerTextDraw(playerid, 320.000000, 200.000000, string);
    PlayerTextDrawAlignment(playerid, PTDLogin_BemVindo[playerid], 2);
    PlayerTextDrawColor(playerid, PTDLogin_BemVindo[playerid], -1);
    PlayerTextDrawFont(playerid, PTDLogin_BemVindo[playerid], 1);
    PlayerTextDrawLetterSize(playerid, PTDLogin_BemVindo[playerid], 0.3, 1.2);
    PlayerTextDrawSetOutline(playerid, PTDLogin_BemVindo[playerid], 1);
    PlayerTextDrawSetProportional(playerid, PTDLogin_BemVindo[playerid], 1);
    
    // Campo de input
    PTDLogin_Input[playerid] = CreatePlayerTextDraw(playerid, 320.000000, 250.000000, "box");
    PlayerTextDrawTextSize(playerid, PTDLogin_Input[playerid], 480.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PTDLogin_Input[playerid], 2);
    PlayerTextDrawColor(playerid, PTDLogin_Input[playerid], -1);
    PlayerTextDrawUseBox(playerid, PTDLogin_Input[playerid], 1);
    PlayerTextDrawBoxColor(playerid, PTDLogin_Input[playerid], 0xFFFFFF88);
    PlayerTextDrawSetShadow(playerid, PTDLogin_Input[playerid], 0);
    PlayerTextDrawBackgroundColor(playerid, PTDLogin_Input[playerid], 255);
    PlayerTextDrawFont(playerid, PTDLogin_Input[playerid], 1);
    PlayerTextDrawSetProportional(playerid, PTDLogin_Input[playerid], 1);
    
    // Botão de login
    PTDLogin_Botao[playerid] = CreatePlayerTextDraw(playerid, 320.000000, 300.000000, 
        "~g~[ENTRAR]");
    PlayerTextDrawAlignment(playerid, PTDLogin_Botao[playerid], 2);
    PlayerTextDrawColor(playerid, PTDLogin_Botao[playerid], -1);
    PlayerTextDrawFont(playerid, PTDLogin_Botao[playerid], 2);
    PlayerTextDrawLetterSize(playerid, PTDLogin_Botao[playerid], 0.4, 1.8);
    PlayerTextDrawSetOutline(playerid, PTDLogin_Botao[playerid], 1);
    PlayerTextDrawSetProportional(playerid, PTDLogin_Botao[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, PTDLogin_Botao[playerid], 1);
    
    return 1;
}

stock CriarTextdrawsRegistro(playerid)
{
    // Fundo da tela de registro
    PTDRegister_Fundo[playerid] = CreatePlayerTextDraw(playerid, 0.000000, 0.000000, "box");
    PlayerTextDrawTextSize(playerid, PTDRegister_Fundo[playerid], 640.000000, 480.000000);
    PlayerTextDrawAlignment(playerid, PTDRegister_Fundo[playerid], 1);
    PlayerTextDrawColor(playerid, PTDRegister_Fundo[playerid], -1);
    PlayerTextDrawUseBox(playerid, PTDRegister_Fundo[playerid], 1);
    PlayerTextDrawBoxColor(playerid, PTDRegister_Fundo[playerid], 0x000000CC);
    PlayerTextDrawSetShadow(playerid, PTDRegister_Fundo[playerid], 0);
    PlayerTextDrawBackgroundColor(playerid, PTDRegister_Fundo[playerid], 255);
    PlayerTextDrawFont(playerid, PTDRegister_Fundo[playerid], 1);
    PlayerTextDrawSetProportional(playerid, PTDRegister_Fundo[playerid], 1);
    
    // Formulário de registro
    new nome[MAX_PLAYER_NAME], string[512];
    GetPlayerName(playerid, nome, sizeof(nome));
    
    format(string, sizeof(string), 
        "~y~BRASIL ELITE RP - REGISTRO~n~~n~"
        "~w~Bem-vindo(a), ~g~%s~w~!~n~"
        "~w~Para criar sua conta, preencha as informações:~n~~n~"
        "~b~• ~w~Senha (mínimo 6 caracteres)~n~"
        "~b~• ~w~Email válido~n~"
        "~b~• ~w~Idade (16-80 anos)~n~"
        "~b~• ~w~Sexo (M/F)~n~~n~"
        "~r~Leia nosso ~y~/regulamento ~r~antes de jogar!", nome);
    
    PTDRegister_Form[playerid] = CreatePlayerTextDraw(playerid, 320.000000, 180.000000, string);
    PlayerTextDrawAlignment(playerid, PTDRegister_Form[playerid], 2);
    PlayerTextDrawColor(playerid, PTDRegister_Form[playerid], -1);
    PlayerTextDrawFont(playerid, PTDRegister_Form[playerid], 1);
    PlayerTextDrawLetterSize(playerid, PTDRegister_Form[playerid], 0.28, 1.1);
    PlayerTextDrawSetOutline(playerid, PTDRegister_Form[playerid], 1);
    PlayerTextDrawSetProportional(playerid, PTDRegister_Form[playerid], 1);
    
    return 1;
}

stock MostrarTelaLogin(playerid)
{
    // Verificar se está registrado
    new query[256], nome[MAX_PLAYER_NAME];
    GetPlayerName(playerid, nome, sizeof(nome));
    
    mysql_format(conexao, query, sizeof(query), 
        "SELECT COUNT(*) FROM `jogadores` WHERE `nome` = '%e'", nome);
    mysql_tquery(conexao, query, "OnCheckRegistration", "i", playerid);
    
    return 1;
}

stock MostrarHUD(playerid)
{
    // Mostrar textdraws globais
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

stock EsconderHUD(playerid)
{
    // Esconder textdraws globais
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
    
    return 1;
}

stock DestruirTextdrawsPlayer(playerid)
{
    // Destruir textdraws do login
    PlayerTextDrawDestroy(playerid, PTDLogin_Fundo[playerid]);
    PlayerTextDrawDestroy(playerid, PTDLogin_Logo[playerid]);
    PlayerTextDrawDestroy(playerid, PTDLogin_BemVindo[playerid]);
    PlayerTextDrawDestroy(playerid, PTDLogin_Input[playerid]);
    PlayerTextDrawDestroy(playerid, PTDLogin_Botao[playerid]);
    
    // Destruir textdraws do registro
    PlayerTextDrawDestroy(playerid, PTDRegister_Fundo[playerid]);
    PlayerTextDrawDestroy(playerid, PTDRegister_Form[playerid]);
    
    return 1;
}

// ==================== SISTEMA MYSQL AVANÇADO ====================

stock ConectarMySQL()
{
    conexao = mysql_connect("localhost", "root", "", "brasil_elite_rp");
    
    if(mysql_errno(conexao) != 0)
    {
        print("❌ ERRO: Falha ao conectar com o MySQL!");
        print("⚠️  Verifique as configurações do banco de dados.");
        SendRconCommand("exit");
        return 0;
    }
    
    print("✅ MySQL conectado com sucesso!");
    
    // Criar tabelas se não existirem
    CriarTabelas();
    
    return 1;
}

stock CriarTabelas()
{
    // Tabela de jogadores
    mysql_query(conexao, 
        "CREATE TABLE IF NOT EXISTS `jogadores` (\
            `id` INT AUTO_INCREMENT PRIMARY KEY,\
            `nome` VARCHAR(24) NOT NULL UNIQUE,\
            `senha` VARCHAR(65) NOT NULL,\
            `email` VARCHAR(128),\
            `cpf` VARCHAR(15),\
            `rg` VARCHAR(12),\
            `idade` INT DEFAULT 18,\
            `sexo` CHAR(1) DEFAULT 'M',\
            `nascimento` VARCHAR(32),\
            `naturalidade` VARCHAR(64),\
            `dinheiro` DECIMAL(15,2) DEFAULT 5000.00,\
            `banco` DECIMAL(15,2) DEFAULT 0.00,\
            `conta_banco` INT DEFAULT 0,\
            `salario` INT DEFAULT 0,\
            `level` INT DEFAULT 1,\
            `exp` INT DEFAULT 0,\
            `exp_total` INT DEFAULT 0,\
            `respect` INT DEFAULT 0,\
            `vida` DECIMAL(5,2) DEFAULT 100.00,\
            `colete` DECIMAL(5,2) DEFAULT 0.00,\
            `fome` DECIMAL(5,2) DEFAULT 100.00,\
            `sede` DECIMAL(5,2) DEFAULT 100.00,\
            `energia` DECIMAL(5,2) DEFAULT 100.00,\
            `stress` DECIMAL(5,2) DEFAULT 0.00,\
            `pos_x` DECIMAL(10,6) DEFAULT 1684.9,\
            `pos_y` DECIMAL(10,6) DEFAULT -2244.5,\
            `pos_z` DECIMAL(10,6) DEFAULT 13.5,\
            `angle` DECIMAL(10,6) DEFAULT 0.0,\
            `interior` INT DEFAULT 0,\
            `virtual_world` INT DEFAULT 0,\
            `emprego` INT DEFAULT 0,\
            `emprego_pag` INT DEFAULT 0,\
            `trabalho` INT DEFAULT 0,\
            `skill_emprego` INT DEFAULT 0,\
            `faccao` INT DEFAULT 0,\
            `cargo_faccao` INT DEFAULT 0,\
            `rank_faccao` INT DEFAULT 0,\
            `procurado` INT DEFAULT 0,\
            `crimes` INT DEFAULT 0,\
            `tempo_jail` INT DEFAULT 0,\
            `jail_admin` INT DEFAULT 0,\
            `cnh` INT DEFAULT 0,\
            `cnh_moto` INT DEFAULT 0,\
            `cnh_caminhao` INT DEFAULT 0,\
            `cnh_barco` INT DEFAULT 0,\
            `cnh_aviao` INT DEFAULT 0,\
            `licenca_arma` INT DEFAULT 0,\
            `licenca_caca` INT DEFAULT 0,\
            `licenca_pesca` INT DEFAULT 0,\
            `casa` INT DEFAULT 0,\
            `empresa` INT DEFAULT 0,\
            `veiculos` VARCHAR(128),\
            `casado` INT DEFAULT 0,\
            `conjuge` VARCHAR(24),\
            `logado` INT DEFAULT 0,\
            `registrado` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,\
            `ultimo_login` TIMESTAMP,\
            `tempo_jogado` INT DEFAULT 0,\
            `configs` VARCHAR(256),\
            `celular` INT DEFAULT 0,\
            `numero` INT DEFAULT 0,\
            `creditos` INT DEFAULT 0,\
            `warnings` INT DEFAULT 0,\
            `banido` INT DEFAULT 0,\
            `muted` INT DEFAULT 0,\
            `tempo_ban` TIMESTAMP,\
            `tempo_mute` TIMESTAMP,\
            `skin` INT DEFAULT 26,\
            `skins` VARCHAR(128),\
            `animacao` INT DEFAULT 0,\
            `anim_lib` VARCHAR(32),\
            `anim_name` VARCHAR(32),\
            `maconha` INT DEFAULT 0,\
            `cocaina` INT DEFAULT 0,\
            `crack` INT DEFAULT 0,\
            `ecstasy` INT DEFAULT 0,\
            `ferido` INT DEFAULT 0,\
            `hospital` INT DEFAULT 0,\
            `medico` INT DEFAULT 0,\
            `vip` INT DEFAULT 0,\
            `vip_dias` INT DEFAULT 0,\
            `vip_features` VARCHAR(256),\
            `conquistas` TEXT,\
            `tatuagens` VARCHAR(256),\
            `mascara` INT DEFAULT 0,\
            `mascara_id` INT DEFAULT 0\
        )", false);
    
    // Tabela de casas
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
            `aluguel` INT DEFAULT 500,\
            `tipo` INT DEFAULT 1,\
            `garagem` INT DEFAULT 0,\
            `trancada` INT DEFAULT 0,\
            `cofre` INT DEFAULT 0,\
            `dinheiro_cofre` DECIMAL(15,2) DEFAULT 0.00,\
            `armario` INT DEFAULT 0,\
            `armas_cofre` VARCHAR(256),\
            `municao_cofre` VARCHAR(256),\
            `extras` VARCHAR(512),\
            `alugada` INT DEFAULT 0,\
            `inquilino` VARCHAR(24),\
            `seguranca` INT DEFAULT 0,\
            `upgrade` VARCHAR(256)\
        )", false);
    
    // Tabela de veículos
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
            `interior` INT DEFAULT 0,\
            `virtual_world` INT DEFAULT 0,\
            `combustivel` DECIMAL(5,2) DEFAULT 100.00,\
            `trancado` INT DEFAULT 0,\
            `seguro` INT DEFAULT 0,\
            `alarme` INT DEFAULT 0,\
            `tuning` VARCHAR(256),\
            `placa` VARCHAR(9),\
            `km` DECIMAL(10,2) DEFAULT 0.00,\
            `tempo_seguro` TIMESTAMP,\
            `danos` VARCHAR(128),\
            `neon` VARCHAR(64),\
            `som` INT DEFAULT 0,\
            `tipo_combustivel` INT DEFAULT 1,\
            `velocimetro` INT DEFAULT 0,\
            `gps` INT DEFAULT 0,\
            `upgrades` VARCHAR(256),\
            `concessionaria` INT DEFAULT 0,\
            `tempo_multa` TIMESTAMP,\
            `valor_multa` DECIMAL(10,2) DEFAULT 0.00,\
            `status` INT DEFAULT 1\
        )", false);
    
    print("✅ Tabelas criadas/verificadas com sucesso!");
    
    return 1;
}

// ==================== SISTEMA DE CALLBACKS MYSQL ====================

forward OnCheckRegistration(playerid);
public OnCheckRegistration(playerid)
{
    new rows = cache_num_rows();
    
    if(rows > 0)
    {
        // Jogador está registrado - mostrar tela de login
        CriarTextdrawsLogin(playerid);
        PlayerTextDrawShow(playerid, PTDLogin_Fundo[playerid]);
        PlayerTextDrawShow(playerid, PTDLogin_Logo[playerid]);
        PlayerTextDrawShow(playerid, PTDLogin_BemVindo[playerid]);
        PlayerTextDrawShow(playerid, PTDLogin_Input[playerid]);
        PlayerTextDrawShow(playerid, PTDLogin_Botao[playerid]);
        
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, 
            "{FFD700}• BRASIL ELITE RP - LOGIN •", 
            "{FFFFFF}Bem-vindo de volta!\n\n"
            "{00FF7F}Digite sua senha para fazer login:\n"
            "{FFFF00}• Esqueceu a senha? {FFFFFF}Digite: /recuperar\n"
            "{FF6347}• Primeira vez? Essa conta já existe!", 
            "Entrar", "Sair");
    }
    else
    {
        // Jogador não está registrado - mostrar tela de registro
        CriarTextdrawsRegistro(playerid);
        PlayerTextDrawShow(playerid, PTDRegister_Fundo[playerid]);
        PlayerTextDrawShow(playerid, PTDRegister_Form[playerid]);
        
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, 
            "{FFD700}• BRASIL ELITE RP - REGISTRO •", 
            "{FFFFFF}Crie sua conta no {FFD700}Brasil Elite RP{FFFFFF}!\n\n"
            "{00FF7F}Escolha uma senha segura:\n"
            "{FFFF00}• Mínimo 6 caracteres\n"
            "{FFFF00}• Use letras maiúsculas, minúsculas e números\n"
            "{FFFF00}• Evite senhas óbvias\n\n"
            "{FF6347}⚠️ Nunca compartilhe sua senha!", 
            "Criar Conta", "Sair");
    }
    
    return 1;
}

forward OnPlayerDataLoaded(playerid);
public OnPlayerDataLoaded(playerid)
{
    if(cache_num_rows() > 0)
    {
        // Carregar dados do player
        cache_get_value_name_int(0, "id", PlayerInfo[playerid][pID]);
        cache_get_value_name(0, "senha", PlayerInfo[playerid][pSenha], 65);
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
        
        PlayerInfo[playerid][pRegistrado] = 1;
        PlayerInfo[playerid][pLogado] = 1;
        
        printf("✅ Dados carregados para %s (ID: %d)", 
            PlayerInfo[playerid][pNome], PlayerInfo[playerid][pID]);
    }
    
    return 1;
}

// ==================== SISTEMA DE DIALOGS ====================

#define DIALOG_LOGIN 1001
#define DIALOG_REGISTER 1002
#define DIALOG_REGISTER_EMAIL 1003
#define DIALOG_REGISTER_IDADE 1004
#define DIALOG_REGISTER_SEXO 1005
#define DIALOG_CPF 1006
#define DIALOG_COMANDOS 1007
#define DIALOG_REGULAMENTO 1008
#define DIALOG_CONFIGURACOES 1009
#define DIALOG_SKIN_SELECTOR 1010

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_LOGIN:
        {
            if(!response) return Kick(playerid);
            
            if(strlen(inputtext) < 1)
            {
                SendClientMessage(playerid, COR_ERRO, "❌ Você deve digitar uma senha!");
                return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, 
                    "{FFD700}• BRASIL ELITE RP - LOGIN •", 
                    "{FF6347}❌ Senha inválida! Tente novamente.\n\n"
                    "{FFFFFF}Digite sua senha para fazer login:", 
                    "Entrar", "Sair");
            }
            
            // Verificar senha
            new hashSenha[65];
            WP_Hash(hashSenha, sizeof(hashSenha), inputtext);
            
            new query[256], nome[MAX_PLAYER_NAME];
            GetPlayerName(playerid, nome, sizeof(nome));
            
            mysql_format(conexao, query, sizeof(query), 
                "SELECT * FROM `jogadores` WHERE `nome` = '%e' AND `senha` = '%s' LIMIT 1", 
                nome, hashSenha);
            mysql_tquery(conexao, query, "OnPlayerLogin", "i", playerid);
        }
        
        case DIALOG_REGISTER:
        {
            if(!response) return Kick(playerid);
            
            if(strlen(inputtext) < 6)
            {
                SendClientMessage(playerid, COR_ERRO, "❌ A senha deve ter no mínimo 6 caracteres!");
                return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, 
                    "{FFD700}• BRASIL ELITE RP - REGISTRO •", 
                    "{FF6347}❌ Senha muito curta!\n\n"
                    "{FFFFFF}Escolha uma senha com no mínimo 6 caracteres:", 
                    "Criar Conta", "Sair");
            }
            
            if(strlen(inputtext) > 32)
            {
                SendClientMessage(playerid, COR_ERRO, "❌ A senha deve ter no máximo 32 caracteres!");
                return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, 
                    "{FFD700}• BRASIL ELITE RP - REGISTRO •", 
                    "{FF6347}❌ Senha muito longa!\n\n"
                    "{FFFFFF}Escolha uma senha com no máximo 32 caracteres:", 
                    "Criar Conta", "Sair");
            }
            
            // Salvar senha temporariamente e pedir email
            new hashSenha[65];
            WP_Hash(hashSenha, sizeof(hashSenha), inputtext);
            format(PlayerInfo[playerid][pSenha], 65, "%s", hashSenha);
            
            ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT, 
                "{FFD700}• BRASIL ELITE RP - EMAIL •", 
                "{FFFFFF}Digite seu email válido:\n\n"
                "{FFFF00}• O email será usado para recuperação de senha\n"
                "{FFFF00}• Exemplo: seuemail@gmail.com", 
                "Continuar", "Voltar");
        }
        
        case DIALOG_REGISTER_EMAIL:
        {
            if(!response) 
            {
                return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, 
                    "{FFD700}• BRASIL ELITE RP - REGISTRO •", 
                    "{FFFFFF}Escolha uma senha segura:", 
                    "Criar Conta", "Sair");
            }
            
            if(strlen(inputtext) < 5 || !strfind(inputtext, "@", true) || !strfind(inputtext, ".", true))
            {
                SendClientMessage(playerid, COR_ERRO, "❌ Digite um email válido!");
                return ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT, 
                    "{FFD700}• BRASIL ELITE RP - EMAIL •", 
                    "{FF6347}❌ Email inválido!\n\n"
                    "{FFFFFF}Digite um email válido:", 
                    "Continuar", "Voltar");
            }
            
            format(PlayerInfo[playerid][pEmail], 128, "%s", inputtext);
            
            ShowPlayerDialog(playerid, DIALOG_REGISTER_IDADE, DIALOG_STYLE_INPUT, 
                "{FFD700}• BRASIL ELITE RP - IDADE •", 
                "{FFFFFF}Digite sua idade:\n\n"
                "{FFFF00}• Idade mínima: 16 anos\n"
                "{FFFF00}• Idade máxima: 80 anos", 
                "Continuar", "Voltar");
        }
        
        case DIALOG_REGISTER_IDADE:
        {
            if(!response) 
            {
                return ShowPlayerDialog(playerid, DIALOG_REGISTER_EMAIL, DIALOG_STYLE_INPUT, 
                    "{FFD700}• BRASIL ELITE RP - EMAIL •", 
                    "{FFFFFF}Digite seu email válido:", 
                    "Continuar", "Voltar");
            }
            
            new idade = strval(inputtext);
            
            if(idade < 16 || idade > 80)
            {
                SendClientMessage(playerid, COR_ERRO, "❌ Idade deve estar entre 16 e 80 anos!");
                return ShowPlayerDialog(playerid, DIALOG_REGISTER_IDADE, DIALOG_STYLE_INPUT, 
                    "{FFD700}• BRASIL ELITE RP - IDADE •", 
                    "{FF6347}❌ Idade inválida!\n\n"
                    "{FFFFFF}Digite uma idade entre 16 e 80 anos:", 
                    "Continuar", "Voltar");
            }
            
            PlayerInfo[playerid][pIdade] = idade;
            
            ShowPlayerDialog(playerid, DIALOG_REGISTER_SEXO, DIALOG_STYLE_LIST, 
                "{FFD700}• BRASIL ELITE RP - SEXO •", 
                "{FFFFFF}Masculino\n{FFFFFF}Feminino", 
                "Continuar", "Voltar");
        }
        
        case DIALOG_REGISTER_SEXO:
        {
            if(!response) 
            {
                return ShowPlayerDialog(playerid, DIALOG_REGISTER_IDADE, DIALOG_STYLE_INPUT, 
                    "{FFD700}• BRASIL ELITE RP - IDADE •", 
                    "{FFFFFF}Digite sua idade:", 
                    "Continuar", "Voltar");
            }
            
            PlayerInfo[playerid][pSexo] = listitem; // 0 = Masculino, 1 = Feminino
            
            // Finalizar registro
            FinalizarRegistro(playerid);
        }
        
        case DIALOG_CPF:
        {
            if(!response) return 1;
            
            new string[256];
            format(string, sizeof(string), 
                "{FFD700}📋 SEUS DOCUMENTOS BRASILEIROS\n\n"
                "{FFFFFF}Nome: {00FF7F}%s\n"
                "{FFFFFF}CPF: {FFFF00}%s\n"
                "{FFFFFF}RG: {FFFF00}%s\n"
                "{FFFFFF}Idade: {00FF7F}%d anos\n"
                "{FFFFFF}Sexo: {00FF7F}%s", 
                PlayerInfo[playerid][pNome], PlayerCPF[playerid], PlayerRG[playerid], 
                PlayerInfo[playerid][pIdade], 
                (PlayerInfo[playerid][pSexo] == 0) ? "Masculino" : "Feminino");
            
            SendClientMessage(playerid, COR_AZUL_ELITE, string);
        }
        
        case DIALOG_COMANDOS:
        {
            if(!response) return 1;
            
            switch(listitem)
            {
                case 0: // Comandos Gerais
                {
                    SendClientMessage(playerid, COR_AZUL_ELITE, "═══════════════ {FFD700}COMANDOS GERAIS {AZUL_ELITE}═══════════════");
                    SendClientMessage(playerid, COR_BRANCA, "{FFFF00}/me {FFFFFF}- Fazer uma ação (ex: /me pega uma cerveja)");
                    SendClientMessage(playerid, COR_BRANCA, "{FFFF00}/do {FFFFFF}- Descrever algo (ex: /do a cerveja está gelada)");
                    SendClientMessage(playerid, COR_BRANCA, "{FFFF00}/b {FFFFFF}- Chat OOC local (ex: /b lag)");
                    SendClientMessage(playerid, COR_BRANCA, "{FFFF00}/s {FFFFFF}- Gritar (ex: /s Socorro!)");
                    SendClientMessage(playerid, COR_BRANCA, "{FFFF00}/w {FFFFFF}- Sussurrar (ex: /w oi)");
                    SendClientMessage(playerid, COR_BRANCA, "{FFFF00}/stats {FFFFFF}- Ver suas estatísticas");
                    SendClientMessage(playerid, COR_BRANCA, "{FFFF00}/tempo {FFFFFF}- Ver o tempo do servidor");
                    SendClientMessage(playerid, COR_BRANCA, "{FFFF00}/dinheiro {FFFFFF}- Ver seu dinheiro");
                    SendClientMessage(playerid, COR_BRANCA, "{FFFF00}/cpf {FFFFFF}- Ver seus documentos");
                    SendClientMessage(playerid, COR_AZUL_ELITE, "═══════════════════════════════════════════════════════");
                }
                case 1: // Comandos de Veículos
                {
                    SendClientMessage(playerid, COR_AZUL_ELITE, "═══════════════ {FFD700}COMANDOS DE VEÍCULOS {AZUL_ELITE}═══════════════");
                    SendClientMessage(playerid, COR_BRANCA, "{FFFF00}/trancar {FFFFFF}- Trancar/destrancar veículo");
                    SendClientMessage(playerid, COR_BRANCA, "{FFFF00}/motor {FFFFFF}- Ligar/desligar motor do veículo");
                    SendClientMessage(playerid, COR_BRANCA, "{FFFF00}/farol {FFFFFF}- Ligar/desligar faróis");
                    SendClientMessage(playerid, COR_BRANCA, "{FFFF00}/capô {FFFFFF}- Abrir/fechar capô");
                    SendClientMessage(playerid, COR_BRANCA, "{FFFF00}/porta-malas {FFFFFF}- Abrir/fechar porta-malas");
                    SendClientMessage(playerid, COR_BRANCA, "{FFFF00}/windows {FFFFFF}- Abrir/fechar vidros");
                    SendClientMessage(playerid, COR_BRANCA, "{FFFF00}/combustivel {FFFFFF}- Ver combustível do veículo");
                    SendClientMessage(playerid, COR_BRANCA, "{FFFF00}/km {FFFFFF}- Ver quilometragem");
                    SendClientMessage(playerid, COR_AZUL_ELITE, "═══════════════════════════════════════════════════════");
                }
                case 2: // Comandos de Casa
                {
                    SendClientMessage(playerid, COR_AZUL_ELITE, "═══════════════ {FFD700}COMANDOS DE CASA {AZUL_ELITE}═══════════════");
                    SendClientMessage(playerid, COR_BRANCA, "{FFFF00}/comprar {FFFFFF}- Comprar casa/empresa");
                    SendClientMessage(playerid, COR_BRANCA, "{FFFF00}/vender {FFFFFF}- Vender casa/empresa");
                    SendClientMessage(playerid, COR_BRANCA, "{FFFF00}/entrar {FFFFFF}- Entrar na casa/empresa");
                    SendClientMessage(playerid, COR_BRANCA, "{FFFF00}/sair {FFFFFF}- Sair da casa/empresa");
                    SendClientMessage(playerid, COR_BRANCA, "{FFFF00}/cofre {FFFFFF}- Acessar cofre da casa");
                    SendClientMessage(playerid, COR_BRANCA, "{FFFF00}/armario {FFFFFF}- Trocar de roupa");
                    SendClientMessage(playerid, COR_BRANCA, "{FFFF00}/alugar {FFFFFF}- Alugar uma casa");
                    SendClientMessage(playerid, COR_AZUL_ELITE, "═══════════════════════════════════════════════════════");
                }
            }
        }
    }
    
    return 1;
}

// ==================== SISTEMA DE COMANDOS AVANÇADOS ====================

// Comando de CPF brasileiro
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
        "{FFFFFF}📧 Email: {FFFF00}%s\n\n"
        "{FF6347}⚠️ Nunca forneça seus documentos para desconhecidos!", 
        PlayerInfo[playerid][pNome], PlayerCPF[playerid], PlayerRG[playerid], 
        PlayerInfo[playerid][pIdade], 
        (PlayerInfo[playerid][pSexo] == 0) ? "Masculino" : "Feminino",
        PlayerInfo[playerid][pEmail]);
    
    ShowPlayerDialog(playerid, DIALOG_CPF, DIALOG_STYLE_MSGBOX, 
        "{FFD700}📋 DOCUMENTOS BRASILEIROS", string, "Fechar", "");
    
    return 1;
}

// Comando de stats avançado
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
        "{FFFFFF}📊 Level: {FFD700}%d {FFFFFF}| XP: {FFD700}%d/%d\n"
        "{FFFFFF}❤️ Vida: {FF6347}%.1f%% {FFFFFF}| 🛡️ Colete: {87CEEB}%.1f%%\n"
        "{FFFFFF}🍔 Fome: {FFD700}%.1f%% {FFFFFF}| 💧 Sede: {00FFFF}%.1f%%\n"
        "{FFFFFF}⚡ Energia: {90EE90}%.1f%% {FFFFFF}| 😰 Stress: {FF4500}%.1f%%\n"
        "{FFFFFF}💼 Emprego: {FFFF00}%s\n"
        "{FFFFFF}🏠 Casa: {FFFF00}%s\n"
        "{FFFFFF}🏢 Facção: {FFFF00}%s\n"
        "{FFFFFF}⏱️ Tempo jogado: {00FF7F}%d horas\n\n"
        "{00FF7F}🎮 Bem-vindo ao Brasil Elite RP!",
        PlayerInfo[playerid][pNome], playerid,
        FormatarDinheiro(floatround(PlayerInfo[playerid][pDinheiro])),
        FormatarDinheiro(PlayerInfo[playerid][pBanco]),
        PlayerInfo[playerid][pLevel], PlayerInfo[playerid][pExp], 
        PlayerInfo[playerid][pLevel] * 1000,
        vida, colete,
        PlayerInfo[playerid][pFome], PlayerInfo[playerid][pSede],
        PlayerInfo[playerid][pEnergia], PlayerInfo[playerid][pStress],
        ObterNomeEmprego(PlayerInfo[playerid][pEmprego]),
        ObterInfoCasa(playerid),
        ObterNomeFaccao(PlayerInfo[playerid][pFaccao]),
        PlayerInfo[playerid][pTempoJogado] / 3600);
    
    ShowPlayerDialog(playerid, 9999, DIALOG_STYLE_MSGBOX, 
        "{FFD700}📊 SUAS ESTATÍSTICAS", string, "Fechar", "");
    
    return 1;
}

// Comando de comandos
CMD:comandos(playerid, params[])
{
    ShowPlayerDialog(playerid, DIALOG_COMANDOS, DIALOG_STYLE_LIST, 
        "{FFD700}• BRASIL ELITE RP - COMANDOS •", 
        "{FFFFFF}📋 Comandos Gerais\n"
        "{FFFFFF}🚗 Comandos de Veículos\n"
        "{FFFFFF}🏠 Comandos de Casa/Empresa\n"
        "{FFFFFF}💼 Comandos de Emprego\n"
        "{FFFFFF}👥 Comandos de Facção\n"
        "{FFFFFF}⚖️ Comandos de Administração", 
        "Selecionar", "Fechar");
    
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
    
    SendClientMessageToAll(COR_CHAT_LOCAL, string);
    SetPlayerChatBubble(playerid, params, 0xC2A2DAFF, 30.0, 5000);
    
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
    
    SendClientMessageToAll(COR_VERDE_ELITE, string);
    
    return 1;
}

// Comando b (chat OOC local)
CMD:b(playerid, params[])
{
    if(isnull(params))
        return SendClientMessage(playerid, COR_ERRO, "❌ Use: /b [texto]");
    
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

// ==================== SISTEMA ANTI-CHEAT AVANÇADO ====================

forward AntiCheatCheck();
public AntiCheatCheck()
{
    foreach(new i : Players)
    {
        if(!PlayerInfo[i][pLogado]) continue;
        
        // Anti Money Hack
        new dinheiro = GetPlayerMoney(i);
        if(dinheiro > PlayerAC_Money[i] + 10000) // Tolerância de R$ 10.000
        {
            ResetPlayerMoney(i);
            GivePlayerMoney(i, PlayerAC_Money[i]);
            
            new string[128];
            format(string, sizeof(string), 
                "🚨 {FF0000}%s foi detectado usando money hack! Dinheiro resetado.", 
                PlayerInfo[i][pNome]);
            SendClientMessageToAll(COR_VERMELHO_ELITE, string);
            
            PlayerAC_Warnings[i]++;
            if(PlayerAC_Warnings[i] >= 3)
            {
                BanirPlayer(i, "Sistema Anti-Cheat", "Money Hack (3 avisos)");
            }
        }
        PlayerAC_Money[i] = dinheiro;
        
        // Anti Health Hack
        new Float:vida;
        GetPlayerHealth(i, vida);
        if(vida > PlayerAC_Health[i] + 50.0 && vida > 100.0)
        {
            SetPlayerHealth(i, PlayerAC_Health[i]);
            
            new string[128];
            format(string, sizeof(string), 
                "🚨 {FF0000}%s foi detectado usando health hack!", 
                PlayerInfo[i][pNome]);
            SendClientMessageToAll(COR_VERMELHO_ELITE, string);
            
            PlayerAC_Warnings[i]++;
            if(PlayerAC_Warnings[i] >= 3)
            {
                BanirPlayer(i, "Sistema Anti-Cheat", "Health Hack (3 avisos)");
            }
        }
        PlayerAC_Health[i] = vida;
        
        // Anti Armour Hack
        new Float:colete;
        GetPlayerArmour(i, colete);
        if(colete > PlayerAC_Armour[i] + 50.0 && colete > 100.0)
        {
            SetPlayerArmour(i, PlayerAC_Armour[i]);
            
            new string[128];
            format(string, sizeof(string), 
                "🚨 {FF0000}%s foi detectado usando armour hack!", 
                PlayerInfo[i][pNome]);
            SendClientMessageToAll(COR_VERMELHO_ELITE, string);
            
            PlayerAC_Warnings[i]++;
        }
        PlayerAC_Armour[i] = colete;
        
        // Anti Speed Hack (básico)
        new Float:x, Float:y, Float:z;
        GetPlayerPos(i, x, y, z);
        
        new Float:distancia = GetDistanceBetweenPoints3D(
            PlayerAC_PosX[i], PlayerAC_PosY[i], PlayerAC_PosZ[i], x, y, z);
        
        if(!IsPlayerInAnyVehicle(i) && distancia > 50.0) // 50 metros em 2 segundos = speed hack
        {
            SetPlayerPos(i, PlayerAC_PosX[i], PlayerAC_PosY[i], PlayerAC_PosZ[i]);
            
            new string[128];
            format(string, sizeof(string), 
                "🚨 {FF0000}%s foi detectado usando speed hack!", 
                PlayerInfo[i][pNome]);
            SendClientMessageToAll(COR_VERMELHO_ELITE, string);
            
            PlayerAC_Warnings[i]++;
        }
        
        PlayerAC_PosX[i] = x;
        PlayerAC_PosY[i] = y;
        PlayerAC_PosZ[i] = z;
    }
    
    return 1;
}

// ==================== TIMERS DO SERVIDOR ====================

forward AtualizarTempo();
public AtualizarTempo()
{
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
    
    SetWorldTime(ServidorHora);
    
    // Atualizar clima aleatoriamente
    if(ServidorMinuto == 0)
    {
        new climas[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
        ServidorClima = climas[random(sizeof(climas))];
        SetWeather(ServidorClima);
    }
    
    return 1;
}

forward SalvarDados();
public SalvarDados()
{
    new salvos = 0;
    
    foreach(new i : Players)
    {
        if(PlayerInfo[i][pLogado])
        {
            SalvarPlayer(i);
            salvos++;
        }
    }
    
    printf("✅ Dados de %d jogadores salvos automaticamente.", salvos);
    
    return 1;
}

forward AtualizarHUD();
public AtualizarHUD()
{
    foreach(new i : Players)
    {
        if(!PlayerInfo[i][pLogado]) continue;
        
        // Atualizar status do player
        AtualizarStatusPlayer(i);
        
        // Atualizar HUD
        AtualizarHUDPlayer(i);
    }
    
    return 1;
}

// ==================== FUNÇÕES AUXILIARES ====================

stock ResetarVariaveisPlayer(playerid)
{
    // Resetar todas as variáveis do player
    PlayerInfo[playerid][pID] = 0;
    PlayerInfo[playerid][pLogado] = 0;
    PlayerInfo[playerid][pRegistrado] = 0;
    
    // Resetar anti-cheat
    PlayerAC_Warnings[playerid] = 0;
    PlayerAC_Money[playerid] = 0;
    PlayerAC_Health[playerid] = 100.0;
    PlayerAC_Armour[playerid] = 0.0;
    PlayerAC_PosX[playerid] = 0.0;
    PlayerAC_PosY[playerid] = 0.0;
    PlayerAC_PosZ[playerid] = 0.0;
    
    // Resetar armas
    for(new j = 0; j < 13; j++)
    {
        PlayerAC_Weapons[playerid][j] = 0;
        PlayerAC_Ammo[playerid][j] = 0;
    }
    
    return 1;
}

stock SalvarPlayer(playerid)
{
    if(!PlayerInfo[playerid][pLogado]) return 0;
    
    // Atualizar posição atual
    GetPlayerPos(playerid, PlayerInfo[playerid][pPosX], PlayerInfo[playerid][pPosY], PlayerInfo[playerid][pPosZ]);
    GetPlayerFacingAngle(playerid, PlayerInfo[playerid][pAngle]);
    PlayerInfo[playerid][pInterior] = GetPlayerInterior(playerid);
    PlayerInfo[playerid][pVirtualWorld] = GetPlayerVirtualWorld(playerid);
    
    // Atualizar dinheiro
    PlayerInfo[playerid][pDinheiro] = float(GetPlayerMoney(playerid));
    
    // Atualizar vida e colete
    GetPlayerHealth(playerid, PlayerInfo[playerid][pVida]);
    GetPlayerArmour(playerid, PlayerInfo[playerid][pColete]);
    
    // Query de update
    new query[2048];
    mysql_format(conexao, query, sizeof(query), 
        "UPDATE `jogadores` SET `dinheiro` = '%.2f', `banco` = '%d', `level` = '%d', \
        `exp` = '%d', `vida` = '%.2f', `colete` = '%.2f', `fome` = '%.2f', `sede` = '%.2f', \
        `energia` = '%.2f', `stress` = '%.2f', `pos_x` = '%.6f', `pos_y` = '%.6f', \
        `pos_z` = '%.6f', `angle` = '%.6f', `interior` = '%d', `virtual_world` = '%d', \
        `ultimo_login` = NOW(), `tempo_jogado` = '%d' WHERE `id` = '%d'",
        PlayerInfo[playerid][pDinheiro], PlayerInfo[playerid][pBanco], PlayerInfo[playerid][pLevel],
        PlayerInfo[playerid][pExp], PlayerInfo[playerid][pVida], PlayerInfo[playerid][pColete],
        PlayerInfo[playerid][pFome], PlayerInfo[playerid][pSede], PlayerInfo[playerid][pEnergia],
        PlayerInfo[playerid][pStress], PlayerInfo[playerid][pPosX], PlayerInfo[playerid][pPosY],
        PlayerInfo[playerid][pPosZ], PlayerInfo[playerid][pAngle], PlayerInfo[playerid][pInterior],
        PlayerInfo[playerid][pVirtualWorld], PlayerInfo[playerid][pTempoJogado], PlayerInfo[playerid][pID]);
    
    mysql_tquery(conexao, query);
    
    return 1;
}

stock FinalizarRegistro(playerid)
{
    // Criar conta no banco de dados
    GetPlayerName(playerid, PlayerInfo[playerid][pNome], MAX_PLAYER_NAME);
    
    // Definir valores padrão
    PlayerInfo[playerid][pDinheiro] = 5000.0;
    PlayerInfo[playerid][pBanco] = 0;
    PlayerInfo[playerid][pLevel] = 1;
    PlayerInfo[playerid][pExp] = 0;
    PlayerInfo[playerid][pVida] = 100.0;
    PlayerInfo[playerid][pColete] = 0.0;
    PlayerInfo[playerid][pFome] = 100.0;
    PlayerInfo[playerid][pSede] = 100.0;
    PlayerInfo[playerid][pEnergia] = 100.0;
    PlayerInfo[playerid][pStress] = 0.0;
    PlayerInfo[playerid][pPosX] = 1684.9;
    PlayerInfo[playerid][pPosY] = -2244.5;
    PlayerInfo[playerid][pPosZ] = 13.5;
    PlayerInfo[playerid][pAngle] = 0.0;
    PlayerInfo[playerid][pInterior] = 0;
    PlayerInfo[playerid][pVirtualWorld] = 0;
    PlayerInfo[playerid][pSkin] = (PlayerInfo[playerid][pSexo] == 0) ? 26 : 56;
    
    // Query de inserção
    new query[1024];
    mysql_format(conexao, query, sizeof(query), 
        "INSERT INTO `jogadores` (`nome`, `senha`, `email`, `cpf`, `rg`, `idade`, `sexo`, \
        `dinheiro`, `skin`) VALUES ('%e', '%s', '%e', '%e', '%e', '%d', '%d', '%.2f', '%d')",
        PlayerInfo[playerid][pNome], PlayerInfo[playerid][pSenha], PlayerInfo[playerid][pEmail],
        PlayerCPF[playerid], PlayerRG[playerid], PlayerInfo[playerid][pIdade],
        PlayerInfo[playerid][pSexo], PlayerInfo[playerid][pDinheiro], PlayerInfo[playerid][pSkin]);
    
    mysql_tquery(conexao, query, "OnPlayerRegistered", "i", playerid);
    
    return 1;
}

forward OnPlayerRegistered(playerid);
public OnPlayerRegistered(playerid)
{
    PlayerInfo[playerid][pID] = cache_insert_id();
    PlayerInfo[playerid][pRegistrado] = 1;
    PlayerInfo[playerid][pLogado] = 1;
    
    // Mensagens de boas-vindas
    SendClientMessage(playerid, COR_VERDE_ELITE, "✅ Conta criada com sucesso!");
    SendClientMessage(playerid, COR_AZUL_ELITE, "🎉 Bem-vindo ao Brasil Elite RP!");
    SendClientMessage(playerid, COR_BRANCA, "📋 Digite {FFFF00}/comandos {FFFFFF}para ver os comandos disponíveis.");
    SendClientMessage(playerid, COR_BRANCA, "📖 Digite {FFFF00}/regulamento {FFFFFF}para ler as regras do servidor.");
    
    // Spawnar o player
    SpawnPlayer(playerid);
    
    return 1;
}

// ==================== INCLUIR FUNÇÕES AUXILIARES ====================
#include "brasil_elite_rp_funcoes.pwn"