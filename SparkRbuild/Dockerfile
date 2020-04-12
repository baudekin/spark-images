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
FROM baudekin/spark2.4.5_sparkbuild:v0.1.0

WORKDIR /tmp
RUN wget https://cran.r-project.org/src/base/R-3/R-3.6.3.tar.gz 
RUN gunzip R-3.6.3.tar.gz 
RUN tar xvf  R-3.6.3.tar 
WORKDIR /tmp/R-3.6.3
RUN ./configure --without-x
RUN make
RUN make install

ENV R_HOME /usr/local/lib/R

RUN rm -rf /tmp/*

# Get SparkR binary and place it in R directory under spark home
# Uncomment the line below to install Spark 2.4.5 when it is nolonger the latest
# RUN R -e "install.packages("https://cran.r-project.org/src/contrib/Archive/SparkR/SparkR_2.4.5.tar.gz", repos=NULL, type="source", dependencies=TRUE)"
RUN R -e "install.packages(c('SparkR'), repos = 'http://cran.us.r-project.org', dependencies=TRUE)"
RUN cp -R /usr/local/lib/R/library/SparkR/R ${SPARK_HOME}

WORKDIR /opt/spark/work-dir
ENTRYPOINT [ "/opt/entrypoint.sh" ]
