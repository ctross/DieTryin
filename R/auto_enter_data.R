auto_enter_data <- function (path = path, pattern = ".jpg", start = 1, stop = 3, seed = 1, n_frames = 4, n_rows = 5, n_cols = 9, 
                         lower_hue_threshold = 210, upper_hue_threshold = 230, colors = c("empty","darkred"),
                        img, locs, focal="NEW",case="N",thresh=0.25, clean=NA, ordered=NULL,
                         lower_saturation_threshold=lower_saturation_threshold, 
                        lower_luminance_threshold=lower_luminance_threshold, 
                     upper_luminance_threshold=upper_luminance_threshold, 
                     border_size=border_size,
                     iso_blur=iso_blur) {
    path_in <- paste0(path, "/StandardizedPhotos")
    IDS <- substr(list.files(path_in, pattern, full.names = FALSE), 
        start = start, stop = stop)
    L <- length(IDS)
    if (L > n_frames * n_rows * n_cols) {
        stop("ID vector exceeds the product of n_frames*n_rows*n_cols")
    }
    if(length(lower_hue_threshold) > 5){
      stop("DieTryin supports a max of 5 token colors")
    }
    else {
        set.seed(seed)

          if(is.null(ordered)){
      SortedIDS <- c(IDS[order(runif(length(IDS),0,1))])
    }
  
     else{
     SortedIDS <- ordered
      } 

        SortedIDS <- c(SortedIDS, rep("", (n_frames * n_rows * n_cols - L))) 

         X <- matrix(SortedIDS, nrow = n_rows, ncol = n_frames * n_cols, byrow = FALSE)
         x <- vector("list", n_frames)

         y1 <- vector("list", n_frames)
         y2 <- vector("list", n_frames)
         y3 <- vector("list", n_frames)
         y4 <- vector("list", n_frames)
         y5 <- vector("list", n_frames)

         cleaned_imgs <- vector("list", n_frames)

        for (i in 1:n_frames) x[[i]] <- X[, c(1:n_cols) + n_cols * 
            (i - 1)]

        for(i in 1:n_frames){
        Temp_1 <- shatter(img[[i]], locs[[i]], n_rows, n_cols, lower_hue_threshold, upper_hue_threshold, 
                     lower_saturation_threshold=lower_saturation_threshold, 
                     lower_luminance_threshold=lower_luminance_threshold, 
                     upper_luminance_threshold=upper_luminance_threshold, 
                     border_size=border_size,
                     iso_blur=iso_blur)
          
        if(length(lower_hue_threshold)>=1)
        y1[[i]] <- Temp_1[[1]][,,1]
        if(length(lower_hue_threshold)>=2)
        y2[[i]] <- Temp_1[[1]][,,2]
        if(length(lower_hue_threshold)>=3)
        y3[[i]] <- Temp_1[[1]][,,3]
        if(length(lower_hue_threshold)>=4)
        y4[[i]] <- Temp_1[[1]][,,4]
        if(length(lower_hue_threshold)>=5)
        y5[[i]] <- Temp_1[[1]][,,5]

        cleaned_imgs[[i]] <- Temp_1[[2]]
            }

        if(length(lower_hue_threshold)==1)
        Res <- data.frame(PID=rep(focal,n_frames*n_rows*n_cols), AID=c(do.call(cbind,x)), Value_1=c(do.call(cbind,y1)))
        if(length(lower_hue_threshold)==2)
        Res <- data.frame(PID=rep(focal,n_frames*n_rows*n_cols), AID=c(do.call(cbind,x)), Value_1=c(do.call(cbind,y1)), Value_2=c(do.call(cbind,y2)))
        if(length(lower_hue_threshold)==3)
        Res <- data.frame(PID=rep(focal,n_frames*n_rows*n_cols), AID=c(do.call(cbind,x)), Value_1=c(do.call(cbind,y1)), Value_2=c(do.call(cbind,y2)), 
          Value_3=c(do.call(cbind,y3)))
        if(length(lower_hue_threshold)==4)
        Res <- data.frame(PID=rep(focal,n_frames*n_rows*n_cols), AID=c(do.call(cbind,x)), Value_1=c(do.call(cbind,y1)), Value_2=c(do.call(cbind,y2)), 
          Value_3=c(do.call(cbind,y3)), Value_4=c(do.call(cbind,y4)))
        if(length(lower_hue_threshold)==5)
        Res <- data.frame(PID=rep(focal,n_frames*n_rows*n_cols), AID=c(do.call(cbind,x)), Value_1=c(do.call(cbind,y1)), Value_2=c(do.call(cbind,y2)), 
          Value_3=c(do.call(cbind,y3)), Value_4=c(do.call(cbind,y4)), Value_5=c(do.call(cbind,y5)))

        Res <- Res[which(Res$AID != ""),]
         if(case != "Blank"){

            if(length(lower_hue_threshold)>=1){
             Res$Control_1 <- clean$Value_1
             Res$Diff_1 <- Res$Value_1-Res$Control_1
             Res$Binary_1 <- ifelse(Res$Diff_1 > thresh,1,0)
             Res$CheckSum <- Res$Binary_1
             Res$Color <- colors[Res$Binary_1 + 1]
             }

            if(length(lower_hue_threshold)>=2){
             Res$Control_2 <- clean$Value_2
             Res$Diff_2 <- Res$Value_2-Res$Control_2
             Res$Binary_2 <- ifelse(Res$Diff_2 > thresh,1,0)
             Res$CheckSum <- Res$Binary_1 + Res$Binary_2
             Res$Color <- colors[Res$Binary_1 + Res$Binary_2*2 + 1]
             }

            if(length(lower_hue_threshold)>=3){
             Res$Control_3 <- clean$Value_3
             Res$Diff_3 <- Res$Value_3-Res$Control_3
             Res$Binary_3 <- ifelse(Res$Diff_3 > thresh,1,0)
             Res$CheckSum <- Res$Binary_1 + Res$Binary_2 + Res$Binary_3
             Res$Color <- colors[Res$Binary_1 + Res$Binary_2*2 + Res$Binary_3*3 + 1]
             }

            if(length(lower_hue_threshold)>=4){
             Res$Control_4 <- clean$Value_4
             Res$Diff_4 <- Res$Value_4-Res$Control_4
             Res$Binary_4 <- ifelse(Res$Diff_4 > thresh,1,0)
             Res$CheckSum <- Res$Binary_1 + Res$Binary_2 + Res$Binary_3 + Res$Binary_4 
             Res$Color <- colors[Res$Binary_1 + Res$Binary_2*2 + Res$Binary_3*3 + Res$Binary_4*4 + 1]
             }

            if(length(lower_hue_threshold)>=5){
             Res$Control_5 <- clean$Value_5
             Res$Diff_5 <- Res$Value_5-Res$Control_5
             Res$Binary_5 <- ifelse(Res$Diff_5 > thresh,1,0)
             Res$CheckSum <- Res$Binary_1 + Res$Binary_2 + Res$Binary_3 + Res$Binary_4 + Res$Binary_5
             Res$Color <- colors[Res$Binary_1 + Res$Binary_2*2 + Res$Binary_3*3 + Res$Binary_4*4 + Res$Binary_5*5 + 1]
             }
           }

        Res$Case <- case

            write.csv(Res,paste0(path,"Results/",case,"_",focal,".csv")) 
            return(list(Res, x, cleaned_imgs))
        }
      }
