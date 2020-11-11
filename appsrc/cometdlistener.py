import asyncio
from aiosfstream import SalesforceStreamingClient
from libs import queuer, logs, rabbitmq_utils, config, postgres, utils



LOGGER = logs.LOGGER


CONSUMER_KEY=config.CONSUMER_KEY
CONSUMER_SECRET=config.CONSUMER_SECRET
USERNAME=config.USERNAME
PASSWORD=config.PASSWORD
TOPICS=config.TOPICS


SERVICE_NAME='cometdrabbit'

async def stream_events():
    # connect to Streaming API
    async with SalesforceStreamingClient( sandbox=config.SANDBOX, consumer_key=CONSUMER_KEY, consumer_secret=CONSUMER_SECRET, username=USERNAME, password=PASSWORD) as client:
        topics=[]
        for topic in TOPICS.split(";"):
        
            LOGGER.debug("Subscribing to {}".format(topic))
            topics.append(topic[1:len(topic)].replace('/','_'))
            await client.subscribe(topic)
        #
        if (config.QUEUING_SYSTEM == config.QUEUING_KAFKA):
            LOGGER.warn("Before receiving any messages, MAKE SURE TO CREATE THE FOLLOWING TOPICS ON KAFKA")
        LOGGER.warn(topics)

        # listen for incoming messages
        async for message in client:
            LOGGER.info("Message Received => {} ".format(message))
            jobid =  message['data']['schema'] + '.' + str(message['data']['event']['replayId'])
            
            # stores in database
            postgres.insertRemoteCompute(jobid, message)
            message['jobid'] = jobid
            
            # saves current status & send a notification
            utils.serviceTracesAndNotifies(message, SERVICE_NAME, SERVICE_NAME + ' - Your request has been received. Job is being queued.', True)

            #must forward this to the ComputeService__c queue
            newTopicName = message['data']['payload']['ComputeService__c']
            LOGGER.info("New Topic Name -> {}".format(newTopicName))
            queuer.sendToQueuer(message, newTopicName)

            utils.serviceTracesAndNotifies(message, SERVICE_NAME, SERVICE_NAME + ' - Job queued to desired service', False)

if __name__ == "__main__":
    queuer.initQueuer()
    loop = asyncio.get_event_loop()
    loop.run_until_complete(stream_events())