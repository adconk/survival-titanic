#test package
setwd('~/survival-titanic')

if ("serveRlessModel" %in% rownames(installed.packages())){
  remove.packages("serveRlessModel")
}

install.packages("ServeRless-Model.tar.gz", repos = NULL, type = "source")
library(serverRlessModel)

request = jsonlite::fromJSON(txt = 'package_test.json')
print(serverRless-model::predict(request))
