# packages and wd
library(reshape2)
# setwd(paste(Sys.getenv('HOME'), "/odrive/data", "/courseraDS/", sep = ""))
path <- getwd()
## uncomment the below 3 lines if data is already downloaded and extracted
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, paste0(path, "/dataFiles.zip"))
unzip(zipfile = "dataFiles.zip")

# load activity labels + features
activityLabels <- read.table(paste0(path, "/UCI HAR Dataset/activity_labels.txt"), header = FALSE,
  col.names = c("classLabels", "activityName"))
features <- read.table(paste0(path, "/UCI HAR Dataset/features.txt"),
  col.names = c("index", "featureNames"))
featuresWanted <- grep("(mean|std)\\(\\)", features[, 2])
measurements <- features[featuresWanted, 2]
measurements <- gsub('[()]', '', measurements)

# load test and train datasets and merge them
train <- read.table(paste0(path, "/UCI HAR Dataset/train/X_train.txt"))[, featuresWanted, 2]
names(train) <- measurements
trainActivities <- read.table(paste0(path, "/UCI HAR Dataset/train/Y_train.txt"),
  col.names = c("Activity"))
trainSubjects <- read.table(paste0(path, "/UCI HAR Dataset/train/subject_train.txt"),
  col.names = c("SubjectNum"))
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table(paste0(path, "/UCI HAR Dataset/test/X_test.txt"))[, featuresWanted, 2]
names(test) <- measurements
testActivities <- read.table(paste0(path, "/UCI HAR Dataset/test/Y_test.txt"),
    col.names = c("Activity"))
testSubjects <- read.table(paste0(path, "/UCI HAR Dataset/test/subject_test.txt"),
    col.names = c("SubjectNum"))
test <- cbind(testSubjects, testActivities, test)

combinedData <- rbind(train, test)

# convert to factor variables and use reshape2's melt and dcast functions to perform step 5
## more info: https://seananderson.ca/2013/10/19/reshape/
combinedData[["Activity"]] <- factor(combinedData[, c("Activity")],
  levels = activityLabels[["classLabels"]], labels = activityLabels[["activityName"]])
combinedData[["SubjectNum"]] <- as.factor(combinedData[, c("SubjectNum")])
combinedData <- melt(data = combinedData, id = c("SubjectNum", "Activity"))
combinedData <- dcast(data = combinedData, SubjectNum + Activity ~ variable, fun.aggregate = mean)

write.csv(combinedData, "tidyDataSet.txt", row.names = FALSE, quote = FALSE)