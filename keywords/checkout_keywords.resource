*** Settings ***
Resource    ../resources/base.resource
Resource    ../resources/login_data.resource
Resource    ../resources/checkout_data.resource
Resource    ../pages/login_page.resource
Resource    ../pages/inventory_page.resource
Resource    ../pages/cart_page.resource
Resource    ../pages/checkout_information_page.resource
Resource    ../pages/checkout_overview_page.resource
Resource    ../pages/checkout_complete_page.resource

*** Keywords ***
Dado que estou logado como usuário padrão
    Abrir Saucedemo
    Campo usuário deve estar visível
    Preencher usuário    ${STANDARD_USER}
    Preencher senha    ${VALID_PASSWORD}
    Clicar em Login
    Deve estar na página de inventário

Quando adiciono um produto ao carrinho
    Adicionar mochila ao carrinho

Quando adiciono dois produtos ao carrinho
    Adicionar mochila ao carrinho
    Adicionar bike light ao carrinho

E vou para o carrinho
    Ir para o carrinho
    Deve estar na página de carrinho

E inicio o checkout
    Clicar em Checkout
    Deve estar na página de informações do checkout

Quando preencho os dados de checkout válidos
    Preencher dados do checkout    ${CHECKOUT_FIRST_NAME}    ${CHECKOUT_LAST_NAME}    ${CHECKOUT_ZIP}

Quando preencho os dados de checkout com campos vazios
    [Arguments]    ${primeiro_nome}    ${sobrenome}    ${cep}
    Preencher dados do checkout    ${primeiro_nome}    ${sobrenome}    ${cep}

E prossigo para o overview
    Clicar em Continuar no checkout
    Deve estar na página de overview do checkout

E tento prosseguir para o overview
    Clicar em Continuar no checkout

Então o pedido deve ser finalizado com sucesso
    Clicar em Finalizar
    Deve exibir mensagem de agradecimento

Então devo ver erro de obrigatoriedade no checkout contendo
    [Arguments]    ${mensagem}
    Mensagem de erro no checkout deve conter    ${mensagem}

Quando cancelo o checkout no overview
    Clicar em Cancelar no overview

Então o carrinho deve conter 1 item
    Quantidade de itens no carrinho deve ser    1

Então o carrinho deve conter 2 itens
    Quantidade de itens no carrinho deve ser    2

Então o resumo de valores para um produto deve estar correto
    Resumo de valores para um produto deve estar correto

Então o resumo de valores para dois produtos deve estar correto
    Resumo de valores para dois produtos deve estar correto
