#AWS
package_s3_bucket <<- "origent-public-demo"
package_s3_key <<- "survival-titanic"

#R
#install.packages('dplyr', repos='http://cran.us.r-project.org')
#install.packages('gbm', repos='http://cran.us.r-project.org')
#install.packages('aws.s3', repos='http://cran.us.r-project.org')

#PYTHON
system(paste0("aws s3 cp s3://", package_s3_bucket, "/", package_s3_key, "/ServeRmore-0.0.1.tar.gz", " ServeRmore-0.0.1.tar.gz"))
system(paste0("pip3 install ServeRmore-0.0.1.tar.gz"))
