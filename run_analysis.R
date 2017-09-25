setwd("C:/Soo Yin/Education & Reference/Coursera Online Course/Data Science Specialization/Course3 - Getting & Cleaning Data/Week4 Assignment")

#0 Get & unzip the data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url=fileUrl, "dataset.zip")
dataset<-unzip("dataset.zip",exdir=".")

#1 Merges the training and the test sets to create one data set

x_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")

x_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")

#colnames(x_train) <- features[,2] 
#colnames(y_train) <-"activityId"
#colnames(subject_train) <- "subjectId"

#colnames(x_test) <- features[,2] 
#colnames(y_test) <- "activityId"
#colnames(subject_test) <- "subjectId"

train_merge<-cbind(x_train,y_train,subject_train)
test_merge<-cbind(x_test,y_test,subject_test)
OneDataSet<-rbind(train_merge,test_merge)


#2 Extracts only the measurements on the mean and standard deviation for each measurement

features<-read.table("./UCI HAR Dataset/features.txt")
colnames(OneDataSet)<-features[,2]
colnames(OneDataSet)[562:563]<-c("activityID","subjectID")

mean_std<-grepl("activityID|subjectID|mean|std",colNames)
Data_meanstd<-OneDataSet[,mean_std==TRUE]


#3 Uses descriptive activity names to name the activities in the data set

activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activity_labels) <- c('activityID','activityType')
Data_ActivityNames <- merge(Data_meanstd, activity_labels, by='activityID', all.x=TRUE)


#4 Appropriately labels the data set with descriptive variable names => done in step2


#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(dplyr)
tidydata<-
    Data_ActivityNames %>%
    group_by(activityType,subjectID) %>%
    summarise_all(funs(mean)) %>% 
    arrange(subjectID,activityType)

write.table(tidydata,"tidydata.txt",row.name=FALSE)
    