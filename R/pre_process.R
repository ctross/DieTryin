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
#' @param 
#' automate will corners be selected manually, or automatically?
#' @param 
#' reference path to the reference set.
#' @param 
#' d_x x width of kernel used to scan for corners
#' @param 
#' d_y y width of kernel used to scan for corners
#' @return A list of length 2. The first slot contains image files. The second slot contains the locations of game-board corners.
#' @export
#' @examples
#' \dontrun{
#' filled = vector("list", 26)
#' filled[[1]] = pre_process(path=path, ID="QQQ", game="Blank", panels=c("A","B"))
#'                    }

pre_process = function (path, ID, game = "Blank", panels = c("A", "B"), pre_processed = FALSE, automate = FALSE, reference = NULL, d_x = 20, d_y = 20, plot_corners=TRUE) 
{
    blank_photos_to_read = paste0(game, "_", ID, "_", panels, ".jpg")
    blank_path = paste0(path, "/ResultsPhotosSmall/", blank_photos_to_read)
    blank_images = grab_images(blank_path)
    
    if(automate == FALSE){
     blank_locs = grab_points(blank_path, pre_processed = pre_processed)
    }
    if(automate == TRUE){
     blank_locs = grab_points_automatic(path_imgs = blank_path, path_refset = reference, d_x = d_x, d_y = d_y, plot_corners=plot_corners)    
    }

    return(list(blank_images, blank_locs))
}

