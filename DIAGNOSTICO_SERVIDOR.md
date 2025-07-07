# 🔧 DIAGNÓSTICO - SERVIDOR DESLIGANDO SOZINHO

## 🚨 Problema Identificado
Seu gamemode Rio de Janeiro RolePlay está desligando sozinho após um tempo de funcionamento na LemeHost.

## 🔍 Possíveis Causas e Soluções

### 1. **PROBLEMAS DE CONEXÃO MYSQL** ⚠️ (MAIS PROVÁVEL)

**Causa:** O MySQL está configurado com credenciais hardcoded que podem não corresponder à sua hospedagem:

```cpp
#define MYSQL_HOST "localhost"
#define MYSQL_USER "root"
#define MYSQL_PASS "password"
#define MYSQL_BASE "rjroleplay"
```

**Solução:**
```cpp
// No início do OnGameModeInit(), ANTES da conexão MySQL:
gMySQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_BASE, MYSQL_PASS);
if(mysql_errno(gMySQL) != 0) {
    printf("ERRO MYSQL: %d - %s", mysql_errno(gMySQL), mysql_error(gMySQL));
    SendRconCommand("exit");
    return 1;
}
```

### 2. **CONFIGURAÇÕES INCORRETAS DA LEMEHOST**

Verifique no painel da LemeHost:
- **Hostname MySQL:** geralmente não é "localhost"
- **Usuário MySQL:** geralmente não é "root"
- **Senha MySQL:** deve ser a fornecida pela hospedagem
- **Banco de dados:** confirme o nome correto

### 3. **PLUGINS FALTANDO OU INCOMPATÍVEIS**

No `server.cfg` você tem:
```
plugins crashdetect.so mysql.so sscanf.so streamer.so Whirlpool.so audio.so geoip.so
plugins sampvoice.so vehiclesync.so nativechecker.so rcon.so anticheat.so
```

**Problemas:**
- `audio.so` e `sampvoice.so` podem causar instabilidade
- `anticheat.so` pode ter falsos positivos
- Plugins duplicados na segunda linha

**Solução:**
```
plugins crashdetect.so mysql.so sscanf.so streamer.so Whirlpool.so geoip.so
```

### 4. **TIMERS PROBLEMÁTICOS**

Seu gamemode tem vários timers que podem causar sobrecarga:

```cpp
gHUDTimer = SetTimer("UpdateHUD", 1000, true);           // Cada 1s
gAntiCheatTimer = SetTimer("AntiCheatCheck", 500, true); // Cada 0.5s
gEconomyTimer = SetTimer("EconomyUpdate", 300000, true); // Cada 5min
gTerritoryTimer = SetTimer("TerritoryUpdate", 60000, true); // Cada 1min
```

**Solução:** Aumente os intervalos:
```cpp
gHUDTimer = SetTimer("UpdateHUD", 2000, true);           // Cada 2s
gAntiCheatTimer = SetTimer("AntiCheatCheck", 2000, true); // Cada 2s
```

### 5. **CONFIGURAÇÕES DO SERVER.CFG**

Problemas identificados:

```cfg
maxplayers 500  # Muito alto para hospedagem compartilhada
maxnpc 50       # NPCs consomem recursos
stream_distance 300.0  # Muito alto
```

**Configuração recomendada:**
```cfg
maxplayers 50
maxnpc 10
stream_distance 200.0
stream_rate 1500
```

### 6. **FUNCTIONS NÃO IMPLEMENTADAS**

No final do código há várias funções vazias que podem causar crashes:

```cpp
stock LoadFactions() { }
stock LoadItems() { }
stock LoadVehicles() { }
// ... outras funções vazias
```

### 7. **MEMÓRIA E RECURSOS**

**Problemas:**
- Muitas variáveis globais (2000 veículos, 500 casas, etc.)
- Sistema de HUD individual para cada player
- Múltiplos textdraws

## 🛠️ SOLUÇÕES IMEDIATAS

### 1. **Configurar MySQL Corretamente**

Entre no painel da LemeHost e anote:
- Host do MySQL
- Usuário
- Senha
- Nome do banco

Edite o arquivo `rjroleplay.pwn`:

```cpp
#define MYSQL_HOST "SEU_HOST_MYSQL_LEMEHOST"
#define MYSQL_USER "SEU_USUARIO_MYSQL"
#define MYSQL_PASS "SUA_SENHA_MYSQL"
#define MYSQL_BASE "SEU_BANCO_MYSQL"
```

### 2. **Configurar server.cfg para Hospedagem**

```cfg
echo Executing Server Config...
lanmode 0
rcon_password SUA_SENHA_RCON_FORTE
maxplayers 50
port 7777
hostname [BR] Rio de Janeiro RolePlay | IP_DA_LEMEHOST
gamemode0 rjroleplay 1
announce 1
query 1
weburl www.rjroleplay.com.br
onfoot_rate 40
incar_rate 40
weapon_rate 40
stream_distance 200.0
stream_rate 1500
maxnpc 10
logtimeformat [%H:%M:%S]
language Português BR

plugins crashdetect.so mysql.so sscanf.so streamer.so Whirlpool.so
filterscripts mapping_favelas mapping_upps mapping_bope sistema_vip

game_text_style 1
use_cj_walk 0
limited_player_radius 200.0
lag_comp_mode 1
sleep 5
```

### 3. **Implementar Logs de Debug**

Adicione no `OnGameModeInit()`:

```cpp
public OnGameModeInit() {
    print("=== INICIANDO SERVIDOR ===");
    printf("Versão: %s", GAMEMODE_VERSION);
    
    // Teste de MySQL
    gMySQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_BASE, MYSQL_PASS);
    if(mysql_errno(gMySQL) != 0) {
        printf("ERRO CRÍTICO: MySQL falhou! Erro: %d", mysql_errno(gMySQL));
        print("Verificar configurações de banco na LemeHost!");
        return 0; // Não force exit, deixe o server morrer naturalmente
    }
    printf("✓ MySQL conectado com sucesso!");
    
    // Continue com o resto...
    return 1;
}
```

### 4. **Criar Script de Monitoramento**

Crie um arquivo `monitor.sh`:

```bash
#!/bin/bash
while true; do
    if ! pgrep -f "samp03svr" > /dev/null; then
        echo "$(date): Servidor offline, reiniciando..."
        cd /caminho/para/seu/servidor
        ./samp03svr &
        sleep 10
    fi
    sleep 30
done
```

## 🔍 COMO INVESTIGAR

### 1. **Verificar Logs**
```bash
tail -f server_log.txt
tail -f mysql_log.txt
```

### 2. **Teste de Conexão MySQL**
No painel da LemeHost, teste a conexão do banco usando as credenciais.

### 3. **Monitor de Recursos**
Verifique no painel da LemeHost:
- Uso de CPU
- Uso de RAM
- Conexões MySQL

## 📞 PRÓXIMOS PASSOS

1. **URGENTE:** Corrija as configurações do MySQL
2. **IMPORTANTE:** Reduza os recursos no server.cfg
3. **RECOMENDADO:** Implemente as funções vazias
4. **OPCIONAL:** Otimize os timers

## 🆘 SE NADA FUNCIONAR

Entre em contato com o suporte da LemeHost informando:
- Logs do servidor
- Horário exato que o servidor cai
- Configurações atuais do MySQL
- Se há algum limite de recursos atingido

---

**💡 DICA:** O problema mais comum em hospedagens compartilhadas é a configuração incorreta do MySQL. Comece sempre por aí!

**⚠️ ATENÇÃO:** Nunca use `SendRconCommand("exit")` em produção, pois força o servidor a desligar.