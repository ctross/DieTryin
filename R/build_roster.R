#' A function to automatically build a photo roster for data collection
#'
#' This is a helper function to plot the roster. Posters are saved in the "Survey" folder.
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
#' n_panels Number of frames/panels/blocks of photos to be output. I use four big panels and randomize order at each game.
#' @param 
#' n_rows Number of rows per panel. With 7cm x 10cm photos, I use five rows of photos per panel.
#' @param 
#' n_cols Number of rows per panel. With 7cm x 10cm photos, I use six to eight cols of photos per panel.
#' @param 
#' ordered A list of IDs if photograph order is to be explicilty coded. This overwrites random sorting, otherwise NULL.
#' @param 
#' size_out Width of standardized photos (pixels).
#' @param 
#' chip_width Width at which reference chip should be printed (pixels).
#' @param 
#' asr Aspect ratio of each photo.
#' @param 
#' width Width at which each photo on the poster should be printed (inches).
#' @export
#' @examples
#' \dontrun{
#'  build_roster(path, pattern=".jpg", start=1, stop=3, n_panels=4, n_rows=6, n_cols=14, 
#'              size_out=1000, chip_width=300, asr=1.6180, width = 2.5, seed=1, ordered = NULL )
#'                    }

 build_roster = function(path, pattern=".jpg", start=1, stop=3, seed=1, n_panels=4, n_rows=5, n_cols=8, ordered = NULL, 
                         size_out=1000, chip_width=300, asr=1.6180, width = 2.5){

 path_out = paste0(path,"/Survey")
  
  if(is.null(ordered)){
    message("Because ordered=NULL, ID codes are loaded from the file names in the StandardizedPhotos directory.")
   IDS = substr(list.files(paste0(path,"/","StandardizedPhotos"), pattern, full.names=FALSE), start = start, stop = stop) # Load IDs from photos
   L = length(IDS)
   set.seed(seed)
   SortedIDS = c(IDS[order(runif(length(IDS),0,1))])
    }else{
    SortedIDS = ordered
    L = length(SortedIDS)
    seed = "NA"
  }

 if( L> n_panels*n_rows*n_cols){
  stop("ID vector exceeds the product of n_panels*n_rows*n_cols")
 } else{      
   
 SortedIDS = c(SortedIDS,rep("BLANK",(n_panels*n_rows*n_cols - L)) )

 X = matrix(paste0(SortedIDS,".jpg"), nrow=n_rows,ncol=n_panels*n_cols,byrow=FALSE)
 x = vector("list",n_panels)

 blankspot = magick::image_blank(width = size_out, height = size_out*asr, color="black")
 imager::save.image(imager::magick2cimg(blankspot), paste0(path,"/PhotosToPrint/","BLANK.jpg"), quality=1)
 
 for(i in 1:n_panels){
 x[[i]] = X[,c(1:n_cols)+n_cols*(i-1)]

 imgs = magick::image_read(paste0(path,"/PhotosToPrint/",c(x[[i]])))
 chip = imager::cimg2magick(imager::load.image(paste0(path,"/Survey/","reference_chip.jpg")))

 loc1 = 1
 loc2 = n_cols
 loc3 = n_cols*n_rows - (n_cols - 1)
 loc4 = n_cols*n_rows
 
 imgs[loc1] = magick::image_composite(imgs[loc1], magick::image_scale(chip, paste0("x",chip_width)), offset = "+0+0")
 imgs[loc2] = magick::image_composite(imgs[loc2], magick::image_scale(chip, paste0("x",chip_width)), offset = paste0("+",size_out-chip_width,"+0"))
 imgs[loc3] = magick::image_composite(imgs[loc3], magick::image_scale(chip, paste0("x",chip_width)), offset = paste0("+0+",asr*size_out-chip_width))
 imgs[loc4] = magick::image_composite(imgs[loc4], magick::image_scale(chip, paste0("x",chip_width)), offset = paste0("+",size_out-chip_width,"+",asr*size_out-chip_width))
 
 setwd(path_out)
 pdf(paste0("Roster_",i,".pdf"), height=width*asr*n_rows, width=n_cols*width)
 plot(magick::image_montage(imgs, geometry = paste0("x",size_out,"+0+0"), tile=paste0(n_cols,"x",n_rows)))
 dev.off()
 setwd(path)
  }
 }
}
