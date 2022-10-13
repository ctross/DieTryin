#' Image classifier workflow
#'
#' This function works by taking an input of lists of images and corner locations of the game board, and the applying
#' a workflow to identify ties, as indicated by token placement. Shatter first applies image straigtening and rotation correction steps.
#' Then, it splits the photo grid into individual respodent photos, and applies the hue detection algorithm on case and control images.
#' @param 
#' image A photograph of a single game board.
#' @param 
#' locations A list of corner locations of the game board in the image. 
#' @param 
#' n_rows Number of rows per panel. With 7cm x 10cm photos, I use five rows of photos per panel.
#' @param 
#' n_cols Number of cols per panel. With 7cm x 10cm photos, I use six to eight cols of photos per panel.
#' @param 
#' lower_hue_threshold A vector of lower hue thresholds for each token color. To use three token colors, instead of the single token in the defaults, use: e.g., c(120, 210, 330).
#' @param 
#' upper_hue_threshold A vector of upper hue thresholds for each token color. To use three token colors, instead of the single token in the defaults, use: e.g., c(150, 250, 355).
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
#' @return A list containing an array of hue expression results, and corrected images.
#' @export
shatter = function(image, locations, n_rows = 5, n_cols = 9, lower_hue_threshold=120, upper_hue_threshold=160, 
                    lower_saturation_threshold=0.05, lower_luminance_threshold=0.05, 
                     upper_luminance_threshold=0.95, border_size=0.25, iso_blur=2,
                     histogram_balancing=FALSE, direction="backward", pre_processed=FALSE){

 results = array(NA, c(n_rows, n_cols, length(lower_hue_threshold)))

 if(pre_processed==FALSE){
  pruned_image = extractor(image, locations, histogram_balancing=histogram_balancing, direction=direction) 
 }
 else{
  pruned_image = image
 }

 rows_image = imager::imsplit(pruned_image,"y",n_rows)
 for(i in 1:n_rows){
 slice_image = imager::imsplit(rows_image[[i]],"x",n_cols)  
 for(j in 1:n_cols){
  for(k in 1: length(lower_hue_threshold)){
   results[i,j,k] = counter(slice_image[[j]], lower_hue_threshold=lower_hue_threshold[k], upper_hue_threshold=upper_hue_threshold[k], 
                            lower_saturation_threshold=lower_saturation_threshold, lower_luminance_threshold=lower_luminance_threshold, 
                            upper_luminance_threshold=upper_luminance_threshold, border_size=border_size, iso_blur=iso_blur)
    }
   }
  }
 return(list(results,pruned_image))
}
