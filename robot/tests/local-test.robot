*** Settings ***
Library         SeleniumLibrary
Resource        ../resources/KeywordsFile.robot
Test Setup      Execute local test
Test Teardown   Close Session


*** Variables ***
${local_website_url}=   http://bs-local.com:45454
&{test_caps}        browser=chrome


*** Keywords ***
Execute local test
    Open Session    ${test_caps}    ${local_website_url}


*** Test Cases ***
BStack Local Test
    Add Implicit Wait
    Verify Local Page
