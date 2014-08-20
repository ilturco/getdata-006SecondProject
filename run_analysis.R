#Create directory
if(!file.exists("./data")){dir.create("./data")}
#Download the file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile <- "getdata-projectfiles-UCI-HAR-Dataset.zip"
download.file(fileUrl, destfile=paste("data", destfile, sep="/"), method="curl")
fileDownloaded <- date()
fileDownloaded
#unzip it
unzip(paste("data", destfile, sep="/"), exdir="data")

data_dir <- "UCI HAR Dataset"
#the human readable list of activities
labels <- read.table(paste("data", data_dir, "activity_labels.txt", sep="/"), col.names=c("labelcode","label"))
#all the variables collected
features <- read.table(paste("data", data_dir, "features.txt", sep="/"))

#we are only interested in the variables that contains the strings "mean" and "std" (standard deviation)
indexes_of_interesting_features <- grep("mean\\(|std\\(", features[,2])



# TRAINING

training_folder <- paste("data", data_dir, "train", sep="/")
training_subjects <- read.table(paste(training_folder,
                    "subject_train.txt", sep="/"), col.names = "subject")
# 'train/X_train.txt': Training set. Loading all the field using the features dataframes for the col.names
training_data <- read.table(paste(training_folder, "X_train.txt", sep="/"), col.names = features[,2], check.names=FALSE)
# select only the interesting columns
training_data <- training_data[,indexes_of_interesting_features]
# 'train/y_train.txt': Training labels.
training_labels <- read.table(paste(training_folder, "y_train.txt", sep="/"),
                              col.names = "labelcode")
training_data_full = cbind(training_labels, training_subjects, training_data)


## SET
test_folder <- paste("data", data_dir, "test", sep="/")
test_subjects <- read.table(paste(test_folder, "subject_test.txt", sep="/"), 
                           col.names = "subject")
test_data <- read.table(paste(test_folder, "X_test.txt", sep="/"),
                        col.names = features[,2], check.names=FALSE)
test_data <- test_data[,indexes_of_interesting_features]
test_labels <- read.table(paste(test_folder, "y_test.txt", sep="/"),
                          col.names = "labelcode")
test_data_full = cbind(test_labels, test_subjects, test_data)

## MERGE
data_full <- rbind(training_data_full, test_data_full)
# adding the descriptions of the activities.
data_full = merge(labels, data_full, by.x="labelcode", by.y="labelcode")
# removing the id of the activities
data_full <- data_full[,-1]

## reshaping
library(reshape2)
data_full_long <- melt(data_full, id = c("label", "subject"))

## Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
# http://www.r-statistics.com/2012/01/aggregation-and-restructuring-data-from-r-in-action/
# label + subject is the set of crossed variables that define the rows
# "varable" is the set of crossed variables that define the columns
data_tidy <- dcast(data_full_long, label + subject ~ variable, mean)

## write the final dataset to disk
write.table(data_tidy, file="tidy_data_final.txt", quote=FALSE, row.names=FALSE, sep="\t")

