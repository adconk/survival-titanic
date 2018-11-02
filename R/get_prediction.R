#' Prediction for Titanic Passengers
#'
#' @export

get_prediction <- function(request){
    package_s3_bucket <- "origent-serverless-demo"
    package_s3_key <- "survival-titanic"
    
    library(gbm)
    library(aws.s3)
    
    model <- s3readRDS(paste0("s3://", package_s3_bucket, "/", package_s3_key, "/model.rds"))
    response = data.frame(passenger_id=0, survived=0, survival_prob=0.0, stringsAsFactors=FALSE)
    response$passenger_id <- request$PassengerId
    response$survival_prob <- predict(model,request,n.trees=6000,type='response')
    response$survived <- ifelse(response$survival_prob<0.48,'no','yes')
    response$timestamp <- Sys.time()
    response
    return(response)
}
