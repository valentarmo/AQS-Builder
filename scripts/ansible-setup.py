import argparse
import boto3
import time
import yaml
import sys
import os


def create_stack(stack_name, key_name, region, client):
    print('Creating CloudFormation Stack')
    dir_path = os.path.dirname(__file__)
    template_path = os.path.join(dir_path, '..', 'aws', 'cfn', 'jenkins.yaml')
    template_body = ''
    with open(template_path, 'r') as f:
        template_body = f.read()
    response = CloudFormation.create_stack(
        StackName=stack_name,
        TemplateBody=template_body,
        Parameters=[
            {'ParameterKey': 'KeyName', 'ParameterValue': key_name},
            {'ParameterKey': 'Region', 'ParameterValue': region}
        ]
    )
    return response['StackId']


def wait_until_stack_is_created(stack_name, client):
    status = client.describe_stacks(StackName=stack_name)['Stacks'][0]['StackStatus']
    while status not in ['CREATE_FAILED', 'CREATE_COMPLETE', 'ROLLBACK_COMPLETE']:
        time.sleep(5)
        status = client.describe_stacks(StackName=stack_name)['Stacks'][0]['StackStatus']
    if status == 'CREATE_FAILED' or status == 'ROLLBACK_COMPLETE':
        raise Exception('Stack Creation Failed')
    print('Stack created')


def get_host_ip(stack_name, client):
    print('Getting IP address')
    response = client.describe_stacks(StackName=stack_name)
    ip = response['Stacks'][0]['Outputs'][0]['OutputValue']
    print(f'IP Address: {ip}')
    return ip


def download_private_key(s3_bucket, key_path, key_name):
    print('Downloading Key Pair')
    s3 = boto3.client('s3')
    dir_path = os.path.dirname(__file__)
    file_name = os.path.join(dir_path, '..', key_name + '.pem')
    s3.download_file(s3_bucket, key_path, file_name)
    os.system(f'chmod 600 {file_name}')
    print(f'Key Pair Downloaded at {file_name}')
    return file_name


def create_hosts_file(host_name, private_key_path, host_ip):
    print('Creating hosts file')
    host_info = f'[{host_name}]\n{host_ip}\n\n[{host_name}:vars]\nansible_ssh_private_key_file={private_key_path}'
    dir_path = os.path.dirname(__file__)
    file_path = os.path.join(dir_path, '../', 'ansible/', 'hosts.ini')
    with open(file_path, 'w') as f:
        f.write(host_info)
    print(f'Hosts file created at {file_path}')


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--StackName', required=True, help='Name of the Stack')
    parser.add_argument('--KeyName', required=True, help='Name of the key pair to associate with the instance')
    parser.add_argument('--Region', help='Region where to create the Stack', default='us-east-2', choices=['us-west-1', 'us-east-1', 'us-west-2', 'us-east-2'])
    parser.add_argument('--PrivateKeyS3Bucket', required=True, help='S3 bucket with the .pem file')
    parser.add_argument('--PrivateKeyS3FilePath', required=True, help='Location of the .pem file in the s3 bucket')
    args = parser.parse_args()

    CloudFormation = boto3.client('cloudformation')
    try:
        create_stack(args.StackName, args.KeyName, args.Region, CloudFormation)
        wait_until_stack_is_created(args.StackName, CloudFormation)
        key_path = download_private_key(args.PrivateKeyS3Bucket, args.PrivateKeyS3FilePath, args.KeyName)
        create_hosts_file('Jenkins', key_path, get_host_ip(args.StackName, CloudFormation))
    except Exception as e:
        print(e)
        sys.exit(1)
