import boto3
import time
import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    log_group_name = event['log_group_name']
    log_stream_name = event['log_stream_name']
    success_signal = event['success_signal']
    fail_signal = "%\[ERROR]%"
    region = event['region']


    logger.info("Log Group Name: {0}".format(log_group_name))
    logger.info("Log Stream Name: {0}".format(log_stream_name))
    logger.info("Configured Success Signal: '{0}'".format(success_signal))
    logger.info("Configured Fail Signal: '{0}'".format(fail_signal))
    logger.info("Region: {0}".format(region))

    client = boto3.client('logs', region_name=region)
    try:
        while True:
            response = client.filter_log_events(
                logGroupName=log_group_name,
                logStreamNames=[log_stream_name],
                filterPattern=success_signal
            )
            error_response = client.filter_log_events(
                logGroupName=log_group_name,
                logStreamNames=[log_stream_name],
                filterPattern=fail_signal
            )
            if response['events']:
                logger.info('Script completed successfully')
                return {
                    'statusCode': 200,
                    'body': json.dumps(event['success_signal'])
                }
            elif error_response['events']:
                custom_error = 'Exception: Script failed to complete. Error message:' + error_response['events'][0]['message']
                error_response_message = {
                    'statusCode': 500,
                    'body': custom_error
                }
                raise Exception(error_response_message)
            else:
                time.sleep(10)
                logger.info('Waiting for script to complete...')
    except Exception as e:
        logger.error(f"Exception encountered: {e}")
        raise e