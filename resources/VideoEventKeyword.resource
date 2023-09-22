*** Settings ***
Documentation     This is a resource file, that can contains variables and keywords.
...               Keywords defined here can be used where this videoKeywords.resource in loaded.
Library                 ../src/VideoUtilController.py
Library                 ../src/VideoEventController.py

*** Keywords ***

Get Video Play Url and Key
    [Arguments]    ${api_name}
    &{video_play_data}=     Video API Gateway      ${api_name}
    [Return]    &{video_play_data}

Set Initial Video Event Data
    [Arguments]    ${device_id}     ${house_hold_id}    ${interval_id}
    ${video_play_obj}=     Set Data Init    ${device_id}       ${house_hold_id}    ${interval_id}
    [Return]    ${video_play_obj}


Validate response
    [Arguments]    ${list_data}     ${key_list_data}
    ${list_lenght}=     Validate List      ${list_data}     ${key_list_data}
    [Return]    ${list_lenght}


Get From List Dic Key Value
    [Arguments]    ${list_data}     ${key_name}
    ${key_vale}=     Get Key Value From List Dic       ${list_data}     ${key_name}
    [Return]    ${key_vale}
