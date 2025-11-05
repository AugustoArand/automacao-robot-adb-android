*** Settings ***
Documentation    Arquivo base com imports, configurações globais e keywords comuns
...              Importar este arquivo em todos os testes para ter acesso a todas as funcionalidades

# === IMPORTS DE BIBLIOTECAS ===
Library          Collections
Library          OperatingSystem
Library          Process
Library          String
Library          DateTime
Library          yaml

# Bibliotecas específicas para automação Android
Library          AppiumLibrary    WITH NAME    Appium
Library          ScreenCapLibrary

# === IMPORTS DE RESOURCES ===
Resource         resources/yaml_locators.robot
Resource         utils/screenshot_utils.robot
Resource         resources/locators/gpos760/dispConectadosLocators.yml
Resource         resources/locators/gpos760/redeInternetLocators.yml
Resource         resources/locators/gpos760/appsENotificacoes.yml
Resource         page/redeEInternet.resource
Resource         page/dispConectados.resource
Resource         page/appsENotificaoes.resource

# === VARIÁVEIS GLOBAIS ===
*** Variables ***
# Configurações de ambiente
${PROJECT_ROOT}              ${CURDIR}
${RESOURCES_DIR}             ${PROJECT_ROOT}/resources
${TESTS_DIR}                 ${PROJECT_ROOT}/tests
${SCREENSHOTS_DIR}           ${PROJECT_ROOT}/screenshots
${LOGS_DIR}                  ${PROJECT_ROOT}/logs
${DUMPS_DIR}                 ${PROJECT_ROOT}/dumps

# Configurações ADB e Android
${ADB_COMMAND}               adb
${ANDROID_SETTINGS_PACKAGE}  com.android.settings
${ANDROID_SETTINGS_ACTIVITY}   .Settings

# Configurações de timeouts padrão
${SHORT_TIMEOUT}             5s
${MEDIUM_TIMEOUT}            10s
${LONG_TIMEOUT}              30s
${APP_LAUNCH_TIMEOUT}        15s

# Configurações de captura
${SCREENSHOT_QUALITY}        100
${UI_DUMP_TIMEOUT}           10s

# === KEYWORDS GLOBAIS ===
*** Keywords ***

# Realocação de keywords para a pasta Utils
Setup Ambiente Base
    [Documentation]    Configuração inicial comum para todos os testes
    
    # Criar diretórios necessários
    Create Directory    ${SCREENSHOTS_DIR}
    Create Directory    ${LOGS_DIR}
    Create Directory    ${DUMPS_DIR}
    
    # Verificar se ADB está disponível
    Verificar ADB Disponivel
    
    # Verificar se dispositivo está conectado
    Verificar Dispositivo Conectado
    
    Log    Ambiente base configurado com sucesso

Teardown Ambiente Base
    [Documentation]    Limpeza comum para todos os testes
    
    # Voltar para tela inicial do Android
    Run Keyword And Ignore Error    Voltar Para Home
    
    # Log de finalização
    Log    Teste finalizado - ambiente limpo

Setup Teste Android
    [Documentation]    Setup específico para testes Android (inclui setup base + YAML)
    
    # Setup base
    Setup Ambiente Base
    
    # Carregar configurações YAML
    Carregar Locators YAML
    
    # Detectar tipo de dispositivo
    ${device_type}=    Detectar E Configurar Dispositivo
    Set Test Variable    ${DEVICE_TYPE}    ${device_type}
    
    Log    Setup Android completo - Dispositivo: ${device_type}

Teardown Teste Android
    [Documentation]    Teardown específico para testes Android
    
    # Capturar screenshot final se o teste falhou
    Run Keyword If Test Failed    Capturar Screenshot Falha
    
    # Fechar app se estiver aberto
    Run Keyword And Ignore Error    Fechar App Configuracoes
    
    # Teardown base
    Teardown Ambiente Base

Verificar ADB Disponivel
    [Documentation]    Verifica se comando ADB está disponível
    
    ${result}=    Run Process    ${ADB_COMMAND}    version    timeout=5s
    Should Be Equal As Integers    ${result.rc}    0    ADB não está disponível no PATH
    Log    ADB disponível: ${result.stdout.split('\n')[0]}

Verificar Dispositivo Conectado
    [Documentation]    Verifica se há pelo menos um dispositivo Android conectado
    
    ${result}=    Run Process    ${ADB_COMMAND}    devices
    Should Contain    ${result.stdout}    device    
    ...    Nenhum dispositivo Android conectado. Conecte um dispositivo via USB ou inicie um emulador.
    
    # Contar dispositivos conectados
    ${lines}=    Split To Lines    ${result.stdout}
    ${device_count}=    Set Variable    0
    FOR    ${line}    IN    @{lines}
        ${has_device}=    Run Keyword And Return Status    Should Contain    ${line}    device
        ${device_count}=    Run Keyword If    ${has_device}    
        ...    Evaluate    ${device_count} + 1
        ...    ELSE    Set Variable    ${device_count}
    END
    
    Log    ${device_count} dispositivo(s) Android conectado(s)
    Set Test Variable    ${DEVICE_COUNT}    ${device_count}

Abrir App Configuracoes
    [Documentation]    Abre o aplicativo de Configurações do Android
    
    ${result}=    Run Process    ${ADB_COMMAND}    shell    am    start    -n    
    ...    ${ANDROID_SETTINGS_PACKAGE}/${ANDROID_SETTINGS_ACTIVITY}
    Should Be Equal As Integers    ${result.rc}    0    Falha ao abrir app Configurações
    
    # Aguardar app carregar
    Sleep    3s
    Log    App Configurações aberto com sucesso

Fechar App Configuracoes
    [Documentation]    Fecha o aplicativo de Configurações
    
    # Forçar fechamento do app
    Run Process    ${ADB_COMMAND}    shell    am    force-stop    ${ANDROID_SETTINGS_PACKAGE}
    Log    App Configurações fechado

Voltar Para Home
    [Documentation]    Volta para a tela inicial do Android
    
    Run Process    ${ADB_COMMAND}    shell    input    keyevent    KEYCODE_HOME
    Sleep    1s
    Log    Voltou para tela inicial

Capturar Screenshot Global
    [Documentation]    Captura screenshot com timestamp e contexto do teste
    [Arguments]        ${nome_base}=screenshot    ${contexto}=${TEST_NAME}
    
    ${timestamp}=    Get Time    epoch
    ${test_name_clean}=    Replace String    ${contexto}    ${SPACE}    _
    ${filename}=    Set Variable    ${nome_base}_${test_name_clean}_${timestamp}.png
    ${filepath}=    Set Variable    ${SCREENSHOTS_DIR}/${filename}
    
    # Capturar via ADB
    ${device_path}=    Set Variable    /sdcard/temp_screenshot.png
    Run Process    ${ADB_COMMAND}    shell    screencap    -p    ${device_path}
    Run Process    ${ADB_COMMAND}    pull    ${device_path}    ${filepath}
    Run Process    ${ADB_COMMAND}    shell    rm    ${device_path}
    
    Log    Screenshot capturado: ${filepath}
    Return From Keyword    ${filepath}

Capturar Screenshot Falha
    [Documentation]    Captura screenshot quando teste falha
    
    ${screenshot}=    Capturar Screenshot Global    FALHA    ${TEST_NAME}
    Log    Screenshot de falha capturado: ${screenshot}

Aguardar E Verificar Elemento
    [Documentation]    Aguarda elemento aparecer e verifica se existe
    [Arguments]        ${locator}    ${timeout}=${MEDIUM_TIMEOUT}    ${screenshot_on_fail}=${TRUE}
    
    ${exists}=    Run Keyword And Return Status    
    ...    Appium.Wait Until Page Contains Element    ${locator}    ${timeout}
    
    Run Keyword If    not ${exists} and ${screenshot_on_fail}
    ...    Capturar Screenshot Global    elemento_nao_encontrado
    
    Should Be True    ${exists}    Elemento não encontrado: ${locator}
    Log    Elemento encontrado: ${locator}

Executar Com Retry
    [Documentation]    Executa keyword com retry automático
    [Arguments]        ${keyword}    ${max_attempts}=3    ${delay}=2s    @{args}
    
    FOR    ${attempt}    IN RANGE    1    ${max_attempts + 1}
        ${success}=    Run Keyword And Return Status    ${keyword}    @{args}
        Run Keyword If    ${success}    Return From Keyword    ${success}
        
        Run Keyword If    ${attempt} < ${max_attempts}
        ...    Run Keywords
        ...    Log    Tentativa ${attempt} falhou, tentando novamente em ${delay}...
        ...    AND    Sleep    ${delay}
        ...    ELSE
        ...    Fail    Falha após ${max_attempts} tentativas: ${keyword}
    END

Obter Informacoes Dispositivo
    [Documentation]    Coleta informações completas do dispositivo
    
    &{device_info}=    Create Dictionary
    
    # Informações básicas
    ${manufacturer}=    Run Process    ${ADB_COMMAND}    shell    getprop    ro.product.manufacturer
    ${model}=          Run Process    ${ADB_COMMAND}    shell    getprop    ro.product.model
    ${brand}=          Run Process    ${ADB_COMMAND}    shell    getprop    ro.product.brand
    ${version}=        Run Process    ${ADB_COMMAND}    shell    getprop    ro.build.version.release
    ${api_level}=      Run Process    ${ADB_COMMAND}    shell    getprop    ro.build.version.sdk
    
    # Resolução da tela
    ${resolution_result}=    Run Process    ${ADB_COMMAND}    shell    wm    size
    ${resolution}=           Extract Resolution From Output    ${resolution_result.stdout}
    
    # Densidade da tela
    ${density_result}=    Run Process    ${ADB_COMMAND}    shell    wm    density
    ${density}=           Extract Density From Output    ${density_result.stdout}
    
    # Preencher dicionário
    Set To Dictionary    ${device_info}    
    ...    manufacturer=${manufacturer.stdout.strip()}
    ...    model=${model.stdout.strip()}
    ...    brand=${brand.stdout.strip()}
    ...    android_version=${version.stdout.strip()}
    ...    api_level=${api_level.stdout.strip()}
    ...    resolution=${resolution}
    ...    density=${density}
    
    Log Dictionary    ${device_info}
    Return From Keyword    &{device_info}

Extract Density From Output
    [Documentation]    Extrai densidade da saída do comando wm density
    [Arguments]        ${output}
    
    ${lines}=    Split To Lines    ${output}
    FOR    ${line}    IN    @{lines}
        ${has_density}=    Run Keyword And Return Status    Should Contain    ${line}    Physical density
        Continue For Loop If    not ${has_density}
        ${parts}=    Split String    ${line}    :
        ${density}=    Strip String    ${parts}[1]
        Return From Keyword    ${density}
    END
    Return From Keyword    Unknown

Criar Relatório Dispositivo
    [Documentation]    Cria relatório detalhado das informações do dispositivo
    
    ${device_info}=    Obter Informacoes Dispositivo
    ${timestamp}=      Get Time
    
    ${report_content}=    Set Variable    RELATÓRIO DO DISPOSITIVO\n========================\nData/Hora: ${timestamp}\n\nINFORMAÇÕES BÁSICAS:\n- Fabricante: ${device_info.manufacturer}\n- Modelo: ${device_info.model}\n- Marca: ${device_info.brand}\n- Versão Android: ${device_info.android_version}\n- API Level: ${device_info.api_level}\n\nTELA:\n- Resolução: ${device_info.resolution}\n- Densidade: ${device_info.density}\n\nCONFIGURAÇÃO DETECTADA:\n- Tipo: ${CURRENT_DEVICE}\n
    
    ${report_file}=    Set Variable    ${LOGS_DIR}/device_report_${device_info.model.replace(' ', '_')}.txt
    Create File    ${report_file}    ${report_content}
    
    Log    Relatório do dispositivo salvo em: ${report_file}
    Return From Keyword    ${report_file}

Log Separador
    [Documentation]    Cria separador visual nos logs
    [Arguments]        ${titulo}=
    
    ${separator}=    Set Variable    ==================================================
    Run Keyword If    '${titulo}' != ''
    ...    Log    ${separator}\n${titulo}\n${separator}
    ...    ELSE
    ...    Log    ${separator}

Validar Pré Requisitos
    [Documentation]    Valida todos os pré-requisitos antes de executar testes
    
    Log Separador    VALIDAÇÃO DE PRÉ-REQUISITOS
    
    # Verificar ADB
    Verificar ADB Disponivel
    
    # Verificar dispositivo
    Verificar Dispositivo Conectado
    
    # Verificar se consegue acessar o dispositivo
    ${result}=    Run Process    ${ADB_COMMAND}    shell    echo    test    timeout=10s
    Should Be Equal As Integers    ${result.rc}    0    Não foi possível acessar o dispositivo via ADB
    Should Be Equal    ${result.stdout.strip()}    test    Comunicação ADB não está funcionando
    
    # Verificar se tela está ligada
    ${screen_result}=    Run Process    ${ADB_COMMAND}    shell    dumpsys    power    |    grep    'Display Power'    shell=True
    Log    Estado da tela: ${screen_result.stdout}
    
    Log    ✅ Todos os pré-requisitos validados com sucesso
    Log Separador

Capturar E Baixar Dump UI
    [Documentation]    Captura dump da UI e baixa para pasta específica
    [Arguments]        ${nome_arquivo}
    
    # Gerar timestamp para arquivo único
    ${timestamp}=    Get Time    epoch
    ${nome_com_timestamp}=    Set Variable    ${nome_arquivo}_${timestamp}.xml
    
    # Paths completos
    ${device_path}=    Set Variable    /sdcard/${nome_com_timestamp}
    ${local_path}=     Set Variable    ${DUMPS_DIR}/${nome_com_timestamp}
    
    # Capturar dump no dispositivo
    Run Process    adb    shell    uiautomator    dump    ${device_path}
    
    # Baixar arquivo para pasta local
    ${result}=    Run Process    adb    pull    ${device_path}    ${local_path}
    Should Be Equal As Integers    ${result.rc}    0    Falha ao baixar dump: ${nome_arquivo}
    
    # Limpar arquivo do dispositivo
    Run Process    adb    shell    rm    ${device_path}
    
    # Verificar se arquivo foi criado localmente
    File Should Exist    ${local_path}
    Log    Dump salvo em: ${local_path}
    
    RETURN    ${local_path}

Limpar Dumps Antigos
    [Documentation]    Remove arquivos dump mais antigos que X dias
    [Arguments]        ${dias}=7
    
    ${dump_files}=    List Files In Directory    ${DUMPS_DIR}    *.xml
    ${data_limite}=    Subtract Time From Date    ${EMPTY}    ${dias} days
    
    FOR    ${arquivo}    IN    @{dump_files}
        ${caminho_completo}=    Set Variable    ${DUMPS_DIR}/${arquivo}
        ${data_arquivo}=    Get Modified Time    ${caminho_completo}
        ${e_antigo}=    Evaluate    '${data_arquivo}' < '${data_limite}'
        
        Run Keyword If    ${e_antigo}    Remove File    ${caminho_completo}
        Run Keyword If    ${e_antigo}    Log    Dump removido: ${arquivo}
    END
    
    Log    Limpeza de dumps concluída - arquivos mais antigos que ${dias} dias removidos