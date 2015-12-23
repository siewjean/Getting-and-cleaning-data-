
###download project data from the given url
a<- getwd()
fullFilename<- paste(a, "/","human.zip",sep="")

###download and unzip data
fileUrl<- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = fullFilename)
unzip(fullFilename)

###read training sets
x_train<-read.table("UCI HAR Dataset/train/x_train.txt")
###read test sets
x_test<-read.table("UCI HAR Dataset/test/x_test.txt")

###read test subjects
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
###read training subjects
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
data_subject<-rbind(subject_train,subject_test)

###read training labels 
y_train<-read.table("UCI HAR Dataset/train/y_train.txt")
###read test labels 
y_test<-read.table("UCI HAR Dataset/test/y_test.txt")
data_y<-rbind(y_train,y_test)
data_y[data_y==1] ="WALKING"
data_y[data_y==2] ="WALKING UPSTAIRS"
data_y[data_y==3] ="WALKING DOWNSTAIRS"
data_y[data_y==4] ="SITTING"
data_y[data_y==5] ="STANDING"
data_y[data_y==6] ="LAYING"

### Merges the training and the test sets to create one data set 
### includes subject and activities
all_data<-cbind(data_x,data_subject,data_y)

###Appropriately labels the data set with descriptive variable names
features<-read.table("UCI HAR Dataset/features.txt")
var_names<-as.character(features[,2])
colnames(all_data)<-c(var_names,"Subject","Activity")

### Extracts only the measurements on the mean and standard deviation for each measurement
subset<-grep("mean|std", var_names)
avg_all_data<-all_data[,c(subset,562,563)]
write.table(avg_all_data,"avg_all_data.txt",sep="\t")

### Independent tidy data set with the average of each variable for each activity and each subject
Subject<-as.factor(avg_all_data$Subject)
Activity<-as.factor(avg_all_data$Activity)
tidy_data<-aggregate(avg_all_data,by=list(Subject,Activity),mean)
tidy_data[,82]<-NULL
tidy_data[,83]<-NULL
colnames(tidy_data)[1]<-c("Subject")
colnames(tidy_data)[2]<-c("Activity")
print(tidy_data[1:10,1:10])
write.table(tidy_data,"tidy.txt",sep="\t",row.name=FALSE)
