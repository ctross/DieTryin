#' A function to automatically enter social network / RICH games data from photographs
#'
#' This function allows you to significantly speed up data entry by using photographs of game boards before and after token allocation. 
#' The auto_enter_all is a workflow wrapper for the auto_enter_data function. This function allows the user process all game data from the same respondent in a single call. 
#' It also automates the calculation of contrasts between control images and images with token allocations.
#' @param 
#' path Full path to main folder.
#' @param 
#' pattern File extension of photos. Should be ".jpg" or ".JPG". 
#' @param 
#' start Location of start of PID in file name. If files are saved as "XXX.jpg" for example, this is 1.
#' @param 
#' stop Location of end of PID in file name. If files are saved as "XXX.jpg" for example, this is 3.
#' @param 
#' seed A seed for the random number generator to sort the order of photos in the array. This should match the seed used to make the survey.
#' @param 
#' n_panels Number of frames/panels/blocks of photos to be output. I use four big panels and randomize their order at each game.
#' @param 
#' n_rows Number of rows per panel. With 7cm x 10cm photos, I use five rows of photos per panel.
#' @param 
#' n_cols Number of cols per panel. With 7cm x 10cm photos, I use six to eight cols of photos per panel.
#' @param 
#' lower_hue_threshold A vector of lower hue thresholds for each token color. To use three token colors, instead of the single token in the defaults, use: e.g., c(120, 210, 330).
#' @param 
#' upper_hue_threshold A vector of upper hue thresholds for each token color. To use three token colors, instead of the single token in the defaults, use: e.g., c(150, 250, 355).
#' @param 
#' plot_colors A vector of labels indicating which token color was used. The first entry must say "empty", other colors can be named as desired, but must be real color names in R. 
#' These colors correspond to the above-listed token hues, and this vector should be one cell longer than the hue threshold vectors. 
#' @param 
#' thresh Difference in hue density between pre- and post-treatment game boards required to code a token color as present. Can be vectorized if mulple token colors are in use: e.g., c(0.05, 0.35, 0.05).
#' @param 
#' img The image to be classified, stored in "imager" format. Supplied via the pre-processing code.
#' @param 
#' locs Locations of the corners of the game boards in the image file. Supplied via the pre-processing code.
#' @param 
#' ID Unique ID code of the player of the game.
#' @param 
#' game ID code of the case/game/question: e.g., "Friendship" or "GaveFood".
#' @param 
#' ordered A vector of photo IDs can be provided to over-ride automatic sorting.
#' @param 
#' lower_saturation_threshold Lower limit of greyness before the hue of such pixels is excluded from density calculations.
#' @param 
#' lower_luminance_threshold Lower limit of darkness before the hue of such pixels is excluded from density calculations.
#' @param 
#' upper_luminance_threshold Upper limit of lightness before the hue of such pixels is excluded from density calculations.
#' @param 
#' border_size Image border excluded from density calculations as a fraction of image size.
#' @param 
#' iso_blur Width of Gaussian filter applied to image. A value of 0 turns off blurring.
#' @param 
#' histogram_balancing Should histogram balancing be used to correct grey-out images? This sometimes helps, but sometimes hurts, classification accuracy. This will cause token hue to shift as well, so hue thresholds will need to be revised if this is used.
#' @param 
#' direction How image skew is corrected. The "forward" algorithm is fast but lower quality. The "backward" algorithm is slow but higher quality. See imwarp function in imager package for technical details.
#' @param 
#' pre_processed Are photographs pre-processed such that image correction steps can be skipped? If FALSE, then user must pre-process images using DieTryings tools. If TRUE game board photographs must be cropped and unskewed. 
#' Some Android and IOS apps, like Tiny Scanner, provide a means of producing such photographs of the game boards at the time of data collection.
#' @return A list of classified ties and associated data, ID tables, and corrected images, for each of the games/cases included in the input lists.
#' @export
#' @examples
#' \dontrun{
#' Game_all1 = auto_enter_all(path=path, pattern=".jpg", start=1, stop=3, seed=1, n_panels=2, n_rows=4, n_cols=5, 
#'                             thresh=0.05, lower_hue_threshold = 120, upper_hue_threshold = 155, 
#'                             plot_colors=c("empty","seagreen4"), img=game_images_all1, locs=game_locs_all1, ID="SK1",
#'                             game=gameID_all1, ordered=sorted_ids,
#'                             lower_saturation_threshold=0.05, 
#'                             lower_luminance_threshold=0.05, 
#'                             upper_luminance_threshold=0.95,  
#'                             border_size=5,
#'                             iso_blur=1,
#'                             histogram_balancing=FALSE,
#'                             direction="backward")
#'                    }

auto_enter_all = function(path, pattern = ".jpg", start = 1, stop = 3, seed = 1, n_panels = 4, n_rows = 5, n_cols = 8, 
                          lower_hue_threshold = 210, upper_hue_threshold = 230, plot_colors=c("empty","darkblue"),
                          img, locs, ID="CTR", game="FriendshipTies", thresh=0.05, ordered=NULL, 
                          lower_saturation_threshold=0.05, lower_luminance_threshold=0.05, 
                          upper_luminance_threshold=0.95, border_size=0.25, iso_blur=2,
                          histogram_balancing=histogram_balancing, direction="backwards",
                          pre_processed=FALSE){
  # Prepare storage 
   res = vector("list",length(img)-1)

  # Now process blank board data
   i = 1
   X = auto_enter_data(path=path, pattern=pattern, start=start, stop=stop, seed=seed, n_panels=n_panels, n_rows=n_rows, n_cols=n_cols, 
                       lower_hue_threshold=lower_hue_threshold, upper_hue_threshold=upper_hue_threshold, plot_colors=plot_colors, thresh=thresh,
                       img=img[[i]], locs=locs[[i]], ID=ID, game=game[[i]],clean=NA, ordered=ordered,
                       lower_saturation_threshold=lower_saturation_threshold, 
                       lower_luminance_threshold=lower_luminance_threshold, 
                       upper_luminance_threshold=upper_luminance_threshold, 
                       border_size=border_size,
                       iso_blur=iso_blur,
                       histogram_balancing=histogram_balancing,
                       direction=direction,
                       pre_processed=pre_processed)

    print(paste0("Finished processing image ", "Blank" ))

   # And, now process real token allocation data
   for(i in 1:(length(img)-1)){
     res[[i]] = auto_enter_data(path=path, pattern=pattern, start=start, stop=stop, seed=seed, n_panels=n_panels, n_rows=n_rows, n_cols=n_cols, 
                                 lower_hue_threshold=lower_hue_threshold, upper_hue_threshold=upper_hue_threshold, plot_colors=plot_colors, thresh=thresh,
                                 img=img[[i+1]], locs=locs[[i+1]], ID=ID, game=game[[i+1]], clean=X[[1]], ordered=ordered,
                                 lower_saturation_threshold=lower_saturation_threshold, 
                                 lower_luminance_threshold=lower_luminance_threshold, 
                                 upper_luminance_threshold=upper_luminance_threshold, 
                                 border_size=border_size,
                                 iso_blur=iso_blur,
                                 histogram_balancing=histogram_balancing,
                                 direction=direction,
                                 pre_processed=pre_processed)
       
     print(paste0("Finished processing image ", game[[i+1]] ))
                          }

     return(res)                     

 }
