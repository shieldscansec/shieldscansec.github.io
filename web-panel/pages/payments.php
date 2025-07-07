<?php
/**
 * =====================================================================
 * SISTEMA DE PAGAMENTOS - RIO DE JANEIRO ROLEPLAY
 * =====================================================================
 * Integração com PIX, PagSeguro e PicPay
 * Vendas automáticas de VIP e Coins
 * =====================================================================
 */

// Verificar se é admin
checkAdminLevel(1);

// Processar ações
if ($_POST) {
    if (isset($_POST['action'])) {
        switch ($_POST['action']) {
            case 'approve_payment':
                approvePayment($_POST['transaction_id']);
                break;
            case 'reject_payment':
                rejectPayment($_POST['transaction_id'], $_POST['reason']);
                break;
            case 'generate_pix':
                generatePIXPayment($_POST);
                break;
        }
    }
}

// Buscar transações pendentes
$stmt = $pdo->prepare("
    SELECT t.*, a.username 
    FROM transactions t 
    LEFT JOIN accounts a ON t.account_id = a.id 
    WHERE t.status = 'pending' 
    ORDER BY t.created_date DESC
");
$stmt->execute();
$pending_transactions = $stmt->fetchAll();

// Buscar estatísticas de pagamento
$stmt = $pdo->query("
    SELECT 
        COUNT(*) as total_transactions,
        SUM(CASE WHEN status = 'completed' THEN amount ELSE 0 END) as total_revenue,
        SUM(CASE WHEN status = 'pending' THEN amount ELSE 0 END) as pending_amount,
        COUNT(CASE WHEN status = 'completed' AND DATE(created_date) = CURDATE() THEN 1 END) as today_sales
    FROM transactions
");
$stats = $stmt->fetch();
?>

<div class="row mb-4">
    <!-- Estatísticas de Pagamento -->
    <div class="col-md-3">
        <div class="card bg-primary text-white">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <div>
                        <h4 class="card-title">R$ <?php echo number_format($stats['total_revenue'], 2, ',', '.'); ?></h4>
                        <p class="card-text">Receita Total</p>
                    </div>
                    <div class="align-self-center">
                        <i class="fas fa-dollar-sign fa-2x"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-md-3">
        <div class="card bg-warning text-dark">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <div>
                        <h4 class="card-title">R$ <?php echo number_format($stats['pending_amount'], 2, ',', '.'); ?></h4>
                        <p class="card-text">Pendente</p>
                    </div>
                    <div class="align-self-center">
                        <i class="fas fa-clock fa-2x"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-md-3">
        <div class="card bg-success text-white">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <div>
                        <h4 class="card-title"><?php echo $stats['today_sales']; ?></h4>
                        <p class="card-text">Vendas Hoje</p>
                    </div>
                    <div class="align-self-center">
                        <i class="fas fa-shopping-cart fa-2x"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="col-md-3">
        <div class="card bg-info text-white">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <div>
                        <h4 class="card-title"><?php echo $stats['total_transactions']; ?></h4>
                        <p class="card-text">Total Transações</p>
                    </div>
                    <div class="align-self-center">
                        <i class="fas fa-credit-card fa-2x"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Tabs -->
<ul class="nav nav-tabs" id="paymentTabs" role="tablist">
    <li class="nav-item" role="presentation">
        <button class="nav-link active" id="pending-tab" data-bs-toggle="tab" data-bs-target="#pending" type="button" role="tab">
            <i class="fas fa-clock"></i> Pagamentos Pendentes
        </button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link" id="store-tab" data-bs-toggle="tab" data-bs-target="#store" type="button" role="tab">
            <i class="fas fa-store"></i> Loja VIP
        </button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link" id="history-tab" data-bs-toggle="tab" data-bs-target="#history" type="button" role="tab">
            <i class="fas fa-history"></i> Histórico
        </button>
    </li>
    <li class="nav-item" role="presentation">
        <button class="nav-link" id="pix-tab" data-bs-toggle="tab" data-bs-target="#pix" type="button" role="tab">
            <i class="fab fa-pix"></i> Gerador PIX
        </button>
    </li>
</ul>

<div class="tab-content" id="paymentTabsContent">
    <!-- Pagamentos Pendentes -->
    <div class="tab-pane fade show active" id="pending" role="tabpanel">
        <div class="card mt-3">
            <div class="card-header">
                <h5><i class="fas fa-clock"></i> Transações Pendentes</h5>
            </div>
            <div class="card-body">
                <?php if (empty($pending_transactions)): ?>
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle"></i> Nenhuma transação pendente no momento.
                    </div>
                <?php else: ?>
                    <div class="table-responsive">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Jogador</th>
                                    <th>Tipo</th>
                                    <th>Valor</th>
                                    <th>Método</th>
                                    <th>Data</th>
                                    <th>Ações</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($pending_transactions as $transaction): ?>
                                <tr>
                                    <td>#<?php echo $transaction['id']; ?></td>
                                    <td><?php echo htmlspecialchars($transaction['username']); ?></td>
                                    <td>
                                        <span class="badge bg-<?php echo $transaction['type'] == 'vip' ? 'warning' : 'info'; ?>">
                                            <?php echo strtoupper($transaction['type']); ?>
                                        </span>
                                    </td>
                                    <td>R$ <?php echo number_format($transaction['amount'], 2, ',', '.'); ?></td>
                                    <td>
                                        <span class="badge bg-primary">
                                            <?php echo strtoupper($transaction['payment_method']); ?>
                                        </span>
                                    </td>
                                    <td><?php echo date('d/m/Y H:i', strtotime($transaction['created_date'])); ?></td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <button type="button" class="btn btn-sm btn-success" 
                                                    onclick="approvePayment(<?php echo $transaction['id']; ?>)">
                                                <i class="fas fa-check"></i> Aprovar
                                            </button>
                                            <button type="button" class="btn btn-sm btn-danger" 
                                                    onclick="rejectPayment(<?php echo $transaction['id']; ?>)">
                                                <i class="fas fa-times"></i> Rejeitar
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <!-- Loja VIP -->
    <div class="tab-pane fade" id="store" role="tabpanel">
        <div class="card mt-3">
            <div class="card-header">
                <h5><i class="fas fa-store"></i> Loja VIP & Coins</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <!-- Pacotes VIP -->
                    <div class="col-md-6">
                        <h6><i class="fas fa-crown"></i> Pacotes VIP</h6>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <div class="card border-warning">
                                    <div class="card-header bg-warning text-dark text-center">
                                        <h6>VIP Bronze</h6>
                                    </div>
                                    <div class="card-body text-center">
                                        <h4>R$ <?php echo number_format(VIP_BRONZE_PRICE, 2, ',', '.'); ?></h4>
                                        <p class="text-muted">30 dias</p>
                                        <ul class="list-unstyled text-start">
                                            <li><i class="fas fa-check text-success"></i> /vheal</li>
                                            <li><i class="fas fa-check text-success"></i> /vcar</li>
                                            <li><i class="fas fa-check text-success"></i> Chat VIP</li>
                                        </ul>
                                        <button class="btn btn-warning btn-sm">Configurar Preço</button>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-4 mb-3">
                                <div class="card border-secondary">
                                    <div class="card-header bg-secondary text-white text-center">
                                        <h6>VIP Silver</h6>
                                    </div>
                                    <div class="card-body text-center">
                                        <h4>R$ <?php echo number_format(VIP_SILVER_PRICE, 2, ',', '.'); ?></h4>
                                        <p class="text-muted">30 dias</p>
                                        <ul class="list-unstyled text-start">
                                            <li><i class="fas fa-check text-success"></i> Todos do Bronze</li>
                                            <li><i class="fas fa-check text-success"></i> /vtp</li>
                                            <li><i class="fas fa-check text-success"></i> Skin exclusiva</li>
                                        </ul>
                                        <button class="btn btn-secondary btn-sm">Configurar Preço</button>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-4 mb-3">
                                <div class="card border-warning">
                                    <div class="card-header bg-warning text-dark text-center">
                                        <h6>VIP Gold</h6>
                                    </div>
                                    <div class="card-body text-center">
                                        <h4>R$ <?php echo number_format(VIP_GOLD_PRICE, 2, ',', '.'); ?></h4>
                                        <p class="text-muted">30 dias</p>
                                        <ul class="list-unstyled text-start">
                                            <li><i class="fas fa-check text-success"></i> Todos do Silver</li>
                                            <li><i class="fas fa-check text-success"></i> 100 Coins/mês</li>
                                            <li><i class="fas fa-check text-success"></i> Casa exclusiva</li>
                                        </ul>
                                        <button class="btn btn-warning btn-sm">Configurar Preço</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Pacotes de Coins -->
                    <div class="col-md-6">
                        <h6><i class="fas fa-coins"></i> Pacotes de Coins</h6>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <div class="card border-primary">
                                    <div class="card-body text-center">
                                        <h5>100 Coins</h5>
                                        <h4>R$ <?php echo number_format(COINS_100_PRICE, 2, ',', '.'); ?></h4>
                                        <button class="btn btn-primary btn-sm">Configurar</button>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <div class="card border-primary">
                                    <div class="card-body text-center">
                                        <h5>250 Coins</h5>
                                        <h4>R$ <?php echo number_format(COINS_250_PRICE, 2, ',', '.'); ?></h4>
                                        <span class="badge bg-success">+5% Bônus</span>
                                        <br><button class="btn btn-primary btn-sm mt-2">Configurar</button>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <div class="card border-primary">
                                    <div class="card-body text-center">
                                        <h5>500 Coins</h5>
                                        <h4>R$ <?php echo number_format(COINS_500_PRICE, 2, ',', '.'); ?></h4>
                                        <span class="badge bg-success">+10% Bônus</span>
                                        <br><button class="btn btn-primary btn-sm mt-2">Configurar</button>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <div class="card border-primary">
                                    <div class="card-body text-center">
                                        <h5>1000 Coins</h5>
                                        <h4>R$ <?php echo number_format(COINS_1000_PRICE, 2, ',', '.'); ?></h4>
                                        <span class="badge bg-success">+20% Bônus</span>
                                        <br><button class="btn btn-primary btn-sm mt-2">Configurar</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Gerador PIX -->
    <div class="tab-pane fade" id="pix" role="tabpanel">
        <div class="card mt-3">
            <div class="card-header">
                <h5><i class="fab fa-pix"></i> Gerador de PIX Manual</h5>
            </div>
            <div class="card-body">
                <form method="POST" id="pixForm">
                    <input type="hidden" name="action" value="generate_pix">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="player_name" class="form-label">Nome do Jogador</label>
                                <input type="text" class="form-control" id="player_name" name="player_name" required>
                            </div>
                            <div class="mb-3">
                                <label for="pix_amount" class="form-label">Valor (R$)</label>
                                <input type="number" class="form-control" id="pix_amount" name="amount" min="1" step="0.01" required>
                            </div>
                            <div class="mb-3">
                                <label for="pix_type" class="form-label">Tipo</label>
                                <select class="form-control" id="pix_type" name="type" required>
                                    <option value="vip">VIP</option>
                                    <option value="coins">Coins</option>
                                    <option value="donation">Doação</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="pix_description" class="form-label">Descrição</label>
                                <textarea class="form-control" id="pix_description" name="description" rows="3"></textarea>
                            </div>
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-qrcode"></i> Gerar PIX
                            </button>
                        </div>
                    </div>
                </form>
                
                <!-- Resultado do PIX -->
                <div id="pixResult" class="mt-4" style="display: none;">
                    <div class="alert alert-success">
                        <h6><i class="fab fa-pix"></i> PIX Gerado com Sucesso!</h6>
                        <div class="row">
                            <div class="col-md-6">
                                <strong>Chave PIX:</strong><br>
                                <code><?php echo PIX_KEY; ?></code><br><br>
                                <strong>Beneficiário:</strong><br>
                                <?php echo PIX_RECIPIENT_NAME; ?><br><br>
                                <strong>Valor:</strong> <span id="pixAmount"></span><br>
                                <strong>Identificador:</strong> <code id="pixId"></code>
                            </div>
                            <div class="col-md-6 text-center">
                                <div id="qrcode"></div>
                                <p class="text-muted mt-2">QR Code para pagamento</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/qrcode@1.5.3/build/qrcode.min.js"></script>
<script>
function approvePayment(transactionId) {
    if (confirm('Tem certeza que deseja aprovar este pagamento?')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.innerHTML = `
            <input type="hidden" name="action" value="approve_payment">
            <input type="hidden" name="transaction_id" value="${transactionId}">
        `;
        document.body.appendChild(form);
        form.submit();
    }
}

function rejectPayment(transactionId) {
    const reason = prompt('Motivo da rejeição:');
    if (reason) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.innerHTML = `
            <input type="hidden" name="action" value="reject_payment">
            <input type="hidden" name="transaction_id" value="${transactionId}">
            <input type="hidden" name="reason" value="${reason}">
        `;
        document.body.appendChild(form);
        form.submit();
    }
}

// Gerador PIX
document.getElementById('pixForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const formData = new FormData(this);
    const amount = formData.get('amount');
    const playerName = formData.get('player_name');
    const type = formData.get('type');
    
    // Gerar ID único para a transação
    const pixId = 'RJ' + Date.now();
    
    // Dados do PIX
    const pixData = `00020126580014br.gov.bcb.pix0136${<?php echo json_encode(PIX_KEY); ?>}0208${pixId}5204000053039865405${amount.padStart(10, '0')}5802BR5925${<?php echo json_encode(PIX_RECIPIENT_NAME); ?>}6009SAO_PAULO62070503***6304`;
    
    // Mostrar resultado
    document.getElementById('pixAmount').textContent = 'R$ ' + parseFloat(amount).toFixed(2).replace('.', ',');
    document.getElementById('pixId').textContent = pixId;
    document.getElementById('pixResult').style.display = 'block';
    
    // Gerar QR Code
    QRCode.toCanvas(document.getElementById('qrcode'), pixData, {
        width: 200,
        height: 200,
        colorDark: '#000000',
        colorLight: '#ffffff',
        correctLevel: QRCode.CorrectLevel.M
    });
});
</script>

<?php
// Funções de processamento de pagamento
function approvePayment($transaction_id) {
    global $pdo;
    
    try {
        $pdo->beginTransaction();
        
        // Buscar detalhes da transação
        $stmt = $pdo->prepare("SELECT * FROM transactions WHERE id = ?");
        $stmt->execute([$transaction_id]);
        $transaction = $stmt->fetch();
        
        if (!$transaction) {
            throw new Exception("Transação não encontrada");
        }
        
        // Atualizar status da transação
        $stmt = $pdo->prepare("UPDATE transactions SET status = 'completed', completed_date = NOW() WHERE id = ?");
        $stmt->execute([$transaction_id]);
        
        // Aplicar benefícios ao jogador
        if ($transaction['type'] == 'vip') {
            $vip_level = getVIPLevelFromAmount($transaction['amount']);
            $expire_date = date('Y-m-d H:i:s', strtotime('+30 days'));
            
            $stmt = $pdo->prepare("UPDATE accounts SET vip_level = ?, vip_expire = ? WHERE id = ?");
            $stmt->execute([$vip_level, $expire_date, $transaction['account_id']]);
            
        } elseif ($transaction['type'] == 'coins') {
            $coins = getCoinsFromAmount($transaction['amount']);
            
            $stmt = $pdo->prepare("UPDATE accounts SET coins = coins + ? WHERE id = ?");
            $stmt->execute([$coins, $transaction['account_id']]);
        }
        
        $pdo->commit();
        
        // Log da ação
        logActivity($_SESSION['admin_id'], 'approve_payment', "Transação #$transaction_id aprovada");
        
        echo "<script>alert('Pagamento aprovado com sucesso!'); window.location.reload();</script>";
        
    } catch (Exception $e) {
        $pdo->rollBack();
        echo "<script>alert('Erro ao aprovar pagamento: " . $e->getMessage() . "');</script>";
    }
}

function rejectPayment($transaction_id, $reason) {
    global $pdo;
    
    $stmt = $pdo->prepare("UPDATE transactions SET status = 'failed', completed_date = NOW() WHERE id = ?");
    $stmt->execute([$transaction_id]);
    
    // Log da ação
    logActivity($_SESSION['admin_id'], 'reject_payment', "Transação #$transaction_id rejeitada: $reason");
    
    echo "<script>alert('Pagamento rejeitado!'); window.location.reload();</script>";
}

function getVIPLevelFromAmount($amount) {
    if ($amount >= VIP_GOLD_PRICE) return 3;
    if ($amount >= VIP_SILVER_PRICE) return 2;
    if ($amount >= VIP_BRONZE_PRICE) return 1;
    return 0;
}

function getCoinsFromAmount($amount) {
    if ($amount >= COINS_1000_PRICE) return 1200; // +20% bônus
    if ($amount >= COINS_500_PRICE) return 550;   // +10% bônus
    if ($amount >= COINS_250_PRICE) return 262;   // +5% bônus
    if ($amount >= COINS_100_PRICE) return 100;
    return floor($amount * 10); // 10 coins por real
}
?>