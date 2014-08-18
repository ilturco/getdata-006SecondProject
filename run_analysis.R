#if not exists download
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile <- "getdata-projectfiles-UCI-HAR-Dataset.zip"
download.file(fileUrl, destfile=paste("data", destfile, sep="/"), method="curl")
unzip(paste("data", destfile, sep="/"), exdir="data")

untar("./activity.zip", compressed = 'gzip')
datas <- read.csv('./activity.csv', na.strings="NA")