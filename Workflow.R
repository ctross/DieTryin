################################### Install and/or load
 library(devtools)
 #You might need to turn off warning-error-conversion, because the tiniest warning stops installation
 Sys.setenv("R_REMOTES_NO_ERRORS_FROM_WARNINGS" = "true")
 install_github('ctross/DieTryin')
 library(DieTryin)

################################### Setup directory
# We set up storage for the RICH games data and data from several other social networks
 path = "C:\\Users\\cody_ross\\Desktop"
 games_to_add = c("FriendshipsData", "TrustData", "WisdomData", "WorkData", "EmotionData", "ReputationData")
 setup_folders(path, add=games_to_add)

################################### Standardize photos
# First paste the images in the RespodentsImages folder in this zip folder 
# into the RawImages folder in the RICH folder created just above, then run:
 standardize_photos(path=path, pattern=".jpg", start=1, stop=3, 
                 size_out=1000, border_size=10, asr=1.6180, 
                 id_range=NULL, id_names=NULL, spin=TRUE)

# Imagine you messed up somewhere and want to re-do a single image, then run:
 standardize_photos(path=path, pattern=".jpg", start=1, stop=3, 
                 size_out=1000, border_size=10, asr=1.6180, 
                 id_range=NULL, id_names="EW1", spin=TRUE)

################################### Now create the survey tool
# To create a random order, run:
 build_survey(path=path, pattern=".jpg", start=1, stop=3, 
            n_panels=2, n_rows=4, n_cols=5, seed=15, ordered = NULL)

# But, for now lets set a specific sorting order 
 sorted_ids = c("LF1", "CCM", "SW1", "KC1",
                "DB1", "RKM", "AT1", "CT1",
                "JK1", "AF1", "KW1", "MK1", 
                "AOC", "FN1", "LWA", "DJT",
                "LCK", "MM1", "RBG", "EM1",

                "AR1", "MR1", "BYC", "JLO",
                "BS1", "SR1", "DB2", "EW1",
                "TT1", "EDG", "JA1", "SS1",
                "SK1", "MB1", "AY1", "ASF",
                "JC1", "BO1", "FKA"
                )

 build_survey(path=path, pattern=".jpg", start=1, stop=3, 
            n_panels=2, n_rows=4, n_cols=5, seed=1, ordered = sorted_ids)


################################### Enter some data for the RICH games
# Repeat this line to enter RICH data for a few ID codes above (e.g., "JLO","AOC", and "FKA"), for each of the three games ("G", "L", and "R")
# You must input data for ID and Game in the header file. Other entries, like date, are optional.
 enter_data(path=path, pattern=".jpg", start=1, stop=3, n_panels=2, n_rows=4, n_cols=5, seed=1, ordered = sorted_ids, add=games_to_add)
# In the event of a data entry error just re-run the above function, and it will overwrite the erroneous, person- and game-specific data file.

################################### Compile the data and check it for accuracy
 compile_data(path=path, game="GivingData")
 compile_data(path=path, game="LeavingData")
 compile_data(path=path, game="ReducingData")
# Now check the results in the Results subfolder, and ensure that the summary tables look correct. If there are errors, then
# fix the csv files by hand, or re-run the enter_data() function for the specific inviduals with data entry errors. Then,
# run the above compile functions again. Repeat until all summary tables look correct.

################################### Calculate payoffs
 calculate_payouts(path=path, pattern=".jpg", start=1, stop=3, game="GLR", GV=1, LV=0.5, KV=1, RV=-3)

###############################################################################################
###############################################################################################
################################### Now, for the other data, we can move into automatic coding
 # First paste results photos from the CollectedDataImages folder from the zip file into the ResultsPhotos directory. Use properly formatted titles
 # of form: "GAMEID_PERSONID_PANELID.jpg" then downsize the images 
 downsize(path=path, scaler=3) # set scaler=1 to keep same size

# In order to set the right paramters for: lower_hue_threshold and upper_hue_threshold, it is helpful to check out the actual hue of your tokens.
# So pick a photo with all your token colors and run:
 get_hue(paste0(path,"/ResultsPhotosSmall/E_YEZ_A.jpg")) 
# make sure to click on several tokens and several places on each token to get a good idea of the range of values each token may take.
# get_hue(file.choose()) # will allow you to select a pictures without having to input the file path directly

################################ Now enter the data


classify(
  path=path,
  PID = "SS1",
  HHID = "SKA",
  RID = "CR",
  day = 12, month = 4, year = 2020,
  name = "Cody",
  panels = c("A", "B"),
  questions = c("A"),
  game = "PeerReports",
  order = "AB",
  revise = FALSE,
  pattern = ".jpg",
  start = 1, stop = 3,
  seed = 1,
  n_panels = 2,
  n_rows = 4, n_cols = 5,
  ordered_ids = sorted_ids,
  thresh = c(0.065, 0.065, 0.065),
  lower_hue_threshold = c(110, 285,175),
  upper_hue_threshold = c(155, 341,215),
  plot_colors = c("empty", "seagreen4", "purple", "navyblue"),
  lower_saturation_threshold = 0.1,
  lower_luminance_threshold = 0.12,
  upper_luminance_threshold = 0.88,
  border_size = 0.22, iso_blur = 0,
  direction = "forward",
  automate = TRUE,
  d_x = 20, d_y = 20
  )

############################################################################
#The code below is outdated. It was needed in the BRM paper, but the package now does all of these steps automatically via the classify function
################################### Pre-process the data needed for analysis
# These lines will open a window where corners must be clicked
 blank1 = pre_process(path=path, ID="CTR", game="Blank", panels=c("A","B"))            # control with no tokens
 friend1 = pre_process(path=path, ID="CTR", game="FriendshipsData", panels=c("A","B")) # game play with tokens

 game_images_all1 = list(blank1[[1]], friend1[[1]]) # Then organize into a list
 game_locs_all1 = list(blank1[[2]], friend1[[2]])
 game_ID_all1 = list("Blank", "FriendshipsData")

################################### Run the classifier
 Game_all1 = auto_enter_all(path=path, pattern=".jpg", start=1, stop=3, seed=1, n_panels=2, n_rows=4, n_cols=5, 
                             thresh=0.1, lower_hue_threshold = 135, upper_hue_threshold = 170,  
                             plot_colors=c("empty","seagreen4"), img=game_images_all1, locs=game_locs_all1, ID="CTR",
                             game=game_ID_all1, ordered=sorted_ids,
                             lower_saturation_threshold=0.12, 
                             lower_luminance_threshold=0.12, 
                             upper_luminance_threshold=0.88,  
                             border_size=0.22,
                             iso_blur=1,
                             histogram_balancing=FALSE,
                             direction="backward")

################################### Check the performance of the classifier
 check_classification(path=path, Game_all1[[1]], n_panels = 2, n_rows=4, n_cols=5, ID="CTR", game="FriendshipsData")

# and if it looks good, then save the results
 annotate_data(path = path, results=Game_all1, HHID="BPL", RID="CR", day=12, month=4, year=2020, 
             name = "Cory", ID="CTR", game="FriendshipsData", order="AB", seed = 1)

# Here we use the same data, and duplicate it with a new set of header data just to test the compile function below
 annotate_data(path = path, results=Game_all1, HHID="LQL", RID="CR", day=12, month=4, year=2020, 
             name = "Faith", ID="AOC", game="FriendshipsData", order="BA", seed = 1) 

 compile_data(path=path, game="FriendshipsData")

#########################################################################################
################################### Now pre-process the data needed for a Likert-analysis
# These lines will open a window where corners must be clicked
 blank2 = pre_process(path=path, ID="QQQ", game="Blank", panels=c("A","B"))
 trust2 = pre_process(path=path, ID="QQQ", game="TrustData", panels=c("A","B"))

 game_images_all2 = list(blank2[[1]], trust2[[1]])
 game_locs_all2 = list(blank2[[2]], trust2[[2]])
 game_ID_all2 = list("Blank", "TrustData")

################################### Run the classifier
Game_all2 = auto_enter_all(path=path, pattern=".jpg", start=1, stop=3, seed=1, n_panels=2, n_rows=4, n_cols=5, 
                            thresh=c(0.075, 0.075, 0.075), lower_hue_threshold = c(135, 280, 170), upper_hue_threshold = c(170, 350, 215),
                            plot_colors=c("empty","seagreen4", "purple", "navyblue"), img=game_images_all2, locs=game_locs_all2, ID="QQQ",
                            game=game_ID_all2, ordered=sorted_ids,
                            lower_saturation_threshold=0.09, 
                            lower_luminance_threshold=0.12, 
                            upper_luminance_threshold=0.88,   
                            border_size=0.22,
                            iso_blur=1,
                            histogram_balancing=FALSE,
                            direction="backward")

################################### Check the performance of the classifier
check_classification(path=path, Game_all2[[1]], n_panels = 2, n_rows=4, n_cols=5, ID="QQQ", game="TrustData")

# and if it looks good, then save the results
annotate_data(path = path, results=Game_all2, HHID="BPL", RID="CR", day=12, month=4, year=2020, 
            name = "Shakira", ID="QQQ", game="TrustData", order="BA", seed = 1)

# Just to test compiler we use the same data with a new set of annotations
annotate_data(path = path, results=Game_all2, HHID="BPL", RID="CR", day=14, month=4, year=2020, 
            name = "Lowkey", ID="LKW", game="TrustData", order="BA", seed = 1)

compile_data(path=path, game="TrustData")

#########################################################################################
################################### If images are preproccessed to be squared and cropped then, 
# user input and image correction can be skipped by using pre_processed=TRUE
 blank3 = pre_process(path=path, ID="YEZ", game="Blank", panels=c("A","B"), pre_processed=TRUE)
 trust3 = pre_process(path=path, ID="YEZ", game="WisdomData", panels=c("A","B"), pre_processed=TRUE)

 game_images_all3 = list(blank3[[1]], trust3[[1]])
 game_locs_all5 = list(blank3[[2]], trust3[[2]])
 game_ID_all3 = list("Blank", "WisdomData")

################################### Run the classifier
Game_all3 = auto_enter_all(path=path, pattern=".jpg", start=1, stop=3, seed=1, n_panels=2, n_rows=4, n_cols=5, 
                            thresh=c(0.075, 0.075, 0.075), lower_hue_threshold = c(135, 280, 170), upper_hue_threshold = c(170, 350, 215), 
                            plot_colors=c("empty","seagreen4", "purple", "navyblue"), img=game_images_all3, locs=game_locs_all3, ID="YEZ",
                            game=game_ID_all3, ordered=sorted_ids,
                            lower_saturation_threshold=0.09, 
                            lower_luminance_threshold=0.12, 
                            upper_luminance_threshold=0.88,  
                            border_size=0.22,
                            iso_blur=1,
                            pre_processed=TRUE)

################################### Check the performance of the classifier
check_classification(path=path, Game_all3[[1]], n_panels = 2, n_rows=4, n_cols=5, ID="YEZ", game="WisdomData")

# and if it looks good, then save the results
annotate_data(path = path, results=Game_all3, HHID="BPL", RID="CR", day=12, month=4, year=2020, 
            name = "Cody", ID="YEZ", game="WisdomData", order="BA", seed = 1)

# Just to test compiler we use the same data with a new set of annotations
annotate_data(path = path, results=Game_all3, HHID="BPL", RID="CR", day=14, month=4, year=2020, 
            name = "Dan", ID="DJR", game="WisdomData", order="BA", seed = 1)

compile_data(path=path, game="WisdomData")


#####################################################################################################
################################### This all works for a single game, now lets batch process binary data
################################ Binary data
filled = vector("list", 27)
filled[[1]] = pre_process(path=path, ID="CTR", game="Blank", panels=c("A","B"))
for(i in 1:26)
filled[[i+1]] = pre_process(path=path, ID="CTR", game=toupper(letters)[i], panels=c("A","B")) # use letters for "game" names

game_images_all4 = vector("list", 27)
game_locs_all4 = vector("list", 27)
game_ID_all4 = vector("list", 27)

game_images_all4[[1]] <- filled[[1]][[1]]
game_locs_all4[[1]] <- filled[[1]][[2]]
game_ID_all4[[1]] <- "Blank"

for(i in 2:27){
game_images_all4[[i]] <- filled[[i]][[1]]
game_locs_all4[[i]] <- filled[[i]][[2]]
game_ID_all4[[i]] <- toupper(letters)[i-1]
}

Game_all4 <- auto_enter_all(path=path, pattern=".jpg", start=1, stop=3, seed=1, n_panels=2, n_rows=4, n_cols=5, 
                            thresh=0.1, lower_hue_threshold = 135, upper_hue_threshold = 170,  
                            plot_colors=c("empty","seagreen4"), img=game_images_all4, locs=game_locs_all4, ID="CTR",
                            game=game_ID_all4, ordered=sorted_ids,
                            lower_saturation_threshold=0.12, 
                            lower_luminance_threshold=0.12, 
                            upper_luminance_threshold=0.88,  
                            border_size=0.22,
                            iso_blur=1,
                            histogram_balancing=FALSE,
                            direction="backward")

for(i in 1:26)
check_classification(path=path, Game_all4[[i]], n_panels = 2, n_rows=4, n_cols=5, ID="CTR", game=toupper(letters)[i])

annotate_batch_data(path = path, results=Game_all4, HHID="BQL", RID="CR", day=12, month=4, year=2020, 
            name = "BobBarker", ID="CTR", game="WorkData", order="AB", seed = 1)

annotate_batch_data(path = path, results=Game_all4, HHID="LQL", RID="CR", day=12, month=4, year=2020, 
            name = "Faith", ID="AOC", game="WorkData", order="BA", seed = 1)

compile_data(path=path, game="WorkData", batch=TRUE)

##################################################################################
################################### And now a batch process script for Likert data
filled2 = vector("list", 27)
filled2[[1]] = pre_process(path=path, ID="QQQ", game="Blank", panels=c("A","B"))
for(i in 1:26)
filled2[[i+1]] = pre_process(path=path, ID="QQQ", game=toupper(letters)[i], panels=c("A","B"))

game_images_all5 = vector("list", 27)
game_locs_all5= vector("list", 27)
game_ID_all5 = vector("list", 27)

game_images_all5[[1]] <- filled2[[1]][[1]]
game_locs_all5[[1]] <- filled2[[1]][[2]]
game_ID_all5[[1]] <- "Blank"

for(i in 2:27){
game_images_all5[[i]] <- filled2[[i]][[1]]
game_locs_all5[[i]] <- filled2[[i]][[2]]
game_ID_all5[[i]] <- toupper(letters)[i-1]
}

Game_all5 <- auto_enter_all(path=path, pattern=".jpg", start=1, stop=3, seed=1, n_panels=2, n_rows=4, n_cols=5, 
                           thresh=c(0.075, 0.075, 0.075), lower_hue_threshold = c(135, 280, 170), upper_hue_threshold = c(170, 350, 215), 
                           plot_colors=c("empty","seagreen4", "purple", "navyblue"), img=game_images_all5, locs=game_locs_all5, ID="QQQ",
                           game=game_ID_all5, ordered=sorted_ids,
                           lower_saturation_threshold=0.09, 
                           lower_luminance_threshold=0.12, 
                           upper_luminance_threshold=0.88,  
                           border_size=0.22,
                           iso_blur=1,
                           histogram_balancing=FALSE,
                           direction="backward")

for(i in 1:26)
check_classification(path=path, Game_all5[[i]], n_panels = 2, n_rows=4, n_cols=5, ID="QQQ", game=toupper(letters)[i])

annotate_batch_data(path = path, results=Game_all5, HHID="BQL", RID="CR", day=12, month=4, year=2020, 
            name = "Quark and Beans", ID="QQQ", game="EmotionData", order="AB", seed = 1)

annotate_batch_data(path = path, results=Game_all5, HHID="JKL", RID="CR", day=1, month=4, year=2020, 
            name = "Walter White", ID="XAS", game="EmotionData", order="AB", seed = 1)

compile_data(path=path, game="EmotionData", batch=TRUE)


####################################################### And Again in batch mode
################################### If images are preproccessed to be squared and cropped then, 
# user input and image correction can be skipped by using pre_processed=TRUE
filled3 = vector("list", 27)
filled3[[1]] = pre_process(path=path, ID="YEZ", game="Blank", panels=c("A","B"), pre_processed=TRUE)
for(i in 1:26)
filled3[[i+1]] = pre_process(path=path, ID="YEZ", game=toupper(letters)[i], panels=c("A","B"), pre_processed=TRUE)

game_images_all6 = vector("list", 27)
game_locs_all6 = vector("list", 27)
game_ID_all6 = vector("list", 27)

game_images_all6[[1]] <- filled3[[1]][[1]]
game_locs_all6[[1]] <- filled3[[1]][[2]]
game_ID_all6[[1]] <- "Blank"

for(i in 2:27){
game_images_all6[[i]] <- filled3[[i]][[1]]
game_locs_all6[[i]] <- filled3[[i]][[2]]
game_ID_all6[[i]] <- toupper(letters)[i-1]
}

Game_all6 <- auto_enter_all(path=path, pattern=".jpg", start=1, stop=3, seed=1, n_panels=2, n_rows=4, n_cols=5, 
                           thresh=c(0.075, 0.075, 0.075), lower_hue_threshold = c(135, 280, 170), upper_hue_threshold = c(170, 350, 215), 
                           plot_colors=c("empty","seagreen4", "purple", "navyblue"), img=game_images_all6, locs=game_locs_all6, ID="YEZ",
                           game=game_ID_all6, ordered=sorted_ids,
                           lower_saturation_threshold=0.09, 
                           lower_luminance_threshold=0.12, 
                           upper_luminance_threshold=0.88,  
                           border_size=0.22,
                           iso_blur=1,
                           pre_processed=TRUE)

for(i in 1:26)
check_classification(path=path, Game_all6[[i]], n_panels = 2, n_rows=4, n_cols=5, ID="YEZ", game=toupper(letters)[i])

annotate_batch_data(path = path, results=Game_all6, HHID="YEP", RID="CR", day=19, month=7, year=2020, 
            name = "Jim LaughAgain", ID="YEZ", game="ReputationData", order="AB", seed = 1)

annotate_batch_data(path = path, results=Game_all6, HHID="JKF", RID="CR", day=11, month=3, year=2020, 
            name = "Sunny Shade", ID="CVD", game="ReputationData", order="AB", seed = 1)

compile_data(path=path, game="ReputationData", batch=TRUE)




################################################################################## For Figure 9
par(mfrow = c(4, 5),     # 2x2 layout
    oma = c(1, 1, 1, 1), # two rows of text at the outer left and bottom margin
    mar = c(1, 1, 1, 1)) # space for one row of text at ticks and to separate plots

pruned_image=(Game_all5[[15]][[3]][[1]])
rows_image = imsplit(pruned_image,"y",4)
slice_image = imsplit(rows_image[[3]],"x",5)
slice = slice_image[2]
slice = slice[[1]]
plot(slice)

border_size  = 10
  px = Xc(slice) <= border_size                         
  slice[px] = 0                                           
  px = Xc(slice) >= dim(slice)[1]-border_size                  
  slice[px] = 0                                           
  px = Yc(slice) <= border_size*2                           
  slice[px] = 0                                           
  px = Yc(slice) >= dim(slice)[2]-border_size*2              
  slice[px] = 0  
  plot(slice)

iso_blur = 2
slice = isoblur(slice, iso_blur)
 plot(slice)

lower_saturation_threshold = 0.1
lower_luminance_threshold = 0.1
upper_luminance_threshold = 0.9
 X = RGBtoHSL(slice)
 S = ifelse(X[,,1,2]>lower_saturation_threshold,1,0)
 L = ifelse(X[,,1,3]>lower_luminance_threshold & X[,,1,3]<upper_luminance_threshold ,0.5,0)
 X[,,1,1] = X[,,1,1]
 X[,,1,2] = S
 X[,,1,3] = L
 plot(HSLtoRGB(X))

plot(density(X[,,1,1]), col="darkred",lwd=2,xlim=c(0,365),main="")
abline(v=230,col="navyblue",lwd=2)
abline(v=175,col="navyblue",lwd=2)

abline(v=350,col="purple",lwd=2)
abline(v=280,col="purple",lwd=2)

abline(v=165,col="seagreen4",lwd=2)
abline(v=110,col="seagreen4",lwd=2)

pruned_image=(Game_all5[[16]][[3]][[1]])
rows_image = imsplit(pruned_image,"y",4)
slice_image = imsplit(rows_image[[3]],"x",5)
slice = slice_image[2]
slice = slice[[1]]
plot(slice)

border_size  = 10
  px = Xc(slice) <= border_size                         
  slice[px] = 0                                           
  px = Xc(slice) >= dim(slice)[1]-border_size                  
  slice[px] = 0                                           
  px = Yc(slice) <= border_size*2                           
  slice[px] = 0                                           
  px = Yc(slice) >= dim(slice)[2]-border_size*2              
  slice[px] = 0  
  plot(slice)

iso_blur = 2
slice = isoblur(slice, iso_blur)
 plot(slice)

lower_saturation_threshold = 0.1
lower_luminance_threshold = 0.1
upper_luminance_threshold = 0.9
 X = RGBtoHSL(slice)
 S = ifelse(X[,,1,2]>lower_saturation_threshold,1,0)
 L = ifelse(X[,,1,3]>lower_luminance_threshold & X[,,1,3]<upper_luminance_threshold ,0.5,0)
 X[,,1,1] = X[,,1,1]
 X[,,1,2] = S
 X[,,1,3] = L
 plot(HSLtoRGB(X))

plot(density(X[,,1,1]), col="darkred",lwd=2,xlim=c(0,365),main="")
abline(v=230,col="navyblue",lwd=2)
abline(v=175,col="navyblue",lwd=2)



pruned_image=(Game_all5[[19]][[3]][[1]])
rows_image = imsplit(pruned_image,"y",4)
slice_image = imsplit(rows_image[[3]],"x",5)
slice = slice_image[2]
slice = slice[[1]]
plot(slice)

border_size  = 10
  px = Xc(slice) <= border_size                         
  slice[px] = 0                                           
  px = Xc(slice) >= dim(slice)[1]-border_size                  
  slice[px] = 0                                           
  px = Yc(slice) <= border_size*2                           
  slice[px] = 0                                           
  px = Yc(slice) >= dim(slice)[2]-border_size*2              
  slice[px] = 0  
  plot(slice)

iso_blur = 2
slice = isoblur(slice, iso_blur)
 plot(slice)

lower_saturation_threshold = 0.1
lower_luminance_threshold = 0.1
upper_luminance_threshold = 0.9
 X = RGBtoHSL(slice)
 S = ifelse(X[,,1,2]>lower_saturation_threshold,1,0)
 L = ifelse(X[,,1,3]>lower_luminance_threshold & X[,,1,3]<upper_luminance_threshold ,0.5,0)
 X[,,1,1] = X[,,1,1]
 X[,,1,2] = S
 X[,,1,3] = L
 plot(HSLtoRGB(X))

plot(density(X[,,1,1]), col="darkred",lwd=2,xlim=c(0,365),main="")
abline(v=165,col="seagreen4",lwd=2)
abline(v=110,col="seagreen4",lwd=2)




pruned_image=(Game_all5[[20]][[3]][[1]])
rows_image = imsplit(pruned_image,"y",4)
slice_image = imsplit(rows_image[[3]],"x",5)
slice = slice_image[2]
slice = slice[[1]]
plot(slice)

border_size  = 10
  px = Xc(slice) <= border_size                         
  slice[px] = 0                                           
  px = Xc(slice) >= dim(slice)[1]-border_size                  
  slice[px] = 0                                           
  px = Yc(slice) <= border_size*2                           
  slice[px] = 0                                           
  px = Yc(slice) >= dim(slice)[2]-border_size*2              
  slice[px] = 0  
  plot(slice)

iso_blur = 2
slice = isoblur(slice, iso_blur)
 plot(slice)

lower_saturation_threshold = 0.1
lower_luminance_threshold = 0.1
upper_luminance_threshold = 0.9
 X = RGBtoHSL(slice)
 S = ifelse(X[,,1,2]>lower_saturation_threshold,1,0)
 L = ifelse(X[,,1,3]>lower_luminance_threshold & X[,,1,3]<upper_luminance_threshold ,0.5,0)
 X[,,1,1] = X[,,1,1]
 X[,,1,2] = S
 X[,,1,3] = L
 plot(HSLtoRGB(X))

plot(density(X[,,1,1]), col="darkred",lwd=2,xlim=c(0,365),main="")
abline(v=350,col="purple",lwd=2)
abline(v=280,col="purple",lwd=2)


################################################################################## For Figure 9 v2
par(mfrow = c(2, 5))
pruned_image=(Game_all5[[15]][[3]][[1]])
rows_image = imsplit(pruned_image,"y",4)
slice_image = imsplit(rows_image[[3]],"x",5)
slice = slice_image[2]
slice = slice[[1]]
plot(slice)

border_size  = 10
  px = Xc(slice) <= border_size                         
  slice[px] = 0                                           
  px = Xc(slice) >= dim(slice)[1]-border_size                  
  slice[px] = 0                                           
  px = Yc(slice) <= border_size*2                           
  slice[px] = 0                                           
  px = Yc(slice) >= dim(slice)[2]-border_size*2              
  slice[px] = 0  
  plot(slice)

iso_blur = 2
slice = isoblur(slice, iso_blur)
 plot(slice)

lower_saturation_threshold = 0.1
lower_luminance_threshold = 0.1
upper_luminance_threshold = 0.9
 X = RGBtoHSL(slice)
 S = ifelse(X[,,1,2]>lower_saturation_threshold,1,0)
 L = ifelse(X[,,1,3]>lower_luminance_threshold & X[,,1,3]<upper_luminance_threshold ,0.5,0)
 X[,,1,1] = X[,,1,1]
 X[,,1,2] = S
 X[,,1,3] = L
 plot(HSLtoRGB(X))

plot(density(X[,,1,1]), col="darkred",lwd=2,xlim=c(0,365),main="")
abline(v=230,col="slateblue",lwd=2)
abline(v=175,col="indianred",lwd=2)

pruned_image=(Game_all5[[16]][[3]][[1]])
rows_image = imsplit(pruned_image,"y",4)
slice_image = imsplit(rows_image[[3]],"x",5)
slice = slice_image[2]
slice = slice[[1]]
plot(slice)

border_size  = 10
  px = Xc(slice) <= border_size                         
  slice[px] = 0                                           
  px = Xc(slice) >= dim(slice)[1]-border_size                  
  slice[px] = 0                                           
  px = Yc(slice) <= border_size*2                           
  slice[px] = 0                                           
  px = Yc(slice) >= dim(slice)[2]-border_size*2              
  slice[px] = 0  
  plot(slice)

iso_blur = 2
slice = isoblur(slice, iso_blur)
 plot(slice)

lower_saturation_threshold = 0.1
lower_luminance_threshold = 0.1
upper_luminance_threshold = 0.9
 X = RGBtoHSL(slice)
 S = ifelse(X[,,1,2]>lower_saturation_threshold,1,0)
 L = ifelse(X[,,1,3]>lower_luminance_threshold & X[,,1,3]<upper_luminance_threshold ,0.5,0)
 X[,,1,1] = X[,,1,1]
 X[,,1,2] = S
 X[,,1,3] = L
 plot(HSLtoRGB(X))

plot(density(X[,,1,1]), col="darkred",lwd=2,xlim=c(0,365),main="")
abline(v=230,col="slateblue",lwd=2)
abline(v=175,col="indianred",lwd=2)

