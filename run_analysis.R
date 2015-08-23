#I comment the following line to be specific to my system.
#setwd("C:/Users/Intrea/Documents/Cursos/R/GettingAndCleaningData/data")

#It's necesary for use 'melt' in the five point.
library(reshape2)

#1. Merges the training and the test sets to create one data set.
#Load and merge Sets.
trainSet <- read.table("./train/X_train.txt")
testSet <- read.table("./test/X_test.txt")
#I check if the number of columns is the same in both sets.
if (dim(trainSet)[2] == dim(testSet)[2]) {
	mergeSet <- rbind(trainSet, testSet)
}
#remove the Sets.
rm(trainSet)
rm(testSet)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("./features.txt")
#I generate a vector of indices where the name of the columns containing 'mean' or 'std'.
iMeanStd <- grep("mean\\(\\)|str\\(\\)", features[, 2])
resMeanStd <- mergeSet[, iMeanStd]
names(resMeanStd) <- features[iMeanStd, 2]

#3. Uses descriptive activity names to name the activities in the data set.
trainLabel <- read.table("./train/y_train.txt")
testLabel <- read.table("./test/y_test.txt")
if (dim(trainLabel)[2] == dim(testLabel)[2]) {
	mergeLabel <- rbind(trainLabel, testLabel)
}
rm(trainLabel)
rm(testLabel)
activities <- read.table("./activity_labels.txt")
mergeLabel[,1] <- activities[mergeLabel[,1],2]
names(mergeLabel) <- "Activity"

#4. Appropriately labels the data set with descriptive variable names.
trainSubject <- read.table("./train/subject_train.txt")
testSubject <- read.table("./test/subject_test.txt")
if (dim(trainSubject)[2] == dim(testSubject)[2]) {
	mergeSubject <- rbind(trainSubject, testSubject)
}
rm(trainSubject)
rm(testSubject)
names(mergeSubject) <- "Subject"
names(mergeSet) <- features[, 2]
#I check if the number of rows is the same in both sets.
if ((dim(mergeSubject)[1] == dim(mergeLabel)[1]) & (dim(mergeLabel)[1] == dim(mergeSet)[1])) {
	cleanedData <- cbind(mergeSubject, mergeLabel, mergeSet)
}

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidyData <- melt(cleanedData, id=c("Subject", "Activity"))
tidyData <- dcast(tidyData, Subject + Activity ~ variable, mean)
write.table(tidyData, "./result.txt", row.name=FALSE)
