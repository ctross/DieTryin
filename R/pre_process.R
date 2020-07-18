#' A helper function
#'
#' This is a helper function to pre-process images
#' @param 
#' x An object.
#' @export

pre_process <- function(path=path, ID, GID="Blank", BID=c("A","B"), pre_processed=FALSE){
 blank_photos_to_read <- paste0(GID, "_", ID, "_",BID,".jpg")
 blank_path <- paste0(path, "/ResultsPhotosSmall/", blank_photos_to_read)
 blank_images <- grab_images(blank_path)
 blank_locs <- grab_points(blank_path, pre_processed=pre_processed)
 return(list(blank_images,blank_locs))
}
