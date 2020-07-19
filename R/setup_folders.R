#' A function to create the main directory used in the workflow
#'
#' This function allows you to build the directories for the data, and to customize which folders appear
#' @param 
#' path Full path to where folder will be stored. This folder will be called "RICH"
#' @param 
#' add A vector of additional data storage sub-folders to add to directory.
#' @export
#' @examples
#' \dontrun{
#' path = "C:/Users/BirdySanders/Desktop"
#' games_to_add = c("FriendshipsData", "TrustData", "NetworkData", "LikertData")
#' setup_folders(path, add=games_to_add)
#'                    }
         
setup_folders = function(path=path, add=NULL){
  dir.create(file.path(path, "RICH"))
  
  dir.create(file.path(paste0(path,"/","RICH"),"RawPhotos"))
  dir.create(file.path(paste0(path,"/","RICH"),"StandardizedPhotos"))
  dir.create(file.path(paste0(path,"/","RICH"),"ClassifiedPhotos"))
  dir.create(file.path(paste0(path,"/","RICH"),"ResultsPhotos"))
  dir.create(file.path(paste0(path,"/","RICH"),"ResultsPhotosSmall"))
  
  dir.create(file.path(paste0(path,"/","RICH"),"Survey"))
  
  dir.create(file.path(paste0(path,"/","RICH"),"GivingData"))
  dir.create(file.path(paste0(path,"/","RICH"),"LeavingData"))
  dir.create(file.path(paste0(path,"/","RICH"),"ReducingData"))
  
  if(! is.null(add)){
           for(i in 1:length(add))
            dir.create(file.path(paste0(path,"/","RICH"),add[i]))
           }
  
  dir.create(file.path(paste0(path,"/","RICH"),"Results"))
  
  file.copy(paste0(path.package("DieTryin"),"/","header.txt"), paste0(path,"/","RICH","/","Survey/","header.txt"))
  file.copy(paste0(path.package("DieTryin"),"/","paperandpencil.sty"), paste0(path,"/","RICH","/","Survey/","paperandpencil.sty"))

path <<- paste0(path,"/RICH")  
}                                                   




