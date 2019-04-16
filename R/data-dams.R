#' dams
#'
#' This data comes from the National Inventory of Dams, \url{https://nid-test.sec.usace.army.mil/ords/f?p=105:1::::::}
#'
#' @format A tibble with 511 rows and 9 variables:
#' \describe{
#' \item{city}{The city closest to the dam}
#' \item{state}{The state the dam is in}
#' \item{river}{The river that the dam is on}
#' \item{year_completed}{The year the dam was constructed}
#' \item{hazard}{The hazard rating of the dam. (H = High; L = Low; S = Signficant; U = Undetermined)}
#' \item{eap}{Status of the dam's emergency action plan. (Y = Yes; N = No; NR = Not Required;)}
#' \item{latitude}{The latitude of the dam}
#' \item{longitude}{The longitude of the dam}
#' }
#' @examples
#' \dontrun{
#' dams
#' }
"dams"
