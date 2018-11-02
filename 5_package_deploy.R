# package build

## setup
source("~/survival-titanic/0_install.R")
setwd('~/survival-titanic')

## begin
system("rm -rf serveRlessModel")
system("mkdir serveRlessModel")
system("mkdir serveRlessModel/man")
system("cp DESCRIPTION serveRlessModel/")
system("cp -rf R serveRlessModel/R")
setwd('serveRlessModel')
devtools::document()
setwd('..')
system("rm -rf ServeRless-Model.tar.gz")
tar("ServeRless-Model.tar.gz", files="serveRlessModel")
system(paste0("aws s3 cp ServeRless-Model.tar.gz s3://", package_s3_bucket, "/", package_s3_key, "/ServeRless-Model.tar.gz"))
