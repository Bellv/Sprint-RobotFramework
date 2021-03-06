*** Settings ***
Library    SeleniumLibrary
Suite Setup    Go To Login Page
Suite Teardown    Close All Browsers

*** Variables ***
${URL}    https://robot-stage-1.firebaseapp.com
${VALID_USERNAME}    demouser
${VALID_PASSWORD}    demopassword
@{CHROME_OPTIONS}    headless    disable-gpu
${CHROME_BINARY}    /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome

*** Test Cases ***
Invalid Username Should Fail
    Login With Credential    invalid    ${VALID_PASSWORD}
    Invalid Username Or Password Error Modal Should Be Displayed
    [Teardown]    Reset Test

Invalid Password Should Fail
    Login With Credential    ${VALID_USERNAME}    invalid
    Invalid Username Or Password Error Modal Should Be Displayed
    [Teardown]    Reset Test

Invalid Username And Password Should Fail
    Login With Credential    invalid    invalid
    Invalid Username Or Password Error Modal Should Be Displayed
    [Teardown]    Reset Test

Empty Username Should Fail
    Login With Credential    ${EMPTY}    ${VALID_PASSWORD}
    Invalid Username Or Password Error Modal Should Be Displayed
    [Teardown]    Reset Test

Empty Password Should Fail
    Login With Credential    ${VALID_USERNAME}    ${EMPTY}
    Invalid Username Or Password Error Modal Should Be Displayed
    [Teardown]    Reset Test

Empty Username And Password Should Fail
    Login With Credential    ${EMPTY}    ${EMPTY}
    Invalid Username Or Password Error Modal Should Be Displayed
    [Teardown]    Reset Test

*** Keywords ***
Open Headless Browser
    [Arguments]    ${url}
    ${options}=    Set Chrome Options
    ${options.set_binary}=    Set Variable    set_binary=${CHROME_BINARY}
    Create WebDriver    Chrome    chrome_options=${options} 
    Go To    ${url}

Set Chrome Options
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    : FOR    ${option}    IN    @{CHROME_OPTIONS}
    \    Call Method    ${options}    add_argument    ${option}
    [Return]    ${options}

Go To Login Page
    Open Headless Browser    ${URL}
    Click Element    signin

Login With Credential
    [Arguments]    ${username}    ${password}
    Enter Username    ${username}
    Enter Password    ${password}
    Click Login Button

Enter Username
    [Arguments]    ${username}
    Input Text    inputUser    ${username}

Enter Password
    [Arguments]    ${password}
    Input Password    inputPassword    ${password}

Click Login Button
    Click Button    buttonLogin

Invalid Username Or Password Error Modal Should Be Displayed
    Retry    Element Should Be Visible    errorModal
    Element Should Contain    errorModal    ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง

Retry
    [Arguments]    @{args}
    Wait Until Keyword Succeeds    5s    3s    @{args}

Reset Test
    Wait Until Element Is Visible    close-error-modal-button
    Click Button    close-error-modal-button
    Wait Until Element Is Not Visible    close-error-modal-button
    Clear Text Field    inputUser
    Clear Text Field    inputPassword

Clear Text Field
    [Arguments]    ${locator}
    ${value}=    Get Value    ${locator}
    ${length}=    Get Length    ${value}    
    :FOR    ${index}    IN RANGE    ${length}
    \    Press Key    ${locator}    \\8
