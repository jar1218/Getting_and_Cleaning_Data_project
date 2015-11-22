library(plyr)

#Read in the features file, which contains the column names
features <- read.table("./UCI HAR Dataset/features.txt", sep=" ")

#Read in the test dataset, using the the column names from freature. Then get the subjects and activities
testdata <- read.table("./UCI HAR Dataset/test/X_test.txt",col.names=features[,2])
testSubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names=c("Subject"))
testActivities <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names=c("Activity"))

#Now for the fun part, getting on the *mean() and *std() columns.
#I suppose we could just manually populate the list of column indeces to keep,
#but I think that would suck.
featurestoinclude <- grep("mean()|std()", features[,2])
testdata <- testdata[,featurestoinclude]

#Put the three together
testdata$Subject <- testSubjects$Subject
testdata$Activity <- testActivities$Activity

#Repeat relevant parts for the training data.
traindata <- read.table("./UCI HAR Dataset/train/X_train.txt",col.names=features[,2])
trainSubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names=c("Subject"))
trainActivities <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names=c("Activity"))

#cleanup the columns we don't need
traindata <- traindata[,featurestoinclude]
traindata$Subject <- trainSubjects$Subject
traindata$Activity <- trainActivities$Activity

#Now that we have two clean datasets, merge them together
trackerdata = merge(testdata, traindata, all=TRUE)

#We still need to update the activity feature to include the name of the activity, not just the code
trackerdata$Activity <- factor(trackerdata$Activity, labels=c("WALKING","WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

#write out the tidy trackerdata
write.table(trackerdata, file="./trackerdata.txt", row.names=FALSE)

#and finally, to summarise
summarydata <-aggregate(.~ Subject + Activity, data=trackerdata, mean)

write.table(summarydata, file="./summarydata.txt", row.names=FALSE)
