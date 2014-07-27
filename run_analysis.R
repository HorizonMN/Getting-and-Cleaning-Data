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
