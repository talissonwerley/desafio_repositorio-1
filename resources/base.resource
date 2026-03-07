*** Settings ***
Library    Browser

*** Variables ***
${URL}    https://www.saucedemo.com
${BROWSER}    chromium

*** Keywords ***
Abrir Saucedemo
    New Browser    ${BROWSER}
    New Context
    New Page    ${URL}

Fechar navegador
    Close Browser