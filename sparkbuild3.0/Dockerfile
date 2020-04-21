# * *****************************************************************************
# *
# *  Pentaho Data Integration
# *
# *  Copyright (C) 2002-2020 by Hitachi Vantara : http://www.pentaho.com
# *
# *  *******************************************************************************
# *  Licensed under the Apache License, Version 2.0 (the "License"); you may not use
# *  this file except in compliance with the License. You may obtain a copy of the
# *  License at
# *
# *     http://www.apache.org/licenses/LICENSE-2.0
# *
# *  Unless required by applicable law or agreed to in writing, software
# *  distributed under the License is distributed on an "AS IS" BASIS,
# *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# *  See the License for the specific language governing permissions and
# *  limitations under the License.
# *
# * *****************************************************************************
FROM baudekin/openjdk8_build:v0.1.2

ENV SPARK_MIRROR http://apache.mirrors.pair.com/spark
ENV SPARK_VERSION 3.0.0-preview2
ENV MAVEN_OPTS "-Xmx4g -XX:ReservedCodeCacheSize=2g"

RUN mkdir /opt/spark

# Build and install spark
WORKDIR /tmp
RUN wget ${SPARK_MIRROR}/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}.tgz
RUN tar zxf ./spark-${SPARK_VERSION}.tgz  

WORKDIR ./spark-${SPARK_VERSION}
RUN ./dev/make-distribution.sh --name hitachi-ldl-spark -Pkubernetes -Phadoop-2.7 -Dhadoop.version=2.8.2 -DskipTests 

ENV SPARK_HOME /opt/spark
WORKDIR ${SPARK_HOME}/jars 
RUN cp -R /tmp/spark-${SPARK_VERSION}/dist/* ${SPARK_HOME}/
#RUN wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk/1.11.234/aws-java-sdk-1.11.234.jar 
#RUN wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-core/1.11.234/aws-java-sdk-core-1.11.234.jar 
#RUN wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-kms/1.11.234/aws-java-sdk-kms-1.11.234.jar 
#RUN wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.8.2/hadoop-aws-2.8.2.jar 
#RUN wget https://repo1.maven.org/maven2/org/apache/httpcomponents/httpclient/4.5.3/httpclient-4.5.3.jar 
#RUN wget https://repo1.maven.org/maven2/joda-time/joda-time/2.9.9/joda-time-2.9.9.jar  
#RUN wget https://repo1.maven.org/maven2/log4j/log4j/1.2.7/log4j-1.2.7.jar 
RUN rm -rf /tmp/*

WORKDIR ${SPARK_HOME}
RUN cp ${SPARK_HOME}/kubernetes/dockerfiles/spark/entrypoint.sh /opt/
ENTRYPOINT [ "/bin/bash" ]
