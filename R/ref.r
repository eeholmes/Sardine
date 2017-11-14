#' Create counter for figure and tables
#'
#' Used in the R markdown files for figure and table counters.
#' 
#' @param useName name of the label.  Must be of the form type:name, like fig:spawners
#' 
#' @return The number of the figure or table
#'
#' @details
#' Can be used anywhere in text or captions.  First time it is called, the counter .refctr is given a number associated with the name and the number returned.  Next time it is called, it checks if the name exists.  If so, it returns its number.  
#' 
#' Use like so `r ref("fig:1a")` whereever you need the number.
#' 
#' Note you need to define the environment of the rmarkdown file that is calling ref().  Add this at the top of the Rmd file
#' if(!exists(".rmdenvir")) .rmdenvir = environment()
#' .rmdenvir and .refctr will be created in the Rmd environment
#' 
ref <- function(useName) {
  require(stringr)
  if(!exists(".refctr")) .refctr <- c(`_` = 0)
  if(any(names(.refctr)==useName)) return(.refctr[useName])
  type=str_split(useName,":")[[1]][1]
  nObj <- sum(str_detect(names(.refctr),type))
  useNum <- nObj + 1
  newrefctr <- c(.refctr, useNum)
  names(newrefctr)[length(.refctr) + 1] <- useName
  assign(".refctr", newrefctr, envir=.rmdenvir)
  return(useNum)
}