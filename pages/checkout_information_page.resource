*** Settings ***
Resource    ../resources/base.resource

*** Keywords ***
Deve estar na página de informações do checkout
    ${url}=    Get Url
    Should Contain    ${url}    /checkout-step-one.html

Preencher dados do checkout
    [Arguments]    ${primeiro_nome}    ${sobrenome}    ${cep}
    Fill Text    id=first-name    ${primeiro_nome}
    Fill Text    id=last-name    ${sobrenome}
    Fill Text    id=postal-code    ${cep}

Clicar em Continuar no checkout
    Click    id=continue

Mensagem de erro no checkout deve conter
    [Arguments]    ${mensagem_esperada}
    Wait For Elements State    css=[data-test="error"]    visible
    ${mensagem_atual}=    Get Text    css=[data-test="error"]
    Should Be Equal As Strings    ${mensagem_atual}    ${mensagem_esperada}
