#!/usr/bin/env bash

# Default ENV variables
if [ -z "$JVM_HEAP_MIN" ]; then L_HEAP_MIN="1024m"; else L_HEAP_MIN="$JVM_HEAP_MIN"; fi
if [ -z "$JVM_HEAP_MAX" ]; then L_HEAP_MAX="2048m"; else L_HEAP_MAX="$JVM_HEAP_MAX"; fi
if [ -z "$SPRING_PROFILES_ACTIVE" ]; then L_SPRING_PROFILE_ACTIVE="cloud"; else L_SPRING_PROFILE_ACTIVE="$SPRING_PROFILES_ACTIVE"; fi

JAVA_ARGS_SERVER="-server -Dcatalina.base=$APP_HOME"
JAVA_ARGS_APP_HOME="-DAPP_HOME=$APP_HOME"
JAVA_ARGS_SERVICE_NAME="-DMICRO_SERVICE_NAME=$SERVICE_NAME"
JAVA_ARGS_PROFILES="-Dspring.profiles.active=$L_SPRING_PROFILE_ACTIVE"
JAVA_ARGS_MEMORY="=Xms$L_HEAP_MIN -Xmx$L_HEAP_MAX"
JAVA_ARGS_OTHER="-XX:+UseG1GC -XX:++PrintGCDetails
                -Xloggc:$SERVICE_PATH/logs/jvm/gc/gc.log
                -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=5
                -XX:GCLogFileSize=10M -XX:+HeapDumpOnOutOfMemoryError
                -XX:HeapDumpPath=$SERVICE_PATH/logs/jvm/heap/
                -XX:+PrintGCDateStamps"

JAVA_ARGS_LOGBACKFILE="-Dlogback.configurationFile=$APP_HOME/conf/logback.xml"
if echo "$L_SPRING_PROFILE_ACTIVE" | grep -q "\\<debug\\>"; then
  # Add this iff docker container is in debug profile
  JAVA_ARGS_DEBUG="$SERVICE_DEBUG_ARGS"
else
  # Reset this for security reasons
  JAVA_ARGS_DEBUG=""
fi

JAVA_ARGS="$JAVA_ARGS_SERVER $JAVA_ARGS_APP_HOME $JAVA_ARGS_SERVICE_NAME $JAVA_ARGS_MEMORY $JAVA_ARGS_PROFILES $JAVA_ARGS_LOGBACKFILE $JAVA_ARGS_OTHER $JAVA_ARGS_DEBUG"
java $JAVA_ARGS -jar $SERVICE_JAR