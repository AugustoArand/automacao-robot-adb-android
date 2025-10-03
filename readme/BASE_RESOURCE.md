# Base Resource - Modularização Central

O arquivo `base.resource` centraliza todas as funcionalidades comuns do projeto, melhorando a modularização, manutenção e reutilização de código.

## 📋 Estrutura do Base Resource

### 🔧 **Imports Centralizados**
```robotframework
# Bibliotecas padrão
Library    Collections
Library    OperatingSystem  
Library    Process
Library    String
Library    DateTime
Library    yaml

# Bibliotecas específicas Android
Library    AppiumLibrary    WITH NAME    Appium
Library    ScreenCapLibrary

# Recursos do projeto
Resource   resources/android_keywords.robot
Resource   resources/yaml_locators.robot
Resource   resources/device_config.robot
```

### 🌐 **Variáveis Globais**
```robotframework
${PROJECT_ROOT}              # Raiz do projeto
${SCREENSHOTS_DIR}           # Diretório de screenshots
${LOGS_DIR}                  # Diretório de logs
${ADB_COMMAND}               # Comando ADB
${SHORT_TIMEOUT}             # 5s
${MEDIUM_TIMEOUT}            # 10s
${LONG_TIMEOUT}              # 30s
```

### 🚀 **Keywords Globais Principais**

#### **Setup e Teardown Automáticos**
```robotframework
Setup Teste Android
    # ✅ Cria diretórios necessários
    # ✅ Verifica ADB e dispositivo
    # ✅ Carrega locators YAML
    # ✅ Detecta tipo de dispositivo automaticamente
    # ✅ Define variáveis de teste

Teardown Teste Android
    # ✅ Captura screenshot se teste falhou
    # ✅ Fecha apps abertos
    # ✅ Volta para tela inicial
    # ✅ Limpa ambiente
```

#### **Validação e Verificação**
```robotframework
Validar Pré Requisitos
    # ✅ Verifica se ADB está disponível
    # ✅ Verifica dispositivo conectado
    # ✅ Testa comunicação ADB
    # ✅ Verifica estado da tela

Verificar Dispositivo Conectado
    # ✅ Lista dispositivos
    # ✅ Conta dispositivos ativos
    # ✅ Define variável ${DEVICE_COUNT}
```

#### **Manipulação de Apps**
```robotframework
Abrir App Configuracoes
    # ✅ Abre via intent específico
    # ✅ Aguarda carregamento
    # ✅ Verifica sucesso

Fechar App Configuracoes
    # ✅ Force-stop do processo
    # ✅ Limpeza de memória
```

#### **Screenshots Inteligentes**
```robotframework
Capturar Screenshot Global
    # ✅ Timestamp automático
    # ✅ Nome baseado no teste
    # ✅ Organização automática
    # ✅ Limpeza de arquivos temporários

Capturar Screenshot Falha
    # ✅ Automático em caso de falha
    # ✅ Contexto do erro
    # ✅ Debug facilitado
```

#### **Robustez e Retry**
```robotframework
Executar Com Retry
    # ✅ Retry automático configurável
    # ✅ Delay entre tentativas
    # ✅ Log de progresso
    # ✅ Falha controlada

Aguardar E Verificar Elemento
    # ✅ Timeout configurável
    # ✅ Screenshot automático em falha
    # ✅ Validação robusta
```

#### **Informações do Dispositivo**
```robotframework
Obter Informacoes Dispositivo
    # ✅ Coleta completa de dados
    # ✅ Fabricante, modelo, versão
    # ✅ Resolução e densidade
    # ✅ Retorna dicionário estruturado

Criar Relatório Dispositivo
    # ✅ Relatório formatado
    # ✅ Salva em arquivo
    # ✅ Timestamp automático
```

## 💡 **Como Usar**

### **Importação Simples**
```robotframework
*** Settings ***
Resource    ../base.resource

# Setup/Teardown automáticos (opcional)
Test Setup       Setup Teste Android
Test Teardown    Teardown Teste Android
```

### **Exemplo Básico**
```robotframework
*** Test Cases ***
Meu Teste
    # Todas as funcionalidades já disponíveis!
    Log Separador    INICIANDO TESTE
    
    # Dispositivo já detectado automaticamente
    Log    Dispositivo: ${DEVICE_TYPE}
    
    # App já pode ser aberto
    Abrir App Configuracoes
    
    # Screenshot com organização automática
    ${screenshot}=    Capturar Screenshot Global    meu_teste
    
    # Retry automático para operações instáveis
    Executar Com Retry    Minha Operacao    max_attempts=3
```

### **Exemplo Avançado**
```robotframework
*** Test Cases ***
Teste Robusto
    # Validação completa
    Validar Pré Requisitos
    
    # Informações detalhadas
    &{device}=    Obter Informacoes Dispositivo
    Log    📱 ${device.manufacturer} ${device.model}
    
    # Relatório automático
    ${report}=    Criar Relatório Dispositivo
    
    # Navegação com YAML (já carregado)
    Tocar Elemento YAML    menu_items    wifi
```

## 🎯 **Vantagens da Modularização**

### ✅ **Centralização**
- **Imports únicos**: Todas as bibliotecas em um lugar
- **Configurações globais**: Variáveis centralizadas
- **Keywords comuns**: Reutilização máxima

### ✅ **Padronização**
- **Setup/Teardown consistentes**: Mesmo comportamento em todos os testes
- **Nomenclatura uniforme**: Padrões definidos
- **Estrutura organizada**: Fácil manutenção

### ✅ **Robustez**
- **Validações automáticas**: Pré-requisitos sempre verificados
- **Retry inteligente**: Operações instáveis automatizadas
- **Error handling**: Screenshots e logs automáticos

### ✅ **Produtividade**
- **Menos código**: Keywords prontas
- **Menos erros**: Validações automáticas
- **Debug fácil**: Logs padronizados

## 📊 **Comparação: Antes vs Depois**

### **❌ Antes (sem base.resource)**
```robotframework
*** Settings ***
Library    Collections
Library    OperatingSystem
Library    Process
Library    String
Resource   resources/android_keywords.robot
Resource   resources/yaml_locators.robot

*** Test Cases ***
Meu Teste
    # Verificar ADB manualmente
    ${result}=    Run Process    adb    version
    Should Be Equal As Integers    ${result.rc}    0
    
    # Verificar dispositivo manualmente
    ${devices}=    Run Process    adb    devices
    Should Contain    ${devices.stdout}    device
    
    # Carregar YAML manualmente
    Carregar Locators YAML
    Detectar E Configurar Dispositivo
    
    # Abrir app manualmente
    Run Process    adb    shell    am    start    -n    com.android.settings/.Settings
    Sleep    3s
    
    # ... resto do teste
```

### **✅ Depois (com base.resource)**
```robotframework
*** Settings ***
Resource    ../base.resource
Test Setup  Setup Teste Android

*** Test Cases ***
Meu Teste
    # Tudo já configurado automaticamente!
    Abrir App Configuracoes
    ${screenshot}=    Capturar Screenshot Global    meu_teste
    # ... foco no teste, não na infraestrutura
```

## 🔍 **Funcionalidades Detalhadas**

### **Log Separador**
```robotframework
Log Separador    TÍTULO DA SEÇÃO
# Saída:
# ==================================================
# TÍTULO DA SEÇÃO  
# ==================================================
```

### **Captura Inteligente**
```robotframework
${screenshot}=    Capturar Screenshot Global    operacao_wifi
# Gera: operacao_wifi_TC001_Meu_Teste_1696259234.png
# Organiza automaticamente por timestamp e contexto
```

### **Retry Configurável**
```robotframework
# Retry com configurações personalizadas
Executar Com Retry    keyword=Tocar Elemento    
...    max_attempts=5    delay=1s    arg1=valor1
```

### **Informações Estruturadas**
```robotframework
&{info}=    Obter Informacoes Dispositivo
# Retorna:
# manufacturer: Samsung
# model: Galaxy S21
# brand: samsung  
# android_version: 13
# api_level: 33
# resolution: 1080x2400
# density: 420dpi
```

## 📁 **Estrutura de Arquivos Atualizada**

```
automacao-adb/
├── base.resource                    # ⭐ Arquivo central de modularização
├── tests/
│   ├── example_base_resource.robot  # ⭐ Exemplo de uso do base.resource
│   ├── adb_basic_tests.robot        # Pode ser refatorado para usar base
│   ├── yaml_locators_test.robot     # Pode ser refatorado para usar base
│   └── ...
├── resources/                       # Módulos específicos
│   ├── locators.yml
│   ├── yaml_locators.robot
│   ├── android_keywords.robot
│   └── device_config.robot
└── ...
```

## 🚀 **Execução**

```bash
# Executar exemplo do base.resource
./run_tests.sh
# Escolher opção 4

# Ou diretamente
robot --outputdir logs tests/example_base_resource.robot
```

O `base.resource` transforma o projeto em uma plataforma robusta e profissional para automação Android! 🚀📱