#' A helper function
#'
#' This is a helper function to grab points
#' @param 
#' x An object.
#' @export

grab_points <- function(path_imgs){
  imgs <- vector("list",length(path_imgs))
  locs <- vector("list",length(path_imgs))

 for(i in 1:length(imgs)){
  imgs[[i]] <- load.image(path_imgs[i])

  loc1<-grabPoint(imgs[[i]])  
  loc2<-grabPoint(imgs[[i]])  
  loc3<-grabPoint(imgs[[i]])  
  loc4<-grabPoint(imgs[[i]])  

  locs[[i]] <- rbind(loc1,loc2,loc3,loc4)
 }
 return(locs)
}
