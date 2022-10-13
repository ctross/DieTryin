#' A helper function
#'
#' This is a helper function to grab points, called from within pre_process. This function will return the locations of the image corners. If pre_processed is FALSE
#' then the user much click on the corners using the automated workflow. If set to TRUE, then it will return the coners of the image file itself.
#' @param 
#' path_imgs Path to the image files
#' @param 
#' pre_processed Are photographs pre-processed such that image correction steps can be skipped? If FALSE, then user must pre-process images using DieTryings tools. If TRUE game board photographs must be cropped and unskewed. 
#' Some Android and IOS apps, like Tiny Scanner, provide a means of producing such photographs of the game boards at the time of data collection.
#' @return 
#' A list containing an array of corner locations.
#' @export

grab_points = function(path_imgs, pre_processed=FALSE){
  imgs = vector("list",length(path_imgs))
  locs = vector("list",length(path_imgs))
  
   for(i in 1:length(imgs)){
    imgs[[i]] = imager::load.image(path_imgs[i])

     if(pre_processed==FALSE){

      if(dim(imgs[[i]])[1]>dim(imgs[[i]])[2]){
        imgs[[i]] = imager::imrotate(imgs[[i]],90)}

      loc1 = imager::grabPoint(imgs[[i]])  
      loc2 = imager::grabPoint(imgs[[i]])  
      loc3 = imager::grabPoint(imgs[[i]])  
      loc4 = imager::grabPoint(imgs[[i]])  

       locs[[i]] = rbind(loc1,loc2,loc3,loc4)
        }
         else{
  
       loc1 = c(0, dim(imgs[[i]])[2])  
       loc2 = c(dim(imgs[[i]])[1], dim(imgs[[i]])[2])  
       loc3 = c(dim(imgs[[i]])[1], 0)  
       loc4 = c(0,0)  
            }
        locs[[i]] = rbind(loc1,loc2,loc3,loc4)
   }

 return(locs)
}
