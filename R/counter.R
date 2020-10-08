#' Hue processing function
#'
#' This is a function to check hue values. It runs the workflow outlined in the Field Methods paper.
#' @param 
#' slice A subimage of a single target/recipient photograph.
#' @param 
#' lower_hue_threshold Lower hue threshold for the token color. 
#' @param 
#' upper_hue_threshold Upper for the token color. 
#' @param 
#' lower_saturation_threshold Lower limit of greyness before the hue of such pixels is excluded from density calculations.
#' @param 
#' lower_luminance_threshold Lower limit of darkness before the hue of such pixels is excluded from density calculations.
#' @param 
#' upper_luminance_threshold Upper limit of lightness before the hue of such pixels is excluded from density calculations.
#' @param 
#' border_size Image border excluded from density calculations as percentage of image size.
#' @param 
#' iso_blur Width of Gaussian filter applied to image. A value of 0 turns off blurring.
#' @export

counter = function(slice, lower_hue_threshold, upper_hue_threshold, lower_saturation_threshold=0.05, 
                     lower_luminance_threshold=0.05, upper_luminance_threshold=0.95, 
                     border_size=0.25, iso_blur=2){
  # Prune border off of photo, to minimize influence of clothing color
  px = Xc(slice) <= border_size*dim(slice)[1]                         
  slice[px] = 0                                           
  px = Xc(slice) >= dim(slice)[1]-(border_size*dim(slice)[1])                  
  slice[px] = 0                                           
  px = Yc(slice) <= border_size*dim(slice)[2]                        
  slice[px] = 0                                           
  px = Yc(slice) >= dim(slice)[2]-(border_size*dim(slice)[2])              
  slice[px] = 0                                           
 
  # Convert RGB image to HSL, and then use hue to identify tokens
  slice = isoblur(slice, iso_blur)
  X = RGBtoHSL(slice)
  S = ifelse(X[,,1,2]>lower_saturation_threshold,1,NA)
  L = ifelse(X[,,1,3]>lower_luminance_threshold & X[,,1,3]<upper_luminance_threshold ,1,NA)
  R = X[,,1,1]*S*L

  results = rep(NA, length(lower_hue_threshold))
  for(i in 1:length(results)){
   Y = ifelse(R>lower_hue_threshold[i] & R < upper_hue_threshold[i],1,0)
   D = ifelse(is.na(R),1,1)
   results[i] = sum(Y,na.rm=TRUE)/sum(D,na.rm=TRUE)
  }
  return(results)
  }
  
