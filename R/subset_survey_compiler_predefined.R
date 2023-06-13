#' Build RICH subset surveys (e.g., for partner choice or PG games.)
#' 
#' This is a small helper function to create suveys (PDFs) to collect data for PGG contributions and similar games.
#'
#' @param path Path to RICH folder.
#' @param pid ID code of focal recipient.
#' @param id_set IDs of alter recipients (as vector).
#' @param game_name Used to label PDF surveys.
#' @param pattern Should JPG be jpg be used to load photos?
#' @param height Size of PDF output.
#' @param width Size of PDF output.
#' @param seed Number to use in RNG.
#' @param gid_size Number of terms in hashcodes for the game IDs.
#' @return A file folder, SubsetSurveys, filled with PDFs of sub-surveys to run, and a second folder, SubsetContributions, 
#'  filled with CSV files that will be used to record survey results.
#' @export
#'
subset_survey_compiler_predefined = function(path, pid=NULL, id_set=NULL, pattern = ".jpg",  
                                         height=8.5, width=11, seed=123, 
                                         gid_size=4, game_name="Predefined"){
    # Set random number generator seed to make repeatable game IDS
      if(!is.na(seed)){
       set.seed(seed)
       }

    # Get a relevant ID list 
      PID = pid
      AIDs = id_set
      set_size = length(AIDs)

      PID2 = paste0(PID, pattern)
      AIDs2 = paste0(AIDs, pattern) 

      IDs = c(PID, AIDs)
      IDs2 = c(PID2, AIDs2)

    # Make photo set 
      path_imgs_small = paste0(path, "/StandardizedPhotos/")
        
      to_read = list.files(path_imgs_small, full.names=TRUE)
      to_read_short = list.files(path_imgs_small)
        
      photoset = list()

      for(j in 1:(set_size+1)){
       photoset[[j]] = imager::load.image(to_read[which(to_read_short==IDs2[j])])
        }

       GID  = toupper(random_string(1, gid_size))

      ###### Build PDF
       pdf(paste0(path, "/SubsetSurveys/", game_name, "_", PID,".pdf"), height=height, width=width)
       par(mfrow=c(2,(set_size+1)),mar=c(0.5, 0.5, 0.2, 0.2), oma = c(2.7, 0.2, 2.7, 0.2))

       for(j in 1:(set_size+1)){
           plot(photoset[[j]], axes=FALSE)
         }

       for(j in 1:(set_size+1)){
           plot(1,1, ylab="", yaxt="n", xlab="", xaxt="n", type="n", ylim=c(0,1))
           text(1,0.75, IDs[j],cex=2.5)
           text(1,0.25, "Offer:",cex=1.75)
         }

        mtext(paste0("HHID:______ RID:_______ Day:_______ Month:_______ Year:_______ Name:_________________ Game: ", game_name," GID: ", GID),                
           side = 1,
           line = 1,
           cex=1,
           outer = TRUE)

        mtext(paste0("Game: ", game_name, "     GID: ", GID),                
           side = 3,
           line = 1,
           cex=1,
           outer = TRUE)

         dev.off()


       ######## Build csv
        Full_N = 8 
        header = cbind(c("HHID", "RID", "Day", "Month", "Year", "Name", "ID", "Game", "Order", "Seed", "GID"), c(rep(NA, 6), PID, game_name, NA, seed, GID))
        header2 = cbind(c(paste0("Offer", c(1:(Full_N+1))),paste0("AID", c(1:(Full_N+1)))), c(rep(NA, Full_N +1),IDs,rep(NA,Full_N-set_size)))

        output = rbind(header,header2) 
        colnames(output) = c("Variable","Data")

        write.csv(output, paste0(path, "/SubsetContributions/", GID,".csv"),row.names = FALSE)

       ####### And parse to JSON 
        LB = length(output[,1])
        billy = c()
        for(i in 1:(LB-1)){
         billy = paste0(billy, paste0("'",output[i,1],"':'", output[i,2],"',"))
         }
        billy = paste0(billy, paste0("'",output[LB,1],"':'", output[LB,2],"'"))
        billy = paste0("{",billy,"}")

        write(billy, paste0(path, "/SubsetContributions/", GID,".json"))

}