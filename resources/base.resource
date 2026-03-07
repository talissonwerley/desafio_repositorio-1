*** Settings ***
Library    Browser    run_on_failure=Capturar screenshot em falha
Library    OperatingSystem
Library    Collections

*** Variables ***
${URL}    https://www.saucedemo.com
${BROWSER}    chromium
# Viewport padrão (centralizado no New Context)
${VIEWPORT_WIDTH}    1280
${VIEWPORT_HEIGHT}    720

*** Keywords ***
Capturar screenshot em falha
    [Documentation]    Keyword executada automaticamente em falha. Salva screenshot em results/screenshots e permite embedding no log.html.
    Create Directory    ${OUTPUT_DIR}/screenshots
    Take Screenshot    ${OUTPUT_DIR}/screenshots/${TEST NAME}_FAILURE_SCREENSHOT    fullPage=True

Abrir Saucedemo
    [Documentation]    Inicializa browser, contexto com gravação de vídeo e viewport padrão. Em CI (GITHUB_ACTIONS) usa headless.
    Create Directory    ${OUTPUT_DIR}/screenshots
    Create Directory    ${OUTPUT_DIR}/videos
    ${ci}=    Get Environment Variable    GITHUB_ACTIONS    default=
    ${headless}=    Set Variable If    '${ci}' == 'true'    ${True}    ${False}
    New Browser    ${BROWSER}    headless=${headless}
    ${video_dir}=    Set Variable    ${OUTPUT_DIR}/videos
    &{record_video}=    Create Dictionary    dir=${video_dir}
    &{viewport}=    Create Dictionary    width=${VIEWPORT_WIDTH}    height=${VIEWPORT_HEIGHT}
    New Context    viewport=${viewport}    recordVideo=${record_video}
    New Page    ${URL}

Fechar navegador
    Close Browser
