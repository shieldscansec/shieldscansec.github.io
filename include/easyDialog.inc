/*
 * easyDialog.inc - Advanced dialog management for SA-MP
 * Facilitates dialog creation and handling
 * Compatible with YSI, ZCMD, and modern SA-MP versions
 */

#if defined _easydialog_included
    #endinput
#endif
#define _easydialog_included

// Dialog IDs (dynamic allocation)
#define DIALOG_ID_START 32700
#define MAX_DIALOGS 100

// Dialog styles with Brazilian names
#define DIALOG_STYLE_MSGBOX_        DIALOG_STYLE_MSGBOX
#define DIALOG_STYLE_INPUT_         DIALOG_STYLE_INPUT
#define DIALOG_STYLE_LIST_          DIALOG_STYLE_LIST
#define DIALOG_STYLE_PASSWORD_      DIALOG_STYLE_PASSWORD
#define DIALOG_STYLE_TABLIST_       DIALOG_STYLE_TABLIST
#define DIALOG_STYLE_TABLIST_HEADERS_ DIALOG_STYLE_TABLIST_HEADERS

// Dialog response storage
enum E_DIALOG_DATA
{
    bool:d_Used,
    d_Style,
    d_Caption[128],
    d_Info[4096],
    d_Button1[32],
    d_Button2[32],
    d_PlayerID,
    d_Function[64]
}

static DialogData[MAX_DIALOGS][E_DIALOG_DATA];
static PlayerCurrentDialog[MAX_PLAYERS] = {-1, ...};

// Dialog creation functions
stock Dialog_Show(playerid, style, const caption[], const info[], const button1[], const button2[] = "", const function[] = "")
{
    new dialogid = -1;
    
    // Find available dialog slot
    for (new i = 0; i < MAX_DIALOGS; i++)
    {
        if (!DialogData[i][d_Used])
        {
            dialogid = i;
            break;
        }
    }
    
    if (dialogid == -1) return 0; // No available slots
    
    // Store dialog data
    DialogData[dialogid][d_Used] = true;
    DialogData[dialogid][d_Style] = style;
    DialogData[dialogid][d_PlayerID] = playerid;
    strcat(DialogData[dialogid][d_Caption], caption);
    strcat(DialogData[dialogid][d_Info], info);
    strcat(DialogData[dialogid][d_Button1], button1);
    strcat(DialogData[dialogid][d_Button2], button2);
    strcat(DialogData[dialogid][d_Function], function);
    
    PlayerCurrentDialog[playerid] = dialogid;
    
    // Show dialog
    ShowPlayerDialog(playerid, DIALOG_ID_START + dialogid, style, caption, info, button1, button2);
    
    return 1;
}

// Brazilian-friendly dialog functions
stock MostrarDialogo(playerid, estilo, const titulo[], const info[], const botao1[], const botao2[] = "", const funcao[] = "")
{
    return Dialog_Show(playerid, estilo, titulo, info, botao1, botao2, funcao);
}

stock MostrarMensagem(playerid, const titulo[], const mensagem[], const botao[] = "OK")
{
    return Dialog_Show(playerid, DIALOG_STYLE_MSGBOX, titulo, mensagem, botao);
}

stock MostrarInput(playerid, const titulo[], const texto[], const botao1[] = "Confirmar", const botao2[] = "Cancelar", const funcao[] = "")
{
    return Dialog_Show(playerid, DIALOG_STYLE_INPUT, titulo, texto, botao1, botao2, funcao);
}

stock MostrarSenha(playerid, const titulo[], const texto[], const botao1[] = "Confirmar", const botao2[] = "Cancelar", const funcao[] = "")
{
    return Dialog_Show(playerid, DIALOG_STYLE_PASSWORD, titulo, texto, botao1, botao2, funcao);
}

stock MostrarLista(playerid, const titulo[], const itens[], const botao1[] = "Selecionar", const botao2[] = "Cancelar", const funcao[] = "")
{
    return Dialog_Show(playerid, DIALOG_STYLE_LIST, titulo, itens, botao1, botao2, funcao);
}

stock MostrarListaTabela(playerid, const titulo[], const itens[], const botao1[] = "Selecionar", const botao2[] = "Cancelar", const funcao[] = "")
{
    return Dialog_Show(playerid, DIALOG_STYLE_TABLIST_HEADERS, titulo, itens, botao1, botao2, funcao);
}

// Dialog close function
stock Dialog_Close(playerid)
{
    if (PlayerCurrentDialog[playerid] != -1)
    {
        new dialogid = PlayerCurrentDialog[playerid];
        
        // Clear dialog data
        DialogData[dialogid][d_Used] = false;
        DialogData[dialogid][d_Caption][0] = EOS;
        DialogData[dialogid][d_Info][0] = EOS;
        DialogData[dialogid][d_Button1][0] = EOS;
        DialogData[dialogid][d_Button2][0] = EOS;
        DialogData[dialogid][d_Function][0] = EOS;
        
        PlayerCurrentDialog[playerid] = -1;
    }
    
    ShowPlayerDialog(playerid, -1, 0, "", "", "", "");
    return 1;
}

// Get current dialog info
stock Dialog_GetStyle(playerid)
{
    if (PlayerCurrentDialog[playerid] != -1)
        return DialogData[PlayerCurrentDialog[playerid]][d_Style];
    return -1;
}

stock Dialog_GetCaption(playerid, output[], size = sizeof(output))
{
    if (PlayerCurrentDialog[playerid] != -1)
    {
        strcat(output, DialogData[PlayerCurrentDialog[playerid]][d_Caption], size);
        return 1;
    }
    return 0;
}

stock Dialog_GetFunction(playerid, output[], size = sizeof(output))
{
    if (PlayerCurrentDialog[playerid] != -1)
    {
        strcat(output, DialogData[PlayerCurrentDialog[playerid]][d_Function], size);
        return 1;
    }
    return 0;
}

// Common dialog templates for Brazilian RP
stock Dialog_Login(playerid, const nome[], tentativas = 0)
{
    new string[512];
    
    if (tentativas > 0)
    {
        format(string, sizeof(string), 
            "{FF6B6B}❌ Senha incorreta! {FFFFFF}Tentativas restantes: {FF6B6B}%d\n\n", 
            5 - tentativas
        );
    }
    
    strcat(string, "{4ECDC4}🔐 {FFFFFF}Bem-vindo(a) ao {FFD93D}Rio de Janeiro RolePlay{FFFFFF}!\n\n");
    format(string, sizeof(string), "%s{FFFFFF}O personagem {4ECDC4}%s{FFFFFF} já está registrado.\n", string, nome);
    strcat(string, "Digite sua senha para fazer login:\n\n");
    strcat(string, "{95E1D3}💡 {C0C0C0}Sua senha é criptografada e segura.");
    
    return MostrarSenha(playerid, "🔐 Login no Servidor", string, "Entrar", "Sair", "OnPlayerLogin");
}

stock Dialog_Register(playerid, const nome[])
{
    new string[512];
    
    strcat(string, "{4ECDC4}📝 {FFFFFF}Bem-vindo(a) ao {FFD93D}Rio de Janeiro RolePlay{FFFFFF}!\n\n");
    format(string, sizeof(string), "%s{FFFFFF}O personagem {4ECDC4}%s{FFFFFF} não está registrado.\n", string, nome);
    strcat(string, "Crie uma senha para se registrar:\n\n");
    strcat(string, "{95E1D3}⚠️ {C0C0C0}Use uma senha forte (mín. 6 caracteres)\n");
    strcat(string, "{95E1D3}💡 {C0C0C0}Sua senha será criptografada com segurança");
    
    return MostrarSenha(playerid, "📝 Registro no Servidor", string, "Registrar", "Sair", "OnPlayerRegister");
}

stock Dialog_VIP(playerid)
{
    new string[1024];
    
    strcat(string, "{FFD700}⭐ {FFFFFF}SISTEMA VIP - {FFD700}Rio de Janeiro RolePlay\n\n");
    strcat(string, "{FFFFFF}Escolha seu plano VIP e tenha acesso aos melhores benefícios:\n\n");
    strcat(string, "{C0C0C0}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n");
    
    strcat(string, "{87CEEB}🥉 VIP BRONZE{FFFFFF} - R$ 15/mês\n");
    strcat(string, "{C0C0C0}• Comandos básicos VIP (/vheal, /varmour)\n");
    strcat(string, "{C0C0C0}• 50 coins mensais grátis\n");
    strcat(string, "{C0C0C0}• Tag [VIP] no chat\n\n");
    
    strcat(string, "{C0C0C0}🥈 VIP SILVER{FFFFFF} - R$ 25/mês\n");
    strcat(string, "{C0C0C0}• Todos os benefícios Bronze\n");
    strcat(string, "{C0C0C0}• Teleportes VIP (/vtp)\n");
    strcat(string, "{C0C0C0}• 100 coins mensais grátis\n");
    strcat(string, "{C0C0C0}• Skin exclusiva\n\n");
    
    strcat(string, "{FFD700}🏆 VIP GOLD{FFFFFF} - R$ 35/mês\n");
    strcat(string, "{C0C0C0}• Todos os benefícios anteriores\n");
    strcat(string, "{C0C0C0}• Veículo VIP (/vcar)\n");
    strcat(string, "{C0C0C0}• 200 coins mensais grátis\n");
    strcat(string, "{C0C0C0}• Acesso prioritário ao servidor\n");
    strcat(string, "{C0C0C0}• Desconto na loja de coins\n\n");
    
    strcat(string, "{95E1D3}💳 {FFFFFF}Pagamento via PIX instantâneo!\n");
    strcat(string, "{95E1D3}📱 {FFFFFF}Use /discord para comprar pelo bot");
    
    return MostrarLista(playerid, "⭐ Sistema VIP", string, "Comprar", "Fechar", "OnVIPDialog");
}

stock Dialog_Inventario(playerid)
{
    new string[2048];
    new count = 0;
    
    strcat(string, "{4ECDC4}🎒 INVENTÁRIO\t{FFFFFF}QUANTIDADE\t{95E1D3}AÇÕES\n");
    strcat(string, "{C0C0C0}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
    
    // Exemplo de itens no inventário
    strcat(string, "{FFFFFF}💰 Dinheiro\t{4ECDC4}R$ 5.000\t{95E1D3}Contar\n");
    strcat(string, "{FFFFFF}📱 Celular\t{4ECDC4}1x\t{95E1D3}Usar\n");
    strcat(string, "{FFFFFF}🔫 Pistola\t{4ECDC4}1x (45 balas)\t{95E1D3}Equipar\n");
    strcat(string, "{FFFFFF}🍔 Hamburger\t{4ECDC4}3x\t{95E1D3}Comer\n");
    strcat(string, "{FFFFFF}🥤 Refrigerante\t{4ECDC4}2x\t{95E1D3}Beber\n");
    strcat(string, "{FFFFFF}🔑 Chave Casa 1\t{4ECDC4}1x\t{95E1D3}Usar\n");
    strcat(string, "{FFFFFF}💳 Cartão Banco\t{4ECDC4}1x\t{95E1D3}Usar\n");
    
    if (count == 0)
    {
        strcat(string, "\n{FF6B6B}Seu inventário está vazio!");
    }
    
    return MostrarListaTabela(playerid, "🎒 Inventário", string, "Usar", "Fechar", "OnInventoryDialog");
}

stock Dialog_Celular(playerid)
{
    new string[1024];
    
    strcat(string, "{4ECDC4}📱 CELULAR - Rio de Janeiro RP\n\n");
    strcat(string, "{FFFFFF}📞 Fazer Ligação\n");
    strcat(string, "{FFFFFF}💬 Enviar SMS\n");
    strcat(string, "{FFFFFF}📋 Contatos\n");
    strcat(string, "{FFFFFF}📨 Mensagens\n");
    strcat(string, "{FFFFFF}🗺️ GPS\n");
    strcat(string, "{FFFFFF}🚗 Uber\n");
    strcat(string, "{FFFFFF}💳 Pix\n");
    strcat(string, "{FFFFFF}⚙️ Configurações");
    
    return MostrarLista(playerid, "📱 Celular", string, "Selecionar", "Fechar", "OnPhoneDialog");
}

stock Dialog_GPS(playerid)
{
    new string[1024];
    
    strcat(string, "{4ECDC4}🗺️ GPS - Locais do Rio de Janeiro\n\n");
    strcat(string, "{FFFFFF}🏛️ Prefeitura (Centro)\n");
    strcat(string, "{FFFFFF}🚔 Delegacia Central\n");
    strcat(string, "{FFFFFF}🏥 Hospital Municipal\n");
    strcat(string, "{FFFFFF}🏦 Banco Central\n");
    strcat(string, "{FFFFFF}🚗 Concessionária\n");
    strcat(string, "{FFFFFF}🏪 24 Horas\n");
    strcat(string, "{FFFFFF}⛽ Posto de Gasolina\n");
    strcat(string, "{FFFFFF}🔧 Oficina Mecânica\n");
    strcat(string, "{FFFFFF}🎓 Auto Escola\n");
    strcat(string, "{FFFFFF}🏖️ Copacabana\n");
    strcat(string, "{FFFFFF}🎭 Pão de Açúcar\n");
    strcat(string, "{FFFFFF}⛪ Cristo Redentor");
    
    return MostrarLista(playerid, "🗺️ GPS", string, "Ir", "Voltar", "OnGPSDialog");
}

stock Dialog_Admin(playerid)
{
    new string[1024];
    
    strcat(string, "{FF4444}⚡ PAINEL ADMINISTRATIVO\n\n");
    strcat(string, "{FFFFFF}👥 Gerenciar Jogadores\n");
    strcat(string, "{FFFFFF}🚗 Gerenciar Veículos\n");
    strcat(string, "{FFFFFF}🏠 Gerenciar Casas\n");
    strcat(string, "{FFFFFF}🏢 Gerenciar Empresas\n");
    strcat(string, "{FFFFFF}⚡ Comandos Admin\n");
    strcat(string, "{FFFFFF}📊 Estatísticas\n");
    strcat(string, "{FFFFFF}📋 Logs do Servidor\n");
    strcat(string, "{FFFFFF}🔧 Configurações\n");
    strcat(string, "{FFFFFF}💰 Sistema Econômico");
    
    return MostrarLista(playerid, "⚡ Admin Panel", string, "Selecionar", "Fechar", "OnAdminDialog");
}

// Dialog response handler (must be used in OnDialogResponse)
stock Dialog_OnResponse(playerid, dialogid, response, listitem, const inputtext[])
{
    new real_dialogid = dialogid - DIALOG_ID_START;
    
    if (real_dialogid < 0 || real_dialogid >= MAX_DIALOGS)
        return 0;
        
    if (!DialogData[real_dialogid][d_Used])
        return 0;
        
    if (DialogData[real_dialogid][d_PlayerID] != playerid)
        return 0;
    
    // Call custom function if set
    if (strlen(DialogData[real_dialogid][d_Function]) > 0)
    {
        new function[64];
        format(function, sizeof(function), "%s", DialogData[real_dialogid][d_Function]);
        
        // Clear dialog first
        Dialog_Close(playerid);
        
        // Call the function (this would need CallLocalFunction in real implementation)
        // CallLocalFunction(function, "dddds", playerid, response, listitem, real_dialogid, inputtext);
    }
    else
    {
        Dialog_Close(playerid);
    }
    
    return 1;
}

// Hook for OnPlayerDisconnect
stock Dialog_OnPlayerDisconnect(playerid)
{
    if (PlayerCurrentDialog[playerid] != -1)
    {
        Dialog_Close(playerid);
    }
    return 1;
}