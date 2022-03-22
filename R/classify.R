#' A function to enter data from RICH economic games automatically
#'
#' This function allows you to speed up data entry. Simply set a path to the main folder. 

#' @param 
#' path Full path to main folder.
#' @param 
#' PID Unique ID of focal individual/respondent.
#' @param 
#' HHID Household ID of focal individual/respondent.
#' @param 
#' RID ID of researcher.
#' @param 
#' day Day of interview.
#' @param 
#' month Month of interview.
#' @param 
#' year Year of interview.
#' @param 
#' name Name of focal individual/respondent.
#' @param 
#' panels ID codes used to indicate panel.
#' @param 
#' questions ID codes used to indicate questions.
#' @param 
#' game ID for the folder in which these data will be saved.
#' @param 
#' order Order of frames/panels of photos as presented to the respodent: e.g., with 4 frames, "ABCD", "CDBA", etc. are legal entries.
#' @param 
#' revise When set to TRUE, the classification function is run, without requiring the corners to be redetected.
#' @param 
#' pattern File extension of photos. Should be ".jpg" or ".JPG". 
#' @param 
#' start Location of start of PID in file name. If files are saved as "XXX.jpg" for example, this is 1.
#' @param 
#' stop Location of end of PID in file name. If files are saved as "XXX.jpg" for example, this is 3.
#' @param 
#' seed A seed for the random number generator to sort the order of photos in the array. This should match the seed used to make the survey.
#' @param 
#' n_panels Number of frames/panels/blocks of photos to be output. I use four big panels and randomize order at each game.
#' @param 
#' n_rows Number of rows per panel. With 7cm x 10cm photos, I use five rows of photos per panel.
#' @param 
#' n_cols Number of rows per panel. With 7cm x 10cm photos, I use six to eight cols of photos per panel.
#' @param 
#' ordered_ids A list of IDs if photograph order is to be explicilty coded. This overwrites random sorting.
#' @param 
#' thresh Difference in hue density between pre- and post-treatment game boards required to code a token color as present. Can be vectorized if mulple token colors are in use: e.g., c(0.05, 0.35, 0.05).
#' @param 
#' lower_hue_threshold A vector of lower hue thresholds for each token color. To use three token colors, instead of the single token in the defaults, use: e.g., c(120, 210, 330).
#' @param 
#' upper_hue_threshold A vector of upper hue thresholds for each token color. To use three token colors, instead of the single token in the defaults, use: e.g., c(150, 250, 355).
#' @param 
#' plot_colors A vector of labels indicating which token color was used. The first entry must say "empty", other colors can be named as desired, but must be real color names in R. 
#' These colors correspond to the above-listed token hues, and this vector should be one cell longer than the hue threshold vectors. 
#' @param 
#' lower_saturation_threshold Lower limit of greyness before the hue of such pixels is excluded from density calculations.
#' @param 
#' lower_luminance_threshold Lower limit of darkness before the hue of such pixels is excluded from density calculations.
#' @param 
#' upper_luminance_threshold Upper limit of lightness before the hue of such pixels is excluded from density calculations.
#' @param 
#' border_size Image border excluded from density calculations as a fraction of image size.
#' @param 
#' iso_blur Width of Gaussian filter applied to image. A value of 0 turns off blurring.
#' @param 
#' direction How image skew is corrected. The "forward" algorithm is fast but lower quality. The "backward" algorithm is slow but higher quality. See imwarp function in imager package for technical details.
#' @param 
#' alert_mode Audio alert when data entry finishes. Set to "50_Cent" for random lyrics off the hit song "In da Club" (warning, explicit content"), or "Beep" for a borning notification.
#' @param 
#' automate will corners be selected manually, or automatically?
#' @param 
#' d_x x width of kernel used to scan for corners
#' @param 
#' d_y y width of kernel used to scan for corners
#' @export

classify = function(
                      path,
                      PID="CTR", 
                      HHID="FKA", 
                      RID="CR", 
                      day=12, 
                      month=4, 
                      year=2020, 
                      name = "Cody", 
                      panels=c("A", "B"),
                      questions=c("Friendship, Wealth"),
                      game="PeerRatings",
                      order="ABCD",
                      revise=FALSE,
                      pattern=".jpg", 
                      start=1, 
                      stop=3, 
                      seed=1, 
                      n_panels=4, 
                      n_rows=5, 
                      n_cols=9,
                      ordered_ids = NULL,
                      thresh=c(0.075, 0.075, 0.075), 
                      lower_hue_threshold = c(135, 265, 175), 
                      upper_hue_threshold = c(175, 310, 215), 
                      plot_colors=c("empty","seagreen4", "purple", "navyblue"), 
                      lower_saturation_threshold=0.1, 
                      lower_luminance_threshold=0.12, 
                      upper_luminance_threshold=0.88,  
                      border_size=0.22,
                      iso_blur=0,
                      direction="forward",
                      alert_mode="off",
                      automate = TRUE,
                      d_x = 20, 
                      d_y = 20
    ){

if(revise == FALSE){
################################### And now a batch process script for Likert data
N_all = length(questions) + 1

filled2 = vector("list", N_all)
filled2[[1]] = pre_process(path=path, ID=PID, game="Blank", panels=panels, automate =  automate, reference = paste0(path,"/ReferenceChip"), d_x = d_x, d_y = d_y)

game_names_list <<- questions

for(i in 1:(N_all-1)){
 print(game_names_list[i])
 filled2[[i+1]] = pre_process(path=path, ID=PID, game=game_names_list[i], panels=panels, automate =  automate, reference = paste0(path,"/ReferenceChip"), d_x = d_x, d_y = d_y)
}

game_images_all5 <<- vector("list", N_all)
game_locs_all5 <<- vector("list", N_all)
game_ID_all5 <<- vector("list", N_all)

game_images_all5[[1]] <<- filled2[[1]][[1]]
game_locs_all5[[1]] <<- filled2[[1]][[2]]
game_ID_all5[[1]] <<- "Blank"

for(i in 2:N_all){
game_images_all5[[i]] <<- filled2[[i]][[1]]
game_locs_all5[[i]] <<- filled2[[i]][[2]]
game_ID_all5[[i]] <<- game_names_list[i-1]
}

}

Game_all5 <<- auto_enter_all(path=path, pattern=".jpg", start=start, stop=stop, seed=seed, n_panels=n_panels, n_rows=n_rows, n_cols=n_cols, 
                             thresh=thresh, 
                             lower_hue_threshold = lower_hue_threshold, 
                             upper_hue_threshold = upper_hue_threshold, 
                             plot_colors=plot_colors, 
                             img=game_images_all5, locs=game_locs_all5, ID=PID,
                             game=game_ID_all5, ordered=ordered_ids,
                             lower_saturation_threshold=lower_saturation_threshold, 
                             lower_luminance_threshold=lower_luminance_threshold, 
                             upper_luminance_threshold=upper_luminance_threshold,  
                             border_size=border_size,
                             iso_blur=iso_blur,
                             histogram_balancing=FALSE,
                             direction=direction)

for(i in 1: (N_all-1))
check_classification(path=path, Game_all5[[i]], n_panels = n_panels, n_rows=n_rows, n_cols=n_cols, ID=PID, game=game_names_list[i])

annotate_batch_data(path = path, results=Game_all5, HHID=HHID, RID=RID, day=day, month=month, year=year, 
            name = name, ID=PID, game=game, order=order, seed = seed)


if(alert_mode == "50_Cent"){
message = rep(NA,6)
message[1] = "Im full of focus man. my money on my mind. I got a mill out the deal, and Im still on the grind."
message[2] = "You can find me in the club, bottle full of bub. Look, mami, I got the X, if you into taking drugs."
message[3] = "In the hood, in L.A., they saying fifty you hot. They like me. I want them to love me like they love Pac."
message[4] = "Go, shorty. Its your birthday. We gonna party like its your birthday. We gonna sip Bacardi like its your birthday."
message[5] = "Been hit wit a few shells, but I dont walk wit a limp."
message[6] = "When I pull out up front, you see the Benz on dubs. When I roll 20 deep, its 20 knives in the club."

 say_something(message=message[ceiling(runif(1, 0, 5.9999))], voice="Zira")
}

if(alert_mode == "Beep"){
 message = "Beep. Beep. Your data are entered."
 say_something(message=message, voice="Zira")
}

}

