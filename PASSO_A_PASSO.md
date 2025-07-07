# 🚀 PASSO A PASSO - CORRIGIR SERVIDOR QUE DESLIGA SOZINHO

## ⚡ AÇÕES URGENTES (Faça AGORA)

### 1. **VERIFICAR CONFIGURAÇÕES MYSQL NA LEMEHOST**

1. Entre no painel da LemeHost
2. Vá na seção **"Banco de Dados"** ou **"MySQL"**
3. Anote **EXATAMENTE**:
   - **Hostname:** (ex: mysql.lemehost.com.br)
   - **Usuário:** (seu usuário MySQL)
   - **Senha:** (sua senha MySQL)
   - **Nome do banco:** (nome do seu banco)

### 2. **EDITAR AS CONFIGURAÇÕES NO GAMEMODE**

Abra o arquivo `gamemodes/rjroleplay.pwn` e mude as linhas 65-68:

**ANTES:**
```cpp
#define MYSQL_HOST "localhost"
#define MYSQL_USER "root"
#define MYSQL_PASS "password"
#define MYSQL_BASE "rjroleplay"
```

**DEPOIS:** (use os dados da LemeHost)
```cpp
#define MYSQL_HOST "SEU_HOST_DA_LEMEHOST"
#define MYSQL_USER "SEU_USUARIO_DA_LEMEHOST"
#define MYSQL_PASS "SUA_SENHA_DA_LEMEHOST"
#define MYSQL_BASE "SEU_BANCO_DA_LEMEHOST"
```

### 3. **USAR O SERVER.CFG OTIMIZADO**

Substitua seu `server.cfg` atual pelo arquivo `server_lemehost.cfg` que criei.

**Importante:** Mude a linha:
```
rcon_password MUDE_ESTA_SENHA_RCON_FORTE_123
```

Para uma senha forte da sua escolha.

### 4. **TESTAR A CONEXÃO MYSQL**

1. Compile o arquivo `teste_mysql.pwn` que criei
2. Mude o gamemode para `teste_mysql` no server.cfg:
   ```
   gamemode0 teste_mysql 1
   ```
3. Execute o servidor e veja se conecta no MySQL
4. Se conectar, volte para seu gamemode original:
   ```
   gamemode0 rjroleplay 1
   ```

## 📋 AÇÕES IMPORTANTES (Faça depois)

### 5. **REMOVER PLUGINS PROBLEMÁTICOS**

No `server.cfg`, mude de:
```
plugins crashdetect.so mysql.so sscanf.so streamer.so Whirlpool.so audio.so geoip.so
plugins sampvoice.so vehiclesync.so nativechecker.so rcon.so anticheat.so
```

Para apenas:
```
plugins crashdetect.so mysql.so sscanf.so streamer.so Whirlpool.so
```

### 6. **IMPLEMENTAR LOGS DE DEBUG**

Adicione no início do `OnGameModeInit()` (após a linha 274):

```cpp
print("=== INICIANDO SERVIDOR RJ ROLEPLAY ===");
printf("Versão: %s", GAMEMODE_VERSION);

// Teste detalhado de MySQL
printf("Conectando MySQL: %s@%s/%s", MYSQL_USER, MYSQL_HOST, MYSQL_BASE);
gMySQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_BASE, MYSQL_PASS);

if(mysql_errno(gMySQL) != 0) {
    printf("❌ ERRO CRÍTICO: MySQL falhou!");
    printf("Código: %d", mysql_errno(gMySQL));
    printf("Mensagem: %s", mysql_error(gMySQL));
    print("Verifique configurações da LemeHost!");
    return 0; // NÃO use SendRconCommand("exit")
}

printf("✅ MySQL conectado com sucesso!");
```

### 7. **OTIMIZAR TIMERS**

Na linha 295, mude de:
```cpp
gAntiCheatTimer = SetTimer("AntiCheatCheck", 500, true);
```

Para:
```cpp
gAntiCheatTimer = SetTimer("AntiCheatCheck", 2000, true);
```

## 🔍 VERIFICAÇÕES DE SEGURANÇA

### 8. **MONITORAR LOGS**

Sempre verifique os logs do servidor:
```bash
tail -f server_log.txt
```

Procure por:
- ❌ Erros MySQL
- ⚠️ Warnings de plugins
- 💥 Crashes
- 🔄 Reinicializações

### 9. **VERIFICAR RECURSOS NO PAINEL DA LEMEHOST**

Monitor:
- **CPU:** Não deve passar de 80%
- **RAM:** Não deve estourar o limite
- **Conexões MySQL:** Limite da hospedagem

## 🆘 SE AINDA NÃO FUNCIONAR

### DIAGNÓSTICO AVANÇADO:

1. **Compile com debug:**
   ```bash
   pawncc -d3 rjroleplay.pwn
   ```

2. **Execute com crashdetect:**
   Verifique se o plugin `crashdetect.so` está funcionando

3. **Monitore em tempo real:**
   Use `htop` ou monitor do painel da LemeHost

4. **Contate o suporte da LemeHost:**
   - Envie os logs
   - Informe horário das quedas
   - Pergunte sobre limites de recursos

## ✅ CHECKLIST FINAL

- [ ] Configurei MySQL com dados corretos da LemeHost
- [ ] Usei o server.cfg otimizado
- [ ] Testei a conexão MySQL
- [ ] Removi plugins problemáticos
- [ ] Implementei logs de debug
- [ ] Otimizei os timers
- [ ] Verifiquei os logs
- [ ] Monitorei recursos no painel

## 🎯 RESULTADO ESPERADO

Após seguir todos os passos:

✅ **Servidor não deve mais desligar sozinho**  
✅ **MySQL deve conectar sem erros**  
✅ **Logs devem mostrar funcionamento normal**  
✅ **Recursos devem estar dentro dos limites**

---

**⚠️ ATENÇÃO:** 90% dos problemas de servidor que desliga sozinho em hospedagens compartilhadas são causados por configuração incorreta do MySQL. Comece sempre pelo MySQL!

**💡 DICA:** Se fizer alterações, sempre faça backup antes e teste em ambiente local primeiro.