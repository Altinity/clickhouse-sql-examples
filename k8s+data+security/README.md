# Kubernetes + Data + Security Talk Artifacts

Scripts and example configuration to secure databases on Kubernetes. 
They are used in the DataConLA 2023 talk [Kubernetes + Data + Security: Tips for Sleeping Well with State-of-the-Art Data Management](https://www.dataconla.com/sessions/kubernetes-data-security/)

## Problem noted in setup (private note)

Error in eksctl with iamserviceaccount:

CloudFormation Stack is corrupted if you create an iamserviceaccount with an invalid role name. 
https://github.com/eksctl-io/eksctl/issues/4918

Cure is to delete the rolled-back/failed stack. 
