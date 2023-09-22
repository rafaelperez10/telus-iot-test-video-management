from aws.AWSServices import APIGateway
from aws.AWSServices import DynamoDB
from robot.api import logger


class VideoPlayController:

    @staticmethod
    def get_device_and_householder(pk_device):
        dinamoDB = DynamoDB()
        device = dinamoDB.get_device(pk_device)
        logger.info(device)
        return device



