# Testes Implementados - Robot Framework Android

## 📱 Cenários de Teste por Arquivo

### 1. Rede e Internet (`redeEInternet.robot`)
- **Cenário 01**: Acessando Tela de Rede e Internet (2-5)
- **Cenário 02**: Acessar Wi-Fi (14-15)  
- **Cenário 03**: Acessar os Detalhes a Rede Conectada (17-18)
- **Cenário 04**: Acessar Sugestão de Melhoria (Wi-Fi desligado)
- **Cenário 05**: (Em desenvolvimento)

### 2. Detalhes da Rede (`detalhesRede.robot`)
- **Teste Principal**: Acessar os Detalhes da Rede Conectada
  - Navega: Configurações → Rede e Internet → Wi-Fi → Detalhes
  - Captura informações detalhadas da rede conectada
  - Testa desligamento/religamento do Wi-Fi

### 3. Dispositivos Conectados (`dispositivosConectados.robot`)
- **Cenário 01**: Acessar Tela de Dispositivos Conectados (20)
- **Cenário 02**: Acessar Tela de Parear Novo Dispositivo (21)
- **Cenário 03**: Acessar Preferências de Conexão (22-23)

## 🛠️ Funcionalidades Implementadas

### Keywords Principais
- `Acessar Rede e Internet 2-5`: Navegação para configurações de rede
- `Acessar Wi-Fi 14-15`: Acesso às configurações Wi-Fi
- `Acessar os Detalhes a Rede Conectada 17-18`: Detalhes da rede
- `Acessar Dispositivos Conectados`: Tela de dispositivos Bluetooth
- `Acessar Parear Novo Dispositivo`: Pareamento Bluetooth
- `Acessar Preferencias Conexao`: Preferências Bluetooth

### Recursos de Automação
- ✅ Navegação por ADB (sem Appium)
- ✅ Captura de screenshots automática
- ✅ Dumps de UI para análise
- ✅ Validação de elementos na tela
- ✅ Gerenciamento de estado (Wi-Fi, Bluetooth)
- ✅ Locators YAML para GPOS760/GPOS780

## 📋 Como Executar

### Via Script Bash
```bash
./run_tests.sh
```
Escolha uma opção do menu interativo.

### Via Robot Framework Direto
```bash
# Teste específico
robot tests/dispositivosConectados.robot

# Cenário específico
robot --test "Cenário 01*" tests/dispositivosConectados.robot

# Por tags
robot --include dispositivos_conectados tests/

# Todos os testes
robot tests/
```

## 📁 Estrutura de Arquivos Gerados

```
├── screenshots/           # Screenshots dos testes
├── dumps/                # Dumps XML da UI
├── logs/                 # Logs detalhados
├── log.html             # Relatório principal
├── report.html          # Resumo executivo
└── output.xml           # Dados estruturados
```

## 🎯 Locators Disponíveis

### Rede e Internet
- `resources/locators/gpos760/redeInternetLocators.yml`

### Dispositivos Conectados  
- `resources/locators/gpos760/dispConectadosLocators.yml`

## 🚀 Próximos Passos

1. **Cenários 6-13**: Implementar cenários intermediários
2. **Cenários 24-30**: Expandir testes Bluetooth
3. **Multi-dispositivo**: Suporte a outros modelos
4. **CI/CD**: Integração contínua
5. **Relatórios**: Dashboard de execução

## 📞 Suporte

- Locators extraídos via ADB UI Automator
- Compatível com dispositivos GPOS760/GPOS780
- Testado em Android (versão detectada via ADB)