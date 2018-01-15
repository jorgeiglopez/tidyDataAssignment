## Configuration of working directory
## setwd("./coursera-wd")  << put your own wd, were the files are.

## Importe the libraries that we're gonna use
library(dplyr)
library(reshape2)

## Check if we have all the files we need.
featuresExist <- file.exists("UCI HAR Dataset/features.txt")
activitiesExist <- file.exists("UCI HAR Dataset/activity_labels.txt")
testXExist <- file.exists("UCI HAR Dataset/test/X_test.txt")
testYExist <- file.exists("UCI HAR Dataset/test/y_test.txt")
testSubjectExist <- file.exists("UCI HAR Dataset/test/subject_test.txt")
trainXExist <- file.exists("UCI HAR Dataset/train/X_train.txt")
trainYExist <- file.exists("UCI HAR Dataset/train/y_train.txt")
trainSubjectExist <- file.exists("UCI HAR Dataset/train/subject_train.txt")

if(featuresExist & activitiesExist & testXExist & testYExist & testSubjectExist 
   & trainXExist & trainYExist & trainSubjectExist){
    features <- read.table("UCI HAR Dataset/features.txt")
    activities<- read.table("UCI HAR Dataset/activity_labels.txt")
    testX <- read.table("UCI HAR Dataset/test/X_test.txt")
    testY <- read.table("UCI HAR Dataset/test/y_test.txt")
    testSubject <- read.table("UCI HAR Dataset/test/subject_test.txt")
    trainX <- read.table("UCI HAR Dataset/train/X_train.txt")
    trainY <- read.table("UCI HAR Dataset/train/y_train.txt")
    trainSubject <- read.table("UCI HAR Dataset/train/subject_train.txt")
    
} else{
    message("Couldn't find some files. Please unzip all the files again")
    return()
}

## 1 - Set the proper column names (features) to the dataset
colnames(testX) <- features$V2
colnames(trainX) <- features$V2

## 2 We're just gonna use Mean() and Std() columns
testX1 <- testX[,grep("mean\\(|std\\(", colnames(testX))]
trainX1 <- trainX[,grep("mean\\(|std\\(", colnames(trainX))]

## 3 Merge and select the activities and subject
actTest <- select(merge (testY, activities), V2)
actTrain <- select(merge(trainY,activities), V2)
colnames(actTest) <- "Activity"
colnames(actTrain) <- "Activity"
colnames(testSubject) <- "SubjectId" 
colnames(trainSubject) <- "SubjectId" 

## 4 bind the columns and after bind both datasets
testComplete <- cbind(actTest, testSubject, testX1)
trainComplete <- cbind(actTrain, trainSubject, trainX1)
merged <- rbind(testComplete, trainComplete)
message("The tidy data set joining train and test is ready! It's called merged.")

## 5 Average of variables grouped by activity and subject
meltValues <- melt(merged, id=c("Activity","SubjectId"), measure.vars = 3:68)
decasted <- dcast(meltValues, Activity + SubjectId ~ variable, mean)
head(decasted)
message("Average of variables grouped by activity and subject is Ready!")
message("To check the full list, try: View(decasted)")
