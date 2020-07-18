#' A function to append header data to token allocation data entered via scan of photographs
#'
#' This is a helper function to check hue
#' @param 
#' x An object.
#' @export

annotate_data <- function (path, results, HHID, RID, day, month, year, name, PID, game, order, seed){
            results <- results[[1]][[1]]
            self <- ifelse(results$Color[which(as.character(results$PID)==as.character(results$AID))]=="empty",0,1)
            checksum <- sum(results$Color!="empty") 
            other <- checksum - self
            headpage <- cbind(c("HHID", "RID", "Day", "Month","Year", "Name", "PID", "Game", "Order", "Seed", "CheckSum", "Self", "Other"), 
                              c(HHID, RID, day, month, year, name, PID, game, order, seed, checksum, self, other))

            res <- cbind(as.character(results$AID),results$Color)

            res.all <- matrix(NA, nrow = dim(headpage)[1] + dim(res)[1], ncol = dim(headpage)[2] + dim(res)[2])


            res.all[1:dim(headpage)[1], 1:dim(headpage)[2]] <- headpage
            res.all[c(1:dim(res)[1]) + dim(headpage)[1], c(1:dim(res)[2]) + dim(headpage)[2]] <- as.matrix(res)
            res.all[1, 3:4] <- c("AlterID", "CoinsPlaced")
         

            path_out <- paste0(path, "/", res.all[8, 2])
            
            write.table(res.all, paste0(path_out, "/", res.all[7,2], ".csv"), row.names = FALSE, col.names = FALSE, sep = ",")
    }
