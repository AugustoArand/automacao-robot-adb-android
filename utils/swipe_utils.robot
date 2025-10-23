*** Settings ***
Documentation    Utilitários para gestos de swipe adaptativos baseados na resolução do dispositivo
Library          Collections
Library          String
Library          Process

*** Variables ***
# Configurações padrão de swipe (percentuais da tela)
${SWIPE_START_Y_PERCENT}     80    # Início do swipe para cima (80% da altura)
${SWIPE_END_Y_PERCENT}       20    # Fim do swipe para cima (20% da altura)
${SWIPE_CENTER_X_PERCENT}    50    # Centro horizontal (50% da largura)
${SWIPE_DURATION_MS}         500   # Duração do swipe em milissegundos

*** Keywords ***
Obter Resolucao Dispositivo
    [Documentation]    Obtém a resolução da tela do dispositivo Android via ADB
    
    # Obter informações da tela usando dumpsys
    ${result}=    Run Process    adb    shell    dumpsys    window    displays
    Should Be Equal As Integers    ${result.rc}    0    msg=Falha ao obter informações da tela
    
    # Extrair resolução da saída
    ${output}=    Set Variable    ${result.stdout}
    ${width}=    Set Variable    0
    ${height}=    Set Variable    0
    
    # Procurar por padrões de resolução
    ${lines}=    Split To Lines    ${output}
    FOR    ${line}    IN    @{lines}
        ${line_clean}=    Strip String    ${line}
        
        # Procurar por 'init=' que contém a resolução
        ${contains_init}=    Run Keyword And Return Status    Should Contain    ${line_clean}    init=
        IF    ${contains_init}
            ${resolution_part}=    Get Substring    ${line_clean}    ${line_clean.find('init=') + 5}
            ${resolution}=    Split String    ${resolution_part}    ${SPACE}
            ${dimensions}=    Set Variable    ${resolution}[0]
            ${width_height}=    Split String    ${dimensions}    x
            ${width}=    Set Variable    ${width_height}[0]
            ${height}=    Set Variable    ${width_height}[1]
            Exit For Loop
        END
    END
    
    # Fallback: usar wm size se não encontrou com dumpsys
    IF    ${width} == 0 or ${height} == 0
        ${result2}=    Run Process    adb    shell    wm    size
        Should Be Equal As Integers    ${result2.rc}    0    msg=Falha ao obter tamanho da tela
        
        ${size_output}=    Set Variable    ${result2.stdout}
        ${size_line}=    Get Lines Containing String    ${size_output}    Physical size
        ${size_parts}=    Split String    ${size_line}    :${SPACE}
        ${dimensions}=    Strip String    ${size_parts}[1]
        ${width_height}=    Split String    ${dimensions}    x
        ${width}=    Set Variable    ${width_height}[0]
        ${height}=    Set Variable    ${width_height}[1]
    END
    
    # Converter para inteiros
    ${width_int}=    Convert To Integer    ${width}
    ${height_int}=    Convert To Integer    ${height}
    
    Log    Resolução detectada: ${width_int}x${height_int}
    
    &{resolution}=    Create Dictionary    width=${width_int}    height=${height_int}
    [Return]    &{resolution}

Calcular Coordenadas Swipe
    [Documentation]    Calcula coordenadas de swipe baseadas na resolução e percentuais
    [Arguments]    ${resolution}    ${start_y_percent}=${SWIPE_START_Y_PERCENT}    ${end_y_percent}=${SWIPE_END_Y_PERCENT}    ${center_x_percent}=${SWIPE_CENTER_X_PERCENT}
    
    # Calcular coordenadas baseadas nos percentuais
    ${center_x}=    Evaluate    int(${resolution.width} * ${center_x_percent} / 100)
    ${start_y}=     Evaluate    int(${resolution.height} * ${start_y_percent} / 100)
    ${end_y}=       Evaluate    int(${resolution.height} * ${end_y_percent} / 100)
    
    &{coordinates}=    Create Dictionary
    ...    center_x=${center_x}
    ...    start_y=${start_y}
    ...    end_y=${end_y}
    
    Log    Coordenadas calculadas - X: ${center_x}, Start Y: ${start_y}, End Y: ${end_y}
    [Return]    &{coordinates}

Swipe Up Adaptativo
    [Documentation]    Executa swipe para cima adaptado à resolução do dispositivo
    [Arguments]    ${duration_ms}=${SWIPE_DURATION_MS}    ${start_y_percent}=${SWIPE_START_Y_PERCENT}    ${end_y_percent}=${SWIPE_END_Y_PERCENT}
    
    # Obter resolução do dispositivo
    &{resolution}=    Obter Resolucao Dispositivo
    
    # Calcular coordenadas do swipe
    &{coords}=    Calcular Coordenadas Swipe    ${resolution}    ${start_y_percent}    ${end_y_percent}
    
    # Executar swipe para cima
    ${result}=    Run Process    adb    shell    input    swipe    
    ...    ${coords.center_x}    ${coords.start_y}    ${coords.center_x}    ${coords.end_y}    ${duration_ms}
    
    Should Be Equal As Integers    ${result.rc}    0    msg=Falha ao executar swipe up
    Log    Swipe up executado: (${coords.center_x}, ${coords.start_y}) → (${coords.center_x}, ${coords.end_y})

Swipe Down Adaptativo
    [Documentation]    Executa swipe para baixo adaptado à resolução do dispositivo
    [Arguments]    ${duration_ms}=${SWIPE_DURATION_MS}    ${start_y_percent}=${SWIPE_END_Y_PERCENT}    ${end_y_percent}=${SWIPE_START_Y_PERCENT}
    
    # Obter resolução do dispositivo
    &{resolution}=    Obter Resolucao Dispositivo
    
    # Calcular coordenadas do swipe (invertidas para swipe down)
    &{coords}=    Calcular Coordenadas Swipe    ${resolution}    ${start_y_percent}    ${end_y_percent}
    
    # Executar swipe para baixo
    ${result}=    Run Process    adb    shell    input    swipe    
    ...    ${coords.center_x}    ${coords.start_y}    ${coords.center_x}    ${coords.end_y}    ${duration_ms}
    
    Should Be Equal As Integers    ${result.rc}    0    msg=Falha ao executar swipe down
    Log    Swipe down executado: (${coords.center_x}, ${coords.start_y}) → (${coords.center_x}, ${coords.end_y})

Swipe Up Multiplo
    [Documentation]    Executa múltiplos swipes para cima com intervalo
    [Arguments]    ${quantidade}=3    ${intervalo_ms}=500    ${duration_ms}=${SWIPE_DURATION_MS}
    
    FOR    ${i}    IN RANGE    ${quantidade}
        Swipe Up Adaptativo    ${duration_ms}
        Sleep    ${intervalo_ms}ms
        Log    Swipe ${i+1}/${quantidade} executado
    END

Swipe Down Multiplo
    [Documentation]    Executa múltiplos swipes para baixo com intervalo
    [Arguments]    ${quantidade}=3    ${intervalo_ms}=500    ${duration_ms}=${SWIPE_DURATION_MS}
    
    FOR    ${i}    IN RANGE    ${quantidade}
        Swipe Down Adaptativo    ${duration_ms}
        Sleep    ${intervalo_ms}ms
        Log    Swipe ${i+1}/${quantidade} executado
    END

Swipe Lateral Adaptativo
    [Documentation]    Executa swipe lateral (esquerda/direita) adaptado à resolução
    [Arguments]    ${direcao}=right    ${duration_ms}=${SWIPE_DURATION_MS}    ${start_x_percent}=20    ${end_x_percent}=80    ${y_percent}=50
    
    # Obter resolução do dispositivo
    &{resolution}=    Obter Resolucao Dispositivo
    
    # Calcular coordenadas
    ${y_coord}=       Evaluate    int(${resolution.height} * ${y_percent} / 100)
    ${start_x}=       Evaluate    int(${resolution.width} * ${start_x_percent} / 100)
    ${end_x}=         Evaluate    int(${resolution.width} * ${end_x_percent} / 100)
    
    # Ajustar coordenadas baseado na direção
    IF    '${direcao}' == 'left'
        ${temp}=    Set Variable    ${start_x}
        ${start_x}=    Set Variable    ${end_x}
        ${end_x}=    Set Variable    ${temp}
    END
    
    # Executar swipe lateral
    ${result}=    Run Process    adb    shell    input    swipe    
    ...    ${start_x}    ${y_coord}    ${end_x}    ${y_coord}    ${duration_ms}
    
    Should Be Equal As Integers    ${result.rc}    0    msg=Falha ao executar swipe ${direcao}
    Log    Swipe ${direcao} executado: (${start_x}, ${y_coord}) → (${end_x}, ${y_coord})

Verificar Suporte Swipe
    [Documentation]    Verifica se o dispositivo suporta comandos de input swipe
    
    ${result}=    Run Process    adb    shell    input
    Should Be Equal As Integers    ${result.rc}    0    msg=Dispositivo não suporta comandos input
    Should Contain    ${result.stdout}    swipe    msg=Comando swipe não disponível

Obter Densidade Tela
    [Documentation]    Obtém a densidade da tela do dispositivo (DPI)
    
    ${result}=    Run Process    adb    shell    wm    density
    Should Be Equal As Integers    ${result.rc}    0    msg=Falha ao obter densidade da tela
    
    ${density_line}=    Strip String    ${result.stdout}
    ${density_parts}=    Split String    ${density_line}    :${SPACE}
    ${density}=    Convert To Integer    ${density_parts}[1]
    
    Log    Densidade da tela: ${density} DPI
    [Return]    ${density}