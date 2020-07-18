#' A helper function
#'
#' This is a helper function to grab points
#' @param 
#' x An object.
#' @export
grab_points <- function(path_imgs, pre_processed=FALSE){
  imgs <- vector("list",length(path_imgs))
  locs <- vector("list",length(path_imgs))
  if(pre_processed==FALSE){
   for(i in 1:length(imgs)){
    imgs[[i]] <- load.image(path_imgs[i])

     if(dim(imgs[[i]])[1]>dim(imgs[[i]])[2]){
    imgs[[i]]<-imrotate(imgs[[i]],90)}

  loc1<-grabPoint(imgs[[i]])  
  loc2<-grabPoint(imgs[[i]])  
  loc3<-grabPoint(imgs[[i]])  
  loc4<-grabPoint(imgs[[i]])  

  locs[[i]] <- rbind(loc1,loc2,loc3,loc4)
   }}
 else{
  loc1<-c(0, dim(imgs[[i]])[2])  
  loc2<-c(dim(imgs[[i]])[1], dim(imgs[[i]])[2])  
  loc3<-c(dim(imgs[[i]])[1], 0)  
  loc4<-c(0,0)  

  locs[[i]] <- rbind(loc1,loc2,loc3,loc4)
 }

 return(locs)
}
