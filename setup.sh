#!/bin/bash

config_file_help() {
    echo "The Configuration File should have the following Key-Value pairs:
            JenkinsStackName=<Name for the Stack of the Builder>
            JenkinsKeyName=<EC2 Key Pair Name for the Builder Instance>
            JenkinsKeyS3Bucket=<Name of the S3 Bucket with the Key for the Jenkins Instance>
            JenkinsKeyS3Path=<Path of the Key withing the Bucket>
            AQSStackName=<Name for the Stack of the Data Lake>
            AQSBucketsStackName=<Name for the Stack of the data lake's buckets>
            AQSS3GlueBucketName=<Name of the bucket for glue>
            AQSS3RawDataBucketName=<Name of the bucket for raw data>
            AQSS3ProcessedDataBucketName=<Name of the bucket for processed data>
            AQSS3AthenaBucketName=<Name of the bucket for athena>
            AQSS3GlueScriptsBucketName=<Name of the bucket for glue scripts>
            AQSS3TaskcatBucketName=<Name of the bucket for taskcat>
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
    exit 1
else
    source $1
fi

JenkinsStackName="${JenkinsStackName/$'\r'/}"
JenkinsKeyName="${JenkinsKeyName/$'\r'/}"
JenkinsKeyS3Bucket="${JenkinsKeyS3Bucket/$'\r'/}"
JenkinsKeyS3Path="${JenkinsKeyS3Path/$'\r'/}"

AQSStackName="${AQSStackName/$'\r'/}"

AQSBucketsStackName="${AQSBucketsStackName/$'\r'/}"
AQSS3GlueBucketName="${AQSS3GlueBucketName/$'\r'/}"
AQSS3RawDataBucketName="${AQSS3RawDataBucketName/$'\r'/}"
AQSS3ProcessedDataBucketName="${AQSS3ProcessedDataBucketName/$'\r'/}"
AQSS3AthenaBucketName="${AQSS3AthenaBucketName/$'\r'/}"
AQSS3GlueScriptsBucketName="${AQSS3GlueScriptsBucketName/$'\r'/}"
AQSS3TaskcatBucketName="${AQSS3TaskcatBucketName/$'\r'/}"

AQSGeneratorsStackName="${AQSGeneratorsStackName/$'\r'/}"
AQSGeneratorsKeyName="${AQSGeneratorsKeyName/$'\r'/}"
AQSGeneratorsKeyS3Bucket="${AQSGeneratorsKeyS3Bucket/$'\r'/}"
AQSGeneratorsKeyS3Path="${AQSGeneratorsKeyS3Path/$'\r'/}"
AQSGeneratorsDockerImageTagName="${AQSGeneratorsDockerImageTagName/$'\r'/}"
AQSGeneratorsNumberOfInstances="${AQSGeneratorsNumberOfInstances/$'\r'/}"

AwsDefaultRegion="${AwsDefaultRegion/$'\r'/}"

if [ -z "$JenkinsStackName" ]; then
    echo "Missing JenkinsStackName"
    config_file_help
    exit 1
fi

if [ -z "$JenkinsKeyName" ]; then
    echo "Missing JenkinsKeyName"
    config_file_help
    exit 1
fi

if [ -z "$JenkinsKeyS3Bucket" ]; then
    echo "Missing JenkinsKeyS3Bucket"
    config_file_help
    exit 1
fi

if [ -z "$JenkinsKeyS3Path" ]; then
    echo "Missing JenkinsKeyS3Path"
    config_file_help
    exit 1
fi

if [ -z "$AQSStackName" ]; then
    echo "Missing AQSStackName"
    config_file_help
    exit 1
fi

if [ -z "$AQSBucketsStackName" ]; then
    echo "Missing AQSBucketsStackName"
    config_file_help
    exit 1
fi

if [ -z "$AQSS3GlueBucketName" ]; then
    echo "Missing AQSS3GlueBucketName"
    config_file_help
    exit 1
fi

if [ -z "$AQSS3RawDataBucketName" ]; then
    echo "Missing AQSS3RawDataBucketName"
    config_file_help
    exit 1
fi

if [ -z "$AQSS3ProcessedDataBucketName" ]; then
    echo "Missing AQSS3ProcessedDataBucketName"
    config_file_help
    exit 1
fi

if [ -z "$AQSS3AthenaBucketName" ]; then
    echo "Missing AQSS3AthenaBucketName"
    config_file_help
    exit 1
fi

if [ -z "$AQSS3GlueScriptsBucketName" ]; then
    echo "Missing AQSS3GlueScriptsBucketName"
    config_file_help
    exit 1
fi

if [ -z "$AQSS3TaskcatBucketName" ]; then
    echo "Missing AQSS3TaskcatBucketName"
    config_file_help
    exit 1
fi

if [ -z "$AQSGeneratorsStackName" ]; then
    echo "Missing AQSGeneratorsStackName"
    config_file_help
    exit 1
fi

if [ -z "$AQSGeneratorsKeyName" ]; then
    echo "Missing AQSGeneratorsKeyName"
    config_file_help
    exit 1
fi

if [ -z "$AQSGeneratorsKeyS3Bucket" ]; then
    echo "Missing AQSGeneratorsKeyS3Bucket"
    config_file_help
    exit 1
fi

if [ -z "$AQSGeneratorsKeyS3Path" ]; then
    echo "Missing AQSGeneratorsKeyS3Path"
    config_file_help
    exit 1
fi

if [ -z "$AQSGeneratorsDockerImageTagName" ]; then
    echo "Missing AQSGeneratorsDockerImageTagName"
    config_file_help
    exit 1
fi

if [ -z "$AQSGeneratorsNumberOfInstances" ]; then
    echo "Missing AQSGeneratorsNumberOfInstances"
    config_file_help
    exit 1
fi

if [ -z "$AwsDefaultRegion" ]; then
    echo "Missing AwsDefaultRegion"
    config_file_help
    exit 1
fi

export AQS_STACK_NAME="$AQSStackName"

export AQS_GENERATORS_STACK_NAME="$AQSGeneratorsStackName"
export AQS_GENERATORS_KEY_NAME="$AQSGeneratorsKeyName"
export AQS_GENERATORS_KEY_S3_BUCKET="$AQSGeneratorsKeyS3Bucket"
export AQS_GENERATORS_KEY_S3_PATH="$AQSGeneratorsKeyS3Path"
export AQS_GENERATORS_DOCKER_IMAGE_TAG_NAME="$AQSGeneratorsDockerImageTagName"
export AQS_GENERATORS_NUMBER_OF_INSTANCES="$AQSGeneratorsNumberOfInstances"

export AQS_BUCKETS_STACK_NAME="$AQSBucketsStackName"
export AQS_S3_GLUE_BUCKET_NAME="$AQSS3GlueBucketName"
export AQS_S3_RAW_DATA_BUCKET_NAME="$AQSS3RawDataBucketName"
export AQS_S3_PROCESSED_DATA_BUCKET_NAME="$AQSS3ProcessedDataBucketName"
export AQS_S3_ATHENA_BUCKET_NAME="$AQSS3AthenaBucketName"
export AQS_S3_GLUE_SCRIPTS_BUCKET_NAME="$AQSS3GlueScriptsBucketName"
export AQS_S3_TASKCAT_BUCKET_NAME="$AQSS3TaskcatBucketName"

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
