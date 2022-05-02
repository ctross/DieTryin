DieTryin
========
Social network collection and automated entry using R 
------
<img align="right" src="https://github.com/ctross/DieTryin/blob/master/logo3.png" alt="logo" width="140"> 
<img align="right" src="https://github.com/ctross/DieTryin/blob/master/logo.png" alt="logo" width="140">
<img align="right" src="https://github.com/ctross/DieTryin/blob/master/logo2.png" alt="logo" width="140">

**DieTryin** is an R package designed to facilitate the collection of roster-based network data, and to run network-structured economic games—such as [Recipient Identity-Conditioned Heuristics (RICH) games](http://journals.sagepub.com/doi/abs/10.1177/1525822X16643709?journalCode=fmxd). This is a brief overview of a workflow. For further details on any step, see our full publication in [Behavior Research Methods](https://doi.org/10.3758/s13428-021-01606-5). 

In order to replicate our workflow from the BRM paper exactly, you will need to download the specific image files we use therein, and place them into the appropriate folders. Download the images [here](https://www.dropbox.com/s/lzazr97erlvbq5u/Workflow.zip?dl=0). In order to replicate our workflow from the AMPPS paper exactly, you will need to download the specific image files we use [here](https://www.dropbox.com/s/uuw6qbzieu0o6qc/TestImages.zip?dl=0) instead.

A raw version of the R code described below can be found [here](https://github.com/ctross/DieTryin/blob/master/Workflow.R)
  
[**DieTryin**](https://github.com/ctross/DieTryin) is part of an ecosystem of tools for contemporary social network analysis. [**STRAND**](https://github.com/ctross/STRAND) is a companion package designed to allow users to specify complex Bayesian social network models using a simple, lm() style, syntax. **ResolveR** (currently under development) is a package for semi-supervised data cleaning, de-duplication, and record linkage.

Data Collection with DieTryinCam
------
To collect data using DieTryinCam, just photograph the roster after tokens have been placed to indicate ties. Then use DieTryin in R to automagically encode the data as color-labeled edge-lists.
![Android Camera API](https://github.com/ctross/DieTryinCam/blob/main/DieTryinCam.png?raw=true)
 
Data Entry with DieTryin
------

Here we will go through the entire DieTryin workflow.  DieTryin works best on Windows. We note that Mac users may have issues using some interactive functions. If this is the case, installing an older version of imager (e.g., 0.41.1) should resolve the issue as long as the user has X11 installed.
```{r}
library(devtools)
install_version("imager", version = "0.41.2", repos = "http://cran.us.r-project.org")
```

Otherwise, we can install by running on R:
```{r}
################################### Install and/or load
 library(devtools)
 #You might need to turn off warning-error-conversion, because the tiniest warning stops installation
 Sys.setenv("R_REMOTES_NO_ERRORS_FROM_WARNINGS" = "true")
 install_github('ctross/DieTryin')
 library(DieTryin)
```

Next, we set a path to where we will save all of the files related to this project:
```{r}
 path = "C:\\Users\\cody_ross\\Desktop"
```

Now, we initialize a directory structure there:
```{r}
################################### Setup directory
# We set up storage for the RICH games data and data from several other social networks
 games_to_add = c("FriendshipsData", "TrustData", "WisdomData", "WorkData", "EmotionData", "ReputationData")
 setup_folders(path, add=games_to_add)
```

By default, data storage is set up only for RICH games. If you would like to also collect data on other questions or games, simply create folders for those questions/games by including them in the games_to_add vector.

Image standardization and survey creation
------

The next step is to bring in the raw photos of all respondents who will be invited to take part in the games. These should be jpg-formatted images. All of the filenames should be ID codes for the respondents: i.e., X1Z.jpg, A12.jpg, ZYZ.jpg. These strings should all be of the same length and must contain a letter as the first character. All file extensions should be the same. Now, just copy-and-paste the photos into the folder: RICH/RawPhotos. To use our example images, copy the photographs from the RespodentsImages folder in the .zip file above into the RICH/RawPhotos folder in your own directory.

Now, we can move on to standardizing the photos. First, we run:
```{r}
################################### Standardize photos
# First paste the images in the RespodentsImages folder in this zip folder 
# into the RawImages folder in the RICH folder created just above, then run:
 standardize_photos(path=path, pattern=".jpg", start=1, stop=3, 
                 size_out=1000, border_size=10, asr=1.6180, 
                 id_range=NULL, id_names=NULL, spin=TRUE)
```

This will open up a semi-automated photo editing process. The first image will pop up. If spin=TRUE, then we must tell R if the image should be spun. If the image is correctly rotated, click in the upper-left corner of the image, and it will disappear. If a 90 degree spin clockwise is needed, click the upper-right corner. Click the lower-right corner for a 180 degree spin, and the bottom-left for a 270 degree spin. Once a spin is selected, the same photo will re-appear. Now click at the point where the final image should have its upper-left corner, and drag the box out to set the boundaries for the final processed image. Repeat for all photos. If you mess up and don't want to redo the whole loop of photo editing, run the same command but set id_names to include only the ids that need to be redone: i.e., id_names=c("XXX","XXY","A12") or id_names="EW1". 

```{r}
# Imagine you messed up somewhere and want to re-do a single image, then run:
 standardize_photos(path=path, pattern=".jpg", start=1, stop=3, 
                 size_out=1000, border_size=10, asr=1.6180, 
                 id_range=NULL, id_names="EW1", spin=TRUE)
```

With the photos standardized, it’s time to print them, laminate them, and arrange them on some boards!


Now we can move on to building the survey. We run:
```{r}
################################### Now create the survey tool
# To create a random order of ID codes, run:
 build_survey(path=path, pattern=".jpg", start=1, stop=3, 
            n_panels=2, n_rows=4, n_cols=5, seed=15, ordered = NULL)

# But, for now lets set a specific sorting order instead
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
```

This builds a LaTeX file of the survey tool using the photo IDs and compiles it to a PDF. The order of ID code can be randomized by changing the seed (as in the first example above). n_panels indicates how many boards/panels of photos will be made. n_rows and n_cols give how many rows and cols of photos will be included on each board. Now open the Survey folder and find the LaTeX file and PDF file of the survey. Edits to the LaTeX file can be made manually, or the header.txt file can be edited prior to running the build_survey function (this is the preferred option). Print out several copies for each respondent and go collect some data! Write the number of coins/tokens placed by the focal on each ID in the photo array.

Manual data entry and payout calculation
------

A whole bunch of work is now done, but we still need to enter the data. For this, we run:
```{r}
################################### Enter some data for the RICH games
# Repeat this line to enter RICH data for a few ID codes above (e.g., "JLO","AOC", and "FKA"), for each of the three games ("G", "L", and "R")
# You must input data for ID and Game in the header file. Other entries, like date, are optional.
 enter_data(path=path, pattern=".jpg", start=1, stop=3, n_panels=2, n_rows=4, n_cols=5, seed=1, ordered = sorted_ids, add=games_to_add)
# In the event of a data entry error just re-run the above function, and it will overwrite the erroneous, person- and game-specific data file.
```

A pop-up will open in R. If this is the first game for a respondent, then type: Y
Otherwise, type: N

Now enter the header data and simply close the pop-up window. There is no need to save or hit ctrl+s.
A new pop-up now opens. Now, if coin(s) were placed on an alter's ID, click on that ID, then type the number of coins placed, then move on to the next ID. If no coins were placed on an alter, just leave the ID code alone. There is no need to type in the zeros. To make the following code work, enter some simulated data for at least 3 respondents (using the IDs in the sorted_ids vectors as their ID codes), for each of the three RICH games. Note that in the header file, the argument Game must take one of three special values for the RICH games data (G for the giving/allocation game, L for the leaving/taking/exploitation game, and R for the reduction/punishment game). Other question types can be given arbitrary names (corresponding to those supplied in the add argument of the setup_folders function). 

Now that all of the data has been entered, lets compile it. First we run:
```{r}
################################### Compile the data and check it for accuracy
 compile_data(path=path, game="GivingData")
 compile_data(path=path, game="LeavingData")
 compile_data(path=path, game="ReducingData")
# Now check the results in the Results subfolder, and ensure that the summary tables look correct. If there are errors, then
# fix the csv files by hand, or re-run the enter_data() function for the specific inviduals with data entry errors. Then,
# run the above compile functions again. Repeat until all summary tables look correct.
```

This will build two files for each game (a summary table and an edge-list). The summary table, which gives self vs. alter allocation data, checks that the sum of entries is correct. If the checksum cell isn't the same for all respondents, then someone probably made a mistake during data collection or data entry! If that's the case, then we better go and fix the corresponding .csv files. If the summary tables look good, then we are set. The other files are the edgelists. These say how many coins ego gave to each alter, and can be converted into network objects by igraph.

Now that we are sure that the data look good, let's see what we owe the community!
```{r}
################################### Calculate payoffs
 calculate_payouts(path=path, pattern=".jpg", start=1, stop=3, game="GLR", GV=1, LV=0.5, KV=1, RV=-3)
```

Change GV, LV, KV, and RV to give the value of each coin in each game. GV for giving, LV for leaving/taking, KV for the value of coins kept in the reducing game, and RV for the reduction value of the tokens in the reducing game.

Automatic data entry
------

While RICH game data may at times be best entered manually, since there can be several coins allocated to each recipient, it can be useful to collect additional binary dyadic data: e.g.,
"With whom have you shared food in the last 30 days?" using the same photograph roster. By placing tokens of a known color on the photograph roster to indicate directed ties and then photographing the resulting game boards, a researcher can implement an automated data entry workﬂow with DieTryin. To use our example images, copy the photographs from the relevant .zip folders above into the RICH/ResultsPhotos folder in your own directory.

When it comes time to collect your own photos, consider using our Android app [**DieTryinCam**](https://github.com/ctross/DieTryin/blob/master/DieTryinCam-v1.2.apk) to collect the data and properly format the filenames.

```{r}
################################### Now, automatic coding
 # First paste results photos into the ResultsPhotos directory, with properly formatted titles
 # of form: "GAMEID_PERSONID_PANELID.jpg" then downsize the images if needed to speed the processing code
 downsize(path=path, scaler=3) # set scaler=1 to keep same size, as the attached photos are already small
```
In order to set the right parameters for lower_hue_threshold and upper_hue_threshold in the functions below, it is helpful to check out the actual hue of your tokens.
```{r}
# So pick a photo with all your token colors and run:
 get_hue(paste0(path,"/ResultsPhotosSmall/G_SS1_A.jpg")) 
# make sure to click on several tokens and several places on each token to get a good idea of the range of hue values that each token may take.
# get_hue(file.choose()) # will allow you to select a pictures without having to input the file path directly
```

Now, we can run a quick example of automatic data entry. For automatic entry, set automate = TRUE. Data will be saved in appropriate folders. If the images are tricky and need manual corner-clicking, just set automate = FALSE. The user must then click the top-left corner of the photograph array, then the top-right, bottom-right, and bottom-left, in that order. This provides DieTryin with the information needed to crop-out only the photograph array, and correct any rotations or distortions. The user will need to process the blank boards and the boards for at least one other question/game. 
```{r}
classify(
  path=path,
  PID = "SS1",
  HHID = "SKA",
  RID = "CR",
  day = 12, month = 4, year = 2020,
  name = "Cody",
  panels = c("A", "B"),
  questions = c("A","B","C","D","E","F","G","H"),
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
```


