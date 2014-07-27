A. DATA INFORMATION

==================================================================
Human Activity Recognition Using Smartphones Dataset
Version 1.0
==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

Feature Selection 
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation


B.  DATA PROCESSING/CLEAN-UP/TRANSFORMATION INFORAMTION

The original raw data was saved in a zip archive.  User will need to download and extract the zip archive
to their specific working environment.

Use read.table to read the various txt files into data frames.
Use rbind to merge train and test data together 
User will need the reshape2 library to run the melt and dcast functions to generate the final data summary file.

##this code assumes that the flat files have already been saved in a specific location
##revise the file path as appropriate for  your case
 
## read the flat files of test set and training set, and their associated subject files into data frames testdt and traindt respectively
testdt<- read.table("C:/Users/Tan/Documents/R/Data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
testsubjdt<- read.table("C:/Users/Tan/Documents/R/Data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
 
traindt<- read.table("C:/Users/Tan/Documents/R/Data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
trainsubjdt<- read.table("C:/Users/Tan/Documents/R/Data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

## create subject (subj) column in the train and test data frames using the subject data.  This column is appended at the end of the column list
## testdt$subj = testsubjdt[ ,1]
## traindt$subj = trainsubjdt[ ,1]
## lastcol <- ncol(testdt)

## read the flat file of features into a data frame called feature
feature<- read.table("C:/Users/Tan/Documents/R/Data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")

## merge train and test sets together into a new data frame called dt
dt<- rbind(testdt,traindt)

## merge subjects of train and test sets together into a new data frame called subjdt
subjdt <- rbind(testsubjdt,trainsubjdt)

## identify features of mean and standard deviation only and create a subset of feature data frame called feature_subset containing only these features
sel_feature <- grepl("mean()",feature[,2],fixed=TRUE) | grepl("std()",feature[,2],fixed=TRUE)
feature_subset <- feature[sel_feature==TRUE,]

## subset the merged data set dt selecting only columns matching the feature subset
dt_subset<-dt[ ,feature_subset[ ,1]]

## assign column names to the tidy data set using column 2 from feature_subset
colnames(dt_subset)<- feature_subset[ ,2]

## create a subj column in the dt_subset data frame
dt_subset$subj = subjdt[,1]


## We now have a tidy data set!

## Create a new summary table where report average values for each test subject and activity

## First turn the data set into molten data set using the melt function from the reshape2 library

library(reshape2)
dtss_melt <- melt(dt_subset,id="subj")

## Next create a summary table dtss_summary
dtss_summary = dcast(dtss_melt, subj ~ variable, mean)

## saving results 
write.table(dtss_summary,"C:/Users/Tan/Documents/R/Data/dtss_summary.txt")
write.table(dt_subset,"C:/Users/Tan/Documents/R/Data/dt_subset.txt")



