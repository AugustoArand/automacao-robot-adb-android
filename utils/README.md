# Utils - Utilitários para Automação Android

Esta pasta contém utilitários especializados para automação Android usando comandos ADB diretamente.

## 📁 Arquivos

### 📸 `screenshot_utils.robot`
Utilitários para captura de screenshots via ADB.

**Principais Keywords:**
- `Capturar Screenshot` - Captura básica com nome opcional
- `Capturar Screenshot Com Timestamp` - Captura com timestamp automático
- `Capturar Screenshot De Teste` - Captura padronizada para testes
- `Verificar Capacidade Screenshot` - Verifica se dispositivo suporta screencap
- `Limpar Screenshots Antigos` - Remove screenshots antigos
- `Obter Informacoes Screenshot` - Retorna metadados do screenshot

### 📱 `swipe_utils.robot`
Utilitários para gestos de swipe adaptativos baseados na resolução do dispositivo.

**Principais Keywords:**
- `Swipe Up Adaptativo` - Swipe para cima adaptado à resolução
- `Swipe Down Adaptativo` - Swipe para baixo adaptado à resolução
- `Swipe Lateral Adaptativo` - Swipe horizontal (esquerda/direita)
- `Swipe Up Multiplo` / `Swipe Down Multiplo` - Múltiplos swipes consecutivos
- `Obter Resolucao Dispositivo` - Detecta resolução da tela
- `Obter Densidade Tela` - Obtém DPI do dispositivo

### 🧪 `test_utils_example.robot`
Arquivo de exemplo demonstrando como usar os utilitários.

## 🚀 Como Usar

### Importar nos seus testes:

```robot
*** Settings ***
Resource    ../utils/screenshot_utils.robot
Resource    ../utils/swipe_utils.robot
```

### Exemplos de uso:

#### Screenshots
```robot
# Captura básica
${caminho}=    Capturar Screenshot

# Captura com nome específico
${caminho}=    Capturar Screenshot    minha_tela.png

# Captura com timestamp
${caminho}=    Capturar Screenshot Com Timestamp    teste

# Captura para teste específico
${caminho}=    Capturar Screenshot De Teste    login_test    sucesso
```

#### Swipes Adaptativos
```robot
# Swipe up básico (adaptado à resolução)
Swipe Up Adaptativo

# Swipe down com duração personalizada
Swipe Down Adaptativo    duration_ms=800

# Swipe lateral
Swipe Lateral Adaptativo    right
Swipe Lateral Adaptativo    left

# Múltiplos swipes
Swipe Up Multiplo    quantidade=5    intervalo_ms=300
```

#### Swipes Personalizados
```robot
# Swipe up curto (60% → 40% da tela)
Swipe Up Adaptativo    duration_ms=300    start_y_percent=60    end_y_percent=40

# Swipe up longo (90% → 10% da tela) 
Swipe Up Adaptativo    duration_ms=1000    start_y_percent=90    end_y_percent=10
```

## 🎯 Características

### Screenshots
- **Automático**: Gera nomes com timestamp se não especificado
- **Organizado**: Salva na pasta `screenshots/`
- **Metadados**: Fornece informações sobre tamanho e data
- **Limpeza**: Remove screenshots antigos automaticamente

### Swipes Adaptativos
- **Resolução Inteligente**: Detecta automaticamente a resolução do dispositivo
- **Percentuais**: Usa percentuais em vez de coordenadas fixas
- **Múltiplos Dispositivos**: Funciona em qualquer resolução Android
- **Personalizável**: Permite ajustar velocidade, posição e quantidade

## 📐 Sistema de Coordenadas

### Percentuais Padrão:
- **Swipe Up**: 80% → 20% (da parte inferior para superior)
- **Swipe Down**: 20% → 80% (da parte superior para inferior)  
- **Centro X**: 50% (meio da tela horizontalmente)
- **Duração**: 500ms

### Resoluções Testadas:
- ✅ 1080x1920 (Full HD)
- ✅ 1440x2560 (QHD)
- ✅ 720x1280 (HD)
- ✅ 2160x3840 (4K)
- ✅ Tablets e telefones

## 🔧 Configuração

### Variáveis Personalizáveis:

#### Screenshots (`screenshot_utils.robot`)
```robot
${SCREENSHOT_DIR}           # Pasta de destino (padrão: ../screenshots)
${DEVICE_SCREENSHOT_PATH}   # Caminho temporário no dispositivo
```

#### Swipes (`swipe_utils.robot`)
```robot
${SWIPE_START_Y_PERCENT}    # Início do swipe up (padrão: 80%)
${SWIPE_END_Y_PERCENT}      # Fim do swipe up (padrão: 20%)
${SWIPE_CENTER_X_PERCENT}   # Centro horizontal (padrão: 50%)
${SWIPE_DURATION_MS}        # Duração padrão (padrão: 500ms)
```

## 🧪 Testar os Utils

Execute o arquivo de exemplo para testar todas as funcionalidades:

```bash
robot utils/test_utils_example.robot
```

Ou execute testes específicos:

```bash
# Testar apenas screenshots
robot --include screenshot utils/test_utils_example.robot

# Testar apenas swipes
robot --include swipe utils/test_utils_example.robot

# Testar múltiplos swipes
robot --include multiplo utils/test_utils_example.robot
```

## 📋 Pré-requisitos

1. **ADB configurado** e no PATH
2. **Dispositivo conectado** via USB ou emulador
3. **Depuração USB ativada**
4. **Robot Framework** instalado

### Verificar pré-requisitos:
```bash
adb devices        # Deve mostrar seu dispositivo
adb shell screencap --help    # Deve mostrar ajuda do screencap
adb shell input    # Deve mostrar opções de input
```

## 🚀 Integração com Outros Arquivos

### Com `base.resource`:
```robot
*** Settings ***
Resource    base.resource
Resource    utils/screenshot_utils.robot
Resource    utils/swipe_utils.robot

*** Test Cases ***
Meu Teste Com Utils
    Setup Teste Basico
    
    # Usar funcionalidades dos utils
    Capturar Screenshot De Teste    meu_teste    inicio
    Swipe Up Adaptativo
    Verificar Elemento Apareceu
    Capturar Screenshot De Teste    meu_teste    sucesso
    
    Teardown Teste Basico
```

### Com YAML Locators:
```robot
*** Settings ***
Resource    ../resources/yaml_locators.robot
Resource    ../utils/swipe_utils.robot
Resource    ../utils/screenshot_utils.robot

*** Test Cases ***
Navegacao Com Swipe
    Abrir Configuracoes
    Capturar Screenshot De Teste    navegacao    configuracoes
    
    # Rolar para baixo para encontrar opção
    Swipe Down Adaptativo
    Verificar Se Elemento Existe    configuracoes.wifi
    
    Capturar Screenshot De Teste    navegacao    wifi_encontrado
```