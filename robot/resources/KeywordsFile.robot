*** Settings ***
Library    SeleniumLibrary

*** Variables ***
# Leave empty for local Chrome, set to remote URL for BrowserStack/Grid
${remote_url}    ${EMPTY}

*** Keywords ***
Open Session
    [Arguments]    ${capabilities}    ${test_url}
    # Check if remote_url is set, otherwise use local browser
    ${is_remote}=    Run Keyword And Return Status    Should Not Be Empty    ${remote_url}
    Run Keyword If    ${is_remote}
    ...    Open Browser    ${test_url}    chrome    remote_url=${remote_url}    desired_capabilities=${capabilities}
    ...    ELSE
    ...    Open Browser    ${test_url}    chrome    options=add_argument("--disable-search-engine-choice-screen")

Close Session
    close browser

Add Implicit Wait
    set selenium implicit wait    5

Get the page title
    get title

Verify Local Page
    Title Should be     BrowserStack Local

Add first product to cart
    click element    xpath=//*[@id="1"]/div[4]

Verify product is added to cart
    ${product_name}    get text    xpath=//*[@id="1"]/p
    ${product_incart}    get text    css=p.title 
    element should contain    css=p.title    ${product_name}
