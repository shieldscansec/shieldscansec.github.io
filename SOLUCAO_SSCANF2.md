# Solução para Erro do sscanf2

## Problema
Você recebeu este erro ao compilar:
```
D:\Server\pawno\include\sscanf2.inc(125) : fatal error 111: user error: sscanf utilises community compiler features.  Use `#define SSCANF_NO_NICE_FEATURES` to live without (if you can call that living) or better yet download it here: github.com/pawn-lang/compiler/releases
```

## Soluções Implementadas

### ✅ Solução Temporária (APLICADA)
Adicionei `#define SSCANF_NO_NICE_FEATURES` antes do include do sscanf2 no arquivo `gamemodes/rjroleplay.pwn`.

Esta solução desabilita os recursos avançados do sscanf2, mas mantém a funcionalidade básica.

### 🚀 Solução Recomendada (Para melhor performance)
Para aproveitar todos os recursos do sscanf2, baixe o Community Compiler:

1. **Baixar o Community Compiler:**
   - Acesse: https://github.com/pawn-lang/compiler/releases
   - Baixe a versão mais recente
   - Substitua o `pawncc.exe` na pasta `pawno/`

2. **Vantagens do Community Compiler:**
   - Melhor performance do sscanf2
   - Recursos avançados de compilação
   - Melhor otimização de código
   - Suporte a syntax moderna

## Testando a Compilação

Agora você pode tentar compilar novamente. O erro deve ter sido resolvido.

### Funcionalidades do sscanf2 que continuam funcionando:
- ✅ Parsing básico de parâmetros: `sscanf(params, "uis[128]", id, valor, string)`
- ✅ Todos os especificadores básicos (u, i, s, f, d, etc.)
- ✅ Arrays e strings
- ❌ Recursos avançados (desabilitados temporariamente)

## Próximos Passos

1. **Testar a compilação** com a solução atual
2. **Considerar atualizar** para o Community Compiler para melhor performance
3. **Manter backup** dos arquivos antes de qualquer mudança

## Arquivos Modificados
- `gamemodes/rjroleplay.pwn` - Adicionado define para compatibilidade