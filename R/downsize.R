downsize <- function(path=path, scaler=2){
  library(imager)
  path_imgs_big <- paste0(path, "/ResultsPhotos/")
  path_imgs_small <- paste0(path, "/ResultsPhotosSmall/")
  to_read <- list.files(path_imgs_big, full=TRUE)
  to_save <- list.files(path_imgs_big)

  for(i in 1:length(to_read)){
   imgRaw <- load.image(to_read[i])
   img <- resize(imgRaw,round(width(imgRaw)/scaler),round(height(imgRaw)/scaler))

   save.image(img, paste0(path_imgs_small,to_save[i]), quality = 0.9)
   }
}
