*** Settings ***
Documentation           A test suite for video play.
Resource                ../../../resources/VideoIntervalKeyword.resource
Library                 RequestsLibrary
Library                 Collections

Suite Setup     Get Initial Configuration and Values

*** Variables ***
${VIDEO_INTERVAL_API_NAME} =    video-interval-api
&{JSON_HEADERS} =  Accept=application/json    Content-Type=application/json    charset=utf-8
&{PROTO_HEADERS} =  Accept=application/x-protobuf    Content-Type=application/x-protobuf    charset=utf-8
${SESSION_ID_LIVESTREAM}
&{VIDEO_INTERVAL}
${DEVICE_ID}
${HOUSEHOLD_ID}
${INTERVAL_ID}


*** Keywords ***
Get Initial Configuration and Values

    &{video_interval_data}=    Get Video Interval Url and Key       ${VIDEO_INTERVAL_API_NAME}
    Set Suite Variable       &{VIDEO_INTERVAL}       &{video_interval_data}
    &{interval}=  Get Invertal Initial Data    ${DEVICE_ID}   ${HOUSEHOLD_ID}
    Create Interval For API Test    video-interval-kvs-metadata     ${interval}
    &{video_interval_notification_payload}=      Get From Dictionary    ${interval}    NotificationPayload
    ${interval_id}=      Get From Dictionary    ${video_interval_notification_payload}    ID
    Set Global Variable    ${INTERVAL_ID}   ${interval_id}


*** Test Cases ***

[TST10] - Video Intevals Unified API - GetVideoIntervals
    [Documentation]    Customer Video Device Playback Get Session and Endpoint List
    [Tags]      Smoke5

    ${video_interval_api_url}=      Get From Dictionary    ${VIDEO_INTERVAL}    url
    ${video_interval_api_key}=      Get From Dictionary    ${VIDEO_INTERVAL}    api_key
    &{json_headers_api}     Copy Dictionary       ${JSON_HEADERS}
    Set To Dictionary   ${json_headers_api}     x-api-key=${video_interval_api_key}
    &{video_interval_query_params}=    Create Dictionary   deviceId=${DEVICE_ID}
    #   nextToken=''    maxResults=''   startTime=''    endTime=''
    #   /unified-api/video-intervals/{householdId}
    ${endpoint_url} =  Catenate     ${video_interval_api_url}/unified-api/video-intervals/${HOUSEHOLD_ID}
    ${response}=    GET  ${endpoint_url}  headers=${json_headers_api}     params=${video_interval_query_params}
    Status Should Be  200  ${response}
    ${items_list}    Get From Dictionary   ${response.json()}     items
    ${video_interval_id}     Get From List Dic Key Value        ${items_list}     intervalId
    Should Not Be Empty    ${video_interval_id}
    Should Be Equal As Strings    ${INTERVAL_ID}    ${video_interval_id}



[TST11] - Video Intevals Unified API - GetVideoIntervalsByDeviceId
    [Documentation]    Customer Video Device Playback Get Session and Endpoint List
    [Tags]      Smoke

    #${interval_id}     Set Variable     32yh32sioe7
    Should Not Be Empty    ${INTERVAL_ID}
    ${video_interval_api_url}=      Get From Dictionary    ${VIDEO_INTERVAL}    url
    ${video_interval_api_key}=      Get From Dictionary    ${VIDEO_INTERVAL}    api_key
    &{json_headers_api}     Copy Dictionary       ${JSON_HEADERS}
    Set To Dictionary   ${json_headers_api}     x-api-key=${video_interval_api_key}
    &{video_interval_query_params}=    Create Dictionary   deviceId=${DEVICE_ID}
    ${endpoint_url} =  Catenate     ${video_interval_api_url}/unified-api/video-intervals/${HOUSEHOLD_ID}/interval/${INTERVAL_ID}
    ${response}=    GET  ${endpoint_url}  headers=${json_headers_api}     params=${video_interval_query_params}
    Status Should Be  200  ${response}