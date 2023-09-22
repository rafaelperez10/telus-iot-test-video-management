*** Settings ***
Documentation     This is a resource file, that can contains variables and keywords.
...               Keywords defined here can be used where this videoKeywords.resource in loaded.
Library                 ../../src/VideoDeviceController.py


*** Keywords ***
Create Video Device Payload For Event Bus
    ${payload}=     Event Bus Set Data Init
    [Return]    ${payload}

Publish Event Bus Message
    [Arguments]    ${event_source}     ${event_type}    ${event_message}     ${event_bus_name}
    ${response}=    Put Event Bridge Message      ${event_source}     ${event_type}    ${event_message}     ${event_bus_name}
    [Return]    ${response}

Validate Correct Kinesis Video Stream Creation
    [Arguments]    ${device_id}
    ${response2}=    Validate Streams    ${device_id}
    Should Match   ${response2}     True
    [Return]    ${response2}