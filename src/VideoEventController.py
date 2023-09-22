import random
import string
import datetime
import json
from model.VideoManager import Event
from random import randint
from datetime import date
from robot.api import logger


class VideoEventController:

    @staticmethod
    def set_data_init(device_id, house_hold_id, interval_id):
        event = Event()
        event.eventType = VideoEventController.get_event_type()  # 'chime'  'pirSensor'
        event.eventId = str(VideoEventController.get_random_uuid(8) + "-" +
                            VideoEventController.get_random_uuid(4) + "-" +
                            VideoEventController.get_random_uuid(4) + "-" +
                            "EVENT-AUTO-" +
                            VideoEventController.get_random_uuid(12))
        event.deviceId = device_id
        event.householdId = house_hold_id
        event.intervalId = interval_id
        event.producerTimeStamp = str(datetime.datetime.now().isoformat())  # "2023-09-01T12:18:17.322Z"
        event.status = "CAPTURED"
        return json.dumps(event.__dict__, default=vars)

    @staticmethod
    def get_random_uuid(digits):
        return str("".join(random.choice(string.ascii_uppercase + string.digits) for _ in range(digits)))

    @staticmethod
    def get_event_type():
        selected = randint(0, 2)
        match selected:
            case 0:
                list_event_type = ['chime']
            case 1:
                list_event_type = ['pirSensor']
            case 2:
                list_event_type = ['chime', 'pirSensor']
        return list_event_type

    @staticmethod
    def get_custom_datetime():
        return datetime.datetime.now()
