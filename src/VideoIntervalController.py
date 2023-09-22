import random
import string
import time
import json
from model.VideoManager import StartNotificationPayload
from model.VideoManager import StartInterval
from model.VideoManager import EndInterval
from model.VideoManager import EndNotificationPayload
from aws.AWSServices import KinesisVideo
from aws.AWSServices import SNS
from random import randint
from datetime import date
from robot.api import logger


class VideoIntervalController:

    @staticmethod
    def set_data_init(device_id, house_hold_id):
        st_interval = StartInterval()
        st_interval.StreamArn = VideoIntervalController.get_arn_stream(device_id)
        st_interval.FragmentNumber = str(
            randint(10000000000000000000000000000000000000000000000, 999999999999999999999999999999999999999999999999))
        st_interval.FragmentStartProducerTimestamp = VideoIntervalController.get_current_milli_time()
        st_interval.FragmentStartServerTimestamp = VideoIntervalController.get_current_milli_time()
        st_interval.NotificationType = "PERSISTED"
        st_notification = StartNotificationPayload()
        st_notification.MESSAGE = "STARTING"
        st_notification.PRODUCER_TIMESTAMP = VideoIntervalController.get_current_milli_time()
        st_notification.HOUSEHOLD_ID = house_hold_id
        st_notification.STREAM = 'SH20-eventStream-' + device_id
        st_notification.ID = str(VideoIntervalController.get_random_uuid(8) + "-" +
                                 VideoIntervalController.get_random_uuid(4) + "-" +
                                 VideoIntervalController.get_random_uuid(4) + "-" +
                                 "interval-auto-" +
                                 VideoIntervalController.get_random_uuid(12)).lower()
        st_notification.DEVICE_ID = device_id
        st_notification.TYPE = "VIDEO_INTERVAL_START"
        st_interval.NotificationPayload = st_notification.__dict__
        return st_interval.__dict__

    @staticmethod
    def get_arn_stream(device_id):
        kinesis_video = KinesisVideo()
        "StreamInfoList"
        result = True
        event_stream = 'SH20-eventStream-' + device_id
        result_event_stream = kinesis_video.get_list_streams(event_stream)
        if "StreamInfoList" in result_event_stream:
            stream_info_list = result_event_stream["StreamInfoList"]
            for i in range(len(stream_info_list)):
                dict_resp = stream_info_list[i]
                if event_stream == dict_resp["StreamName"]:
                    stream_arn = dict_resp["StreamARN"]
        return str(stream_arn)

    @staticmethod
    def get_current_milli_time():
        return round(time.time() * 1000)

    @staticmethod
    def get_random_uuid(digits):
        return str("".join(random.choice(string.ascii_uppercase + string.digits) for _ in range(digits)))

    @staticmethod
    def create_video_interval(topic_name, video_interval):
        sns = SNS()
        response = sns.publish_msg_topic(topic_name, video_interval)
        logger.info(response)
        return response
