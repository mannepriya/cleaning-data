Analysis on the Human Activity Recognition Using Smartphones Dataset
Data source:https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Analysis has been carried out in R by downloading the data from the above provided link
Assumptions for R code: All the files have been downloaded,extracted and present in the working directory for R 

Flow of the analysis is as below
1.Different files containing data w.r.t training data set have been read into R
i.e.,X_train.txt,subject_train.txt and y_train.txt
2.They have been combined using cbind() function to create a data set (xtrain_2)with the subject and training label included
3.above two steps are repeated for testing data to create a data set(xtest_2) including subject and activity label
4.Both the datasets xtest_2 and xtrain_2 have been combined using the function rbind()
5.list of all features has been read from features.txt file into data table features
6.List of features is used for providing descriptive variable names for the traintest data setby using colnames()
7.traintest dataset has been filtered to contain only the measurements on the mean and standard deviation for each measurement
for arriving at this it has been assumed that only the measurements with mean() or std() in the name only will
have to be considered. function grep() has been used for this purpose.
The so extracted data set is named  traintest_filter
8.file containing activity lables activity_labels.txt has been read into R and is merged with the traintest_filter.
This has provided appropriate descriptive activity names to name the activities in the data set.
The resulting data set with the lables is named traintest_label
9.Using the reshape2 package, using functions melt() and dcast() a second independent tidy data set
 with the average of each variable for each activity and each subjecthas been created and named tidy_traintest
10.This resulting tidy data set from the above step is saved into the working directory by using write.table() function

All the above steps were carried out using teh Rscript in the file run_analysis.R
teh R script is as below

##Using data collected from the accelerometers from the Samsung Galaxy S
##smartphone.solving for the assignment in the course 

fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl,destfile="./dataset.zip") # for file download
dataset<-unzip("./dataset.zip")

## Reading various files
xtrain<-read.table("./UCI HAR Dataset/train/X_train.txt")
subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
ytrain<-read.table("./UCI HAR Dataset/train/y_train.txt")
##Joining data in different files
xtrain_2<-cbind(subject_train,ytrain,xtrain)
colnames(xtrain_2)<-c("subject","training lables")
xtest<-read.table("./UCI HAR Dataset/test/X_test.txt")
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
ytest<-read.table("./UCI HAR Dataset/test/y_test.txt")
xtest_2<-cbind(subject_test,ytest,xtest)
colnames(xtest_2)<-c("subject","training lables")
## Merges the training and the test sets to create one data set called traintest
traintest<-rbind(xtrain_2,xtest_2)
features<-read.table("./UCI HAR Dataset/features.txt")
features<-as.character(features[,2])
features1<-c("subject","activity lables",features)
##Appropriately labels the data set with descriptive variable names. 
colnames(traintest)<-features1

##Extracting the measurements with mean and stadard deviation for each measurement
##Assuming that only the measuremnets with mean() or std() in the name only will
##have to be considered for the above purpose
traintest_filter1<-traintest[,grep("mean\\(\\)",colnames(traintest))]
traintest_filter2<-traintest[,grep("std\\(\\)",colnames(traintest))]
traintest_filter<-cbind(traintest[,1:2],traintest_filter1,traintest_filter2)
## traintest_filter Extracts only the measurements on the mean and standard 
## deviation for each measurement. 

##labelling the name of the activities
activity_label<-read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activity_label)<-c("activity_label","activity")
traintest_label<-merge(activity_label,traintest_filter,
                       by.y="activity lables",by.x="activity_label",all=TRUE)
traintest_label<-traintest_label[,2:ncol(traintest_label)]

##Creating the tidy data set with the averages of each activity for each subject
##for each variable

library(reshape2)
melt_traintest<-melt(traintest_label,id=c("activity","subject"),
        measure.vars=colnames(traintest_label[,3:68]))
tidy_traintest<-dcast(melt_traintest,activity+subject~variable,mean)
##tidy_traintest meets all teh criteria of a tidy data set such as
##each variable forms a column; 2. Each observation forms a row;
##each table stores the observations about one kind of variable only
write.table(tidy_traintest,"./tidy_averages.txt")

