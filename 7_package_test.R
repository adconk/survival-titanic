#test package
setwd('~/survival-titanic')

if ("exampleModel" %in% rownames(installed.packages())){
  remove.packages("exampleModel")
}

system(paste0("aws s3 cp s3://", package_s3_bucket, "/", package_s3_key, "/ExampleModel.tar.gz", " ExampleModel.tar.gz"))
install.packages("ExampleModel.tar.gz", repos = NULL, type = "source")

library(exampleModel)
library(jsonlite)
library(aws.s3)

request = jsonlite::fromJSON(txt = 'package_test.json')
print(exampleModel::get_prediction(request))
rm(request)
