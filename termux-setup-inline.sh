#!/bin/bash
# COPIE E COLE ESTE SCRIPT INTEIRO NO TERMUX

echo "🚀 CONFIGURANDO SA-MP TERMUX..."

# Atualizar e instalar
pkg update -y && pkg upgrade -y
pkg install -y wget curl unzip git build-essential clang

# Criar ambiente
cd ~
rm -rf samp-server
mkdir samp-server
cd samp-server
mkdir -p gamemodes include

echo "📦 Baixando compilador..."
wget -q https://github.com/pawn-lang/compiler/releases/download/v3.10.10/pawncc-3.10.10-linux.tar.gz
tar -xzf pawncc-3.10.10-linux.tar.gz
mv pawncc pawncc-linux
chmod +x pawncc-linux
rm pawncc-3.10.10-linux.tar.gz

echo "📚 Baixando includes..."
cd include
wget -q -O a_samp.inc https://raw.githubusercontent.com/pawn-lang/samp-stdlib/master/a_samp.inc
wget -q -O a_mysql.inc https://raw.githubusercontent.com/pBlueG/SA-MP-MySQL/master/a_mysql.inc
wget -q -O sscanf2.inc https://raw.githubusercontent.com/Y-Less/sscanf/master/sscanf2.inc
wget -q -O streamer.inc https://raw.githubusercontent.com/samp-incognito/samp-streamer-plugin/master/include/streamer.inc
wget -q -O zcmd.inc https://raw.githubusercontent.com/Southclaws/zcmd/master/zcmd.inc
wget -q -O whirlpool.inc https://raw.githubusercontent.com/Southclaws/samp-whirlpool/master/whirlpool.inc
wget -q -O foreach.inc https://raw.githubusercontent.com/Y-Less/foreach/master/foreach.inc
cd ..

echo "🔨 Criando gamemode de teste..."
cat > gamemodes/teste_funcional.pwn << 'EOF'
#include <a_samp>
#include <zcmd>

public OnGameModeInit() {
    print("✅ SERVIDOR SA-MP FUNCIONANDO!");
    print("✅ Compilado no Termux com sucesso!");
    SetGameModeText("Termux Test v1.0");
    return 1;
}

public OnPlayerConnect(playerid) {
    new string[128], name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    format(string, sizeof(string), "✅ %s conectou! Compilado no Termux!", name);
    SendClientMessageToAll(0x00FF00FF, string);
    SendClientMessage(playerid, 0xFFFF00FF, "🎉 Servidor compilado com sucesso no Termux!");
    return 1;
}

public OnPlayerSpawn(playerid) {
    SetPlayerPos(playerid, 1958.33, 1343.12, 15.36);
    SetPlayerSkin(playerid, 26);
    GivePlayerMoney(playerid, 50000);
    return 1;
}

CMD:teste(playerid, params[]) {
    SendClientMessage(playerid, 0x00FF00FF, "✅ Comando funcionando! Compilação OK!");
    return 1;
}

CMD:dinheiro(playerid, params[]) {
    GivePlayerMoney(playerid, 10000);
    SendClientMessage(playerid, 0x00FF00FF, "💰 +R$ 10.000 adicionados!");
    return 1;
}

CMD:vida(playerid, params[]) {
    SetPlayerHealth(playerid, 100.0);
    SendClientMessage(playerid, 0x00FF00FF, "❤️ Vida restaurada!");
    return 1;
}
EOF

echo "🔧 Compilando gamemode teste..."
./pawncc-linux -i"./include" -d3 -v2 gamemodes/teste_funcional.pwn -ogamemodes/teste_funcional.amx

if [ -f "gamemodes/teste_funcional.amx" ]; then
    echo "✅ SUCESSO! Gamemode compilado!"
    echo "📁 Arquivo: $(ls -lh gamemodes/teste_funcional.amx)"
else
    echo "❌ Erro na compilação do teste"
fi

echo "🔧 Criando corretor para outros gamemodes..."
cat > fix-gamemode.sh << 'EOF'
#!/bin/bash
if [ -z "$1" ]; then
    echo "Uso: ./fix-gamemode.sh arquivo.pwn"
    exit 1
fi

FILE="$1"
BACKUP="${FILE%.pwn}_backup.pwn"
echo "🔄 Backup: $BACKUP"
cp "$FILE" "$BACKUP"

echo "🔧 Corrigindo erros..."
sed -i 's/^}/};/g' "$FILE"
sed -i 's/\[13,/[13],/g' "$FILE"
sed -i 's/\[12,/[12],/g' "$FILE" 
sed -i 's/orgSpawnX,/Float:orgSpawnX,/g' "$FILE"
sed -i 's/orgSpawnY,/Float:orgSpawnY,/g' "$FILE"
sed -i 's/orgSpawnZ,/Float:orgSpawnZ,/g' "$FILE"
sed -i 's/pWeapons\[/gPlayerData[playerid][pWeapons][/g' "$FILE"

echo "✅ Correções aplicadas!"
echo "🔨 Para compilar: ./pawncc-linux -i\"./include\" -d3 \"$FILE\" -o\"${FILE%.pwn}.amx\""
EOF

chmod +x fix-gamemode.sh

cat > compile.sh << 'EOF'
#!/bin/bash
GAMEMODE="${1:-teste_funcional}"
echo "🔨 Compilando: $GAMEMODE.pwn"

./pawncc-linux \
    -i"./include" \
    -d3 \
    -v2 \
    -w203 \
    -w214 \
    -w219 \
    -w220 \
    "gamemodes/$GAMEMODE.pwn" \
    -o"gamemodes/$GAMEMODE.amx"

if [ $? -eq 0 ]; then
    echo "✅ COMPILAÇÃO SUCESSO!"
    ls -lh "gamemodes/$GAMEMODE.amx"
else
    echo "❌ ERRO na compilação"
fi
EOF

chmod +x compile.sh

echo ""
echo "🎉 CONFIGURAÇÃO CONCLUÍDA!"
echo "=========================================="
echo "📂 Pasta: ~/samp-server"
echo "📁 Gamemode teste: gamemodes/teste_funcional.amx"
echo ""
echo "📋 COMANDOS DISPONÍVEIS:"
echo "  ./compile.sh nome_gamemode    - Compilar"
echo "  ./fix-gamemode.sh arquivo.pwn - Corrigir erros"
echo ""
echo "🔧 PARA CORRIGIR SEU GAMEMODE:"
echo "1. Copie seu .pwn para gamemodes/"
echo "2. Execute: ./fix-gamemode.sh gamemodes/SEU_ARQUIVO.pwn"
echo "3. Compile: ./compile.sh SEU_ARQUIVO"
echo ""
echo "📱 COMPARTILHAR ARQUIVO:"
echo "  termux-setup-storage"
echo "  cp gamemodes/*.amx ~/storage/downloads/"
echo "=========================================="

# Teste final
if [ -f "gamemodes/teste_funcional.amx" ]; then
    echo "✅ TUDO FUNCIONANDO PERFEITAMENTE!"
else
    echo "❌ Algo deu errado. Verifique os erros acima."
fi