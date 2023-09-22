*** Settings ***
Documentation     This is a resource file, that can contains variables and keywords.
...               Keywords defined here can be used where this videoKeywords.resource in loaded.
Library                 ../src/VideoUtilController.py
Library                 ../src/VideoIntervalController.py

*** Keywords ***

Get Video Interval Url and Key
    [Arguments]    ${api_name}
    &{video_interval_data}=     Video API Gateway      ${api_name}
    [Return]    &{video_interval_data}

Get From List Dic Key Value
    [Arguments]    ${list_data}     ${key_name}
    ${key_vale}=     Get Key Value From List Dic       ${list_data}     ${key_name}
    [Return]    ${key_vale}

Get Invertal Initial Data
    [Arguments]    ${device_id}     ${house_hold_id}
    &{video_interval}=  Set Data Init    ${device_id}   ${house_hold_id}
    [Return]    &{video_interval}

Create Interval For API Test
    [Arguments]    ${topic_name}     ${video_interval}
    &{response}=  Create Video Interval    ${topic_name}   ${video_interval}
    [Return]    &{response}

