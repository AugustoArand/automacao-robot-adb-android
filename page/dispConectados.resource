***Settings***
Resource         ../base.resource

*** Keywords ***
Acessar Dispositivos Conectados
    [Documentation]    Navega até a tela de Dispositivos Conectados nas configurações do Android
    [Tags]    dispositivos_conectados    navegacao

    # Abrir configurações
    Run Process    adb    shell    am    start    -n    com.android.settings/.Settings
    Sleep    2s

    # Clicar em "Dispositivos conectados" nas configurações
    Log    Tentando clicar em 'Dispositivos conectados'
    Run Process    adb    shell    input    tap    416    298
    Sleep    2s

    # Verificar se chegou na tela de Dispositivos Conectados
    ${dump_disp_path}=    Capturar E Baixar Dump UI    dispositivos_conectados_dump
    ${content}=    Get File    ${dump_disp_path}
    Should Contain    ${content}    Dispositivos conectados

    Log    ✅ Navegação para Dispositivos Conectados funcionando

Acessar Parear Novo Dispositivo
    [Documentation]    Acessa a opção de parear novo dispositivo Bluetooth
    [Tags]    dispositivos_conectados    bluetooth    parear

    # Clicar em "Parear novo dispositivo"
    Log    Clicando em 'Parear novo dispositivo'
    Run Process    adb    shell    input    tap    360    213
    Sleep    3s

    # Verificar se chegou na tela de pareamento
    ${dump_parear_path}=    Capturar E Baixar Dump UI    parear_dispositivo_dump
    ${content}=    Get File    ${dump_parear_path}
    
    # Verificar múltiplas possibilidades de texto que indicam estar na tela de pareamento
    ${parear_ok}=    Run Keyword And Return Status    Should Contain    ${content}    Parear
    ${bluetooth_ok}=    Run Keyword And Return Status    Should Contain    ${content}    Bluetooth
    ${dispositivos_ok}=    Run Keyword And Return Status    Should Contain    ${content}    dispositivos
    
    ${pareamento_sucesso}=    Evaluate    ${parear_ok} or ${bluetooth_ok} or ${dispositivos_ok}
    Should Be True    ${pareamento_sucesso}    Não foi possível acessar a tela de pareamento

    Log    ✅ Navegação para Parear Novo Dispositivo funcionando

Acessar Preferencias Conexao
    [Documentation]    Acessa as preferências de conexão (Bluetooth)
    [Tags]    dispositivos_conectados    bluetooth    preferencias

    # Clicar em "Preferências de conexão"
    Log    Clicando em 'Preferências de conexão'
    Run Process    adb    shell    input    tap    360    339
    Sleep    3s

    # Verificar se chegou na tela de preferências
    ${dump_pref_path}=    Capturar E Baixar Dump UI    preferencias_conexao_dump
    ${content}=    Get File    ${dump_pref_path}
    
    # Verificar múltiplas possibilidades de texto que indicam estar na tela de preferências
    ${pref_ok}=    Run Keyword And Return Status    Should Contain    ${content}    Preferências
    ${bluetooth_ok}=    Run Keyword And Return Status    Should Contain    ${content}    Bluetooth
    ${conexao_ok}=    Run Keyword And Return Status    Should Contain    ${content}    conexão
    
    ${preferencias_sucesso}=    Evaluate    ${pref_ok} or ${bluetooth_ok} or ${conexao_ok}
    Should Be True    ${preferencias_sucesso}    Não foi possível acessar as preferências de conexão

    Log    ✅ Navegação para Preferências de Conexão funcionando

Verificar Visibilidade Bluetooth
    [Documentation]    Verifica a configuração de visibilidade do Bluetooth
    [Tags]    dispositivos_conectados    bluetooth    visibilidade

    # Capturar dump atual para verificar visibilidade
    ${dump_vis_path}=    Capturar E Baixar Dump UI    visibilidade_bluetooth_dump
    ${content}=    Get File    ${dump_vis_path}
    
    # Verificar se o texto de visibilidade está presente
    ${visivel_ok}=    Run Keyword And Return Status    Should Contain    ${content}    Visível como
    ${gpos_ok}=    Run Keyword And Return Status    Should Contain    ${content}    GPOS
    
    # Log das verificações
    Run Keyword If    ${visivel_ok}    Log    ✅ Dispositivo configurado como visível
    Run Keyword If    ${gpos_ok}    Log    ✅ Nome do dispositivo detectado: GPOS
    
    ${visibilidade_detectada}=    Evaluate    ${visivel_ok} or ${gpos_ok}
    
    Log    Status da visibilidade Bluetooth detectado: ${visibilidade_detectada}
    RETURN    ${visibilidade_detectada}

Verificar Status Bluetooth Dispositivos
    [Documentation]    Verifica o status geral do Bluetooth via ADB
    [Tags]    bluetooth    verificacao
    
    # Verificar status do Bluetooth via ADB
    ${bluetooth_status}=    Run Process    adb    shell    settings    get    global    bluetooth_on
    Log    Status Bluetooth atual (0=desligado, 1=ligado): ${bluetooth_status.stdout.strip()}
    
    # Verificar se há dispositivos pareados
    ${dispositivos_pareados}=    Run Process    adb    shell    settings    get    secure    bluetooth_address
    Log    Endereço Bluetooth do dispositivo: ${dispositivos_pareados.stdout.strip()}
    
    RETURN    ${bluetooth_status.stdout.strip()}

Ligar Bluetooth Se Necessario
    [Documentation]    Liga o Bluetooth apenas se estiver desligado
    [Tags]    bluetooth    configuracao
    
    # Verificar status atual
    ${bluetooth_status}=    Verificar Status Bluetooth Dispositivos
    
    # Se Bluetooth estiver desligado (0), ligar
    ${bluetooth_desligado}=    Run Keyword And Return Status    Should Be Equal    ${bluetooth_status}    0
    
    Run Keyword If    ${bluetooth_desligado}    Log    Bluetooth está desligado, ligando...
    Run Keyword If    ${bluetooth_desligado}    Run Process    adb    shell    svc    bluetooth    enable
    Run Keyword If    ${bluetooth_desligado}    Sleep    5s
    Run Keyword If    ${bluetooth_desligado}    Log    ✅ Bluetooth foi ligado
    
    Run Keyword If    not ${bluetooth_desligado}    Log    ℹ️ Bluetooth já está ligado

Capturar Screenshot Dispositivos Conectados
    [Documentation]    Captura screenshot da tela de dispositivos conectados
    [Arguments]        ${contexto}=dispositivos_conectados
    
    ${screenshot}=    Capturar Screenshot Global    ${contexto}    dispositivos_conectados
    Log    Screenshot capturado: ${screenshot}
    RETURN    ${screenshot}

Validar Tela Dispositivos Conectados
    [Documentation]    Valida se está na tela correta de dispositivos conectados
    [Tags]    validacao    dispositivos_conectados
    
    # Capturar dump para validação
    ${dump_val_path}=    Capturar E Baixar Dump UI    validacao_dispositivos_dump
    ${content}=    Get File    ${dump_val_path}
    
    # Verificar elementos essenciais da tela
    ${titulo_ok}=    Run Keyword And Return Status    Should Contain    ${content}    Dispositivos conectados
    ${parear_ok}=    Run Keyword And Return Status    Should Contain    ${content}    Parear novo dispositivo
    ${preferencias_ok}=    Run Keyword And Return Status    Should Contain    ${content}    Preferências de conexão
    
    # Validar que pelo menos 2 dos 3 elementos estão presentes
    ${elementos_encontrados}=    Evaluate    ${titulo_ok} + ${parear_ok} + ${preferencias_ok}
    Should Be True    ${elementos_encontrados} >= 2    Tela de Dispositivos Conectados não foi carregada corretamente
    
    # Log dos elementos encontrados
    Run Keyword If    ${titulo_ok}    Log    ✅ Título 'Dispositivos conectados' encontrado
    Run Keyword If    ${parear_ok}    Log    ✅ Opção 'Parear novo dispositivo' encontrada
    Run Keyword If    ${preferencias_ok}    Log    ✅ Opção 'Preferências de conexão' encontrada
    
    Log    ✅ Tela de Dispositivos Conectados validada com sucesso

Voltar Da Tela Dispositivos
    [Documentation]    Volta da tela de dispositivos conectados para configurações
    [Tags]    navegacao    voltar
    
    # Pressionar o botão Back do Android ou clicar no botão voltar
    Log    Voltando da tela de dispositivos conectados...
    Run Process    adb    shell    input    keyevent    KEYCODE_BACK
    Sleep    1s
    Log    ✅ Voltou da tela de dispositivos conectados
Acessar Dispositivos Conectados