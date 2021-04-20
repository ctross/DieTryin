enter_data <- function (path = path, pattern = ".jpg", start = 1, stop = 3, 
     n_panels = 4, n_rows = 5, n_cols = 8, seed = 1, ordered=NULL, add=c("Nothing")) 
{
    path_in <- paste0(path, "/StandardizedPhotos")
       
     if(is.null(ordered)){
       IDS <- substr(list.files(path_in, pattern, full.names = FALSE), start = start, stop = stop)
       L <- length(IDS)
       set.seed(seed)
       SortedIDS <- c(IDS[order(runif(length(IDS),0,1))])
       } else{
      SortedIDS <- ordered
      L <- length(SortedIDS)
      } 

    if (L > n_panels * n_rows * n_cols) {
        stop("ID vector exceeds the product of n_panels*n_rows*n_cols")
    }
    else {
               
        SortedIDS <- c(SortedIDS, rep("", (n_panels * n_rows * n_cols - 
            L))) 
            X2 <<- X <<- matrix(SortedIDS, nrow = n_rows, ncol = n_panels * 
            n_cols, byrow = FALSE)
        x <<- vector("list", n_panels)
        for (i in 1:n_panels) x[[i]] <<- X[, c(1:n_cols) + n_cols * 
            (i - 1)]
        AZ <- readline("New Person ?: ")
        if (AZ == "Y" | AZ == "y") 
            headpage <<- cbind(c("HHID", "RID", "Day", "Month", 
                "Year", "Name", "ID", "Game", "Order", "Seed"), 
                c(rep(NA, 9), seed))
        data.entry(headpage)
        for (i in 1:n_panels) {
            z <<- x[[i]]
            data.entry(z)
            x[[i]] <<- z
        }
             
        if (headpage[8, 2] %in% c(add, "G", "L", "R") ) {
           if (headpage[8, 2] %in% c("G", "L", "R") ){
            for (i in 1:n_panels) X2[, c(1:n_cols) + n_cols * (i - 
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
                   
           if (headpage[8, 2] %in% c(add) ){
              for (i in 1:n_panels) X2[, c(1:n_cols) + n_cols * (i - 
                1)] <<- x[[i]]
            x.all <<- c(X2)
            x.all[x.all %in% SortedIDS] <<- 0
            res <<- data.frame(AID = c(X)[1:L], Allocation = c(x.all)[1:L])
            headpage2 <<- rbind(headpage, cbind(c("CheckSum", 
                "Self", "Other"), c(length(which(res$Allocation !="0")), NA, NA)))
            res.all <<- matrix(NA, nrow = dim(headpage2)[1] + 
                dim(res)[1], ncol = dim(headpage2)[2] + dim(res)[2])
            res.all[1:dim(headpage2)[1], 1:dim(headpage2)[2]] <<- headpage2
            res.all[c(1:dim(res)[1]) + dim(headpage2)[1], c(1:dim(res)[2]) + 
                dim(headpage2)[2]] <<- as.matrix(res)
            res.all[1, 3:4] <<- c("AlterID", "CoinsPlaced")
              }
        }
        else {
            stop("Cannot find folder. Does game code match the directories added in setup_folders?")
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
         
        for(i in 1:length(add)){       
        if (res.all[8, 2] == add[i]) {
            path_out <- paste0(path, "/", add[i])
        }   
        }
               
        write.table(res.all, paste0(path_out, "/", res.all[7, 
            2], ".csv"), row.names = FALSE, col.names = FALSE, 
            sep = ",")
    }
}
