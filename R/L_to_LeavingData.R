#' L_to_LeavingData
#'
#' This is a helper function to convert automatically entered token placements in the leaving game into
#' numeric data, as if it were manually entered.
#' @param 
#' path  The base file directory.
#' @param 
#' max_coins The maximum number of coins to be placed.
#' @param 
#' token_color The color label of the tokens used in the leaving game.
#' @return Nothing is returned by this function, but data from the folder "L" are duplicated to "LeavingData".
#' @export
L_to_LeavingData = function(path, max_coins, token_color){
 files = list.files(paste0(path,"/L"), full.names=TRUE)
 files_short = list.files(paste0(path,"/L"))
 
 for(i in 1:length(files)){
 bob=read.csv(files[i])
 bob$CoinsPlaced[bob$CoinsPlaced==token_color] = 1
 bob$CoinsPlaced[which(bob$AlterID==bob[6,2])] = 0

 bob[10,2] = max_coins
 bob[12,2] = sum(as.numeric(as.character(bob$CoinsPlaced)),na.rm=TRUE) 
 bob[11,2] = as.numeric(as.character(bob[10,2])) - as.numeric(as.character(bob[12,2]))

 bob = bob[, 1:4]

 bob$CoinsPlaced[which(bob$AlterID==bob[6,2])] = bob[11,2]

 write.csv(bob, paste0(path,"/LeavingData/",files_short[i]), row.names=FALSE)
 }
}
