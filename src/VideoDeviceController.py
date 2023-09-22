import random
import string
import json
from model.VideoManager import Device
from model.VideoManager import EventBusDevice
from aws.AWSServices import EventBridge
from aws.AWSServices import KinesisVideo
from random import randint
from robot.api import logger


class VideoDeviceController:

    @staticmethod
    def set_data_init():
        device = Device()
        device.deviceId = str(randint(10000000000, 999999999999))
        device.householdId = "api-" + VideoDeviceController.get_random_uuid(10) \
                             + "-" + VideoDeviceController.get_random_uuid(7)\
                             + "-auto-test"
        device.videoRetentionPeriodInHours = randint(1, 720)
        device.maximumNumberOfWebRTCSessions = randint(1, 9)
        device.webRTCSessionProtocols = VideoDeviceController.get_session_protocol()
        return json.dumps(device.__dict__, default=vars)

    @staticmethod
    def event_bus_set_data_init():
        device = EventBusDevice()
        device.deviceId = str(randint(10000000000, 999999999999))
        device.householdId = "event-" + VideoDeviceController.get_random_uuid(10) \
                             + "-" + VideoDeviceController.get_random_uuid(7)\
                             + "-auto-test"
        device.alias = VideoDeviceController.get_random_uuid(7) + "-auto-test"
        device.videoRetentionPeriodInHours = randint(1, 720)
        device.maximumNumberOfWebRTCSessions = randint(1, 9)
        device.webRTCSessionProtocols = VideoDeviceController.get_session_protocol()
        return device.__dict__

    @staticmethod
    def get_random_uuid(digits):
        return str("".join(random.choice(string.ascii_uppercase + string.digits) for _ in range(digits)))

    @staticmethod
    def get_session_protocol():
        selected = randint(0, 2)
        match selected:
            case 0:
                list_event_type = ['WSS']
            case 1:
                list_event_type = ['HTTPS']
            case 2:
                list_event_type = ['WSS', 'HTTPS']
        return list_event_type


# AWS SERVICES
# EVENTBRIDGE
    @staticmethod
    def put_event_bridge_message(event_source, event_type, event_message, event_bus_name):
        event_bridge = EventBridge()
        return event_bridge.publish_msg(event_source, event_type, event_message, event_bus_name)

    @staticmethod
    def validate_streams(device_id):
        kinesis_video = KinesisVideo()
        result = True

        device_stream = 'SH20-deviceStream-'+device_id
        result_device_stream = kinesis_video.get_list_streams(device_stream)
        exist_device_stream = VideoDeviceController.validate_exist_streams(device_stream, "StreamName", result_device_stream.get('StreamInfoList'))
        if not exist_device_stream:
            result = False
            return str(result)

        event_stream = 'SH20-eventStream-'+device_id
        result_event_stream = kinesis_video.get_list_streams(event_stream)
        exist_event_stream = VideoDeviceController.validate_exist_streams(event_stream, "StreamName", result_event_stream.get('StreamInfoList'))
        if not exist_event_stream:
            result = False

        manual_stream = 'SH20-manualStream-'+device_id
        results_manual_stream = kinesis_video.get_list_streams(manual_stream)
        exist_manual_stream = VideoDeviceController.validate_exist_streams(manual_stream, "StreamName", results_manual_stream.get('StreamInfoList'))
        if not exist_manual_stream:
            result = False

        live_stream = 'SH20-liveChannel-'+device_id
        result_live_stream = kinesis_video.get_signaling_channels(live_stream)
        exist_live_stream = VideoDeviceController.validate_exist_streams(live_stream, "ChannelName", result_live_stream.get('ChannelInfoList'))
        if not exist_live_stream:
            result = False

        return str(result)

    @staticmethod
    def validate_exist_streams(stream_name, stream_key, stream_list):
        exist_stream = False
        for i in range(len(stream_list)):
            dict_resp = stream_list[i]
            key_value = dict_resp.get(stream_key)
            logger.info('key_value:'+key_value)
            if stream_name == key_value:
                exist_stream = True
                break
        return exist_stream
