*** Settings ***
Documentation    Keywords para carregar e usar locators YAML
Library          Collections
Library          OperatingSystem
Library          yaml
Library          Process
Library          String

*** Variables ***
${LOCATORS_FILE}    ${CURDIR}/locators.yml
&{LOCATORS}         # Dicionário global para armazenar locators carregados
${CURRENT_DEVICE}   default

*** Keywords ***
Carregar Locators YAML
    [Documentation]    Carrega locators do arquivo YAML
    [Arguments]        ${arquivo_yaml}=${LOCATORS_FILE}
    
    ${yaml_exists}=    Run Keyword And Return Status    File Should Exist    ${arquivo_yaml}
    Run Keyword If    not ${yaml_exists}    Fail    Arquivo YAML não encontrado: ${arquivo_yaml}
    
    ${yaml_content}=    Get File    ${arquivo_yaml}
    ${locators_dict}=   Evaluate    yaml.safe_load($yaml_content)    modules=yaml
    Set Suite Variable    &{LOCATORS}    &{locators_dict}
    
    Log    Locators carregados com sucesso do arquivo: ${arquivo_yaml}
    RETURN    ${locators_dict}

Detectar E Configurar Dispositivo
    [Documentation]    Detecta o fabricante do dispositivo e configura locators apropriados
    
    # Obter informações do dispositivo
    ${manufacturer}=    Obter Propriedade Dispositivo    ro.product.manufacturer
    ${brand}=          Obter Propriedade Dispositivo    ro.product.brand
    
    # Determinar configuração baseada no fabricante
    ${device_type}=    Determinar Tipo Dispositivo    ${manufacturer}    ${brand}
    Set Suite Variable    ${CURRENT_DEVICE}    ${device_type}
    
    Log    Dispositivo detectado: ${manufacturer} ${brand} - Usando configuração: ${device_type}
    RETURN    ${device_type}

Determinar Tipo Dispositivo
    [Documentation]    Determina o tipo de dispositivo baseado no fabricante
    [Arguments]        ${manufacturer}    ${brand}
    
    ${manufacturer_lower}=    Convert To Lowercase    ${manufacturer}
    ${brand_lower}=          Convert To Lowercase    ${brand}
    
    ${device_type}=    Run Keyword If    'samsung' in '${manufacturer_lower}' or 'samsung' in '${brand_lower}'
    ...    Set Variable    samsung
    ...    ELSE IF    'xiaomi' in '${manufacturer_lower}' or 'xiaomi' in '${brand_lower}' or 'redmi' in '${brand_lower}'
    ...    Set Variable    xiaomi
    ...    ELSE IF    'google' in '${manufacturer_lower}' or 'google' in '${brand_lower}'
    ...    Set Variable    google
    ...    ELSE IF    'huawei' in '${manufacturer_lower}' or 'huawei' in '${brand_lower}' or 'honor' in '${brand_lower}'
    ...    Set Variable    huawei
    ...    ELSE
    ...    Set Variable    default
    
    RETURN    ${device_type}

Obter Locator Simples
    [Documentation]    Obtém locator de forma simplificada
    [Arguments]        ${secao}    ${elemento}    ${tipo}=text
    
    # Carregar locators se necessário
    ${locators_loaded}=    Run Keyword And Return Status    Variable Should Exist    &{LOCATORS}
    Run Keyword If    not ${locators_loaded}    Carregar Locators YAML
    
    # Tentar obter do dispositivo atual primeiro
    ${locator_value}=    Run Keyword And Return Status    
    ...    Get Value From Nested Dict    ${LOCATORS}    ${CURRENT_DEVICE}    ${secao}    ${elemento}    ${tipo}
    
    # Se não encontrou, usar default
    ${locator_value}=    Run Keyword If    not ${locator_value}
    ...    Get Value From Nested Dict    ${LOCATORS}    default    ${secao}    ${elemento}    ${tipo}
    ...    ELSE
    ...    Set Variable    ${locator_value}
    
    RETURN    ${locator_value}

Get Value From Nested Dict
    [Documentation]    Obtém valor de dicionário aninhado
    [Arguments]        ${dict}    ${key1}    ${key2}    ${key3}    ${key4}
    
    TRY
        ${level1}=    Get From Dictionary    ${dict}    ${key1}
        ${level2}=    Get From Dictionary    ${level1}    ${key2}
        ${level3}=    Get From Dictionary    ${level2}    ${key3}
        ${value}=     Get From Dictionary    ${level3}    ${key4}
        RETURN    ${value}
    EXCEPT
        RETURN    ${NONE}
    END

Obter Texto Locator
    [Documentation]    Obtém texto do locator para elemento
    [Arguments]        ${secao}    ${elemento}
    
    ${texto}=    Obter Locator Simples    ${secao}    ${elemento}    text
    RETURN    ${texto}

Obter Coordenadas Tap
    [Documentation]    Obtém coordenadas para tap baseadas na resolução
    [Arguments]        ${elemento}
    
    # Obter resolução
    ${resolution}=    Obter Resolucao Tela
    
    # Determinar chave de coordenadas
    ${coord_key}=    Run Keyword If    '720' in '${resolution}'
    ...    Set Variable    hd_720p
    ...    ELSE IF    '1080' in '${resolution}' or '1920' in '${resolution}'
    ...    Set Variable    fhd_1080p
    ...    ELSE IF    '1440' in '${resolution}' or '2560' in '${resolution}'
    ...    Set Variable    qhd_1440p
    ...    ELSE
    ...    Set Variable    fhd_1080p
    
    # Obter coordenadas
    ${coords}=    Get Value From Nested Dict    ${LOCATORS}    coordinates    ${coord_key}    ${elemento}    ${NONE}
    
    # Se não encontrou, usar coordenadas padrão
    ${coords}=    Run Keyword If    ${coords} is None
    ...    Create List    540    960
    ...    ELSE
    ...    Set Variable    ${coords}
    
    RETURN    ${coords}

Tocar Elemento YAML
    [Documentation]    Toca em elemento usando configuração YAML
    [Arguments]        ${secao}    ${elemento}
    
    # Tentar tocar por texto primeiro
    ${texto}=    Obter Texto Locator    ${secao}    ${elemento}
    ${sucesso}=  Run Keyword And Return Status    Tocar Por Texto Simples    ${texto}
    
    # Se falhou, usar coordenadas
    IF    not ${sucesso}
        ${coords}=    Obter Coordenadas Tap    ${elemento}
        Tocar Por Coordenadas    ${coords}[0]    ${coords}[1]
    END

Tocar Por Texto Simples
    [Documentation]    Toca em elemento procurando por texto na tela
    [Arguments]        ${texto}
    
    # Fazer dump da UI
    ${timestamp}=    Get Time    epoch
    ${dump_file}=    Set Variable    /sdcard/ui_dump_${timestamp}.xml
    
    Run Process    adb    shell    uiautomator    dump    ${dump_file}
    
    # Verificar se texto existe
    ${result}=    Run Process    adb    shell    grep    -q    ${texto}    ${dump_file}
    
    # Limpar arquivo
    Run Process    adb    shell    rm    ${dump_file}
    
    # Se encontrou, usar coordenadas aproximadas
    Run Keyword If    ${result.rc} == 0
    ...    Run Process    adb    shell    input    tap    540    960
    ...    ELSE
    ...    Fail    Texto não encontrado: ${texto}

Tocar Por Coordenadas
    [Documentation]    Toca em coordenadas específicas
    [Arguments]        ${x}    ${y}
    
    Run Process    adb    shell    input    tap    ${x}    ${y}
    Log    Tocado em coordenadas: ${x}, ${y}

Obter Propriedade Dispositivo
    [Documentation]    Obtém propriedade do dispositivo via ADB
    [Arguments]        ${propriedade}
    
    ${result}=    Run Process    adb    shell    getprop    ${propriedade}
    ${value}=     Strip String    ${result.stdout}
    RETURN       ${value}

Obter Resolucao Tela
    [Documentation]    Obtém resolução da tela do dispositivo
    
    ${result}=       Run Process    adb    shell    wm    size
    ${resolution}=   Extract Resolution From Output    ${result.stdout}
    RETURN          ${resolution}

Extract Resolution From Output
    [Documentation]    Extrai resolução da saída do comando wm size
    [Arguments]        ${output}
    
    ${lines}=    Split To Lines    ${output}
    FOR    ${line}    IN    @{lines}
        ${has_size}=    Run Keyword And Return Status    Should Contain    ${line}    Physical size
        Continue For Loop If    not ${has_size}
        ${parts}=    Split String    ${line}    :
        ${resolution}=    Strip String    ${parts}[1]
        RETURN    ${resolution}
    END
    RETURN    1080x1920