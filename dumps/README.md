# Pasta de Dumps

Esta pasta contém todos os arquivos XML de dump da interface do usuário (UI) gerados durante a execução dos testes.

## Organização

### Arquivos gerados automaticamente:
- `*_[timestamp].xml` - Arquivos com timestamp único gerados durante execução dos testes
- Timestamp formato: epoch (ex: 1761230195)

### Tipos de dump por funcionalidade:

#### Rede e Internet (2-5):
- `rede_internet_dump_*.xml` - Dump da tela principal de Rede e Internet

#### Wi-Fi (14-15):
- `antes_wifi_dump_*.xml` - Dump antes de clicar no Wi-Fi (debug)
- `wifi_dump_*.xml` - Dump da tela de Wi-Fi após navegação
- `verificacao_navegacao_*.xml` - Dump para verificar navegação Wi-Fi

#### Preferências Wi-Fi (16):
- `wifi_preferencias_dump_*.xml` - Dump da tela de preferências do Wi-Fi

#### Detalhes da Rede (17-18):
- `antes_detalhes_dump_*.xml` - Dump antes de acessar detalhes (debug)
- `detalhes_tentativa1_*.xml` - Dump da primeira tentativa de acesso aos detalhes
- `detalhes_rede_dump_*.xml` - Dump final da tela de detalhes da rede

## Limpeza

Os arquivos são organizados automaticamente com timestamp para evitar sobrescrita.
Recomenda-se limpeza periódica dos arquivos mais antigos para economizar espaço.

## Utilização

Estes arquivos são úteis para:
- Debug de problemas de interface
- Análise de elementos da tela
- Verificação de navegação
- Desenvolvimento de novos testes