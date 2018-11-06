#AWS
package_s3_bucket <<- "origent-serverless-demo"
package_s3_key <<- "survival-titanic"

#R
install.packages('dplyr', repos='http://cran.us.r-project.org')
install.packages('gbm', repos='http://cran.us.r-project.org')
install.packages('aws.s3', repos='http://cran.us.r-project.org')

#PYTHON
system(paste0("pip3 uninstall -y serveRless"))
system(paste0("rm serveRless-0.0.1.tar.gz"))
system(paste0("aws s3 cp s3://", package_s3_bucket, "/", package_s3_key, "/serveRless-0.0.1.tar.gz", " serveRless-0.0.1.tar.gz"))
system(paste0("pip3 install serveRless-0.0.1.tar.gz"))
