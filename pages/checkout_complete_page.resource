*** Settings ***
Resource    ../resources/base.resource

*** Keywords ***
Deve exibir mensagem de agradecimento
    Wait For Elements State    css=[data-test="complete-header"]    visible
    ${mensagem}=    Get Text    css=[data-test="complete-header"]
    Should Contain    ${mensagem}    Thank you for your order!
