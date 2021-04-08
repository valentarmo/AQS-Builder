Setup server default everything

Sample conf file

JenkinsStackName="jenkins"
JenkinsKeyName="jenkinskey"
JenkinsKeyS3Bucket="my-key-pairs-bucket"
JenkinsKeyS3Path="jenkinskey.pem"
AQSStackName="aqs"
AQSS3BucketPrefix="my-prefix"
AQSGeneratorsStackName="aqsgenerators"
AQSGeneratorsKeyName="aqsgenskey"
AQSGeneratorsKeyS3Bucket="my-key-pairs-bucket"
AQSGeneratorsKeyS3Path="aqsgenskey.pem"
AQSGeneratorsDockerImageTagName="aqs-data-generators"
AwsDefaultRegion="us-east-2"

set up in credentials

AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
DOCKER_CREDENTIALS = credentials('docker-credentials')

recommended install blue ocean

under Configure System
set PATH+EXTRA=/usr/local/bin
