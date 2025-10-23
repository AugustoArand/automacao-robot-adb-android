*** Settings ***
Resource    ../base.resource
Test Setup    Setup Teste Android
Test Teardown    Teardown Teste Android

*** Test Cases ***
Cenário 01: Acessando Tela de Rede e Internet 2-5
    [Documentation]    Acessa Rede e Internet e Executa os Cenários 2-5
    [Tags]    rede_internet    android    configuracoes

    Acessar Rede e Internet 2-5
    Capturar Screenshot De Teste    2-5    tela_rede_internet

Cenário 02: Acessar Wi-Fi 14-15
    [Documentation]    Acessa Wi-Fi e Executa os Cenários 14-15
    [Tags]    rede_internet    android    wifi
    
    Acessar Rede e Internet 2-5
    Acessar Wi-Fi 14-15
    Capturar Screenshot De Teste    14-15    tela_wifi

Cenário 03: Acessar os Detalhes a Rede Conectada 17-18
    [Documentation]    Acessa os Detalhes da Rede Conectada e Executa os Cenários 17-18
    [Tags]    rede_internet    android    detalhes_rede

    Acessar Rede e Internet 2-5
    Acessar Wi-Fi 14-15
    Acessar os Detalhes a Rede Conectada 17-18
    Capturar Screenshot De Teste    17-18    detalhes_rede

Cenário 04: Acessar Sugestão de Melhoria
    Acessar Rede e Internet 2-5
    Acessar Wi-Fi 14-15
    Desligar Wifi
    Sleep    3s
    Capturar Screenshot De Teste    19    wifi_desligado

Cenário 05: 
   