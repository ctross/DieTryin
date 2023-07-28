#' Batch resize
#'
#' This is a helper function to batch resize raw images of game boards. Set scaler=1 to simply pass images from the raw folder into the output file folder with no scaling.
#' @param 
#' path path Full path to main folder.
#' @param 
#' scaler Factor by which image will be shrunk.
#' @export

downsize = function(path=path, scaler=2){
  path_imgs_big = paste0(path, "/ResultsPhotos/")
  path_imgs_small = paste0(path, "/ResultsPhotosSmall/")
  to_read = list.files(path_imgs_big, full.names=TRUE)
  to_save = list.files(path_imgs_big)

  for(i in 1:length(to_read)){
   imgRaw = imager::load.image(to_read[i])
   img = imager::resize(imgRaw,round(imager::width(imgRaw)/scaler),round(imager::height(imgRaw)/scaler))

   out_path = gsub(" ", "", paste0(path_imgs_small,to_save[i]), fixed = TRUE)
   imager::save.image(img, out_path, quality = 0.9)
   }
}
