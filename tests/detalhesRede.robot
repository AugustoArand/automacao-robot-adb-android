*** Settings ***
Resource    ../base.resource
Test Setup    Setup Teste Android
Test Teardown    Teardown Teste Android

*** Test Cases ***
Acessar os Detalhes da Rede Conectada
    [Documentation]    Acessa os Detalhes da Rede Conectada
    [Tags]    rede_internet    android    detalhes_rede

    Acessar Rede e Internet 2-5
    Acessar Wi-Fi 14-15
    Acessar os Detalhes a Rede Conectada 17-18
    Capturar Screenshot De Teste    detalhes_rede    detalhes_final
    
    # Voltar à página anterior (Wi-Fi)
    Voltar Pagina Anterior
    Desligar Wifi
    Sleep    3s
    Capturar Screenshot De Teste    detalhes_rede    wifi_desligado

