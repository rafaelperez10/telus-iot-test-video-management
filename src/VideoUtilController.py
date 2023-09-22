from aws.AWSServices import APIGateway
from robot.api import logger


class VideoUtilController:

    @staticmethod
    def video_api_gateway(api_name):
        apigateway = APIGateway()
        video_api = apigateway.get_api_details(api_name)
        logger.info(video_api)
        return video_api

    @staticmethod
    def validate_list(list_data, key_name):
        logger.info(type(list_data))
        endpoint_list = list_data.get(key_name)
        logger.info(list_data)
        return len(endpoint_list)

    @staticmethod
    def get_key_value_from_list_dic(list_data, key_name):
        key_value = ''
        logger.info(type(list_data))
        for i in range(len(list_data)):
            dict_resp = list_data[i]
            key_value = dict_resp.get(key_name)
        return key_value
