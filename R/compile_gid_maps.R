#' Build a map between GIDs and PIDs
#' 
#' This is a small helper function to create suveys JSON files that guide the app behavior.
#'
#' @param path Path to RICH folder.
#' @param mode For games like the PGG or SnowDrift, where the focal persons can either give or not, set to "onlyfocal". For games were the focal
#' can give to anyone on the roster, set to "fullset".
#' @export
#'
compile_gid_maps = function(path, mode="onlyfocal"){
   ################################### PGG style
  if(mode=="onlyfocal"){
       ## Now list games by PID
       all_ds = list.files(paste0(path, "/SubsetContributions/"), pattern=".csv", full.names=TRUE)
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

   ################################### RICH style
        if(mode=="fullset"){
       ## Now list games by PID
       all_ds = list.files(paste0(path, "/SubsetContributions/"), pattern=".csv", full.names=TRUE)
       res_list = list()
       Full_N = 8 

       for( i in 1:length(all_ds)){
        res1 = read.csv(all_ds[i]) 
        res1b = res1[which(res1[,1] %in% paste0("AID", c(1:(Full_N+1)))),]
        res1b$Variable = rep(res1[which(res1[,1]=="GID"),2], Full_N+1)
        res1b$Focal = rep(res1[which(res1[,1]=="ID"),2], Full_N+1)
        res_list[[i]] = res1b
       }

       res_all = do.call(rbind,res_list)
       res_all = res_all[which(res_all$Data != "BLANK"),]

       res_all = res_all[which(res_all$Focal == res_all$Data),]

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

     }

     
