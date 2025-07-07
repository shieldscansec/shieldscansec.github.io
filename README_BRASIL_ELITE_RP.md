# 🚀 BRASIL ELITE ROLEPLAY - A NOVA ERA DO RP BRASILEIRO 🚀

![Brasil Elite RP](https://img.shields.io/badge/SA--MP-Brasil%20Elite%20RP-gold)
![Version](https://img.shields.io/badge/version-1.0-brightgreen)
![Status](https://img.shields.io/badge/status-Pronto%20para%20Uso-success)

## 📋 SOBRE O PROJETO

O **Brasil Elite RP** é uma GameMode revolucionária para SA-MP, desenvolvida com base nas melhores funcionalidades encontradas nas principais GameModes RP brasileiras. Combina tecnologia moderna, sistemas avançados e uma experiência única de roleplay.

### 🌟 CARACTERÍSTICAS PRINCIPAIS

- ✅ **Sistema de Login/Registro Avançado** com validação de email e força de senha
- ✅ **Gerador de CPF e RG Brasileiros** únicos para cada player
- ✅ **HUD Moderno** inspirado no GTA V com informações em tempo real
- ✅ **Anti-Cheat Robusto** detectando money hack, speed hack, health hack e mais
- ✅ **Sistema de Casas Dinâmicas** totalmente configuráveis
- ✅ **Sistema de Veículos Avançado** com combustível, KM, tuning e mais
- ✅ **Sistema de Facções Brasileiras** (PMERJ, CV, ADA, TCP, Milícia, BOPE)
- ✅ **Sistema de Empregos Realistas** (Lixeiro, Entregador, Taxista, Médico)
- ✅ **Sistema de Status Realista** (Fome, Sede, Energia, Stress)
- ✅ **Interface em TextDraws Modernas** com design profissional
- ✅ **Speedometer Avançado** com informações detalhadas do veículo
- ✅ **Sistema MySQL Otimizado** para máxima performance

## 🔧 REQUISITOS TÉCNICOS

### Servidor
- **SA-MP Server 0.3.7 R2** ou superior
- **MySQL 5.7+** ou MariaDB 10.2+
- **Linux Ubuntu 18.04+** ou Windows Server 2016+
- **RAM:** Mínimo 2GB, Recomendado 4GB+
- **CPU:** Dual-core 2.4GHz+

### Plugins Necessários
- `mysql.so/.dll` - Plugin MySQL para conexão com banco de dados
- `streamer.so/.dll` - Plugin Streamer para objetos dinâmicos
- `sscanf.so/.dll` - Plugin SSCANF para parsing de comandos
- `crashdetect.so/.dll` - Plugin CrashDetect para debug

### Includes Necessárias
- `a_samp.inc` - Include padrão do SA-MP
- `streamer.inc` - Include do Streamer Plugin
- `sscanf2.inc` - Include do SSCANF2
- `zcmd.inc` - Include do ZCMD para comandos
- `YSI_Coding\y_hooks.inc` - Y_Less hooks
- `YSI_Data\y_iterate.inc` - Y_Less iterators
- `mysql.inc` - Include do MySQL
- `crashdetect.inc` - Include do CrashDetect

## 📥 INSTALAÇÃO

### 1. Preparação do Servidor

```bash
# Clone ou baixe os arquivos da GM
git clone https://github.com/seu-usuario/brasil-elite-rp.git
cd brasil-elite-rp

# Copie os arquivos para seu servidor SA-MP
cp gamemodes/brasil_elite_rp.pwn /seu-servidor/gamemodes/
cp gamemodes/brasil_elite_rp_funcoes.pwn /seu-servidor/gamemodes/
```

### 2. Configuração do MySQL

```sql
-- Crie o banco de dados
CREATE DATABASE brasil_elite_rp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Use o banco criado
USE brasil_elite_rp;

-- As tabelas serão criadas automaticamente pela GM
```

### 3. Configuração do server.cfg

```ini
echo Executando servidor...
lanmode 0
rcon_password suasenhaadmin
maxplayers 100
port 7777
hostname [BR] Brasil Elite RP | O Futuro do RP Brasileiro
gamemode0 brasil_elite_rp 1
filterscripts 
plugins crashdetect mysql sscanf streamer
announce 1
chatlogging 0
weburl discord.gg/brasielite
onfoot_rate 40
incar_rate 40
weapon_rate 40
stream_distance 300.0
stream_rate 1000
maxnpc 0
logtimeformat [%H:%M:%S]
language Português
```

### 4. Configuração do MySQL na GM

Edite o arquivo `brasil_elite_rp.pwn` na função `ConectarMySQL()`:

```pawn
stock ConectarMySQL()
{
    // Altere as configurações abaixo para seu servidor MySQL
    conexao = mysql_connect("localhost", "root", "suasenha", "brasil_elite_rp");
    
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
```

### 5. Compilação

```bash
# Compile a gamemode usando seu compilador Pawn
pawncc brasil_elite_rp.pwn -o brasil_elite_rp.amx -d3 -O1

# Se usar sampctl
sampctl package build
```

## 🎮 PRIMEIROS PASSOS

### Para Administradores

1. **Inicie o servidor** e conecte-se
2. **Registre-se** como administrador
3. **Configure as casas** usando comandos admin
4. **Configure as facções** e recrute membros
5. **Configure os empregos** e salários

### Para Jogadores

1. **Conecte-se ao servidor**
2. **Registre-se** preenchendo todos os dados
3. **Receba seu CPF e RG** brasileiros automaticamente
4. **Explore a cidade** e conheça outros players
5. **Procure um emprego** para ganhar dinheiro
6. **Compre uma casa** quando tiver recursos
7. **Entre em uma facção** para mais roleplay

## 📋 COMANDOS PRINCIPAIS

### Comandos Gerais
- `/cpf` - Ver seus documentos brasileiros
- `/stats` - Ver suas estatísticas completas
- `/comandos` - Lista todos os comandos disponíveis
- `/me [ação]` - Fazer uma ação de roleplay
- `/do [descrição]` - Descrever algo no ambiente
- `/b [texto]` - Chat OOC local
- `/s [texto]` - Gritar
- `/w [texto]` - Sussurrar

### Comandos de Veículos
- `/trancar` - Trancar/destrancar veículo
- `/motor` - Ligar/desligar motor
- `/farol` - Ligar/desligar faróis
- `/capô` - Abrir/fechar capô
- `/porta-malas` - Abrir/fechar porta-malas
- `/combustivel` - Ver combustível do veículo

### Comandos de Casa
- `/comprar` - Comprar casa/empresa
- `/vender` - Vender casa/empresa
- `/entrar` - Entrar na casa/empresa
- `/sair` - Sair da casa/empresa
- `/cofre` - Acessar cofre da casa
- `/armario` - Trocar de roupa

## 🎯 SISTEMAS AVANÇADOS

### Sistema de CPF Brasileiro
- Geração automática de CPF válido
- Geração automática de RG
- Validação matemática dos dígitos verificadores
- Formato brasileiro padrão (000.000.000-00)

### Sistema Anti-Cheat
- **Money Hack Detection** - Detecta alterações ilegais de dinheiro
- **Health Hack Detection** - Detecta vida infinita
- **Armour Hack Detection** - Detecta colete infinito
- **Speed Hack Detection** - Detecta velocidade anormal
- **Weapon Hack Detection** - Detecta armas ilegais
- **Sistema de Warnings** - 3 avisos = banimento automático

### Sistema de Status Realista
- **Fome** - Diminui gradualmente, afeta a saúde
- **Sede** - Diminui mais rápido que a fome
- **Energia** - Afeta a capacidade de correr
- **Stress** - Aumenta com fome/sede baixas

### HUD Moderno
- **Vida e Colete** - Barra visual em tempo real
- **Dinheiro** - Formatação brasileira (R$ 1.000.000)
- **Level e XP** - Sistema de progressão
- **FPS Counter** - Monitoramento de performance
- **Ping Display** - Latência em tempo real
- **Data e Hora** - Informações do servidor

## 🏆 FACÇÕES DISPONÍVEIS

### Forças da Lei
- **PMERJ** - Polícia Militar do Estado do Rio de Janeiro
- **PCERJ** - Polícia Civil do Estado do Rio de Janeiro
- **BOPE** - Batalhão de Operações Policiais Especiais
- **SAMU** - Serviço de Atendimento Móvel de Urgência
- **Bombeiros** - Corpo de Bombeiros Militar

### Facções Criminosas
- **Comando Vermelho (CV)** - Facção tradicional carioca
- **ADA** - Amigos dos Amigos
- **TCP** - Terceiro Comando Puro
- **Milícia** - Grupos paramilitares

## 💼 EMPREGOS DISPONÍVEIS

1. **Lixeiro** - R$ 500-1.500/hora
   - Colete lixo pela cidade
   - Mantenha a cidade limpa
   
2. **Entregador** - R$ 600-2.000/hora
   - Entregue produtos de moto/bicicleta
   - Rápido e eficiente

3. **Taxista** - R$ 800-2.500/hora
   - Transporte passageiros
   - Conheça a cidade

4. **Mecânico** - R$ 1.000-3.000/hora
   - Repare veículos
   - Instale tuning

5. **Médico** - R$ 2.000-5.000/hora
   - Salve vidas no hospital
   - Atenda emergências

## 🛠️ CONFIGURAÇÕES AVANÇADAS

### Personalização da GM

```pawn
// Altere essas configurações no início da GM
#define MAX_HOUSES 500          // Máximo de casas
#define MAX_BUSINESSES 200      // Máximo de empresas
#define MAX_FACTIONS 50         // Máximo de facções
#define MAX_VEHICLES_SERVER 2000 // Máximo de veículos
#define MAX_JOBS 25             // Máximo de empregos
```

### Sistema de Cores

```pawn
// Personalize as cores do servidor
#define COR_AZUL_ELITE      0x1E90FFFF
#define COR_VERDE_ELITE     0x00FF7FFF
#define COR_VERMELHO_ELITE  0xFF4500FF
#define COR_DOURADO_ELITE   0xFFD700FF
```

## 🔒 SEGURANÇA

### Proteções Implementadas
- **Hash SHA256** para senhas
- **Validação de Email** com regex
- **Proteção SQL Injection** com mysql_format
- **Rate Limiting** em comandos críticos
- **Validação de dados** em todos os inputs

### Recomendações de Segurança
- Use senhas fortes para MySQL
- Configure firewall adequadamente
- Mantenha backups regulares
- Monitor logs de segurança
- Atualize plugins regularmente

## 📊 PERFORMANCE

### Otimizações Implementadas
- **Iteradores Y_Less** para loops eficientes
- **Sistema de Cache** para dados frequentes
- **Timers Otimizados** para reduzir lag
- **MySQL Threaded** para operações assíncronas
- **Memory Pool** para textdraws

### Monitoramento
- FPS counter em tempo real
- Ping display para players
- Logs de performance no console
- Sistema de debug integrado

## 🆘 SUPORTE TÉCNICO

### Problemas Comuns

**Erro de Compilação:**
```
solution: Verifique se todas as includes estão instaladas
solution: Use o compilador community compiler
solution: Verifique sintaxe do Pawn
```

**Erro MySQL:**
```
solution: Verifique credenciais no código
solution: Certifique-se que o MySQL está rodando
solution: Verifique se o banco existe
```

**Lag no Servidor:**
```
solution: Monitore uso de CPU/RAM
solution: Otimize queries MySQL
solution: Reduza objetos streamer
```

### Contato
- **Discord:** discord.gg/brasielite
- **GitHub:** github.com/seu-usuario/brasil-elite-rp
- **Email:** suporte@brasieliterp.com

## 🎖️ CRÉDITOS

### Desenvolvedores
- **Desenvolvimento Principal:** Brasil Elite Team
- **Sistema Anti-Cheat:** Baseado em pesquisas das melhores GMs
- **Interface Moderna:** Inspirado no GTA V HUD
- **Sistema de CPF:** Algoritmo brasileiro oficial

### Baseado nos Melhores Sistemas
- **Homeland RP** - Sistema intuitivo
- **Paradise City RP** - Casas dinâmicas
- **Samp RPG Gamemode** - Sistema de empregos
- **Advanced Speedometer** - HUD moderno
- **Multiple Anti-Cheat Systems** - Proteção avançada

### Includes e Plugins
- **Y_Less** - YSI Library
- **BlueG** - MySQL Plugin
- **Incognito** - Streamer Plugin
- **Emmet_** - SSCANF Plugin
- **Zeex** - CrashDetect Plugin

## 📜 LICENÇA

Este projeto está licenciado sob a **MIT License** - veja o arquivo [LICENSE](LICENSE) para detalhes.

### Termos de Uso
- ✅ Uso comercial permitido
- ✅ Modificação permitida
- ✅ Distribuição permitida
- ✅ Uso privado permitido
- ❌ Remover créditos não é permitido

## 🚀 FUTURAS ATUALIZAÇÕES

### Versão 1.1 (Em Desenvolvimento)
- [ ] Sistema de Drogas Avançado
- [ ] Sistema de Banco Completo
- [ ] Sistema de Celular com Apps
- [ ] Sistema de Relacionamentos
- [ ] Sistema de Conquistas

### Versão 1.2 (Planejada)
- [ ] Sistema de Negócios Dinâmicos
- [ ] Sistema de Eventos Automáticos
- [ ] Sistema de Rankings
- [ ] Sistema de Clan Wars
- [ ] API REST para website

---

## 🎉 AGRADECIMENTOS

Agradecemos a toda a comunidade SA-MP brasileira que contribuiu direta ou indiretamente para este projeto. O Brasil Elite RP representa o que há de melhor no roleplay brasileiro, unindo tradição e inovação.

**Vamos juntos revolucionar o RP brasileiro! 🇧🇷🚀**

---

*"O futuro do roleplay brasileiro começa aqui!"*