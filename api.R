model <- s3readRDS(paste0("s3://", package_s3_bucket, "/", package_s3_key, "/model.rds"))
request <- s3readRDS(paste0("s3://", package_s3_bucket, "/", package_s3_key, "/request.rds"))

response = data.frame(passenger_id=0, survived=0, stringsAsFactors=FALSE)
response$passenger_id <- request$PassengerId
response$survival_prob <- predict(model,request,n.trees=6000,type='response')
response$survived <- ifelse(response$survival_prob<0.48,'no','yes')
response$timestamp <- Sys.time()
response

rm(model)
rm(request)
rm(response)