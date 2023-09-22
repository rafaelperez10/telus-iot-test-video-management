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