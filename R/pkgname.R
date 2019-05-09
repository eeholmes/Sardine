#' Documentation for Indian oil sardine forecasting papers
#'
#' Indian Oil Sardine Data, Code and References for Papers on Forecasting
#'
#' To get an overview of the data, see \code{\link{precip}}, \code{\link{oilsardine_qtr}},
#' \code{\link{enso}}, \code{\link{chl}}, \code{\link{sst}}, \code{\link{onset}}, and
#' \code{\link{tidelevel}}.
#' To see the code for the data and raw data files, look in the \code{extdata} folder.  The full reference bib file is in \code{Sardine.bib} in the \code{docs}
#' along with some figures used in the papers.  \code{REFERENCES.bib} is only references for the help files.
#' To see all the help files type \code{help(package="SardineForecast")}.
"_PACKAGE"
#> [1] "_PACKAGE"
#' @examples
#' list.files(system.file("docs", package="SardineForecast"))
#' list.files(system.file("extdata", package="SardineForecast"))
#' list.files(system.file("extdata/get_satellite_data", package="SardineForecast"))
#' help(package="SardineForecast")
#' 
#' # Show the bibliography
#' file.show(system.file("docs", "Sardine.bib", package="SardineForecast"))
