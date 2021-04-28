# AQS Builder
Setup the Jenkins server for [AQS](https://github.com/valentarmo/AQS) and [AQS Generators](https://github.com/valentarmo/AQS-Generator)

## Deployment
The deployment is performed using cloudformation, Ansible and python scripts.

To deploy use `setup.sh` with a configuration file.

    $ ./setup.sh <Configuration File>

The configuration file should look something like this

    JenkinsStackName="jenkins"
    JenkinsKeyName="jenkinskey"
    JenkinsKeyS3Bucket="my-key-pairs-bucket"
    JenkinsKeyS3Path="jenkinskey.pem"
    AQSStackName="aqs"
    AQSBucketsStackName="aqsbuckets"
    AQSS3GlueBucketName="aqs-glue"
    AQSS3RawDataBucketName="aqs-raw"
    AQSS3ProcessedDataBucketName="aqs-processed"
    AQSS3AthenaBucketName="aqs-athena"
    AQSS3GlueScriptsBucketName="aqs-glue-scripts"
    AQSS3TaskcatBucketName="aqs-taskcat"
    AQSGeneratorsStackName="aqsgenerators"
    AQSGeneratorsKeyName="aqsgenskey"
    AQSGeneratorsKeyS3Bucket="my-key-pairs-bucket"
    AQSGeneratorsKeyS3Path="aqsgenskey.pem"
    AQSGeneratorsDockerImageTagName="aqs-data-generators"
    AwsDefaultRegion="us-east-2"

Near the end of the server's deployment you should see the server's public ip address and its administrator password as an output from Ansible.

Copy the password and move to configure the server from a browser. During the setup wizard pick Install suggested plugins.

## Additional Server Configuration
For the pipelines for AQS and AQS Generators to work it's necessary to setup some credentials. `Manage Jenkins > Manage Credentials > Jenkins > Global Credentials > Add Credentials`

Add a Username/Password credential for Docker, put `docker-credentials` in the ID field.

Add Secret Text credentials for the AWS Access Key ID (put `aws-access-key-id` in the ID field) and AWS Secret Access Key (put `aws-secret-access-key` in the ID field)


## Pipelines
Pipeline can be easily setup by installing the Blue Ocean plugin and using a GitHub Token.

