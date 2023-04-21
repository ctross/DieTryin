#' A function to remove token colors from standardized photos
#'
#' This function allows you to make automatic data entry more accurate by filtering out token color from the photo roster. Simply set a path to the main folder. 
#' Then supply the token color vectors and shift angles. It is recomended to use cool token colors (e.g., green, blue, and purple), and shift all
#' token colors in the standized photos twoards warmer yellow, red, and orange hues. All photos in StandardizedPhotos will be updated and saved in PhotosToPrint.
#' @param 
#' path Full path to main folder.
#' @param 
#' lower_hue_threshold A vector of lower hue thresholds for each token color. To use three token colors, instead of the single token in the defaults, use: e.g., c(120, 210, 330).
#' @param 
#' upper_hue_threshold A vector of upper hue thresholds for each token color. To use three token colors, instead of the single token in the defaults, use: e.g., c(150, 250, 355).
#' @param 
#' rotation_angle A vector of angles with which to shift colors inside of the token range. Values are specified in degree: e.g., c(-65, 70, 40). Calculations are made mod 360.
#' @param 
#' verbose If TRUE, print which photo is being saved.
#' @export

remove_color_collisions = function(path=path,
                                   lower_hue_threshold = c(120, 270, 185),
                                   upper_hue_threshold = c(180, 330, 210),
                                   rotation_angle = c(-65, 70, 40),
                                   verbose=FALSE){

  path_imgs_full = list.files(paste0(path, "/StandardizedPhotos/"),full.names=TRUE)
  path_imgs_short = list.files(paste0(path, "/StandardizedPhotos/"))

  for(i in 1:length(path_imgs_full)){
       clean_colors(path=path, 
                    id = NA,
                    id_full=path_imgs_full[i],
                    id_short=path_imgs_short[i],
                    lower_hue_threshold = lower_hue_threshold, 
                    upper_hue_threshold = upper_hue_threshold, 
                    rotation_angle = rotation_angle,
                    mode="save"
                    )
   if(verbose==TRUE){
    print(paste0("Printing photograph ", path_imgs_short[i] ))
   }    
  }
}

