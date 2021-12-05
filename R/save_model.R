
#' @title Save your model
#' @description Save your model
#' @param x your model
#' @param model.path the path of the local repository of \code{luckyModel} package
#' @inheritParams lucky_model
#' @author Weibin Huang<\email{654751191@@qq.com}>
#' @export
save_model <- function(x,
                       model.path = '.',
                       project = 'GSClassifier',
                       model = 'PAD',
                       developer='HWB',
                       version = 'v20200110'){

  # Test
  if(F){

    x <- readRDS(system.file("extdata", "PAD.train_20200110.rds", package = "GSClassifier"))
    model.path <- 'C:/Users/Administrator/Desktop/PAD_Test'
    project = 'GSClassifier'
    model = 'PAD'
    developer='HWB'
    version = 'v20200110'
  }

  # save .rds model
  p <- paste0(model.path,'/inst/extdata/',project,'/')
  dir.create(p, showWarnings = F, recursive = T)
  model.name <- paste0(p, model, '_', developer,'_',version,'.rds')
  saveRDS(x, file = model.name)
  message('Your model had been saved in ', model.name,'.')

}
