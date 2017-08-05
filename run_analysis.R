setwd("C:/Users/shivam giri/Downloads/UCI HAR Dataset")

features<-read.table("features.txt")
activity_type<-read.table("activity_labels.txt")


test_X_tests<-read.table("test/X_test.txt")
test_Y_tests<-read.table("test/y_test.txt")

train_X_tests<-read.table("train/X_train.txt")
train_Y_tests<-read.table("train/y_train.txt")

subject_train<-read.table("train/subject_train.txt")
subject_test<-read.table("test/subject_test.txt")


colnames(activity_type)<-c("Activity Id","Activity Type")

colnames(subject_train)<-"Subject Id"
colnames(train_X_tests)<-as.character(features[,2])
colnames(train_Y_tests)<-"Activity Id"


colnames(subject_test)<-"Subject Id"
colnames(test_X_tests)<-as.character(features[,2])
colnames(test_Y_tests)<-"Activity Id"


train_data<-cbind(subject_train,train_Y_tests,train_X_tests)
test_data<-cbind(subject_test,test_Y_tests,test_X_tests)

data_combined<-rbind(test_data,train_data)


selected<-features[grep("mean\\(\\)|std\\(\\)",features[,2]),]

mean_sd_data<-data_combined[,selected[,2]]
mean_sd_data<-cbind(data_combined[,1:2],mean_sd_data)

mean_sd_data$'Activity Id'<-factor(mean_sd_data$`Activity Id`,levels = activity_type[,1],labels = activity_type[,2])



colNames<-colnames(mean_sd_data)
for(i in 1:length(colNames)){
  colNames[i] = gsub("\\()","",colNames[i])
  colNames[i] = gsub("^(t)","Time",colNames[i])
  colNames[i] = gsub("^(f)","freq",colNames[i])
  colNames[i] = gsub("-mean","Mean",colNames[i])
  colNames[i] = gsub("-std","StdDev",colNames[i])
  colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
  colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
  colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
  colNames[i] = gsub("AccMag","AccMagnitude",colNames[i])
  colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
}
colnames(mean_sd_data)<-colNames

library(data.table)

data_without_ativitytype<-mean_sd_data[,-c(1,2)]
tidy_data<-aggregate(data_without_ativitytype,by=list(Activity_ID=mean_sd_data$`Activity Id`,Subject_ID=mean_sd_data$`Subject Id`),mean)

write.table(tidy_data, './tidyData.txt',row.names=FALSE,sep='\t')


