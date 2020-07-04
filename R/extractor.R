extractor <- function(img, Locs, nr=3, nc=5, N=10, w=7, h=11){
  loc1<-Locs[1,]  
  loc2<-Locs[2,] 
  loc3<-Locs[3,] 
  loc4<-Locs[4,]   

  A <- matrix(NA,nrow=3,ncol=3)
  A[3,] <- rep(1,3)
  A[1,] <- c(loc1[1],loc2[1],loc3[1])
  A[2,] <- c(loc1[2],loc2[2],loc3[2])

  B <- c(loc4[1],loc4[2],1)

  Y <- solve(A,B)

  A[,1] <- A[,1]*Y[1]
  A[,2] <- A[,2]*Y[2]
  A[,3] <- A[,3]*Y[3]

  W <- w*nc*N
  H <- h*nr*N
  A2 <- matrix(NA,nrow=3,ncol=3)
  A2[3,] <- rep(1,3)
  A2[1,] <- c(0,W,W)
  A2[2,] <- c(0,0,H) 

  B2 <- c(0,H,1)

  Y2 <- solve(A2,B2)

  A2[,1] <- A2[,1]*Y2[1]
  A2[,2] <- A2[,2]*Y2[2]
  A2[,3] <- A2[,3]*Y2[3]

  C <- A2 %*% ginv(A)

  map <- function(x,y){
  	y_new <- x_new <- rep(NA,length(x))
  	for(i in 1:length(x)){
  	q = c(x[i],y[i],1)
  	#q2 = C %*% q
  	q2 = solve(C,q)
  	x_new[i]=q2[1]/q2[3]
  	y_new[i]=q2[2]/q2[3]
     }
   list(x=x_new, y=y_new)
   }

   img_warp <- imwarp(img,map=map,direction="backward") 
   img_cut <- imsub(img_warp,x < W, y < H) # %>% plot
 return(img_cut)
}
