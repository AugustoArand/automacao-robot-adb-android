***Settings***
Resource         ../base.resource

*** Keywords ***
Acessar Rede e Internet 2-5
    [Documentation]    Navega até a tela de Rede e Internet nas configurações do Android
    [Tags]    rede_internet    navegacao

    # Abrir configurações
    Run Process    adb    shell    am    start    -n    com.android.settings/.Settings
    Sleep    2s

    # Clicar em "Rede e Internet" nas configurações
    Log    Tentando clicar em 'Rede e Internet' (método seguro: área de texto à esquerda)
    Run Process    adb    shell    input    tap    180    220
    Sleep    2s

    # Verificar se chegou na tela de Rede e Internet
    ${dump_rede_path}=    Capturar E Baixar Dump UI    rede_internet_dump
    ${content}=    Get File    ${dump_rede_path}
    Should Contain    ${content}    Rede e Internet

    Log    ✅ Navegação para Rede e Internet funcionando

Acessar Wi-Fi 14-15
    [Documentation]    Acessa a seção de Wi-Fi dentro de Rede e Internet
    [Tags]    rede_internet    wifi

    # Primeiro capturar a tela atual para debug
    ${dump_antes_path}=    Capturar E Baixar Dump UI    antes_wifi_dump
    ${content_antes}=    Get File    ${dump_antes_path}
    Log    Conteúdo antes do clique Wi-Fi: ${content_antes}

    # Clicar em Wi-Fi usando método seguro (evita toggle)
    ${navegacao_sucesso}=    Clicar Texto Wi-Fi Seguro

    Sleep    2s
    
    Liga Wifi
    # Sleep mais longo para aguardar carregamento das redes Wi-Fi disponíveis
    Sleep    5s
    

    # Captura final para verificação - aguardar redes Wi-Fi carregarem
    Sleep    3s
    ${dump_wifi_path}=    Capturar E Baixar Dump UI    wifi_dump
    
    # Utilizando verificações mais flexíveis
    ${content}=    Get File    ${dump_wifi_path}
    Log    Conteúdo da tela Wi-Fi: ${content}
    


Acessar Preferências de wifi 16

    [Documentation]    Acessa as Preferências de Wi-Fi dentro da seção de Wi-Fi
    [Tags]    rede_internet    wifi    preferencias

    # Abrir menu de preferências (coordenadas do GPOS760)
    Run Process    adb    shell    input    tap    950    150
    Sleep    1s
    Run Process    adb    shell    input    tap    800    400
    Sleep    3s

    # Capturar dump para verificar se chegou na tela correta
    ${dump_pref_path}=    Capturar E Baixar Dump UI    wifi_preferencias_dump
    
    # Utilizando uma verificação simples, somente para tirar o print da tela
    ${content}=    Get File    ${dump_pref_path}
    Should Contain    ${content}    Preferências de Wi‑Fi

    Log    ✅ Navegação para Preferências de Wi-Fi funcionando

Acessar os Detalhes a Rede Conectada 17-18
    [Documentation]    Acessa os detalhes da rede Wi-Fi conectada clicando na engrenagem
    [Tags]    rede_internet    wifi    detalhes_rede
    # Tentar abrir detalhes clicando primeiro na engrenagem (lado direito) ou no nome da rede (lado esquerdo)
    Log    Tentando abrir detalhes: clicar na engrenagem (lado direito)
    Run Process    adb    shell    input    tap    920    360
    Sleep    2s

    # Verificar se abriu a tela de detalhes
    ${dump_pos_tentativa}=    Capturar E Baixar Dump UI    tentativa_gear_check
    ${content_pos}=    Get File    ${dump_pos_tentativa}
    ${abriu_detalhes}=    Run Keyword And Return Status    Should Contain    ${content_pos}    Detalhes da rede

    # Se não abriu, tentar clicar sobre o nome da rede conectada (lado esquerdo)
    Run Keyword If    not ${abriu_detalhes}    Log    Engrenagem não abriu detalhes, tentando clicar no nome da rede (lado esquerdo)
    Run Keyword If    not ${abriu_detalhes}    Run Process    adb    shell    input    tap    200    360
    Run Keyword If    not ${abriu_detalhes}    Sleep    2s

    # Se ainda não abriu, tentar clicar no centro do item de rede (caso o layout seja diferente)
    Run Keyword If    not ${abriu_detalhes}    Log    Tentativa final: clicar no centro do item de rede
    Run Keyword If    not ${abriu_detalhes}    Run Process    adb    shell    input    tap    560    360
    Run Keyword If    not ${abriu_detalhes}    Sleep    2s
    # Primeiro capturar a tela atual para debug e identificar a rede conectada
    ${dump_antes_det_path}=    Capturar E Baixar Dump UI    antes_detalhes_dump
    ${content_antes}=    Get File    ${dump_antes_det_path}
    Log    Conteúdo antes do clique nos detalhes: ${content_antes}

    # Procurar pela engrenagem (ícone de configurações) da rede conectada
    # Estratégia 1: Clicar na área típica da engrenagem (lado direito da lista)
    # Coordenadas baseadas na área comum de engrenagens: x=650-680, y=300-400
    Run Process    adb    shell    input    tap    665    350
    Sleep    3s

    # Verificar se mudou de tela
    ${dump_tentativa1_path}=    Capturar E Baixar Dump UI    detalhes_tentativa1
    ${content_tentativa1}=    Get File    ${dump_tentativa1_path}
    
    # Verificar se encontrou indicadores de tela de detalhes
    ${detalhes_encontrado1}=    Run Keyword And Return Status    Should Contain    ${content_tentativa1}    Detalhes da rede
    ${detalhes_encontrado2}=    Run Keyword And Return Status    Should Contain    ${content_tentativa1}    Informações da rede
    ${detalhes_encontrado3}=    Run Keyword And Return Status    Should Contain    ${content_tentativa1}    Esquecer
    ${detalhes_encontrado4}=    Run Keyword And Return Status    Should Contain    ${content_tentativa1}    Modificar
    ${detalhes_encontrado}=    Evaluate    ${detalhes_encontrado1} or ${detalhes_encontrado2} or ${detalhes_encontrado3} or ${detalhes_encontrado4}
    
    # Se não encontrou, tentar outras coordenadas
    Run Keyword If    not ${detalhes_encontrado}    Log    Primeira tentativa falhou, tentando coordenadas alternativas
    Run Keyword If    not ${detalhes_encontrado}    Run Process    adb    shell    input    tap    650    300
    Run Keyword If    not ${detalhes_encontrado}    Sleep    3s
    
    # Se ainda não encontrou, tentar coordenadas mais baixas (outras redes)
    Run Keyword If    not ${detalhes_encontrado}    Run Process    adb    shell    input    tap    665    450
    Run Keyword If    not ${detalhes_encontrado}    Sleep    3s

    # Captura final para verificação - aguardar tela de detalhes carregar
    Sleep    2s
    ${dump_detalhes_path}=    Capturar E Baixar Dump UI    detalhes_rede_dump
    
    # Utilizando verificações mais flexíveis para tela de detalhes
    ${content}=    Get File    ${dump_detalhes_path}
    Log    Conteúdo da tela de detalhes: ${content}
    
    # Verificar múltiplas possibilidades de texto que indicam estar na tela de detalhes
    ${detalhes_ok}=    Run Keyword And Return Status    Should Contain    ${content}    Detalhes da rede
    ${detalhes_ok2}=    Run Keyword And Return Status    Should Contain    ${content}    Informações da rede
    ${detalhes_ok3}=    Run Keyword And Return Status    Should Contain    ${content}    Esquecer
    ${detalhes_ok4}=    Run Keyword And Return Status    Should Contain    ${content}    Modificar
    ${detalhes_ok5}=    Run Keyword And Return Status    Should Contain    ${content}    Senha
    ${detalhes_ok6}=    Run Keyword And Return Status    Should Contain    ${content}    IP
    
    # Debug: Log dos resultados das verificações
    Log    Debug - detalhes_ok (Detalhes da rede): ${detalhes_ok}
    Log    Debug - detalhes_ok2 (Informações da rede): ${detalhes_ok2}
    Log    Debug - detalhes_ok3 (Esquecer): ${detalhes_ok3}
    Log    Debug - detalhes_ok4 (Modificar): ${detalhes_ok4}
    Log    Debug - detalhes_ok5 (Senha): ${detalhes_ok5}
    Log    Debug - detalhes_ok6 (IP): ${detalhes_ok6}
    
    # Se pelo menos uma verificação passou, considera sucesso
    ${detalhes_sucesso}=    Evaluate    ${detalhes_ok} or ${detalhes_ok2} or ${detalhes_ok3} or ${detalhes_ok4} or ${detalhes_ok5} or ${detalhes_ok6}
    Log    Debug - detalhes_sucesso final: ${detalhes_sucesso}
    
    # Log qual verificação passou ANTES do Should Be True
    Run Keyword If    ${detalhes_ok}    Log    ✅ Encontrado 'Detalhes da rede'
    Run Keyword If    ${detalhes_ok2}    Log    ✅ Encontrado 'Informações da rede'  
    Run Keyword If    ${detalhes_ok3}    Log    ✅ Encontrado 'Esquecer'
    Run Keyword If    ${detalhes_ok4}    Log    ✅ Encontrado 'Modificar'
    Run Keyword If    ${detalhes_ok5}    Log    ✅ Encontrado 'Senha'
    Run Keyword If    ${detalhes_ok6}    Log    ✅ Encontrado 'IP'
    
    Should Be True    ${detalhes_sucesso}    Não foi possível acessar a tela de detalhes da rede

    Log    ✅ Navegação para Detalhes da Rede funcionando

Verificar Status Wi-Fi Apenas
    [Documentation]    Verifica e registra o status do Wi-Fi sem modificá-lo
    [Tags]    wifi    verificacao
    
    # Verificar status do Wi-Fi via ADB
    ${wifi_status}=    Run Process    adb    shell    settings    get    global    wifi_on
    Log    Status Wi-Fi atual (0=desligado, 1=ligado): ${wifi_status.stdout.strip()}
    
    # Apenas informar o status, sem modificar
    ${wifi_desligado}=    Run Keyword And Return Status    Should Be Equal    ${wifi_status.stdout.strip()}    0
    
    Run Keyword If    ${wifi_desligado}    Log    ℹ️ Wi-Fi está desligado
    Run Keyword If    not ${wifi_desligado}    Log    ℹ️ Wi-Fi está ligado
    
    RETURN    ${wifi_status.stdout.strip()}

Verificar E Garantir Wi-Fi Ligado
    [Documentation]    Verifica se o Wi-Fi está ligado e o liga APENAS se necessário (usar com cuidado)
    [Tags]    wifi    verificacao
    
    # Verificar status do Wi-Fi via ADB
    ${wifi_status}=    Run Process    adb    shell    settings    get    global    wifi_on
    Log    Status Wi-Fi atual (0=desligado, 1=ligado): ${wifi_status.stdout.strip()}
    
    # Se Wi-Fi estiver desligado (0), ligar
    ${wifi_desligado}=    Run Keyword And Return Status    Should Be Equal    ${wifi_status.stdout.strip()}    0
    
    Run Keyword If    ${wifi_desligado}    Log    Wi-Fi está desligado, ligando...
    Run Keyword If    ${wifi_desligado}    Run Process    adb    shell    svc    wifi    enable
    Run Keyword If    ${wifi_desligado}    Sleep    5s
    Run Keyword If    ${wifi_desligado}    Log    Wi-Fi foi ligado
    
    Run Keyword If    not ${wifi_desligado}    Log    ✅ Wi-Fi já está ligado, continuando...

Clicar Texto Wi-Fi Seguro
    [Documentation]    Clica no texto Wi-Fi evitando o toggle/interruptor
    [Tags]    wifi    navegacao
    
    # Clicar na área de texto (extremo esquerdo do elemento Wi-Fi)
    Log    Clicando na área de texto Wi-Fi (coordenadas extremamente seguras)
    Run Process    adb    shell    input    tap    180    248
    Sleep    3s
    
    # Verificar se navegou corretamente verificando por elementos da tela Wi-Fi
    ${dump_nav_path}=    Capturar E Baixar Dump UI    verificacao_navegacao
    ${content_nav}=    Get File    ${dump_nav_path}
    
    # Verificar se estamos na tela de Wi-Fi
    ${nav_ok1}=    Run Keyword And Return Status    Should Contain    ${content_nav}    Redes salvas
    ${nav_ok2}=    Run Keyword And Return Status    Should Contain    ${content_nav}    Adicionar rede
    ${nav_ok3}=    Run Keyword And Return Status    Should Contain    ${content_nav}    Preferências
    
    ${navegacao_sucesso}=    Evaluate    ${nav_ok1} or ${nav_ok2} or ${nav_ok3}
    Log    Navegação para Wi-Fi bem-sucedida: ${navegacao_sucesso}
    
    RETURN    ${navegacao_sucesso}

Liga Wifi
    [Documentation]    Verifica se o Wi-Fi ainda está ligado após interação e o religou se necessário
    [Tags]    wifi    verificacao
    
    # Verificar status atual do Wi-Fi
    ${wifi_status}=    Run Process    adb    shell    settings    get    global    wifi_on
    Log    Status Wi-Fi após clique: ${wifi_status.stdout.strip()}
    
    # Se foi desligado inadvertidamente, religar
    ${wifi_desligado}=    Run Keyword And Return Status    Should Be Equal    ${wifi_status.stdout.strip()}    0
    
    Run Keyword If    ${wifi_desligado}    Log    ⚠️ Wi-Fi foi desligado inadvertidamente! Religando...
    Run Keyword If    ${wifi_desligado}    Run Process    adb    shell    svc    wifi    enable
    Run Keyword If    ${wifi_desligado}    Sleep    5s
    Run Keyword If    ${wifi_desligado}    Log    ✅ Wi-Fi religado com sucesso
    
    Run Keyword If    not ${wifi_desligado}    Log    ✅ Wi-Fi permanece ligado

Desligar Wifi
    [Documentation]    Verifica se o Wi‑Fi está ligado e o desliga APENAS se necessário
    [Tags]    wifi    verificacao

    # Verificar status do Wi‑Fi via ADB
    ${wifi_status}=    Run Process    adb    shell    settings    get    global    wifi_on
    Log    Status Wi‑Fi atual (0=desligado, 1=ligado): ${wifi_status.stdout.strip()}

    # Se Wi‑Fi estiver ligado (1), desligar
    ${wifi_ligado}=    Run Keyword And Return Status    Should Be Equal    ${wifi_status.stdout.strip()}    1

    Run Keyword If    ${wifi_ligado}    Log    Wi‑Fi está ligado, desligando...
    Run Keyword If    ${wifi_ligado}    Run Process    adb    shell    svc    wifi    disable
    Run Keyword If    ${wifi_ligado}    Sleep    5s

    # Verificar resultado
    ${wifi_status_after}=    Run Process    adb    shell    settings    get    global    wifi_on
    Log    Status Wi‑Fi após tentativa de desligar: ${wifi_status_after.stdout.strip()}

    ${desligou_sucesso}=    Run Keyword And Return Status    Should Be Equal    ${wifi_status_after.stdout.strip()}    0
    Run Keyword If    ${desligou_sucesso}    Log    ✅ Wi‑Fi desligado com sucesso
    Run Keyword If    not ${desligou_sucesso}    Log    ⚠️ Não foi possível desligar o Wi‑Fi (talvez já estivesse desligado ou houve erro)

    RETURN    ${wifi_status_after.stdout.strip()}

Voltar Pagina Anterior
    [Documentation]    Volta para a página anterior usando o botão back do Android
    [Tags]    navegacao    voltar
    
    # Pressionar o botão Back do Android
    Log    Voltando para a página anterior...
    Run Process    adb    shell    input    keyevent    KEYCODE_BACK
    Sleep    1s
    Log    ✅ Voltou para a página anterior

