auto_enter_data <- function (path = path, pattern = ".jpg", start = 1, stop = 3, seed = 1, frames = 4, rows = 5, cols = 9, 
                        img, locs, focal="NEW",case="N",thresh=0.3, clean=NA) {
    path_in <- paste0(path, "/StandardizedPhotos")
    IDS <- substr(list.files(path_in, pattern, full.names = FALSE), 
        start = start, stop = stop)
    L <- length(IDS)
    if (L > frames * rows * cols) {
        stop("ID vector exceeds the product of frames*rows*cols")
    }
    else {
        set.seed(seed)
        SortedIDS <- c(IDS[order(runif(length(IDS), 0, 1))])
        SortedIDS <- c(SortedIDS, rep("", (frames * rows * cols - L))) 

         X <- matrix(SortedIDS, nrow = rows, ncol = frames * cols, byrow = FALSE)
         x <- vector("list", frames)
         y <- vector("list", frames)

        for (i in 1:frames) x[[i]] <- X[, c(1:cols) + cols * 
            (i - 1)]

        for(i in 1:frames)
        y[[i]] <- shatter(img[[i]],locs[[i]],rows, cols)
            }

            Res <- data.frame(PID=rep(focal,frames*rows*cols), AID=c(do.call(cbind,x)), Value=c(do.call(cbind,y)))
            Res <- Res[which(Res$AID != ""),]
            if(case != "Blank"){
            Res$Control <- clean$Value
            Res$Diff <- Res$Value-Res$Control
            Res$Binary <- ifelse(Res$Value-clean$Value > thresh,1,0)
             }

            write.csv(Res,paste0(path,"Results/",case,"_",focal,".csv")) 
            return(Res)
        }
