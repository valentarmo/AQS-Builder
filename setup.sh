#!/bin/bash

config_file_help() {
    echo "The Configuration File should have the following Key-Value pairs:
            JenkinsStackName=<Name for the Stack of the Builder>
            JenkinsKeyName=<EC2 Key Pair Name for the Builder Instance>
            JenkinsKeyS3Bucket=<Name of the S3 Bucket with the Key for the Jenkins Instance>
            JenkinsKeyS3Path=<Path of the Key withing the Bucket>
            AQSStackName=<Name for the Stack of Stack of the Data Lake>
            AQSS3BucketPrefix=<Prefix for S3 Buckets>
            AQSGeneratorsStackName=<Name for the Stack of the Generators>
            AQSGeneratorsKeyName=<EC2 Key Pair Name for the Generator Instances>
            AQSGeneratorsKeyS3Bucket=<Name of the S3 Bucket with the Key for the Generator Instances>
            AQSGeneratorsKeyS3Path=<Path of the Key withing the Bucket>
            AQSGeneratorsDockerImageTagName=<Name for the docker tag image>
            AwsDefaultRegion=<AWS Default Region>"
}

usage() {
    echo "Usage: . ./setup <ConfigFile>"
}

if [[ $# != 1 ]]; then
    usage
    exit 2
else
    source $1
fi

JenkinsStackName="${JenkinsStackName/$'\r'/}"
JenkinsKeyName="${JenkinsKeyName/$'\r'/}"
JenkinsKeyS3Bucket="${JenkinsKeyS3Bucket/$'\r'/}"
JenkinsKeyS3Path="${JenkinsKeyS3Path/$'\r'/}"

AQSStackName="${AQSStackName/$'\r'/}"
AQSS3BucketPrefix="${AQSS3BucketPrefix/$'\r'/}"

AQSGeneratorsStackName="${AQSGeneratorsStackName/$'\r'/}"
AQSGeneratorsKeyName="${AQSGeneratorsKeyName/$'\r'/}"
AQSGeneratorsKeyS3Bucket="${AQSGeneratorsKeyS3Bucket/$'\r'/}"
AQSGeneratorsKeyS3Path="${AQSGeneratorsKeyS3Path/$'\r'/}"
AQSGeneratorsDockerImageTagName="${AQSGeneratorsDockerImageTagName/$'\r'/}"

AwsDefaultRegion="${AwsDefaultRegion/$'\r'/}"

if [ -z "$JenkinsStackName" ]; then
    echo "Missing JenkinsStackName"
    config_file_help
    exit 2
fi

if [ -z "$JenkinsKeyName" ]; then
    echo "Missing JenkinsKeyName"
    config_file_help
    exit 2
fi

if [ -z "$JenkinsKeyS3Bucket" ]; then
    echo "Missing JenkinsKeyS3Bucket"
    config_file_help
    exit 2
fi

if [ -z "$JenkinsKeyS3Path" ]; then
    echo "Missing JenkinsKeyS3Path"
    config_file_help
    exit 2
fi

if [ -z "$AQSStackName" ]; then
    echo "Missing AQSStackName"
    config_file_help
    exit 2
fi

if [ -z "$AQSS3BucketPrefix" ]; then
    echo "Missing AQSS3BucketPrefix"
    config_file_help
    exit 2
fi

if [ -z "$AQSGeneratorsStackName" ]; then
    echo "Missing AQSGeneratorsStackName"
    config_file_help
    exit 2
fi

if [ -z "$AQSGeneratorsKeyName" ]; then
    echo "Missing AQSGeneratorsKeyName"
    config_file_help
    exit 2
fi

if [ -z "$AQSGeneratorsKeyS3Bucket" ]; then
    echo "Missing AQSGeneratorsKeyS3Bucket"
    config_file_help
    exit 2
fi

if [ -z "$AQSGeneratorsKeyS3Path" ]; then
    echo "Missing AQSGeneratorsKeyS3Path"
    config_file_help
    exit 2
fi

if [ -z "$AQSGeneratorsDockerImageTagName" ]; then
    echo "Missing AQSGeneratorsDockerImageTagName"
    config_file_help
    exit 2
fi

if [ -z "$AwsDefaultRegion" ]; then
    echo "Missing AwsDefaultRegion"
    config_file_help
    exit 2
fi

export AQS_STACK_NAME="$AQSStackName"

export AQS_GENERATORS_STACK_NAME="$AQSGeneratorsStackName"
export AQS_GENERATORS_KEY_NAME="$AQSGeneratorsKeyName"
export AQS_GENERATORS_KEY_S3_BUCKET="$AQSGeneratorsKeyS3Bucket"
export AQS_GENERATORS_KEY_S3_PATH="$AQSGeneratorsKeyS3Path"
export AQS_GENERATORS_DOCKER_IMAGE_TAG_NAME="$AQSGeneratorsDockerImageTagName"

export AQS_S3_BUCKET_PREFIX="$AQSS3BucketPrefix"

export AQS_AWS_DEFAULT_REGION="$AwsDefaultRegion"

export ANSIBLE_HOST_KEY_CHECKING=false
export ANSIBLE_SSH_RETRIES=10

python scripts/ansible-setup.py --StackName "$JenkinsStackName" \
                                --KeyName "$JenkinsKeyName" \
                                --Region "$AwsDefaultRegion" \
                                --PrivateKeyS3Bucket "$JenkinsKeyS3Bucket" \
                                --PrivateKeyS3FilePath "$JenkinsKeyS3Path"
ansible-playbook -i ansible/hosts.ini ansible/jenkins.yaml
exit
