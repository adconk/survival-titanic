preds <- predict(gb1m,titanic,n.trees=6000,type='response')
density(preds) %>% plot

preds2<- preds[!titanic$train]
target <- c(0,1)[titanic$Survived[!titanic$train]]
sapply(seq(.3,.7,.01),function(step)
  c(step,sum(ifelse(preds2<step,0,1)!=target)))
