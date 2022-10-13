#' A function to standardize photos for RICH economic games or roster-based social network approaches
#'
#' This function allows you to speed up photo standardization. Simply set a path to the main folder. The filenames of all raw photos should have same string length.
#' These should be the IDs of the respondents. Then run the function. Photos can be croped, rotated, and resized to a constant aspect ratio. This function relies on 'imager'. 
#' First, if spin=TRUE click a quadrant of the photo to determine how it should be spun (See details below). Then drag a box to crop. Eyeball the aspect ratio you want, 
#' then the program will find the closest box with the legal aspect ratio. Files are saved to the StandardizedPhotos subfolder.
#' @param 
#' path Full path to main folder.
#' @param 
#' pattern File extension. Should be ".jpg" or ".JPG".
#' @param 
#' start Location of start of PID in file name. If files are saved as "XXX.jpg" for example, this is 1.
#' @param 
#' stop Location of end of PID in file name. If files are saved as "XXX.jpg" for example, this is 3.
#' @param 
#' size_out Pixel width of outputted JPGs.
#' @param 
#' border_size Add a black border of X pixels.
#' @param 
#' asr Aspect ratio of outputted JPGs.
#' @param 
#' id_range If a value is provided here OR in id_names, then not all photos will be processed. Use a vector of numbers here to indicate which IDs to process:  
#' i.e., c(1:13) to run on only the first 13 photos.
#' @param 
#' id_names Or, just give the IDs themselves: i.e., c("XX1","XX2","XY1").
#' @param 
#' spin If spin is set to TRUE, then a two step process is opened. First the user selects a spin, then the user crops. On the first pop-up, by clicking in the upper-left corner, 
#' the photo is not spun. If one clicks on the upper-right a 90 clockwise spin is done before opening the cropping window. Bottom-right, 180. Bottom-left, 270.
#' @export
#' @examples
#' \dontrun{
#' standardize_photos(path=path, pattern=".jpg", start=1, stop=3, 
#'                    size_out=1000, border_size=10, asr=1.6180, 
#'                    id_range=1, id_names=NULL, spin=TRUE)
#'                    }
 
standardize_photos = function(path, pattern=".jpg", start=1, stop=3,
                              size_out=1000, border_size=10, asr=1.6180,
                              id_range=NULL, id_names=NULL, spin=FALSE){

   path_in = paste0(path,"/RawPhotos")
   path_out = paste0(path,"/StandardizedPhotos")
   ids = substr(list.files(path_in, pattern, full.names=FALSE), start = start, stop = stop) # Load IDs
   
   if(is.null(id_range) & is.null(id_names)){
     idset = 1:length(ids) 
     } else {
         if(is.null(id_names)){
         idset = id_range }
         else{ 
         idset = c(which(as.character(ids) %in% as.character(id_names)))} 
    }
    
 for( i in idset){
  pid = ids[i]                                       # Pick ID
  img = imager::load.image(paste0(path_in,"/",pid,pattern))  # Load Image
  size = dim(img)[1:2]
  
  if(spin==TRUE){
   img2 = img                                        # Define quadrants
  
   img2[round(dim(img2)[1]/2,0)+c(-1,0,1),,1,1] = 1
   img2[round(dim(img2)[1]/2,0)+c(-1,0,1),,1,2] = 0
   img2[round(dim(img2)[1]/2,0)+c(-1,0,1),,1,3] = 0
   
   img2[,round(dim(img2)[2]/2,0)+c(-1,0,1),1,1] = 1
   img2[,round(dim(img2)[2]/2,0)+c(-1,0,1),1,2] = 0
   img2[,round(dim(img2)[2]/2,0)+c(-1,0,1),1,3] = 0
   
   loc = imager::grabPoint(img2)                           # Check rotation
  
   if( loc[1]<(size[1]/2) & loc[2]<(size[2]/2) )   # Set Spin
   spin_ang = 0                                    #
   if( loc[1]>(size[1]/2) & loc[2]<(size[2]/2) )   #
   spin_ang = 90                                   #
   if( loc[1]>(size[1]/2) & loc[2]>(size[2]/2) )   #
   spin_ang = 180                                  #
   if( loc[1]<(size[1]/2) & loc[2]>(size[2]/2) )   #
   spin_ang = 270                                  #
  
   img = imager::imrotate(img, spin_ang, interp=2)
   }
  
  locs = imager::grabRect(img, output = "coord")                # Set picture range
  locs = locs[c(1,3,2,4)]                               # Swap IDS - Not sure why I do this!
  
  wid = locs[2]-locs[1]                                 # Rescale
  hig = locs[4]-locs[3]                                 #
  hig2 = round(wid*asr,0)                               #
  locs[4] = locs[3]+hig2                                #
                                                        #
  x = imager::imsub(img,x %inr% locs[1:2],y %inr% locs[3:4])    #
                                                                #
  y = imager::resize(x,size_out,round(size_out*asr,0))          #
 
  px = imager::Xc(y) <= border_size                           # Add border
  y[px] = 0                                                   #
  px = imager::Xc(y) >= size_out-border_size                  #
  y[px] = 0                                                   #
  px = imager::Yc(y) <= border_size                           #
  y[px] = 0                                                   #
  px = imager::Yc(y) >= asr*size_out-border_size              #
  y[px] = 0                                                   #

 imager::save.image(y,paste0(path_out,"/",pid,".jpg"),quality=1)  # Save image
 }
    
}



 
