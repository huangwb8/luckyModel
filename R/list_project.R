


#' @title list_project
#' @description list projects in \code{luckyModel} package
#' @return A list of project
#' @seealso \code{\link{list_model}}; \code{\link{lucky_model}}
#' @author Weibin Huang<\email{654751191@@qq.com}>
#' @examples
#' list_project()
#' @export
list_project <- function(){

  path.root <- system.file(paste0('extdata'), package = "luckyModel")

  return(list.dirs(path = path.root, full.names = F, recursive = F))

}











