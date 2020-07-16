 #' A helper function
#'
#' This is a helper function to check hue
#' @param 
#' x An object.
#' @export

counter <- function(slice, lower_hue_threshold, upper_hue_threshold, 
                     lower_saturation_threshold=0.04, 
                     lower_luminance_threshold=0.04, 
                     upper_luminance_threshold=0.96, 
                     border_size=8,
                     iso_blur=0){
  # Prune border off of photo, to minimize influence of clothing color
  px <- Xc(slice) <= border_size                         
  slice[px] <- 0                                           
  px <- Xc(slice) >= dim(slice)[1]-border_size                  
  slice[px] <- 0                                           
  px <- Yc(slice) <= border_size*2                           
  slice[px] <- 0                                           
  px <- Yc(slice) >= dim(slice)[2]-border_size*2              
  slice[px] <- 0                                           
 
  # Convert RGB image to HSL, and then use hue to identify tokens
  slice <- isoblur(slice, iso_blur)
  X <- RGBtoHSL(slice)
  S <- ifelse(X[,,1,2]>lower_saturation_threshold,1,NA)
  L <- ifelse(X[,,1,3]>lower_luminance_threshold & X[,,1,3]<upper_luminance_threshold ,1,NA)
  R <- X[,,1,1]*S*L

  results <- rep(NA, length(lower_hue_threshold))
  for(i in 1:length(results)){
   Y <- ifelse(R>lower_hue_threshold[i] & R < upper_hue_threshold[i],1,0)
   D <- ifelse(is.na(R),1,1)
   results[i] <- sum(Y,na.rm=TRUE)/sum(D,na.rm=TRUE)
  }
  return(results)
  }
  
