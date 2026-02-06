*** Settings ***
Documentation    Robot Framework wrapper for BrowserStack Robot execution
Library          Process
Library          OperatingSystem

*** Variables ***
${TIMEOUT}        30 minutes
# These can be overridden via command line: robot -v BROWSERSTACK_USERNAME:value -v BROWSERSTACK_ACCESS_KEY:value
${BROWSERSTACK_USERNAME}    ${EMPTY}
${BROWSERSTACK_ACCESS_KEY}    ${EMPTY}

*** Tasks ***
Execute BrowserStack Robot Local Tests
    [Documentation]    Run the bash script to execute Robot tests on BrowserStack
    [Tags]    browserstack    android    Robot
    
    Log    Starting BrowserStack Robot execution    console=True
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

    # Make env vars available to all subsequent Run Process calls
    Set Environment Variable    BROWSERSTACK_USERNAME    ${username}
    Set Environment Variable    BROWSERSTACK_ACCESS_KEY    ${key}
    Set Environment Variable    BROWSERSTACK_BUILD_IDENTIFIER    ${build_id}
    
    Log    Installing dependencies (pip install -r requirements.txt)    console=True
    ${install_result}=    Run Process    python    -m    pip    install    -r    requirements.txt
    ...    cwd=${CURDIR}
    ...    timeout=${TIMEOUT}
    ...    stdout=${CURDIR}/pip_stdout.log
    ...    stderr=${CURDIR}/pip_stderr.log
    Run Keyword If    ${install_result.rc} != 0    Fail    Dependency install failed with exit code ${install_result.rc}. Check pip_stdout.log / pip_stderr.log.

    Log    Running BrowserStack SDK: browserstack-sdk robot ./tests/    console=True
    ${result}=    Run Process    browserstack-sdk    robot    ./tests/
    ...    cwd=${CURDIR}/robot
    ...    timeout=${TIMEOUT}
    ...    stdout=${CURDIR}/robot_stdout.log
    ...    stderr=${CURDIR}/robot_stderr.log
    
    # Log output for debugging
    Log    STDOUT:\n${result.stdout}    console=True
    Log    STDERR:\n${result.stderr}    console=True
    Log    Exit Code: ${result.rc}    console=True
    
    # Check exit code - fail if non-zero
    Run Keyword If    ${result.rc} != 0    Fail    Robot execution failed with exit code ${result.rc}. Check logs for details.
    
    Log    BrowserStack Robot execution completed successfully    console=True

*** Keywords ***
# Add custom keywords here if needed
