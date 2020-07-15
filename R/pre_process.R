pre_process <- function(path=path, ID, GID="Blank", BID=c("A","B")){
 blank_photos_to_read <- paste0(GID, "_", ID, "_",BID,".jpg")
 blank_path <- paste0(path, "/ResultsPhotosSmall/", blank_photos_to_read)
 blank_images <- grab_images(blank_path)
 blank_locs <- grab_points(blank_path)
 return(list(blank_images,blank_locs))
}
