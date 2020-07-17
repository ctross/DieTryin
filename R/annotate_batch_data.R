#' A helper function
#'
#' This is a helper function to check hue
#' @param 
#' x An object.
#' @export


annotate_batch_data <- function (path = path, results, HHID, RID, day, month, year, name, PID, game, order, seed = 1){

	        N <- length(results)
	        prep <- vector("list", N)

	        for(i in 1:N){
              prep[[i]] <- results[[i]][[1]]
	        }

	        results <- do.call(rbind,prep)
   
            headpage <- cbind(c("HHID", "RID", "Day", "Month","Year", "Name", "PID", "Game", "Order", "Seed", "CheckSum", "Self", "Other"), 
                              c(HHID, RID, day, month, year, name, PID, game, order, seed, NA, NA, NA))

            res <- cbind(as.character(results$AID),results$Color,as.character(results$Case))

            res.all <- matrix(NA, nrow = dim(headpage)[1] + dim(res)[1], ncol = dim(headpage)[2] + dim(res)[2])


            res.all[1:dim(headpage)[1], 1:dim(headpage)[2]] <- headpage
            res.all[c(1:dim(res)[1]) + dim(headpage)[1], c(1:dim(res)[2]) + dim(headpage)[2]] <- as.matrix(res)
            res.all[1, 3:5] <- c("AlterID", "CoinsPlaced", "Question")
         

            path_out <- paste0(path, "/", res.all[8, 2])
            
            write.table(res.all, paste0(path_out, "/", res.all[7,2], ".csv"), row.names = FALSE, col.names = FALSE, sep = ",")
    }

