*** Settings ***
Resource    ../base.resource
Test Setup    Setup Teste Android
Test Teardown    Teardown Teste Android

*** Test Cases ***
Cenário 01: Acessar Tela de Apps e Notificações
    [Documentation]    Acessa a tela de Apps e Notificações nas Configurações
    [Tags]    apps_notificacoes    android    configuracoes

    Acessar Apps e Notificacoes
    Capturar Screenshot De Teste    24_28    apps_notificacoes


Cenário 02: Acessar Lista de Todos os Apps
    [Documentation]    Acessa Apps e Notificações e clica em Ver Todos os Apps
    [Tags]    apps_notificacoes    android    lista_apps

    Acessar Apps e Notificacoes
    Clicar Ver Todos Apps
    Capturar Screenshot De Teste    29    todos_apps

Cenário 03: Acessar app Agenda
    [Documentation]    Acessa Apps e Notificações, Ver Todos os Apps e abre o app Agenda
    [Tags]    apps_notificacoes    android    agenda

    Acessar Apps e Notificacoes
    Clicar Ver Todos Apps
    Clicar em Gertec Box App
    Capturar Screenshot De Teste    30    gertec_box_app