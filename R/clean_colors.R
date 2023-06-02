#' A function to remove token colors from standardized photos
#'
#' This function allows you to make automatic data entry more accurate by filtering out token color from the photo roster. Simply set a path to the main folder. 
#' Then supply an ID code and the token color vectors and shift angles. It is recomended to use cool token colors (e.g., green, blue, and purple), and shift all
#' token colors in the standized photos towards warmer yellow, red, and orange hues.
#' @param 
#' path Full path to main folder.
#' @param 
#' id Unique ID of focal individual/respondent. Used if user wants to test colors by setting mode="test".
#' @param 
#' id_full Full path to photograph. Used by remove_color_collisions function. Set to NA otherwise.
#' @param 
#' id_short ID code plus .jpg extension. Used by remove_color_collisions. Set to NA otherwise.
#' @param 
#' mix_histogram A scalar on (0,1) to mix orginal intensity and balanced histogram of intensity. 
#' @param 
#' high_intensity_thresh Limit at which to moderate overexposed areas.
#' @param 
#' low_intensity_thresh Limit at which to lighten underexposed areas.
#' @param 
#' moderate_intensity Scale factor with which we correct high and low intensity areas.
#' @param 
#' blur_intensity Blur applied to intensity layer to smooth out threshold artifacts.
#' @param 
#' blur_saturation Blur applied to saturation layer to smooth out threshold artifacts.
#' @param 
#' mean_intensity Average intensity in final image.
#' @param 
#' mean_saturation Average saturation in final image.
#' @param 
#' rotate_wheel Angle to rotate color wheel before removing token colors. Its beter to start at slightly purple than red.
#' @param 
#' endpoint Upper limit of hues after mapping.
#' @param 
#' lower_hue_threshold Any hue above this, but below the upper threshold, will get mapped to the interval between 0 and endpoint.
#' @param 
#' upper_hue_threshold Any hue below this, but above the lower threshold, will get mapped to the interval between 0 and endpoint.
#' @param 
#' saturation_limit_recolor Saturation limit above which token colors are rotated out of image.
#' @param 
#' mode Set to "test", to check photos by hand. The "save" option is used only by remove_color_collisions. 
#' @param 
#' verbose Set to TRUE to plot orginal and processsed images 
#' @export

clean_colors = function(path=path, 
                        id="blank",
                        id_full=NA,
                        id_short=NA, 
                        mix_histogram = 0.8,
                        high_intensity_thresh = 0.8,
                        low_intensity_thresh = 0.2,
                        moderate_intensity = 0.8,
                        blur_intensity = 2,
                        blur_saturation = 2,
                        mean_intensity = 0.5,
                        mean_saturation = 0.15,
                        rotate_wheel = 30,
                        endpoint = 100,
                        lower_hue_threshold = 150,
                        upper_hue_threshold = 330,
                        saturation_limit_recolor = 0.15,
                        mode="test",
                        verbose=TRUE
                        ){
 ################################################################## Read in picture
   if(!is.na(id_full)){
    path_img = id_full
   } else{
    path_img = paste0(path,"/StandardizedPhotos/",id,".jpg") 
   }

    img = imager::load.image(path_img)
    img2z = img2 = imager::RGBtoHSI(img)

 ################################################################## Process intensity
    img2a = img2[,,1]
    img2b = img2[,,2]
    img2c = img2[,,3]

    imgP = imager::grayscale(img)
    px = imgP > high_intensity_thresh
    pz = imgP < low_intensity_thresh

    img2c[px] = img2c[px]*moderate_intensity
    img2c[pz] = img2c[pz]*(1/moderate_intensity)

    img2c = imager::isoblur(imager::as.cimg(img2c,dim=dim(img2c)), blur_intensity) 
    img2b = imager::isoblur(imager::as.cimg(img2b,dim=dim(img2c)), blur_saturation) 

    f = ecdf(img2c)
    img2cv2 = f(img2c) %>% imager::as.cimg(dim=dim(img2c)) 

    img2c = img2c*mix_histogram + img2cv2*(1-mix_histogram)

 ################################################################## Remove token colors
  img2a = (img2a + rotate_wheel) %% 360
  pw = (img2a < upper_hue_threshold) & (img2a > lower_hue_threshold) & (img2b[,,1,1] > saturation_limit_recolor)
  img2a[pw] = (img2a[pw]/360)*endpoint

  pw = (img2a > upper_hue_threshold) & (img2b[,,1,1] > saturation_limit_recolor)
  img2a[pw] = (img2a[pw] + rotate_wheel) %% 360

  img2a = (img2a - rotate_wheel) %% 360

  img2z[,,1] = (img2a ) 
  img2z[,,2] = img2b*(mean_saturation/mean(img2b))
  img2z[,,3] = img2c*(mean_intensity/mean(img2c))
  img4 = imager::HSItoRGB(img2z)

 if(verbose==TRUE){
  layout(t(1:2))
  plot(img)
  plot(img4)
  }

 if(mode=="save"){
  imager::save.image(img4, paste0(path,"/PhotosToPrint/",id_short), quality=1)  # Save image 
  }
}
