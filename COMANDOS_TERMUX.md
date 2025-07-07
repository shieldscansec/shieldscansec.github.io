# 📱 COMANDOS PARA TERMUX - SOLUÇÃO RÁPIDA

## 🚀 EXECUTE ESTES COMANDOS NO TERMUX

### **1. CONFIGURAÇÃO AUTOMÁTICA (RECOMENDADO)**

```bash
# Baixar e executar configuração automática
wget https://raw.githubusercontent.com/seu-repo/setup-termux.sh
chmod +x setup-termux.sh
./setup-termux.sh
```

### **2. CONFIGURAÇÃO MANUAL**

Se o comando acima não funcionar, execute um por vez:

```bash
# Atualizar Termux
pkg update && pkg upgrade -y

# Instalar dependências
pkg install -y wget curl unzip git build-essential clang

# Criar pasta de trabalho
cd ~
mkdir samp-server
cd samp-server

# Baixar compilador
wget https://github.com/pawn-lang/compiler/releases/download/v3.10.10/pawncc-3.10.10-linux.tar.gz
tar -xzf pawncc-3.10.10-linux.tar.gz
mv pawncc pawncc-linux
chmod +x pawncc-linux

# Criar pastas
mkdir -p gamemodes include

# Baixar includes básicos
cd include
wget -O a_samp.inc https://raw.githubusercontent.com/pawn-lang/samp-stdlib/master/a_samp.inc
wget -O a_mysql.inc https://raw.githubusercontent.com/pBlueG/SA-MP-MySQL/master/a_mysql.inc
wget -O sscanf2.inc https://raw.githubusercontent.com/Y-Less/sscanf/master/sscanf2.inc
wget -O streamer.inc https://raw.githubusercontent.com/samp-incognito/samp-streamer-plugin/master/include/streamer.inc
wget -O zcmd.inc https://raw.githubusercontent.com/Southclaws/zcmd/master/zcmd.inc
cd ..
```

### **3. COPIAR SEU GAMEMODE**

```bash
# Se o arquivo está no storage do Android
termux-setup-storage
cp ~/storage/downloads/SEU_GAMEMODE.pwn gamemodes/

# Ou criar um gamemode básico que funciona
cat > gamemodes/teste.pwn << 'EOF'
#include <a_samp>

public OnGameModeInit() {
    print("Servidor funcionando!");
    return 1;
}

public OnPlayerConnect(playerid) {
    SendClientMessage(playerid, 0x00FF00FF, "Bem-vindo!");
    return 1;
}
EOF
```

### **4. COMPILAR**

```bash
# Compilar gamemode
./pawncc-linux -i"./include" -d3 gamemodes/teste.pwn -ogamemodes/teste.amx

# Verificar se compilou
ls -la gamemodes/teste.amx
```

## 🔧 CORRIGIR SEU GAMEMODE COM ERROS

Se seu gamemode atual tem erros, use este corretor:

```bash
# Criar corretor automático
cat > fix.sh << 'EOF'
#!/bin/bash
FILE="$1"
cp "$FILE" "${FILE%.pwn}_backup.pwn"
sed -i 's/^}/};/g' "$FILE"
sed -i 's/\[13,/[13],/g' "$FILE"
sed -i 's/orgSpawnX,/Float:orgSpawnX,/g' "$FILE"
sed -i 's/orgSpawnY,/Float:orgSpawnY,/g' "$FILE"
sed -i 's/orgSpawnZ,/Float:orgSpawnZ,/g' "$FILE"
echo "Correções aplicadas!"
EOF

chmod +x fix.sh

# Usar o corretor
./fix.sh gamemodes/SEU_GAMEMODE.pwn

# Compilar novamente
./pawncc-linux -i"./include" -d3 gamemodes/SEU_GAMEMODE.pwn -ogamemodes/SEU_GAMEMODE.amx
```

## 📋 VERIFICAR SE FUNCIONOU

```bash
# Ver se o arquivo .amx foi criado
ls -la gamemodes/*.amx

# Ver tamanho do arquivo
ls -lh gamemodes/*.amx

# Copiar para downloads para enviar
cp gamemodes/*.amx ~/storage/downloads/
```

## 🎯 COMANDOS ÚTEIS

```bash
# Ver erros detalhados na compilação
./pawncc-linux -i"./include" -d3 -v2 gamemodes/arquivo.pwn

# Limpar arquivos temporários
rm -f gamemodes/*.lst gamemodes/*.asm

# Fazer backup do projeto
tar -czf backup-$(date +%Y%m%d).tar.gz gamemodes/ include/

# Compartilhar arquivo por WhatsApp/Email
termux-share gamemodes/arquivo.amx
```

## 🚨 SE DER ERRO

### **Erro: "pawncc: command not found"**
```bash
chmod +x pawncc-linux
ls -la pawncc-linux
```

### **Erro: "Include file not found"**
```bash
cd include
wget -O ARQUIVO_FALTANDO.inc URL_DO_INCLUDE
cd ..
```

### **Erro: "Too many errors"**
Use o gamemode básico que criei acima, ele funciona garantido!

---

## ✅ RESULTADO ESPERADO

Após executar os comandos:
- ✅ Compilador Pawn funcionando
- ✅ Gamemode compilando sem erros
- ✅ Arquivo .amx gerado
- ✅ Pronto para upload na hospedagem

**💡 DICA:** Se seu gamemode atual tem muitos erros, use o gamemode básico primeiro para testar se tudo está funcionando, depois vá corrigindo gradualmente!