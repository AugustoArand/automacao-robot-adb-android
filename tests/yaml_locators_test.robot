*** Settings ***
Documentation    Teste demonstrando uso de locators YAML para automação Android
Resource         ../base.resource

# Setup e Teardown automáticos para ambiente padronizado
Test Setup       Setup Ambiente Base
Test Teardown    Teardown Ambiente Base

*** Test Cases ***
TC001 - Teste Locators YAML - Configurações
    [Documentation]    Demonstra uso dos locators YAML para navegar nas configurações
    [Tags]    yaml    locators    demo
    
    Log Separador    TESTE LOCATORS YAML
    
    # Os locators já estão carregados pelo base.resource
    Log    Dispositivo detectado como: ${DEVICE_TYPE}
    
    # Obter resolução usando base.resource
    &{device_info}=    Obter Informacoes Dispositivo
    Log    Resolução da tela: ${device_info.resolution}
    
    # Abrir app de configurações usando base.resource
    Abrir App Configuracoes
    
    # Capturar screenshot inicial usando base.resource
    ${screenshot}=    Capturar Screenshot Global    yaml_test_inicial
    
    # Testar obter textos de locators usando base.resource
    ${wifi_text}=       Obter Texto Locator    menu_items    wifi
    ${bluetooth_text}=  Obter Texto Locator    menu_items    bluetooth
    ${apps_text}=       Obter Texto Locator    menu_items    apps
    
    Log    ✅ Texto Wi-Fi para ${DEVICE_TYPE}: ${wifi_text}
    Log    ✅ Texto Bluetooth para ${DEVICE_TYPE}: ${bluetooth_text}
    Log    ✅ Texto Apps para ${DEVICE_TYPE}: ${apps_text}
    Log    📱 Screenshot salvo: ${screenshot}

TC002 - Teste Navegação Com Locators YAML
    [Documentation]    Testa navegação usando locators YAML
    [Tags]    yaml    navigation    demo
    
    Log Separador    NAVEGAÇÃO COM YAML
    
    # Abrir configurações usando base.resource
    Abrir App Configuracoes
    
    # Tentar tocar em Wi-Fi usando locators YAML
    Log    Tentando tocar em Wi-Fi...
    ${wifi_sucesso}=    Run Keyword And Return Status    Tocar Elemento YAML    menu_items    wifi
    Log    Wi-Fi tocado com sucesso: ${wifi_sucesso}
    
    Run Keyword If    ${wifi_sucesso}
    ...    Run Keywords
    ...    Sleep    2s
    ...    AND    Log    ✅ Navegou para Wi-Fi com sucesso
    ...    AND    Run Process    ${ADB_COMMAND}    shell    input    keyevent    KEYCODE_BACK
    ...    AND    Sleep    2s
    
    # Tentar tocar em Apps
    Log    Tentando tocar em Apps...
    ${apps_sucesso}=    Run Keyword And Return Status    Tocar Elemento YAML    menu_items    apps
    Log    Apps tocado com sucesso: ${apps_sucesso}
    
    Run Keyword If    ${apps_sucesso}
    ...    Run Keywords
    ...    Sleep    2s
    ...    AND    Log    ✅ Navegou para Apps com sucesso
    ...    AND    Run Process    ${ADB_COMMAND}    shell    input    keyevent    KEYCODE_BACK

TC003 - Teste Coordenadas Adaptativas
    [Documentation]    Testa sistema de coordenadas adaptativas baseado na resolução
    [Tags]    yaml    coordinates    demo
    
    Log Separador    COORDENADAS ADAPTATIVAS
    
    # Obter diferentes tipos de coordenadas usando base.resource
    ${search_coords}=    Obter Coordenadas Tap    search_icon
    ${center_coords}=    Obter Coordenadas Tap    center_tap
    
    Log    📍 Coordenadas do ícone de busca: ${search_coords}
    Log    📍 Coordenadas do centro da tela: ${center_coords}
    
    # Abrir configurações usando base.resource
    Abrir App Configuracoes
    
    # Testar tap no centro da tela
    Log    Tocando no centro da tela...
    Tocar Por Coordenadas    ${center_coords}[0]    ${center_coords}[1]
    Sleep    1s
    
    # Testar tap na área de busca
    Log    Tocando na área de busca...
    Tocar Por Coordenadas    ${search_coords}[0]    ${search_coords}[1]
    Sleep    2s
    
    # Voltar
    Run Process    ${ADB_COMMAND}    shell    input    keyevent    KEYCODE_BACK
    Log    ✅ Teste de coordenadas adaptativas concluído

TC004 - Teste Comparação Entre Fabricantes
    [Documentation]    Demonstra diferenças de locators entre fabricantes
    [Tags]    yaml    comparison    demo
    
    Log Separador    COMPARAÇÃO FABRICANTES
    
    # Os locators já estão carregados pelo base.resource
    
    # Simular diferentes tipos de dispositivos
    @{device_types}=    Create List    default    samsung    xiaomi    google    huawei
    
    FOR    ${device_type}    IN    @{device_types}
        Log    === Testando configuração: ${device_type} ===
        Set Suite Variable    ${CURRENT_DEVICE}    ${device_type}
        
        # Obter textos para cada fabricante
        ${wifi_text}=       Obter Texto Locator    menu_items    wifi
        ${security_text}=   Obter Texto Locator    menu_items    security
        ${accounts_text}=   Obter Texto Locator    menu_items    accounts
        ${system_text}=     Obter Texto Locator    menu_items    system
        
        Log    📱 ${device_type} - Wi-Fi: ${wifi_text}
        Log    🔒 ${device_type} - Segurança: ${security_text}
        Log    👤 ${device_type} - Contas: ${accounts_text}
        Log    ⚙️ ${device_type} - Sistema: ${system_text}
        Log    ====================================
    END
    Log    ✅ Comparação entre fabricantes concluída

TC005 - Teste Timeouts Configuráveis
    [Documentation]    Demonstra uso de timeouts configuráveis do YAML
    [Tags]    yaml    timeouts    demo
    
    Log Separador    TIMEOUTS CONFIGURÁVEIS
    
    # Os locators já estão carregados pelo base.resource
    
    # Obter diferentes tipos de timeout
    ${timeouts_dict}=    Get From Dictionary    ${LOCATORS}    timeouts
    ${timeout_short}=    Get From Dictionary    ${timeouts_dict}    short
    ${timeout_medium}=   Get From Dictionary    ${timeouts_dict}    medium
    ${timeout_long}=     Get From Dictionary    ${timeouts_dict}    long
    
    Log    ⏱️ Timeout curto: ${timeout_short}s
    Log    ⏱️ Timeout médio: ${timeout_medium}s
    Log    ⏱️ Timeout longo: ${timeout_long}s
    
    # Demonstrar uso prático
    Log    Aguardando com timeout curto...
    Sleep    ${timeout_short}s
    
    Log    Aguardando com timeout médio...
    Sleep    ${timeout_medium}s
    
    Log    ✅ Teste de timeouts concluído
    Sleep    ${timeout_medium}s