#' Build a map between GIDs and PIDs
#' 
#' This is a small helper function to create suveys JSON files that guide the app behavior.
#'
#' @param path Path to RICH folder.
#' @param game_name Used to label PDF surveys.
#' @param set_size Size of set of possible alters.
#' @param token_color "color" of tokens placed. If data was entered manually, place whatever value was stored 
#'  to indiciate a tie: e.g., "1"
#' @param pattern Should "JPG" be "jpg" be used to load photos?
#' @param height Size of PDF output.
#' @param width Size of PDF output.
#' @param seed Number to use in seeding randomizer. Not applicable with choice data.
#' @param gid_size Number of characters in hashcodes for the game IDs.
#' @return A file folder, SubsetSurveys, filled with PDFs of sub-surveys to run, and a second folder, SubsetContributions, 
#'  filled with CSV files that will be used to record survey results.
#' @export
#'
compile_gid_maps = function(path){
       ## Now list games by PID
       all_ds = list.files(paste0(path, "/SubsetContributions/"), pattern=".csv", full=TRUE)
       res_list = list()
       Full_N = 8 

       for( i in 1:length(all_ds)){
        res1 = read.csv(all_ds[i]) 
        res1b = res1[which(res1[,1] %in% paste0("AID", c(1:(Full_N+1)))),]
        res1b$Variable = rep(res1[which(res1[,1]=="GID"),2], Full_N+1)
        res_list[[i]] = res1b
       }

       res_all = do.call(rbind,res_list)
       res_all = res_all[which(res_all$Data != "BLANK"),]

       ## Write json files
       all_ids = tools::file_path_sans_ext(list.files(paste0(path, "/StandardizedPhotos/")))
       
       for(i in 1:length(all_ids)){
         ####### And parse to JSON 
         gids_2_write = res_all$Variable[which(res_all$Data==all_ids[i])]
         LB = length(gids_2_write)
         billy = c(paste0("'","Ngames","':'", LB,"',"))
         for(j in 1:(LB-1)){
         billy = paste0(billy, paste0("'",paste0("GIDx",j),"':'", gids_2_write[j],"',"))
         }
         billy = paste0(billy, paste0("'",paste0("GIDx",LB),"':'", gids_2_write[LB],"'"))
         billy = paste0("{",billy,"}")

         write(billy, paste0(path, "/SubsetContributions/GIDsByPID/", all_ids[i],".json"))
       }
     }

     
