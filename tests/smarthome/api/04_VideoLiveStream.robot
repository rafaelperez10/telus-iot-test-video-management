*** Settings ***
Documentation           A test suite for video play.
Resource                ../../../resources/VideoPlayKeyword.resource
Library                 RequestsLibrary
Library                 Collections

Suite Setup     Get Initial Configuration and Values

*** Variables ***
${VIDEO_PLAY_API_NAME} =    video-play-api
&{JSON_HEADERS} =  Accept=application/json    Content-Type=application/json    charset=utf-8
&{PROTO_HEADERS} =  Accept=application/x-protobuf    Content-Type=application/x-protobuf    charset=utf-8
${SESSION_ID_LIVESTREAM}
&{VIDEO_PLAY}
${DEVICE_ID}
${HOUSEHOLD_ID}
${INTERVAL_ID}
*** Keywords ***
Get Initial Configuration and Values

    &{video_play_data}=    Get Video Play Url And Key        ${VIDEO_PLAY_API_NAME}
    Set Suite Variable      &{VIDEO_PLAY}       &{video_play_data}

*** Test Cases ***

[TST03] - Video Playback Get Endpoint List and Session ID
    [Documentation]    Customer Video Device Playback Get Session and Endpoint List
    [Tags]      Smoke

    ${video_play_api_url}=      Get From Dictionary    ${VIDEO_PLAY}    url
    ${video_play_api_key}=      Get From Dictionary    ${VIDEO_PLAY}    api_key
    &{json_headers_api}     Copy Dictionary       ${JSON_HEADERS}
    Set To Dictionary   ${json_headers_api}     x-api-key=${video_play_api_key}
    &{video_play_query_params}=    Create Dictionary   retention=3600    role=VIEWER
    ${endpoint_url} =  Catenate     ${video_play_api_url}/unified-api/video-play/${HOUSEHOLD_ID}/liveStream/device/${DEVICE_ID}
    ${response}=    GET  ${endpoint_url}  headers=${json_headers_api}     params=${video_play_query_params}
    Status Should Be  200  ${response}
    ${livestream_session_id}    Get From Dictionary   ${response.json()}     sessionId
    Should Not Be Empty    ${livestream_session_id}
    Set Global Variable     ${SESSION_ID_LIVESTREAM}     ${livestream_session_id}
    ${device_data}    Get From Dictionary   ${response.json()}     device
    ${list_endpoint_lenght}     Validate Response        ${device_data}     resourceEndpointList
    Run Keyword If  ${list_endpoint_lenght} <= 0        Fail    "The device endpoint list is empty"




[TST04] - Video Playback Delete Livestream Session
    [Documentation]    Customer Video Playback Delete Session
    [Tags]      Smoke
    ${video_play_api_url}=      Get From Dictionary    ${VIDEO_PLAY}    url
    ${video_play_api_key}=      Get From Dictionary    ${VIDEO_PLAY}    api_key
    &{json_headers_api}     Copy Dictionary       ${JSON_HEADERS}
    Set To Dictionary   ${json_headers_api}     x-api-key=${video_play_api_key}
    Should Not Be Empty    ${SESSION_ID_LIVESTREAM}
    ${endpoint_url} =  Catenate     ${video_play_api_url}/unified-api/video-play/liveStream/device/${DEVICE_ID}/session/${SESSION_ID_LIVESTREAM}
    ${response}=    DELETE  ${endpoint_url}  headers=${json_headers_api}
    Status Should Be  200  ${response}



[TST05] - Video Playback Get Playback (HLS / DASH) - Cloud
    [Documentation]    Customer Video Device Play Back  (HLS / DASH) - Cloud
    [Tags]      Smoke

    ${video_play_api_url}=      Get From Dictionary    ${VIDEO_PLAY}    url
    ${video_play_api_key}=      Get From Dictionary    ${VIDEO_PLAY}    api_key
    &{json_headers_api}     Copy Dictionary       ${JSON_HEADERS}
    Set To Dictionary   ${json_headers_api}     x-api-key=${video_play_api_key}
    #/unified-api/video-play/:householdId/playback/cloud/:intervalIdprotocols=["HTTPS", "WSS"]&retention=900&role=VIEWER
    &{video_playback_query_params}=    Create Dictionary    retention=20       role=VIEWER     protocols=["HTTPS", "WSS"]
    ${endpoint_url} =  Catenate     ${video_play_api_url}/unified-api/video-play/${HOUSEHOLD_ID}/playback/cloud/${INTERVAL_ID}
    ${response}=    GET  ${endpoint_url}  headers=${json_headers_api}     params=${video_playback_query_params}
    Status Should Be  200  ${response}
