*** Settings ***
Resource    ../resources/base.resource

*** Keywords ***
Deve estar na página de inventário
    Wait For Elements State    css=.inventory_list    visible
    ${url}=    Get Url
    Should Contain    ${url}    /inventory.html

Adicionar mochila ao carrinho
    Click    id=add-to-cart-sauce-labs-backpack

Adicionar bike light ao carrinho
    Click    id=add-to-cart-sauce-labs-bike-light

Ir para o carrinho
    Click    id=shopping_cart_container
