#' A function to remove token hues from standardized photos
#'
#' This function allows you to make automatic data entry more accurate by filtering out token color from the photo 
#' roster. Simply set a path to the main folder. Then supply the token color vectors and shift angles. It is 
#' recomended to use cool token colors (e.g., green, blue, and purple), and shift all token hues in the standized 
#' photos twoards warmer yellow, red, and orange hues. All photos in the StandardizedPhotos folder will be updated  
#' and saved in the PhotosToPrint folder. With token hues removed from the photo-roster, automatic token detection and
#' classification is much more acurrate, as there a fewer false positives arising from background colors.
#' @param 
#' path Full path to main folder.
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

remove_color_collisions = function(path=path,
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
                                   lower_hue_threshold = 110,
                                   upper_hue_threshold = 330,
                                   saturation_limit_recolor = 0.2,
                                   mode="save",
                                   verbose=TRUE
                                   ){

  path_imgs_full = list.files(paste0(path, "/StandardizedPhotos/"),full.names=TRUE)
  path_imgs_short = list.files(paste0(path, "/StandardizedPhotos/"))

  for(i in 1:length(path_imgs_full)){
       clean_colors(path=path, 
                    id = NA,
                    id_full=path_imgs_full[i],
                    id_short=path_imgs_short[i],
                    mix_histogram = mix_histogram,
                    high_intensity_thresh = high_intensity_thresh,
                    low_intensity_thresh = low_intensity_thresh,
                    moderate_intensity = moderate_intensity,
                    blur_intensity = blur_intensity,
                    blur_saturation = blur_saturation,
                    mean_intensity = mean_intensity,
                    mean_saturation = mean_saturation,
                    rotate_wheel = rotate_wheel,
                    endpoint = endpoint,
                    lower_hue_threshold = lower_hue_threshold,
                    upper_hue_threshold = upper_hue_threshold,
                    saturation_limit_recolor = saturation_limit_recolor,
                    mode=mode,
                    verbose=verbose
                    )
   if(verbose==TRUE){
    print(paste0("Printing photograph ", path_imgs_short[i] ))
   }    
  }
}


