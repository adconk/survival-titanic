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

saveRDS(titanic, "data/titanic.rds")