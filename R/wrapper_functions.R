
enter_L = function(ID_CODE="RG0", HHID="BQL", RID="CR", day=12, month=4, year=2020, name = "Cody", revise=FALSE,
                      thresh=c(0.085), 
                      lower_hue_threshold = c(175), 
                      upper_hue_threshold = c(215), 
                      plot_colors=c("empty", "navyblue"), 
                      lower_saturation_threshold=0.16, 
                      lower_luminance_threshold=0.15, 
                      upper_luminance_threshold=0.85,  
                      border_size=0.22,
                      iso_blur=3,
                      direction="forward"
    ){

if(revise == FALSE){

################################### And now a batch process script for Likert data
filled2 = vector("list", 2)
filled2[[1]] = pre_process(path=path, ID=ID_CODE, game="Blank", panels=c("A","B","C","D"))

game_names_list <<- c("L")

for(i in 1:1){
 print(game_names_list[i])
 filled2[[i+1]] = pre_process(path=path, ID=ID_CODE, game=game_names_list[i], panels=c("A","B","C","D"))
}

game_images_all5 <<- vector("list", 2)
game_locs_all5 <<- vector("list", 2)
game_ID_all5 <<- vector("list", 2)

game_images_all5[[1]] <<- filled2[[1]][[1]]
game_locs_all5[[1]] <<- filled2[[1]][[2]]
game_ID_all5[[1]] <<- "Blank"

for(i in 2:2){
game_images_all5[[i]] <<- filled2[[i]][[1]]
game_locs_all5[[i]] <<- filled2[[i]][[2]]
game_ID_all5[[i]] <<- game_names_list[i-1]
}

}

Game_all5 <<- auto_enter_all(path=path, pattern=".jpg", start=1, stop=3, seed=1, n_panels=4, n_rows=5, n_cols=9, 
                           thresh=thresh, 
                           lower_hue_threshold = lower_hue_threshold, 
                           upper_hue_threshold = upper_hue_threshold, 
                           plot_colors=plot_colors, 
                           img=game_images_all5, locs=game_locs_all5, ID=ID_CODE,
                           game=game_ID_all5, ordered=NULL,
                           lower_saturation_threshold=lower_saturation_threshold, 
                           lower_luminance_threshold=lower_luminance_threshold, 
                           upper_luminance_threshold=upper_luminance_threshold,  
                           border_size=border_size,
                           iso_blur=iso_blur,
                           histogram_balancing=FALSE,
                           direction=direction)

for(i in 1:1)
check_classification(path=path, Game_all5[[i]], n_panels = 4, n_rows=5, n_cols=9, ID=ID_CODE, game=game_names_list[i])

 annotate_data(path = path, results=Game_all5, HHID=HHID, RID=RID, day=day, month=month, year=year, 
            name = name, ID=ID_CODE, game="L", order="ABCD", seed = 1)

}


enter_rich = function(ID_CODE="RG0", HHID="BQL", RID="CR", day=12, month=4, year=2020, name = "Cody", revise=FALSE,
                      thresh=c(0.075, 0.075, 0.075), 
                      lower_hue_threshold = c(135, 265, 175), 
                      upper_hue_threshold = c(175, 310, 215), 
                      plot_colors=c("empty","seagreen4", "purple", "navyblue"), 
                      lower_saturation_threshold=0.1, 
                      lower_luminance_threshold=0.12, 
                      upper_luminance_threshold=0.88,  
                      border_size=0.22,
                      iso_blur=0,
                      direction="forward"
    ){

if(revise == FALSE){

################################### And now a batch process script for Likert data
filled2 = vector("list", 10)
filled2[[1]] = pre_process(path=path, ID=ID_CODE, game="Blank", panels=c("A","B","C","D"))

game_names_list <<- c("A", "B", "C", "D", "E", "F", "H", "J", "K")

for(i in 1:9){
 print(game_names_list[i])
 filled2[[i+1]] = pre_process(path=path, ID=ID_CODE, game=game_names_list[i], panels=c("A","B","C","D"))
}

game_images_all5 <<- vector("list", 10)
game_locs_all5 <<- vector("list", 10)
game_ID_all5 <<- vector("list", 10)

game_images_all5[[1]] <<- filled2[[1]][[1]]
game_locs_all5[[1]] <<- filled2[[1]][[2]]
game_ID_all5[[1]] <<- "Blank"

for(i in 2:10){
game_images_all5[[i]] <<- filled2[[i]][[1]]
game_locs_all5[[i]] <<- filled2[[i]][[2]]
game_ID_all5[[i]] <<- game_names_list[i-1]
}

}

Game_all5 <<- auto_enter_all(path=path, pattern=".jpg", start=1, stop=3, seed=1, n_panels=4, n_rows=5, n_cols=9, 
                           thresh=thresh, 
                           lower_hue_threshold = lower_hue_threshold, 
                           upper_hue_threshold = upper_hue_threshold, 
                           plot_colors=plot_colors, 
                           img=game_images_all5, locs=game_locs_all5, ID=ID_CODE,
                           game=game_ID_all5, ordered=NULL,
                           lower_saturation_threshold=lower_saturation_threshold, 
                           lower_luminance_threshold=lower_luminance_threshold, 
                           upper_luminance_threshold=upper_luminance_threshold,  
                           border_size=border_size,
                           iso_blur=iso_blur,
                           histogram_balancing=FALSE,
                           direction=direction)

for(i in 1:9)
check_classification(path=path, Game_all5[[i]], n_panels = 4, n_rows=5, n_cols=9, ID=ID_CODE, game=game_names_list[i])

annotate_batch_data(path = path, results=Game_all5, HHID=HHID, RID=RID, day=day, month=month, year=year, 
            name = name, ID=ID_CODE, game="PeerRatings", order="ABCD", seed = 1)

}


grabPointAuto = function(img, ref_set, d_x = 20, d_y = 20){

    Q_H = as.vector(table(c(floor(ref_set[,,1]+1), c(1:360)))) - 1
    Q_S = as.vector(table(c(floor(ref_set[,,2]*360*0.999 + 1), c(1:360)))) - 1
    Q_L = as.vector(table(c(floor(ref_set[,,3]*360*0.999 + 1), c(1:360)))) - 1

    n_x = floor(dim(img)[1]/d_x)
    n_y = floor(dim(img)[2]/d_y)

    hues = RGBtoHSL(img)

    divergence_H = matrix(NA, nrow=n_x, ncol=n_y)
    divergence_S = matrix(NA, nrow=n_x, ncol=n_y)
    divergence_L = matrix(NA, nrow=n_x, ncol=n_y)

    for(x in 0:(n_x-1)){
    for(y in 0:(n_y-1)){

     # Hue divergence   
     hue_signature = c(hues[(1:d_x)+x*d_x, (1:d_y)+y*d_y, 1, 1])
     P_H = as.vector(table(c(floor(hue_signature+1), c(1:360)))) - 1
     X = rbind(P_H/sum(P_H), Q_H/sum(Q_H))

     divergence_H[x+1,y+1] = -log(KL(X[2:1,]))

     # # Saturation divergence   
     # saturation_signature = c(hues[(1:d_x)+x*d_x, (1:d_y)+y*d_y, 1, 2])*360*0.999
     # P_S = as.vector(table(c(floor(saturation_signature+1), c(1:360)))) - 1
     # X = rbind(P_S/sum(P_S), Q_S/sum(Q_S))

     # divergence_S[x+1,y+1] = -log(KL(X[2:1,]))

     # # Lumenosity divergence   
     # lumenosity_signature = c(hues[(1:d_x)+x*d_x, (1:d_y)+y*d_y, 1, 3])*360*0.999
     # P_L = as.vector(table(c(floor(lumenosity_signature+1), c(1:360)))) - 1
     # X = rbind(P_L/sum(P_L), Q_L/sum(Q_L))

     # divergence_L[x+1,y+1] = -log(KL(X[2:1,]))

    }
    }

    D = (divergence_H+divergence_S+divergence_L)

    D = (divergence_H)

    #par(mfrow=c(1,2))
    #image(D[,ncol(D):1])

    D1 = D[1:floor(dim(D)[1]/2), 1:floor(dim(D)[2]/2)]
    D2 = D[(floor(dim(D)[1]/2)+1):dim(D)[1], 1:floor(dim(D)[2]/2)]
    D3 = D[(floor(dim(D)[1]/2)+1):dim(D)[1], (floor(dim(D)[2]/2)+1):dim(D)[2] ]
    D4 = D[1:floor(dim(D)[1]/2), (floor(dim(D)[2]/2)+1):dim(D)[2] ]

    loc1 = which(D1==max(D1), arr.ind=TRUE) + c(0,0)
    loc2 = which(D2==max(D2), arr.ind=TRUE) + c(dim(D1)[1], 0)
    loc3 = which(D3==max(D3), arr.ind=TRUE) + c(dim(D1)[1], dim(D4)[2])
    loc4 = which(D4==max(D4), arr.ind=TRUE) + c(0,dim(D4)[2])

    loc1 = loc1 * c(d_x, d_y) + c(-d_x, -d_y)
    loc2 = loc2 * c(d_x, d_y) + c(d_x/2, -d_y/2)
    loc3 = loc3 * c(d_x, d_y) + c(d_x/2, d_y/2)
    loc4 = loc4 * c(d_x, d_y) + c(-d_x, d_y)

    loc = rbind(loc1, loc2, loc3, loc4)
   return(loc)
}




grab_points_automatic = function (path_imgs, path_refset, d_x = 10, d_y = 10) 
  {

    ###################################### Get reference set hue spectra
    refset_img = load.image(path_refset)

    refset_img_small = resize(refset_img, d_x, d_y, interpolation_type = 3, centering_x = 0, centering_y = 0)

    refset = RGBtoHSL(refset_img_small)


 ###################################### Find locations of reference labels
    imgs = vector("list", length(path_imgs))
    locs = vector("list", length(path_imgs))
    for (i in 1:length(imgs)) {
        imgs[[i]] = load.image(path_imgs[i])
     
        if(dim(imgs[[i]])[1] > dim(imgs[[i]])[2]) {
                imgs[[i]] = imrotate(imgs[[i]], 90)
            }

            locs[[i]] = grabPointAuto(imgs[[i]],refset, d_x = d_x, d_y = d_y)


       print(paste("image", i, "processed"))

    windows()
    plot(imgs[[i]])
    points(locs[[i]][1,1],locs[[i]][1,2], pch=20, cex=2.5, col="red")
    segments(locs[[i]][1,1], locs[[i]][1,2], locs[[i]][2,1], locs[[i]][2,2], lwd=2, col="red")

    points(locs[[i]][2,1],locs[[i]][2,2], pch=20, cex=2.5, col="purple")
    segments(locs[[i]][2,1], locs[[i]][2,2], locs[[i]][3,1], locs[[i]][3,2], lwd=2, col="purple")

    points(locs[[i]][3,1],locs[[i]][3,2], pch=20, cex=2.5, col="blue")
    segments(locs[[i]][3,1], locs[[i]][3,2], locs[[i]][4,1], locs[[i]][4,2], lwd=2, col="blue")

    points(locs[[i]][4,1],locs[[i]][4,2], pch=20, cex=2.5, col="green")
    segments(locs[[i]][4,1], locs[[i]][4,2], locs[[i]][1,1], locs[[i]][1,2], lwd=2, col="green")


    }
    return(locs)
  }


 pre_process2 = function (path, ID, game = "Blank", panels = c("A", "B"), pre_processed = FALSE, automate = FALSE, reference = NULL, d_x = 20, d_y = 20) 
{
    blank_photos_to_read = paste0(game, "_", ID, "_", panels, ".jpg")
    blank_path = paste0(path, "/ResultsPhotosSmall/", blank_photos_to_read)
    blank_images = grab_images(blank_path)
    
    if(automate == FALSE){
     blank_locs = grab_points(blank_path, pre_processed = pre_processed)
    }
    if(automate == TRUE){
     blank_locs = grab_points_automatic(path_imgs = blank_path, path_refset = reference, d_x = d_x, d_y = d_y)    
    }

    return(list(blank_images, blank_locs))
}
