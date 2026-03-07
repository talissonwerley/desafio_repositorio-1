*** Settings ***
Resource    ../../resources/base.resource
Resource    ../../resources/checkout_data.resource
Resource    ../../keywords/checkout_keywords.resource

Test Teardown    Fechar navegador

*** Test Cases ***
CHECKOUT-01 - Checkout de um produto com dados válidos
    [Documentation]    Cenário BDD: realizar checkout de um único produto com dados válidos.
    Dado que estou logado como usuário padrão
    Quando adiciono um produto ao carrinho
    E vou para o carrinho
    Então o carrinho deve conter 1 item
    E inicio o checkout
    Quando preencho os dados de checkout válidos
    E prossigo para o overview
    Então o resumo de valores para um produto deve estar correto
    Então o pedido deve ser finalizado com sucesso

CHECKOUT-02 - Checkout de múltiplos produtos com dados válidos
    [Documentation]    Cenário BDD: realizar checkout de dois produtos com dados válidos.
    Dado que estou logado como usuário padrão
    Quando adiciono dois produtos ao carrinho
    E vou para o carrinho
    Então o carrinho deve conter 2 itens
    E inicio o checkout
    Quando preencho os dados de checkout válidos
    E prossigo para o overview
    Então o resumo de valores para dois produtos deve estar correto
    Então o pedido deve ser finalizado com sucesso

CHECKOUT-03 - Checkout sem preencher primeiro nome
    [Documentation]    Cenário BDD: tentativa de checkout sem preencher o primeiro nome.
    Dado que estou logado como usuário padrão
    Quando adiciono um produto ao carrinho
    E vou para o carrinho
    E inicio o checkout
    Quando preencho os dados de checkout com campos vazios    ${EMPTY}    ${CHECKOUT_LAST_NAME}    ${CHECKOUT_ZIP}
    E tento prosseguir para o overview
    Então devo ver erro de obrigatoriedade no checkout contendo    ${ERROR_FIRST_NAME_REQUIRED}

CHECKOUT-04 - Checkout sem preencher sobrenome
    [Documentation]    Cenário BDD: tentativa de checkout sem preencher o sobrenome.
    Dado que estou logado como usuário padrão
    Quando adiciono um produto ao carrinho
    E vou para o carrinho
    E inicio o checkout
    Quando preencho os dados de checkout com campos vazios    ${CHECKOUT_FIRST_NAME}    ${EMPTY}    ${CHECKOUT_ZIP}
    E tento prosseguir para o overview
    Então devo ver erro de obrigatoriedade no checkout contendo    ${ERROR_LAST_NAME_REQUIRED}

CHECKOUT-05 - Checkout sem preencher CEP
    [Documentation]    Cenário BDD: tentativa de checkout sem preencher o CEP.
    Dado que estou logado como usuário padrão
    Quando adiciono um produto ao carrinho
    E vou para o carrinho
    E inicio o checkout
    Quando preencho os dados de checkout com campos vazios    ${CHECKOUT_FIRST_NAME}    ${CHECKOUT_LAST_NAME}    ${EMPTY}
    E tento prosseguir para o overview
    Então devo ver erro de obrigatoriedade no checkout contendo    ${ERROR_POSTAL_CODE_REQUIRED}

CHECKOUT-06 - Cancelar checkout na tela de overview
    [Documentation]    Cenário BDD: cancelar o fluxo de checkout na página de overview.
    Dado que estou logado como usuário padrão
    Quando adiciono um produto ao carrinho
    E vou para o carrinho
    E inicio o checkout
    Quando preencho os dados de checkout válidos
    E prossigo para o overview
    Quando cancelo o checkout no overview
