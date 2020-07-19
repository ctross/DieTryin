#' A helper function
#'
#' This is just a helper function for xtable processing
#' @param 
#' x An object.
#' @export
#' @examples
#' \dontrun{
#'   make_align_string(x)
#'                    }

make_align_string = function(x) {
  format_str = rep("l",ncol(x))
  paste0(paste0(c("r", format_str), collapse = "|"),"|")
}


