

check_classification <- function(path="C:/Users/Mind Is Moving/Desktop/RICH/", dat, n_frames = 2, n_rows=4, n_cols=5, focal="BS1", case="Friend"){
 for(k in 1:n_frames){
  Q <- dat[[3]][[k]]
  P <- dat[[1]]
  Z <- dat[[2]][[k]]

  Z_F <- Z_B <- Z_X <- Z_Y <- Z

  for(i in 1:dim(Z)[1]){
   for(j in 1:dim(Z)[2]){
    if(Z[i,j] != ""){
    Z_B[i,j] <- P$Color[which(P$AID==Z[i,j])]
    Z_F[i,j] <- P$CheckSum[which(P$AID==Z[i,j])]
    Z_X[i,j] <- (dim(Q)[1]/n_cols)*j - 0.5*(dim(Q)[1]/n_cols)
    Z_Y[i,j] <- (dim(Q)[2]/n_rows)*i - 0.5*(dim(Q)[2]/n_rows)
    }
    }
   }

 df <- data.frame(x=c(Z_X), y=c(Z_Y), b=c(Z_B), f=c(Z_F))
 df2 <- df[which(df$b != "" & df$b != "empty"),]
 df2$b <- as.character(df2$b) 
 df2$b[which(as.numeric(as.character(df2$f)) > 1)] <- "black"

 jpeg(file=paste0(path,"ClassifiedPhotos/",case,"_",focal,"_","frame_",k,".jpg"))
  plot(Q)
 points(as.numeric(as.character(df2$x)),as.numeric(as.character(df2$y)),col="white",pch=20, cex=5)
 points(as.numeric(as.character(df2$x)),as.numeric(as.character(df2$y)),col=as.character(df2$b),pch=20, cex=4.4)
 dev.off()
}}
