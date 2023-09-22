*** Settings ***
Documentation           A test suite for video play.
Resource                ../../../resources/VideoEventKeyword.resource
Library                 RequestsLibrary
Library                 Collections


Suite Setup     Get Initial Configuration and Values

*** Variables ***
${HOST} =  http://localhost:8080
${VIDEO_EVENT_API_NAME} =    	video-event-api
&{JSON_HEADERS} =  Accept=application/json    Content-Type=application/json    charset=utf-8
&{PROTO_HEADERS} =  Accept=application/x-protobuf    Content-Type=application/x-protobuf    charset=utf-8
&{VIDEO_EVENT}
${DEVICE_ID}
${HOUSEHOLD_ID}
${INTERVAL_ID}
${EVENT_ID}

*** Keywords ***
Get Initial Configuration and Values

    &{video_event_data}=    Get Video Play Url and Key    ${VIDEO_EVENT_API_NAME}
    Set Suite Variable    &{VIDEO_EVENT}       &{video_event_data}

*** Test Cases ***

[TST07] - Video Event Create
    [Documentation]    Customer Video Device Playback Get Session and Endpoint List
    [Tags]      Smoke

    ${payload}=    Set Initial Video Event Data     ${DEVICE_ID}   ${HOUSEHOLD_ID}     ${INTERVAL_ID}
    &{custom_payload}=       Evaluate      ${payload}
    ${event_id}=    Get From Dictionary     ${custom_payload}   eventId
    Set Suite Variable  ${EVENT_ID}     ${event_id}
    ${video_event_api_url}=      Get From Dictionary    ${VIDEO_EVENT}    url
    ${video_event_api_key}=      Get From Dictionary    ${VIDEO_EVENT}    api_key
    &{json_headers_api}     Copy Dictionary       ${JSON_HEADERS}
    Set To Dictionary   ${json_headers_api}     x-api-key=${VIDEO_EVENT_api_key}
    ${endpoint_url} =  Catenate     ${video_event_api_url}/unified-api/video-events
    ${response}=  POST  ${endpoint_url}   headers=${json_headers_api}    data=${payload}
    Status Should Be  200  ${response}




[TST08] - Video Event Get
    [Documentation]    Customer Video Device Playback Get Session and Endpoint List
    [Tags]      Smoke

    &{video_event_query_params}=    Create Dictionary    maxResults=20
    #         timeRange, nextToken
    ${video_event_api_url}=      Get From Dictionary    ${VIDEO_EVENT}    url
    ${video_event_api_key}=      Get From Dictionary    ${VIDEO_EVENT}    api_key
    &{json_headers_api}     Copy Dictionary       ${JSON_HEADERS}
    Set To Dictionary   ${json_headers_api}     x-api-key=${video_event_api_key}
    ${endpoint_url} =  Catenate     ${video_event_api_url}/unified-api/video-events/${HOUSEHOLD_ID}/event/${DEVICE_ID}/${EVENT_ID}
    ${response}=    GET  ${endpoint_url}  headers=${json_headers_api}     params=${video_event_query_params}
    Status Should Be  200  ${response}
    ${event_id_response}    Get From Dictionary   ${response.json()}     eventId
    Should Not Be Empty    ${event_id_response}
    Should Be Equal As Strings    ${EVENT_ID}     ${event_id_response}




[TST09] - Video Event Get List
    [Documentation]    Customer Video Device Playback Get Session and Endpoint List
    [Tags]      Smoke

    &{video_event_query_params}=    Create Dictionary    maxResults=20
    #      deviceId,   timeRange, nextToken
    ${video_event_api_url}=      Get From Dictionary    ${VIDEO_EVENT}    url
    ${video_event_api_key}=      Get From Dictionary    ${VIDEO_EVENT}    api_key
    &{json_headers_api}     Copy Dictionary       ${JSON_HEADERS}
    Set To Dictionary   ${json_headers_api}     x-api-key=${video_event_api_key}
    ${endpoint_url} =  Catenate     ${video_event_api_url}/unified-api/video-events/${HOUSEHOLD_ID}
    ${response}=    GET  ${endpoint_url}  headers=${json_headers_api}     params=${video_event_query_params}
    Status Should Be  200  ${response}
    ${items}    Get From Dictionary   ${response.json()}     items
    ${key_value}     Get From List Dic Key Value        ${items}     eventId
    Should Be Equal As Strings    ${EVENT_ID}   ${key_value}