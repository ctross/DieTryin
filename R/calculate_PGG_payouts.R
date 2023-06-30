#' A function to calculate payouts for RICH public goods games
#'
#' This function allows you to quickly calculate PGG payouts. See details below. 
#' @param 
#' path Full path to main folder.
#' @param 
#' K The number of players in the public goods game.
#' @param 
#' B The endowment provided to each person in the public goods game.
#' @param 
#' Mu The scalar on the goods provided to the public pot.
#' @param 
#' NA_Payout What value is assigned to NAs?
#' @export
#' @examples
#' \dontrun{
#'   calculate_PGG_payouts(path=path, K=5, B=20, Mu=2, NA_Payout=10)
#'                    }


calculate_PGG_payouts = function(path, K=5, B=20, Mu=2, NA_Payout=10){
  d = read.csv(paste0(path,"/Results/","SubsetContributions-SummaryTable.csv"))
  d_AID = d[,which(colnames(d) %in% paste0("AID",1:K))]
  d_public = d[,which(colnames(d) %in% paste0("Offer",1:K))]
  d_public[is.na(d_public)] = NA_Payout
  d_private = B - d_public
  d_PG = Mu*(rowSums(d_public)/K)

  d_mixture = d_private 

   for(k in 1:K){
    d_mixture[,k] = d_mixture[,k] + d_PG
   }

  d_blend = data.frame(ID = factor(as.vector(t(d_AID))), Payout = as.numeric(as.vector(t(d_mixture))))

  d_payout = aggregate(d_blend$Payout, by=list(ID=d_blend$ID), FUN=sum)

  colnames(d_payout) = c("ID", "Payout")

  print(d_payout)
  write.csv(d_payout, paste0(path,"/Results/PGG_Payouts.csv"))
} 

