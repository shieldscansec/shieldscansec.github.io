# 🔧 COMO APLICAR AS CORREÇÕES URGENTES

## ⚡ ETAPAS PARA CORRIGIR SEU GAMEMODE

### 1. **BACKUP DO ARQUIVO ORIGINAL**
```bash
cp gamemodes/rjroleplay.pwn gamemodes/rjroleplay_backup.pwn
```

### 2. **CORREÇÃO 1: Include YSI (LINHA 27)**

**Localize:**
```cpp
#include <YSI\y_ini>
```

**Substitua por:**
```cpp
// #include <YSI\y_ini>
```

### 3. **CORREÇÃO 2: Enum PlayerInfo (LINHA ~130)**

**Localize essas linhas no enum PlayerInfo:**
```cpp
// Anti-cheat
pLastPosX,
pLastPosY,
pLastPosZ,
```

**Substitua por:**
```cpp
// Anti-cheat
Float:pLastPosX,
Float:pLastPosY,
Float:pLastPosZ,
```

### 4. **CORREÇÃO 3: SendClientMessage com Format**

**Procure por linhas como:**
```cpp
SendClientMessage(playerid, COLOR_RED, "ANTI-CHEAT: Speed hack detectado! Aviso: %d/3", gPlayerInfo[playerid][pSpeedHackWarns]);
```

**Substitua por:**
```cpp
new string[128];
format(string, sizeof(string), "ANTI-CHEAT: Speed hack detectado! Aviso: %d/3", gPlayerInfo[playerid][pSpeedHackWarns]);
SendClientMessage(playerid, COLOR_RED, string);
```

### 5. **CORREÇÃO 4: Adicionar Funções no Final**

**Copie TODO o conteúdo do arquivo `correcoes_urgentes.pwn` e cole no FINAL do seu `rjroleplay.pwn`, ANTES das últimas linhas.**

## 🎯 RESULTADO ESPERADO

Após aplicar as correções:

✅ **O gamemode deve compilar sem erros**  
✅ **O servidor deve inicializar normalmente**  
✅ **Não deve mais desligar sozinho por erros de código**  

## 🚨 SE AINDA DER ERRO

### Verifique se aplicou TODAS as correções:

1. ✅ Include YSI comentado
2. ✅ Enum corrigido com Float:
3. ✅ SendClientMessage corrigido
4. ✅ Funções adicionadas no final

### Compile novamente:
```bash
pawncc -d3 rjroleplay.pwn
```

### Verifique os warnings:
- Ignore warnings de "symbol is never used"
- Ignore warnings de "function is deprecated"
- **Corrija** apenas ERRORS (erros)

## 📞 PRÓXIMOS PASSOS

Depois que o gamemode compilar:

1. **Teste local primeiro**
2. **Configure MySQL com dados da LemeHost**
3. **Use o server.cfg otimizado**
4. **Monitore os logs**

---

**💡 DICA:** Os erros de compilação eram a causa principal do servidor desligar sozinho. Corrigindo esses erros, o servidor deve funcionar estável!