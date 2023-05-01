#' A function to enter subset survey data from games like the RICH PGG.
#' Useful for data entry when a restricted sub-set of the photo roster is used in economic games.
#' 
#' @param path Path to RICH folder.
#' @return The template CSV files in the SubsetContributions folder will be updated to include 
#' data on contribution levels.
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

    #################### Save for global binding
    d_Top = d_Top
        
    write.csv(res, paste0(path, "/SubsetContributions/", GID,".csv"),row.names = FALSE)
}

