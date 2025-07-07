/*
===============================================================================
    🛠️ BRASIL ELITE RP - FUNÇÕES AUXILIARES 🛠️
    
    Este arquivo contém todas as funções auxiliares necessárias para o
    funcionamento completo da GameMode Brasil Elite RP
===============================================================================
*/

// ==================== FUNÇÕES AUXILIARES NECESSÁRIAS ====================

// Forward para OnPlayerLogin
forward OnPlayerLogin(playerid);
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
    
    // Mensagem para o banido
    format(string, sizeof(string), 
        "🔨 {FF0000}Você foi banido do servidor!\n\n"
        "{FFFFFF}Admin: {FFD700}%s\n"
        "{FFFFFF}Motivo: {FFD700}%s\n\n"
        "{00FF7F}Recurso: discord.gg/brasielite", admin, motivo);
    
    ShowPlayerDialog(playerid, 9998, DIALOG_STYLE_MSGBOX, 
        "{FF0000}BANIDO DO SERVIDOR", string, "Sair", "");
    
    SetTimerEx("KickPlayerDelayed", 3000, false, "i", playerid);
    
    return 1;
}

forward KickPlayerDelayed(playerid);
public KickPlayerDelayed(playerid)
{
    Kick(playerid);
    return 1;
}

// Funções para carregar dados do servidor
stock CarregarHousas()
{
    new query[256];
    mysql_format(conexao, query, sizeof(query), "SELECT * FROM `casas` WHERE `existe` = 1");
    mysql_tquery(conexao, query, "OnHousesLoaded");
    
    return 1;
}

forward OnHousesLoaded();
public OnHousesLoaded()
{
    new rows = cache_num_rows();
    new casas_carregadas = 0;
    
    for(new i = 0; i < rows; i++)
    {
        new id;
        cache_get_value_name_int(i, "id", id);
        
        if(id >= MAX_HOUSES) continue;
        
        HouseInfo[id][hExiste] = 1;
        cache_get_value_name(i, "dono", HouseInfo[id][hDono], 24);
        cache_get_value_name_float(i, "entrada_x", HouseInfo[id][hEntradaX]);
        cache_get_value_name_float(i, "entrada_y", HouseInfo[id][hEntradaY]);
        cache_get_value_name_float(i, "entrada_z", HouseInfo[id][hEntradaZ]);
        cache_get_value_name_int(i, "preco", HouseInfo[id][hPreco]);
        cache_get_value_name_int(i, "trancada", HouseInfo[id][hTrancada]);
        
        // Criar pickup e 3D text
        HouseInfo[id][hPickup] = CreateDynamicPickup(1273, 1, 
            HouseInfo[id][hEntradaX], HouseInfo[id][hEntradaY], HouseInfo[id][hEntradaZ]);
        
        new string[256];
        if(!strcmp(HouseInfo[id][hDono], "Ninguém"))
        {
            format(string, sizeof(string), 
                "{FFD700}🏠 CASA À VENDA\n"
                "{FFFFFF}Preço: {00FF00}R$ %s\n"
                "{FFFFFF}Digite {FFFF00}/comprar {FFFFFF}para comprar", 
                FormatarDinheiro(HouseInfo[id][hPreco]));
        }
        else
        {
            format(string, sizeof(string), 
                "{FFD700}🏠 CASA PRIVADA\n"
                "{FFFFFF}Proprietário: {00FF7F}%s\n"
                "{FFFFFF}Digite {FFFF00}/entrar {FFFFFF}para entrar", 
                HouseInfo[id][hDono]);
        }
        
        HouseInfo[id][hText3D] = CreateDynamic3DTextLabel(string, 0xFFFFFFFF, 
            HouseInfo[id][hEntradaX], HouseInfo[id][hEntradaY], HouseInfo[id][hEntradaZ] + 0.5, 
            15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
        
        Iter_Add(Houses, id);
        casas_carregadas++;
    }
    
    printf("✅ %d casas carregadas com sucesso!", casas_carregadas);
    
    return 1;
}

stock CarregarVeiculos()
{
    new query[256];
    mysql_format(conexao, query, sizeof(query), "SELECT * FROM `veiculos` WHERE `existe` = 1");
    mysql_tquery(conexao, query, "OnVehiclesLoaded");
    
    return 1;
}

forward OnVehiclesLoaded();
public OnVehiclesLoaded()
{
    new rows = cache_num_rows();
    new veiculos_carregados = 0;
    
    for(new i = 0; i < rows; i++)
    {
        new id;
        cache_get_value_name_int(i, "id", id);
        
        if(id >= MAX_VEHICLES_SERVER) continue;
        
        VehicleInfo[id][vExiste] = 1;
        cache_get_value_name_int(i, "modelo", VehicleInfo[id][vModelo]);
        cache_get_value_name(i, "dono", VehicleInfo[id][vDono], 24);
        cache_get_value_name_float(i, "pos_x", VehicleInfo[id][vPosX]);
        cache_get_value_name_float(i, "pos_y", VehicleInfo[id][vPosY]);
        cache_get_value_name_float(i, "pos_z", VehicleInfo[id][vPosZ]);
        cache_get_value_name_float(i, "angle", VehicleInfo[id][vAngle]);
        cache_get_value_name_int(i, "cor1", VehicleInfo[id][vCor1]);
        cache_get_value_name_int(i, "cor2", VehicleInfo[id][vCor2]);
        cache_get_value_name_float(i, "combustivel", VehicleInfo[id][vCombustivel]);
        cache_get_value_name(i, "placa", VehicleInfo[id][vPlaca], 9);
        
        // Criar veículo no jogo
        VehicleInfo[id][vID] = CreateVehicle(VehicleInfo[id][vModelo], 
            VehicleInfo[id][vPosX], VehicleInfo[id][vPosY], VehicleInfo[id][vPosZ], VehicleInfo[id][vAngle], 
            VehicleInfo[id][vCor1], VehicleInfo[id][vCor2], -1);
        
        SetVehicleNumberPlate(VehicleInfo[id][vID], VehicleInfo[id][vPlaca]);
        
        Iter_Add(Vehicles, id);
        veiculos_carregados++;
    }
    
    printf("✅ %d veículos carregados com sucesso!", veiculos_carregados);
    
    return 1;
}

stock CarregarFaccoes()
{
    // Por enquanto criar facções padrão
    // Facção 1 - PMERJ
    FactionInfo[1][fExiste] = 1;
    format(FactionInfo[1][fNome], 64, "Polícia Militar do Estado do Rio de Janeiro");
    format(FactionInfo[1][fTag], 8, "[PMERJ]");
    FactionInfo[1][fCor] = 0x0080FFFF;
    FactionInfo[1][fTipo] = 1; // Policial
    format(FactionInfo[1][fLider], MAX_PLAYER_NAME, "Ninguém");
    FactionInfo[1][fMaxMembros] = 50;
    
    // Facção 2 - CV
    FactionInfo[2][fExiste] = 1;
    format(FactionInfo[2][fNome], 64, "Comando Vermelho");
    format(FactionInfo[2][fTag], 8, "[CV]");
    FactionInfo[2][fCor] = 0xFF0000FF;
    FactionInfo[2][fTipo] = 2; // Criminal
    format(FactionInfo[2][fLider], MAX_PLAYER_NAME, "Ninguém");
    FactionInfo[2][fMaxMembros] = 30;
    
    printf("✅ Facções padrão criadas com sucesso!");
    
    return 1;
}

stock CarregarEmpregos()
{
    // Emprego 1 - Lixeiro
    JobInfo[1][jExiste] = 1;
    format(JobInfo[1][jNome], 64, "Lixeiro");
    format(JobInfo[1][jDescricao], 128, "Colete o lixo pela cidade e mantenha-a limpa!");
    JobInfo[1][jPosX] = 2200.0;
    JobInfo[1][jPosY] = -2000.0;
    JobInfo[1][jPosZ] = 13.5;
    JobInfo[1][jSalarioMin] = 500;
    JobInfo[1][jSalarioMax] = 1500;
    JobInfo[1][jMaxVagas] = 20;
    
    // Emprego 2 - Entregador
    JobInfo[2][jExiste] = 1;
    format(JobInfo[2][jNome], 64, "Entregador");
    format(JobInfo[2][jDescricao], 128, "Entregue produtos pela cidade usando moto ou bicicleta!");
    JobInfo[2][jPosX] = 2100.0;
    JobInfo[2][jPosY] = -1900.0;
    JobInfo[2][jPosZ] = 13.5;
    JobInfo[2][jSalarioMin] = 600;
    JobInfo[2][jSalarioMax] = 2000;
    JobInfo[2][jMaxVagas] = 15;
    
    // Emprego 3 - Taxista
    JobInfo[3][jExiste] = 1;
    format(JobInfo[3][jNome], 64, "Taxista");
    format(JobInfo[3][jDescricao], 128, "Transporte passageiros pela cidade!");
    JobInfo[3][jPosX] = 1800.0;
    JobInfo[3][jPosY] = -1850.0;
    JobInfo[3][jPosZ] = 13.5;
    JobInfo[3][jSalarioMin] = 800;
    JobInfo[3][jSalarioMax] = 2500;
    JobInfo[3][jMaxVagas] = 25;
    
    printf("✅ Empregos carregados com sucesso!");
    
    return 1;
}

// Função GetDistanceBetweenPoints3D (implementação)
stock Float:GetDistanceBetweenPoints3D(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
    return floatsqroot(
        (x2 - x1) * (x2 - x1) + 
        (y2 - y1) * (y2 - y1) + 
        (z2 - z1) * (z2 - z1)
    );
}

// Função para verificar se string está vazia
stock isnull(const string[])
{
    return (strlen(string) == 0);
}