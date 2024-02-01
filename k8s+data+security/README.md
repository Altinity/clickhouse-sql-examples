# Kubernetes + Data + Security Talk Artifacts

Scripts and example configuration to secure databases on Kubernetes. 
They are used in the DataConLA 2023 talk [Kubernetes + Data + Security: Tips for Sleeping Well with State-of-the-Art Data Management](https://www.dataconla.com/sessions/kubernetes-data-security/)

## How to test S3 connections

Test S3 credentials by reading and writing S3 endpoints. Here's an example
of writing to an endpoint.  The URL in the s3() function all must match
the prefix given by the Secret value "AWS_S3_ENDPOINT".

```
INSERT INTO FUNCTION 
s3('https://s3.us-west-2.amazonaws.com/my-playground-1/data/foo.parquet', 'Parquet')
SELECT 1;
```

You can check that it worked by reading the value back. 

```
SELECT * FROM
s3('https://s3.us-west-2.amazonaws.com/my-playground-1/data/foo.parquet', 'Parquet')
```

## Problem noted in setup (private note)

Error in eksctl with iamserviceaccount:

CloudFormation Stack is corrupted if you create an iamserviceaccount with an invalid role name. 
https://github.com/eksctl-io/eksctl/issues/4918

Cure is to delete the rolled-back/failed stack. 
