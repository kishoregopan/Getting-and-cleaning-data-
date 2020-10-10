#Data file downloaded directly from URL and placed in local folder

#Get list of files
path_rf <- file.path("~/Desktop/Coursera/UCI HAR Dataset")
files <- list.files(path_rf, recursive = TRUE)
files

#Reading data from variables based on descriptions 
dataActivityTest <- read.table(file.path(path_rf, "test", "Y_test.txt"),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"), header = FALSE)

dataSubjectTest <- read.table(file.path(path_rf, "test", "subject_test.txt"), header = FALSE)
dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"), header = FALSE)

dataFeaturesTest <- read.table(file.path(path_rf, "test", "X_test.txt"), header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"), header = FALSE)

#Merging the "TEST" and "TRAINING" data sets to one data set
dataActivity <- rbind(dataActivityTest, dataActivityTrain)
dataSubject <- rbind(dataSubjectTest, dataSubjectTrain)
dataFeatures <- rbind(dataFeaturesTest, dataFeaturesTrain)

#Setting variable names 
names(dataActivity) <- c("activity")
names(dataSubject) <- c("subject")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"), header = FALSE)
names(dataFeatures) <- dataFeaturesNames$V2

#Merging columns to one data frame for all data
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

#Extracting mean and standard deviation for each measurement 
subdataFeaturesNames <- dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames <- c(as.character(subdataFeaturesNames), "subject", "activity")
Data <- subset(Data, select = selectedNames)

#Setting descriptive activity names to all activities in data set 
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"), header = FALSE)

#Factorize variables and activity in DF include descriptive activity names 
Data$activity <- factor(Data$activity)
Data$activity <- factor(Data$activity, labels = as.character(activityLabels$V2))

#Setting descriptive variable names to all activities in data set 
# - prefix t is replaced by time
# - Acc is replaced by Accelerometer
# - Gyro is replaced by Gyroscope
# - prefix f is replaced by frequency
# - Mag is replaced by Magnitude
# - BodyBody is replaced by Body

names(Data) <- gsub("^t", "time", names(Data))
names(Data) <- gsub("^f", "frequency", names(Data))
names(Data) <- gsub("^Acc", "Accelerometer", names(Data))
names(Data) <- gsub("^Gyro", "Gyroscope", names(Data))
names(Data) <- gsub("^Mag", "Magnitude", names(Data))
names(Data) <- gsub("^BodyBody", "Body", names(Data))

#Creating a second and independent TIDY data set w/ output 

library(plyr)

Data2 <- aggregate(. ~subject + activity, Data, mean)
Data2 <- Data2[order(Data2$subject, Data2$activity),]
write.table(Data2, file = "tidydata.txt", row.name = FALSE)
