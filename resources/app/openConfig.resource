*** Settings ***
Resource    ../../base.resource

*** Keywords ***
Abrir Configurações
    [Documentation]    Abre a tela de configurações do sistema.
    Click Element    xpath=//button[@aria-label="open settings"]
    Wait Until Element Is Visible    xpath=//h2[text()="Configurações"]    timeout=10s