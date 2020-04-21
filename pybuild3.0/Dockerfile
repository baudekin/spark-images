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
FROM baudekin/spark3.0.0_sparkbuild:v0.1.2

WORKDIR /
# TODO: Investigate running both pip and pip3 via virtualenvs
RUN apt install -y python python-pip && \
    apt install -y python3 python3-pip && \
    # We remove ensurepip since it adds no functionality since pip is
    # installed on the image and it just takes up 1.6MB on the image
    rm -r /usr/lib/python*/ensurepip && \
    pip install --upgrade pip setuptools && \
    # You may install with python3 packages by using pip3.7
    # Removed the .cache to save space
    pip3 install --upgrade pip setuptools && \
    pip3 install pypandoc && \
    pip3 install pyspark==2.4.5 && \
    pip3 install py4j==0.10.8.1 && \
    pip3 install pyarrow==0.16.0 && \
    rm -r /root/.cache && rm -rf /var/cache/apt/*

# Create pyspark zip
ENV PYTHONPATH ${SPARK_HOME}/python/lib/pyspark.zip:${SPARK_HOME}/python/lib/py4j-*.zip

WORKDIR /opt/spark/work-dir
ENTRYPOINT [ "/opt/entrypoint.sh" ]
