#' grab_points_automatic
#'
#' This is a helper function.
#' @param 
#' path_imgs the path to the images to be scaned for corners.
#' @param 
#' path_refset the path to the reference chips.
#' @param 
#' d_x x width of kernel used to scan for corners.
#' @param 
#' d_y y width of kernel used to scan for corners.
#' @param 
#' plot_corners should predicted corners be plotted in situ?
#' @return A list of lists of length 4. Each slot contains the locations of game-board corners.
#' @export


 grab_points_automatic = function (path_imgs, path_refset, d_x = 10, d_y = 10, plot_corners=TRUE) 
  {

    ###################################### Get reference set hue spectra
    path_refset = list.files(path_refset, full=TRUE)

    refset_long = refset_img = vector("list", length(path_refset))

    for(i in 1: length(path_refset)){
     refset_img[[i]] = load.image(path_refset[[i]])
     refset_img_small = resize(refset_img[[i]], d_x, d_y, interpolation_type = 3, centering_x = 0, centering_y = 0)
     refsetHSL = RGBtoHSL(refset_img_small)
     refset_long[[i]] =  as.vector(table(c(floor(refsetHSL[,,1]+1), c(1:360)))) - 1
     }

    refset =  rep(0,360)

    for(i in 1:length(path_refset)){
      refset = refset + refset_long[[i]]  
    }

 ###################################### Find locations of reference labels
    imgs = vector("list", length(path_imgs))
    locs = vector("list", length(path_imgs))
    for (i in 1:length(imgs)) {
        imgs[[i]] = load.image(path_imgs[i])
     
        if(dim(imgs[[i]])[1] > dim(imgs[[i]])[2]) {
                imgs[[i]] = imrotate(imgs[[i]], 90)
            }

            locs[[i]] = grabPointAuto(img = imgs[[i]], ref_set = refset, d_x = d_x, d_y = d_y)


       print(paste("image", i, "processed"))


 if(plot_corners==TRUE){
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

    }
    return(locs)
  }

  