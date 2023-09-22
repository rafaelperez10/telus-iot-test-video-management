import json

import boto3 as sdk
from robot.api import logger


class APIGateway:
    @staticmethod
    def get_api_details(api_name):
        logger.info(api_name)
        api_id = ''
        deployment_id = ''
        stage_name = ''
        api_key_value = ''
        url_value = ''
        base_path_value = ''

        # logger.info("get_rest_apis")
        apigateway = sdk.client('apigateway')
        response = apigateway.get_rest_apis(
            limit=500
        )
        # logger.info(response)
        if "items" in response:
            dict_items = response.get("items")
            for i in range(len(dict_items)):
                device = dict_items[i]
                if api_name in device.get("name"):
                    api_id = device.get("id")
                    break
                    # logger.info(device)

        logger.info('Api ID:' + api_id)
        response = ""

        # logger.info("get_deployments")
        response = apigateway.get_deployments(
            restApiId=api_id
        )
        # logger.info(response0)
        if "items" in response:
            dict_items = response.get("items")
            for i in range(len(dict_items)):
                deployment = dict_items[i]
                deployment_id = deployment.get("id")
                break
        logger.info('Deployment ID:' + deployment_id)
        # logger.info(type(response))
        response = ""

        # logger.info("get_stages")
        response = apigateway.get_stages(
            restApiId=api_id
        )
        if "item" in response:
            dict_items = response.get("item")
            for i in range(len(dict_items)):
                stage = dict_items[i]
                if deployment_id in stage.get("deploymentId"):
                    stage_name = stage.get("stageName")
                    break
        logger.info("Stage Name: " + stage_name)
        response = ""

        response = apigateway.get_export(
            restApiId=api_id,
            stageName=stage_name,
            exportType='oas30',
            accepts='application/json'
        )['body']
        response_bytes = response.read()
        response_json = json.loads(response_bytes.decode())['servers']
        for i in range(len(response_json)):
            item_list = response_json[i]
            url_value = item_list.get("url")
            base_path_value = item_list.get("variables").get("basePath").get("default")
            break
        url_final_value = url_value.replace("{basePath}", base_path_value)
        logger.info("URL: " + url_value)
        logger.info("Base Path: " + base_path_value)
        logger.info("URL Final: " + url_final_value)

        response = ""

        # logger.info("get_api_keys")
        response = apigateway.get_api_keys(
            includeValues=True
        )
        if "items" in response:
            api_key_name = api_name + '-api-key'
            dict_items = response.get("items")
            for i in range(len(dict_items)):
                api_key = dict_items[i]
                if api_key_name in api_key.get("name"):
                    api_key_value = api_key.get("value")
                    break

        logger.info("Api Key: " + api_key_value)
        return {"url": url_final_value, "api_key": api_key_value}


class DynamoDB:

    @staticmethod
    def get_device(pk_device):
        dynamodb = sdk.client('dynamodb')
        response_db = dynamodb.get_item(
            TableName='videoMgmtTable',
            Key={
                'PK': {'S': pk_device},
                'SK': {'S': pk_device}
            }
        )
        if "Item" in response_db:
            dict_items = response_db.get("Item")
            if "householdId" in dict_items:
                house_hold = dict_items.get("householdId")
                if "S" in house_hold:
                    house_hold_id = house_hold.get("S")
            if "deviceId" in dict_items:
                device = dict_items.get("deviceId")
                if "S" in device:
                    device_id = device.get("S")

            logger.info(dict_items)

            logger.info(house_hold_id)
            logger.info(device_id)
        return {'house_hold_id': house_hold_id, 'device_id': device_id}


class EventBridge:

    @staticmethod
    def publish_msg(event_source='device-creation-fake', event_type='my-detail', event_message=None,
                    event_bus_name='default'):

        logger.info('Entro01')
        event_bridge = sdk.client('events')

        response2 = event_bridge.list_event_buses(
            Limit=99
        )
        logger.info(response2)
        logger.info(event_source)
        logger.info(event_type)
        logger.info(event_bus_name)
        logger.info(json.dumps(event_message, default=vars))
        response = event_bridge.put_events(
            Entries=[
                {
                    'Source': event_source,
                    'DetailType': event_type,
                    'Detail': json.dumps(event_message, default=vars),
                    'EventBusName': event_bus_name,
                },
            ],
        )
        logger.info(response)
        return response


class SNS:

    @staticmethod
    def publish_msg_topic(topic_name=None,  topic_message=None):
        logger.info('SNS')
        logger.info(topic_name)
        logger.info(topic_message)

        sns = sdk.client('sns')
        lst_topic = sns.list_topics()
        logger.info(lst_topic)
        topic_arn = ""
        for element in lst_topic['Topics']:
        # if "video-interval-kvs-metadata" in element['TopicArn']:
            if topic_name in element['TopicArn']:
                topic_arn = element['TopicArn']
        logger.info("Topic Arn:  " + topic_arn, True, True)
        response_topic = sns.publish(
            TopicArn=topic_arn,
            Message=json.dumps({'default': json.dumps(topic_message, default=vars)}),
            MessageStructure='json',
            #            MessageDeduplicationId='3A',
            #            MessageGroupId='12'
        )
        logger.info('Response Topic')
        logger.info(response_topic)

        return response_topic


class KinesisVideo:

    @staticmethod
    def get_list_streams(stream_name=None):
        logger.info('KVS')
        logger.info(stream_name)
        kvs = sdk.client('kinesisvideo')
        response = kvs.list_streams(
            MaxResults=5000,
            StreamNameCondition={
                'ComparisonOperator': 'BEGINS_WITH',
                'ComparisonValue': stream_name
            }
        )
        logger.info(response)
        return response

    @staticmethod
    def get_signaling_channels(stream_name=None):
        logger.info('KVS')
        logger.info(stream_name)
        kvs = sdk.client('kinesisvideo')
        response = kvs.list_signaling_channels(
            MaxResults=5000,
            ChannelNameCondition={
                'ComparisonOperator': 'BEGINS_WITH',
                'ComparisonValue': stream_name
            }
        )
        logger.info(response)
        return response
