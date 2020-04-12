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
FROM baudekin/sparkrbuild3.6.3:v0.1.0

# Uncomment the lines below to install dplyr 0.8.5 when it is nolonger the latest
# RUN R -e "install.packages("https://cran.r-project.org/src/contrib/Archive/dplyr/dplyr_0.8.5.tar.gz", repos=NULL, type="source", dependencies=TRUE)"
# RUN R -e "install.packages("https://cran.r-project.org/src/contrib/Archive/sparklyr/sparklyr_1.1.0.tar.gz", repos=NULL, type="source", dependencies=TRUE)"
RUN R -e "install.packages(c('sparklyr', 'dbplyr'), repos = 'http://cran.us.r-project.org', dependencies=TRUE)"

ENV SPARKLYR_HOME /opt/sparklyr
RUN mkdir -p ${SPARKLYR_HOME}
RUN cp ${R_HOME}/library/sparklyr/R/sparklyr  ${SPARKLYR_HOME}
RUN cp ${R_HOME}/library/sparklyr/java/*.jar  ${SPARKLYR_HOME}
WORKDIR /opt/spark/work-dir
ENTRYPOINT [ "/opt/entrypoint.sh" ]
