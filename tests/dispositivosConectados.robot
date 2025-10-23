*** Settings ***
Resource    ../base.resource
Test Setup    Setup Teste Android
Test Teardown    Teardown Teste Android

*** Test Cases ***
Cenário 01: Acessar Tela de Dispositivos Conectados
    [Documentation]    Acessa a tela de Dispositivos Conectados e valida elementos
    [Tags]    dispositivos_conectados    android    configuracoes

    Acessar Dispositivos Conectados
    Capturar Screenshot Dispositivos Conectados    20_disp_conectados

Cenário 02: Acessar Tela de Parear Novo Dispositivo
    [Documentation]    Verifica todas as opções disponíveis na tela
    [Tags]    dispositivos_conectados    android    opcoes

    Acessar Dispositivos Conectados
    Acessar Parear Novo Dispositivo
    Capturar Screenshot Dispositivos Conectados    21_parear_novo_disp


Cenário 03: Acessar Preferências de Conexão
    [Documentation]    Testa o acesso às preferências de conexão Bluetooth
    [Tags]    dispositivos_conectados    bluetooth    preferencias

    Acessar Dispositivos Conectados
    Acessar Preferencias Conexao
    Capturar Screenshot Dispositivos Conectados    22_23_preferencias_conexao
    
