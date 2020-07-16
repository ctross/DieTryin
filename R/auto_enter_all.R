
auto_enter_all <- function(path = "C:/Users/Mind Is Moving/Desktop/RICH/", pattern = ".jpg", start = 1, stop = 3, 
    seed = 1, n_frames = 4, n_rows = 5, n_cols = 9, lower_hue_threshold = 210, upper_hue_threshold = 230, colors=c("empty","red"),
    img, locs, focal="CTR", case, thresh=0.25, ordered=NULL, 
                     lower_saturation_threshold=0.05, 
                     lower_luminance_threshold=0.05, 
                     upper_luminance_threshold=0.95, 
                     border_size=8,
                     iso_blur=2){
   
   res <- vector("list",length(img)-1)

    i <- 1
    X <- auto_enter_data(path=path, pattern=pattern, start=start, stop=stop, seed=seed, n_frames=n_frames, n_rows=n_rows, n_cols=n_cols, 
                    lower_hue_threshold=lower_hue_threshold, upper_hue_threshold=upper_hue_threshold, colors=colors, thresh=thresh,
                    img=img[[i]], locs=locs[[i]], focal=focal, case=case[[i]],clean=NA, ordered=ordered,
                    lower_saturation_threshold=lower_saturation_threshold, 
                        lower_luminance_threshold=lower_luminance_threshold, 
                     upper_luminance_threshold=upper_luminance_threshold, 
                     border_size=border_size,
                     iso_blur=iso_blur)

    print(paste0("Finished processing image ", "Blank" ))

   for(i in 1:(length(img)-1)){
     res[[i]] <- auto_enter_data(path=path, pattern=pattern, start=start, stop=stop, seed=seed, n_frames=n_frames, n_rows=n_rows, n_cols=n_cols, 
                            lower_hue_threshold=lower_hue_threshold, upper_hue_threshold=upper_hue_threshold, colors=colors, thresh=thresh,
                            img=img[[i+1]], locs=locs[[i+1]], focal=focal, case=case[[i+1]], clean=X[[1]], ordered=ordered,
                            lower_saturation_threshold=lower_saturation_threshold, 
                        lower_luminance_threshold=lower_luminance_threshold, 
                     upper_luminance_threshold=upper_luminance_threshold, 
                     border_size=border_size,
                     iso_blur=iso_blur)
     print(paste0("Finished processing image ", case[[i+1]] ))
                          }

     return(res)                     

 }

