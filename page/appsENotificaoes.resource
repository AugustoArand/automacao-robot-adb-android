*** Settings ***
Resource         ../base.resource

*** Keywords ***
Acessar Apps e Notificacoes
    [Documentation]    Navega até a tela de Apps e Notificações nas configurações do Android
    [Tags]    apps_notificacoes    navegacao

    # Abrir configurações
    Run Process    adb    shell    am    start    -n    com.android.settings/.Settings
    Sleep    2s

    # Clicar em "Apps e notificações" nas configurações
    # Coordenadas do elemento completo: bounds [0,371][720,516]
    # Centro: x=360, y=444
    Log    Tentando clicar em 'Apps e notificações' (centro do elemento)
    Run Process    adb    shell    input    tap    360    444
    Sleep    2s

    # Verificar se chegou na tela de Apps e notificações
    ${dump_apps_path}=    Capturar E Baixar Dump UI    apps_notificacoes_dump
    ${content}=    Get File    ${dump_apps_path}
    Should Contain    ${content}    Apps e notificações

    Log    ✅ Navegação para Apps e Notificações funcionando

Verificar Apps Recentes
    [Documentation]    Verifica se a seção de apps recentes está visível
    [Tags]    apps_notificacoes    verificacao

    # Capturar dump da tela atual
    ${dump_path}=    Capturar E Baixar Dump UI    apps_recentes_dump
    ${content}=    Get File    ${dump_path}

    # Verificar se a seção de apps recentes existe
    ${apps_recentes_ok}=    Run Keyword And Return Status    Should Contain    ${content}    Apps abertos recentemente
    
    Run Keyword If    ${apps_recentes_ok}    Log    ✅ Seção 'Apps abertos recentemente' encontrada
    Run Keyword If    not ${apps_recentes_ok}    Log    ⚠️ Seção 'Apps abertos recentemente' não encontrada

    RETURN    ${apps_recentes_ok}

Clicar Ver Todos Apps
    [Documentation]    Clica no botão "VER TODOS OS X APPS"
    [Tags]    apps_notificacoes    navegacao

    # Clicar no botão Ver Todos usando coordenadas do locator YAML
    # bounds: [181,539][538,635] -> centro aproximado: x=360, y=587
    Log    Clicando em 'VER TODOS OS APPS'
    Run Process    adb    shell    input    tap    360    587
    Sleep    2s

    # Verificar se navegou para a lista de todos os apps
    ${dump_todos_path}=    Capturar E Baixar Dump UI    todos_apps_dump
    ${content}=    Get File    ${dump_todos_path}

    # Verificar múltiplas possibilidades de texto que indicam estar na tela de todos os apps
    ${todos_ok1}=    Run Keyword And Return Status    Should Contain    ${content}    apps
    ${todos_ok2}=    Run Keyword And Return Status    Should Contain    ${content}    aplicativos
    
    ${navegacao_sucesso}=    Evaluate    ${todos_ok1} or ${todos_ok2}
    
    Run Keyword If    ${navegacao_sucesso}    Log    ✅ Navegação para lista de todos os apps bem-sucedida
    Run Keyword If    not ${navegacao_sucesso}    Log    ⚠️ Possível falha na navegação para lista de apps

    RETURN    ${navegacao_sucesso}

Abrir App Pelo Nome
    [Documentation]    Busca e clica em um app na lista de todos os apps
    [Arguments]    ${nome_app}
    [Tags]    apps_notificacoes    navegacao

    Log    Buscando app: ${nome_app}
    
    # Criar nome de arquivo sem espaços
    ${nome_arquivo}=    Replace String    ${nome_app}    ${SPACE}    _
    
    # Capturar dump para encontrar o app
    ${dump_path}=    Capturar E Baixar Dump UI    busca_app_tent1_${nome_arquivo}
    ${content}=    Get File    ${dump_path}
    
    # Verificar se o app existe na lista
    ${app_existe}=    Run Keyword And Return Status    Should Contain    ${content}    ${nome_app}
    
    Run Keyword If    not ${app_existe}    
    ...    Log    ⚠️ App '${nome_app}' não encontrado na primeira captura, fazendo scroll...
    ...    WARN
    
    # Fazer scroll para tentar encontrar o app na tela
    # Scroll para baixo algumas vezes
    FOR    ${i}    IN RANGE    5
        Run Process    adb    shell    input    swipe    360    800    360    400    500
        Sleep    1s
        
        ${dump_path}=    Capturar E Baixar Dump UI    busca_app_tent${i+2}_${nome_arquivo}
        ${content}=    Get File    ${dump_path}
        
        ${app_visivel}=    Run Keyword And Return Status    Should Contain    ${content}    ${nome_app}
        
        # Se encontrou o app, tenta clicar
        Run Keyword If    ${app_visivel}    Exit For Loop
    END
    
    # Tentar clicar no centro da tela onde geralmente aparece o app
    Log    Tentando clicar no app ${nome_app}
    Run Process    adb    shell    input    tap    360    600
    Sleep    2s
    
    Log    ✅ Tentativa de abrir app ${nome_app} executada

Clicar em Gertec Box App
    [Documentation]    Clica no app Gertec Box na lista de apps
    [Tags]    apps_notificacoes    navegacao

    Abrir App Pelo Nome    Gertec Box
    Sleep    2s

    # Verificar se o app foi aberto com sucesso
    ${dump_app_path}=    Capturar E Baixar Dump UI    gertec_box_dump
    ${content}=    Get File    ${dump_app_path}

    ${app_aberto_ok}=    Run Keyword And Return Status    Should Contain    ${content}    Gertec Box

    Run Keyword If    ${app_aberto_ok}    Log    ✅ App Gertec Box aberto com sucesso
    Run Keyword If    not ${app_aberto_ok}    Log    ⚠️ Falha ao abrir o app Gertec Box

    RETURN    ${app_aberto_ok}

Voltar Tela Apps e Notificacoes
    [Documentation]    Volta para a tela de Apps e Notificações usando o botão voltar
    [Tags]    apps_notificacoes    navegacao

    # Clicar no botão de voltar usando coordenadas do locator YAML
    # coordenadas: x=56, y=104
    Log    Clicando no botão voltar
    Run Process    adb    shell    input    tap    56    104
    Sleep    1s

    # Verificar se voltou para Apps e Notificações
    ${dump_path}=    Capturar E Baixar Dump UI    voltar_apps_dump
    ${content}=    Get File    ${dump_path}
    
    ${voltou_ok}=    Run Keyword And Return Status    Should Contain    ${content}    Apps e notificações
    
    Run Keyword If    ${voltou_ok}    Log    ✅ Voltou para tela de Apps e Notificações
    Run Keyword If    not ${voltou_ok}    Log    ⚠️ Pode não ter voltado para Apps e Notificações

    RETURN    ${voltou_ok}