#' A helper function
#'
#' This is a helper function to grab images
#' @param 
#' x An object.
#' @export

grab_images <- function(path_imgs){
  imgs <- vector("list",length(path_imgs))

 for(i in 1:length(imgs)){
  imgs[[i]] <- load.image(path_imgs[i])
  }
 return(imgs)
}
