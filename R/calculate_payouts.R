#' A function to calculate payouts for RICH economic games using the compiled edgelists
#'
#' This function allows you to quickly calculate payouts. See details below. Note that coins allocated to alters who do not themselves appear as focals are refunded to the donors.
#' @param 
#' path Full path to main folder.
#' @param 
#' game Indicates which game data will be used in payout calculations. All combinations of G for the giving/allocation game, L for the leaving/taking game, and
#' R for the reduction/punishment game, are accepted: i.e., type "G", "L", "R", "GL", "GR", "LR", or "GLR".
#' @param 
#' GV Value of coins used in giving game.
#' @param 
#' LV Value of coins used in leaving game.
#' @param 
#' KV Value of coins kept in reducing game.
#' @param 
#' RV Value of punishment tokens used in reducing game. Should be negative.
#' @export
#' @examples
#' \dontrun{
#'   calculate_payouts(path=path, pattern=".jpg", start=1, stop=3, game="GLR", GV=1, LV=0.5, KV=1, RV=-4)
#'                    }
         
calculate_payouts = function(path, pattern=".jpg", start=1, stop=3, game="GLR", GV=1, LV=0.5, KV=1, RV=-4){ 
                               
path_photos = paste0(path,"/StandardizedPhotos")
path_csv  = path
path_res = paste0(path,"/Results")

start2  = start
stop2   = stop

 if(game=="GLR" | game=="GL" | game=="GR" | game=="G"){
######################################################################## Give
   IDS = substr(list.files(path_photos, pattern, full.names=FALSE), start = start, stop = stop) # Load IDs from Photos
   IDS2 = substr(list.files(path=paste0(path_csv,"/","GivingData"), pattern="*.csv", full.names=FALSE), start = start2, stop = stop2) # Load IDs from CSVs
   
   IDS2 = IDS2[which(IDS2 %in% IDS)]
   
   NonRespondents = IDS[which(!IDS %in% IDS2)]
   
   X = read.csv(paste0(path_res,"/","GivingData-EdgeList.csv"))

   X2 = X[which(X$AID %in% NonRespondents),]
   X3 = X[which(! X$AID %in% NonRespondents),]

   X2$CoinsPlaced = as.numeric(as.character(X2$CoinsPlaced))

   GiveNR = tapply(X2$CoinsPlaced, X2$AID, sum)
   GiverNR = tapply(X2$CoinsPlaced, X2$ID, sum)

   X3$CoinsPlaced = as.numeric(as.character(X3$CoinsPlaced))

   Give = tapply(X3$CoinsPlaced, X3$AID, sum)

   Give = sort(Give)
   GiverNR = sort(GiverNR)

   Give = Give[which(names(Give) %in% IDS)]
   GiveNR = GiveNR[which(names(GiveNR) %in% IDS)]

   a1 = order(names(Give))
   a2 = order(names(GiverNR))

   Give[a1]
   GiverNR[a2]

   if(sum(names(Give[a1])!=names(GiverNR[a2]))>0){
   stop("IDs not matched")}
   
   GiveSum =  GiverNR[a2] + Give[a1]
   
   GiveVal = GiveSum*GV
    }

if(game=="GLR" | game=="GL" | game=="LR" | game=="L"){
############################################################### Leave
   IDS = substr(list.files(path_photos, pattern, full.names=FALSE), start = start, stop = stop) # Load IDs from Photos
   IDS2 = substr(list.files(path=paste0(path_csv,"/","LeavingData"), pattern="*.csv", full.names=FALSE), start = start2, stop = stop2) # Load IDs from CSVs
   
   IDS2 = IDS2[which(IDS2 %in% IDS)]
   
   NonRespondents = IDS[which(!IDS %in% IDS2)]
   
   X = read.csv(paste0(path_res,"/","LeavingData-EdgeList.csv"))

   X2 = X[which(X$AID %in% NonRespondents),]
   X3 = X[which(! X$AID %in% NonRespondents),]

   X2$CoinsPlaced = as.numeric(as.character(X2$CoinsPlaced))

   LeaveNR = tapply(X2$CoinsPlaced, X2$AID, sum)
   LeaverNR = tapply(X2$CoinsPlaced, X2$ID, sum)

   X3$CoinsPlaced = as.numeric(as.character(X3$CoinsPlaced))

   Leave = tapply(X3$CoinsPlaced, X3$AID, sum)

   Leave = sort(Leave)
   LeaverNR = sort(LeaverNR)

   Leave = Leave[which(names(Leave) %in% IDS)]
   LeaveNR = LeaveNR[which(names(LeaveNR) %in% IDS)]

   a1 = order(names(Leave))
   a2 = order(names(LeaverNR))

   Leave[a1]
   LeaverNR[a2]

  if(sum(names(Leave[a1])!=names(LeaverNR[a2]))>0){
  stop("IDs not matched")}

  LeaveSum =  LeaverNR[a2] + Leave[a1]
  
  TakeVal = LeaveSum*LV
}

 if(game=="GLR" | game=="GR" | game=="LR" | game=="R"){
########################################################### Reduce
   IDS = substr(list.files(path_photos, pattern, full.names=FALSE), start = start, stop = stop) # Load IDs from Photos
   IDS2 = substr(list.files(path=paste0(path_csv,"/","ReducingData"), pattern="*.csv", full.names=FALSE), start = start2, stop = stop2) # Load IDs from CSVs
   
   IDS2 = IDS2[which(IDS2 %in% IDS)]
   
   NonRespondents = IDS[which(!IDS %in% IDS2)]
   
   X = read.csv(paste0(path_res,"/","ReducingData-EdgeList.csv"))

   X2 = X[which(X$AID %in% NonRespondents),]
   X3 = X[which(! X$AID %in% NonRespondents),]
   
   
   X2$CoinsPlaced = as.numeric(as.character(X2$CoinsPlaced))

   ReduceNR = tapply(X2$CoinsPlaced, X2$AID, sum)
   ReducerNR = tapply(X2$CoinsPlaced, X2$ID, sum)

   X3$CoinsPlaced = as.numeric(as.character(X3$CoinsPlaced))

   Xs = X3[which(as.character(X3$ID)==as.character(X3$AID)),]
   Xo = X3[which(as.character(X3$ID)!=as.character(X3$AID)),]

   Kept = tapply(Xs$CoinsPlaced, Xs$AID, sum)
   Reduced = tapply(Xo$CoinsPlaced, Xo$AID, sum)

   Kept = sort(Kept)
   Reduced = sort(Reduced)
   ReducerNR = sort(ReducerNR)

   Kept = Kept[which(names(Kept) %in% IDS)]   
   Reduced = Reduced[which(names(Reduced) %in% IDS)]
   ReducerNR = ReducerNR[which(names(ReducerNR) %in% IDS)]

   a1 = order(names(Kept))
   a2 = order(names(ReducerNR))
   a3 = order(names(Reduced))

   Kept[a1]
   ReducerNR[a2]
   Reduced[a3]

   names(Kept[a1])==names(ReducerNR[a2])
     if(sum(names(Kept[a1])!=names(ReducerNR[a2]))>0 | sum(names(Kept[a1])!=names(Reduced[a3]))>0){
  stop("IDs not matched")}
  
   KeptSum =  ReducerNR[a2] + Kept[a1]
   
   ReducedSum =  Reduced[a3]
   
   KeptVal = KeptSum*KV
   ReducedVal = ReducedSum*RV
}

######################################################################### Payout

if(game=="GLR"){
Vals = c(GiveVal,TakeVal,KeptVal,ReducedVal)
GIDS = c(names(GiveVal),names(TakeVal),names(KeptVal),names(ReducedVal))
Payout = tapply(Vals, GIDS, sum, na.rm=TRUE)
}

if(game=="G"){
Vals = c(GiveVal)
GIDS = c(names(GiveVal))
Payout = tapply(Vals, GIDS, sum, na.rm=TRUE)
}

if(game=="L"){
Vals = c(GTakeVal)
GIDS = c(names(TakeVal))
Payout = tapply(Vals, GIDS, sum, na.rm=TRUE)
}

if(game=="R"){
Vals = c(KeptVal,ReducedVal)
GIDS = c(names(KeptVal),names(ReducedVal))
Payout = tapply(Vals, GIDS, sum, na.rm=TRUE)
}

if(game=="GL"){
Vals = c(GiveVal,TakeVal)
GIDS = c(names(GiveVal),names(TakeVal))
Payout = tapply(Vals, GIDS, sum, na.rm=TRUE)
}

if(game=="GR"){
Vals = c(GiveVal,KeptVal,ReducedVal)
GIDS = c(names(GiveVal),names(KeptVal),names(ReducedVal))
Payout = tapply(Vals, GIDS, sum, na.rm=TRUE)
}

if(game=="LR"){
Vals = c(TakeVal,KeptVal,ReducedVal)
GIDS = c(names(TakeVal),names(KeptVal),names(ReducedVal))
Payout = tapply(Vals, GIDS, sum, na.rm=TRUE)
}

print(Payout)

Payouts<<-Payout

write.csv(Payout,paste0(path,"/Results/Payouts.csv"))
}
  
