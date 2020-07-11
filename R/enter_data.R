#' A function to enter data from RICH economic games
#'
#' This function allows you to speed up data entry. Simply set a path to the main folder. Then run the function. In the popup, enter "Y" if the data is for a new person, and "N" if it is for a second game from the same person. In the header for each data.entry table, you must enter 'G', 'L', or 'R' to indicate which game: Giving, Leaving, or Reducing, the data correspond to. In the function call, set the number of panels, and the number of rows and cols per panel, as in the build_survey file. Then run the function. This function relies on the 'data.entry' function. This is only supported on some builds. I've only tested on Windows. See details below.
#' @param 
#' path Full path to main folder.
#' @param 
#' pattern File extension of photos. Should be .jpg or .JPG. 
#' @param 
#' start Location of start of PID in file name. If files are saved as XXX.jpg for example, this is 1.
#' @param 
#' stop Location of end of PID in file name. ... and this is 3.  
#' @param 
#' seed A seed for the random number generator to sort the order of photos in the array. This should match the seed used to make the survey.
#' @param 
#' frames Number of frames/panels/blocks of photos to be output. I use four big panels and randomize order at each game.
#' @param 
#' rows Number of rows per panel. With 7cm x 10cm photos, I use five rows of photos per panel.
#' @param 
#' cols Number of rows per panel. With 7cm x 10cm photos, I use six to eight cols of photos per panel.
#' @export
#' @examples
#' \dontrun{
#'   enter_data(path=path,pattern=".jpg",start=1,stop=3,seed=1,frames=4,rows=5,cols=8)
#'                    }
           
enter_data <- function (path = path, pattern = ".jpg", start = 1, stop = 3, 
    seed = 1, frames = 4, rows = 5, cols = 8, ordered=NULL) 
{
    path_in <- paste0(path, "/StandardizedPhotos")
    IDS <- substr(list.files(path_in, pattern, full.names = FALSE), 
        start = start, stop = stop)
    L <- length(IDS)
    if (L > frames * rows * cols) {
        stop("ID vector exceeds the product of frames*rows*cols")
    }
    else {
        set.seed(seed)
        
  if(is.null(ordered)){
  SortedIDS <- c(IDS[order(runif(length(IDS),0,1))])
    }
  
  else{
    SortedIDS <- ordered
  } 
               
        SortedIDS <- c(SortedIDS, rep("", (frames * rows * cols - 
            L))) 
            X2 <<- X <<- matrix(SortedIDS, nrow = rows, ncol = frames * 
            cols, byrow = FALSE)
        x <<- vector("list", frames)
        for (i in 1:frames) x[[i]] <<- X[, c(1:cols) + cols * 
            (i - 1)]
        AZ <- readline("New Person ?: ")
        if (AZ == "Y") 
            headpage <<- cbind(c("HHID", "RID", "Day", "Month", 
                "Year", "Name", "PID", "Game", "Order", "Seed"), 
                c(rep(NA, 9), seed))
        data.entry(headpage)
        for (i in 1:frames) {
            z <<- x[[i]]
            data.entry(z)
            x[[i]] <<- z
        }
             

        if (headpage[8, 2] == "G" || headpage[8, 2] == "L" || 
            headpage[8, 2] == "R") {
            for (i in 1:frames) X2[, c(1:cols) + cols * (i - 
                1)] <<- x[[i]]
            x.all <<- suppressWarnings(as.numeric(c(X2)))
            x.all[is.na(x.all)] <<- 0
            res <<- data.frame(AID = c(X)[1:L], Allocation = as.numeric(c(x.all)[1:L]))
            headpage2 <<- rbind(headpage, cbind(c("CheckSum", 
                "Self", "Other"), c(sum(res$Allocation), ifelse(length(which(res$AID == 
                headpage[7, 2])) > 0, res$Allocation[which(res$AID == 
                headpage[7, 2])], 0), sum(res$Allocation) - ifelse(length(which(res$AID == 
                headpage[7, 2])) > 0, res$Allocation[which(res$AID == 
                headpage[7, 2])], 0))))
            res.all <<- matrix(NA, nrow = dim(headpage2)[1] + 
                dim(res)[1], ncol = dim(headpage2)[2] + dim(res)[2])
            res.all[1:dim(headpage2)[1], 1:dim(headpage2)[2]] <<- headpage2
            res.all[c(1:dim(res)[1]) + dim(headpage2)[1], c(1:dim(res)[2]) + 
                dim(headpage2)[2]] <<- as.matrix(res)
            res.all[1, 3:4] <<- c("AlterID", "CoinsPlaced")
        }
        else {
            stop("Game must be G, L, or R")
        }
        if (res.all[8, 2] == "G") {
            path_out <- paste0(path, "/GivingData")
        }
        if (res.all[8, 2] == "L") {
            path_out <- paste0(path, "/LeavingData")
        }
        if (res.all[8, 2] == "R") {
            path_out <- paste0(path, "/ReducingData")
        }
        write.table(res.all, paste0(path_out, "/", res.all[7, 
            2], ".csv"), row.names = FALSE, col.names = FALSE, 
            sep = ",")
    }
}



