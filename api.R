model <- readRDS("data/model.rds")
request <- readRDS("data/request.rds")
response = data.frame(passenger_id=0, survived=0, stringsAsFactors=FALSE)
response$passenger_id <- request$PassengerId
response$survival_prob <- predict(model,request,n.trees=6000,type='response')
response$survived <- ifelse(response$survival_prob<0.48,'no','yes')
response$timestamp <- Sys.time()
response
