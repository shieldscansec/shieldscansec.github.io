<?php
/**
 * =====================================================================
 * CONFIGURAÇÕES DO PAINEL WEB - RIO DE JANEIRO ROLEPLAY
 * =====================================================================
 */

// Configurações do banco de dados
define('DB_HOST', 'localhost');
define('DB_USERNAME', 'root');
define('DB_PASSWORD', 'password');
define('DB_NAME', 'rjroleplay');

// Configurações do servidor
define('SERVER_NAME', 'Rio de Janeiro RolePlay');
define('SERVER_IP', '127.0.0.1');
define('SERVER_PORT', '7777');
define('PANEL_VERSION', '1.0.0');

// Configurações de segurança
define('SECRET_KEY', 'rjrp_secret_key_2024');
define('SESSION_TIMEOUT', 3600); // 1 hora

// Configurações de pagamento
define('PAGSEGURO_EMAIL', 'vendas@rjroleplay.com.br');
define('PAGSEGURO_TOKEN', 'your_pagseguro_token_here');
define('PICPAY_TOKEN', 'your_picpay_token_here');

// PIX
define('PIX_KEY', 'vendas@rjroleplay.com.br');
define('PIX_RECIPIENT_NAME', 'Rio de Janeiro RolePlay');

// Preços VIP (em reais)
define('VIP_BRONZE_PRICE', 15.00);  // 30 dias
define('VIP_SILVER_PRICE', 25.00);  // 30 dias
define('VIP_GOLD_PRICE', 35.00);    // 30 dias

// Preços Coins
define('COINS_100_PRICE', 10.00);
define('COINS_250_PRICE', 20.00);
define('COINS_500_PRICE', 35.00);
define('COINS_1000_PRICE', 60.00);

// Configurações gerais
define('ADMIN_EMAIL', 'admin@rjroleplay.com.br');
define('SITE_URL', 'https://rjroleplay.com.br');

// Fuso horário
date_default_timezone_set('America/Sao_Paulo');

// Conectar ao banco de dados
try {
    $pdo = new PDO("mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=utf8mb4", 
                   DB_USERNAME, DB_PASSWORD, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4"
    ]);
} catch (PDOException $e) {
    die("Erro na conexão com o banco: " . $e->getMessage());
}

// Função para logs
function logActivity($admin_id, $action, $details = '') {
    global $pdo;
    
    $stmt = $pdo->prepare("INSERT INTO admin_logs (admin_id, action, details, ip_address, created_at) 
                          VALUES (?, ?, ?, ?, NOW())");
    $stmt->execute([$admin_id, $action, $details, $_SERVER['REMOTE_ADDR']]);
}

// Verificar se o usuário é admin
function isAdmin() {
    return isset($_SESSION['admin_logged']) && $_SESSION['admin_logged'] === true;
}

// Verificar nível de admin
function checkAdminLevel($required_level) {
    if (!isAdmin() || $_SESSION['admin_level'] < $required_level) {
        header('HTTP/1.0 403 Forbidden');
        exit('Acesso negado: Nível administrativo insuficiente.');
    }
}
?>