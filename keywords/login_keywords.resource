*** Settings ***
Resource    ../resources/base.resource
Resource    ../resources/login_data.resource
Resource    ../pages/login_page.resource
Resource    ../pages/inventory_page.resource

*** Keywords ***
Dado que estou na página de login
    Abrir Saucedemo
    Campo usuário deve estar visível

Quando faço login com credenciais
    [Arguments]    ${usuario}    ${senha}
    Preencher usuário    ${usuario}
    Preencher senha    ${senha}
    Clicar em Login

Então devo ver a página de inventário
    Deve estar na página de inventário

Então devo ver mensagem de erro de login contendo
    [Arguments]    ${mensagem}
    Mensagem de erro de login deve conter    ${mensagem}

Quando faço login como usuário padrão
    Quando faço login com credenciais    ${STANDARD_USER}    ${VALID_PASSWORD}
