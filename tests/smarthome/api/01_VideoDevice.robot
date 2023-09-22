*** Settings ***
Documentation           A test suite for video device.
Library                 RequestsLibrary
Library                 Collections
Library                 ../../../src/util/Utils.py
# Library                 ../../../src/VideoDeviceController.py
Resource                ../../../resources/VideoDeviceKeyword.resource

Suite Setup     Get Initial Configuration and Values

*** Variables ***
${HOST} =  http://localhost:8080
${VIDEO_DEVICE_API_NAME} =    video-device-tenant-api
&{VIDEO_DEVICE}
${ENDPOINT_URL}
${RESPONSE_API}
&{CUSTOM_PAYLOAD}
@{RESPONSE_API_BODY}
${RESPONSE_API_JSON}
&{JSON_HEADERS} =  Accept=application/json    Content-Type=application/json    charset=utf-8
&{PROTO_HEADERS} =  Accept=application/x-protobuf    Content-Type=application/x-protobuf    charset=utf-8
${DEVICE_ID}
${HOUSEHOLD_ID}
${VIDEO_DEVICE_API_URL}
${VIDEO_DEVICE_API_KEY}

*** Keywords ***
Get Initial Configuration and Values
    &{video_device_host}=    Get Video Device Url and Key    ${VIDEO_DEVICE_API_NAME}
    ${video_device_api_url}=      Get From Dictionary   ${video_device_host}    url
    ${video_device_api_key}=      Get From Dictionary   ${video_device_host}    api_key
    Set Suite Variable  ${VIDEO_DEVICE_API_URL}     ${video_device_api_url}
    Set Suite Variable  ${VIDEO_DEVICE_API_KEY}     ${video_device_api_key}

*** Test Cases ***

[TST01] - Create a customer video devices
    [Documentation]    Customer Video Device onboarding
    [Tags]      Smoke   Creation


    ${payload} =   Set Data Init
    &{custom_payload}=       Evaluate      ${payload}
    ${device_id}=    Get From Dictionary     ${custom_payload}   deviceId
    Set Global Variable     ${DEVICE_ID}    ${device_id}
    ${household_id}=    Get From Dictionary    ${custom_payload}    householdId
    Set Global Variable         ${HOUSEHOLD_ID}         ${household_id}
    ${endpoint_url} =  Catenate     ${VIDEO_DEVICE_API_URL}/tenant-api/video-device
    &{json_headers_api}     Copy Dictionary       ${JSON_HEADERS}
    Set To Dictionary   ${json_headers_api}     x-api-key=${VIDEO_DEVICE_API_KEY}
    ${response}=  POST  ${endpoint_url}   headers=${json_headers_api}    data=${payload}
    ${body}=  Convert To String  ${response.content}
    Status Should Be  200  ${response}
    ${response_list}=  GET  ${endpoint_url}  headers=${json_headers_api}
    Status Should Be  200  ${response_list}
    ${device}=  Response Should Contains    ${response_list.json()}   deviceId   ${payload}



[TST02] - Get customer video devices list
    [Documentation]    Will retrive all the video devices by customer
    [Tags]    Smoke

    &{json_headers_api}     Copy Dictionary       ${JSON_HEADERS}
    Set To Dictionary   ${json_headers_api}     x-api-key=${VIDEO_DEVICE_API_KEY}

    Given Api Endpoint    ${VIDEO_DEVICE_API_URL}   /tenant-api/video-device?
    When Make Video Device Get Request   ${ENDPOINT_URL}     ${json_headers_api}
    Then Status Should Be   200      ${RESPONSE_API}


