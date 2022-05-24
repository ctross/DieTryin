#' grabPointAuto
#'
#' This is a helper function to automatically find corners using KL divergence
#' @param 
#' img  The image to be scaned for corners.
#' @param 
#' ref_set the reference hue distribution.
#' @param 
#' d_x x width of kernel used to scan for corners
#' @param 
#' d_y y width of kernel used to scan for corners
#' @return A list of length 4. Each slot contains the locations of game-board corners.
#' @export

 grabPointAuto = function(img, ref_set, d_x = 20, d_y = 20){

    Q_H = ref_set
    # Q_S = as.vector(table(c(floor(ref_set[,,2]*360*0.999 + 1), c(1:360)))) - 1
    # Q_L = as.vector(table(c(floor(ref_set[,,3]*360*0.999 + 1), c(1:360)))) - 1

    n_x = floor(dim(img)[1]/d_x)
    n_y = floor(dim(img)[2]/d_y)

    hues = RGBtoHSL(img)

    divergence_H = matrix(NA, nrow=n_x, ncol=n_y)
    #divergence_S = matrix(NA, nrow=n_x, ncol=n_y)
    #divergence_L = matrix(NA, nrow=n_x, ncol=n_y)

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

    #D = (divergence_H+divergence_S+divergence_L)

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

    loc1 = loc1 * c(d_x, d_y) + c(-d_x/2, -d_y/2)
    loc2 = loc2 * c(d_x, d_y) + c(d_x/2, -d_y/2)
    loc3 = loc3 * c(d_x, d_y) + c(d_x/2, d_y/2)
    loc4 = loc4 * c(d_x, d_y) + c(-d_x/2, d_y/2)

    loc = rbind(loc1, loc2, loc3, loc4)
   return(loc)
}

