#' A helper function
#'
#' This is a helper function to break array into cells and check hue differences
#' @param 
#' x An object.
#' @export
shatter <- function(image, locations, n_rows = 5, n_cols = 9, lower_hue_threshold=lower_hue_threshold, 
                    upper_hue_threshold=upper_hue_threshold, lower_saturation_threshold=lower_saturation_threshold, 
                     lower_luminance_threshold=lower_luminance_threshold, 
                     upper_luminance_threshold=upper_luminance_threshold, 
                     border_size=border_size,
                     iso_blur=iso_blur,
                     histogram_balancing=histogram_balancing,
                     direction="backward"){
 # shatter takes in an image file and corner locations, splits the file into individual images, 
 # runs the classifier, and exports results and images
 results <- array(NA, c(n_rows, n_cols, length(lower_hue_threshold)))
 pruned_image <- extractor(image, locations, histogram_balancing=histogram_balancing, direction=direction) 
 rows_image <- imsplit(pruned_image,"y",n_rows)
 for(i in 1:n_rows){
 slice_image<- imsplit(rows_image[[i]],"x",n_cols)  
 for(j in 1:n_cols){
  for(k in 1: length(lower_hue_threshold)){
   results[i,j,k] <- counter(slice_image[[j]], lower_hue_threshold=lower_hue_threshold[k], upper_hue_threshold=upper_hue_threshold[k], 
                     lower_saturation_threshold=lower_saturation_threshold, 
                     lower_luminance_threshold=lower_luminance_threshold, 
                     upper_luminance_threshold=upper_luminance_threshold, 
                     border_size=border_size,
                     iso_blur=iso_blur)
    }
   }
  }
 return(list(results,pruned_image))
}
