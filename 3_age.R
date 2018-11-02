library(aws.s3)

setwd("~/survival-titanic/")

titanic <- s3readRDS(paste0("s3://", package_s3_bucket, "/", package_s3_key, "/titanic.rds"))
test <- s3readRDS(paste0("s3://", package_s3_bucket, "/", package_s3_key, "/test.rds"))

forage <- filter(titanic,!is.na(titanic$Age)) %>%
  select(.,Age,SibSp,Parch,Fare,Sex,Pclass,Title,Embarked,A,B,C,D,E,F,ncabin,PC,STON,oe)

rfa1 <- gbm(Age ~ ., 
            data=forage,
            interaction.depth=4,
            cv.folds=10,
            n.trees=8000,
            shrinkage=0.0005,
            n.cores=2)
gbm.perf(rfa1)

titanic$AGE<- titanic$Age
titanic$AGE[is.na(titanic$AGE)] <- predict(rfa1,titanic,n.trees=7118)[is.na(titanic$Age)]
test$AGE<- test$Age
test$AGE[is.na(test$AGE)] <- predict(rfa1,test,n.trees=7118)[is.na(test$Age)]

s3saveRDS(titanic, paste0("s3://", package_s3_bucket, "/", package_s3_key, "/titanic.rds"))
s3saveRDS(test, paste0("s3://", package_s3_bucket, "/", package_s3_key, "/test.rds"))

rm(forage)
rm(rfa1)
rm(titanic)
rm(test)
