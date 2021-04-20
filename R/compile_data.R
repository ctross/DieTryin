#' A function to compile CSV data from RICH economic games into an edgelist and summary table
#'
#' This function allows you to merge the individual-specific CSVs. Simply set a path to the main folder. Then run the function. See details below.
#' @param 
#' path Full path to main folder.
#' @param 
#' game Select the data to merge. "GivingData" for Giving. "LeavingData" for Leaving. "ReducingData" for Reducing. Other folders can be compiled as well, by
#' putting the folder name here: e.g., "FriendshipTies"
#' @param 
#' batch Do the tie data come from the batched-processed image classifier? If so, set batch=TRUE, so that an extra column with game ID is added.
#' @export
#' @examples
#' \dontrun{
#'   compile_data(path=path, game="GivingData")
#'                    }
         
compile_data = function(path=path, game="GivingData", batch=FALSE){

 files = list.files(path=paste0(path,"/",game), pattern="*.csv")
 Basic = vector("list",length(files))
                              
 for(i in 1:length(files)){         
  Basic[[i]] = matrix(read.csv(paste0(path,"/",game,"/",files[i]),stringsAsFactors = FALSE, header = FALSE))
   }

 Nc<-c()
 for(i in 1:length(files)){
   Nc[i] = length(Basic[[i]][[1]])
   }

 Nk<-c()
 for(i in 1:length(files)){
   Nk[i] = length(matrix(read.csv(paste0(path,"/",game,"/",files[i]),stringsAsFactors = FALSE)))
   }

 
 Data = matrix(NA,ncol=13,nrow=length(files))
 colnames(Data) = Basic[[1]][[1]][1:13]
 for(i in 1:length(files)){
   Data[i,] = Basic[[i]][[2]][1:13]
   }                         
 
 
                 
   DataF = data.frame(HHID=as.factor(Data[,1]),
                     RID=as.factor(Data[,2]),
                     Day=as.numeric(as.character(Data[,3])),
                     Month=as.numeric(as.character(Data[,4])),
                     Year=as.numeric(as.character(Data[,5])),
                     Name=as.character(Data[,6]),
                     ID=as.factor(Data[,7]),
                     Order=(Data[,9]),
                     Seed=as.numeric(Data[,10]),
                     CheckSum=as.numeric(Data[,11]),
                     Self=as.numeric(Data[,12]),
                     Other=as.numeric(Data[,13])
                     )
           
    DataFb = vector("list",length(files))
         if(batch==FALSE){
    for(i in 1:length(files)){
    Scrap = as.data.frame(cbind(   Basic[[i]][[3]],
                                  Basic[[i]][[4]])[14:length(Basic[[i]][[4]]),])
    colnames(Scrap) = c("AID","CoinsPlaced")
          DataFb[[i]] =  data.frame(ID=rep(DataF$ID[i],length(Scrap$AID)),AID=Scrap$AID,CoinsPlaced=Scrap$CoinsPlaced)
                } 
                }
       else{
           for(i in 1:length(files)){
    Scrap = as.data.frame(cbind(Basic[[i]][[3]],
                               Basic[[i]][[4]],
                               Basic[[i]][[5]])[14:length(Basic[[i]][[4]]),])
    colnames(Scrap) = c("AID","CoinsPlaced","Question")
        DataFb[[i]] =  data.frame(ID=rep(DataF$ID[i],length(Scrap$AID)),AID=Scrap$AID,CoinsPlaced=Scrap$CoinsPlaced,Question=Scrap$Question)
                } 
                
       }
         
         
   X = do.call(rbind,DataFb)
   
   write.csv(DataF, file=paste0(path,"/","Results/",game,"-SummaryTable.csv")) 
   write.csv(X, file=paste0(path,"/","Results/",game,"-EdgeList.csv"))
   }
                 
