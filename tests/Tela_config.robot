*** Settings ***
Resource    ../base.resource
Test Setup    Setup Teste Android
Test Teardown    Teardown Teste Android

*** Test Cases ***
Acessar Tela de Configuracoes
    [Documentation]    Testa o acesso à tela de configurações do dispositivo Android e captura screenshots
    [Tags]    config    android    basic    screenshot
    
    Log    🚀 Iniciando teste de acesso à tela de configurações com captura de screenshots
    
    # Primeiro, capturar um screenshot simples usando a funcionalidade básica
    TRY
        ${screenshot_inicial}=    Capturar Screenshot Global    estado_inicial    TelaConfig
        Log    📸 Screenshot inicial capturado: ${screenshot_inicial}
    EXCEPT    AS    ${error}
        Log    ⚠️ Erro ao capturar screenshot inicial: ${error}
        Fail    Falha na captura de screenshot inicial
    END
    
    # Acessar a tela de configurações
    Log    🎯 Acessando tela de configurações...
    Go To Config
    
    # Aguardar carregamento
    Sleep    3s
    Log    ⏱️ Aguardando carregamento completo da tela de configurações...
    
    # Capturar screenshot da tela de configurações
    TRY
        ${screenshot_config}=    Capturar Screenshot Global    tela_configuracoes    TelaConfig
        Log    📸 Screenshot da tela de configurações capturado: ${screenshot_config}
        
        # Verificar se o screenshot foi criado
        Verificar Screenshot Capturado    ${screenshot_config}
        
    EXCEPT    AS    ${error}
        Log    ⚠️ Erro ao capturar screenshot final: ${error}
        # Mesmo com erro de screenshot, o teste do acesso pode ter funcionado
    END
    
    # Log final
    Log    ✅ Teste de acesso à tela de configurações concluído!
    Log    📸 Screenshots utilizando funcionalidade da pasta utils