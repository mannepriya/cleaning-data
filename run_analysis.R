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
