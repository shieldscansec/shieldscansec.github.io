<?php
/**
 * =====================================================================
 * RIO DE JANEIRO ROLEPLAY - PAINEL WEB ADMINISTRATIVO
 * =====================================================================
 * Sistema completo de administração do servidor SA-MP
 * Recursos: gerenciamento de players, vendas VIP, logs, estatísticas
 * =====================================================================
 */

session_start();
require_once 'config.php';
require_once 'includes/functions.php';

// Verificar se está logado
if (!isset($_SESSION['admin_logged']) && basename($_SERVER['PHP_SELF']) != 'login.php') {
    header('Location: login.php');
    exit;
}

$page = isset($_GET['page']) ? $_GET['page'] : 'dashboard';
?>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RJ RolePlay - Painel Administrativo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="assets/css/admin.css" rel="stylesheet">
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="index.php">
                <i class="fas fa-city"></i> RJ RolePlay
            </a>
            
            <div class="navbar-nav ms-auto">
                <div class="dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user"></i> <?php echo $_SESSION['admin_name']; ?>
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="?page=profile"><i class="fas fa-user-cog"></i> Perfil</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="logout.php"><i class="fas fa-sign-out-alt"></i> Sair</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav class="col-md-3 col-lg-2 d-md-block bg-light sidebar">
                <div class="position-sticky pt-3">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link <?php echo $page == 'dashboard' ? 'active' : ''; ?>" href="?page=dashboard">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <?php echo $page == 'players' ? 'active' : ''; ?>" href="?page=players">
                                <i class="fas fa-users"></i> Jogadores
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <?php echo $page == 'factions' ? 'active' : ''; ?>" href="?page=factions">
                                <i class="fas fa-shield-alt"></i> Facções
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <?php echo $page == 'vehicles' ? 'active' : ''; ?>" href="?page=vehicles">
                                <i class="fas fa-car"></i> Veículos
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <?php echo $page == 'houses' ? 'active' : ''; ?>" href="?page=houses">
                                <i class="fas fa-home"></i> Casas
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <?php echo $page == 'businesses' ? 'active' : ''; ?>" href="?page=businesses">
                                <i class="fas fa-building"></i> Empresas
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <?php echo $page == 'vip' ? 'active' : ''; ?>" href="?page=vip">
                                <i class="fas fa-crown"></i> Sistema VIP
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <?php echo $page == 'logs' ? 'active' : ''; ?>" href="?page=logs">
                                <i class="fas fa-file-alt"></i> Logs
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <?php echo $page == 'bans' ? 'active' : ''; ?>" href="?page=bans">
                                <i class="fas fa-ban"></i> Bans
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <?php echo $page == 'statistics' ? 'active' : ''; ?>" href="?page=statistics">
                                <i class="fas fa-chart-bar"></i> Estatísticas
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link <?php echo $page == 'payments' ? 'active' : ''; ?>" href="?page=payments">
                                <i class="fas fa-credit-card"></i> Pagamentos
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">
                        <?php echo getPageTitle($page); ?>
                    </h1>
                </div>

                <?php
                // Incluir a página solicitada
                switch($page) {
                    case 'dashboard':
                        include 'pages/dashboard.php';
                        break;
                    case 'players':
                        include 'pages/players.php';
                        break;
                    case 'factions':
                        include 'pages/factions.php';
                        break;
                    case 'vehicles':
                        include 'pages/vehicles.php';
                        break;
                    case 'houses':
                        include 'pages/houses.php';
                        break;
                    case 'businesses':
                        include 'pages/businesses.php';
                        break;
                    case 'vip':
                        include 'pages/vip.php';
                        break;
                    case 'logs':
                        include 'pages/logs.php';
                        break;
                    case 'bans':
                        include 'pages/bans.php';
                        break;
                    case 'statistics':
                        include 'pages/statistics.php';
                        break;
                    case 'payments':
                        include 'pages/payments.php';
                        break;
                    default:
                        include 'pages/dashboard.php';
                        break;
                }
                ?>
            </main>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-light mt-5 py-3">
        <div class="container text-center">
            <p>&copy; 2024 Rio de Janeiro RolePlay. Todos os direitos reservados.</p>
            <p>Versão do Painel: 1.0.0 | Servidor Online: <?php echo getServerStatus(); ?></p>
        </div>
    </footer>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="assets/js/admin.js"></script>
</body>
</html>