#' A function to create directory
#'
#' This function allows you to build the directories for the data
#' @param 
#' path Full path to where folder will be stored.
#' @export
#' @examples
#' \dontrun{
#'   path<-"C:\\Users\\Mind Is Moving\\Desktop"
#'   setup_folders(path)
#'                    }
         
setup_folders <- function(path=path){
  dir.create(file.path(path, "RICH"))
  
  dir.create(file.path(paste0(path,"/","RICH"),"RawPhotos"))
  dir.create(file.path(paste0(path,"/","RICH"),"StandardizedPhotos"))
  
  dir.create(file.path(paste0(path,"/","RICH"),"Survey"))
  
  dir.create(file.path(paste0(path,"/","RICH"),"GivingData"))
  dir.create(file.path(paste0(path,"/","RICH"),"LeavingData"))
  dir.create(file.path(paste0(path,"/","RICH"),"ReducingData"))
  
  dir.create(file.path(paste0(path,"/","RICH"),"Results"))
  
  file.copy(paste0(path.package("DieTryin"),"/","header.txt"), paste0(path,"/","RICH","/","Survey/","header.txt"))
  file.copy(paste0(path.package("DieTryin"),"/","paperandpencil.sty"), paste0(path,"/","RICH","/","Survey/","paperandpencil.sty"))

path <<- paste0(path,"/RICH")  
}                                                   




