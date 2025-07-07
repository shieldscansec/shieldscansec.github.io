/*
    TESTE DE CONEXÃO MYSQL - LEMEHOST
    
    Este script testa apenas a conexão com o MySQL para diagnosticar problemas.
    Compile e rode este gamemode para testar a conexão antes do seu GM principal.
*/

#include <a_samp>
#include <a_mysql>

// CONFIGURAÇÕES - EDITE COM OS DADOS DA SUA LEMEHOST
#define MYSQL_HOST "localhost"  // Mude para o host da LemeHost
#define MYSQL_USER "root"       // Mude para seu usuário MySQL
#define MYSQL_PASS "password"   // Mude para sua senha MySQL  
#define MYSQL_BASE "rjroleplay" // Mude para seu banco de dados

new MySQL:gMySQL;

public OnGameModeInit() {
    print("\n===========================================");
    print(" TESTE DE CONEXÃO MYSQL - LEMEHOST");
    print("===========================================");
    
    printf("Tentando conectar ao MySQL...");
    printf("Host: %s", MYSQL_HOST);
    printf("User: %s", MYSQL_USER);
    printf("Database: %s", MYSQL_BASE);
    
    gMySQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_BASE, MYSQL_PASS);
    
    if(mysql_errno(gMySQL) != 0) {
        printf("ERRO: Falha na conexão MySQL!");
        printf("Código do erro: %d", mysql_errno(gMySQL));
        printf("Mensagem: %s", mysql_error(gMySQL));
        print("");
        print("POSSÍVEIS SOLUÇÕES:");
        print("1. Verifique as configurações no painel da LemeHost");
        print("2. Host pode não ser 'localhost'");
        print("3. Usuário pode não ser 'root'");
        print("4. Senha pode estar incorreta");
        print("5. Nome do banco pode estar errado");
        print("6. MySQL pode não estar ativo");
        print("");
        print("Entre no painel da LemeHost e verifique os dados de conexão!");
        return 1;
    }
    
    print("✓ SUCESSO: MySQL conectado!");
    
    // Teste de query simples
    mysql_tquery(gMySQL, "SELECT 1", "OnTestQuery", "");
    
    return 1;
}

forward OnTestQuery();
public OnTestQuery() {
    if(cache_num_rows() > 0) {
        print("✓ SUCESSO: Query de teste executada!");
        print("✓ CONEXÃO MYSQL ESTÁ FUNCIONANDO PERFEITAMENTE!");
        print("");
        print("Agora você pode usar seu gamemode principal.");
    } else {
        print("✗ ERRO: Query de teste falhou!");
        print("MySQL conectou mas não está respondendo queries.");
    }
    
    print("===========================================");
    print(" TESTE CONCLUÍDO");
    print("===========================================\n");
}

public OnGameModeExit() {
    if(mysql_errno(gMySQL) == 0) {
        mysql_close(gMySQL);
        print("MySQL desconectado.");
    }
    return 1;
}

public OnPlayerConnect(playerid) {
    SendClientMessage(playerid, 0x00FF00FF, "Este é um servidor de teste MySQL.");
    SendClientMessage(playerid, 0xFFFF00FF, "Verifique o console para resultados do teste.");
    return 1;
}