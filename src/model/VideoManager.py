class Device:
    def __init__(self, deviceId='', householdId='', videoRetentionPeriodInHours=0, maximumNumberOfWebRTCSessions=0,
                 webRTCSessionProtocols=[]):
        self.deviceId = deviceId
        self.householdId = householdId
        self.videoRetentionPeriodInHours = videoRetentionPeriodInHours
        self.maximumNumberOfWebRTCSessions = maximumNumberOfWebRTCSessions
        self.webRTCSessionProtocols = webRTCSessionProtocols


class Event:
    def __init__(self, eventType='', eventId='', deviceId='', householdId='', intervalId='', producerTimeStamp='',
                 status=''):
        self.eventType = eventType
        self.eventId = eventId
        self.deviceId = deviceId
        self.householdId = householdId
        self.intervalId = intervalId
        self.producerTimeStamp = producerTimeStamp
        self.status = status


class EventBusDevice:
    def __init__(self, deviceId=None, householdId=None, alias=None, maximumNumberOfWebRTCSessions=None,
                 videoRetentionPeriodInHours=None, webRTCSessionProtocols=[]):
        self.deviceId = deviceId
        self.householdId = householdId
        self.alias = alias
        self.maximumNumberOfWebRTCSessions = maximumNumberOfWebRTCSessions
        self.videoRetentionPeriodInHours = videoRetentionPeriodInHours
        self.webRTCSessionProtocols = webRTCSessionProtocols


class StartInterval:
    def __init__(self, StreamArn=None, FragmentNumber=None, FragmentStartProducerTimestamp=None,
                 FragmentStartServerTimestamp=None, NotificationType=None, NotificationPayload=None):
        self.StreamArn = StreamArn
        self.FragmentNumber = FragmentNumber
        self.FragmentStartProducerTimestamp = FragmentStartProducerTimestamp
        self.FragmentStartServerTimestamp = FragmentStartServerTimestamp
        self.NotificationType = NotificationType
        self.NotificationPayload = NotificationPayload


class StartNotificationPayload:
    def __init__(self, MESSAGE=None, PRODUCER_TIMESTAMP=None, HOUSEHOLD_ID=None, STREAM=None, ID=None, DEVICE_ID=None, TYPE=None):
        self.MESSAGE = MESSAGE
        self.PRODUCER_TIMESTAMP = PRODUCER_TIMESTAMP
        self.HOUSEHOLD_ID = HOUSEHOLD_ID
        self.STREAM = STREAM
        self.ID = ID
        self.DEVICE_ID = DEVICE_ID
        self.TYPE = TYPE


class EndInterval:
    def __init__(self, StreamArn=None, FragmentNumber=None, FragmentStartProducerTimestamp=None, FragmentStartServerTimestamp=None, NotificationType=None, NotificationPayload=None):
        self.StreamArn = StreamArn
        self.FragmentNumber = FragmentNumber
        self.FragmentStartProducerTimestamp = FragmentStartProducerTimestamp
        self.FragmentStartServerTimestamp = FragmentStartServerTimestamp
        self.NotificationType = NotificationType
        self.NotificationPayload = NotificationPayload


class EndNotificationPayload:
    def __init__(self, MESSAGE=None, PRODUCER_TIMESTAMP=None, ID=None, TYPE=None):
        self.MESSAGE = MESSAGE
        self.PRODUCER_TIMESTAMP = PRODUCER_TIMESTAMP
        self.ID = ID
        self.TYPE = TYPE
# {
#    "StreamArn":"arn:aws:kinesisvideo:ca-central-1:364350952952:stream/SH20-eventStream-test102/1693953555611",
#    "FragmentNumber":"91343852333181556241155352923233361199335710992",
#    "FragmentStartProducerTimestamp":1694038298246,
#    "FragmentStartServerTimestamp":1694038247180,
#    "NotificationType":"PERSISTED",
#    "NotificationPayload":{
#       "MESSAGE":"FINISHING",
#       "PRODUCER_TIMESTAMP":"1694038298246379047",
#       "ID":"1694038248366379047",
#       "TYPE":"VIDEO_INTERVAL_END"
#    }
# }
