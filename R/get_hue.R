#' get_hue
#'
#' This is a helper function to identify HSL hue values. ust set a path to an image, and click to get a pixel color.
#' @param 
#' path Full path to image. file.choose() is often useful. Example: get_hue(file.choose())
#' @export

get_hue = function(path){
 img = load.image(path)
 asr1 = dim(img)[1:2]
 asr = asr1[1]/asr1[2]
 size_out = 500

 y = resize(img,round(size_out*asr,0),size_out)         

 y[1:round(dim(y)[1]*0.2,0),1:50,1,2:3] <-0
 y[1:round(dim(y)[1]*0.2,0),1:50,1,1] <-1

 y2 = draw_text(y, 35, 15, "Exit", "black", opacity = 1, fsize = 30)
 y3 = RGBtoHSL(y2)

 exit_path = 1
 safebreak = 1
 while(exit_path>0){

 loc = grabPoint(y2)    

 hue_val = round(y3[loc[1],loc[2],1,1],0)

 y3[round(dim(y)[1]*0.4,0):dim(y)[1],1:50,1,1] = hue_val
 y3[round(dim(y)[1]*0.4,0):dim(y)[1],1:50,1,2] = 1
 y3[round(dim(y)[1]*0.4,0):dim(y)[1],1:50,1,3] = 0.5
 y4 = HSLtoRGB(y3)

 y2 = draw_text(y4, round(dim(y)[1]*0.5,0) + 15, 15, paste0("Hue = ",hue_val), "black", opacity = 1, fsize = 30)

 if(loc[1]<round(dim(y)[1]*0.2,0) & loc[2] < 50){
 exit_path = -1
 }
  safebreak = safebreak+1
  if(safebreak>300){
  	exit_path = -1
  }
}}


