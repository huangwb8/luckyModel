
# Package
if(T){
  if (!requireNamespace("devtools", quietly = TRUE))
    install.packages("devtools")

  if (!requireNamespace("luckyBase", quietly = TRUE))
    devtools::install_github("huangwb8/luckyBase")

  if (!requireNamespace("GSClassifier", quietly = TRUE))
    devtools::install_github("huangwb8/GSClassifier")

  library(luckyBase)
  Plus.library(c('GSClassifier','plyr','dplyr','pROC','tidyr','xgboost'))
}

# Data
testData <- readRDS(system.file("extdata", "testData.rds", package = "GSClassifier"))
expr <- testData$PanSTAD_expr_part
design <- testData$PanSTAD_phenotype_part

# Random seed
seed <- 10077

# Training cohort
modelInfo <- modelData(
  design,
  id.col = "ID",
  variable = c("platform", "PAD_subtype"),
  Prop = 0.7,
  seed = seed
)

# Training data
Xs <- expr[,modelInfo$Data$Train$ID]
y <- modelInfo$Data$Train
y <- y[colnames(Xs),]
Ys <- ifelse(y$PAD_subtype == 'PAD-I',"1",ifelse(y$PAD_subtype == 'PAD-II',"2",ifelse(y$PAD_subtype == 'PAD-III',"3",ifelse(y$PAD_subtype == 'PAD-IV',"4",NA)))); table(Ys)/length(Ys)
nSubtype <- length(unique(Ys))

# Parameteres
if(T){

  # Build 100 models
  n = 100

  # In every model, 70% samples in the training cohort would be selected.
  sampSize = 0.7

  # Seed for sampling
  sampSeed = 2020

  # A vector for gene rank estimation
  breakVec=c(0, 0.25, 0.5, 0.75, 1.0)

  # Use 80% most variable gene & gene-pairs for modeling
  ptail=0.8/2

  # Automatical selection of parameters for xGboost
  # self-defined params. Fast.
  # params = list(max_depth = 5,
  #               eta = 0.5,
  #               nrounds = 100,
  #               nthread = 10,
  #               nfold=5)
  params = list(
    device = "cpu",
    nfold = 5, nrounds = 200,
    nthread = 2, eta = 0.3, gamma = 0, max_depth = 14, colsample_bytree = 1, min_child_weight = 1
  )
  caret.seed = NULL

  # report
  verbose = F

  # parallel
  numCores = 16
}

# Other information
l <- readRDS(system.file("extdata", "PAD.train_20200110.rds", package = "GSClassifier"))

# Model Xs
geneSet <- l$geneSet
tGene = as.character(unlist(geneSet))
Xs = Xs[tGene,]

# Model training
res <- fitEnsembleModel(Xs,
                        Ys,
                        geneSet = geneSet,
                        na.fill.method = "quantile",
                        na.fill.seed = 2022,
                        n = n,
                        sampSize = sampSize,
                        sampSeed = sampSeed,
                        breakVec = breakVec,
                        params = params,
                        nround.mode = c("fixed", "polling")[2],
                        caret.grid = NULL,
                        caret.seed =  caret.seed,
                        ptail = ptail,
                        verbose = verbose,
                        numCores = numCores)

# scaller for train data
if(T){
  resTrain <- parCallEnsemble(X = Xs,
                              ens = res$Model,
                              geneAnnotation = l$geneAnnotation,
                              geneSet = l$geneSet,
                              scaller = NULL,
                              geneid = "ensembl",
                              subtype = NULL,
                              verbose = F,
                              numCores = numCores)

  dtrain <- xgb.DMatrix(as.matrix(resTrain[4:(3 + nSubtype)]), label = as.integer(Ys)-1)

  params_train <- list(
    eta = 0.1,
    max_depth = 5,
    min_child_weight = 5,
    gamma = 0.1,
    alpha = 0.1,
    colsample_bytree = 0.8,
    subsample = 1,
    device = 'cuda'
  )

  set.seed(seed)
  cvRes <- xgb.cv(
    params = params_train,
    data = dtrain,
    nrounds=1000,
    nfold=5,
    num_class = nSubtype,
    early_stopping_rounds=10,
    objective = "multi:softmax",
    verbose = 1
  )
  best_iteration <- cvRes$best_iteration

  set.seed(seed)
  bst <- xgboost(
    params = params_train,
    data = dtrain,
    nrounds = best_iteration,
    num_class = nSubtype,
    objective = "multi:softmax",
    verbose = 1
  )
  Ys_pred <- as.character(predict(bst, as.matrix(resTrain[4:7])) + 1)

  scaller.train <- list(
    Repeat = c(
      list(
        seed = seed,
        nrounds = best_iteration,
        objective = "multi:softmax"
      ),
      params_train
    ),
    Model = bst
  )

}


# Assemble model
if(T){
  l.train <- list()

  # bootstrap models based on the training cohort
  l.train[['ens']] <- res

  # Scaller model
  l.train[['scaller']] <- scaller.train

  # a data frame contarining gene annotation for IDs convertion
  l.train[['geneAnnotation']] <- l$geneAnnotation

  # Your gene sets
  l.train[['geneSet']] <- geneSet
}

# save l.train as .rds

