*** Settings ***
Resource    ../resources/base.resource

*** Keywords ***
Campo usuário deve estar visível
    Wait For Elements State    id=user-name    visible

Preencher usuário
    [Arguments]    ${usuario}
    Fill Text    id=user-name    ${usuario}

Preencher senha
    [Arguments]    ${senha}
    Fill Text    id=password    ${senha}

Clicar em Login
    Click    id=login-button

Mensagem de erro de login deve conter
    [Arguments]    ${mensagem_esperada}
    Wait For Elements State    css=[data-test="error"]    visible
    ${mensagem_atual}=    Get Text    css=[data-test="error"]
    Should Be Equal As Strings    ${mensagem_atual}    ${mensagem_esperada}
