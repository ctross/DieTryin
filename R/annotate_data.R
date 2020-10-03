#' A function to append header data to token allocation data entered via scan of photographs
#'
#' This function appends header data to automatically entered data. The end result is a "csv" with the same structure as that
#' which is exported by the standard enter_data function.
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
#' annotate_data(path = path, results=Game_all5, HHID="BPL", RID="CR", day=12, month=4, year=2020, 
#'                name = "Cody", PID="CTR", game="TrustData", order="BA", seed = 1)
#'                    }

annotate_data = function (path, results, HHID, RID, day, month, year, name, ID, game, order, seed){
            results = results[[1]][[1]]
            
            self = NA
            checksum = sum(results$Color!="empty") 
            other = NA
            
            results$Color <- ifelse(results$Color=="empty", "0", results$Color)
            headpage = cbind(c("HHID", "RID", "Day", "Month","Year", "Name", "PID", "Game", "Order", "Seed", "CheckSum", "Self", "Other"), 
                              c(HHID, RID, day, month, year, name, ID, game, order, seed, checksum, self, other))

            res = cbind(as.character(results$AID),results$Color)

            res.all = matrix(NA, nrow = dim(headpage)[1] + dim(res)[1], ncol = dim(headpage)[2] + dim(res)[2])


            res.all[1:dim(headpage)[1], 1:dim(headpage)[2]] = headpage
            res.all[c(1:dim(res)[1]) + dim(headpage)[1], c(1:dim(res)[2]) + dim(headpage)[2]] = as.matrix(res)
            res.all[1, 3:4] = c("AlterID", "CoinsPlaced")
         

            path_out = paste0(path, "/", res.all[8, 2])
            
            write.table(res.all, paste0(path_out, "/", res.all[7,2], ".csv"), row.names = FALSE, col.names = FALSE, sep = ",")
    }
