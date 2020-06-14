FROM openjdk:8-jdk-alpine
MAINTAINER rajjaiswalsaumya@gmail.com
# Service Args
ARG SERVICE_JAR
ARG SERVICE_PATH
ARG SERVICE_NAME
#Exposed Variables
ENV SERVICE_JAR=$SERVICE_JAR SERVICE_PATH=$SERVICE_PATH SERVICE_NAME=$SERVICE_NAME
ENV LANG=C.UTF-8

#Create conf dir
RUN mkdir -p $SERVICE_PATH/conf
#Copy startup script
COPY entrypoint.sh $SERVICE_PATH/
#Copy libs
COPY maven/lib/ $SERVICE_PATH/lib/
#Copy service jar
COPY maven/$SERVICE_JAR $SERVICE_PATH/
#COPY any certs here and run keytool
# COPY a.pem $SERVICE_PATH/
#RUN keytool -import -alias x -file $SERVICE_PATH/a.pem -keystore $JAVA_HOME/jre/lib/security/cacerts -noprompt -store changeit
WORKDIR $SERVICE_PATH
RUN chmod a+x ./entrypoint.sh
ENTRYPOINT ./entrypoint.sh



