# Cloud Native ClickHouse Scaling Examples

This directory has YAML files and commands to illustrate how to scale
resources up and down. 

# Demo of stop property

The following files set up a demo of use of the stop property to turn 
off compute for ClickHouse. The operator implements by dialing down 
the replica count for each stateful set to zero. 

```
# Start ClickHouse. 
kubectl apply -f chi-stop-00.yaml
# Pause compute. 
kubectl apply -f chi-stop-01.yaml
# Restore compute. 
kubectl apply -f chi-stop-02.yaml
```
