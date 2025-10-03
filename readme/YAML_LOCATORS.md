# Locators YAML - Estrutura Organizacional

Este sistema permite organizar todos os locators (seletores de elementos) em arquivos YAML, facilitando a manutenção e permitindo configurações específicas por fabricante de dispositivo.

## 📋 Estrutura do YAML

### Seções Principais

```yaml
# Configuração padrão (fallback)
default:
  app:                 # Informações do app
  main_screen:         # Elementos da tela principal
  menu_items:          # Itens do menu
  common_elements:     # Elementos comuns

# Configurações específicas por fabricante
samsung:             # Herda de 'default' e sobrescreve específicos
xiaomi:              # Configurações para MIUI
google:              # Configurações para Android puro
huawei:              # Configurações para EMUI
```

### Tipos de Locators Suportados

- **text**: Texto visível na tela
- **text_en**: Texto em inglês
- **text_variations**: Lista de variações de texto
- **xpath**: Seletor XPath
- **id**: Resource ID do Android
- **class**: Classe do elemento
- **coordinates**: Coordenadas X,Y para tap

### Coordenadas Adaptativas

```yaml
coordinates:
  hd_720p:           # 720x1280
    search_icon: [360, 100]
    center_tap: [360, 640]
  
  fhd_1080p:         # 1080x1920
    search_icon: [540, 150]
    center_tap: [540, 960]
  
  qhd_1440p:         # 1440x2560
    search_icon: [720, 200]
    center_tap: [720, 1280]
```

## 🔧 Como Usar

### 1. Carregar Locators

```robotframework
*** Test Cases ***
Meu Teste
    # Carregar locators do arquivo YAML
    Carregar Locators YAML
    
    # Detectar dispositivo automaticamente
    Detectar E Configurar Dispositivo
```

### 2. Obter Textos de Locators

```robotframework
# Obter texto específico para o dispositivo atual
${wifi_text}=    Obter Texto Locator    menu_items    wifi
${apps_text}=    Obter Texto Locator    menu_items    apps

Log    Texto Wi-Fi: ${wifi_text}
Log    Texto Apps: ${apps_text}
```

### 3. Tocar em Elementos

```robotframework
# Tocar usando locators YAML (tenta texto primeiro, depois coordenadas)
Tocar Elemento YAML    menu_items    wifi
Tocar Elemento YAML    menu_items    bluetooth
```

### 4. Obter Coordenadas Adaptativas

```robotframework
# Obtém coordenadas baseadas na resolução da tela
${coords}=    Obter Coordenadas Tap    search_icon
Tocar Por Coordenadas    ${coords}[0]    ${coords}[1]
```

## 📱 Diferenças por Fabricante

### Samsung
- **Segurança**: "Biometria e segurança"
- **Contas**: "Contas e backup"
- **Sistema**: "Atualização de software"

### Xiaomi (MIUI)
- **Segurança**: "Senhas e segurança"
- **Contas**: "Conta Mi"
- **Sistema**: "Sobre o telefone"

### Google (Android Puro)
- **Wi-Fi**: "Rede e Internet"
- **Bluetooth**: "Dispositivos conectados"

### Huawei (EMUI)
- **Display**: "Exibição e brilho"
- **Contas**: "Usuários e contas"
- **Sistema**: "Sistema e atualizações"

## 🎯 Vantagens

### ✅ Manutenção Centralizada
- Todos os locators em um só arquivo
- Fácil de atualizar e versionar
- Reduz duplicação de código

### ✅ Adaptação Automática
- Detecta fabricante automaticamente
- Usa textos corretos para cada dispositivo
- Coordenadas adaptáveis à resolução

### ✅ Fallback Inteligente
- Se locator específico não existe, usa padrão
- Múltiplas estratégias de localização
- Logs detalhados para debug

### ✅ Escalabilidade
- Fácil adicionar novos fabricantes
- Suporte a múltiplos idiomas
- Configurações de timeout centralizadas

## 📝 Exemplo Prático

```robotframework
*** Settings ***
Resource    ../resources/yaml_locators.robot

*** Test Cases ***
Navegar Configurações
    # Setup automático
    Carregar Locators YAML
    ${device_type}=    Detectar E Configurar Dispositivo
    
    # Abrir configurações
    Run Process    adb    shell    am    start    -n    com.android.settings/.Settings
    Sleep    3s
    
    # Navegar usando locators YAML
    Tocar Elemento YAML    menu_items    wifi        # Abre Wi-Fi
    Sleep    2s
    Run Process    adb    shell    input    keyevent    KEYCODE_BACK
    
    Tocar Elemento YAML    menu_items    bluetooth   # Abre Bluetooth
    Sleep    2s
    Run Process    adb    shell    input    keyevent    KEYCODE_BACK
    
    Tocar Elemento YAML    menu_items    apps        # Abre Apps
```

## 🔍 Debug e Troubleshooting

### Verificar Locators Carregados
```robotframework
${wifi_text}=    Obter Texto Locator    menu_items    wifi
Log    Texto Wi-Fi detectado: ${wifi_text}
```

### Testar Coordenadas
```robotframework
${coords}=    Obter Coordenadas Tap    search_icon
Log    Coordenadas do ícone de busca: ${coords}
```

### Forçar Tipo de Dispositivo
```robotframework
Set Suite Variable    ${CURRENT_DEVICE}    samsung
# Agora usará configurações Samsung independente do dispositivo
```

## 📊 Estrutura de Arquivos

```
resources/
├── locators.yml          # Arquivo principal de locators
├── yaml_locators.robot   # Keywords para usar os locators
└── device_config.robot   # Configurações legadas (compatibilidade)

tests/
└── yaml_locators_test.robot  # Testes demonstrando uso
```

## 🚀 Execução

```bash
# Executar testes específicos YAML
./run_tests.sh
# Escolher opção 3

# Ou diretamente
robot --outputdir logs tests/yaml_locators_test.robot
```