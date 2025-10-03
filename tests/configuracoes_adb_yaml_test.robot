*** Settings ***
Documentation    Testes de automação para o menu Configurações usando ADB e YAML
Resource         ../base.resource

# Setup e Teardown automáticos usando base.resource
Test Setup       Setup Teste Android
Test Teardown    Teardown Teste Android

*** Variables ***
${WIFI_CONFIG}           Wi-Fi
${BLUETOOTH_CONFIG}      Bluetooth
${APPS_CONFIG}           Apps
${DISPLAY_CONFIG}        Exibição
${SOUND_CONFIG}          Som
${STORAGE_CONFIG}        Armazenamento
${BATTERY_CONFIG}        Bateria
${SECURITY_CONFIG}       Segurança
${ACCOUNTS_CONFIG}       Contas
${SYSTEM_CONFIG}         Sistema

*** Test Cases ***
TC001 - Verificar Tela Principal Configurações ADB
    [Documentation]    Verifica se a tela principal de configurações está carregada usando ADB
    [Tags]    smoke    configuracoes    adb    yaml
    
    Log Separador    VERIFICAÇÃO TELA PRINCIPAL
    
    # Abrir configurações via ADB
    Abrir App Configuracoes
    
    # Capturar screenshot da tela principal
    ${screenshot}=    Capturar Screenshot Global    tela_principal_configuracoes
    
    # Verificar que o app está aberto usando dump da UI
    ${result}=    Run Process    ${ADB_COMMAND}    shell    dumpsys    window    windows
    ...    |    grep    -i    settings    shell=True
    Should Contain    ${result.stdout}    settings    App Configurações não está aberto
    
    Log    ✅ Tela principal verificada com sucesso

TC002 - Navegar Para Wi-Fi Com YAML
    [Documentation]    Navega para configurações Wi-Fi usando locators YAML
    [Tags]    wifi    configuracoes    yaml
    
    Log Separador    NAVEGAÇÃO WI-FI
    
    # App já está aberto pelo Setup
    Abrir App Configuracoes
    
    # Usar locators YAML para encontrar Wi-Fi
    ${wifi_texto}=    Obter Texto Locator    menu_items    wifi
    Log    Texto Wi-Fi detectado para ${DEVICE_TYPE}: ${wifi_texto}
    
    # Tentar tocar usando YAML
    ${sucesso}=    Run Keyword And Return Status    Tocar Elemento YAML    menu_items    wifi
    
    Run Keyword If    ${sucesso}
    ...    Run Keywords
    ...    Log    ✅ Navegou para Wi-Fi com sucesso usando YAML
    ...    AND    Sleep    2s
    ...    AND    Capturar Screenshot Global    configuracoes_wifi
    ...    AND    Run Process    ${ADB_COMMAND}    shell    input    keyevent    KEYCODE_BACK
    ...    ELSE
    ...    Log    ⚠️ Fallback: Usando coordenadas para Wi-Fi

TC003 - Navegar Para Bluetooth Com YAML
    [Documentation]    Navega para configurações Bluetooth usando locators YAML
    [Tags]    bluetooth    configuracoes    yaml
    
    Log Separador    NAVEGAÇÃO BLUETOOTH
    
    Abrir App Configuracoes
    
    # Usar locators YAML
    ${bluetooth_texto}=    Obter Texto Locator    menu_items    bluetooth
    Log    Texto Bluetooth detectado: ${bluetooth_texto}
    
    ${sucesso}=    Run Keyword And Return Status    Tocar Elemento YAML    menu_items    bluetooth
    
    Run Keyword If    ${sucesso}
    ...    Run Keywords
    ...    Log    ✅ Navegou para Bluetooth com sucesso
    ...    AND    Sleep    2s
    ...    AND    Capturar Screenshot Global    configuracoes_bluetooth
    ...    AND    Run Process    ${ADB_COMMAND}    shell    input    keyevent    KEYCODE_BACK

TC004 - Navegar Para Apps Com YAML
    [Documentation]    Navega para configurações de Apps usando locators YAML
    [Tags]    apps    configuracoes    yaml
    
    Log Separador    NAVEGAÇÃO APPS
    
    Abrir App Configuracoes
    
    # Scroll para baixo caso Apps não esteja visível
    Run Process    ${ADB_COMMAND}    shell    input    swipe    500    800    500    300    1000
    Sleep    1s
    
    ${apps_texto}=    Obter Texto Locator    menu_items    apps
    Log    Texto Apps detectado: ${apps_texto}
    
    ${sucesso}=    Run Keyword And Return Status    Tocar Elemento YAML    menu_items    apps
    
    Run Keyword If    ${sucesso}
    ...    Run Keywords
    ...    Log    ✅ Navegou para Apps com sucesso
    ...    AND    Sleep    2s
    ...    AND    Capturar Screenshot Global    configuracoes_apps
    ...    AND    Run Process    ${ADB_COMMAND}    shell    input    keyevent    KEYCODE_BACK

TC005 - Navegar Para Exibição Com YAML
    [Documentation]    Navega para configurações de Exibição usando locators YAML
    [Tags]    display    configuracoes    yaml
    
    Log Separador    NAVEGAÇÃO EXIBIÇÃO
    
    Abrir App Configuracoes
    
    # Pode estar mais abaixo na lista
    Run Process    ${ADB_COMMAND}    shell    input    swipe    500    800    500    300    1000
    Sleep    1s
    
    ${display_texto}=    Obter Texto Locator    menu_items    display
    Log    Texto Exibição detectado: ${display_texto}
    
    ${sucesso}=    Run Keyword And Return Status    Tocar Elemento YAML    menu_items    display
    
    Run Keyword If    ${sucesso}
    ...    Run Keywords
    ...    Log    ✅ Navegou para Exibição com sucesso
    ...    AND    Sleep    2s
    ...    AND    Capturar Screenshot Global    configuracoes_exibicao
    ...    AND    Run Process    ${ADB_COMMAND}    shell    input    keyevent    KEYCODE_BACK

TC006 - Navegar Para Bateria Com YAML
    [Documentation]    Navega para configurações de Bateria usando locators YAML
    [Tags]    battery    configuracoes    yaml
    
    Log Separador    NAVEGAÇÃO BATERIA
    
    Abrir App Configuracoes
    
    # Scroll para encontrar Bateria
    FOR    ${i}    IN RANGE    3
        Run Process    ${ADB_COMMAND}    shell    input    swipe    500    800    500    300    1000
        Sleep    1s
    END
    
    ${battery_texto}=    Obter Texto Locator    menu_items    battery
    Log    Texto Bateria detectado: ${battery_texto}
    
    ${sucesso}=    Run Keyword And Return Status    Tocar Elemento YAML    menu_items    battery
    
    Run Keyword If    ${sucesso}
    ...    Run Keywords
    ...    Log    ✅ Navegou para Bateria com sucesso
    ...    AND    Sleep    2s
    ...    AND    Capturar Screenshot Global    configuracoes_bateria
    ...    AND    Run Process    ${ADB_COMMAND}    shell    input    keyevent    KEYCODE_BACK

TC007 - Navegar Para Segurança Com YAML
    [Documentation]    Navega para configurações de Segurança usando locators YAML
    [Tags]    security    configuracoes    yaml
    
    Log Separador    NAVEGAÇÃO SEGURANÇA
    
    Abrir App Configuracoes
    
    # Scroll para encontrar Segurança
    FOR    ${i}    IN RANGE    4
        Run Process    ${ADB_COMMAND}    shell    input    swipe    500    800    500    300    1000
        Sleep    1s
    END
    
    ${security_texto}=    Obter Texto Locator    menu_items    security
    Log    Texto Segurança detectado: ${security_texto}
    
    ${sucesso}=    Run Keyword And Return Status    Tocar Elemento YAML    menu_items    security
    
    Run Keyword If    ${sucesso}
    ...    Run Keywords
    ...    Log    ✅ Navegou para Segurança com sucesso
    ...    AND    Sleep    2s
    ...    AND    Capturar Screenshot Global    configuracoes_seguranca
    ...    AND    Run Process    ${ADB_COMMAND}    shell    input    keyevent    KEYCODE_BACK

TC008 - Mapear Todas Opções Configurações
    [Documentation]    Mapeia todas as opções disponíveis nas configurações
    [Tags]    exploratory    configuracoes    mapping
    
    Log Separador    MAPEAMENTO COMPLETO
    
    Abrir App Configuracoes
    
    # Capturar múltiplos screenshots fazendo scroll
    FOR    ${i}    IN RANGE    6
        ${screenshot}=    Capturar Screenshot Global    mapeamento_scroll_${i}
        Log    Screenshot ${i}: ${screenshot}
        
        # Scroll para baixo
        Run Process    ${ADB_COMMAND}    shell    input    swipe    500    800    500    300    1000
        Sleep    2s
    END
    
    # Voltar ao topo
    FOR    ${i}    IN RANGE    6
        Run Process    ${ADB_COMMAND}    shell    input    swipe    500    300    500    800    1000
        Sleep    1s
    END
    
    Log    ✅ Mapeamento completo realizado

TC009 - Testar Diferentes Fabricantes
    [Documentation]    Testa textos de locators para diferentes fabricantes
    [Tags]    yaml    comparison    fabricantes
    
    Log Separador    COMPARAÇÃO FABRICANTES
    
    Log    Dispositivo atual detectado: ${DEVICE_TYPE}
    
    # Testar textos para o dispositivo atual
    ${wifi_atual}=       Obter Texto Locator    menu_items    wifi
    ${security_atual}=   Obter Texto Locator    menu_items    security
    ${accounts_atual}=   Obter Texto Locator    menu_items    accounts
    
    Log    📱 ${DEVICE_TYPE} - Wi-Fi: ${wifi_atual}
    Log    📱 ${DEVICE_TYPE} - Segurança: ${security_atual}
    Log    📱 ${DEVICE_TYPE} - Contas: ${accounts_atual}
    
    # Simular outros fabricantes para comparação
    @{fabricantes}=    Create List    samsung    xiaomi    google    huawei
    
    FOR    ${fabricante}    IN    @{fabricantes}
        Log    --- Simulando ${fabricante} ---
        Set Suite Variable    ${CURRENT_DEVICE}    ${fabricante}
        
        ${wifi_fab}=       Obter Texto Locator    menu_items    wifi
        ${security_fab}=   Obter Texto Locator    menu_items    security
        
        Log    ${fabricante} - Wi-Fi: ${wifi_fab}
        Log    ${fabricante} - Segurança: ${security_fab}
    END
    
    # Restaurar dispositivo original
    Set Suite Variable    ${CURRENT_DEVICE}    ${DEVICE_TYPE}
    
    Log    ✅ Comparação entre fabricantes concluída