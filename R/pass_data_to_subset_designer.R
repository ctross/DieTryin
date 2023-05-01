#' A function to pass partner choice data to the subset suvery builder tool.
#' Useful for the RICH partner choice and public goods game.
#' 
#' @param path Path to RICH folder.
#' @param folder Which folder holds the partner choice data? Maybe "PartnerChoice".
#' @return The data files in "folder", will be cloned into "SubsetData", where they can be read 
#'  by the survey tool builder functions.
#' @export
#' @examples
#' \dontrun{
#' pass_data_to_subset_designer(path, folder="PartnerChoice")
#' }
#'

pass_data_to_subset_designer = function(path, folder){
    to_read = list.files(paste0(path, "/",folder,"/"), full.names=TRUE)
    to_read_short = list.files(paste0(path, "/",folder,"/"))

    for(i in 1:length(to_read)){
     res = read.csv(to_read[i])
     write.csv(res, paste0(path, "/SubsetData/", to_read_short[i]),row.names = FALSE)
    }
}

