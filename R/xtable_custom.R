#' A helper function
#'
#' This is just a helper function to reformat xtable output
#' @param 
#' x An object.
#' @export
#' @examples
#' \dontrun{
#'   xtable_custom(x)
#'                    }

xtable_custom = function(x, ...) xtable(x, ..., align = make_align_string(x))



