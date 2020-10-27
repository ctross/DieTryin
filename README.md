DieTryin
========
This is an R package for making it super-easy to run RICH economic games <http://journals.sagepub.com/doi/abs/10.1177/1525822X16643709?journalCode=fmxd> and other dyadic data collection operations.

Here we will go through the process. First, we install by running on R:
```{r}
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
 games_to_add = c("FriendshipsData", "TrustData", "WisdomData", "WorkData", "EmotionData", "ReputationData")
 setup_folders(path, add=games_to_add)
```
By default, data storage is set up only for the RICH games. If one wants to also collect other questions or games, simply create folders for those questions/data by inlcuding the  games_to_add vector.

The next step is to bring in the raw photos of all respondents who will be invited to take part in the games. These should be jpg-formatted images. All of the filenames should be ID codes for the respodents: i.e., X1Z.jpg, A12.jpg, ZYZ.jpg. These strings should all be of the same length and must contain a letter as the first character. All file extensons should be the same. Now, just copy-and-paste the photos into the folder: RICH/RawPhotos

Now, we can move on to standardizing the photos. First, we run:
```{r}
 standardize_photos(path=path, pattern=".jpg", start=1, stop=3, 
	               size_out=1000, border_size=10, asr=1.6180, 
	               id_range=NULL, id_names=NULL, spin=TRUE)
```
This will open up a semi-automated photo editing process. The first image will pop up. If spin=TRUE, then we must tell R if the image should be spun. If the image is correctly rotated, click in the upper-left corner of the image, and it will disappear. If a 90 degree spin clockwise is needed, click the upper-right corner. Click the lower-right corner for a 180 degree spin, and the bottom-left for a 270 degree spin. Once a spin is selected, the same photo will re-appear. Now click at the point where the final image should have its upper-left corner, and drag the box out to set the boundares for the final processed image. Repeat for all photos. If you mess up and don't want to redo the whole loop, run the command but set id_names toinclude only the ids that need to be redone: i.e., id_names=c("XXX","XXY","A12") 

Its time to print out the photos, laminate them,  and arrange them on some boards!

Now we can move on to building the survey. We run:
```{r}
build_survey(path=path,pattern=".jpg",start=1,stop=3,frames=4,seed=1, rows=5, cols=8)
```
This builds a LaTeX file of the survey using the photo ids. Individual ids can be randomized by changing seed. Frames indicates how many boards of photos will be made. Rows and Cols give how many rows and cols of photos will be included on each board. The product Frames*Rows*Cols should be greater than or equal to the number of photos in the StandardizedPhotos folder. Now open the Survey folder and compile the survey.tex file. Now we have a PDF file. Print out 3 copies for each respodent and go collect some data! Write the number of coins/tokens placed by the focal on each id in the photo aray.

A whole bunch of work is now done, but we still need to enter the data. For this, we run:
```{r}
enter_data(path=path,pattern=".jpg",start=1,stop=3, seed=1, frames=4, rows=5, cols=8)
```
A pop-up will open in R. If this is the first game for a respondent, then type: Y
Otherwise, type: N

Now enter the header data and simply close the pop-up window. There is no need to save or hit ctrl+s.
A new pop-up opens. Now, if coin(s) were placed on an alter's id, click on that id, then type the number of coins placed, then move on to the next id. If no coins were placed on an alter, just leave the id ode alone. There is no need to type in the zeros.

Now that all of the data has been entered, lets compile it. First we run:
```{r}
compile_data(path=path,game="GivingData")
compile_data(path=path,game="LeavingData")
compile_data(path=path,game="ReducingData")
```
This will build two files for each game. A summary table, which gives self vs. alter allocation data, and checks that the sum of entries is correct. If the checksum cell isn't the same for all respodents, then someone probably made a mistake during data collection or data entry! Better go fix the corresponding .csv files. If the summary tables look good, then we are set. The other files are the edgelists. These say how many coins ego gave to each alter.

Now that we are sure that the data look good, lets see what we owe the community!
```{r}
calculate_payouts(path=path,pattern=".jpg",start=1,stop=3,game="GLR",GV=1,LV=0.5,KV=1,RV=-4)
```
Change GV, LV, KV, and RV to give the value of each coin in each game. GV for giving, LV for leaving/taking, KV for the value of coins kept in the reducing game, and RV for the reducation value of the tokens in the reducing game.

Great, now we have the payoffs. Lets hope you have an ATM nearbye, otherwise you will have people pounding on your door at 6AM asking for their money!


