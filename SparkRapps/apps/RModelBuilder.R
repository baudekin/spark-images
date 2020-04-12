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
library(SparkR)

sparkR.session()
# Prepare Data 
sdmtLoc <- "file:///Users/mbodkin/src/r/disney/data/SDMT"
modelLoc <- "file:///Users/mbodkin/src/r/disney/models/NaiveBayes01"

sdmt <- read.parquet(sdmtLoc)
rawdata <- drop(sdmt, "Time")
rawdata <- withColumn(rawdata, "RideCondition", round(abs(randn(42L)) * 10))

# Split Data
trainingData <- sample_frac(rawdata, FALSE, 0.8, 42L)
testingData <- sample_frac(sdmt, FALSE, 0.2, 42L)

model <- spark.naiveBayes(trainingData, RideCondition ~ .)
prediction <- predict(model, testingData)
p <- limit(prediction, 5)
collect(select(p, "Time", "prediction"))
write.ml(model, modelLoc)

m <- read.ml(modelLoc)
prediction <- predict(m, testingData)
p <- limit(prediction, 5)
collect(select(p, "Time", "prediction"))
