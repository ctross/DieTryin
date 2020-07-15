#' A function to build LaTeX survey tool for RICH economic games
#'
#' This function allows you to speed up data collection and photo randomization. Simply set a path the main folder.  Set the number of panels, and the number of rows and cols per panel. Then run the function. This function relies on 'xtable'. See details below.
#' @param 
#' path Full path to main folder.
#' @param 
#' pattern File extension of photos. Should be .jpg or .JPG. 
#' @param 
#' start Location of start of PID in file name. If files are saved as XXX.jpg for example, this is 1.
#' @param 
#' stop Location of end of PID in file name. ... and this is 3.  
#' @param 
#' seed A seed for the random number generator to sort the order of photos in the array. 
#' @param 
#' frames Number of frames/panels/blocks of photos to be output. I use four big panels and randomize order at each game.
#' @param 
#' rows Number of rows per panel. With 7cm x 10cm photos, I use five rows of photos per panel.
#' @param 
#' cols Number of rows per panel. With 7cm x 10cm photos, I use six to eight cols of photos per panel.
#' @export
#' @examples
#' \dontrun{
#'   build_survey(path=path,pattern=".jpg",start=1,stop=3,frames=4,seed=1, rows=5, cols=8)
#'                    }
  
build_survey <- function(path=path, pattern=".jpg", start=1, stop=3,
                         n_frames=4, n_rows=5, n_cols=8, seed=1, ordered = NULL ){
                         
path_out<-paste0(path,"/Survey")
require(xtable)
require(readr)
IDS <- substr(list.files(paste0(path,"/","StandardizedPhotos"), pattern, full.names=FALSE), start = start, stop = stop) # Load IDs from photos

L <- length(IDS)

if( L> n_frames*n_rows*n_cols){
stop("ID vector exceeds the product of n_frames*n_rows*n_cols")}
else{      
set.seed(seed)

  if(is.null(ordered)){
  SortedIDS <- c(IDS[order(runif(length(IDS),0,1))])
    }
  
  else{
    SortedIDS <- ordered
  }

SortedIDS<-c(SortedIDS,rep("~~~~",(n_frames*n_rows*n_cols - L)) )

 X <- matrix(paste0("\\LARGE \\color{gray}",SortedIDS), nrow=n_rows,ncol=n_frames*n_cols,byrow=FALSE)
 x <- vector("list",n_frames)
 
 for(i in 1:frames)
 x[[i]] <- xtable_custom(X[,c(1:n_cols)+n_cols*(i-1)])
 
Code <- c()
Code[1] <- read_file(paste0(path,"/Survey/","header.txt"))
Code[2] <- seed
Code[3] <- " \\\\[12pt] \\end{fshaded}"
for(i in 1:n_frames)
Code[3+i] <- print(x[[i]],include.rownames=FALSE,include.colnames=FALSE,hline.after=0:nrow(x[[i]]), sanitize.text.function = identity)
Code[frames+4] <- " \\end{document}"

write(Code, file = paste0(path_out,"/","Survey.tex"), append = FALSE)
   }
  
  wd1<-getwd()   
wd2<-paste0(path_out,"/")
setwd(wd2)
tools::texi2dvi("Survey.tex", pdf = TRUE, clean = TRUE)
setwd(wd1)
   } 
   

