# Automação Android com Robot Framework + ADB + YAML

Este projeto utiliza Robot Framework com ADB (Android Debug Bridge) e sistema YAML de locators para automatizar dispositivos Android de forma rápida e estável.

## ✨ Características

- **🚀 Sem Appium Server**: Usa ADB diretamente para maior estabilidade
- **📱 Multi-dispositivo**: Suporte automático para Samsung, Xiaomi, Google, Huawei
- **🎯 YAML Locators**: Sistema inteligente de locators adaptáveis
- **🔧 Setup Automático**: Ambiente configurado automaticamente
- **📸 Screenshots**: Captura automática com timestamps

## Pré-requisitos

1. **Android SDK** instalado e configurado
2. **ADB** disponível no PATH
3. Dispositivo Android conectado via USB ou emulador rodando
4. Python 3.8+ com Robot Framework

## Configuração do Ambiente

### 1. Instalar Android SDK
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install android-sdk

# Ou baixar do site oficial da Google
```

### 2. Ativar ambiente virtual Python
```bash
source .venv/bin/activate
```

### 3. Verificar se ADB está funcionando
```bash
adb version
```

## Configuração do Dispositivo

### Habilitar Depuração USB
1. Vá em **Configurações** > **Sobre o telefone**
2. Toque 7 vezes em **Número da versão**
3. Volte para **Configurações** > **Sistema** > **Opções do desenvolvedor**
4. Ative **Depuração USB**

### Verificar conexão
```bash
adb devices
```

## Executar Testes

### 🚀 Iniciante - Testes básicos ADB
```bash
robot tests/adb_basic_tests.robot
```

### 🎯 Recomendado - Configurações com ADB + YAML
```bash
robot tests/configuracoes_adb_yaml_test.robot
```

### 🔬 Avançado - Sistema YAML Locators
```bash
robot tests/yaml_locators_test.robot
```

### 📱 Detecção de Dispositivos
```bash
robot tests/device_detection_tests.robot
```

### 📊 Executar todos os testes
```bash
robot tests/
```

### 🚀 Script interativo (Recomendado)
```bash
./run_tests.sh
```

## Estrutura do Projeto

```
automacao-adb/
├── base.resource              # ⭐ Arquivo central de modularização
├── tests/                     # Arquivos de teste
│   ├── adb_basic_tests.robot        # 🚀 Testes básicos com ADB
│   ├── configuracoes_adb_yaml_test.robot  # 🎯 Configurações ADB + YAML  
│   ├── yaml_locators_test.robot     # 🔬 Testes avançados YAML
│   └── device_detection_tests.robot # 📱 Detecção automática do dispositivo
├── resources/                 # Keywords e configurações
│   ├── locators.yml           # ⭐ Locators organizados em YAML
│   └── yaml_locators.robot    # ⭐ Keywords para usar locators YAML
├── screenshots/               # Screenshots capturados automaticamente
├── logs/                      # Relatórios de execução e device info
├── requirements.txt           # Dependências Python
├── run_tests.sh              # Script principal de execução
├── demo.sh                   # Script de demonstração
├── README.md                 # Esta documentação
├── YAML_LOCATORS.md          # ⭐ Documentação dos locators YAML
└── BASE_RESOURCE.md          # ⭐ Documentação do sistema de modularização
```

## 🚀 **Funcionalidades Principais**

### ⭐ **1. Base Resource (Modularização)**
- **Arquivo central**: `base.resource` com todas as configurações
- **Setup/Teardown automáticos**: Configuração e limpeza automática  
- **Keywords globais**: Funções prontas para uso
- **Validações automáticas**: Pré-requisitos sempre verificados
- **📖 Documentação**: [BASE_RESOURCE.md](BASE_RESOURCE.md)

### ⭐ **2. Locators YAML (Organização)**
- **Estrutura organizada**: Locators em arquivo YAML
- **Detecção automática**: Identifica fabricante do dispositivo
- **Configurações específicas**: Samsung, Xiaomi, Google, Huawei
- **Coordenadas adaptáveis**: Baseadas na resolução da tela
- **📖 Documentação**: [YAML_LOCATORS.md](YAML_LOCATORS.md)

### ⭐ **3. ADB Direto (Estabilidade)**
- **Sem dependências externas**: Não precisa do Appium Server
- **Mais rápido**: Comandos diretos via ADB
- **Mais estável**: Menos pontos de falha
- **Cross-platform**: Funciona em qualquer dispositivo Android

## Comandos Úteis ADB

```bash
# Listar dispositivos conectados
adb devices

# Obter informações do dispositivo  
adb shell getprop ro.build.version.release  # Versão Android
adb shell getprop ro.product.model          # Modelo do dispositivo

# Capturar screenshot
adb shell screencap -p /sdcard/screenshot.png
adb pull /sdcard/screenshot.png

# Abrir app de configurações
adb shell am start -n com.android.settings/.Settings

# Simular toque na tela
adb shell input tap 500 800

# Digitar texto
adb shell input text "Hello World"

# Pressionar teclas
adb shell input keyevent KEYCODE_BACK
```