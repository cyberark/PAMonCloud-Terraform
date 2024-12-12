import json
import boto3
import uuid

def lambda_handler(event, context):
    physicalResourceId = str(uuid.uuid4())
    if 'PhysicalResourceId' in event:
        physicalResourceId = event['PhysicalResourceId']

    try:
        print("Start RemovePermissionLambda execution")
        client = boto3.client('iam')

        # Gather roles and policies info
        vault_role = client.get_role(RoleName=event['ResourceProperties']['VaultRoleName'])['Role']
        lambda_role = client.get_role(RoleName=event['ResourceProperties']['LambdaRoleName'])['Role']
        print("Found Vault IAM Role Name: {0}, ID: {1}".format(vault_role["RoleName"], vault_role["RoleId"]))
        print("Found Lambda IAM Role Name: {0}, ID: {1}".format(lambda_role["RoleName"], lambda_role["RoleId"]))

        vault_policies = ["Instance_SSM_Policy", "Instance_S3_Policy", "Instance_KMS_Policy"]
        lambda_policies = ["Lambda_RemovePermissions_Policy"]

        # Delete old Policies
        print("Trying to delete inline policies from roles")
        for role, policies in [(vault_role, vault_policies), (lambda_role, lambda_policies)]:
            print("Deleting policies from role: {0}".format(role["RoleName"]))
            for policy in policies:
                try:
                    client.delete_role_policy(RoleName=role["RoleName"], PolicyName=policy)
                    print("Deleted policy: {0}".format(policy))
                except client.exceptions.NoSuchEntityException:
                    print("Policy not found: {0}".format(policy))

        print("Finished deleting inline policies from roles")

        # Get KMS ID
        kms = boto3.client('kms', region_name=event['ResourceProperties']['Region'])
        kms_arn = kms.describe_key(KeyId="alias/vault/{0}".format(event['ResourceProperties']['Instance']))['KeyMetadata']['Arn']
        print("Retrieved KMS ARN: {0}".format(kms_arn))

        # Create inline policy
        kms_policy = {
            "Statement": [
                {
                    "Action": [
                        "kms:Encrypt",
                        "kms:Decrypt"
                    ],
                    "Resource": kms_arn,
                    "Effect": "Allow"
                }
            ]
        }

        response = client.put_role_policy(
            RoleName=vault_role['RoleName'],
            PolicyName="Instance_KMS_Policy",
            PolicyDocument=json.dumps(kms_policy)
        )
        print("Added new restricted Instance_KMS_Policy to role: {0}, ID: {1}".format(vault_role["RoleName"], vault_role["RoleId"]))

        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Lambda executed successfully',
                'PhysicalResourceId': physicalResourceId,
                'response': response
            })
        }

    except Exception as E:
        print("Error in Lambda execution: {0}".format(E))
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Error in Lambda execution: {}'.format(str(E)),
                'PhysicalResourceId': physicalResourceId
            })
        }