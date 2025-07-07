# 🏙️ RIO DE JANEIRO ROLEPLAY - GUIA DE INSTALAÇÃO

## 📋 Visão Geral

Este é um servidor SA-MP RolePlay brasileiro completo, inspirado no Rio de Janeiro, com sistemas avançados e realistas. O projeto inclui:

- **Gamemode SA-MP** em PAWN com sistemas avançados
- **Painel Web** administrativo em PHP
- **Discord Bot** integrado para vendas e administração
- **Banco de dados MySQL** completo
- **Sistema de pagamentos** PIX, PagSeguro e PicPay

## 🛠️ Requisitos do Sistema

### Servidor SA-MP
- SA-MP Server 0.3.7-R4 ou open.mp
- Linux/Windows Server
- MySQL 5.7+ ou MariaDB 10.3+
- PHP 7.4+ (para painel web)

### Plugins Necessários
- mysql.so (MySQL R41-4)
- sscanf.so
- streamer.so
- crashdetect.so
- Whirlpool.so
- sampvoice.so (opcional, para VoIP)

### Discord Bot
- Node.js 16+
- NPM

## 📦 Instalação Passo a Passo

### 1. Configurar Banco de Dados

```bash
# Instalar MySQL
sudo apt update
sudo apt install mysql-server

# Criar banco de dados
mysql -u root -p < database/schema.sql
```

### 2. Configurar Servidor SA-MP

```bash
# Baixar SA-MP Server
wget https://files.sa-mp.com/samp037svr_R2-1.tar.gz
tar -xzf samp037svr_R2-1.tar.gz

# Copiar arquivos do gamemode
cp gamemodes/* samp037svr/gamemodes/
cp filterscripts/* samp037svr/filterscripts/
cp include/* samp037svr/pawno/include/
cp plugins/* samp037svr/plugins/

# Configurar server.cfg
cp server.cfg samp037svr/
```

### 3. Compilar Gamemode

```bash
cd samp037svr/pawno
./pawncc -i../include -o../gamemodes/rjroleplay.amx rjroleplay.pwn
```

### 4. Configurar Painel Web

```bash
# Instalar Apache/Nginx + PHP
sudo apt install apache2 php php-mysql

# Copiar arquivos do painel
sudo cp -r web-panel/* /var/www/html/

# Configurar permissões
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

# Editar configurações
sudo nano /var/www/html/config.php
```

### 5. Configurar Discord Bot

```bash
# Instalar Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install nodejs

# Instalar dependências
cd discord-bot/
npm install

# Configurar bot
nano bot.js  # Editar configurações do bot

# Executar bot
npm start
```

## ⚙️ Configurações Importantes

### MySQL (config.php e bot.js)
```php
define('DB_HOST', 'localhost');
define('DB_USERNAME', 'root');
define('DB_PASSWORD', 'SUA_SENHA_MYSQL');
define('DB_NAME', 'rjroleplay');
```

### Pagamentos (config.php)
```php
// PIX
define('PIX_KEY', 'vendas@seudominio.com.br');
define('PIX_RECIPIENT_NAME', 'Rio de Janeiro RolePlay');

// PagSeguro
define('PAGSEGURO_EMAIL', 'vendas@seudominio.com.br');
define('PAGSEGURO_TOKEN', 'SEU_TOKEN_PAGSEGURO');

// PicPay
define('PICPAY_TOKEN', 'SEU_TOKEN_PICPAY');
```

### Discord Bot (bot.js)
```javascript
const config = {
    token: 'SEU_BOT_TOKEN_DISCORD',
    clientId: 'SEU_CLIENT_ID',
    guildId: 'ID_DO_SEU_SERVIDOR_DISCORD',
    
    channels: {
        vendas: 'ID_CANAL_VENDAS',
        logs: 'ID_CANAL_LOGS',
        denuncias: 'ID_CANAL_DENUNCIAS',
        status: 'ID_CANAL_STATUS'
    }
};
```

## 🚀 Executando o Servidor

### 1. Iniciar MySQL
```bash
sudo systemctl start mysql
sudo systemctl enable mysql
```

### 2. Iniciar Servidor SA-MP
```bash
cd samp037svr/
./samp03svr
```

### 3. Iniciar Painel Web
```bash
sudo systemctl start apache2
sudo systemctl enable apache2
```

### 4. Iniciar Discord Bot
```bash
cd discord-bot/
npm start
```

## 📊 Recursos Implementados

### 🎮 Gamemode SA-MP
- ✅ Sistema de login/registro avançado
- ✅ HUD com fome, sede, energia
- ✅ Inventário gráfico com textdraw
- ✅ Sistema de celular com VoIP
- ✅ Facções: CV, ADA, TCP, Milícia, PMERJ, BOPE, CORE, UPP
- ✅ Sistema de territórios com lucro passivo
- ✅ Anti-cheat completo
- ✅ Sistema de crafting
- ✅ Comandos policiais: /prender, /algemar, /revistar
- ✅ Comandos criminosos: /dominar, /drogas
- ✅ Documentação: RG, CNH, Porte de Arma
- ✅ Sistema VIP com benefícios
- ✅ Economia dinâmica com inflação

### 🌐 Painel Web
- ✅ Dashboard administrativo
- ✅ Gerenciamento de jogadores
- ✅ Sistema de pagamentos integrado
- ✅ Gerador de PIX com QR Code
- ✅ Logs detalhados
- ✅ Estatísticas em tempo real
- ✅ Loja VIP e Coins

### 🤖 Discord Bot
- ✅ Comandos slash modernos
- ✅ Vendas VIP automáticas
- ✅ Sistema de denúncias
- ✅ Status do servidor em tempo real
- ✅ Comandos administrativos
- ✅ Integração com banco de dados

## 🔧 Comandos Principais

### Jogadores
- `/stats` - Ver estatísticas
- `/inventario` - Abrir inventário
- `/celular` - Usar celular
- `/rg [id]` - Mostrar RG
- `/cnh [id]` - Mostrar CNH
- `/porte [id]` - Mostrar porte de arma
- `/craft` - Sistema de crafting

### Polícia
- `/prender [id] [tempo] [motivo]` - Prender suspeito
- `/algemar [id]` - Algemar/desalgemar
- `/revistar [id]` - Revistar suspeito
- `/blitz` - Criar blitz policial

### Criminosos
- `/dominar` - Dominar território
- `/drogas [produzir/vender] [quantidade]` - Sistema de drogas

### Administração
- `/ban [id] [motivo]` - Banir jogador
- `/kick [id] [motivo]` - Kickar jogador
- `/goto [id]` - Ir até jogador
- `/get [id]` - Trazer jogador
- `/setlevel [id] [level]` - Definir nível admin
- `/setvip [id] [level] [dias]` - Dar VIP
- `/setmoney [id] [quantia]` - Alterar dinheiro

### VIP
- `/vcar [model]` - Spawnar veículo VIP
- `/vheal` - Restaurar vida/colete
- `/vtp [local]` - Teleporte VIP
- `/vcoins` - Loja de coins

## 🔒 Segurança

### Anti-Cheat
- Detecção de speed hack
- Proteção contra teleport hack
- Verificação de weapon hack
- Anti money hack
- Anti health hack

### Logs
- Todas as ações são logadas
- IPs e seriais registrados
- Comandos executados
- Movimentações suspeitas

## 💰 Monetização

### Sistema VIP
- **Bronze** (R$ 15,00/mês): /vheal, /vcar, chat VIP
- **Silver** (R$ 25,00/mês): Bronze + /vtp, skin exclusiva
- **Gold** (R$ 35,00/mês): Silver + 100 coins/mês, casa exclusiva

### Sistema de Coins
- **100 Coins** - R$ 10,00
- **250 Coins** - R$ 20,00 (+5% bônus)
- **500 Coins** - R$ 35,00 (+10% bônus)
- **1000 Coins** - R$ 60,00 (+20% bônus)

### Métodos de Pagamento
- PIX (automático via QR Code)
- PagSeguro
- PicPay

## 📱 Compatibilidade Mobile

O servidor é totalmente compatível com SA-MP Android, incluindo:
- HUD adaptado para telas menores
- Interface de inventário otimizada
- Controles touch-friendly

## 🆘 Suporte

### Logs de Debug
```bash
# Ver logs do servidor SA-MP
tail -f samp037svr/server_log.txt

# Ver logs do Apache
sudo tail -f /var/log/apache2/error.log

# Ver logs do Discord Bot
cd discord-bot && npm run dev
```

### Problemas Comuns

1. **Erro de conexão MySQL**
   - Verificar credenciais em config.php
   - Confirmar se MySQL está rodando

2. **Gamemode não compila**
   - Verificar se includes estão na pasta correta
   - Instalar plugins necessários

3. **Discord Bot offline**
   - Verificar token do bot
   - Confirmar permissões no servidor Discord

## 📞 Contato

- **Discord**: [Servidor Discord]
- **Email**: admin@rjroleplay.com.br
- **Site**: https://rjroleplay.com.br

---

**© 2024 Rio de Janeiro RolePlay - Todos os direitos reservados**

Desenvolvido com ❤️ para a comunidade SA-MP brasileira.