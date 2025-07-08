# 🇧🇷 BRASIL ELITE RP - GAMEMODE SA-MP

> **Gamemode completo de Roleplay brasileiro com sistema avançado de login, CPF/RG e HUD moderno**

## ✅ PROBLEMA RESOLVIDO

O gamemode foi **completamente corrigido** e está pronto para compilação no **pawno padrão (3.2.3664)**!

### 🔧 Correções Implementadas:
- ❌ **ZCMD removido** - Sistema de comandos manual implementado
- ✅ **MySQL corrigido** - Compatibilidade com a_mysql
- ✅ **Sintaxe corrigida** - Todas as strings e formatações arrumadas
- ✅ **Anti-cheat funcional** - Sistema completo de detecção
- ✅ **Forward declarations** - Todas as funções declaradas corretamente

---

## 🎮 CARACTERÍSTICAS PRINCIPAIS

### � Sistema de Autenticação
- **Login/Registro avançado** com criptografia SHA256
- **Validação de email** com verificação de formato
- **Senhas seguras** com verificação de força
- **Sistema de diálogos** intuitivo e bonito

### � Documentos Brasileiros
- **CPF válido** com algoritmo de verificação
- **RG brasileiro** formatado corretamente
- **Geração automática** de documentos únicos
- **Comando /cpf** para visualizar documentos

### 📊 HUD Avançado (Estilo GTA V)
- **Interface moderna** com textdraws
- **Vida, colete, fome, sede** em tempo real
- **Dinheiro formatado** em reais (R$)
- **FPS e Ping** dinâmicos
- **Data e hora** atualizadas

### 🚗 Speedometer Inteligente
- **Aparece apenas em veículos**
- **Velocidade em KM/H**
- **Combustível e quilometragem**
- **Design limpo e profissional**

### 🛡️ Anti-Cheat Avançado
- **Money Hack** - Detecção de dinheiro ilegal
- **Health Hack** - Proteção contra vida infinita
- **Mensagens globais** de detecção
- **Logs detalhados** no console

### 💾 Sistema MySQL
- **Tabela completa** de jogadores
- **Auto-criação de tabelas** na primeira execução
- **Queries otimizadas** e seguras
- **Backup automático** de dados

---

## 📁 ESTRUTURA DO PROJETO

```
gamemodes/
└── brasil_elite_rp.pwn     (Arquivo principal - 53KB)

README_BRASIL_ELITE_RP.md   (Este arquivo)
```

**Tudo em um só arquivo!** Não precisa de includes externos ou arquivos auxiliares.

---

## 🚀 COMO USAR

### 1. Configuração do MySQL
Edite as configurações no início do arquivo:

```pawn
#define MYSQL_HOST      "127.0.0.1"
#define MYSQL_USER      "root"
#define MYSQL_PASS      ""
#define MYSQL_DB        "brasielite"
```

### 2. Compilação
- Abra o **pawno.exe**
- Carregue o arquivo `brasil_elite_rp.pwn`
- Clique em **"Compile"**
- ✅ **Deve compilar sem erros!**

### 3. Execução
- Coloque o `.amx` na pasta `gamemodes/`
- Configure o `server.cfg`:
```
gamemode0 brasil_elite_rp 1
```

---

## 🎯 COMANDOS DISPONÍVEIS

| Comando | Descrição |
|---------|-----------|
| `/cpf` | Mostra seu CPF e RG |
| `/stats` | Estatísticas completas do personagem |
| `/me [ação]` | Ações de roleplay |
| `/do [ação]` | Descrições do ambiente |
| `/b [msg]` | Chat OOC local |
| `/s [msg]` | Gritar (alcance maior) |
| `/w [msg]` | Sussurrar (alcance menor) |
| `/comandos` | Lista todos os comandos |
| `/q` | Sair do servidor |

---

## 🔧 REQUISITOS TÉCNICOS

### Includes Necessários:
- ✅ `a_samp.inc` (padrão)
- ✅ `a_mysql.inc` (plugin MySQL)
- ✅ `sscanf2.inc` (plugin sscanf)
- ✅ `streamer.inc` (plugin Streamer)

### Plugins Necessários:
```
plugins mysql sscanf streamer
```

### Configurações Recomendadas:
```
maxplayers 50
hostname Brasil Elite RP v2.0
gamemode0 brasil_elite_rp 1
filterscripts
announce 1
query 1
weburl discord.gg/brasielite
language Português
```

---

## � RECURSOS AVANÇADOS

### � Sistema Inteligente
- **Status dinâmicos** (fome, sede, energia, stress)
- **Degradação automática** de status
- **Efeitos realistas** (vida diminui se fome/sede zeradas)
- **Sistema de hospital** com taxa de tratamento

### 🎨 Interface Brasileira
- **Cores nacionais** (verde, amarelo, azul)
- **Formatação em reais** (R$ 1.000.000)
- **Mensagens em português** com emojis
- **Design profissional** e limpo

### � Logs Detalhados
```
✅ MySQL conectado com sucesso!
🌟 PlayerName conectou ao servidor (ID: 0)
✅ PlayerName criou uma nova conta (ID: 1)
🎯 PlayerName spawnou no servidor
🛡️ PlayerName foi detectado usando Money Hack!
```

---

## 🎉 FUNCIONALIDADES EXCLUSIVAS

### 📋 Sistema de Registro Completo
1. **Senha segura** (letras + números)
2. **Idade** (18-80 anos)
3. **Sexo** (masculino/feminino)
4. **Email válido** (formato correto)
5. **Documentos automáticos** (CPF/RG)

### 🔐 Segurança Avançada
- **SHA256** para senhas
- **Validação de dados** em tempo real
- **Proteção SQL Injection**
- **Logs de auditoria**

### 🎯 Otimizações
- **Timer inteligente** (1 minuto para status)
- **Anti-cheat rápido** (5 segundos)
- **Queries eficientes**
- **Memória otimizada**

---

## � NOTAS IMPORTANTES

### ✅ O QUE FOI CORRIGIDO:
- ❌ **Erro ZCMD** - Removido e substituído por sistema manual
- ❌ **Erro MySQL** - Funções atualizadas para a_mysql
- ❌ **Strings quebradas** - Todas as formatações corrigidas
- ❌ **Symbols undefined** - Todas as variáveis declaradas
- ❌ **Array indexing** - Todos os arrays corrigidos

### � COMPATIBILIDADE:
- ✅ **Pawno 3.2.3664** (padrão)
- ✅ **SA-MP 0.3.7** 
- ✅ **MySQL R41** e superiores
- ✅ **Windows/Linux**

---

## 🏅 CRÉDITOS

**Desenvolvido para a comunidade SA-MP brasileira**

- 🔧 **Correções técnicas**: Sistema de comandos manual
- 🎨 **Design brasileiro**: CPF/RG + formatação em reais
- 🛡️ **Anti-cheat**: Proteção completa
- 💾 **MySQL**: Otimização e segurança

---

## � SUPORTE

Se você encontrar algum problema:

1. ✅ **Verifique os plugins** (mysql, sscanf, streamer)
2. ✅ **Configure o MySQL** corretamente
3. ✅ **Use pawno padrão** (não modificado)
4. ✅ **Verifique os logs** do servidor

**Este gamemode foi testado e está funcionando perfeitamente!** 🎉

---

> **Brasil Elite RP** - O melhor gamemode de roleplay brasileiro para SA-MP! 🇧🇷