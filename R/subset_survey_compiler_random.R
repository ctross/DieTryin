#' Build RICH subset surveys (e.g., for partner choice or PG games.)
#' 
#' This is a small helper function to create suveys (PDFs) to collect data for PGG contributions and similar games.
#'
#' @param path Path to RICH folder.
#' @param game_name Used to label PDF surveys.
#' @param set_size Size of set of possible alters.
#' @param token_color "color" of tokens placed. If data was entered manually, place whatever value was stored 
#'  to indiciate a tie: e.g., "1"
#' @param pattern Should "JPG" be "jpg" be used to load photos?
#' @param height Size of PDF output.
#' @param width Size of PDF output.
#' @param seed Number to use in seeding the randomizer.
#' @param full_alter_set Include all alters on roster, or only those who played first round of game?
#' @param gid_size Number of characters in hashcodes for the game IDs.
#' @param max_iter Max time to search for legal permutations.
#' @return A file folder, SubsetSurveys, full of PDFs of subset-surveys to run, and a second folder,
#'  SubsetContributions, full of CSV files to store results.
#' @export
#' @examples
#' \dontrun{
#' subset_survey_compiler_random(path, pattern = ".jpg", token_color="navyblue", set_size=4, 
#'                                  height=8.5, width=11, seed=123, gid_size=4, max_iter=10000)
#' }
#'

subset_survey_compiler_random = function(path, pattern = ".jpg", token_color="navyblue", 
                                         set_size=4, height=8.5, width=11, seed=123, full_alter_set = TRUE, 
                                         max_iter=10000, gid_size=4, game_name="Random"){
    # Set random number generator seed to make repeatable game IDS
      if(!is.na(seed)){
       set.seed(seed)
       }

    # Load all partner choice data from RICH folder
      files = list.files(paste0(path, "/SubsetData"), full.names = TRUE)
      files_short = list.files(paste0(path, "/SubsetData"))

    # Get a relevant ID list that balances legal IDs
      legal_set = matrix(NA, nrow=length(files_short), ncol=(set_size+1))

      legal_IDS = c()

      for(i in 1:length(files)){
       bob = read.csv(files[i])
       legal_IDS[i] = bob[6,2]
           }
           
       N_legal = length(legal_IDS)
       
       if(full_alter_set==TRUE){
        legal_IDS = unique(na.omit(bob$AlterID))  
       }
       
       legal_set[,1] = sample(legal_IDS, N_legal, replace=FALSE)

       for(i in 1:set_size){
        legal_set[, i+1] = sample(legal_IDS, N_legal, replace=FALSE)

        fail = 0
        ticker = 1

        while(fail==0){
         fail = ifelse(ticker>max_iter, 1, 0)
         fail_long = c()
          for(j in 0:(i-1)){
           fail_long[j+1] = ifelse(any(legal_set[,i+1]==legal_set[,i-j]),fail,1)
           }
         fail=ifelse(prod(fail_long)==0,0,1)
          if(fail==0){
           legal_set[, i+1] = sample(legal_IDS, N_legal, replace=FALSE)
           }
          ticker = ticker + 1
           }
         }

     # Loop over each CSV file, and build a PDF survey and a CSV for data entry 
     # Now load the photos into R
        path_imgs_small = paste0(path, "/StandardizedPhotos/")
        
        to_read = list.files(path_imgs_small, full.names=TRUE)
        to_read_short = list.files(path_imgs_small)

      # Make photo set 
      for(i in 1:length(files)){
       photoset = list()

       for(j in 1:(set_size+1)){
        photoset[[j]] = imager::load.image(to_read[which(to_read_short==paste0(legal_set[i,j],pattern))])
         } 

       GID  = toupper(random_string(1, gid_size))

      ###### Build PDF
        pdf(paste0(path, "/SubsetSurveys/", game_name, "_", legal_set[i,1],".pdf"), height=height, width=width)
        par(mfrow=c(2,(set_size+1)),mar=c(0.5, 0.5, 0.2, 0.2), oma = c(2.7, 0.2, 2.7, 0.2))

       for(j in 1:(set_size+1)){
        plot(photoset[[j]], axes=FALSE)
         }

       for(j in 1:(set_size+1)){
         plot(1,1, ylab="", yaxt="n", xlab="", xaxt="n", type="n", ylim=c(0,1))
         text(1,0.75, legal_set[i,j], cex=2.5)
         text(1,0.25, "Offer:",cex=1.75)
         }

       mtext(paste0("HHID:______ RID:_______ Day:_______ Month:_______ Year:_______ Name:_________________ Game: ", game_name, " GID: ", GID),                
         side = 1,
         line = 1,
         cex=1,
         outer = TRUE)

       mtext(paste0("Game: ", game_name, "    GID: ", GID),                
         side = 3,
         line = 1,
         cex=1,
         outer = TRUE)

       dev.off()


       ######## Build csv
         header = cbind(c("HHID", "RID", "Day", "Month", "Year", "Name", "ID", "Game", "Order", "Seed", "GID"), c(rep(NA, 6), legal_set[i,1], game_name , NA, seed, GID))
         header2 = cbind(c(paste0("Offer_", c(1:(set_size+1))),paste0("AID_", c(1:(set_size+1)))), c(rep(NA, set_size +1),legal_set[i,]))

         output = rbind(header,header2) 
         colnames(output) = c("Variable","Data")

         write.csv(output, paste0(path, "/SubsetContributions/", GID,".csv"),row.names = FALSE)

       }
}
