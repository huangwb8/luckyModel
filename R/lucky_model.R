

#' @title lucky_model
#' @description Model calling function
#' @param project the project
#' @param developer the developer
#' @param model the series of models
#' @param version the model version
#' @return a model
#' @seealso \code{\link{list_project}};\code{\link{list_model}};
#' @author Weibin Huang<\email{654751191@@qq.com}>
#' @examples
#' PADi <- lucky_model(project = 'GSClassifier',
#'                     developer='HWB',
#'                     model = 'PAD',
#'                     version = 'v20200110')
#'
#' ImmuneSubtype <- lucky_model(project = 'GSClassifier',
#'                             developer='Gibbs',
#'                             model = 'PanCancerImmuneSubtype',
#'                             version = 'v20190731')
#' @export
lucky_model <- function(project = 'GSClassifier',
                        model = 'PAD',
                        developer='HWB',
                        version = 'v20200110'){

  # Test
  if(F){
    project = 'GSClassifier'
    developer='HWB'
    model = 'PAD'
    version = 'v20200110'
  }

  # Call a model
  name.m <- paste0(paste(developer, model, version, sep = '_'), '.rds', collapse = '')
  path.m <- paste0('extdata/', project)
  m <- readRDS(system.file(path.m, name.m, package = "luckyModel"))
  return(m)


}

