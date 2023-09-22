import json
from robot.api import logger
from types import SimpleNamespace


class Utils:

    @staticmethod
    def response_should_contains(body_response, custom_key, custom_value):

        logger.info(type(custom_value))
        device_custom = json.loads(custom_value, object_hook=lambda d: SimpleNamespace(**d))
        logger.info(device_custom.deviceId)
        for device_list in body_response.values():
            for i in range(len(device_list)):
                device = device_list[i]
                # logger.info(device)
                # logger.info(type(device))
                if device_custom.deviceId in device.values():
                    # if device.get(custom_key, custom_value) is not None:
                    logger.info(custom_key)
                    logger.info(custom_value)
                    # logger.info("inside1")
                    logger.info(device)
                    return device

