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

[TST01] - Video Device Tenant API - Create new video device
    [Documentation]    Will create new video device
    [Tags]      Smoke01


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



[TST02] - Video Device Tenant API - Get video devices list
    [Documentation]    Will retrive all the video devices by customer
    [Tags]    Smoke01

    &{json_headers_api}     Copy Dictionary       ${JSON_HEADERS}
    Set To Dictionary   ${json_headers_api}     x-api-key=${VIDEO_DEVICE_API_KEY}

    Given Api Endpoint    ${VIDEO_DEVICE_API_URL}   /tenant-api/video-device?
    When Make Video Device Get Request   ${ENDPOINT_URL}     ${json_headers_api}
    Then Status Should Be   200      ${RESPONSE_API}


[TST03] - Video Device Tenant API - Update atribute UpdateMaximunNumberOfWebRTCSessions by DeviceId

    [Documentation]    Will update maximumNumberOfWebRTCSessions by deviceId
    [Tags]    Smoke01


    ${RANDOM_NUMBER}=     Random Number
    ${payload}=    Create Dictionary    maximumNumberOfWebRTCSessions=${RANDOM_NUMBER}
    Log To Console    ${payload}
    ${device_id}=    Set Variable   ${DEVICE_ID}
    ${endpoint_url}=    Catenate    ${VIDEO_DEVICE_API_URL}/tenant-api/video-device/${device_id}/maxChannelSessions
    &{json_headers_api}=    Copy Dictionary    ${JSON_HEADERS}
    Set To Dictionary    ${json_headers_api}    x-api-key=${VIDEO_DEVICE_API_KEY}
    ${response}=    PATCH    ${endpoint_url}    headers=${json_headers_api}    json=${payload}
    ${body}=    Convert To String    ${response.content}
    Log To Console   ${body}
    Status Should Be    200    ${response}
    ${response_list}=  Get Id Request   ${VIDEO_DEVICE_API_URL}/tenant-api/video-device/${device_id}  headers=${json_headers_api}
    ${body_list}=  Convert To String  ${response_list.content}
    Status Should Be  200  ${response_list}
    ${response_dict}=  Evaluate  json.loads('''${body_list}''')  json
    ${maximum_sessions}=  Get From Dictionary  ${response_dict}  maximumNumberOfWebRTCSessions
    Should Be Equal As Strings  ${maximum_sessions}  ${RANDOM_NUMBER}



[TST04] - Video Device Tenant API - Update atribute RetantionPeriod by deviceId

    [Documentation]    Will update retentionPeriod by deviceId
    [Tags]    Smoke01

    ${RANDOM_NUMBER}=     Random Number
    ${payload}=    Create Dictionary    videoRetentionPeriodInHours=${RANDOM_NUMBER}
    Log To Console    ${payload}
    ${device_id}=    Set Variable    ${DEVICE_ID}
    ${endpoint_url}=    Catenate    ${VIDEO_DEVICE_API_URL}/tenant-api/video-device/${device_id}/retentionPeriod
    &{json_headers_api}=    Copy Dictionary    ${JSON_HEADERS}
    Set To Dictionary    ${json_headers_api}    x-api-key=${VIDEO_DEVICE_API_KEY}
    ${response}=    PATCH    ${endpoint_url}    headers=${json_headers_api}    json=${payload}
    ${body}=    Convert To String    ${response.content}
    Log To Console   ${body}
    ${response_list}=  Get Id Request   ${VIDEO_DEVICE_API_URL}/tenant-api/video-device/${device_id}  headers=${json_headers_api}
    ${body_list}=  Convert To String  ${response_list.content}
    Status Should Be  200  ${response_list}
    ${response_dict}=  Evaluate  json.loads('''${body_list}''')  json
    ${video_retantion}=  Get From Dictionary  ${response_dict}  videoRetentionPeriodInHours
    Log To Console  Video Retention: ${video_retantion}
    Should Be Equal As Strings  ${video_retantion}  ${RANDOM_NUMBER}

[TST05] - Video Device Tenant API - Update atribute status by deviceId

    [Documentation]    Will update status by deviceId
    [Tags]    Smoke01

    ${LIFE_CYCLE_TYPE}=     Life Cycle Type
    ${payload}=    Create Dictionary    status=${LIFE_CYCLE_TYPE}
    Log To Console    ${payload}
    ${device_id}=    Set Variable    ${DEVICE_ID}
    ${endpoint_url}=    Catenate    ${VIDEO_DEVICE_API_URL}/tenant-api/video-device/${device_id}/status
    &{json_headers_api}=    Copy Dictionary    ${JSON_HEADERS}
    Set To Dictionary    ${json_headers_api}    x-api-key=${VIDEO_DEVICE_API_KEY}
    ${response}=    PATCH    ${endpoint_url}    headers=${json_headers_api}    json=${payload}
    ${body}=    Convert To String    ${response.content}
    Log To Console   ${body}
    Status Should Be    200    ${response}
    ${response_list}=  Get Id Request   ${VIDEO_DEVICE_API_URL}/tenant-api/video-device/${device_id}  headers=${json_headers_api}
    ${body_list}=  Convert To String  ${response_list.content}
    Status Should Be  200  ${response_list}
    ${response_dict}=  Evaluate  json.loads('''${body_list}''')  json
    ${status_device}=  Get From Dictionary  ${response_dict}  status
    Should Be Equal As Strings   ${status_device}  ${LIFE_CYCLE_TYPE}


[TST06] - Video Device Tenant API - Delete video device by deviceId

    [Documentation]    Will delete video devices by deviceId
    [Tags]    Smoke10

    ${device_id}=    Set Variable   ${DEVICE_ID}
    Log To Console    ${device_id}
    ${endpoint_url} =  Catenate     ${VIDEO_DEVICE_API_URL}/tenant-api/video-device/${device_id}
    &{json_headers_api}     Copy Dictionary       ${JSON_HEADERS}
    Set To Dictionary   ${json_headers_api}     x-api-key=${VIDEO_DEVICE_API_KEY}
    ${response}=  DELETE  ${endpoint_url}   headers=${json_headers_api}
    ${body}=  Convert To String  ${response.content}
    Log To Console   ${body}
    Status Should Be  200  ${response}
    ${response_list}=  Get Id Request   ${VIDEO_DEVICE_API_URL}/tenant-api/video-device/${device_id}  headers=${json_headers_api}
    Status Should Be  404  ${response_list}


[TST07] - Video Device Tenant API - Get video device by deviceId

    [Documentation]    Will get video devices by deviceId
    [Tags]    Smoke01

    ${device_id}=    Set Variable   ${DEVICE_ID}
    Log To Console    ${device_id}
    ${endpoint_url} =  Catenate     ${VIDEO_DEVICE_API_URL}/tenant-api/video-device/${device_id}
    &{json_headers_api}     Copy Dictionary       ${JSON_HEADERS}
    Set To Dictionary   ${json_headers_api}     x-api-key=${VIDEO_DEVICE_API_KEY}
    ${response}=  Get Id Request  ${endpoint_url}   headers=${json_headers_api}
    ${body}=  Convert To String  ${response.content}
    Log To Console   ${body}
    Status Should Be  200  ${response}

[TST08] - Video Device Tenant API - Get video device by householdId

    [Documentation]    Will get video devices by householdId
    [Tags]    Smoke01

    ${household_id}=    Set Variable   ${HOUSEHOLD_ID}
    Log To Console    ${household_id}
    ${endpoint_url} =  Catenate     ${VIDEO_DEVICE_API_URL}/tenant-api/video-device/${household_id}
    &{json_headers_api}     Copy Dictionary       ${JSON_HEADERS}
    Set To Dictionary   ${json_headers_api}     x-api-key=${VIDEO_DEVICE_API_KEY}
    ${response}=  Get Id Request  ${endpoint_url}   headers=${json_headers_api}
    ${body}=  Convert To String  ${response.content}
    Log To Console   ${body}
    Status Should Be  200  ${response}