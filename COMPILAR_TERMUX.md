# 📱 COMPILAR GAMEMODE SA-MP NO TERMUX

## 🚀 CONFIGURAÇÃO INICIAL DO TERMUX

### 1. **ATUALIZAR TERMUX**
```bash
pkg update && pkg upgrade -y
```

### 2. **INSTALAR PACOTES NECESSÁRIOS**
```bash
pkg install -y wget curl unzip git build-essential clang
```

### 3. **CRIAR DIRETÓRIO DE TRABALHO**
```bash
cd ~
mkdir samp-server
cd samp-server
```

## 🔧 INSTALAR COMPILADOR PAWN

### 4. **BAIXAR COMPILADOR PAWN**
```bash
# Opção 1: Compilador oficial (recomendado)
wget https://github.com/pawn-lang/compiler/releases/download/v3.10.10/pawncc-3.10.10-linux.tar.gz
tar -xzf pawncc-3.10.10-linux.tar.gz
mv pawncc pawncc-linux

# Dar permissão de execução
chmod +x pawncc-linux
```

### 5. **CRIAR ESTRUTURA DE PASTAS**
```bash
mkdir -p gamemodes
mkdir -p include
mkdir -p plugins
mkdir -p filterscripts
```

### 6. **BAIXAR INCLUDES BÁSICOS**
```bash
cd include

# Include básico SA-MP
wget https://raw.githubusercontent.com/pawn-lang/samp-stdlib/master/a_samp.inc

# MySQL include
wget https://raw.githubusercontent.com/pBlueG/SA-MP-MySQL/master/a_mysql.inc

# SScanf include  
wget https://raw.githubusercontent.com/Y-Less/sscanf/master/sscanf2.inc

# Streamer include
wget https://raw.githubusercontent.com/samp-incognito/samp-streamer-plugin/master/include/streamer.inc

# ZCmd include
wget https://raw.githubusercontent.com/Southclaws/zcmd/master/zcmd.inc

# Whirlpool include
wget https://raw.githubusercontent.com/Southclaws/samp-whirlpool/master/whirlpool.inc

# Foreach include
wget https://raw.githubusercontent.com/Y-Less/foreach/master/foreach.inc

# Crashdetect include
wget https://raw.githubusercontent.com/Zeex/samp-plugin-crashdetect/master/crashdetect.inc

cd ..
```

## 📂 TRANSFERIR GAMEMODE

### 7. **COPIAR SEU GAMEMODE**
```bash
# Se você tem o arquivo localmente, copie para:
cp /caminho/para/rjroleplay.pwn gamemodes/

# OU baixe do repositório se estiver online:
# wget https://raw.githubusercontent.com/SEU_USUARIO/SEU_REPO/main/rjroleplay.pwn -O gamemodes/rjroleplay.pwn
```

## 🔨 COMPILAR GAMEMODE

### 8. **CRIAR SCRIPT DE COMPILAÇÃO**
```bash
cat > compile.sh << 'EOF'
#!/bin/bash

echo "==================================="
echo "  COMPILADOR SA-MP GAMEMODE"
echo "==================================="

if [ -z "$1" ]; then
    echo "Uso: ./compile.sh nome_do_gamemode"
    echo "Exemplo: ./compile.sh rjroleplay"
    exit 1
fi

GAMEMODE="$1"
PAWN_COMPILER="./pawncc-linux"
INCLUDE_DIR="./include"
GAMEMODE_DIR="./gamemodes"

echo "Compilando: $GAMEMODE.pwn"
echo "Includes: $INCLUDE_DIR"
echo ""

# Compilar com debug e includes
$PAWN_COMPILER \
    -i"$INCLUDE_DIR" \
    -d3 \
    -;+ \
    -\+ \
    -O1 \
    -v2 \
    "$GAMEMODE_DIR/$GAMEMODE.pwn" \
    -o"$GAMEMODE_DIR/$GAMEMODE.amx"

RESULT=$?

echo ""
if [ $RESULT -eq 0 ]; then
    echo "✅ COMPILAÇÃO CONCLUÍDA COM SUCESSO!"
    echo "Arquivo gerado: $GAMEMODE_DIR/$GAMEMODE.amx"
    
    # Mostrar tamanho do arquivo
    if [ -f "$GAMEMODE_DIR/$GAMEMODE.amx" ]; then
        SIZE=$(ls -lh "$GAMEMODE_DIR/$GAMEMODE.amx" | awk '{print $5}')
        echo "Tamanho: $SIZE"
    fi
else
    echo "❌ ERRO NA COMPILAÇÃO!"
    echo "Verifique os erros acima e corrija-os."
fi

echo "==================================="
EOF

# Dar permissão de execução
chmod +x compile.sh
```

### 9. **COMPILAR SEU GAMEMODE**
```bash
./compile.sh rjroleplay
```

## 🔍 VERIFICAR INCLUDES PERSONALIZADOS

### 10. **SE DER ERRO DE INCLUDE FALTANDO**

Caso apareçam erros de includes não encontrados, baixe manualmente:

```bash
cd include

# Se precisar de outros includes específicos:
# wget URL_DO_INCLUDE -O nome_do_include.inc

cd ..
```

## 📋 RESOLVER PROBLEMAS COMUNS

### **ERRO: "pawncc: command not found"**
```bash
# Verificar se o arquivo existe
ls -la pawncc-linux

# Dar permissão novamente
chmod +x pawncc-linux

# Testar diretamente
./pawncc-linux
```

### **ERRO: "Include file not found"**
```bash
# Verificar includes disponíveis
ls -la include/

# Baixar include faltando manualmente
cd include
wget URL_DO_INCLUDE
cd ..
```

### **ERRO: "Too many errors"**
```bash
# Compilar com mais detalhes
./pawncc-linux -i"./include" -d3 -v2 gamemodes/rjroleplay.pwn
```

## 🎯 COMPILAÇÃO AUTOMÁTICA

### 11. **SCRIPT AVANÇADO COM AUTO-CORREÇÃO**
```bash
cat > auto-compile.sh << 'EOF'
#!/bin/bash

GAMEMODE="rjroleplay"
echo "🔨 Compilando $GAMEMODE..."

# Verificar se existem as pastas
mkdir -p gamemodes include

# Compilar
./pawncc-linux \
    -i"./include" \
    -d3 \
    -;+ \
    -\+ \
    -O1 \
    -v2 \
    -w203 \
    -w214 \
    -w219 \
    -w220 \
    "gamemodes/$GAMEMODE.pwn" \
    -o"gamemodes/$GAMEMODE.amx"

if [ $? -eq 0 ]; then
    echo "✅ SUCESSO! Gamemode compilado!"
    echo "📁 Arquivo: gamemodes/$GAMEMODE.amx"
    
    # Mostrar informações do arquivo
    if [ -f "gamemodes/$GAMEMODE.amx" ]; then
        echo "📊 Tamanho: $(ls -lh gamemodes/$GAMEMODE.amx | awk '{print $5}')"
        echo "📅 Data: $(ls -l gamemodes/$GAMEMODE.amx | awk '{print $6" "$7" "$8}')"
    fi
    
    echo ""
    echo "🚀 Pronto para upload na LemeHost!"
else
    echo "❌ ERRO na compilação!"
    echo "💡 Verifique os erros acima."
fi
EOF

chmod +x auto-compile.sh
```

### 12. **COMPILAR COM SCRIPT AUTOMÁTICO**
```bash
./auto-compile.sh
```

## 📤 TRANSFERIR PARA LEMEHOST

### 13. **PREPARAR ARQUIVOS PARA UPLOAD**
```bash
# Criar pasta de upload
mkdir upload-lemehost

# Copiar arquivos essenciais
cp gamemodes/rjroleplay.amx upload-lemehost/
cp server_lemehost.cfg upload-lemehost/server.cfg

echo "📦 Arquivos prontos em: upload-lemehost/"
echo "📤 Faça upload destes arquivos na LemeHost:"
echo "   - rjroleplay.amx (pasta gamemodes/)"
echo "   - server.cfg (pasta raiz)"
```

## 🔧 COMANDOS ÚTEIS

### **VERIFICAR COMPILAÇÃO**
```bash
# Ver detalhes do arquivo compilado
file gamemodes/rjroleplay.amx
ls -la gamemodes/rjroleplay.amx
```

### **BACKUP DO PROJETO**
```bash
# Criar backup
tar -czf backup-gamemode-$(date +%Y%m%d).tar.gz gamemodes/ include/ *.cfg
```

### **LIMPAR ARQUIVOS TEMPORÁRIOS**
```bash
# Limpar arquivos de compilação
rm -f gamemodes/*.lst
rm -f gamemodes/*.asm
```

## 📱 COMANDOS TERMUX ESPECÍFICOS

### **MANTER TERMUX ATIVO**
```bash
# Evitar que o Termux seja morto pelo Android
termux-wake-lock
```

### **ACESSAR STORAGE EXTERNO**
```bash
# Permitir acesso ao storage
termux-setup-storage

# Copiar gamemode do storage
cp ~/storage/downloads/rjroleplay.pwn gamemodes/
```

### **COMPARTILHAR ARQUIVO COMPILADO**
```bash
# Copiar AMX para downloads
cp gamemodes/rjroleplay.amx ~/storage/downloads/

# Ou enviar por e-mail
termux-share gamemodes/rjroleplay.amx
```

## ✅ CHECKLIST FINAL

- [ ] ✅ Termux atualizado
- [ ] ✅ Compilador Pawn instalado
- [ ] ✅ Includes baixados
- [ ] ✅ Gamemode copiado
- [ ] ✅ Script de compilação criado
- [ ] ✅ Gamemode compilado com sucesso
- [ ] ✅ Arquivo .amx gerado
- [ ] ✅ Pronto para upload na LemeHost

---

## 🆘 SUPORTE TERMUX

**Se der algum erro:**

1. Verifique se o Termux tem permissões
2. Reinicie o Termux se necessário
3. Verifique se todos os includes foram baixados
4. Use `./compile.sh rjroleplay` para ver erros detalhados

**💡 DICA:** Mantenha o Termux sempre atualizado e use `termux-wake-lock` para evitar que seja fechado pelo sistema Android.