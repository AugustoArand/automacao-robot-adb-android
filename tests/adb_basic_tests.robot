*** Settings ***
Documentation    Testes básicos de automação Android usando ADB
Resource         ../base.resource

# Setup e Teardown automáticos para ambiente padronizado
Test Setup       Setup Ambiente Base
Test Teardown    Teardown Ambiente Base

*** Test Cases ***
TC001 - Verificar Dispositivo Conectado
    [Documentation]    Verifica se há dispositivo Android conectado via ADB
    [Tags]    smoke    adb
    
    Log Separador    VERIFICAÇÃO DE DISPOSITIVO
    
    # Usar verificação do base.resource que já inclui contagem
    Log    Dispositivos conectados: ${DEVICE_COUNT}
    Should Be True    ${DEVICE_COUNT} > 0    Nenhum dispositivo conectado
    
    ${result}=    Run Process    ${ADB_COMMAND}    devices    shell=True
    Log    Detalhes dos dispositivos: ${result.stdout}
    Should Contain    ${result.stdout}    device
    Should Not Contain    ${result.stdout}    unauthorized

TC002 - Capturar Screenshot Via ADB
    [Documentation]    Captura screenshot usando comando ADB diretamente
    [Tags]    screenshot    adb
    
    Log Separador    CAPTURA DE SCREENSHOT
    
    # Usar screenshot global do base.resource
    ${screenshot}=    Capturar Screenshot Global    adb_screenshot_teste
    
    # Verificar se screenshot foi criado
    Should Exist    ${screenshot}
    Log    ✅ Screenshot ADB salvo em: ${screenshot}

TC003 - Abrir App Configurações Via ADB
    [Documentation]    Abre o aplicativo de Configurações usando ADB
    [Tags]    navigation    adb
    
    Log Separador    ABERTURA DE APP
    
    # Usar keyword do base.resource
    Abrir App Configuracoes
    
    # Verificar se app está aberto usando base.resource
    ${result}=    Run Process    ${ADB_COMMAND}    shell    dumpsys    window    windows
    ...    |    grep    -i    settings    shell=True
    Should Contain    ${result.stdout}    settings
    Log    ✅ App Configurações aberto com sucesso

TC004 - Obter Informações do Dispositivo
    [Documentation]    Coleta informações básicas do dispositivo Android usando base.resource
    [Tags]    device_info    adb
    
    Log Separador    INFORMAÇÕES DO DISPOSITIVO
    
    # Usar keyword do base.resource que coleta tudo
    &{device_info}=    Obter Informacoes Dispositivo
    
    # Log das informações principais
    Log    📱 Fabricante: ${device_info.manufacturer}
    Log    📱 Modelo: ${device_info.model}
    Log    📱 Marca: ${device_info.brand}
    Log    🤖 Android: ${device_info.android_version}
    Log    🔧 API Level: ${device_info.api_level}
    Log    📺 Resolução: ${device_info.resolution}
    Log    📊 Densidade: ${device_info.density}
    
    # Criar relatório
    ${report_file}=    Criar Relatório Dispositivo
    Log    📄 Relatório salvo em: ${report_file}

TC005 - Navegar Configurações Com ADB
    [Documentation]    Navega pelas configurações usando comandos ADB e base.resource
    [Tags]    navigation    adb
    
    Log Separador    NAVEGAÇÃO CONFIGURAÇÕES
    
    # Usar keyword do base.resource
    Abrir App Configuracoes
    
    # Capturar screenshot inicial usando base.resource
    ${screenshot1}=    Capturar Screenshot Global    config_inicial
    
    # Fazer dump da UI para análise
    Run Process    ${ADB_COMMAND}    shell    uiautomator    dump    /sdcard/ui_dump.xml
    Run Process    ${ADB_COMMAND}    pull    /sdcard/ui_dump.xml    ${LOGS_DIR}/
    Run Process    ${ADB_COMMAND}    shell    rm    /sdcard/ui_dump.xml
    
    # Simular scroll para baixo
    Run Process    ${ADB_COMMAND}    shell    input    swipe    500    1000    500    300    1000
    Sleep    1s
    
    # Capturar screenshot após scroll
    ${screenshot2}=    Capturar Screenshot Global    config_scroll
    
    Log    ✅ Navegação básica concluída
    Log    Screenshots: ${screenshot1}, ${screenshot2}

TC006 - Teste Input Text Via ADB
    [Documentation]    Testa entrada de texto usando ADB
    [Tags]    input    adb
    
    Log Separador    TESTE DE INPUT
    
    # Abrir configurações
    Abrir App Configuracoes
    
    # Tentar abrir busca nas configurações
    Run Process    ${ADB_COMMAND}    shell    input    keyevent    KEYCODE_SEARCH
    Sleep    1s
    
    # Fallback: tocar na área de busca (coordenadas do base.resource)
    ${search_coords}=    Obter Coordenadas Tap    search_icon
    Run Process    ${ADB_COMMAND}    shell    input    tap    ${search_coords}[0]    ${search_coords}[1]
    Sleep    1s
    
    # Digitar texto de busca
    Run Process    ${ADB_COMMAND}    shell    input    text    wifi
    Sleep    2s
    
    # Capturar screenshot da busca
    ${screenshot}=    Capturar Screenshot Global    busca_wifi
    
    # Sair da busca
    Run Process    ${ADB_COMMAND}    shell    input    keyevent    KEYCODE_ESCAPE
    
    Log    ✅ Teste de input concluído - Screenshot: ${screenshot}