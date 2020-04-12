#*******************************************************************************
#*
#* Copyright (C) 2002-2020 by Hitachi Vantara : http://www.pentaho.com
#*
#*******************************************************************************
#*
#* Licensed under the Apache License, Version 2.0 (the "License");
#* you may not use this file except in compliance with
#* the License. You may obtain a copy of the License at
#*
#*    http://www.apache.org/licenses/LICENSE-2.0
#*
#* Unless required by applicable law or agreed to in writing, software
#* distributed under the License is distributed on an "AS IS" BASIS,
#* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express *  or implied.
#* See the License for the specific language governing permissions and
#* limitations under the License.
#* ******************************************************************************
from __future__ import print_function

from pyspark.sql import SparkSession, DataFrame, Row
from pyspark.sql.functions import asc, desc, current_timestamp, date_format
from datetime import datetime

if __name__ == "__main__":

    spark = SparkSession.builder\
        .appName("TSMMPythonDataGenerator")\
        .getOrCreate()

    tsmmdata_fn = "s3a://input/TSMM_AB_2019-11-04_09-56-00.parquet"
    tsmmdata = spark.read.parquet(tsmmdata_fn)

    print("Started Processing data from templates")
    # Replace Current time column with our own
    timedata = tsmmdata.drop("Time")
    # Match Disney format
    timedata = timedata.withColumn("Time", date_format(current_timestamp(), "yyyy-MM-dd hh:mm:ss"))

    # Write new TSMM data
    currentdate = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    tsmmdata_out_fn = """s3a://output/TSMM""" + """.parquet""" 
    print('Writting to {0} with {1} records'.format(tsmmdata_out_fn, timedata.count()))
    # See if timestamp screwing up parquet
    timedata.coalesce(1).write.mode('append').parquet(tsmmdata_out_fn)
    print('Finished Processing data from templates for timeframe: {0}'.format(currentdate))

    spark.stop()
