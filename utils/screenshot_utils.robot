*** Settings ***
Documentation    Utilitários para captura de screenshots usando comandos ADB
Library          Collections
Library          DateTime
Library          OperatingSystem
Library          Process

*** Variables ***
${SCREENSHOT_DIR}    ${CURDIR}/../screenshots
${DEVICE_SCREENSHOT_PATH}    /sdcard/screenshot_temp.png

*** Keywords ***
Capturar Screenshot
    [Documentation]    Captura screenshot do dispositivo Android via ADB
    [Arguments]    ${nome_arquivo}=${EMPTY}
    
    # Gerar nome do arquivo se não fornecido
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    ${nome_final}=    Set Variable If    '${nome_arquivo}' == '${EMPTY}'    screenshot_${timestamp}.png    ${nome_arquivo}
    
    # Garantir que a pasta screenshots existe
    Create Directory    ${SCREENSHOT_DIR}
    
    # Capturar screenshot no dispositivo
    ${result}=    Run Process    adb    shell    screencap    -p    ${DEVICE_SCREENSHOT_PATH}
    Should Be Equal As Integers    ${result.rc}    0    msg=Falha ao capturar screenshot no dispositivo
    
    # Aguardar screenshot ser salvo
    Sleep    0.5s
    
    # Fazer download do screenshot
    ${local_path}=    Set Variable    ${SCREENSHOT_DIR}/${nome_final}
    ${result}=    Run Process    adb    pull    ${DEVICE_SCREENSHOT_PATH}    ${local_path}
    Should Be Equal As Integers    ${result.rc}    0    msg=Falha ao fazer download do screenshot
    
    # Limpar arquivo temporário do dispositivo
    Run Process    adb    shell    rm    ${DEVICE_SCREENSHOT_PATH}
    
    # Verificar se arquivo foi criado
    File Should Exist    ${local_path}
    Log    Screenshot salvo em: ${local_path}
    
    RETURN    ${local_path}

Capturar Screenshot Com Timestamp
    [Documentation]    Captura screenshot com timestamp no nome do arquivo
    [Arguments]    ${prefixo}=screenshot
    
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S_%f
    ${nome_arquivo}=    Set Variable    ${prefixo}_${timestamp}.png
    ${caminho}=    Capturar Screenshot    ${nome_arquivo}
    
    RETURN    ${caminho}

Capturar Screenshot De Teste
    [Documentation]    Captura screenshot específico para testes com nome padronizado
    [Arguments]    ${nome_teste}    ${passo}=${EMPTY}
    
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    ${sufixo}=    Set Variable If    '${passo}' != '${EMPTY}'    _${passo}    ${EMPTY}
    ${nome_arquivo}=    Set Variable    ${nome_teste}${sufixo}_${timestamp}.png
    ${caminho}=    Capturar Screenshot    ${nome_arquivo}
    
    RETURN    ${caminho}

Verificar Capacidade Screenshot
    [Documentation]    Verifica se o dispositivo suporta captura de screenshot
    
    ${result}=    Run Process    adb    shell    screencap    --help
    Should Be Equal As Integers    ${result.rc}    0    msg=Dispositivo não suporta comando screencap

Limpar Screenshots Antigos
    [Documentation]    Remove screenshots mais antigos que X dias
    [Arguments]    ${dias}=7
    
    ${screenshot_files}=    List Files In Directory    ${SCREENSHOT_DIR}    *.png
    ${data_limite}=    Subtract Time From Date    ${EMPTY}    ${dias} days
    
    FOR    ${arquivo}    IN    @{screenshot_files}
        ${caminho_completo}=    Set Variable    ${SCREENSHOT_DIR}/${arquivo}
        ${data_arquivo}=    Get Modified Time    ${caminho_completo}
        ${e_antigo}=    Evaluate    '${data_arquivo}' < '${data_limite}'
        
        Run Keyword If    ${e_antigo}    Remove File    ${caminho_completo}
        Run Keyword If    ${e_antigo}    Log    Arquivo removido: ${arquivo}
    END

Obter Informacoes Screenshot
    [Documentation]    Retorna informações sobre o último screenshot capturado
    [Arguments]    ${caminho_screenshot}
    
    File Should Exist    ${caminho_screenshot}
    ${tamanho}=    Get File Size    ${caminho_screenshot}
    ${data_modificacao}=    Get Modified Time    ${caminho_screenshot}
    
    &{info}=    Create Dictionary
    ...    caminho=${caminho_screenshot}
    ...    tamanho_bytes=${tamanho}
    ...    data_modificacao=${data_modificacao}
    
    RETURN    &{info}