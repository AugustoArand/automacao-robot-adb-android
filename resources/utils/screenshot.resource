*** Settings ***
Documentation    Keywords para captura de screenshots em testes Android
...              Funcionalidades especializadas para captura de tela via ADB

# === IMPORTS DE BIBLIOTECAS ===
Library          Collections
Library          OperatingSystem
Library          Process
Library          String
Library          DateTime

# === VARIÁVEIS ===
*** Variables ***
# Configurações de captura
${SCREENSHOT_QUALITY}        100
${SCREENSHOT_FORMAT}         png
${DEVICE_SCREENSHOT_PATH}    /sdcard/temp_screenshot.png

# === KEYWORDS DE SCREENSHOT ===
*** Keywords ***
Capturar Screenshot Global
    [Documentation]    Captura screenshot com timestamp e contexto do teste
    [Arguments]        ${nome_base}=screenshot    ${contexto}=${TEST_NAME}
    
    ${timestamp}=    Get Time    epoch
    ${test_name_clean}=    Replace String    ${contexto}    ${SPACE}    _
    ${filename}=    Set Variable    ${nome_base}_${test_name_clean}_${timestamp}.${SCREENSHOT_FORMAT}
    ${filepath}=    Set Variable    ${SCREENSHOTS_DIR}${/}${filename}
    
    # Garantir que o diretório existe
    Create Directory    ${SCREENSHOTS_DIR}
    
    # Capturar via ADB
    Log    🔄 Capturando screenshot no dispositivo...
    ${result}=    Run Process    ${ADB_COMMAND}    shell    screencap    -p    ${DEVICE_SCREENSHOT_PATH}
    Should Be Equal As Integers    ${result.rc}    0    Falha ao capturar screenshot no dispositivo
    
    # Transferir screenshot do dispositivo (usando caminho absoluto)
    Log    📥 Transferindo screenshot do dispositivo...
    ${pull_result}=    Run Process    ${ADB_COMMAND}    pull    ${DEVICE_SCREENSHOT_PATH}    ${filepath}
    
    # Verificar se a transferência foi bem-sucedida
    ${transfer_success}=    Run Keyword And Return Status    
    ...    Should Be Equal As Integers    ${pull_result.rc}    0
    
    # Se falhou, tentar método alternativo
    IF    not ${transfer_success}
        Log    ⚠️ Método padrão falhou, tentando método alternativo...
        ${alt_result}=    Run Process    ${ADB_COMMAND}    pull    ${DEVICE_SCREENSHOT_PATH}    screenshots/
        Should Be Equal As Integers    ${alt_result.rc}    0    Falha ao transferir screenshot - método alternativo
        
        # Renomear arquivo se necessário
        ${temp_file}=    Set Variable    ${SCREENSHOTS_DIR}${/}temp_screenshot.png
        ${file_exists}=    Run Keyword And Return Status    File Should Exist    ${temp_file}
        IF    ${file_exists}
            Move File    ${temp_file}    ${filepath}
        END
    END
    
    # Limpar arquivo temporário do dispositivo
    Run Process    ${ADB_COMMAND}    shell    rm    ${DEVICE_SCREENSHOT_PATH}
    
    # Verificar se o arquivo final existe
    File Should Exist    ${filepath}    Screenshot não foi criado: ${filepath}
    
    Log    📸 Screenshot capturado com sucesso: ${filepath}
    Return From Keyword    ${filepath}

Capturar Screenshot Falha
    [Documentation]    Captura screenshot quando teste falha
    
    ${screenshot}=    Capturar Screenshot Global    FALHA    ${TEST_NAME}
    Log    📸 Screenshot de falha capturado: ${screenshot}
    Return From Keyword    ${screenshot}

Capturar Screenshot Com Contexto
    [Documentation]    Captura screenshot com contexto específico
    [Arguments]        ${contexto}    ${descricao}=${EMPTY}
    
    ${timestamp}=    Get Time    yyyy-MM-dd_HH-mm-ss
    ${contexto_clean}=    Replace String    ${contexto}    ${SPACE}    _
    
    ${filename}=    Run Keyword If    '${descricao}' != '${EMPTY}'
    ...    Set Variable    ${contexto_clean}_${descricao}_${timestamp}.${SCREENSHOT_FORMAT}
    ...    ELSE
    ...    Set Variable    ${contexto_clean}_${timestamp}.${SCREENSHOT_FORMAT}
    
    ${filepath}=    Set Variable    ${SCREENSHOTS_DIR}/${filename}
    
    # Capturar screenshot
    ${result}=    Run Process    ${ADB_COMMAND}    shell    screencap    -p    ${DEVICE_SCREENSHOT_PATH}
    Should Be Equal As Integers    ${result.rc}    0    Falha ao capturar screenshot
    
    ${pull_result}=    Run Process    ${ADB_COMMAND}    pull    ${DEVICE_SCREENSHOT_PATH}    ${filepath}
    Should Be Equal As Integers    ${pull_result.rc}    0    Falha ao transferir screenshot
    
    # Limpar arquivo temporário
    Run Process    ${ADB_COMMAND}    shell    rm    ${DEVICE_SCREENSHOT_PATH}
    
    Log    📸 Screenshot '${contexto}' capturado: ${filepath}
    Return From Keyword    ${filepath}

Capturar Screenshot Sequencial
    [Documentation]    Captura múltiplos screenshots em sequência
    [Arguments]        ${quantidade}=3    ${intervalo}=1s    ${nome_base}=sequencial
    
    @{screenshots}=    Create List
    
    FOR    ${i}    IN RANGE    1    ${quantidade + 1}
        ${screenshot}=    Capturar Screenshot Global    ${nome_base}_${i}    Sequencia_${i}
        Append To List    ${screenshots}    ${screenshot}
        
        Run Keyword If    ${i} < ${quantidade}
        ...    Sleep    ${intervalo}
    END
    
    Log    📸 Sequência de ${quantidade} screenshots capturada
    Return From Keyword    @{screenshots}

Capturar Screenshot Antes E Depois
    [Documentation]    Captura screenshots antes e depois de uma ação
    [Arguments]        ${keyword_acao}    ${nome_acao}    @{args}
    
    # Screenshot antes
    ${screenshot_antes}=    Capturar Screenshot Global    antes_${nome_acao}    ${TEST_NAME}
    
    # Executar ação
    ${resultado}=    Run Keyword    ${keyword_acao}    @{args}
    
    # Screenshot depois
    ${screenshot_depois}=    Capturar Screenshot Global    depois_${nome_acao}    ${TEST_NAME}
    
    Log    📸 Screenshots capturados - Antes: ${screenshot_antes}, Depois: ${screenshot_depois}
    
    &{resultado_completo}=    Create Dictionary
    ...    resultado=${resultado}
    ...    screenshot_antes=${screenshot_antes}
    ...    screenshot_depois=${screenshot_depois}
    
    Return From Keyword    &{resultado_completo}

Verificar Screenshot Capturado
    [Documentation]    Verifica se um screenshot foi capturado corretamente
    [Arguments]        ${caminho_screenshot}
    
    File Should Exist    ${caminho_screenshot}    Screenshot não foi encontrado: ${caminho_screenshot}
    
    ${file_size}=    Get File Size    ${caminho_screenshot}
    Should Be True    ${file_size} > 0    Screenshot está vazio: ${caminho_screenshot}
    
    Log    ✅ Screenshot válido: ${caminho_screenshot} (${file_size} bytes)
    Return From Keyword    ${file_size}

Limpar Screenshots Antigos
    [Documentation]    Remove screenshots antigos do diretório
    [Arguments]        ${dias_para_manter}=7
    
    ${cutoff_time}=    Get Time    epoch
    ${cutoff_time}=    Evaluate    ${cutoff_time} - (${dias_para_manter} * 24 * 60 * 60)
    
    @{files}=    List Files In Directory    ${SCREENSHOTS_DIR}    *.${SCREENSHOT_FORMAT}
    ${removed_count}=    Set Variable    0
    
    FOR    ${file}    IN    @{files}
        ${filepath}=    Set Variable    ${SCREENSHOTS_DIR}/${file}
        ${file_time}=    Get Modified Time    ${filepath}    epoch
        
        ${should_remove}=    Evaluate    ${file_time} < ${cutoff_time}
        
        IF    ${should_remove}
            Remove File    ${filepath}
            ${removed_count}=    Evaluate    ${removed_count} + 1
            Log    🗑️ Screenshot antigo removido: ${file}
        END
    END
    
    Log    🧹 Limpeza concluída: ${removed_count} screenshot(s) antigo(s) removido(s)
    Return From Keyword    ${removed_count}

Obter Informacoes Screenshot
    [Documentation]    Obtém informações detalhadas sobre um screenshot
    [Arguments]        ${caminho_screenshot}
    
    File Should Exist    ${caminho_screenshot}
    
    ${file_size}=       Get File Size    ${caminho_screenshot}
    ${modified_time}=   Get Modified Time    ${caminho_screenshot}
    ${filename}=        Get File Name    ${caminho_screenshot}
    
    &{info}=    Create Dictionary
    ...    caminho=${caminho_screenshot}
    ...    nome=${filename}
    ...    tamanho=${file_size}
    ...    data_modificacao=${modified_time}
    
    Log Dictionary    ${info}
    Return From Keyword    &{info}