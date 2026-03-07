*** Settings ***
Resource    ../resources/base.resource
Resource    ../resources/checkout_data.resource

*** Keywords ***
Deve estar na página de overview do checkout
    ${url}=    Get Url
    Should Contain    ${url}    /checkout-step-two.html

Clicar em Finalizar
    Click    id=finish

Clicar em Cancelar no overview
    Click    id=cancel

Resumo de valores para um produto deve estar correto
    ${subtotal}=    Get Text    css=.summary_subtotal_label
    ${taxa}=    Get Text    css=.summary_tax_label
    ${total}=    Get Text    css=.summary_total_label
    Should Be Equal As Strings    ${subtotal}    ${ONE_ITEM_SUBTOTAL}
    Should Be Equal As Strings    ${taxa}        ${ONE_ITEM_TAX}
    Should Be Equal As Strings    ${total}      ${ONE_ITEM_TOTAL}

Resumo de valores para dois produtos deve estar correto
    ${subtotal}=    Get Text    css=.summary_subtotal_label
    ${taxa}=    Get Text    css=.summary_tax_label
    ${total}=    Get Text    css=.summary_total_label
    Should Be Equal As Strings    ${subtotal}    ${TWO_ITEMS_SUBTOTAL}
    Should Be Equal As Strings    ${taxa}        ${TWO_ITEMS_TAX}
    Should Be Equal As Strings    ${total}      ${TWO_ITEMS_TOTAL}
