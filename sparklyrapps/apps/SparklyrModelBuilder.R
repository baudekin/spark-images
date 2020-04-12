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
library(sparklyr)
library(dplyr)

sc <- spark_connect( config = spark_config_kubernetes(
  "k8s://https://192.168.99.103:8443",
  account = "default",
  image = "localhost:5000/spark-r:Minikube_vspark2.4.4-R3.6.3-01",
  version = "2.4.5"))

# Get the combined files
sdmt <- spark_read_parquet(sc, "sdmt_view", "file:///Users/mbodkin/src/r/disney/data/SDMT")

# List column names
colnames(sdmt)

# Count observations
count(sdmt)

# Drop Time
#sdmt %>% sample_n(2) %>% select(-c("Time")) %>% collect()

# Add a random column and see the results
# sdmt %>% select(-c("Time")) %>% sample_n(3) %>% mutate(RideCondition = round( rand() * 10 ) ) %>% select(c("RideCondition")) %>% collect()
# sdmt %>% select(-c("Time")) %>% sample_n(2) %>% mutate(RideCondition = round( randn(42L) * 10 ) ) %>% select(c("RideCondition"))

# create dataset 
rawdata <- sdmt %>% select(-c("Time")) %>% mutate(RideCondition = round( randn(42L) * 10 ) )

# split dataset into training and testing  set
data_splits <- sdf_random_split(rawdata, training = 0.8, testing = 0.2, seed = 42)
train <- data_splits$training
testing <- data_splits$testing

# Create a predition model that predicts teh RideCondition based on the trues
# and falses
model <- train %>% ml_naive_bayes(RideCondition ~ .)

# Let's see how well we did
pred <- ml_predict(model, testing)
ml_multiclass_classification_evaluator(pred)

# Normal Usagei using sdmt sample size 5
ml_predict(model, sdmt %>% sample_n(5)) %>% select(c("Time", "prediction"))

# Persist the model to disk
ml_save(model, "file:///Users/mbodkin/src/r/disney/models/mlmodel_03", overwrite = FALSE)
