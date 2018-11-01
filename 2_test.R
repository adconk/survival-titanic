library(dplyr)
library(gbm)

setwd("~/survival-titanic/")
titanic <- s3readRDS(paste0("s3://", package_s3_bucket, "/", package_s3_key, "/titanic.rds"))
test <- aws.s3::s3read_using(read.csv, object = paste0("s3://", package_s3_bucket, "/", package_s3_key, "/test.csv")) %>%
  mutate(.,
         Embarked=factor(Embarked,levels=levels(titanic$Embarked)),
         Pclass=factor(Pclass),
         #      Survived=factor(Survived),
         age=ifelse(is.na(Age),35,Age),
         age = cut(age,c(0,2,5,9,12,15,21,55,65,100)),
         Title=sapply(Name,function(x) strsplit(as.character(x),'[.,]')[[1]][2]),
         Title=gsub(' ','',Title),
         Title =ifelse(Title %in% c('Capt','Col','Don','Sir','Jonkheer','Major'),'Mr',Title),
         Title =ifelse(Title %in% c('Lady','Ms','theCountess','Mlle','Mme','Ms','Dona'),'Miss',Title),
         Title = factor(Title),
         A=factor(grepl('A',Cabin)),
         B=factor(grepl('B',Cabin)),
         C=factor(grepl('C',Cabin)),
         D=factor(grepl('D',Cabin)),
         E=factor(grepl('E',Cabin)),
         F=factor(grepl('F',Cabin)),
         ncabin=nchar(as.character(Cabin)),
         PC=factor(grepl('PC',Ticket)),
         STON=factor(grepl('STON',Ticket)),
         cn = as.numeric(gsub('[[:space:][:alpha:]]','',Cabin)),
         oe=factor(ifelse(!is.na(cn),cn%%2,-1))
  )
test$Fare[is.na(test$Fare)]<- median(titanic$Fare)
s3saveRDS(test, paste0("s3://", package_s3_bucket, "/", package_s3_key, "/test.rds"))
input = within(test, rm(cn))
input = input[13,]
s3saveRDS(input, paste0("s3://", package_s3_bucket, "/", package_s3_key, "/input.rds"))
rm(titanic)
rm(test)
rm(input)