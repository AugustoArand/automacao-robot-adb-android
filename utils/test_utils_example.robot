*** Settings ***
Documentation    Exemplo de uso dos utilitários de screenshot e swipe
Resource         screenshot_utils.robot
Resource         swipe_utils.robot
Library          Process

*** Test Cases ***
Teste Screenshot Utils
    [Documentation]    Testa as funcionalidades de captura de screenshot
    [Tags]    screenshot    utils
    
    # Verificar se dispositivo suporta screenshot
    Verificar Capacidade Screenshot
    
    # Capturar screenshot básico
    ${caminho1}=    Capturar Screenshot
    Log    Screenshot básico salvo em: ${caminho1}
    
    # Capturar screenshot com nome específico
    ${caminho2}=    Capturar Screenshot    teste_manual.png
    Log    Screenshot nomeado salvo em: ${caminho2}
    
    # Capturar screenshot com timestamp
    ${caminho3}=    Capturar Screenshot Com Timestamp    exemplo
    Log    Screenshot com timestamp salvo em: ${caminho3}
    
    # Capturar screenshot de teste
    ${caminho4}=    Capturar Screenshot De Teste    utils_test    inicio
    Log    Screenshot de teste salvo em: ${caminho4}
    
    # Obter informações do último screenshot
    &{info}=    Obter Informacoes Screenshot    ${caminho4}
    Log    Informações do screenshot: ${info}

Teste Swipe Utils
    [Documentation]    Testa as funcionalidades de swipe adaptativo
    [Tags]    swipe    utils
    
    # Verificar suporte a swipe
    Verificar Suporte Swipe
    
    # Obter resolução do dispositivo
    &{resolution}=    Obter Resolucao Dispositivo
    Log    Resolução: ${resolution.width}x${resolution.height}
    
    # Obter densidade da tela
    ${density}=    Obter Densidade Tela
    Log    Densidade: ${density} DPI
    
    # Capturar screenshot antes dos swipes
    Capturar Screenshot De Teste    swipe_test    antes
    
    # Teste swipe up adaptativo
    Log    Executando swipe up adaptativo...
    Swipe Up Adaptativo
    Sleep    1s
    
    # Capturar screenshot após swipe up
    Capturar Screenshot De Teste    swipe_test    apos_up
    
    # Teste swipe down adaptativo
    Log    Executando swipe down adaptativo...
    Swipe Down Adaptativo
    Sleep    1s
    
    # Capturar screenshot após swipe down
    Capturar Screenshot De Teste    swipe_test    apos_down
    
    # Teste swipe lateral direita
    Log    Executando swipe lateral direita...
    Swipe Lateral Adaptativo    right
    Sleep    1s
    
    # Teste swipe lateral esquerda
    Log    Executando swipe lateral esquerda...
    Swipe Lateral Adaptativo    left
    Sleep    1s

Teste Swipes Multiplos
    [Documentation]    Testa múltiplos swipes consecutivos
    [Tags]    swipe    multiplo    utils
    
    # Capturar screenshot inicial
    Capturar Screenshot De Teste    multiplo_test    inicial
    
    # Múltiplos swipes up
    Log    Executando 3 swipes up consecutivos...
    Swipe Up Multiplo    quantidade=3    intervalo_ms=300
    
    # Capturar screenshot após swipes up
    Capturar Screenshot De Teste    multiplo_test    apos_multiplos_up
    Sleep    2s
    
    # Múltiplos swipes down para voltar
    Log    Executando 3 swipes down consecutivos...
    Swipe Down Multiplo    quantidade=3    intervalo_ms=300
    
    # Capturar screenshot final
    Capturar Screenshot De Teste    multiplo_test    final

Teste Coordenadas Personalizadas
    [Documentation]    Testa swipes com coordenadas personalizadas
    [Tags]    swipe    personalizado    utils
    
    # Obter resolução
    &{resolution}=    Obter Resolucao Dispositivo
    
    # Testar diferentes percentuais de início e fim
    Log    Testando swipe up curto (60% → 40%)...
    Swipe Up Adaptativo    duration_ms=300    start_y_percent=60    end_y_percent=40
    Sleep    1s
    
    Log    Testando swipe up longo (90% → 10%)...
    Swipe Up Adaptativo    duration_ms=800    start_y_percent=90    end_y_percent=10
    Sleep    1s
    
    Log    Testando swipe down rápido (30% → 70%)...
    Swipe Down Adaptativo    duration_ms=200    start_y_percent=30    end_y_percent=70

*** Keywords ***
Setup Teste Utils
    [Documentation]    Configuração inicial para testes dos utils
    
    # Verificar se dispositivo está conectado
    ${result}=    Run Process    adb    devices
    Should Be Equal As Integers    ${result.rc}    0
    Should Contain    ${result.stdout}    device    msg=Nenhum dispositivo Android conectado
    
    Log    Dispositivo Android detectado e pronto para testes

Cleanup Teste Utils
    [Documentation]    Limpeza após testes dos utils
    
    # Limpar screenshots antigos se necessário
    # Limpar Screenshots Antigos    dias=1