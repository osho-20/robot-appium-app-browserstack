*** Settings ***
Documentation    Robot Framework wrapper for BrowserStack Pytest execution
Library          Process
Library          OperatingSystem

*** Variables ***
${SCRIPT_PATH}    ${CURDIR}/script.sh
${TIMEOUT}        30 minutes
# These can be overridden via command line: robot -v BROWSERSTACK_USERNAME:value -v BROWSERSTACK_ACCESS_KEY:value
${BROWSERSTACK_USERNAME}    ${EMPTY}
${BROWSERSTACK_ACCESS_KEY}    ${EMPTY}

*** Test Cases ***
Execute BrowserStack Pytest Tests
    [Documentation]    Run the bash script to execute pytest tests on BrowserStack
    [Tags]    browserstack    android    pytest
    
    Log    Starting BrowserStack pytest execution    console=True
    Log    Working directory: ${CURDIR}    console=True
    
    # Try to get credentials from Robot variables first, then fallback to environment variables
    ${username}=    Set Variable If    '${BROWSERSTACK_USERNAME}' != '${EMPTY}'    ${BROWSERSTACK_USERNAME}    NOT_SET
    ${username}=    Get Environment Variable    BROWSERSTACK_USERNAME    default=${username}
    
    ${key}=    Set Variable If    '${BROWSERSTACK_ACCESS_KEY}' != '${EMPTY}'    ${BROWSERSTACK_ACCESS_KEY}    NOT_SET
    ${key}=    Get Environment Variable    BROWSERSTACK_ACCESS_KEY    default=${key}
    
    Log    BrowserStack Username: ${username}    console=True
    ${key_status}=    Set Variable If    '${key}' != 'NOT_SET'    Yes    No
    Log    BrowserStack Key configured: ${key_status}    console=True
    
    # Generate unique build identifier
    ${timestamp}=    Get Time    epoch
    ${random}=    Evaluate    __import__('random').randint(1000, 9999)
    ${build_id}=    Set Variable    build_${timestamp}_${random}
    Log    Build Identifier: ${build_id}    console=True
    
    # Ensure script has execute permissions
    Run    chmod +x ${SCRIPT_PATH}
    
    # Execute the bash script with exported environment variables using shell
    ${command}=    Set Variable    export BROWSERSTACK_USERNAME="${username}" && export BROWSERSTACK_ACCESS_KEY="${key}" && export BROWSERSTACK_BUILD_RUN_IDENTIFIER="${build_id}" && bash ${SCRIPT_PATH}
    ${result}=    Run Process    bash    -c    ${command}
    ...    cwd=${CURDIR}
    ...    timeout=${TIMEOUT}
    ...    stdout=${CURDIR}/robot_stdout.log
    ...    stderr=${CURDIR}/robot_stderr.log
    ...    shell=True
    
    # Log output for debugging
    Log    STDOUT:\n${result.stdout}    console=True
    Log    STDERR:\n${result.stderr}    console=True
    Log    Exit Code: ${result.rc}    console=True
    
    # Check exit code - fail if non-zero
    Run Keyword If    ${result.rc} != 0    Fail    Pytest execution failed with exit code ${result.rc}. Check logs for details.
    
    Log    BrowserStack pytest execution completed successfully    console=True

*** Keywords ***
# Add custom keywords here if needed
