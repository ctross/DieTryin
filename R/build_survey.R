#' A function to build LaTeX survey tool for RICH economic games or related social network data collection
#'
#' This function allows you to speed up data collection and photo randomization. Simply set a path to the main folder.  
#' Set the number of panels, and the number of rows and cols per panel. Then run the function. This function relies on 'xtable' to create a survey tool, and compile to PDF using LaTeX.
#' The user must have a LaTeX build on the system path.
#' @param 
#' path Full path to main folder.
#' @param 
#' pattern File extension of photos. Should be ".jpg" or ".JPG". 
#' @param 
#' start Location of start of PID in file name. If files are saved as "XXX.jpg" for example, this is 1.
#' @param 
#' stop Location of end of PID in file name. If files are saved as "XXX.jpg" for example, this is 3.
#' @param 
#' seed A seed for the random number generator to sort the order of photos in the array. 
#' @param 
#' n_panels Number of frames/panels/blocks of photos to be output. I use four big panels and randomize order at each game.
#' @param 
#' n_rows Number of rows per panel. With 7cm x 10cm photos, I use five rows of photos per panel.
#' @param 
#' n_cols Number of cols per panel. With 7cm x 10cm photos, I use six to eight cols of photos per panel.
#' @param 
#' ordered A list of IDs in explicit order. Can be used to overide random sorting.
#' @export
#' @examples
#' \dontrun{
#' build_survey(path=path, pattern=".jpg", start=1, stop=3, n_panels=2, n_rows=4, n_cols=5, seed=1, ordered = sorted_ids)
#'                    }
  
build_survey = function(path, pattern=".jpg", start=1, stop=3, n_panels=4, n_rows=5, n_cols=8, seed=1, ordered = NULL ){
 require(xtable)
 require(readr)  
 require(tools) 
  
 path_out = paste0(path,"/Survey")
  
  if(is.null(ordered)){
    message("Because ordered=NULL, ID codes are loaded from the file names in the StandardizedPhotos directory.")
   IDS = substr(list.files(paste0(path,"/","StandardizedPhotos"), pattern, full.names=FALSE), start = start, stop = stop) # Load IDs from photos
   L = length(IDS)
   set.seed(seed)
   SortedIDS = c(IDS[order(runif(length(IDS),0,1))])
    }else{
    SortedIDS = ordered
    L = length(SortedIDS)
    seed = "NA"
  }

 if( L> n_panels*n_rows*n_cols){
  stop("ID vector exceeds the product of n_panels*n_rows*n_cols")
 } else{      
   
SortedIDS = c(SortedIDS,rep("~~~~",(n_panels*n_rows*n_cols - L)) )

 X = matrix(paste0("\\LARGE \\color{gray}",SortedIDS), nrow=n_rows,ncol=n_panels*n_cols,byrow=FALSE)
 x = vector("list",n_panels)
 
 for(i in 1:n_panels)
 x[[i]] = xtable_custom(X[,c(1:n_cols)+n_cols*(i-1)])
 
Code = c()
Code[1] = read_file(paste0(path,"/Survey/","header.txt"))
Code[2] = seed
Code[3] = " \\\\[12pt] \\end{fshaded}"
     
for(i in 1:n_panels)
Code[3+i] = print(x[[i]],include.rownames=FALSE,include.colnames=FALSE,hline.after=0:nrow(x[[i]]), sanitize.text.function = identity)
Code[n_panels+4] = " \\end{document}"

write(Code, file = paste0(path_out,"/","Survey.tex"), append = FALSE)
   }
  
wd1 = getwd()   
wd2 = paste0(path_out,"/")
setwd(wd2)
tools::texi2dvi("Survey.tex", pdf = TRUE, clean = TRUE)
setwd(wd1)
   } 
   

