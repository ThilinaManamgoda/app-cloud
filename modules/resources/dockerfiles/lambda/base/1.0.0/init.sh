#!/usr/bin/env bash
# ------------------------------------------------------------------------
#
# Copyright (c) 2016, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
#
#   WSO2 Inc. licenses this file to you under the Apache License,
#   Version 2.0 (the "License"); you may not use this file except
#   in compliance with the License.
#   You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing,
#   software distributed under the License is distributed on an
#   "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#   KIND, either express or implied.  See the License for the
#   specific language governing permissions and limitations
#   under the License.
#
# ------------------------------------------------------------------------

#Check whether JAVA_OPTS env variable is defined and not empty
if [[ $JAVA_OPTS && ${JAVA_OPTS-_} ]]; then
	export JAVA_OPTS=$JAVA_OPTS
else
    #Calculate max heap size and the perm size for Java Opts
    #Check whether TOTAL_MEMORY env variable defined or and not empty
	if [[ $TOTAL_MEMORY && ${TOTAL_MEMORY-_} ]]; then
	    let MAX_HEAP_SIZE=$TOTAL_MEMORY/256*128
	    let MAX_META_SPACE_SIZE=$TOTAL_MEMORY/256*128
	    JAVA_OPTS="-Xms128m -Xmx"$MAX_HEAP_SIZE"m -XX:MaxMetaspaceSize="$MAX_META_SPACE_SIZE"m"
	    export JAVA_OPTS=$JAVA_OPTS
	fi
fi

if [[ $ENABLE_JFR && ${ENABLE_JFR-_} && $ENABLE_JFR == "true" ]]; then
    export JAVA_OPTS=$JAVA_OPTS" -XX:+UnlockCommercialFeatures -XX:+FlightRecorder -XX:StartFlightRecording=delay=20s,duration=60s,name=jfr_recording,filename=/home/wso2user/jfr_recording.jfr,settings=profile"
fi

java $JAVA_OPTS -cp .:$MSF4J_JAR:core-1.0-SNAPSHOT.jar:WSO2FunctionClient-1.0-SNAPSHOT.jar -Dtransports.netty.conf=/opt/conf/https/netty-transports.yaml org.wso2.core.service.LambdaServiceRunner