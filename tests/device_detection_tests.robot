*** Settings ***
Documentation    Testes para detectar tipo de dispositivo e ajustar configurações
Resource         ../base.resource

# Setup e Teardown automáticos para ambiente padronizado
Test Setup       Setup Ambiente Base
Test Teardown    Teardown Ambiente Base

*** Test Cases ***
TC001 - Detectar Informações do Dispositivo
    [Documentation]    Detecta fabricante, modelo e versão do Android para ajustar testes
    [Tags]    device_detection    setup
    
    Log Separador    DETECÇÃO DE DISPOSITIVO
    
    # Usar base.resource que já coleta todas as informações
    &{device_info}=    Obter Informacoes Dispositivo
    
    # Criar relatório completo usando base.resource
    ${report_file}=    Criar Relatório Dispositivo
    
    # Log das informações principais
    Log    📱 Fabricante: ${device_info.manufacturer}
    Log    📱 Modelo: ${device_info.model}
    Log    📱 Marca: ${device_info.brand}
    Log    🤖 Android: ${device_info.android_version}
    Log    🔧 API Level: ${device_info.api_level}
    Log    📺 Resolução: ${device_info.resolution}
    Log    📊 Densidade: ${device_info.density}
    Log    📄 Relatório salvo em: ${report_file}
    Log    🎯 Configurações detectadas: ${DEVICE_TYPE}

TC002 - Capturar Layout Configurações
    [Documentation]    Captura o layout da tela de configurações para análise
    [Tags]    layout_analysis    screenshot
    
    Log Separador    ANÁLISE DE LAYOUT
    
    # Abrir configurações usando base.resource
    Abrir App Configuracoes
    
    # Capturar UI dump usando base.resource
    ${timestamp}=    Get Time    epoch
    ${ui_dump_file}=    Set Variable    ${LOGS_DIR}/ui_dump_${timestamp}.xml
    Run Process    ${ADB_COMMAND}    shell    uiautomator    dump    /sdcard/ui_dump.xml
    Run Process    ${ADB_COMMAND}    pull    /sdcard/ui_dump.xml    ${ui_dump_file}
    Run Process    ${ADB_COMMAND}    shell    rm    /sdcard/ui_dump.xml
    
    # Capturar screenshot usando base.resource
    ${screenshot}=    Capturar Screenshot Global    layout_analysis
    
    # Analisar elementos encontrados
    ${ui_content}=    Get File    ${ui_dump_file}
    ${element_count}=    Get Regexp Matches    ${ui_content}    <node
    ${elements_found}=    Get Length    ${element_count}
    
    Log    📊 Elementos UI encontrados: ${elements_found}
    Log    📄 UI dump salvo em: ${ui_dump_file}
    Log    📸 Screenshot salvo em: ${screenshot}

TC003 - Testar Navegação Adaptativa
    [Documentation]    Testa navegação usando configurações detectadas do dispositivo
    [Tags]    adaptive_navigation    screenshot
    
    Log Separador    NAVEGAÇÃO ADAPTATIVA
    
    # As configurações já estão carregadas pelo base.resource
    Log    Configuração detectada: ${DEVICE_TYPE}
    
    # Abrir configurações usando base.resource
    Abrir App Configuracoes
    
    # Testar navegação usando locators YAML do base.resource
    ${wifi_sucesso}=    Run Keyword And Return Status    Tocar Elemento YAML    menu_items    wifi
    Run Keyword If    ${wifi_sucesso}
    ...    Run Keywords
    ...    Log    ✅ Wi-Fi encontrado e tocado usando YAML
    ...    AND    Sleep    2s
    ...    AND    Capturar Screenshot Global    wifi_adaptive
    ...    AND    Run Process    ${ADB_COMMAND}    shell    input    keyevent    KEYCODE_BACK
    ...    AND    Sleep    1s
    ...    ELSE
    ...    Log    ❌ Wi-Fi não encontrado com configuração ${DEVICE_TYPE}
    
    # Testar outras opções
    ${bluetooth_sucesso}=    Run Keyword And Return Status    Tocar Elemento YAML    menu_items    bluetooth
    Run Keyword If    ${bluetooth_sucesso}
    ...    Run Keywords
    ...    Log    ✅ Bluetooth encontrado usando YAML
    ...    AND    Sleep    1s
    ...    AND    Run Process    ${ADB_COMMAND}    shell    input    keyevent    KEYCODE_BACK
    ...    ELSE
    ...    Log    ❌ Bluetooth não encontrado
    
    Log    ✅ Teste de navegação adaptativa concluído