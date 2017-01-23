#!/usr/bin/env bash

# This script build initial base docker images to be used in app cloud setup.
CURRENT_DIR=`pwd`
rm $CURRENT_DIR/lambda/base/1.0.0/core-1.0-SNAPSHOT.jar
rm $CURRENT_DIR/lambda/base/1.0.0/WSO2FunctionClient-1.0-SNAPSHOT.jar
cp /home/maanadev/WSO2_CLOUD/LambdaCore/target/core-1.0-SNAPSHOT.jar lambda/base/1.0.0/
cp /home/maanadev/WSO2_CLOUD/Wso2FunctionClient/target/WSO2FunctionClient-1.0-SNAPSHOT.jar lambda/base/1.0.0/
docker build --no-cache -t wso2-appcloud/wso2-cloud/lambda:1.0.0-alpine3.4-oracle-jdk1.8.0 -f $CURRENT_DIR/lambda/base/1.0.0/Dockerfile.wso2-appcloud-lambda-1.0.0.base $CURRENT_DIR/lambda/base/1.0.0/

