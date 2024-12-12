import uuid
import boto3
import json

def lambda_handler(event, context):
    ssmClient = boto3.client('ssm')
    physicalResourceId = str(uuid.uuid4())

    if 'PhysicalResourceId' in event:
        physicalResourceId = event['PhysicalResourceId']

    try:
        if event['ResourceProperties']['Action'] == 'Create':
            if 'Password' not in event['ResourceProperties'] or not event['ResourceProperties']['Password']:
                return {
                    'statusCode': 400,
                    'body': json.dumps({
                        'message': 'Password not provided',
                    })
                }

            ssmClient.put_parameter(
                Name=physicalResourceId,
                Value=event['ResourceProperties']['Password'],
                Type='SecureString'
            )
            print('Password has been stored in SSM Parameter Store successfully. SsmId: ' + physicalResourceId)
            response = {'SsmId': physicalResourceId}
            return {
                'statusCode': 200,
                'body': json.dumps({
                    'message': 'Parameter created successfully',
                    'response': response,
                })
            }

        elif event['ResourceProperties']['Action'] == 'Delete':
            ssmClient.delete_parameter(Name=event['ResourceProperties']['SsmId'])
            print('Password successfully deleted. SsmId: ' + event['ResourceProperties']['SsmId'])
            return {
                'statusCode': 200,
                'body': json.dumps({
                    'message': 'Password successfully deleted',
                })
            }

    except ssmClient.exceptions.ParameterNotFound:
        print('Item already removed')
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Item already removed',
            })
        }

    except Exception as E:
        print(E)
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': str(E),
            })
        }