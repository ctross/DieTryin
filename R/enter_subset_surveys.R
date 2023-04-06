#' A function to enter subset survey data from games like the RICH PGG.
#' Useful for partner choice and public goods games.
#' 
#'
#' @param path Path to RICH folder.
#' @return The SubsetContributions template CSVs will be updated to include data on contribution levels.
#' @export
#' @examples
#' \dontrun{
#' enter_subset_surveys(path)
#' }
#'

enter_subset_surveys = function(path){
    GID = readline("What is the Game ID (GID)?: ")
    d_AZ = read.csv(paste0(path, "/SubsetContributions/", GID,".csv"))
    d_Top <<- d_AZ
    data.entry(d_Top)
    res = as.data.frame(d_Top)
        
    write.csv(res, paste0(path, "/SubsetContributions/", GID,".csv"),row.names = FALSE)
}

