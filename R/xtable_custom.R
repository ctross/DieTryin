#' A helper function
#'
#' This is just a helper function to reformat xtable output
#' @param 
#' x An object.
#' @param 
#' ... Additional arguments to xtable.
#' @export
#' @examples
#' \dontrun{
#'   xtable_custom(x)
#'                    }

xtable_custom = function(x, ...) xtable::xtable(x, ..., align = make_align_string(x))



