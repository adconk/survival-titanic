#test package
setwd('~/survival-titanic')

if ("exampleModel" %in% rownames(installed.packages())){
  remove.packages("exampleModel")
}
install.packages("ExampleModel.tar.gz", repos = NULL, type = "source")
library(exampleModel)
library(jsonlite)
library(aws.s3)

request1 <- s3readRDS(paste0("s3://", package_s3_bucket, "/", package_s3_key, "/request.rds"))
test = prettify(request1)
write_json(test, "package_test2.json")
request = jsonlite::fromJSON(txt = 'package_test2.json')
print(exampleModel::get_prediction(request))
rm(request)
