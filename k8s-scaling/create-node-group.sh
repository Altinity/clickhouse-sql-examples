#!/bin/bash
set -x
eksctl create nodegroup --config-file eks-nodegroups.yaml 
