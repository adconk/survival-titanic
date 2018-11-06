#' Prediction for Titanic Passengers
#'
#' @export

get_prediction <- function(request){
    package_s3_bucket <- "origent-serverless-demo"
    package_s3_key <- "survival-titanic"
    
    library(gbm)
    library(aws.s3)
    
    request_test <- s3readRDS(paste0("s3://", package_s3_bucket, "/", package_s3_key, "/request.rds"))
    model <- s3readRDS(paste0("s3://", package_s3_bucket, "/", package_s3_key, "/model.rds"))
    
    request$Pclass <- factor(request$Pclass, levels = levels(request_test$Pclass))
    request$Name <- factor(request$Name, levels = levels(request_test$Name))
    request$Sex <- factor(request$Sex, levels = levels(request_test$Sex))
    request$Ticket <- factor(request$Ticket, levels = levels(request_test$Ticket))
    request$Cabin <- factor(request$Cabin, levels = levels(request_test$Cabin))
    request$Embarked <- factor(request$Embarked, levels = levels(request_test$Embarked))
    request$age <- factor(request$age, levels = levels(request_test$age))
    request$Title <- factor(request$Title, levels = levels(request_test$Title))
    request$PC <- factor(request$PC, levels = levels(request_test$PC))
    request$STON <- factor(request$STON, levels = levels(request_test$STON))
    request$oe <- factor(request$oe, levels = levels(request_test$oe))
    request$A <-factor(request$A,levels = c(1,0), labels = levels(request_test$A))
    request$B <-factor(request$B,levels = c(1,0), labels = levels(request_test$B))
    request$C <-factor(request$C,levels = c(1,0), labels = levels(request_test$C))
    request$D <-factor(request$D,levels = c(1,0), labels = levels(request_test$D))
    request$E <-factor(request$E,levels = c(1,0), labels = levels(request_test$E))
    request$F <-factor(request$F,levels = c(1,0), labels = levels(request_test$F))
    
    response = data.frame(passenger_id=0, survived=0, survival_prob=0.0, stringsAsFactors=FALSE)
    response$passenger_id <- request$PassengerId
    response$survival_prob <- predict(model,request,n.trees=6000,type='response')
    response$survived <- ifelse(response$survival_prob<0.48,'no','yes')
    response$timestamp <- Sys.time()
    response
    return(response)
}
