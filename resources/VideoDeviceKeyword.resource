*** Settings ***
Documentation     This is a resource file, that can contains variables and keywords.
...               Keywords defined here can be used where this videoKeywords.resource in loaded.
Library                 RequestsLibrary
Library                 JSONLibrary
Library                 ../src/VideoDeviceController.py
Library                 ../src/VideoUtilController.py

*** Keywords ***
Make Video Device Get Request
    [Arguments]    ${endpoint_url}    ${json_headers}
    ${response}=    GET  ${endpoint_url}  headers=${json_headers}
    Set Global Variable     @{RESPONSE_API_BODY}     ${response.content}
    Set Global Variable     ${RESPONSE_API_JSON}     ${response.json()}
    Set Global Variable     ${RESPONSE_API}     ${response}


Api Endpoint
    [Arguments]    ${host}    ${api_path}
    Set Global Variable  ${ENDPOINT_URL}        ${host}${api_path}

Set Video Device Payload
    ${payload}=     Set Data Init
    Set Global Variable     ${CUSTOM_PAYLOAD}   ${payload}


Get Video Device Url and Key
    [Arguments]    ${api_name}
    &{video_play_data}=     Video API Gateway      ${api_name}
    [Return]    &{video_play_data}

Check Response Status
    [Arguments]    ${response}    ${expected_status}
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}

Patch Request
    [Arguments]    ${url}    ${headers}    ${json}
    ${response}=    Patch    ${url}    headers=${headers}    json=${json}
    [Return]        ${response}

Delete Request
    [Arguments]    ${url}    ${headers}
    ${response}=    Delete    ${url}    headers=${headers}
    [Return]        ${response}

Get Id Request
    [Arguments]    ${url}    ${headers}
    ${response}=    GET    ${url}    headers=${headers}
    [Return]        ${response}

Random Number
    ${random_number}=    Random Number
    Set Global Variable    ${RANDOM_NUMBER}   ${random_number}
    [Return]    ${RANDOM_NUMBER}

Life Cycle Type
    ${life_cycle_type}=    Life Cycle Type
    Set Global Variable    ${LIFE_CYCLE_TYPE}   ${life_cycle_type}
    [Return]    ${LIFE_CYCLE_TYPE}
