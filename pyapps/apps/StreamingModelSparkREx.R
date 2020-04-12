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
library(tidyverse)
library(SparkR)

sparkR.session()

sdmtdata_stream <- "s3a://output/SDMT.parquet"
predition_loc  <-  "s3a://output/PRED.parquet"
model_loc <- "s3a://models/NaiveBayes01"
cp_loc <- "file:///opt/spark/work-dir/cp"

# Write out predictions along with original input stream observations.
# The preditions are stored under a column "prediction"
obsSchema <- schema(read.parquet(sdmtdata_stream))
observations  <- read.stream(format = "parquet", path = sdmtdata_stream, schema = obsSchema, maxFilesPerTrigger = 1)
model <- read.ml(model_loc)
predictions <-  predict(model, observations)
query <- write.stream(predictions, format = "parquet", path = predition_loc, outputMode = "append", checkpointLocation = cp_loc) 
awaitTermination(query)
