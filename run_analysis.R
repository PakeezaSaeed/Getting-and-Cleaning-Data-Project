library(dplyr)
library(tidyverse)
library(skimr)

setwd("C:/Users/ok/Desktop/Coursera-Getting and Cleaning Data/Last Assignment/UCI HAR Dataset/train")
#Read the training set into R
training_set <- read.table("X_train.txt", sep = "", header = FALSE)
training_set <- tbl_df(training_set)
View(training_set)

#Read the training labels into R
training_labels <- read.table("y_train.txt", header = FALSE)
training_labels <- tbl_df(training_labels)
View(training_labels)

#Read the features into R so that they form the col names for test and train data 
setwd("C:/Users/ok/Desktop/Coursera-Getting and Cleaning Data/Last Assignment/UCI HAR Dataset")
features <- read.table("features.txt", sep = "", header = FALSE)
View(features)
colnames(features) <- c("col1", "col2")
features <- features[ ,"col2"]
features <- as.vector(features)

#Set the col names for training set
colnames(training_set) <- features
View(training_set)

#Read the testing set into R
setwd("C:/Users/ok/Desktop/Coursera-Getting and Cleaning Data/Last Assignment/UCI HAR Dataset/test")
testing_set <- read.table("X_test.txt", sep = "", header = FALSE)
testing_set <- tbl_df(testing_set)
View(testing_set)

#Read the testing labels into R
testing_labels <- read.table("y_test.txt", header = FALSE)
testing_labels <- tbl_df(testing_labels)
View(testing_labels)

#Set the col names for testing set
colnames(testing_set) <- features

#Read the activity labels into R
setwd("C:/Users/ok/Desktop/Coursera-Getting and Cleaning Data/Last Assignment/UCI HAR Dataset")
activity <- read.table("activity_labels.txt", header = FALSE)
View(activity)
activity <- activity[, "V2"]

#Set names to the testing/training labels according to the activities being performed
training_labels[training_labels == 1] <- c("Walking")
training_labels[training_labels == 2] <- c("Walking Up")
training_labels[training_labels == 3] <- c("Walking Down")
training_labels[training_labels == 4] <- c("Sitting")
training_labels[training_labels == 5] <- c("Standing")
training_labels[training_labels == 6] <- c("Laying")

testing_labels[testing_labels == 1] <- c("Walking")
testing_labels[testing_labels == 2] <- c("Walking Up")
testing_labels[testing_labels == 3] <- c("Walking Down")
testing_labels[testing_labels == 4] <- c("Sitting")
testing_labels[testing_labels == 5] <- c("Standing")
testing_labels[testing_labels == 6] <- c("Laying")

#Bind the labels with the data sets
testing_set <- cbind(testing_labels, testing_set)
View(testing_set)

training_set <- cbind(training_labels, training_set)
View(training_set)

##TASK 1: Merge the two data sets
merged_data <- rbind(training_set, testing_set)
View(merged_data)

##TASK 2: Extracts only the measurements on the mean and standard deviation for each measurement
merged_data <- merged_data[grepl(".mean()", names(merged_data)) | grepl(".std()", names(merged_data)) | grepl("^V1", names(merged_data))]
View(merged_data)

##TASK 3: Uses descriptive activity names to name the activities in the data set
## Done earlier. Read under #Set names to the testing/training labels according to the activities being performed
names(merged_data)[names(merged_data) == 'V1'] <- 'Activity'

##TASK 4: Appropriately labels the data set with descriptive variable names.
#Done earlier as well. See under Set the col names for training set and Set the col names for testing set

##TASK 5: From the data set in step 4, creates a second, independent tidy data set with the average of 
#each variable for each activity and each subject.
setwd("C:/Users/ok/Desktop/Coursera-Getting and Cleaning Data/Last Assignment/UCI HAR Dataset/train")
trainig_subjects <- read.table("subject_train.txt", header = FALSE)
View(trainig_subjects)

setwd("C:/Users/ok/Desktop/Coursera-Getting and Cleaning Data/Last Assignment/UCI HAR Dataset/test")
testing_subjects <- read.table("subject_test.txt", header = FALSE)
View(testing_subjects)

subjects <- rbind(trainig_subjects, testing_subjects)
merged_data <- cbind(subjects, merged_data)

names(merged_data)[names(merged_data) == 'V1'] <- 'Subjects'

CleanData <- aggregate(.~ Subjects + Activity, merged_data, mean) 
View(CleanData)
