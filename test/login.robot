*** Settings ***
Documentation    Suite description

Library  SeleniumLibrary

*** Test Cases ***
Test title
    [Tags]    DEBUG

    Begin Web Test
    Login
    Going inside Regions
    creating new Region
    Logout
    End Web Test






















*** Keywords ***
Begin Web Test
   Open Browser     about:blank     chrome


Login
    Go to    https://paas-console-admin.netdev.broadsoft.cloud/#/login
    sleep  4 s
    Input Text  id=username      usubba@cisco.com
    Input Text  id=password      Broadsoft*14
    sleep  2s
    click button  xpath=//button[@promise-btn="loginPromise"]
    sleep  3s


Going inside Regions
    wait until page contains   Regions
    sleep  2s
    click element   //*[text()='Regions']

creating new Region
    wait until page contains  Add Region
    click element    //*[text()='Add Region']
    sleep  3s
    click element    //*[@id='type']
    sleep  2s
    click element    //*[@id='type']//option[6]
    sleep  2s
    Input Text   id=name         client3
    sleep  2s
    Input Text   id=regionIdentity   in02
    sleep  2s
    Input Text   id=systemRoutingProfile    webexdefault
    click button     xpath=//button[@promise-btn="promise"]
    sleep  2s

Logout
    click element     //*[@ng-click='logout()']


End Web Test
   Close Browser

