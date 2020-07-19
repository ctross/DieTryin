#' Image rotation, de-skewing, and cropping
#'
#' This is a helper function to extract the game board images from an arbitrary photograph.
#' @param 
#' image The image, stored in "imager" format, to be processed. Supplied via the pre-processing code.
#' @param 
#' locations Locations of the corners of the game boards in the image file. Supplied via the pre-processing code.
#' @param 
#' histogram_balancing Should histogram balancing be used to correct grey-out images? This sometimes helps, but sometimes hurts, classification accuracy. This will cause token hue to shift as well, so hue thresholds will need to be revised if this is used.
#' @param 
#' direction How image skew is corrected. The "forward" algorithm is fast but lower quality. The "backward" algorithm is slow but higher quality. See imwarp function in imager package for technical details.
#' @return A square, cropped, and unskewed image.
#' @export

extractor = function(image, locations, histogram_balancing=FALSE, direction="backward"){
  # extractor takes in a raw image file and corner locations, and unwarps image
   require(MASS)
   require(imager)

  ####################### First get four corners of image in order: top left, top right, bottom right, bottom left
  loc1 = locations[1,]  
  loc2 = locations[2,] 
  loc3 = locations[3,] 
  loc4 = locations[4,]   

 ####################### Now solve for the transformation matrix
 ### Source image
  A = matrix(NA,nrow=3,ncol=3)
  A[3,] = rep(1,3)
  A[1,] = c(loc1[1],loc2[1],loc3[1])
  A[2,] = c(loc1[2],loc2[2],loc3[2])

  B = c(loc4[1],loc4[2],1)

  Y = solve(A,B)

  A[,1] = A[,1]*Y[1]
  A[,2] = A[,2]*Y[2]
  A[,3] = A[,3]*Y[3]

 ### Target image
  W = dist(locations[1:2,])
  H = dist(locations[2:3,])
  A2 = matrix(NA,nrow=3,ncol=3)
  A2[3,] = rep(1,3)
  A2[1,] = c(0,W,W)
  A2[2,] = c(0,0,H) 

  B2 = c(0,H,1)

  Y2 = solve(A2,B2)

  A2[,1] = A2[,1]*Y2[1]
  A2[,2] = A2[,2]*Y2[2]
  A2[,3] = A2[,3]*Y2[3]

 ### Transformation matrix
  C = A2 %*% ginv(A)
 
 ### Define backwards map function for imager
  map_F = function(x,y){
  	y_new = x_new = rep(NA,length(x))
  	for(i in 1:length(x)){
  	q = c(x[i],y[i],1)
  	q2 = C %*% q
  	x_new[i] = q2[1]/q2[3]
  	y_new[i] = q2[2]/q2[3]
     }
   list(x=x_new, y=y_new)
   }

  map_B = function(x,y){
    y_new = x_new = rep(NA,length(x))
    for(i in 1:length(x)){
    q = c(x[i],y[i],1)
    q2 = solve(C,q)
    x_new[i] = q2[1]/q2[3]
    y_new[i] = q2[2]/q2[3]
     }
   list(x=x_new, y=y_new)
   }
   
   if(direction=="backward"){
   img_warp = imwarp(image, map=map_B, direction="backward", coordinates="absolute") 
                             }
   if(direction=="forward"){
   img_warp = imwarp(image, map=map_F, direction="forward", coordinates="absolute") 
                             }
   img_cut = imsub(img_warp, x < W, y < H) # %>% plot

  #Split across colour channels,
  if(histogram_balancing==TRUE){
  hist.eq = function(im) as.cimg(ecdf(im)(im),dim=dim(im))
  cn = imsplit(img_cut,"c")
  cn.eq = map_il(cn,hist.eq) #run hist.eq on each
  img_cut = imappend(cn.eq,"c") 
   }
 return(img_cut)
}
 
