#' A function to automatically enter social network/ RICH games data from photographs
#'
#' This function allows you to significantly speed up data entry by using photographs of game boards before and after token allocation. 
#' The auto_enter_data function is the workhorse of DieTryin, but is not normally
#' called directly, but rather, through auto_enter_all which organizes and simplifies the workflow.
#' @param 
#' path Full path to main folder.
#' @param 
#' pattern File extension of photos. Should be ".jpg" or ".JPG". 
#' @param 
#' start Location of start of PID in file name. If files are saved as "XXX.jpg" for example, this is 1.
#' @param 
#' stop Location of end of PID in file name. If files are saved as "XXX.jpg" for example, this is 3.
#' @param 
#' seed A seed for the random number generator to sort the order of photos in the array. This should match the seed used to make the survey.
#' @param 
#' n_panels Number of frames/panels/blocks of photos to be output. I use four big panels and randomize their order at each game.
#' @param 
#' n_rows Number of rows per panel. With 7cm x 10cm photos, I use five rows of photos per panel.
#' @param 
#' n_cols Number of cols per panel. With 7cm x 10cm photos, I use six to eight cols of photos per panel.
#' @param 
#' lower_hue_threshold A vector of lower hue thresholds for each token color. To use three token colors, instead of the single token in the defaults, use: e.g., c(120, 210, 330).
#' @param 
#' upper_hue_threshold A vector of upper hue thresholds for each token color. To use three token colors, instead of the single token in the defaults, use: e.g., c(150, 250, 355).
#' @param 
#' plot_colors A vector of labels indicating which token color was used. The first entry must say "empty", other colors can be named as desired, but must be real color names in R. 
#' These colors correspond to the above-listed token hues, and this vector should be one cell longer than the hue threshold vectors. 
#' @param 
#' thresh Difference in hue density between pre- and post-treatment game boards required to code a token color as present. Can be vectorized if mulple token colors are in use: e.g., c(0.05, 0.35, 0.05).
#' @param 
#' img The image to be classified, stored in "imager" format. Supplied via the pre-processing code.
#' @param 
#' locs Locations of the corners of the game boards in the image file. Supplied via the pre-processing code.
#' @param 
#' ID Unique ID code of the player of the game.
#' @param 
#' game ID code of the case/game/question: e.g., "Friendship" or "GaveFood".
#' @param 
#' clean Used to pass the hue results from the control condition into the token-treatment condition so that DieTryin can calculate contrasts.
#' @param 
#' ordered A vector of photo IDs can be provided to over-ride automatic sorting.
#' @param 
#' lower_saturation_threshold Lower limit of greyness before the hue of such pixels is excluded from density calculations.
#' @param 
#' lower_luminance_threshold Lower limit of darkness before the hue of such pixels is excluded from density calculations.
#' @param 
#' upper_luminance_threshold Upper limit of lightness before the hue of such pixels is excluded from density calculations.
#' @param 
#' border_size Image border excluded from density calculations as a fraction of image size.
#' @param 
#' iso_blur Width of Gaussian filter applied to image. A value of 0 turns off blurring.
#' @param 
#' histogram_balancing Should histogram balancing be used to correct grey-out images? This sometimes helps, but sometimes hurts, classification accuracy. This will cause token hue to shift as well, so hue thresholds will need to be revised if this is used.
#' @param 
#' direction How image skew is corrected. The "forward" algorithm is fast but lower quality. The "backward" algorithm is slow but higher quality. See imwarp function in imager package for technical details.
#' @param 
#' pre_processed Are photographs pre-processed such that image correction steps can be skipped? If FALSE, then user must pre-process images using DieTryings tools. If TRUE game board photographs must be cropped and unskewed. 
#' Some Android and IOS apps, like Tiny Scanner, provide a means of producing such photographs of the game boards at the time of data collection.
#' @return A list of classified ties and associated data, ID tables, and corrected images.
#' @export
#' @examples
#' \dontrun{
#'   auto_enter_data(path, pattern=".jpg", start=1, stop=3, seed=1, n_panels=2, n_rows=4, n_cols=5, 
#'                    lower_hue_threshold=120, upper_hue_threshold=155, plot_colors=c("empty","darkgreen"), 
#'                    thresh=0.05, img, locs, ID="CTR", game="GameID", clean=NA, ordered=NULL,
#'                    lower_saturation_threshold=0.05, lower_luminance_threshold=0.05, 
#'                    upper_luminance_threshold=0.95, border_size=0.25, iso_blur=1, histogram_balancing=FALSE,
#'                    direction="backward", pre_processed=FALSE)
#'                    }
auto_enter_data = function (path, pattern = ".jpg", start = 1, stop = 3, seed = 1, n_panels = 4, n_rows = 5, n_cols = 8, 
                            lower_hue_threshold = 210, upper_hue_threshold = 230, plot_colors = c("empty","darkblue"),
                            img, locs, ID="CTR", game="FriendshipTies", thresh=c(0.05), clean=NA, ordered=NULL,
                            lower_saturation_threshold=0.05, lower_luminance_threshold=0.05, 
                            upper_luminance_threshold=0.95, border_size=0.25, iso_blur=1,
                            histogram_balancing=FALSE, direction="backwards", pre_processed=FALSE) {
  
 ########################## Sort and prepare IDs if needed
    path_in = paste0(path, "/StandardizedPhotos")
    IDS = substr(list.files(path_in, pattern, full.names = FALSE), start = start, stop = stop)
    L = length(IDS)
    
    if(L > n_panels * n_rows * n_cols) {
        stop("ID vector exceeds the product of n_panels*n_rows*n_cols")
        }
  
    if(length(lower_hue_threshold) > 5){
      stop("DieTryin supports a max of 5 token colors")
      }
  
    else{
        set.seed(seed)

     if(is.null(ordered)){
      SortedIDS = c(IDS[order(runif(length(IDS),0,1))])
           }
  
      else{
      SortedIDS = ordered
      } 

      SortedIDS = c(SortedIDS, rep("", (n_panels * n_rows * n_cols - L))) 

      X = matrix(SortedIDS, nrow = n_rows, ncol = n_panels * n_cols, byrow = FALSE)
      x = vector("list", n_panels)

      y1 = vector("list", n_panels)
      y2 = vector("list", n_panels)
      y3 = vector("list", n_panels)
      y4 = vector("list", n_panels)
      y5 = vector("list", n_panels)

      cleaned_imgs = vector("list", n_panels)

     ########################## Then process the image data
     for (i in 1:n_panels) x[[i]] = X[, c(1:n_cols) + n_cols * (i - 1)]

     for(i in 1:n_panels){
      Temp_1 = shatter(img[[i]], locs[[i]], n_rows, n_cols, lower_hue_threshold, upper_hue_threshold, 
                       lower_saturation_threshold=lower_saturation_threshold, 
                       lower_luminance_threshold=lower_luminance_threshold, 
                       upper_luminance_threshold=upper_luminance_threshold, 
                       border_size=border_size,
                       iso_blur=iso_blur,
                       histogram_balancing=histogram_balancing,
                       direction=direction,
                       pre_processed=pre_processed)
       
      # Extract layers from the processed array for each token color          
      if(length(lower_hue_threshold)>=1)
        y1[[i]] = Temp_1[[1]][,,1]
      if(length(lower_hue_threshold)>=2)
        y2[[i]] = Temp_1[[1]][,,2]
      if(length(lower_hue_threshold)>=3)
        y3[[i]] = Temp_1[[1]][,,3]
      if(length(lower_hue_threshold)>=4)
        y4[[i]] = Temp_1[[1]][,,4]
      if(length(lower_hue_threshold)>=5)
        y5[[i]] = Temp_1[[1]][,,5]

        cleaned_imgs[[i]] = Temp_1[[2]]
            }

      # Compile all token color data into a single data frame      
      if(length(lower_hue_threshold)==1)
        Res = data.frame(PID=rep(ID,n_panels*n_rows*n_cols), AID=c(do.call(cbind,x)), Value_1=c(do.call(cbind,y1)))
      if(length(lower_hue_threshold)==2)
        Res = data.frame(PID=rep(ID,n_panels*n_rows*n_cols), AID=c(do.call(cbind,x)), Value_1=c(do.call(cbind,y1)), Value_2=c(do.call(cbind,y2)))
      if(length(lower_hue_threshold)==3)
        Res = data.frame(PID=rep(ID,n_panels*n_rows*n_cols), AID=c(do.call(cbind,x)), Value_1=c(do.call(cbind,y1)), Value_2=c(do.call(cbind,y2)), Value_3=c(do.call(cbind,y3)))
      if(length(lower_hue_threshold)==4)
        Res = data.frame(PID=rep(ID,n_panels*n_rows*n_cols), AID=c(do.call(cbind,x)), Value_1=c(do.call(cbind,y1)), Value_2=c(do.call(cbind,y2)), Value_3=c(do.call(cbind,y3)), Value_4=c(do.call(cbind,y4)))
      if(length(lower_hue_threshold)==5)
        Res = data.frame(PID=rep(ID,n_panels*n_rows*n_cols), AID=c(do.call(cbind,x)), Value_1=c(do.call(cbind,y1)), Value_2=c(do.call(cbind,y2)), Value_3=c(do.call(cbind,y3)), Value_4=c(do.call(cbind,y4)), Value_5=c(do.call(cbind,y5)))

        Res = Res[which(Res$AID != ""),]
      
         # Now, if this is not the pre-game/control condition photo, calculate contrasts    
         if(game != "Blank"){
           
            if(length(lower_hue_threshold)>=1){
             Res$Control_1 = clean$Value_1
             Res$Diff_1 = Res$Value_1-Res$Control_1
             Res$Binary_1 = ifelse(Res$Diff_1 > thresh[1],1,0)
             }

            if(length(lower_hue_threshold)>=2){
             Res$Control_2 = clean$Value_2
             Res$Diff_2 = Res$Value_2-Res$Control_2
             Res$Binary_2 = ifelse(Res$Diff_2 > thresh[2],1,0)
             }

            if(length(lower_hue_threshold)>=3){
             Res$Control_3 = clean$Value_3
             Res$Diff_3 = Res$Value_3-Res$Control_3
             Res$Binary_3 = ifelse(Res$Diff_3 > thresh[3],1,0)
             }

            if(length(lower_hue_threshold)>=4){
             Res$Control_4 = clean$Value_4
             Res$Diff_4 = Res$Value_4-Res$Control_4
             Res$Binary_4 = ifelse(Res$Diff_4 > thresh[4],1,0)
             }

            if(length(lower_hue_threshold)>=5){
             Res$Control_5 = clean$Value_5
             Res$Diff_5 = Res$Value_5-Res$Control_5
             Res$Binary_5 = ifelse(Res$Diff_5 > thresh[5],1,0)
             }

            # Now decide which color to code each potential tie
             if(length(lower_hue_threshold)==1){
              Color = ifelse(Res$Binary_1==1, plot_colors[2], plot_colors[1])
              } else{

            Diffs =  Res[,which(colnames(Res) %in% c("Diff_1","Diff_2","Diff_3","Diff_4","Diff_5"))]
            Binary = Res[,which(colnames(Res) %in% c("Binary_1","Binary_2","Binary_3","Binary_4","Binary_5"))]
            Color = rep(NA,dim(Res)[1])  

             for(i in 1:dim(Res)[1]){

               if(sum(Binary[i,])==0){
                Color[i] = plot_colors[1]
                }
              
               if(sum(Binary[i,])==1){
                 Color[i] = plot_colors[1 + which(Binary[i,]==1)]
                 }

               if(sum(Binary[i,])>1){
                 Color[i] = plot_colors[1 + which(Diffs[i,]==max(Diffs[i,]))]
                 }

                 }}

            Res$Case = game
            Res$Color = Color
             }

            # write.csv(Res,paste0(path,"/Results/",game,"_",ID,".csv")) 
            return(list(Res, x, cleaned_imgs))
    }
}


