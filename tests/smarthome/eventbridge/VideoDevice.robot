*** Settings ***
Documentation           A test suite for video device using AWS EventBridge.
Library                 Collections
Resource                ../../../resources/eventbridge/VideoDeviceKeywordE.resource

Suite Setup     Get Initial Configuration and Values

*** Variables ***
${EVENT_SOURCE} =  SH2.IotCloud.AssetManagement
${EVENT_TYPE} =  AddAsset
${EVENT_BUS_NAME} =  SH2.Platform.GlobalEventBus
${DEVICE_ID_EVENTBRIDGE}

*** Keywords ***
Get Initial Configuration and Values
    &{custom_payload} =   Create Video Device Payload For Event Bus
    ${device_id_event}=    Get From Dictionary     ${custom_payload}   deviceId
    Set Global Variable     ${DEVICE_ID_EVENTBRIDGE}    ${device_id_event}
    ${household_id_event}=    Get From Dictionary    ${custom_payload}    householdId
    Set Global Variable         ${HOUSEHOLD_ID_EVENTBRIDGE}         ${household_id_event}
    Set Suite Variable    ${PAYLOAD}     ${custom_payload}

*** Test Cases ***
[TST01] - Add a New Video Device Asset
    [Documentation]    AWS Event Bridge Add a Customer Video Device
    [Tags]      Smoke
    ${response}=    Publish Event Bus Message    ${EVENT_SOURCE}     ${EVENT_TYPE}      ${PAYLOAD}       ${EVENT_BUS_NAME}
    Wait Until Keyword Succeeds     12x     5 sec    Validate Correct Kinesis Video Stream Creation  ${DEVICE_ID_EVENTBRIDGE}

