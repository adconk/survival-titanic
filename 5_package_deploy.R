# package build

## setup
source("~/survival-titanic/0_install.R")
setwd('~/survival-titanic')

## begin
system("rm -rf exampleModel")
system("mkdir exampleModel")
system("mkdir exampleModel/man")
system("cp DESCRIPTION exampleModel/")
system("cp -rf R exampleModel/R")
setwd('exampleModel')
devtools::document()
setwd('..')
system("rm -rf ExampleModel.tar.gz")
tar("ExampleModel.tar.gz", files="exampleModel")
system(paste0("aws s3 cp ExampleModel.tar.gz s3://", package_s3_bucket, "/", package_s3_key, "/ExampleModel.tar.gz"))
