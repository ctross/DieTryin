library(devtools)
install_github('ctross/DieTrying')
library(DieTrying)

path<-"C:\\Users\\Mind Is Moving\\Desktop"
setup_folders(path)

standardize_photos(path=path, pattern=".jpg",start=1,stop=3, size_out=1000,border_size=10,asr=1.6180, id_range=NULL,id_names=NULL,spin=TRUE)

build_survey(path=path,pattern=".jpg",start=1,stop=3,frames=4,seed=1, rows=5, cols=8)

enter_data(path=path,pattern=".jpg",start=1,stop=3, seed=1, frames=4, rows=5, cols=8)

compile_data(path=path,game="GivingData")
compile_data(path=path,game="LeavingData")
compile_data(path=path,game="ReducingData")

calculate_payouts(path=path,pattern=".jpg",start=1,stop=3,game="GLR",GV=1,LV=0.5,KV=1,RV=-4)
   


