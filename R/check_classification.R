#' A function to check automatic classifications
#'
#' This is a helper function to plot infered connections. Run this for each game, and it will plot predicted tokens on the real images. If model performance
#' is not good, then tweak parameters until classification is accurate. Photos are saved in the "ClassifiedPhotos" folder.
#' @param 
#' path Full path to main folder.
#' @param 
#' dat Classification output. 
#' @param 
#' n_panels Number of frames/panels/blocks of photos to be output. I use four big panels and randomize their order at each game.
#' @param 
#' n_rows Number of rows per panel. With 7cm x 10cm photos, I use five rows of photos per panel.
#' @param 
#' n_cols Number of cols per panel. With 7cm x 10cm photos, I use six to eight cols of photos per panel.
#' @param 
#' focal ID code of focal individual.
#' @param 
#' case ID code for game/case/question: e.g., "GivingGame".
#' @export
#' @examples
#' \dontrun{
#'  check_classification(path=path, dat[[1]], n_panels = 2, n_rows=4, n_cols=5, focal="SK1", case="FriendshipsData")
#'                    }

check_classification = function(path, dat, n_panels = 2, n_rows=4, n_cols=5, focal="BS1", case="Friend"){
 for(k in 1:n_panels){
  Q = dat[[3]][[k]]
  P = dat[[1]]
  Z = dat[[2]][[k]]

  Z_F = Z_B = Z_X = Z_Y = Z

  for(i in 1:dim(Z)[1]){
   for(j in 1:dim(Z)[2]){
    if(Z[i,j] != ""){
    Z_B[i,j] = P$Color[which(P$AID==Z[i,j])]
    Z_X[i,j] = (dim(Q)[1]/n_cols)*j - 0.5*(dim(Q)[1]/n_cols)
    Z_Y[i,j] = (dim(Q)[2]/n_rows)*i - 0.5*(dim(Q)[2]/n_rows)
    }
    }
   }

 df = data.frame(x=c(Z_X), y=c(Z_Y), b=c(Z_B))
 df2 = df[which(df$b != "" & df$b != "empty"),]
 df2$b = as.character(df2$b) 

 jpeg(file=paste0(path,"/ClassifiedPhotos/",case,"_",focal,"_","frame_",k,".jpg"))
  plot(Q)
 points(as.numeric(as.character(df2$x)),as.numeric(as.character(df2$y)),col="white",pch=20, cex=6)
 points(as.numeric(as.character(df2$x)),as.numeric(as.character(df2$y)),col=as.character(df2$b),pch=20, cex=5)
 dev.off()
}}
