*** Settings ***
Library         SeleniumLibrary
Resource        ../resources/KeywordsFile.robot
Resource        ../resources/TestCases.robot
Suite Setup     Initialize Environment
Suite Teardown    Cleanup Environment
Test Setup      Start Test
Test Teardown   Close Test

*** Keywords ***
Initialize Environment
    Log             Setting up the environment for the test suite

Cleanup Environment
    Log    Cleaning up the environment after the test suite

Start Test
    Log             Setting up the test

Close Test
    Log             Setting up the test end

*** Test Cases ***
BStack Sample Test 1
    [Tags]  chrome
    Should Be True      1==1