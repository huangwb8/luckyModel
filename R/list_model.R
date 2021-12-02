

#' @title list_model
#' @description Explore models in a specific project
#' @inheritParams lucky_model
#' @return a list of models in the project
#' @seealso \code{\link{lucky_model}}.
#' @author Weibin Huang<\email{654751191@@qq.com}>
#' @examples
#' list_model(project='GSClassifier')
#' list_model('GSClassifier')
#' @export
list_model <- function(project='GSClassifier'){

  path.project <- system.file(paste0('extdata/', project), package = "luckyModel")

  path.model <- list.files(path = path.project, pattern = '.rds$', full.names = T, recursive = F)

  model <- basename(path.model)

  model <- gsub('.rds','',model)

  message('Available models in ', project,': ')

  for(i in model) cat('  *',i, '\n', sep='')

}


