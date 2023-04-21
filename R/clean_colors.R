#' A function to remove token colors from standardized photos
#'
#' This function allows you to make automatic data entry more accurate by filtering out token color from the photo roster. Simply set a path to the main folder. 
#' Then supply an ID code and the token color vectors and shift angles. It is recomended to use cool token colors (e.g., green, blue, and purple), and shift all
#' token colors in the standized photos twoards warmer yellow, red, and orange hues.
#' @param 
#' path Full path to main folder.
#' @param 
#' id Unique ID of focal individual/respondent. Used if user wants to test colors by setting mode="test".
#' @param 
#' id_full Full path to photograph. Used by remove_color_collisions function. Set to NA otherwise.
#' @param 
#' id_short ID code plus .jpg extension. Used by remove_color_collisions. Set to NA otherwise.
#' @param 
#' lower_hue_threshold A vector of lower hue thresholds for each token color. To use three token colors, instead of the single token in the defaults, use: e.g., c(120, 210, 330).
#' @param 
#' upper_hue_threshold A vector of upper hue thresholds for each token color. To use three token colors, instead of the single token in the defaults, use: e.g., c(150, 250, 355).
#' @param 
#' rotation_angle A vector of angles with which to shift colors inside of the token range. Values are specified in degree: e.g., c(-65, 70, 40). Calculations are made mod 360.
#' @param 
#' mode Set to "test", to check photos by hand. The "save" option is used only by remove_color_collisions. 
#' @export

clean_colors = function(path=path, 
                        id="blank",
                        id_full=NA,
                        id_short=NA, 
                        lower_hue_threshold = c(120, 270, 185),
                        upper_hue_threshold = c(180, 330, 210),
                        rotation_angle = c(-65, 70, 40),
                        mode="test"
                        ){
  if(!is.na(id_full)){
   path_img = id_full
   } else{
   path_img = paste0(path,"/StandardizedPhotos/",id,".jpg") 
   }

  img = imager::load.image(path_img)
  img2 = RGBtoHSL(img)
  img3 = img2
  for(k in 1:length(rotation_angle))
  img3[,,1,1] = ifelse((img3[,,1,1] > lower_hue_threshold[k]) & (img3[,,1,1]<upper_hue_threshold[k]),(img3[,,1,1] + rotation_angle[k]) %% 360, img3[,,1,1]) 
  img4 = HSLtoRGB(img3)
  if(mode=="test"){
   plot(img4)
  }
  if(mode=="save"){
   imager::save.image(img4, paste0(path,"/PhotosToPrint/",id_short), quality=1)  # Save image 
  }
}

