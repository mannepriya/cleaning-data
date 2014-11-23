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