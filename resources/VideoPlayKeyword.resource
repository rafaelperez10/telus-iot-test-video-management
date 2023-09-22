*** Settings ***
Documentation     This is a resource file, that can contains variables and keywords.
...               Keywords defined here can be used where this videoKeywords.resource in loaded.
Library                 ../src/VideoUtilController.py

*** Keywords ***

Get Video Play Url and Key
    [Arguments]    ${api_name}
    &{video_play_data}=     Video API Gateway      ${api_name}
    [Return]    &{video_play_data}


Validate response
    [Arguments]    ${list_data}     ${key_list_data}
    ${list_endpoint_lenght}=     Validate List      ${list_data}     ${key_list_data}
    [Return]    ${list_endpoint_lenght}