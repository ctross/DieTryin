#' A helper function
#'
#' This is a helper function to grab images. Called from pre_process
#' @param 
#' path_imgs Path to images.
#' @return A raw image.
#' @export

grab_images = function(path_imgs){
  imgs = vector("list",length(path_imgs))

 for(i in 1:length(imgs)){
  imgs[[i]] = imager::load.image(path_imgs[i])

 #    if(dim(imgs[[i]])[1]>dim(imgs[[i]])[2]){
 #      imgs[[i]] = imager::imrotate(imgs[[i]],90)}
 #     }
 return(imgs)
}
