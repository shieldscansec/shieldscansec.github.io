/*
====================================================================================================
    MAPPING DAS FAVELAS CARIOCAS - RIO DE JANEIRO ROLEPLAY
    
    Favelas mapeadas:
    - Rocinha (Zona Sul)
    - Complexo do Alemão (Zona Norte)
    - Cidade de Deus (Barra da Tijuca)
    - Morro da Providência (Porto)
    - Vila Cruzeiro (Penha)
    - Morro do Borel (Tijuca)
    
    Características:
    - Becos estreitos e realistas
    - Lajes e terraços
    - Pontos de tráfico
    - Entrada de UPPs
    - Comércios locais
    
    Autor: Rio de Janeiro RP Team
    Versão: 1.5
====================================================================================================
*/

#include <a_samp>
#include <streamer>

// Cores das favelas
#define COR_FAVELA      0x8B4513FF
#define COR_UPP         0x0000FFFF
#define COR_COMERCIO    0x00FF00FF
#define COR_PERIGO      0xFF0000FF

// IDs das favelas
#define FAVELA_ROCINHA      1
#define FAVELA_ALEMAO       2
#define FAVELA_CIDADE_DEUS  3
#define FAVELA_PROVIDENCIA  4
#define FAVELA_CRUZEIRO     5
#define FAVELA_BOREL        6

// Variáveis globais
new Text3D:FavelaLabels[100];
new FavelaObjects[500];
new FavelaPickups[50];
new LabelCount = 0;
new ObjectCount = 0;
new PickupCount = 0;

public OnFilterScriptInit()
{
    print("\n=========================================");
    print("  MAPPING FAVELAS - Rio de Janeiro RP");
    print("  Carregando favelas cariocas...");
    print("=========================================\n");
    
    // Criar mapping das favelas
    CreateFavelaRocinha();
    CreateFavelaAlemao();
    CreateFavelaCidadeDeus();
    CreateFavelaProvidencia();
    CreateFavelaCruzeiro();
    CreateFavelaBorel();
    
    // Criar pickups e labels
    CreateFavelaPickups();
    CreateFavelaLabels();
    
    print("✅ Todas as favelas foram carregadas com sucesso!");
    printf("📊 Total: %d objetos, %d pickups, %d labels", ObjectCount, PickupCount, LabelCount);
    
    return 1;
}

public OnFilterScriptExit()
{
    // Destruir objetos
    for (new i = 0; i < ObjectCount; i++)
    {
        if (IsValidDynamicObject(FavelaObjects[i]))
        {
            DestroyDynamicObject(FavelaObjects[i]);
        }
    }
    
    // Destruir pickups
    for (new i = 0; i < PickupCount; i++)
    {
        if (IsValidDynamicPickup(FavelaPickups[i]))
        {
            DestroyDynamicPickup(FavelaPickups[i]);
        }
    }
    
    // Destruir labels
    for (new i = 0; i < LabelCount; i++)
    {
        if (FavelaLabels[i] != Text3D:INVALID_3DTEXT_ID)
        {
            Delete3DTextLabel(FavelaLabels[i]);
        }
    }
    
    print("Mapping das favelas descarregado!");
    return 1;
}

// ====================================================================================================
// FAVELA DA ROCINHA (ZONA SUL)
// ====================================================================================================

stock CreateFavelaRocinha()
{
    print("🏠 Criando Favela da Rocinha...");
    
    // Base principal da Rocinha (próximo ao São Conrado)
    new Float:rocinha_x = -2700.0, Float:rocinha_y = -1500.0, Float:rocinha_z = 5.0;
    
    // === CASAS E BARRACOS ===
    
    // Casas de alvenaria (parte baixa)
    for (new i = 0; i < 15; i++)
    {
        for (new j = 0; j < 10; j++)
        {
            new Float:x = rocinha_x + (i * 8.0) + random(3);
            new Float:y = rocinha_y + (j * 6.0) + random(2);
            new Float:z = rocinha_z + (random(2) * 3.0);
            new Float:rotation = random(360);
            
            // Casas variadas
            new models[] = {1408, 1409, 1410, 1411, 1412}; // Modelos de casas
            new model = models[random(sizeof(models))];
            
            FavelaObjects[ObjectCount++] = CreateDynamicObject(model, x, y, z, 0.0, 0.0, rotation);
        }
    }
    
    // Lajes e terraços
    for (new i = 0; i < 20; i++)
    {
        new Float:x = rocinha_x + random(100) - 50;
        new Float:y = rocinha_y + random(60) - 30;
        new Float:z = rocinha_z + 3.0 + (random(4) * 3.0);
        
        FavelaObjects[ObjectCount++] = CreateDynamicObject(3095, x, y, z, 0.0, 0.0, random(360)); // Laje
    }
    
    // === BECOS E VIELAS ===
    
    // Muros e paredes dos becos
    for (new i = 0; i < 30; i++)
    {
        new Float:x = rocinha_x + random(80) - 40;
        new Float:y = rocinha_y + random(50) - 25;
        new Float:z = rocinha_z;
        
        FavelaObjects[ObjectCount++] = CreateDynamicObject(3037, x, y, z, 0.0, 0.0, random(4) * 90.0); // Muro
    }
    
    // === COMÉRCIOS LOCAIS ===
    
    // Botecos e vendas
    FavelaObjects[ObjectCount++] = CreateDynamicObject(1209, rocinha_x + 20, rocinha_y + 15, rocinha_z, 0.0, 0.0, 45.0); // Bar
    FavelaObjects[ObjectCount++] = CreateDynamicObject(1302, rocinha_x + 25, rocinha_y + 20, rocinha_z, 0.0, 0.0, 0.0); // Venda
    FavelaObjects[ObjectCount++] = CreateDynamicObject(1340, rocinha_x + 30, rocinha_y + 25, rocinha_z, 0.0, 0.0, 90.0); // Feira
    
    // === PONTOS ESTRATÉGICOS ===
    
    // Ponto do tráfico (escondido)
    FavelaObjects[ObjectCount++] = CreateDynamicObject(2358, rocinha_x + 45, rocinha_y + 35, rocinha_z + 6.0, 0.0, 0.0, 0.0); // Casa escondida
    
    // Entrada da UPP
    FavelaObjects[ObjectCount++] = CreateDynamicObject(968, rocinha_x - 10, rocinha_y - 5, rocinha_z, 0.0, 0.0, 0.0); // Barreira policial
    FavelaObjects[ObjectCount++] = CreateDynamicObject(3265, rocinha_x - 8, rocinha_y - 3, rocinha_z, 0.0, 0.0, 45.0); // Container UPP
    
    // === DETALHES AMBIENTAIS ===
    
    // Antenas de TV
    for (new i = 0; i < 8; i++)
    {
        new Float:x = rocinha_x + random(60);
        new Float:y = rocinha_y + random(40);
        new Float:z = rocinha_z + 8.0 + random(5);
        
        FavelaObjects[ObjectCount++] = CreateDynamicObject(1251, x, y, z, 0.0, 0.0, random(360)); // Antena
    }
    
    // Fios elétricos improvisados
    for (new i = 0; i < 15; i++)
    {
        new Float:x = rocinha_x + random(70);
        new Float:y = rocinha_y + random(45);
        new Float:z = rocinha_z + 4.0 + random(3);
        
        FavelaObjects[ObjectCount++] = CreateDynamicObject(1251, x, y, z, 0.0, 0.0, random(360)); // Poste improvisado
    }
    
    // Lixo e entulho
    for (new i = 0; i < 12; i++)
    {
        new Float:x = rocinha_x + random(80);
        new Float:y = rocinha_y + random(50);
        new Float:z = rocinha_z;
        
        FavelaObjects[ObjectCount++] = CreateDynamicObject(1359, x, y, z, 0.0, 0.0, random(360)); // Lixo
    }
    
    print("✅ Rocinha criada com sucesso!");
}

// ====================================================================================================
// COMPLEXO DO ALEMÃO (ZONA NORTE)
// ====================================================================================================

stock CreateFavelaAlemao()
{
    print("🏠 Criando Complexo do Alemão...");
    
    // Base do Alemão (área montanhosa)
    new Float:alemao_x = 2500.0, Float:alemao_y = -1200.0, Float:alemao_z = 10.0;
    
    // === TELEFÉRICO DO ALEMÃO ===
    
    // Torres do teleférico
    FavelaObjects[ObjectCount++] = CreateDynamicObject(3242, alemao_x, alemao_y, alemao_z + 15.0, 0.0, 0.0, 0.0);
    FavelaObjects[ObjectCount++] = CreateDynamicObject(3242, alemao_x + 50, alemao_y + 30, alemao_z + 20.0, 0.0, 0.0, 0.0);
    FavelaObjects[ObjectCount++] = CreateDynamicObject(3242, alemao_x + 100, alemao_y + 60, alemao_z + 25.0, 0.0, 0.0, 0.0);
    
    // Cabos do teleférico
    for (new i = 0; i < 10; i++)
    {
        new Float:x = alemao_x + (i * 10.0);
        new Float:y = alemao_y + (i * 6.0);
        new Float:z = alemao_z + 15.0 + (i * 1.0);
        
        FavelaObjects[ObjectCount++] = CreateDynamicObject(1251, x, y, z, 0.0, 0.0, 45.0); // Cabo
    }
    
    // === CASAS EM ENCOSTA ===
    
    // Casas escalonadas no morro
    for (new level = 0; level < 4; level++)
    {
        for (new i = 0; i < 12; i++)
        {
            for (new j = 0; j < 8; j++)
            {
                new Float:x = alemao_x + (i * 6.0) + random(2);
                new Float:y = alemao_y + (j * 5.0) + random(2);
                new Float:z = alemao_z + (level * 4.0);
                
                // Casas de diferentes tipos
                new models[] = {1408, 1409, 1410, 1411, 1412, 3037};
                new model = models[random(sizeof(models))];
                
                FavelaObjects[ObjectCount++] = CreateDynamicObject(model, x, y, z, 0.0, 0.0, random(360));
            }
        }
    }
    
    // === ÁREA COMERCIAL ===
    
    // Mercadinho local
    FavelaObjects[ObjectCount++] = CreateDynamicObject(1302, alemao_x + 20, alemao_y + 10, alemao_z, 0.0, 0.0, 0.0);
    FavelaObjects[ObjectCount++] = CreateDynamicObject(1209, alemao_x + 25, alemao_y + 15, alemao_z, 0.0, 0.0, 90.0);
    
    // Quadra de futebol
    FavelaObjects[ObjectCount++] = CreateDynamicObject(3095, alemao_x + 40, alemao_y + 40, alemao_z, 0.0, 0.0, 0.0); // Campo
    FavelaObjects[ObjectCount++] = CreateDynamicObject(1245, alemao_x + 30, alemao_y + 40, alemao_z + 2.0, 0.0, 0.0, 0.0); // Trave
    FavelaObjects[ObjectCount++] = CreateDynamicObject(1245, alemao_x + 50, alemao_y + 40, alemao_z + 2.0, 0.0, 0.0, 180.0); // Trave
    
    // === PONTOS DE TRÁFICO ===
    
    // Boca de fumo principal
    FavelaObjects[ObjectCount++] = CreateDynamicObject(2358, alemao_x + 60, alemao_y + 50, alemao_z + 8.0, 0.0, 0.0, 0.0);
    
    // Pontos de observação
    for (new i = 0; i < 5; i++)
    {
        new Float:x = alemao_x + random(80);
        new Float:y = alemao_y + random(60);
        new Float:z = alemao_z + 12.0 + random(8);
        
        FavelaObjects[ObjectCount++] = CreateDynamicObject(3095, x, y, z, 0.0, 0.0, 0.0); // Laje de observação
    }
    
    print("✅ Complexo do Alemão criado com sucesso!");
}

// ====================================================================================================
// CIDADE DE DEUS (BARRA DA TIJUCA)
// ====================================================================================================

stock CreateFavelaCidadeDeus()
{
    print("🏠 Criando Cidade de Deus...");
    
    new Float:cdeus_x = -1500.0, Float:cdeus_y = 2000.0, Float:cdeus_z = 5.0;
    
    // === CONJUNTOS HABITACIONAIS ===
    
    // Blocos de apartamentos
    for (new bloco = 0; bloco < 8; bloco++)
    {
        new Float:x = cdeus_x + (bloco % 4) * 25.0;
        new Float:y = cdeus_y + (bloco / 4) * 30.0;
        new Float:z = cdeus_z;
        
        // Prédios de 3 andares
        for (new andar = 0; andar < 3; andar++)
        {
            FavelaObjects[ObjectCount++] = CreateDynamicObject(3095, x, y, z + (andar * 4.0), 0.0, 0.0, 0.0);
            FavelaObjects[ObjectCount++] = CreateDynamicObject(3095, x + 10, y, z + (andar * 4.0), 0.0, 0.0, 0.0);
            FavelaObjects[ObjectCount++] = CreateDynamicObject(3095, x, y + 15, z + (andar * 4.0), 0.0, 0.0, 0.0);
            FavelaObjects[ObjectCount++] = CreateDynamicObject(3095, x + 10, y + 15, z + (andar * 4.0), 0.0, 0.0, 0.0);
        }
    }
    
    // === ÁREA CENTRAL ===
    
    // Praça central
    FavelaObjects[ObjectCount++] = CreateDynamicObject(3095, cdeus_x + 50, cdeus_y + 40, cdeus_z, 0.0, 0.0, 0.0); // Praça
    
    // Igreja local
    FavelaObjects[ObjectCount++] = CreateDynamicObject(1209, cdeus_x + 45, cdeus_y + 35, cdeus_z, 0.0, 0.0, 0.0);
    
    // Comércios
    FavelaObjects[ObjectCount++] = CreateDynamicObject(1302, cdeus_x + 55, cdeus_y + 45, cdeus_z, 0.0, 0.0, 45.0);
    FavelaObjects[ObjectCount++] = CreateDynamicObject(1340, cdeus_x + 60, cdeus_y + 50, cdeus_z, 0.0, 0.0, 90.0);
    
    // === BECOS E VIELAS ===
    
    for (new i = 0; i < 20; i++)
    {
        new Float:x = cdeus_x + random(100) - 20;
        new Float:y = cdeus_y + random(80) - 10;
        new Float:z = cdeus_z;
        
        FavelaObjects[ObjectCount++] = CreateDynamicObject(3037, x, y, z, 0.0, 0.0, random(4) * 90.0);
    }
    
    print("✅ Cidade de Deus criada com sucesso!");
}

// ====================================================================================================
// OUTRAS FAVELAS (VERSÕES SIMPLIFICADAS)
// ====================================================================================================

stock CreateFavelaProvidencia()
{
    print("🏠 Criando Morro da Providência...");
    
    new Float:prov_x = 1200.0, Float:prov_y = -800.0, Float:prov_z = 15.0;
    
    // Casas históricas (primeira favela do Rio)
    for (new i = 0; i < 30; i++)
    {
        new Float:x = prov_x + random(40) - 20;
        new Float:y = prov_y + random(30) - 15;
        new Float:z = prov_z + random(3) * 2.0;
        
        FavelaObjects[ObjectCount++] = CreateDynamicObject(1408, x, y, z, 0.0, 0.0, random(360));
    }
    
    // Vista para o centro (Cristo Redentor ao fundo)
    FavelaObjects[ObjectCount++] = CreateDynamicObject(3095, prov_x, prov_y, prov_z + 10.0, 0.0, 0.0, 0.0); // Mirante
    
    print("✅ Morro da Providência criado com sucesso!");
}

stock CreateFavelaCruzeiro()
{
    print("🏠 Criando Vila Cruzeiro...");
    
    new Float:cruz_x = 1800.0, Float:cruz_y = -1400.0, Float:cruz_z = 8.0;
    
    // Área residencial densa
    for (new i = 0; i < 25; i++)
    {
        new Float:x = cruz_x + random(35) - 17;
        new Float:y = cruz_y + random(25) - 12;
        new Float:z = cruz_z + random(2) * 3.0;
        
        FavelaObjects[ObjectCount++] = CreateDynamicObject(1409, x, y, z, 0.0, 0.0, random(360));
    }
    
    // Passarela famosa
    FavelaObjects[ObjectCount++] = CreateDynamicObject(1215, cruz_x + 20, cruz_y, cruz_z + 5.0, 0.0, 0.0, 90.0);
    
    print("✅ Vila Cruzeiro criada com sucesso!");
}

stock CreateFavelaBorel()
{
    print("🏠 Criando Morro do Borel...");
    
    new Float:borel_x = -1200.0, Float:borel_y = 1200.0, Float:borel_z = 12.0;
    
    // Casas na encosta
    for (new i = 0; i < 20; i++)
    {
        new Float:x = borel_x + random(30) - 15;
        new Float:y = borel_y + random(25) - 12;
        new Float:z = borel_z + (i % 3) * 3.0;
        
        FavelaObjects[ObjectCount++] = CreateDynamicObject(1410, x, y, z, 0.0, 0.0, random(360));
    }
    
    // Vista para a Tijuca
    FavelaObjects[ObjectCount++] = CreateDynamicObject(3095, borel_x, borel_y, borel_z + 8.0, 0.0, 0.0, 0.0);
    
    print("✅ Morro do Borel criado com sucesso!");
}

// ====================================================================================================
// LABELS E PICKUPS
// ====================================================================================================

stock CreateFavelaLabels()
{
    // Labels das favelas
    FavelaLabels[LabelCount++] = Create3DTextLabel("🏠 ROCINHA\n{FFFFFF}Maior favela do Brasil", COR_FAVELA, -2700.0, -1500.0, 8.0, 100.0, 0, 0);
    FavelaLabels[LabelCount++] = Create3DTextLabel("🚡 COMPLEXO DO ALEMÃO\n{FFFFFF}Teleférico e UPP", COR_FAVELA, 2500.0, -1200.0, 15.0, 100.0, 0, 0);
    FavelaLabels[LabelCount++] = Create3DTextLabel("🏘️ CIDADE DE DEUS\n{FFFFFF}Conjuntos habitacionais", COR_FAVELA, -1500.0, 2000.0, 8.0, 100.0, 0, 0);
    FavelaLabels[LabelCount++] = Create3DTextLabel("⛪ MORRO DA PROVIDÊNCIA\n{FFFFFF}Primeira favela do Rio", COR_FAVELA, 1200.0, -800.0, 18.0, 100.0, 0, 0);
    FavelaLabels[LabelCount++] = Create3DTextLabel("🌉 VILA CRUZEIRO\n{FFFFFF}Passarela famosa", COR_FAVELA, 1800.0, -1400.0, 11.0, 100.0, 0, 0);
    FavelaLabels[LabelCount++] = Create3DTextLabel("🏔️ MORRO DO BOREL\n{FFFFFF}Vista da Tijuca", COR_FAVELA, -1200.0, 1200.0, 15.0, 100.0, 0, 0);
    
    // Labels de UPPs
    FavelaLabels[LabelCount++] = Create3DTextLabel("🚔 UPP ROCINHA\n{FFFFFF}Use /entrar para acessar", COR_UPP, -2710.0, -1505.0, 5.0, 30.0, 0, 0);
    FavelaLabels[LabelCount++] = Create3DTextLabel("🚔 UPP ALEMÃO\n{FFFFFF}Use /entrar para acessar", COR_UPP, 2490.0, -1210.0, 10.0, 30.0, 0, 0);
    
    // Labels de comércios
    FavelaLabels[LabelCount++] = Create3DTextLabel("🍺 BOTECO DA ROCINHA\n{FFFFFF}/comprar bebida", COR_COMERCIO, -2680.0, -1485.0, 5.0, 20.0, 0, 0);
    FavelaLabels[LabelCount++] = Create3DTextLabel("🛒 MERCADINHO DO ALEMÃO\n{FFFFFF}/comprar comida", COR_COMERCIO, 2520.0, -1190.0, 10.0, 20.0, 0, 0);
}

stock CreateFavelaPickups()
{
    // Pickups de entrada das favelas
    FavelaPickups[PickupCount++] = CreateDynamicPickup(1239, 1, -2710.0, -1505.0, 5.0, 0, 0, -1, 100.0); // Entrada Rocinha
    FavelaPickups[PickupCount++] = CreateDynamicPickup(1239, 1, 2490.0, -1210.0, 10.0, 0, 0, -1, 100.0); // Entrada Alemão
    FavelaPickups[PickupCount++] = CreateDynamicPickup(1239, 1, -1510.0, 1990.0, 5.0, 0, 0, -1, 100.0); // Entrada Cidade de Deus
    
    // Pickups de comércios
    FavelaPickups[PickupCount++] = CreateDynamicPickup(1274, 1, -2680.0, -1485.0, 5.0, 0, 0, -1, 50.0); // Boteco
    FavelaPickups[PickupCount++] = CreateDynamicPickup(1274, 1, 2520.0, -1190.0, 10.0, 0, 0, -1, 50.0); // Mercado
    
    // Pickups de pontos especiais (escondidos)
    FavelaPickups[PickupCount++] = CreateDynamicPickup(1254, 1, -2655.0, -1465.0, 11.0, 0, 0, -1, 10.0); // Ponto especial Rocinha
    FavelaPickups[PickupCount++] = CreateDynamicPickup(1254, 1, 2560.0, -1150.0, 18.0, 0, 0, -1, 10.0); // Ponto especial Alemão
}

// ====================================================================================================
// EVENTOS E INTERAÇÕES
// ====================================================================================================

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    // Entradas das favelas
    if (pickupid == FavelaPickups[0]) // Rocinha
    {
        SendClientMessage(playerid, COR_FAVELA, "🏠 Bem-vindo à Rocinha! Maior favela do Brasil.");
        SendClientMessage(playerid, 0xFFFFFFFF, "💡 Use /gps para encontrar locais importantes.");
    }
    else if (pickupid == FavelaPickups[1]) // Alemão
    {
        SendClientMessage(playerid, COR_FAVELA, "🚡 Bem-vindo ao Complexo do Alemão!");
        SendClientMessage(playerid, 0xFFFFFFFF, "💡 Procure pelo teleférico para ter uma vista incrível.");
    }
    else if (pickupid == FavelaPickups[2]) // Cidade de Deus
    {
        SendClientMessage(playerid, COR_FAVELA, "🏘️ Bem-vindo à Cidade de Deus!");
        SendClientMessage(playerid, 0xFFFFFFFF, "💡 Cuidado ao andar pelos becos à noite.");
    }
    
    // Comércios
    else if (pickupid == FavelaPickups[3]) // Boteco
    {
        SendClientMessage(playerid, COR_COMERCIO, "🍺 Seja bem-vindo ao Boteco da Rocinha!");
        SendClientMessage(playerid, 0xFFFFFFFF, "💡 Use /comprar para ver as bebidas disponíveis.");
    }
    else if (pickupid == FavelaPickups[4]) // Mercado
    {
        SendClientMessage(playerid, COR_COMERCIO, "🛒 Mercadinho do Alemão - Tudo que você precisa!");
        SendClientMessage(playerid, 0xFFFFFFFF, "💡 Use /comprar para ver os produtos.");
    }
    
    // Pontos especiais
    else if (pickupid == FavelaPickups[5] || pickupid == FavelaPickups[6])
    {
        SendClientMessage(playerid, COR_PERIGO, "⚠️ Você encontrou um local suspeito...");
        SendClientMessage(playerid, 0xFF6B6BFF, "💀 Melhor sair daqui rapidamente!");
    }
    
    return 1;
}

// ====================================================================================================
// COMANDOS ESPECÍFICOS DAS FAVELAS
// ====================================================================================================

public OnPlayerCommandText(playerid, cmdtext[])
{
    if (!strcmp(cmdtext, "/favelas", true))
    {
        SendClientMessage(playerid, COR_FAVELA, "════════════ 🏠 FAVELAS DO RIO DE JANEIRO ════════════");
        SendClientMessage(playerid, 0xFFFFFFFF, "🏠 Rocinha - Maior favela do Brasil (Zona Sul)");
        SendClientMessage(playerid, 0xFFFFFFFF, "🚡 Complexo do Alemão - Com teleférico (Zona Norte)");
        SendClientMessage(playerid, 0xFFFFFFFF, "🏘️ Cidade de Deus - Conjuntos habitacionais (Barra)");
        SendClientMessage(playerid, 0xFFFFFFFF, "⛪ Morro da Providência - Primeira favela (Porto)");
        SendClientMessage(playerid, 0xFFFFFFFF, "🌉 Vila Cruzeiro - Passarela famosa (Penha)");
        SendClientMessage(playerid, 0xFFFFFFFF, "🏔️ Morro do Borel - Vista da Tijuca");
        SendClientMessage(playerid, COR_INFO, "💡 Use /gps para encontrar as localizações!");
        return 1;
    }
    
    if (!strcmp(cmdtext, "/upps", true))
    {
        SendClientMessage(playerid, COR_UPP, "════════════ 🚔 UPPs DO RIO DE JANEIRO ════════════");
        SendClientMessage(playerid, 0xFFFFFFFF, "🚔 UPP Rocinha - Controle da maior favela");
        SendClientMessage(playerid, 0xFFFFFFFF, "🚔 UPP Alemão - Segurança no complexo");
        SendClientMessage(playerid, 0xFFFFFFFF, "🚔 UPP Cidade de Deus - Patrulhamento constante");
        SendClientMessage(playerid, COR_INFO, "💡 As UPPs mantêm a paz nas comunidades!");
        return 1;
    }
    
    return 0;
}

// ====================================================================================================
// SISTEMA DE ÁREAS PERIGOSAS
// ====================================================================================================

forward CheckDangerousAreas();
public CheckDangerousAreas()
{
    for (new playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        if (!IsPlayerConnected(playerid)) continue;
        
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        
        // Verificar se está em área perigosa da Rocinha
        if (x >= -2720.0 && x <= -2640.0 && y >= -1520.0 && y <= -1450.0)
        {
            if (random(100) < 5) // 5% de chance por verificação
            {
                SendClientMessage(playerid, COR_PERIGO, "⚠️ Você está em uma área perigosa da Rocinha!");
                SendClientMessage(playerid, 0xFF6B6BFF, "💀 Tome cuidado com sua segurança!");
            }
        }
        
        // Verificar área perigosa do Alemão
        if (x >= 2480.0 && x <= 2580.0 && y >= -1220.0 && y <= -1150.0)
        {
            if (random(100) < 5)
            {
                SendClientMessage(playerid, COR_PERIGO, "⚠️ Área de conflito no Complexo do Alemão!");
                SendClientMessage(playerid, 0xFF6B6BFF, "💀 Mantenha-se alerta!");
            }
        }
    }
    return 1;
}

public OnGameModeInit()
{
    // Timer para verificar áreas perigosas (a cada 30 segundos)
    SetTimer("CheckDangerousAreas", 30000, true);
    return 1;
}