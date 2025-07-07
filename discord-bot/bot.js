/**
 * =====================================================================
 * DISCORD BOT - RIO DE JANEIRO ROLEPLAY
 * =====================================================================
 * Bot completo para integração com servidor SA-MP
 * Recursos: vendas VIP, comandos admin, status do servidor, denúncias
 * =====================================================================
 */

const { Client, GatewayIntentBits, EmbedBuilder, ActionRowBuilder, ButtonBuilder, ButtonStyle, SlashCommandBuilder } = require('discord.js');
const mysql = require('mysql2/promise');
const axios = require('axios');
const QRCode = require('qrcode');
const fs = require('fs');

// Configurações
const config = {
    token: 'YOUR_DISCORD_BOT_TOKEN',
    clientId: 'YOUR_CLIENT_ID',
    guildId: 'YOUR_GUILD_ID',
    
    // Configurações do servidor SA-MP
    serverIP: '127.0.0.1',
    serverPort: 7777,
    
    // Configurações do banco de dados
    database: {
        host: 'localhost',
        user: 'root',
        password: 'password',
        database: 'rjroleplay'
    },
    
    // Configurações de pagamento
    vipPrices: {
        bronze: 15.00,
        silver: 25.00,
        gold: 35.00
    },
    
    coinsPrices: {
        '100': 10.00,
        '250': 20.00,
        '500': 35.00,
        '1000': 60.00
    },
    
    // PIX
    pixKey: 'vendas@rjroleplay.com.br',
    pixRecipient: 'Rio de Janeiro RolePlay',
    
    // Canais do Discord
    channels: {
        vendas: '1234567890123456789',
        logs: '1234567890123456789',
        denuncias: '1234567890123456789',
        status: '1234567890123456789'
    },
    
    // Cargos do Discord
    roles: {
        vipBronze: '1234567890123456789',
        vipSilver: '1234567890123456789', 
        vipGold: '1234567890123456789',
        admin: '1234567890123456789',
        moderador: '1234567890123456789'
    }
};

// Inicializando o cliente Discord
const client = new Client({
    intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildMessages,
        GatewayIntentBits.MessageContent,
        GatewayIntentBits.GuildMembers
    ]
});

// Conexão com MySQL
let db;

async function connectDatabase() {
    try {
        db = await mysql.createConnection(config.database);
        console.log('✅ Conectado ao banco de dados MySQL');
    } catch (error) {
        console.error('❌ Erro ao conectar ao banco:', error);
    }
}

// Quando o bot estiver pronto
client.once('ready', async () => {
    console.log(`🤖 Bot ${client.user.tag} está online!`);
    console.log(`📊 Conectado a ${client.guilds.cache.size} servidor(es)`);
    
    await connectDatabase();
    
    // Atualizar status do servidor a cada 30 segundos
    setInterval(updateServerStatus, 30000);
    updateServerStatus();
    
    // Registrar comandos slash
    await registerSlashCommands();
});

// Registrar comandos slash
async function registerSlashCommands() {
    const commands = [
        // Comando de status do servidor
        new SlashCommandBuilder()
            .setName('servidor')
            .setDescription('Mostra informações do servidor SA-MP'),
            
        // Comando de loja VIP
        new SlashCommandBuilder()
            .setName('vip')
            .setDescription('Comprar VIP para o servidor')
            .addStringOption(option =>
                option.setName('tipo')
                    .setDescription('Tipo de VIP')
                    .setRequired(true)
                    .addChoices(
                        { name: 'VIP Bronze - R$ 15,00', value: 'bronze' },
                        { name: 'VIP Silver - R$ 25,00', value: 'silver' },
                        { name: 'VIP Gold - R$ 35,00', value: 'gold' }
                    ))
            .addStringOption(option =>
                option.setName('nick')
                    .setDescription('Seu nick no servidor SA-MP')
                    .setRequired(true)),
                    
        // Comando de loja de coins
        new SlashCommandBuilder()
            .setName('coins')
            .setDescription('Comprar coins para o servidor')
            .addStringOption(option =>
                option.setName('quantidade')
                    .setDescription('Quantidade de coins')
                    .setRequired(true)
                    .addChoices(
                        { name: '100 Coins - R$ 10,00', value: '100' },
                        { name: '250 Coins - R$ 20,00', value: '250' },
                        { name: '500 Coins - R$ 35,00', value: '500' },
                        { name: '1000 Coins - R$ 60,00', value: '1000' }
                    ))
            .addStringOption(option =>
                option.setName('nick')
                    .setDescription('Seu nick no servidor SA-MP')
                    .setRequired(true)),
                    
        // Comando de denúncia
        new SlashCommandBuilder()
            .setName('denuncia')
            .setDescription('Fazer uma denúncia')
            .addStringOption(option =>
                option.setName('jogador')
                    .setDescription('Nome do jogador denunciado')
                    .setRequired(true))
            .addStringOption(option =>
                option.setName('motivo')
                    .setDescription('Motivo da denúncia')
                    .setRequired(true))
            .addStringOption(option =>
                option.setName('prova')
                    .setDescription('Link da prova (screenshot/vídeo)')
                    .setRequired(false)),
                    
        // Comandos administrativos
        new SlashCommandBuilder()
            .setName('ban')
            .setDescription('Banir um jogador do servidor')
            .addStringOption(option =>
                option.setName('jogador')
                    .setDescription('Nome do jogador')
                    .setRequired(true))
            .addStringOption(option =>
                option.setName('motivo')
                    .setDescription('Motivo do ban')
                    .setRequired(true)),
                    
        new SlashCommandBuilder()
            .setName('players')
            .setDescription('Ver jogadores online no servidor'),
            
        new SlashCommandBuilder()
            .setName('stats')
            .setDescription('Ver estatísticas de um jogador')
            .addStringOption(option =>
                option.setName('jogador')
                    .setDescription('Nome do jogador')
                    .setRequired(true))
    ];

    try {
        console.log('🔄 Registrando comandos slash...');
        const guild = client.guilds.cache.get(config.guildId);
        await guild.commands.set(commands);
        console.log('✅ Comandos slash registrados!');
    } catch (error) {
        console.error('❌ Erro ao registrar comandos:', error);
    }
}

// Handler para comandos slash
client.on('interactionCreate', async interaction => {
    if (!interaction.isChatInputCommand()) return;

    const { commandName } = interaction;

    try {
        switch (commandName) {
            case 'servidor':
                await handleServerCommand(interaction);
                break;
            case 'vip':
                await handleVIPCommand(interaction);
                break;
            case 'coins':
                await handleCoinsCommand(interaction);
                break;
            case 'denuncia':
                await handleReportCommand(interaction);
                break;
            case 'ban':
                await handleBanCommand(interaction);
                break;
            case 'players':
                await handlePlayersCommand(interaction);
                break;
            case 'stats':
                await handleStatsCommand(interaction);
                break;
        }
    } catch (error) {
        console.error('Erro ao executar comando:', error);
        await interaction.reply({
            content: '❌ Ocorreu um erro ao executar o comando!',
            ephemeral: true
        });
    }
});

// Comando /servidor
async function handleServerCommand(interaction) {
    const serverInfo = await getServerInfo();
    
    const embed = new EmbedBuilder()
        .setTitle('🏙️ Rio de Janeiro RolePlay - Status do Servidor')
        .setColor(serverInfo.online ? 0x00FF00 : 0xFF0000)
        .setThumbnail('https://i.imgur.com/rjrp_logo.png')
        .addFields(
            { name: '📡 Status', value: serverInfo.online ? '🟢 Online' : '🔴 Offline', inline: true },
            { name: '👥 Jogadores', value: `${serverInfo.players}/${serverInfo.maxPlayers}`, inline: true },
            { name: '🌐 IP', value: `${config.serverIP}:${config.serverPort}`, inline: true },
            { name: '🎮 Gamemode', value: 'RJ RolePlay v1.0', inline: true },
            { name: '🗺️ Mapa', value: 'Rio de Janeiro', inline: true },
            { name: '⏱️ Uptime', value: serverInfo.uptime || 'N/A', inline: true }
        )
        .setFooter({ text: 'Última atualização' })
        .setTimestamp();

    await interaction.reply({ embeds: [embed] });
}

// Comando /vip
async function handleVIPCommand(interaction) {
    const tipo = interaction.options.getString('tipo');
    const nick = interaction.options.getString('nick');
    
    // Verificar se o jogador existe
    const [rows] = await db.execute('SELECT id FROM accounts WHERE username = ?', [nick]);
    if (rows.length === 0) {
        return await interaction.reply({
            content: '❌ Jogador não encontrado no servidor!',
            ephemeral: true
        });
    }
    
    const playerId = rows[0].id;
    const preco = config.vipPrices[tipo];
    
    // Gerar PIX
    const pixData = await generatePIX(preco, `VIP ${tipo.toUpperCase()}`, `${nick}_vip_${Date.now()}`);
    
    // Salvar transação no banco
    await db.execute(
        'INSERT INTO transactions (account_id, type, amount, payment_method, payment_id, status) VALUES (?, ?, ?, ?, ?, ?)',
        [playerId, 'vip', preco, 'pix', pixData.id, 'pending']
    );
    
    // Criar embed com informações do pagamento
    const embed = new EmbedBuilder()
        .setTitle('👑 Compra de VIP')
        .setDescription(`**VIP ${tipo.toUpperCase()}** para ${nick}`)
        .setColor(0xFFD700)
        .addFields(
            { name: '💰 Valor', value: `R$ ${preco.toFixed(2).replace('.', ',')}`, inline: true },
            { name: '⏱️ Validade', value: '30 dias', inline: true },
            { name: '🔑 Chave PIX', value: config.pixKey, inline: false },
            { name: '👤 Beneficiário', value: config.pixRecipient, inline: false },
            { name: '🆔 ID da Transação', value: `\`${pixData.id}\``, inline: false }
        )
        .setFooter({ text: 'Após o pagamento, seu VIP será ativado em até 5 minutos!' });

    // Salvar QR Code como arquivo temporário
    const qrBuffer = await QRCode.toBuffer(pixData.qrCode, { width: 300 });
    
    await interaction.reply({
        embeds: [embed],
        files: [{
            attachment: qrBuffer,
            name: 'qrcode.png'
        }],
        ephemeral: true
    });
    
    // Log da venda
    const logChannel = client.channels.cache.get(config.channels.logs);
    if (logChannel) {
        const logEmbed = new EmbedBuilder()
            .setTitle('💰 Nova Compra VIP')
            .setColor(0x00FF00)
            .addFields(
                { name: 'Jogador', value: nick, inline: true },
                { name: 'VIP', value: tipo.toUpperCase(), inline: true },
                { name: 'Valor', value: `R$ ${preco.toFixed(2)}`, inline: true },
                { name: 'Discord', value: interaction.user.tag, inline: true }
            )
            .setTimestamp();
        
        await logChannel.send({ embeds: [logEmbed] });
    }
}

// Comando /coins
async function handleCoinsCommand(interaction) {
    const quantidade = interaction.options.getString('quantidade');
    const nick = interaction.options.getString('nick');
    
    // Verificar se o jogador existe
    const [rows] = await db.execute('SELECT id FROM accounts WHERE username = ?', [nick]);
    if (rows.length === 0) {
        return await interaction.reply({
            content: '❌ Jogador não encontrado no servidor!',
            ephemeral: true
        });
    }
    
    const playerId = rows[0].id;
    const preco = config.coinsPrices[quantidade];
    
    // Calcular bônus
    let coinsTotal = parseInt(quantidade);
    let bonus = 0;
    
    if (quantidade === '250') { bonus = Math.floor(coinsTotal * 0.05); }
    else if (quantidade === '500') { bonus = Math.floor(coinsTotal * 0.10); }
    else if (quantidade === '1000') { bonus = Math.floor(coinsTotal * 0.20); }
    
    coinsTotal += bonus;
    
    // Gerar PIX
    const pixData = await generatePIX(preco, `${quantidade} Coins`, `${nick}_coins_${Date.now()}`);
    
    // Salvar transação no banco
    await db.execute(
        'INSERT INTO transactions (account_id, type, amount, coins_amount, payment_method, payment_id, status) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [playerId, 'coins', preco, coinsTotal, 'pix', pixData.id, 'pending']
    );
    
    const embed = new EmbedBuilder()
        .setTitle('🪙 Compra de Coins')
        .setDescription(`**${coinsTotal} Coins** para ${nick}`)
        .setColor(0x1E90FF)
        .addFields(
            { name: '💰 Valor', value: `R$ ${preco.toFixed(2).replace('.', ',')}`, inline: true },
            { name: '🪙 Coins', value: quantidade, inline: true },
            { name: '🎁 Bônus', value: bonus > 0 ? `+${bonus} coins` : 'Sem bônus', inline: true },
            { name: '🔑 Chave PIX', value: config.pixKey, inline: false },
            { name: '👤 Beneficiário', value: config.pixRecipient, inline: false },
            { name: '🆔 ID da Transação', value: `\`${pixData.id}\``, inline: false }
        );

    const qrBuffer = await QRCode.toBuffer(pixData.qrCode, { width: 300 });
    
    await interaction.reply({
        embeds: [embed],
        files: [{
            attachment: qrBuffer,
            name: 'qrcode.png'
        }],
        ephemeral: true
    });
}

// Comando /denuncia
async function handleReportCommand(interaction) {
    const jogador = interaction.options.getString('jogador');
    const motivo = interaction.options.getString('motivo');
    const prova = interaction.options.getString('prova') || 'Não fornecida';
    
    const embed = new EmbedBuilder()
        .setTitle('🚨 Nova Denúncia')
        .setColor(0xFF4500)
        .addFields(
            { name: '👤 Denunciante', value: interaction.user.tag, inline: true },
            { name: '🎯 Jogador Denunciado', value: jogador, inline: true },
            { name: '📝 Motivo', value: motivo, inline: false },
            { name: '📎 Prova', value: prova, inline: false }
        )
        .setTimestamp()
        .setFooter({ text: 'ID: ' + interaction.id });

    const reportChannel = client.channels.cache.get(config.channels.denuncias);
    if (reportChannel) {
        await reportChannel.send({ embeds: [embed] });
    }
    
    await interaction.reply({
        content: '✅ Denúncia enviada com sucesso! Nossa equipe irá analisar.',
        ephemeral: true
    });
}

// Comando /players
async function handlePlayersCommand(interaction) {
    const [rows] = await db.execute(`
        SELECT c.name, f.name as faction_name, c.level 
        FROM characters c
        LEFT JOIN factions f ON c.faction_id = f.id
        WHERE c.last_login > DATE_SUB(NOW(), INTERVAL 10 MINUTE)
        ORDER BY c.level DESC
        LIMIT 20
    `);
    
    let playersList = '';
    if (rows.length === 0) {
        playersList = 'Nenhum jogador online no momento.';
    } else {
        rows.forEach((player, index) => {
            const faction = player.faction_name || 'Civil';
            playersList += `${index + 1}. **${player.name}** - Level ${player.level} (${faction})\n`;
        });
    }
    
    const embed = new EmbedBuilder()
        .setTitle('👥 Jogadores Online')
        .setDescription(playersList)
        .setColor(0x00FF00)
        .setFooter({ text: `Total: ${rows.length} jogadores` })
        .setTimestamp();
    
    await interaction.reply({ embeds: [embed] });
}

// Atualizar status do servidor
async function updateServerStatus() {
    try {
        const serverInfo = await getServerInfo();
        
        // Atualizar activity do bot
        const activity = serverInfo.online 
            ? `${serverInfo.players}/${serverInfo.maxPlayers} players`
            : 'Servidor Offline';
            
        client.user.setActivity(activity, { type: 'WATCHING' });
        
        // Atualizar canal de status se configurado
        const statusChannel = client.channels.cache.get(config.channels.status);
        if (statusChannel) {
            const embed = new EmbedBuilder()
                .setTitle('📊 Status do Servidor')
                .setColor(serverInfo.online ? 0x00FF00 : 0xFF0000)
                .addFields(
                    { name: 'Status', value: serverInfo.online ? '🟢 Online' : '🔴 Offline', inline: true },
                    { name: 'Jogadores', value: `${serverInfo.players}/${serverInfo.maxPlayers}`, inline: true }
                )
                .setTimestamp();
                
            // Buscar última mensagem e editar ao invés de enviar nova
            const messages = await statusChannel.messages.fetch({ limit: 1 });
            const lastMessage = messages.first();
            
            if (lastMessage && lastMessage.author.id === client.user.id) {
                await lastMessage.edit({ embeds: [embed] });
            } else {
                await statusChannel.send({ embeds: [embed] });
            }
        }
    } catch (error) {
        console.error('Erro ao atualizar status:', error);
    }
}

// Obter informações do servidor SA-MP
async function getServerInfo() {
    try {
        // Aqui você pode implementar uma consulta ao servidor SA-MP
        // Por enquanto, vamos simular os dados
        const [rows] = await db.execute('SELECT COUNT(*) as count FROM characters WHERE last_login > DATE_SUB(NOW(), INTERVAL 10 MINUTE)');
        const playersOnline = rows[0].count;
        
        return {
            online: true,
            players: playersOnline,
            maxPlayers: 500,
            uptime: '2 dias, 5 horas'
        };
    } catch (error) {
        console.error('Erro ao obter info do servidor:', error);
        return {
            online: false,
            players: 0,
            maxPlayers: 500,
            uptime: 'N/A'
        };
    }
}

// Gerar dados PIX
async function generatePIX(amount, description, transactionId) {
    const pixData = {
        id: transactionId,
        amount: amount,
        description: description,
        qrCode: `00020126580014br.gov.bcb.pix0136${config.pixKey}0208${transactionId}5204000053039865405${amount.toFixed(2).padStart(10, '0')}5802BR5925${config.pixRecipient}6009SAO_PAULO62070503***6304`
    };
    
    return pixData;
}

// Verificar se o usuário é admin
function isAdmin(interaction) {
    return interaction.member.roles.cache.has(config.roles.admin) || 
           interaction.member.roles.cache.has(config.roles.moderador);
}

// Handler para botões
client.on('interactionCreate', async interaction => {
    if (!interaction.isButton()) return;
    
    // Implementar handlers para botões se necessário
});

// Login do bot
client.login(config.token);