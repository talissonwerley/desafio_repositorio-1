*** Settings ***
Resource    ../../resources/base.resource
Resource    ../../resources/login_data.resource
Resource    ../../keywords/login_keywords.resource

Test Setup    Nenhuma configuração inicial
Test Teardown    Fechar navegador

*** Keywords ***
Nenhuma configuração inicial
    No Operation

*** Test Cases ***
LOGIN-01 - Login válido com usuário padrão
    [Documentation]    Cenário BDD: login bem-sucedido com usuário standard_user.
    Dado que estou na página de login
    Quando faço login com credenciais    ${STANDARD_USER}    ${VALID_PASSWORD}
    Então devo ver a página de inventário

LOGIN-02 - Login com senha inválida
    [Documentation]    Cenário BDD: tentativa de login com senha incorreta.
    Dado que estou na página de login
    Quando faço login com credenciais    ${STANDARD_USER}    ${INVALID_PASSWORD}
    Então devo ver mensagem de erro de login contendo    ${ERROR_INVALID_CREDENTIALS}

LOGIN-03 - Login com usuário inválido
    [Documentation]    Cenário BDD: tentativa de login com usuário inexistente.
    Dado que estou na página de login
    Quando faço login com credenciais    ${INVALID_USER}    ${VALID_PASSWORD}
    Então devo ver mensagem de erro de login contendo    ${ERROR_INVALID_CREDENTIALS}

LOGIN-04 - Login com usuário bloqueado
    [Documentation]    Cenário BDD: tentativa de login com usuário bloqueado.
    Dado que estou na página de login
    Quando faço login com credenciais    ${LOCKED_OUT_USER}    ${VALID_PASSWORD}
    Então devo ver mensagem de erro de login contendo    ${ERROR_LOCKED_OUT}

LOGIN-05 - Login com campos vazios
    [Documentation]    Cenário BDD: tentativa de login sem preencher usuário e senha.
    Dado que estou na página de login
    Quando faço login com credenciais    ${EMPTY}    ${EMPTY}
    Então devo ver mensagem de erro de login contendo    ${ERROR_USERNAME_REQUIRED}