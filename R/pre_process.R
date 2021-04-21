#' A helper function to streamline pre-processing workflow
#'
#' This function is used to prepare data for automatic coding.
#' @param 
#' path Full path to main folder.
#' @param 
#' ID Unique ID of focal individual/respondent.
#' @param 
#' game ID for case/game/question.
#' @param 
#' panels ID codes used to distinguish photographs of the different boards/panels/frames from the same person and game.
#' @param 
#' pre_processed Are photographs pre-processed such that image correction steps can be skipped? If FALSE, then user must pre-process images using DieTryings tools. If TRUE game board photographs must be cropped and unskewed. 
#' Some Android and IOS apps, like Tiny Scanner, provide a means of producing such photographs of the game boards at the time of data collection.
#' @return A list of length 2. The first slot contains image files. The second slot contains the locations of game-board corners.
#' @export
#' @examples
#' \dontrun{
#' filled = vector("list", 26)
#' filled[[1]] = pre_process(path=path, ID="QQQ", game="Blank", panels=c("A","B"))
#'                    }

pre_process <- function(path, ID, game="Blank", panels=c("A","B"), pre_processed=FALSE){
 blank_photos_to_read = paste0(game, "_", ID, "_", panels, ".jpg")
 blank_path = paste0(path, "/ResultsPhotosSmall/", blank_photos_to_read)
 blank_images = grab_images(blank_path)
 blank_locs = grab_points(blank_path, pre_processed=pre_processed)
 return(list(blank_images,blank_locs))
}

