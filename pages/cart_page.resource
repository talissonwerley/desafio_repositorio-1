*** Settings ***
Resource    ../resources/base.resource

*** Keywords ***
Deve estar na página de carrinho
    ${url}=    Get Url
    Should Contain    ${url}    /cart.html

Quantidade de itens no carrinho deve ser
    [Arguments]    ${quantidade_esperada}
    ${quantidade_atual}=    Get Element Count    css=.cart_item
    Should Be Equal As Integers    ${quantidade_atual}    ${quantidade_esperada}

Clicar em Checkout
    Click    id=checkout

Remover mochila do carrinho
    Click    id=remove-sauce-labs-backpack
