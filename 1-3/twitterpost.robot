*** Settings ***
Library    SeleniumLibrary


*** Variables ***
${URL}    https://twitter.com/
${BROWSER}    gc
${ID}     
${PASSWORD}    


*** Test Cases ***
Write New Post To Twitter
    Go To Test Site
    Write New Status


*** Keywords ***
Go To Test Site
    Open Browser    ${URL}    ${BROWSER}
    Input Text    signin-email    ${ID}
    Input Text    signin-password    ${PASSWORD} 
    Click Button    //*[@id="front-container"]/div[2]/div[2]/form/table/tbody/tr/td[2]/button

Write New Status
    Input Text    xpath=//@[id='tweet-box-home-timeline']    Hello 
    Click Button    //*[@id="timeline"]/div[2]/div/form/div[3]/div[2]/button/span[1]
