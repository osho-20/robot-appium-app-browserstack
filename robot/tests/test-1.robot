*** Settings ***
Library         SeleniumLibrary
Resource        ../resources/KeywordsFile.robot
Resource        ../resources/TestCases.robot
Suite Setup     Initialize Environment
Suite Teardown    Cleanup Environment
Test Setup      Execute test
Test Teardown   Close Session


*** Variables ***
${website_url}=     https://bstackdemo.com
&{test_caps}        browser=chrome


*** Keywords ***
Execute test
    Open Session    ${test_caps}    ${website_url}

Initialize Environment
    Log             Setting up the environment for the test suite

Cleanup Environment
    Log    Cleaning up the environment after the test suite
    
*** Test Cases ***
BStack Sample Test 1
    [Tags]  chrome
    Add to Cart
    Capture Page Screenshot    EMBED
