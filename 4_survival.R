setwd("~/survival-titanic/")

titanic <- s3readRDS(paste0("s3://", package_s3_bucket, "/", package_s3_key, "/titanic.rds"))
test <- s3readRDS(paste0("s3://", package_s3_bucket, "/", package_s3_key, "/test.rds"))

gb1 <- filter(titanic,train) %>%
  select(.,age,SibSp,Parch,Fare,Sex,Pclass,
         Title,Embarked,A,B,C,D,E,F,ncabin,PC,STON,oe,AGE,Survived)%>%
  mutate(Survived=c(0,1)[Survived])
gb1m <- gbm(Survived ~ .,
            cv.folds=11,
            n.cores=2,
            interaction.depth=5,
            shrinkage = 0.0005,
            distribution='adaboost',
            data=gb1,
            n.trees=10000)
gbm.perf(gb1m)
s3saveRDS(gb1m, paste0("s3://", package_s3_bucket, "/", package_s3_key, "/model.rds"))

rm(gb1)
rm(gb1m)
rm(test)
rm(titanic)