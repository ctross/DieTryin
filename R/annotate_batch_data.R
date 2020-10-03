#' A function to append header data to token allocation data entered via batch scans of photographs
#'
#' This function appends header data to automatically entered data batch-wise. The end result is a "csv" with the same structure as that
#' which is exported by the standard enter_data function, but with one extra column for game ID.
#' @param 
#' path Full path to main folder.
#' @param 
#' results A cell from the results list exported by auto_enter_all. 
#' @param 
#' HHID Household ID of focal individual/respondent.
#' @param 
#' RID ID of researcher.
#' @param 
#' day Day of interview.
#' @param 
#' month Month of interview.
#' @param 
#' year Year of interview.
#' @param 
#' name Name of focal individual/respondent.
#' @param 
#' ID Unique ID of focal individual/respondent.
#' @param 
#' game ID for case/game/question.
#' @param 
#' order Order of frames/panels of photos as presented to the respodent: e.g., with 4 frames, "ABCD", "CDBA", etc. are legal entries.
#' @param 
#' seed A seed for the random number generator to sort the order of photos in the array. This should match the seed used to make the survey.
#' @export
#' @examples
#' \dontrun{
#'annotate_batch_data(path = path, results=Game_all6, HHID="JKF", RID="CR", day=11, month=3, year=2020, 
#'              name = "Walter W.", PID="CVD", game="LikertData", order="AB", seed = 1)
#'                    }

annotate_batch_data = function (path, results, HHID, RID, day, month, year, name, ID, game, order, seed){
            
            

	        N = length(results)
	        prep = vector("list", N)

	        for(i in 1:N){
              prep[[i]] = results[[i]][[1]]
	        }

	        results = do.call(rbind,prep)
	    results$Color <- ifelse(results$Color=="empty", "0", results$Color)
   
            headpage = cbind(c("HHID", "RID", "Day", "Month","Year", "Name", "PID", "Game", "Order", "Seed", "CheckSum", "Self", "Other"), 
                              c(HHID, RID, day, month, year, name, ID, game, order, seed, NA, NA, NA))

            res = cbind(as.character(results$AID),results$Color,as.character(results$Case))

            res.all = matrix(NA, nrow = dim(headpage)[1] + dim(res)[1], ncol = dim(headpage)[2] + dim(res)[2])


            res.all[1:dim(headpage)[1], 1:dim(headpage)[2]] = headpage
            res.all[c(1:dim(res)[1]) + dim(headpage)[1], c(1:dim(res)[2]) + dim(headpage)[2]] = as.matrix(res)
            res.all[1, 3:5] = c("AlterID", "CoinsPlaced", "Question")
         

            path_out = paste0(path, "/", res.all[8, 2])
            
            write.table(res.all, paste0(path_out, "/", res.all[7,2], ".csv"), row.names = FALSE, col.names = FALSE, sep = ",")
    }

