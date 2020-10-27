DieTryin
========
This is an R package for making it super-easy to run RICH economic games <http://journals.sagepub.com/doi/abs/10.1177/1525822X16643709?journalCode=fmxd> and other dyadic data collection operations. This is a brief overview of a workflow. For further details on any step, see our pre-print at <http://journals.sagepub.com/doi/abs/10.1177/1525822X16643709?journalCode=fmxd>. 

In order to replicate our code exactly, you will need to download the specific image files we use in this example, and place them into the approriate folders. Download the images with this link: <http://journals.sagepub.com/doi/abs/10.1177/1525822X16643709?journalCode=fmxd>. 

Here we will go through the whole DieTryin workflow. First, we install by running on R:
```{r}
################################### Install and/or load
 library(devtools)
 install_github('ctross/DieTryin')
 library(DieTryin)
```

Next, we set a path to where we will save all of the files related to this project:
```{r}
path<-"C:\\Users\\cody_ross\\Desktop"
```

Now, we initialize a directory structure:
```{r}
################################### Setup directory
# We set up for RICH games and extra network data
 games_to_add = c("FriendshipsData", "TrustData", "WisdomData", "WorkData", "EmotionData", "ReputationData")
 setup_folders(path, add=games_to_add)
```
By default, data storage is set up only for the RICH games. If one wants to also collect other questions or games, simply create folders for those questions/games by inlcuding the  games_to_add vector.

The next step is to bring in the raw photos of all respondents who will be invited to take part in the games. These should be jpg-formatted images. All of the filenames should be ID codes for the respodents: i.e., X1Z.jpg, A12.jpg, ZYZ.jpg. These strings should all be of the same length and must contain a letter as the first character. All file extensons should be the same. Now, just copy-and-paste the photos into the folder: RICH/RawPhotos. To use our example images, copy the photographs from the RespodentsImages folder in the .zip file above into the RICH/RawPhotos folder in your own directory.

Now, we can move on to standardizing the photos. First, we run:
```{r}
################################### Standardize photos
# First paste the images into the RawImages folder, then run:
 standardize_photos(path=path, pattern=".jpg", start=1, stop=3, 
	               size_out=1000, border_size=10, asr=1.6180, 
	               id_range=NULL, id_names=NULL, spin=TRUE)
```
This will open up a semi-automated photo editing process. The first image will pop up. If spin=TRUE, then we must tell R if the image should be spun. If the image is correctly rotated, click in the upper-left corner of the image, and it will disappear. If a 90 degree spin clockwise is needed, click the upper-right corner. Click the lower-right corner for a 180 degree spin, and the bottom-left for a 270 degree spin. Once a spin is selected, the same photo will re-appear. Now click at the point where the final image should have its upper-left corner, and drag the box out to set the boundares for the final processed image. Repeat for all photos. If you mess up and don't want to redo the whole loop, run the command but set id_names to include only the ids that need to be redone: i.e., id_names=c("XXX","XXY","A12"). 

Its time to print out the photos, laminate them, and arrange them on some boards!

Now we can move on to building the survey. We run:
```{r}
################################### Create the survey tool
# Lets set a specific sorting order (not required, but sometimes desired)
 sorted_ids = c("DB1","AR1","AY1","JLO","AF1","ASF","BO1","BYC","AOC","AT1",
                "BS1","CCM","LF1","MK1","RBG","CT1","JC1","SS1","TT1","SW1",
                "KC1","EDG","FKA","JK1","DB2","EM1","FN1","RKM","DJT","EW1",
                "JA1","SK1","KW1","LWA","MM1","SR1","LCK","MB1","MR1")

 build_survey(path=path, pattern=".jpg", start=1, stop=3, 
 	          n_panels=2, n_rows=4, n_cols=5, seed=1, ordered = sorted_ids)
```
This builds a LaTeX file of the survey using the photo IDs. Individual IDs can be randomized by changing seed. n_panels indicates how many boards of photos will be made. n_rows and n_cols give how many rows and cols of photos will be included on each board. Now open the Survey folder and find the LaTeX file and PDF file of the survey. Edits to the LaTeX file can be made manually, or the header.txt file can be edited prior to running the build survey function (this is the prefered option). Print out several copies for each respodent and go collect some data! Write the number of coins/tokens placed by the focal on each ID in the photo aray.

A whole bunch of work is now done, but we still need to enter the data. For this, we run:
```{r}
################################### Enter some data for the RICH games
# Repeat this line to enter RICH data for a few ID codes above, for each of the three games
 enter_data(path=path, pattern=".jpg", start=1, stop=3, n_panels=2, 
            n_rows=4, n_cols=5, seed=1, ordered = sorted_ids, add=games_to_add)
```
A pop-up will open in R. If this is the first game for a respondent, then type: Y
Otherwise, type: N

Now enter the header data and simply close the pop-up window. There is no need to save or hit ctrl+s.
A new pop-up opens. Now, if coin(s) were placed on an alter's ID, click on that ID, then type the number of coins placed, then move on to the next ID. If no coins were placed on an alter, just leave the ID code alone. There is no need to type in the zeros. To make the following code work, enter some simulated data for at least 3 respodents, for each of the three RICH games. Note that in the header file, the argument Game must take one of three special values for the RICH games data (G for the giving/allocation game, L for the leaving/taking game, and R for the reduction/punishment game). Other question types can be given arbitrary names (corresponding to those supplied in the add argument of the
setup folders function). 

Now that all of the data has been entered, lets compile it. First we run:
```{r}
################################### Compile the data and check it for accuracy
 compile_data(path=path, game="GivingData")
 compile_data(path=path, game="LeavingData")
 compile_data(path=path, game="ReducingData")
```
This will build two files for each game. A summary table, which gives self vs. alter allocation data, and checks that the sum of entries is correct. If the checksum cell isn't the same for all respodents, then someone probably made a mistake during data collection or data entry! Better go fix the corresponding .csv files. If the summary tables look good, then we are set. The other files are the edgelists. These say how many coins ego gave to each alter.

Now that we are sure that the data look good, lets see what we owe the community!
```{r}
################################### Calculate payoffs
 calculate_payouts(path=path, pattern=".jpg", start=1, stop=3, game="GLR", GV=1, LV=0.5, KV=1, RV=-3)
```
Change GV, LV, KV, and RV to give the value of each coin in each game. GV for giving, LV for leaving/taking, KV for the value of coins kept in the reducing game, and RV for the reducation value of the tokens in the reducing game.


While RICH game data is often best entered manually, since there can be several coins allocated to each recipient, it can be useful to collect additional binary dyadic data: e.g.,
"With whom have you shared food in the last 30 days?" using the same photograph roster. By placing tokens of a known color on the photograph roster to indicate directed ties and then photographing the resulting game boards, a researcher can implement an automated data entry workﬂow with DieTryin. To use our example images, copy the photographs from the CollectedDataImages folder in the .zip file above into the RICH/RawPhotos folder in your own directory.
```{r}
################################### Now, automatic coding
 # First paste results photos into the ResultsPhotos directory, with properly formatted titles
 # of form: "GAMEID_PERSONID_PANELID.jpg" then downsize the images if needed to speed the processing code
 downsize(path=path, scaler=1) # set scaler=1 to keep same size, as the attached photos are already small
```

Now, we can run a quick example of automatic data entry for binary tie data. The user must pre-process the images. The pre_process function opens an interactive window that
displays each photo array. The user must click the top-left corner of the photograph array, then the top-right, bottom-right, and bottom-left, in that order. This provides DieTryin with the information needed to crop-out only the photograph array, and correct any rotations or distortions. The user will need to process the blank boards and the boards for at least one other question/game. 
```{r}
################################### Pre-process the data needed for analysis
# These lines will open a window where corners must be clicked
 blank1 = pre_process(path=path, ID="CTR", GID="Blank", PID=c("A","B"))            # control with no tokens
 friend1 = pre_process(path=path, ID="CTR", GID="FriendshipsData", PID=c("A","B")) # game play with tokens

 game_images_all1 = list(blank1[[1]], friend1[[1]]) # Then organize into a list
 game_locs_all1 = list(blank1[[2]], friend1[[2]])
 GID_all1 = list("Blank", "FriendshipsData")
```

Once the data are pre-processed, the classifier can be applied:
```{r}
################################### Run the classifier
 Game_all1 = auto_enter_all(path=path, pattern=".jpg", start=1, stop=3, seed=1, n_panels=2, n_rows=4, n_cols=5, 
                             thresh=0.1, lower_hue_threshold = 135, upper_hue_threshold = 170,  
                             plot_colors=c("empty","seagreen4"), img=game_images_all1, locs=game_locs_all1, focal="CTR",
                             case=GID_all1, ordered=sorted_ids,
                             lower_saturation_threshold=0.12, 
                             lower_luminance_threshold=0.12, 
                             upper_luminance_threshold=0.88,  
                             border_size=0.22,
                             iso_blur=1,
                             histogram_balancing=FALSE,
                             direction="backward")
```

