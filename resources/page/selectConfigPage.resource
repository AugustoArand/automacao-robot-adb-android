*** Settings ***
Resource    ../../base.resource

*** Keywords ***
Go To Config
    [Documentation]    Acessa a tela de configurações do dispositivo Android
    
    Log    Iniciando acesso à tela de configurações
    
    # Abrir o aplicativo de configurações usando os dados do YAML
    ${result}=    Run Process    ${ADB_COMMAND}    shell    am    start    -n    
    ...    ${app}[package]/${app}[activity]
    Should Be Equal As Integers    ${result.rc}    0    Falha ao abrir aplicativo de Configurações
    
    # Aguardar o aplicativo carregar
    Sleep    ${MEDIUM_TIMEOUT}
    
    # Verificar se a tela de configurações foi aberta corretamente
    # Tentar verificar o título da tela
    ${ui_dump_result}=    Run Process    ${ADB_COMMAND}    shell    uiautomator    dump    /sdcard/ui_dump.xml
    ${pull_result}=       Run Process    ${ADB_COMMAND}    pull    /sdcard/ui_dump.xml    ${LOGS_DIR}/ui_dump.xml
    
    # Verificar se o texto "Configurações" ou "Settings" está presente
    ${ui_content}=    Get File    ${LOGS_DIR}/ui_dump.xml
    ${config_found}=    Run Keyword And Return Status    
    ...    Should Contain Any    ${ui_content}    ${main_screen}[text]    ${main_screen}[text_en]
    
    # Limpar arquivo temporário do dispositivo
    Run Process    ${ADB_COMMAND}    shell    rm    /sdcard/ui_dump.xml
    
    Run Keyword If    ${config_found}
    ...    Log    ✅ Tela de configurações acessada com sucesso
    ...    ELSE
    ...    Run Keywords
    ...    Capturar Screenshot Global    config_screen_error
    ...    AND    Fail    ❌ Não foi possível confirmar o acesso à tela de configurações
    
    Log    Tela de configurações do dispositivo Android está disponível
    